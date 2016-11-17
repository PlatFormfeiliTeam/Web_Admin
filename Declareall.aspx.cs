using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Web_Admin.model;
using StackExchange.Redis;
using Web_Admin.Common;
using Newtonsoft.Json;

namespace Web_Admin
{
    public partial class Declareall : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
       
            this.Label1.Text = "";
            this.GridView1.AllowPaging = true;
            this.GridView1.PageSize = 15;
            this.GridView2.AllowPaging = true;
            this.GridView2.PageSize = 15;
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            
            GridView1.DataSource = pageLoad();
            GridView1.PageIndex = 0;
            GridView1.DataBind();
            List<Declare> fenKeyStatuslogList = pageLoadFenKey();

            GridView2.DataSource = fenKeyStatuslogList;
            GridView2.PageIndex = 0;
            GridView2.DataBind();
            if (fenKeyStatuslogList != null)
            {
                this.Label1.Text = "分KEY:" + TxtKey.Text.ToString();
            }
            else
            {
                if (TxtKey.Text.Trim() != "")
                {
                    this.Label1.Text = "分KEY:" + TxtKey.Text.ToString() + "______NO DATA!";
                }
            }
        }

        protected void GridView1_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            this.GridView1.DataSource = pageLoad();
            this.GridView1.PageIndex = e.NewPageIndex;
            this.GridView1.DataBind();
        }

        protected void GridView2_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            List<Declare> fenKeyStatuslogList = pageLoadFenKey();
            if (fenKeyStatuslogList != null)
            {
                GridView2.DataSource = fenKeyStatuslogList;
                GridView2.PageIndex = e.NewPageIndex;
                GridView2.DataBind();


            }
        }


        public List<Declare> pageLoad()
        {

            string cusno = TxtCusno.Text.ToString();
            string key = TxtKey.Text.ToString();
            IDatabase db = SeRedis.redis.GetDatabase();
            List<Declare> DeclareList = new List<Declare>();

            if (db.KeyExists("declareall"))
            {
                RedisValue[] StatusList = db.ListRange("declareall");
                //IEnumerable<RedisValue> ie = StatusList.Where<RedisValue>(st =>
                StatusList.Where<RedisValue>(st =>
                {

                    Declare Declare_temp = JsonConvert.DeserializeObject<Declare>(st.ToString());

                    if (Declare_temp.CUSNO.Contains(cusno) && Declare_temp.DIVIDEREDISKEY.Contains(key))
                    {
                        DeclareList.Add(Declare_temp);
                        return true;
                    }


                    return false;
                }).ToList<RedisValue>();

                //RedisValue[] statusArray = ie.ToArray<RedisValue>();
                //string jons = string.Join(",", statusArray);
                //JavaScriptSerializer Serializer = new JavaScriptSerializer();            
                //List<Declare> objs = Serializer.Deserialize<List<Declare>>("["+jons+"]");

                return DeclareList;

            }
            return null;
        }
        public List<Declare> pageLoadFenKey()
        {

            string key = TxtKey.Text.ToString();
            IDatabase db = SeRedis.redis.GetDatabase();
            List<Declare> DeclareList = new List<Declare>();

            if (key != string.Empty && db.KeyExists(key))
            {
                RedisValue[] StatusList = db.ListRange(key);
                StatusList.Where<RedisValue>(st =>
                {

                    Declare Declare_temp = JsonConvert.DeserializeObject<Declare>(st.ToString());


                    DeclareList.Add(Declare_temp);
                    return true;
                }).ToList<RedisValue>();
                return DeclareList;

            }
            return null;
        }
    }
}