using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using StackExchange.Redis;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Web_Admin.Common;
using Web_Admin.model;
using System.Web.Services;


namespace Web_Admin
{
    public partial class EXT_Inspectionall : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string action = Request["action"];
            string cusno = Request["CUSNO"];
            string fenkey = Request["FENKEY"];
            // fenkey = "declareall";
            int totalProperty = 0;
            long totalProperty_fenkey = 0;
            string where = string.Empty;
            DataTable dt;
            string json = string.Empty;
            string json_fenkey = string.Empty;
            string sql = "select * from redis_inspectionall where 1=1";
            IsoDateTimeConverter iso = new IsoDateTimeConverter();//序列化JSON对象时,日期的处理格式
            iso.DateTimeFormat = "yyyy-MM-dd HH:mm:ss";
            switch (action)
            {
                case "loadattach":

                    if (!string.IsNullOrEmpty(cusno))
                    {
                        where += " and CUSNO like '%" + cusno + "%'";
                    }
                    if (!string.IsNullOrEmpty(fenkey))
                    {
                        where = " and DIVIDEREDISKEY like '%" + fenkey + "%'";
                    }
                    sql += where;

                    sql = Extension.GetPageSql(sql, "ID", "desc", ref totalProperty, Convert.ToInt32(Request["start"]), Convert.ToInt32(Request["limit"]));
                    dt = DBMgr.GetDataTable(sql);
                    json = JsonConvert.SerializeObject(dt, iso);
                    Response.Write("{rows:" + json + ",total:" + totalProperty + "}");
                    Response.End();
                    break;
                case "loadattach1":
                    IDatabase db = SeRedis.redis.GetDatabase();
                    if (fenkey != string.Empty && db.KeyExists(fenkey))
                    {
                        long start = Convert.ToInt64(Request["start"]);
                        long end = Convert.ToInt64(Request["start"]) + Convert.ToInt64(Request["limit"]);
                        RedisValue[] jsonlist = db.ListRange(fenkey, start, end - 1);
                        totalProperty_fenkey = db.ListLength(fenkey);
                        for (long i = 0; i < jsonlist.Length; i++)
                        {
                            json_fenkey += jsonlist[i];
                            if (i < jsonlist.Length - 1) { json_fenkey += ","; }
                        }
                        json_fenkey = "[" + json_fenkey + "]";
                    }
                    else
                    {
                        json_fenkey = "[]";
                    }
                    Response.Write("{rows:" + json_fenkey + ",total:" + totalProperty_fenkey + "}");
                    Response.End();
                    break;

            }
        }
    }
}