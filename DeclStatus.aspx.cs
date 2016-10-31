using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using StackExchange.Redis;
using Web_Admin.Common;
using Newtonsoft.Json.Converters;
using Newtonsoft.Json;

namespace Web_Admin
{
    public partial class DeclStatus : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            IDatabase db = SeRedis.redis.GetDatabase();
            string action = Request["action"];
            string cuno = Request["cusno"] == null ? "" : Request["cusno"].ToString();
            long totalProperty = 0;
            string json = string.Empty; string sql = ""; DataTable dt;
            switch (action)
            {
                case "loadredisclareStatus":
                    IsoDateTimeConverter iso = new IsoDateTimeConverter();//序列化JSON对象时,日期的处理格式
                    iso.DateTimeFormat = "yyyy-MM-dd HH:mm:ss";

                    if (db.KeyExists("statuslog"))
                    {
                        RedisValue[] jsonlist = db.ListRange("statuslog");
                        if (cuno != "")
                        {
                            IEnumerable<RedisValue> IE_redis = jsonlist.Where<RedisValue>(RV => RV.ToString().Contains(cuno));
                            jsonlist = IE_redis.ToArray<RedisValue>();
                        }
                        totalProperty = jsonlist.LongLength;
                        long start = Convert.ToInt64(Request["start"]);
                        long end = Convert.ToInt64(Request["start"]) + Convert.ToInt64(Request["limit"]);
                        end = totalProperty >= end ? end : totalProperty;

                        for (long i = start; i < end; i++)
                        {  
                            json += jsonlist[i];
                            if (i < end - 1) { json += ","; }
                        }
                        json = "[" + json + "]";
                    }
                    else
                    {
                        json = "[]";
                    }
                    Response.Write("{rows:" + json + ",total:" + totalProperty + "}");
                    Response.End();
                    break;
                case "WriteRedisDeclStatus":
                    string ordercode = string.Empty;
                    string statuscode_tmp = string.Empty;
                    if (Request["ordercode"]!=null)
                    {
                    ordercode = Request["ordercode"].Trim();
                    }
                    if (Request["statuscode"] != null)
                    {
                        statuscode_tmp = Request["statuscode"].Trim();
                    }
                    string where = string.Empty;
                    if (ordercode!=string.Empty)
                    {

                        where = "and code='" + ordercode + "'";
                    }
                    try
                    {
                        //sql = @"select sysdate,cusno,declstatus from list_order where 1=1" + where;
                        sql = @"select * from list_order where 1=1" + where;
                        dt = DBMgr.GetDataTable(sql);
                        if (dt.Rows.Count > 0)
                        {
                            
                            foreach (DataRow dr in dt.Rows)
                            {
                                string statustime = "", cusno = "", statusname = "",statuscode = "";
                                if (statuscode_tmp != string.Empty)
                                {
                                    statuscode = statuscode_tmp;
                                }
                                else
                                {
                                    statuscode = dr["DECLSTATUS"].ToString() == "" ? "0" : dr[2].ToString();
                                }
                               // statustime = dr[0].ToString(); 
                                cusno = dr["CUSNO"].ToString();




                                if (statuscode == "15") { statusname = "关务接单"; statustime = dr["ACCEPTTIME"].ToString(); }
                                if (statuscode == "80") { statusname = "单证输机"; statustime = dr["REPSTARTTIME"].ToString(); }
                                if (statuscode == "110") { statusname = "提前报关单发送"; statustime = dr["RELATEDTIME"].ToString(); }
                                if (statuscode =="20" ) { statusname = "单证制单"; statustime=dr["MOSTARTTIME"].ToString();}
                                if (statuscode == "40") { statusname = "单证审单"; statustime = dr["COSTARTTIME"].ToString(); }
                                if (statuscode == "100") { statusname = "报关单发送"; statustime = dr["PREENDTIME"].ToString(); }



                                json = "{\"TYPE\":\"declare\",\"ORDERCODE\":\"" + cusno + "\",\"STATUSCODE\":" + statuscode + ",\"STATUSNAME\":\"" + statusname + "\",\"STATUSTIME\":\"" + statustime + "\"}";
                                db.ListRightPush("statuslog", json);
                            }
                        }


                        Response.Write("{success:true}");
                    }
                    catch
                    {
                        Response.Write("{success:false}");
                    }
                    Response.End();
                    break;
                case "ClearRedisDeclStatus":
                    if (db.KeyExists("statuslog")) { db.KeyDelete("statuslog"); }
                    Response.Write("{success:true}");
                    Response.End();
                    break;

            }   
        }
    }
}