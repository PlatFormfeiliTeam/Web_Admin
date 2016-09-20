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
    public partial class AttachList : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {           
            string action = Request["action"];
            int totalProperty = 0;
            string json = string.Empty; string sql = ""; DataTable dt;
            
            switch (action)
            {
                case "loadattach":
                    IsoDateTimeConverter iso = new IsoDateTimeConverter();//序列化JSON对象时,日期的处理格式
                    iso.DateTimeFormat = "yyyy-MM-dd HH:mm:ss";

                    string where = "";
                    //if (!string.IsNullOrEmpty(Request["NAME"]))
                    //{
                    //    where += " and NAME like '%" + Request["NAME"] + "%'";
                    //}
                    //if (!string.IsNullOrEmpty(Request["REALNAME"]))
                    //{
                    //    where += " and REALNAME like '%" + Request["REALNAME"] + "%'";
                    //}

                    sql = @"SELECT * FROM List_Attachment where ISUPLOAD='1' and ORDERCODE is not null " + where;

                    sql = Extension.GetPageSql(sql, "ORDERCODE", "desc", ref totalProperty, Convert.ToInt32(Request["start"]), Convert.ToInt32(Request["limit"]));
                    dt = DBMgr.GetDataTable(sql);
                    json = JsonConvert.SerializeObject(dt, iso);
                    Response.Write("{rows:" + json + ",total:" + totalProperty + "}");
                    Response.End();
                    break;
               
            }
        }
    }
}