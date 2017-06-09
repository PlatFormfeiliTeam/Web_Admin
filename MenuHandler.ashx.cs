using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using Web_Admin.Common;

namespace Web_Admin
{
    /// <summary>
    /// MenuHandler 的摘要说明
    /// </summary>
    public class MenuHandler : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            context.Response.Write(GetMenu());
        }

        public string GetMenu()
        {
            FormsIdentity identity = HttpContext.Current.User.Identity as FormsIdentity;
            if (identity == null)
            {
                return "";
            }
            string userName = identity.Name;

            string result = "";
            if (string.IsNullOrEmpty(userName))
            {

            }
            else
            {
                JObject json_user = Extension.Get_UserInfo(userName);

                string sql = @"select MODULEID,NAME,PARENTID,URL,SORTINDEX,IsLeaf,ICON from sysmodule t 
                where t.parentid='91a0657f-1939-4528-80aa-91b202a593ac' and t.MODULEID IN (select MODULEID FROM sys_moduleuser_back where userid='{0}')
                order by sortindex";
                sql = string.Format(sql, json_user.GetValue("ID"));

                DataTable dt1 = DBMgr.GetDataTable(sql);
                for (int i = 0; i < dt1.Rows.Count; i++)
                {
                    string icon = string.Empty;
                    if (!string.IsNullOrEmpty(dt1.Rows[i]["ICON"] + ""))
                    {
                        icon = "<span style='font-size:14px;'><i class=\"icon iconfont\">&#x" + dt1.Rows[i]["ICON"] + ";</i></span>&nbsp;";
                    }
                    result += "<li><a>" + icon + dt1.Rows[i]["NAME"] + "</a>";

                    sql = @"select MODULEID,NAME,PARENTID,URL,SORTINDEX,IsLeaf,ICON from sysmodule t where t.parentid='{0}'
                    and t.MODULEID IN (select MODULEID FROM sys_moduleuser_back where userid='{1}') order by sortindex";
                    sql = string.Format(sql, dt1.Rows[i]["MODULEID"], json_user.GetValue("ID"));

                    DataTable dt2 = DBMgr.GetDataTable(sql);
                    if (dt2.Rows.Count > 0)
                    {
                        result += "<ul>";
                        for (int j = 0; j < dt2.Rows.Count; j++)
                        {
                            icon = string.Empty;
                            if (!string.IsNullOrEmpty(dt2.Rows[j]["ICON"] + ""))
                            {
                                icon = "<span style='font-size:14px;'><i class=\"icon iconfont\">&#x" + dt2.Rows[j]["ICON"] + ";</i></span>&nbsp;";
                            }
                            if (string.IsNullOrEmpty(dt2.Rows[j]["URL"] + ""))
                            {
                                result += "<li><a>" + icon + dt2.Rows[j]["NAME"] + "</a>";
                            }
                            else
                            {
                                result += "<li><a href=\"" + icon + dt2.Rows[j]["URL"] + "\">" + dt2.Rows[j]["NAME"] + "</a>";
                            }
                            sql = @"select MODULEID,NAME,PARENTID,URL,SORTINDEX,IsLeaf,ICON from sysmodule t where t.parentid='{0}' 
                            and t.MODULEID IN (select MODULEID FROM sys_moduleuser_back where userid='{1}') order by sortindex";
                            sql = string.Format(sql, dt2.Rows[j]["MODULEID"], json_user.GetValue("ID"));
                            
                            DataTable dt3 = DBMgr.GetDataTable(sql);
                            if (dt3.Rows.Count > 0)
                            {
                                result += "<ul>";
                                for (int k = 0; k < dt3.Rows.Count; k++)
                                {
                                    icon = string.Empty;
                                    if (!string.IsNullOrEmpty(dt3.Rows[k]["ICON"] + ""))
                                    {
                                        icon = "<span style='font-size:14px;'><i class=\"icon iconfont\">&#x" + dt3.Rows[k]["ICON"] + ";</i></span>&nbsp;";
                                    }
                                    if (string.IsNullOrEmpty(dt3.Rows[k]["URL"] + ""))
                                    {
                                        result += "<li><a>" + icon + dt3.Rows[k]["NAME"] + "</a></li>";
                                    }
                                    else
                                    {
                                        result += "<li><a href=\"" + dt3.Rows[k]["URL"] + "\">" + icon + dt3.Rows[k]["NAME"] + "</a></li>";
                                    }
                                }
                                result += "</ul></li>";
                            }
                            else
                            {
                                result += "</li>";
                            }
                        }
                        result += "</ul></li>";
                    }
                    else
                    {
                        result += "</li>";
                    }
                }
            }
            return result;
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}