using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data;
using System.Security.Cryptography;
using System.Text;

namespace Web_Admin.Common
{
    public static class Extension
    {
        public static string ToSHA1(this string value)
        {
            string result = string.Empty;
            SHA1 sha1 = new SHA1CryptoServiceProvider();
            byte[] array = sha1.ComputeHash(Encoding.Unicode.GetBytes(value));
            for (int i = 0; i < array.Length; i++)
            {
                result += array[i].ToString("x2");
            }
            return result;
        }

        //获得用户信息
        public static JObject Get_UserInfo(string username)
        {
            IsoDateTimeConverter iso = new IsoDateTimeConverter();//序列化JSON对象时,日期的处理格式
            iso.DateTimeFormat = "yyyy-MM-dd HH:mm:ss";


            string sql = @"select * from sys_user where name = '{0}'";
            sql = string.Format(sql, username);

            string jsonstr = JsonConvert.SerializeObject(DBMgr.GetDataTable(sql), iso).Replace("[", "").Replace("]", "");
            return (JObject)JsonConvert.DeserializeObject(jsonstr);
        }


        public static string GetPageSql(string tempsql, string order, string asc, ref int totalProperty, int start, int limit)
        {
            //int start = Convert.ToInt32(Request["start"]);
            //int limit = Convert.ToInt32(Request["limit"]);
            string sql = "select count(1) from ( " + tempsql + " )";
            totalProperty = Convert.ToInt32(DBMgr.GetDataTable(sql).Rows[0][0]); 
            string pageSql = @"SELECT * FROM ( SELECT tt.*, ROWNUM AS rowno FROM ({0} ORDER BY {1} {2}) tt WHERE ROWNUM <= {4}) table_alias WHERE table_alias.rowno >= {3}";
            pageSql = string.Format(pageSql, tempsql, order, asc, start + 1, limit + start);
            return pageSql;
        }

        /// <summary>
        /// 将DataTable指定列转换为list
        /// </summary>
        /// <param name="dt"></param>
        /// <param name="columnName">需要转换的列名</param>
        /// <returns></returns>
        public static List<string> getColumnFromDatatable(DataTable dt, string columnName)
        {
            List<string> columnList = new List<string>();
            foreach (DataRow dr in dt.Rows)
            {
                columnList.Add(dr[columnName].ToString());
            }
            return columnList;
        }


    }
}
