using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Web_Admin.Common;

namespace Web_Admin
{
    public partial class NoticeList : System.Web.UI.Page
    {
        
        protected void Page_Load(object sender, EventArgs e)
        {
            int totalProperty = 0; DataTable dt;
            string json = string.Empty; string sql = "";

            string action = Request["action"]; string id = Request["id"];
            switch (action)
            {
                case "load":
                    IsoDateTimeConverter iso = new IsoDateTimeConverter();//序列化JSON对象时,日期的处理格式
                    iso.DateTimeFormat = "yyyy-MM-dd HH:mm:ss";

                    string where = "";
                    if (!string.IsNullOrEmpty(Request["TITLE"]))
                    {
                        where += " and TITLE like '%" + Request["TITLE"] + "%'";
                    }
                    sql = @"SELECT t.* FROM WEB_NOTICE t WHERE 1= 1 " + where;

                    sql = Extension.GetPageSql(sql, "UPDATETIME", "desc", ref totalProperty, Convert.ToInt32(Request["start"]), Convert.ToInt32(Request["limit"]));
                    dt = DBMgr.GetDataTable(sql);
                    json = JsonConvert.SerializeObject(dt, iso);
                    Response.Write("{rows:" + json + ",total:" + totalProperty + "}");
                    Response.End();
                    break;
                case "delete":
                    sql = @"delete from WEB_NOTICE where id in (" + id + ")";
                    int i = DBMgr.ExecuteNonQuery(sql);
                    if (i > 0)
                    {
                        Response.Write("{success:true}");
                    }
                    else
                    {
                        Response.Write("{success:false}");
                    }

                    Response.End();
                    break;
            }
        }
    }
}