using Newtonsoft.Json;
using StackExchange.Redis;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Web_Admin.Common;
using Web_Admin.model;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls.WebParts;

namespace Web_Admin
{
    public partial class Statuslogall : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
           this.GridView1.AllowPaging=true;
           this.GridView1.PageSize = 15;
           this.GridView2.AllowPaging = true;
           this.GridView2.PageSize = 15;
           //this.GridView1.PagerSettings.Mode = PagerButtons.NumericFirstLast;
           //this.GridView1.PagerSettings.Position = PagerPosition.Bottom;
           


        }

        protected void BtnQuery_Click(object sender, EventArgs e)
        {

            
            GridView1.DataSource = pageLoad();
            GridView1.PageIndex = 0;
            GridView1.DataBind();
            List<Statuslog> fenKeyStatuslogList = pageLoadFenKey();
            
                GridView2.DataSource = fenKeyStatuslogList;
                GridView2.PageIndex = 0;
                GridView2.DataBind();
                if (fenKeyStatuslogList != null)
                {
                    this.Label1.Text = "分KEY:" + TxtKey.Text.ToString();
                }
                else
                {
                    this.Label1.Text = "";
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
            List<Statuslog> fenKeyStatuslogList = pageLoadFenKey();
            if (fenKeyStatuslogList != null)
            {
                GridView2.DataSource = fenKeyStatuslogList;
                GridView2.PageIndex = e.NewPageIndex;
                GridView2.DataBind();
                

            }
        }

        public List<Statuslog> pageLoad()
        {

            string cusno = TxtCusno.Text.ToString();
            string key = TxtKey.Text.ToString();
            IDatabase db = SeRedis.redis.GetDatabase();
            List<Statuslog> statuslogList = new List<Statuslog>();

            if (db.KeyExists("statuslogall"))
            {
                RedisValue[] StatusList = db.ListRange("statuslogall");
                //IEnumerable<RedisValue> ie = StatusList.Where<RedisValue>(st =>
                StatusList.Where<RedisValue>(st =>
                {

                    Statuslog statuslog_temp = JsonConvert.DeserializeObject<Statuslog>(st.ToString());

                    if (statuslog_temp.CUSNO.Contains(cusno) && statuslog_temp.DIVIDEREDISKEY.Contains(key))
                    {
                        statuslogList.Add(statuslog_temp);
                        return true;
                    }


                    return false;
                }).ToList<RedisValue>();

                //RedisValue[] statusArray = ie.ToArray<RedisValue>();
                //string jons = string.Join(",", statusArray);
                //JavaScriptSerializer Serializer = new JavaScriptSerializer();            
                //List<Statuslog> objs = Serializer.Deserialize<List<Statuslog>>("["+jons+"]");

                return statuslogList;

            }
            return null;
        }
        public List<Statuslog> pageLoadFenKey()
        {

            string key = TxtKey.Text.ToString();
            IDatabase db = SeRedis.redis.GetDatabase();
            List<Statuslog> statuslogList = new List<Statuslog>();

            if (key!=string.Empty&&db.KeyExists(key))
            {
                RedisValue[] StatusList = db.ListRange(key);
                StatusList.Where<RedisValue>(st =>
                {

                    Statuslog statuslog_temp = JsonConvert.DeserializeObject<Statuslog>(st.ToString());

            
                        statuslogList.Add(statuslog_temp);
                        return true;
                }).ToList<RedisValue>();
                return statuslogList;

            }
            return null;
        }

    }

}