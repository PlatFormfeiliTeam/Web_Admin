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
using System.Text;

namespace Web_Admin
{
    public partial class DeclarationStatus : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            IDatabase db = SeRedis.redis.GetDatabase();
            string action = Request["action"];
            string code = Request["CODE"] == null ? "" : Request["CODE"].ToString();
            long totalProperty = 0;
            string json = string.Empty; string sql = ""; DataTable dt;
            string CUSNO = Request["CUSNO"] == null ? "" : Request["CUSNO"].ToString();

            switch (action)
            {
                case "loadredisclare":
                    IsoDateTimeConverter iso = new IsoDateTimeConverter();//序列化JSON对象时,日期的处理格式
                    iso.DateTimeFormat = "yyyy-MM-dd HH:mm:ss";

                    if (db.KeyExists("redis_declare"))
                    {
                        RedisValue[] jsonlist = db.ListRange("redis_declare"); //db.StringGet("redis_declare");
                        if(code!=""){
                        IEnumerable<RedisValue> IE_redis=jsonlist.Where<RedisValue>(RV => RV.ToString().Contains(code));
                        jsonlist = IE_redis.ToArray<RedisValue>();
                        }
                        
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
                        if (CUSNO == "")
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
                        }
                        else
                        {
                            string[] cusno = CUSNO.Split(',');
                            for (int i = 0; i < cusno.Length; i++)
                                
                            {
                                string codetemp = RandCode(15);
                                string DECLARATIONCODEtemp = RandCode(18);
                                json = "{\"CODE\":\"" + codetemp + "\",\"DECLARATIONCODE\":\"" + DECLARATIONCODEtemp + "\",\"CUSTOMSSTATUS\":\"15\",\"COMMODITYNUM\":\"20 \",\"SHEETNUM\":\"20\",\"CUSNO\":\"" + cusno[i].ToString() + "\"}";
                                db.ListRightPush("redis_declare", json);
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
                

                    Response.Write("{success:true}");
                    Response.End();
                    break;

            }         
            
        }

        private string getRandom() {

            string str = null;
            for (int i = 0; i < 18;i++ )
            {
                Random random = new Random();
                int n=random.Next(0, 10);
                str += n.ToString();

            }
            return str;


        }
       
        private  string RandCode(int N)
        {
            char[] arrChar = new char[] { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' };
            StringBuilder num = new StringBuilder();
            Random rnd = new Random(Guid.NewGuid().GetHashCode());
            for (int i = 0; i < N; i++)
            {
                num.Append(arrChar[rnd.Next(0, arrChar.Length)].ToString());
            }
            return num.ToString();
        }



    }
}