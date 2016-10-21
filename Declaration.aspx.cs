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
            int totalProperty = 0;
            string json = string.Empty; string sql = ""; DataTable dt;

            switch (action)
            {
                case "loadredisceclare":
                    IsoDateTimeConverter iso = new IsoDateTimeConverter();//序列化JSON对象时,日期的处理格式
                    iso.DateTimeFormat = "yyyy-MM-dd HH:mm:ss";

                    string where = "";
                    if (!string.IsNullOrEmpty(Request["CODE"]))
                    {
                        where += " and CODE like '%" + Request["CODE"] + "%'";
                    }
                    json = db.StringGet("redis_declare");
                    //sql = @"SELECT * FROM list_declaration " + where;

                    //sql = Extension.GetPageSql(sql, "UPLOADTIME", "desc", ref totalProperty, Convert.ToInt32(Request["start"]), Convert.ToInt32(Request["limit"]));
                    //dt = DBMgr.GetDataTable(sql);
                    dt = new DataTable();
                    json = JsonConvert.SerializeObject(dt, iso);
                    Response.Write("{rows:" + json + ",total:" + totalProperty + "}");
                    Response.End();
                    break;
                case "WriteRedisDecl":
                    try
                    {
                        sql = @"select ld.*,lo.cusno as locusno from list_declaration ld left join list_order lo on ld.ordercode=lo.code";
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

                        sql = @"select ld.* from list_decllist ld ";
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

            }            
            
        }
        /*
        /// <summary>
        /// Json 字符串 转换为 DataTable数据集合
        /// </summary>
        /// <param name="json"></param>
        /// <returns></returns>
        public static DataTable ToDataTable(this string json)
        {
            DataTable dataTable = new DataTable();  //实例化
            DataTable result;
            try
            {
                JavaScriptSerializer javaScriptSerializer = new JavaScriptSerializer();
                javaScriptSerializer.MaxJsonLength = Int32.MaxValue; //取得最大数值
                ArrayList arrayList = javaScriptSerializer.Deserialize<ArrayList>(json);
                if (arrayList.Count > 0)
                {
                    foreach (Dictionary<string, object> dictionary in arrayList)
                    {
                        if (dictionary.Keys.Count<string>() == 0)
                        {
                            result = dataTable;
                            return result;
                        }
                        if (dataTable.Columns.Count == 0)
                        {
                            foreach (string current in dictionary.Keys)
                            {
                                dataTable.Columns.Add(current, dictionary[current].GetType());
                            }
                        }
                        DataRow dataRow = dataTable.NewRow();
                        foreach (string current in dictionary.Keys)
                        {
                            dataRow[current] = dictionary[current];
                        }

                        dataTable.Rows.Add(dataRow); //循环添加行到DataTable中
                    }
                }
            }
            catch
            {
            }
            result = dataTable;
            return result;
        }
*/


    }
}