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

            this.lbl_msg1.Text = "";
            this.lbl_msg2.Text = "";
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            List<Declare> statuslogList = pageLoad();
            GridView1.DataSource = statuslogList;
            GridView1.PageIndex = 0;
            GridView1.DataBind();
            if (statuslogList.Count <= 0)
            {
                this.lbl_msg1.Text = "<p><font color='red'>No Data!</font></p>";
            }
            else
            {
                List<Declare> fenKeyStatuslogList = pageLoadFenKey();

                GridView2.DataSource = fenKeyStatuslogList;
                GridView2.PageIndex = 0;
                GridView2.DataBind();
                if (fenKeyStatuslogList != null)
                {
                    this.lbl_msg2.Text = "<h4 style=\" color:blue;\">分KEY:" + TxtKey.Text.ToString() + "</h4>";
                }
                else
                {
                    if (TxtKey.Text.Trim() != "")
                    {
                        this.lbl_msg2.Text = "<h4 style=\" color:blue;\">分KEY:" + TxtKey.Text.ToString() + "</h4><p><font color='red'>No Data!</font></p>";
                    }
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

            if (fenKeyStatuslogList != null)
            {
                this.lbl_msg2.Text = "<h4 style=\" color:blue;\">分KEY:" + TxtKey.Text.ToString() + "</h4>";
            }
            else
            {
                if (TxtKey.Text.Trim() != "")
                {
                    this.lbl_msg2.Text = "<h4 style=\" color:blue;\">分KEY:" + TxtKey.Text.ToString() + "</h4><p><font color='red'>No Data!</font></p>";
                }
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
               
                long len = db.ListLength("declareall");
                long tempi = 200; long i = 0;

                for (; i < len; i = i + tempi)
                {

                    if ((i + tempi) >= len) { tempi = (len - i); }

                    RedisValue[] StatusList = db.ListRange("declareall", i, i + (tempi - 1));
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

                    tempi = 200;
                }

                /*
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
                */
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
                long len = db.ListLength(key);
                long tempi = 200; long i = 0;

                for (; i < len; i = i + tempi)
                {

                    if ((i + tempi) >= len) { tempi = (len - i); }

                    RedisValue[] StatusList = db.ListRange(key, i, i + (tempi - 1));
                    StatusList.Where<RedisValue>(st =>
                    {
                        Declare Declare_temp = JsonConvert.DeserializeObject<Declare>(st.ToString());
                        DeclareList.Add(Declare_temp);
                        return true;
                    }).ToList<RedisValue>();

                    tempi = 200;
                }
                /*
                RedisValue[] StatusList = db.ListRange(key);
                StatusList.Where<RedisValue>(st =>
                {

                    Declare Declare_temp = JsonConvert.DeserializeObject<Declare>(st.ToString());


                    DeclareList.Add(Declare_temp);
                    return true;
                }).ToList<RedisValue>();*/

                return DeclareList;

            }
            return null;
        }
    }
}