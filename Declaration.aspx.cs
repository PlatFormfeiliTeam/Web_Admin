using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json.Converters;
using Web_Admin.Common;
using StackExchange.Redis;

namespace Web_Admin
{
    public partial class Declaration : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            IDatabase db = SeRedis.redis.GetDatabase();
            string action = Request["action"];
            long totalProperty = 0;
            string json = string.Empty; string sql = ""; DataTable dt;

            switch (action)
            {
                case "loadredisclare":
                    IsoDateTimeConverter iso = new IsoDateTimeConverter();//序列化JSON对象时,日期的处理格式
                    iso.DateTimeFormat = "yyyy-MM-dd HH:mm:ss";

                    if (db.KeyExists("redis_declare"))
                    {
                        RedisValue[] jsonlist = db.ListRange("redis_declare"); //db.StringGet("redis_declare");
                        totalProperty = jsonlist.LongLength;
                        long startweizhi = Convert.ToInt64(Request["start"]);
                        long endweizhi = Convert.ToInt64(Request["start"]) + Convert.ToInt64(Request["limit"]);
                        endweizhi = totalProperty >= endweizhi ? endweizhi : totalProperty;

                        for (long i = startweizhi; i < endweizhi; i++)
                        {
                            json += jsonlist[i];
                            if (i < endweizhi - 1) { json += ","; }
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
                case "WriteRedisDecl":
                    try
                    {
                        sql = @"select ld.*,lo.cusno as locusno from list_declaration ld left join list_order lo on ld.ordercode=lo.code order by ld.id";
                        dt = DBMgr.GetDataTable(sql);
                        if (dt.Rows.Count > 0)
                        {
                            DataTable tmp = dt.Rows[0].Table.Clone(); // 复制DataRow的表结构
                            foreach (DataRow dr in dt.Rows)
                            {
                                dr["ordercode"] = dr["locusno"];
                                tmp.ImportRow(dr);
                                json = JsonConvert.SerializeObject(tmp); json = json.TrimStart('[').TrimEnd(']');
                                tmp.Clear();
                                db.ListRightPush("redis_declare", json);
                            }
                        }

                        sql = @"select ld.* from list_decllist ld  order by ld.id";
                        dt = DBMgr.GetDataTable(sql);
                        if (dt.Rows.Count > 0)
                        {
                            DataTable tmp = dt.Rows[0].Table.Clone(); // 复制DataRow的表结构
                            foreach (DataRow dr in dt.Rows)
                            {
                                tmp.ImportRow(dr);
                                json = JsonConvert.SerializeObject(tmp); json = json.TrimStart('[').TrimEnd(']');
                                tmp.Clear();
                                db.ListRightPush("redis_declarelist", json);
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
                case "ClearRedisDecl":
                    if (db.KeyExists("redis_declare")) { db.KeyDelete("redis_declare"); }
                    if (db.KeyExists("redis_declarelist")) { db.KeyDelete("redis_declarelist"); }

                    Response.Write("{success:true}");
                    Response.End();
                    break;

            }         
            
        }



    }
}