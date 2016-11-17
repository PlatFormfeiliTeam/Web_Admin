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
    public partial class Inspectionall : System.Web.UI.Page
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
            List<Inspection> fenKeyStatuslogList = pageLoadFenKey();

            GridView2.DataSource = fenKeyStatuslogList;
            GridView2.PageIndex = 0;
            GridView2.DataBind();
            if (fenKeyStatuslogList != null)
            {
                this.Label1.Text = "分KEY:" + TxtKey.Text.ToString();
            }
            else
            {
                if(TxtKey.Text.Trim()!="")
                {
                    this.Label1.Text = "分KEY:" + TxtKey.Text.ToString()+"______NO DATA!";
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
            List<Inspection> fenKeyStatuslogList = pageLoadFenKey();
            if (fenKeyStatuslogList != null)
            {
                GridView2.DataSource = fenKeyStatuslogList;
                GridView2.PageIndex = e.NewPageIndex;
                GridView2.DataBind();


            }
        }


        public List<Inspection> pageLoad()
        {

            string cusno = TxtCusno.Text.ToString();
            string key = TxtKey.Text.ToString();
            IDatabase db = SeRedis.redis.GetDatabase();
            List<Inspection> InspectionList = new List<Inspection>();

            if (db.KeyExists("inspectionall"))
            {
                RedisValue[] StatusList = db.ListRange("inspectionall");
                //IEnumerable<RedisValue> ie = StatusList.Where<RedisValue>(st =>
                StatusList.Where<RedisValue>(st =>
                {

                    Inspection Inspection_temp = JsonConvert.DeserializeObject<Inspection>(st.ToString());

                    if (Inspection_temp.CUSNO.Contains(cusno) && Inspection_temp.DIVIDEREDISKEY.Contains(key))
                    {
                        InspectionList.Add(Inspection_temp);
                        return true;
                    }


                    return false;
                }).ToList<RedisValue>();

                //RedisValue[] statusArray = ie.ToArray<RedisValue>();
                //string jons = string.Join(",", statusArray);
                //JavaScriptSerializer Serializer = new JavaScriptSerializer();            
                //List<Inspection> objs = Serializer.Deserialize<List<Inspection>>("["+jons+"]");

                return InspectionList;

            }
            return null;
        }
        public List<Inspection> pageLoadFenKey()
        {

            string key = TxtKey.Text.ToString();
            IDatabase db = SeRedis.redis.GetDatabase();
            List<Inspection> InspectionList = new List<Inspection>();

            if (key != string.Empty && db.KeyExists(key))
            {
                RedisValue[] StatusList = db.ListRange(key);
                StatusList.Where<RedisValue>(st =>
                {

                    Inspection Inspection_temp = JsonConvert.DeserializeObject<Inspection>(st.ToString());


                    InspectionList.Add(Inspection_temp);
                    return true;
                }).ToList<RedisValue>();
                return InspectionList;

            }
            return null;
        }
    }
}