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
    public partial class UserList : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string sql = ""; int totalProperty = 0; string json = string.Empty;
            string action = Request["action"]; string id = Request["id"]; string name = Request["name"];            
            
            DataTable dt;
            switch (action)
            {
                case "loadchildaccount":
                    sql = @"SELECT * FROM SYS_USER WHERE PARENTID = " + id + " order by CREATETIME ASC";
                    dt = DBMgr.GetDataTable(sql);
                    json = JsonConvert.SerializeObject(dt);
                    Response.Write("{innerrows:" + json + "}");
                    Response.End();
                    break;
                case "loaduser":
                    IsoDateTimeConverter iso = new IsoDateTimeConverter();//序列化JSON对象时,日期的处理格式
                    iso.DateTimeFormat = "yyyy-MM-dd HH:mm:ss";
                    string groupid = Request["groupid"];
                    string where = "";
                    if (!string.IsNullOrEmpty(Request["NAME"]))
                    {
                        where += " and NAME like '%" + Request["NAME"] + "%'";
                    }
                    if (!string.IsNullOrEmpty(Request["REALNAME"]))
                    {
                        where += " and REALNAME like '%" + Request["REALNAME"] + "%'";
                    }
                    //客户2016-4-25提出只显示外部账号
                    if (string.IsNullOrEmpty(groupid) || groupid == "-1")
                    {
                        sql = @"SELECT * FROM SYS_USER WHERE TYPE = 1 AND  PARENTID IS NULL " + where;
                    }
                    else
                    {
                        sql = @"SELECT * FROM SYS_USER WHERE TYPE = 1 AND  PARENTID IS NULL AND POSITIONID = '" + groupid + "'" + where;
                    }
                    sql = Extension.GetPageSql(sql, "CREATETIME", "desc", ref totalProperty, Convert.ToInt32(Request["start"]), Convert.ToInt32(Request["limit"]));
                    json = JsonConvert.SerializeObject(DBMgr.GetDataTable(sql), iso);
                    Response.Write("{rows:" + json + ",total:" + totalProperty + "}");
                    Response.End();
                    break;
                case "inipsd":                    
                    sql = "update sys_user set PASSWORD='{0}' where id='{1}'";
                    sql = string.Format(sql, Extension.ToSHA1(name), id);
                    Response.Write(DBMgr.ExecuteNonQuery(sql));
                    Response.End();
                    break;
            }
        }
    }
}