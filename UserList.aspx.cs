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
            string sql = "";
            string action = Request["action"];
            string id = Request["id"];
            int totalProperty = 0;
            string json = string.Empty;
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
                case "delete":
                    sql = "update sys_customer set INTERFACECODE=null where id in (select customerid from sys_user where id='" + id + "')";
                    DBMgr.ExecuteNonQuery(sql);
                    sql = @"delete from sys_user where id ='{0}' or parentid='{0}'";
                    sql = string.Format(sql, id);
                    Response.Write(DBMgr.ExecuteNonQuery(sql));
                    Response.End();
                    break;
                case "inipsd":
                    sql = @"SELECT * FROM SYS_USER WHERE ID= " + id;
                    dt = DBMgr.GetDataTable(sql);
                    string name = dt.Rows[0]["NAME"] + "";
                    sql = "update sys_user set PASSWORD='{0}' where id='{1}'";
                    sql = string.Format(sql, name.ToSHA1(), id);
                    Response.Write(DBMgr.ExecuteNonQuery(sql));
                    Response.End();
                    break;
                case "import":
                    //                    dt = GetDataFromExcelByConn(false);
                    //                    string customerid = Request["CustomerId"];
                    //                    sql = "delete from user_rename_company where customerid='" + customerid + "'";
                    //                    Extension.ExecuteData(sql);
                    //                    int i = 0;
                    //                    foreach (DataRow dr in dt.Rows)
                    //                    {
                    //                        sql = "select ID from base_company where incode='" + dr[0] + "'";
                    //                        DataTable dt_tmp = Extension.GetData(sql);
                    //                        sql = "insert into user_rename_company (id,companyid,companyenname,companychname,createdate,customerid) values(user_rename_company_id.nextval,'{0}','{1}','{2}',sysdate,'{3}')";
                    //                        sql = string.Format(sql, dt_tmp.Rows[0]["ID"] + "", dr[2], dr[3], customerid);
                    //                        i++;
                    //                        Extension.ExecuteData(sql);
                    //                    }
                    //                    string RedisIp = ConfigurationManager.AppSettings["RedisServer"].ToString();
                    //                    string RedisPort = ConfigurationManager.AppSettings["RedisPort"].ToString();
                    //                    RedisClient redisClient = new RedisClient(RedisIp, Int32.Parse(RedisPort));//redis服务IP和端口
                    //                    sql = @"SELECT T.* FROM (
                    //                                                SELECT a.CUSTOMERID, a.companychname||'('||a.companyenname||')' NAME ,a.companyenname CODE,b.incode QUANCODE,b.name QUANNAME FROM USER_RENAME_COMPANY a 
                    //                                                left join BASE_COMPANY b 
                    //                                                on a.companyid = b.id 
                    //                                                where b.incode is not null and a.companyenname is not null) T 
                    //                                                WHERE  T.CUSTOMERID = '" + customerid + "'";
                    //                    qdo = ts.Query(sql, null, false, null);
                    //                    dt = qdo.dsk__BackingField.Tables[0];
                    //                    json = JsonConvert.SerializeObject(dt);
                    //                    redisClient.Set("jydw:" + customerid, json);
                    //                    Response.Write("{result:'" + i + "'}");
                    //                    Response.End();
                    break;
            }
        }
    }
}