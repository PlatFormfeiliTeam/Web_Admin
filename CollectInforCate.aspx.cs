using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;
using System.Data;
using Web_Admin.Common;
using System.IO;
using Newtonsoft.Json.Linq;


namespace Web_Admin
{
    public partial class CollectInforCate : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string sql = "";
            string action = Request["action"];
            string id = string.Empty; string ICON = string.Empty; string formdata = "";
            DataTable dt; string json = "";
            string webpath = System.Web.HttpContext.Current.Request.PhysicalApplicationPath;

            switch (action)
            {
                case "select":
                    sql = @"select ID,NAME,DESCRIPTION,ICON,SORTINDEX from list_collect_infor_cate where ISINVALID=0 order by SORTINDEX";
                    dt = DBMgr.GetDataTable(sql);
                    json = JsonConvert.SerializeObject(dt);
                    Response.Write("{rows:" + json + "}");
                    Response.End();
                    break;
                case "loaddetail":
                    id = Request["id"];
                    sql = @"SELECT * FROM list_collect_infor WHERE rid_type = " + id + " order by CREATEDATE ASC";
                    dt = DBMgr.GetDataTable(sql);
                    json = JsonConvert.SerializeObject(dt);
                    Response.Write("{innerrows:" + json + "}");
                    Response.End();
                    break;
                case "delete":
                    id = Request["id"];ICON = Request["ICON"];
                    sql = @"delete from list_collect_infor where id in (" + id + ")";
                    DBMgr.ExecuteNonQuery(sql);

                    sql = @"delete from list_collect_infor_byuser where type='news' and rid in (" + id + ")";
                    DBMgr.ExecuteNonQuery(sql);

                    if (File.Exists(webpath + ICON)) { File.Delete(webpath + ICON); }

                    Response.Write("{success:true}");
                    Response.End();
                    break;
                case "save":
                    formdata = Request["formdata"];
                    JObject jo = (JObject)JsonConvert.DeserializeObject(formdata);
                    id = jo.Value<string>("ID"); string NAME = jo.Value<string>("NAME");
                    string DESCRIPTION = jo.Value<string>("DESCRIPTION");string SORTINDEX = jo.Value<string>("SORTINDEX");

                    sql = @"update list_collect_infor_cate set NAME='" + NAME + "',DESCRIPTION='" + DESCRIPTION + "',SORTINDEX='" + SORTINDEX + "' where id=" + id;
                    DBMgr.ExecuteNonQuery(sql);

                    sql = @"update list_collect_infor set TYPE='" + NAME + "' where rid_type=" + id;
                    DBMgr.ExecuteNonQuery(sql);

                    Response.Write("{success:true}");
                    Response.End();
                    break;
            }
        }
    }
}