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
using System.Web.Services;

namespace Web_Admin
{
    public partial class NoticeList : System.Web.UI.Page
    {
        //string action = string.Empty;
        protected void Page_Load(object sender, EventArgs e)
        {
            //string result = ""; string sql = string.Empty;

            //action = Request["action"];
            //switch (action)
            //{
            //    case "loadnewscategory":
            //        sql = @"select t.* from NEWSCATEGORY t where t.PID is null";

            //        result = "[";
            //        DataTable dt = DBMgr.GetDataTable(sql);
            //        int i = 0;
            //        string children = string.Empty;
            //        foreach (DataRow dr in dt.Rows)
            //        {
            //            children = getchildren(dr["id"].ToString());
            //            result += "{id:'" + dr["id"] + "',name:'" + dr["NAME"] + "',PID:'" + dr["PID"] + "',leaf:'" + dr["ISLEAF"] + "',children:" + children + "}";

            //            if (i != dt.Rows.Count - 1)
            //            {
            //                result += ",";
            //            }
            //            i++;
            //        }
            //        result += "]";
            //        Response.Write(result);
            //        Response.End();
            //        break;
            //    default:
            //        break;
            //}
        }

        [WebMethod]
        public static string getCate()
        {
            string result = ""; string sql = string.Empty;
            sql = @"select t.* from NEWSCATEGORY t where t.PID is null";

            result = "[";
            DataTable dt = DBMgr.GetDataTable(sql);
            int i = 0;
            string children = string.Empty;
            foreach (DataRow dr in dt.Rows)
            {
                children = getchildren(dr["id"].ToString());
                result += "{ID:'" + dr["id"] + "',NAME:'" + dr["NAME"] + "',PID:'" + dr["PID"] + "',leaf:'" + dr["ISLEAF"] + "',children:" + children + "}";

                if (i != dt.Rows.Count - 1)
                {
                    result += ",";
                }
                i++;
            }
            result += "]";
            return result;
        }

        private static string getchildren(string id)
        {
            string sql = string.Empty;

            string children = "[";
            sql = @"select t.* from NEWSCATEGORY t where  t.PID ='{0}'";
            sql = string.Format(sql, id);
            DataTable dt = DBMgr.GetDataTable(sql);
            int i = 0;
            foreach (DataRow dr in dt.Rows)
            {
                string tmp_children = getchildren(dr["id"].ToString());

                children += "{ID:'" + dr["id"] + "',NAME:'" + dr["NAME"] + "',PID:'" + dr["PID"] + "',leaf:'" + dr["ISLEAF"] + "',children:" + tmp_children + "}";

                if (i != dt.Rows.Count - 1)
                {
                    children += ",";
                }
                i++;
            }
            children += "]";
            return children;
        }

    }
}