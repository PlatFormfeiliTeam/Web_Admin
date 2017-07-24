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
            string action = Request["action"];             
            switch (action)
            {
                case "loadchildaccount":
                    loadChildAccount();
                    break;
                case "loaduser":
                    loadUser();
                    break;
                case "inipsd":
                    inipsd();
                    break;
                case "enabled":
                    enabled();
                    break;
                case "delete":
                    deleteData();
                    break;
            }
        }
        /// <summary>
        /// 获取子节点
        /// </summary>
        private void loadChildAccount()
        {
            string id = Request["id"]; 
            string sql = @"SELECT * FROM SYS_USER WHERE PARENTID = " + id + " order by CREATETIME ASC";
            DataTable dt = DBMgr.GetDataTable(sql);
            string json = JsonConvert.SerializeObject(dt);
            Response.Write("{innerrows:" + json + "}");
            Response.End();
        }
        /// <summary>
        /// 查询
        /// </summary>
        private void loadUser()
        {
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
            if (!string.IsNullOrEmpty(Request["POSITIONID"]))
            {
                where += " and POSITIONID =" + Request["POSITIONID"];
            }
            //主账号
            string sql = @"SELECT * FROM SYS_USER WHERE TYPE = 1 " + where;
            int totalProperty = 0;
            sql = Extension.GetPageSql(sql, "CREATETIME", "desc", ref totalProperty, Convert.ToInt32(Request["start"]), Convert.ToInt32(Request["limit"]));
            string json = JsonConvert.SerializeObject(DBMgr.GetDataTable(sql), iso);
            Response.Write("{rows:" + json + ",total:" + totalProperty + "}");
            Response.End();
        }
        private void inipsd()
        {
            string id = Request["id"];
            string name = Request["name"];
            string sql = "update sys_user set points=0,PASSWORD='{0}' where id='{1}'";
            sql = string.Format(sql, Extension.ToSHA1(name), id);
            Response.Write(DBMgr.ExecuteNonQuery(sql));
            Response.End();
        }
        /// <summary>
        /// 启禁用
        /// </summary>
        private void enabled()
        {
            string id = Request["id"];
            string flag = Request["flag"];
            string sql = "update sys_user set enabled='{0}' where id='{1}'";
            string str = DBMgr.ExecuteNonQuery(string.Format(sql, flag, id)) > 0 ? "true" : "false";
            Response.Write("{\"success\":" + str + "}");
            Response.End();
        }

        /// <summary>
        /// 删除数据
        /// </summary>
        /// <param name="id"></param>
        private void deleteData()
        {
            string id = Request["ID"];
            string sql = "delete from sys_user where id='{0}'";
            string str = DBMgr.ExecuteNonQuery(string.Format(sql, id)) > 0 ? "true" : "false";
            Response.Write("{\"success\":" + str + "}");
            Response.End();
        }
    }
}