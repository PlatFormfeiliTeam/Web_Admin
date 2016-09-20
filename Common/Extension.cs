using System;
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

        ////获得用户信息
        //public static DataTable GetUserInfo(this string username)
        //{
        //    string strSql = @"select * from sys_user where name = '{0}'";
        //    strSql = string.Format(strSql, username);
        //    DataTable ents = DBMgr.GetDataTable(strSql);
        //    return ents;
        //}


        public static string GetPageSql(string tempsql, string order, string asc, ref int totalProperty, int start, int limit)
        {
            //int start = Convert.ToInt32(Request["start"]);
            //int limit = Convert.ToInt32(Request["limit"]);
            string sql = "select count(1) from ( " + tempsql + " )";
            totalProperty = DBMgr.GetDataTable(sql).Rows.Count;
            string pageSql = @"SELECT * FROM ( SELECT tt.*, ROWNUM AS rowno FROM ({0} ORDER BY {1} {2}) tt WHERE ROWNUM <= {4}) table_alias WHERE table_alias.rowno >= {3}";
            pageSql = string.Format(pageSql, tempsql, order, asc, start + 1, limit + start);
            return pageSql;
        }




    }
}
