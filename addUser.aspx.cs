using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
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
    public partial class addUser : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string id = Request["ID"];
            string action = Request["action"];

            switch (action)
            {
                case "initData":
                    initData(id);
                    break;
                case "customer":
                    getCustomer();
                    break;
                case "save":
                    JObject json = (JObject)JsonConvert.DeserializeObject(Request["formdata"]);
                    save(json, id);
                    break;
            }
        }

        private void initData(string id)
        {
            string sql = "select * from sys_user where id='" + id + "'";
            DataTable dt = DBMgr.GetDataTable(sql);
            string json = JsonConvert.SerializeObject(dt).Replace("[", "").Replace("]", "");
            if (json == "") { json = "{}"; }
            Response.Write(json);
            Response.End();
        }
        private void getCustomer()
        {
            string sql = "select id,name from cusdoc.sys_customer where enabled=1";
            DataTable dt = DBMgr.GetDataTable(sql);
            string json = JsonConvert.SerializeObject(dt);
            if (json == "") { json = "{}"; }
            Response.Write(json);
            Response.End();
        }

        private void save(JObject json, string id)
        {
            string str = "false";
            string enabled = "1", position = "0";
            if (json.Value<string>("ENABLED") == "否" || json.Value<string>("ENABLED") == "0")
                enabled = "1";
            if (json.Value<string>("POSITION") == "前端管理" || json.Value<string>("POSITION") == "1")
            {
                position = "1";
            }
            else if (json.Value<string>("POSITION") == "后台管理" || json.Value<string>("POSITION") == "2")
            {
                position = "2";
            }
            if (string.IsNullOrEmpty(id))
            {
                string sql = @"insert into sys_user(id,name,realname,telephone,mobilephone,email,customerid,companyids,positionid,enabled,remark,createtime,type,password) 
                values(sys_user_id.nextval,'{0}','{1}','{2}', '{3}','{4}',{5},{6},'{7}','{8}','{9}',sysdate,1,'{10}')";
                sql = string.Format(sql,
                    json.Value<string>("NAME"),
                    json.Value<string>("REALNAME"),
                    json.Value<string>("TELEPHONE"),
                    json.Value<string>("MOBILEPHONE"),
                    json.Value<string>("EMAIL"),
                    json.Value<string>("CUSTOMERID"),
                    "(select NAME from cusdoc.sys_customer where code='" + json.Value<string>("CUSTOMERID") + "')",
                    position,
                    enabled,
                    json.Value<string>("REMARK"),
                    "000000".ToSHA1());
                int i = DBMgr.ExecuteNonQuery(sql);
                str = i > 0 ? "true" : "false";
            }
            else
            {
                string sql = @"update sys_user set name='{0}',realname='{1}',telephone='{2}',mobilephone='{3}',email='{4}',customerid={5},companyids='{6}',
            positionid='{7}',enabled='{8}',remark='{9}' where id={10}";
                sql = string.Format(sql,
                    json.Value<string>("NAME"),
                    json.Value<string>("REALNAME"),
                    json.Value<string>("TELEPHONE"),
                    json.Value<string>("MOBILEPHONE"),
                    json.Value<string>("EMAIL"),
                    "(select id from cusdoc.sys_customer where code='" + json.Value<string>("CUSTOMERNAME") + "')",
                    json.Value<string>("CUSTOMERNAME"),
                    position,
                    enabled,
                    json.Value<string>("REMARK"),
                    id);
                int i = DBMgr.ExecuteNonQuery(sql);
                str = i > 0 ? "true" : "false";
            }
            string response = "{\"success\":" + str + "}";
            Response.Write(response);
            Response.End();
        }
    }
}