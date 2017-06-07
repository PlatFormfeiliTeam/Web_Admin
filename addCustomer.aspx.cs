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
    public partial class addCustomer : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string id = Request["ID"];
            string action = Request["action"];
            
            switch(action)
            {
                case "initData":
                    initData(id);
                    break;
                case "save":
                    JObject json = (JObject)JsonConvert.DeserializeObject(Request["formdata"]);
                    save(json, id);
                    break;
            }
           
            
        }
        private void initData(string id)
        {
            string sql = "select * from cusdoc.sys_customer where id='" + id + "'";
            DataTable dt = DBMgr.GetDataTable(sql);
            string json = JsonConvert.SerializeObject(dt);
            Response.Write(json.Replace("[", "").Replace("]", ""));
            Response.End();
        }

        private void save(JObject json, string id)
        {
            string str = "false";
            string enabled = "0";
            if (json.Value<string>("ENABLED") == "是" || json.Value<string>("ENABLED") == "1")
                enabled = "1";
            if(string.IsNullOrEmpty(id))
            {
                string sql = @"insert into cusdoc.sys_customer(id,code,name,chineseabbreviation,chineseaddress,hscode,ciqcode,englishname,englishaddress,
            iscustomer,isshipper,iscompany,logicauditflag,docservicecompany,enabled,remark) values(cusdoc.sys_customer_id.nextval,'{0}','{1}','{2}',
            '{3}','{4}','{5}','{6}','{7}','{8}','{9}','{10}','{11}','{12}','{13}','{14}')";
                sql = string.Format(sql, json.Value<string>("CODE"), json.Value<string>("NAME"), json.Value<string>("CHINESEABBREVIATION"), json.Value<string>("CHINESEADDRESS"),
                    json.Value<string>("HSCODE"), json.Value<string>("CIQCODE"), json.Value<string>("ENGLISHNAME"), json.Value<string>("ENGLISHADDRESS"),
                    json.Value<string>("ISCUSTOMER") == "on" ? "1" : "0", json.Value<string>("ISSHIPPER") == "on" ? "1" : "0", json.Value<string>("ISCOMPANY") == "on" ? "1" : "0",
                    json.Value<string>("LOGICAUDITFLAG") == "on" ? "1" : "0", json.Value<string>("DOCSERVICECOMPANY") == "on" ? "1" : "0", enabled,
                    json.Value<string>("REMARK"));
                int i = DBMgr.ExecuteNonQuery(sql);
                str = i > 0 ? "true" : "false";
            }
            else
            {
                string sql = @"update cusdoc.sys_customer set code='{0}',name='{1}',chineseabbreviation='{2}',chineseaddress='{3}',hscode='{4}',ciqcode='{5}',englishname='{6}',
            englishaddress='{7}',iscustomer='{8}',isshipper='{9}',iscompany='{10}',logicauditflag='{11}',docservicecompany='{12}',enabled='{13}',remark='{14}' where id={15}";
                sql = string.Format(sql, json.Value<string>("CODE"), json.Value<string>("NAME"), json.Value<string>("CHINESEABBREVIATION"), json.Value<string>("CHINESEADDRESS"),
                    json.Value<string>("HSCODE"), json.Value<string>("CIQCODE"), json.Value<string>("ENGLISHNAME"), json.Value<string>("ENGLISHADDRESS"),
                    json.Value<string>("ISCUSTOMER") == "on" ? "1" : "0", json.Value<string>("ISSHIPPER") == "on" ? "1" : "0", json.Value<string>("ISCOMPANY") == "on" ? "1" : "0",
                    json.Value<string>("LOGICAUDITFLAG") == "on" ? "1" : "0", json.Value<string>("DOCSERVICECOMPANY") == "on" ? "1" : "0", enabled,
                    json.Value<string>("REMARK"), id);
                int i = DBMgr.ExecuteNonQuery(sql);
                str = i > 0 ? "true" : "false";
            }
            string response = "{\"success\":" + str + "}";
            Response.Write(response);
            Response.End();
        }
    }
}