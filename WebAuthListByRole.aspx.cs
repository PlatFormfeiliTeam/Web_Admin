using Newtonsoft.Json;
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
    public partial class WebAuthListByRole : System.Web.UI.Page
    {
        string action = string.Empty; string userid = string.Empty; string ISCUSTOMER = string.Empty; string ISSHIPPER = string.Empty; string ISCOMPANY = string.Empty;
        string sql = string.Empty; DataTable ents;
        protected void Page_Load(object sender, EventArgs e)
        {
            action = Request["action"]; userid = Request["userid"]; ISCUSTOMER = Request["ISCUSTOMER"]; ISSHIPPER = Request["ISSHIPPER"]; ISCOMPANY = Request["ISCOMPANY"]; 
             string result = "";

             switch (action)
             {
                 case "loaduser":
                     sql = @"SELECT su.*, sc.name AS CUSTOMERNAME,sc.iscustomer,sc.isshipper,sc.iscompany 
                            FROM sys_user su 
                                LEFT JOIN cusdoc.sys_customer sc ON su.customerid = sc.id 
                            WHERE su.customerid > 0 AND PARENTID IS NULL";
                     ents = DBMgr.GetDataTable(sql);
                     result = "{rows:" + JsonConvert.SerializeObject(ents) + "}";
                     Response.Write(result);
                     Response.End();
                     break;
                 case "SaveAuthorByRole":                    
                    sql = @"DELETE FROM SYS_MODULEUSER WHERE USERID = '{0}'";
                    sql = string.Format(sql, userid);
                    DBMgr.ExecuteNonQuery(sql);

                    sql = "";
                    if (ISCUSTOMER == "1") {
                        sql = (sql == "" ? "" : sql + " union ") + " select '" + userid + "' userid,moduleid from sysmodule where ISCUSTOMER=1";
                    }
                    if (ISSHIPPER == "1") {
                        sql = (sql == "" ? "" : sql + " union ") + " select '" + userid + "' userid,moduleid from sysmodule where ISSHIPPER=1";
                    }
                    if (ISCOMPANY == "1") {
                        sql = (sql == "" ? "" : sql + " union ") + " select '" + userid + "' userid,moduleid from sysmodule where ISCOMPANY=1";
                    }

                    sql = @"insert into SYS_MODULEUSER (USERID,MODULEID) " + sql;
                    DBMgr.ExecuteNonQuery(sql);

                    updateChildrenAuthority();

                    Response.Write("{success:true}");
                    Response.End();
                     break;
                 case "loadauthority":
                     if (!string.IsNullOrEmpty(userid))
                     {
                         sql = @"select t.*,u.MODULEID AUTHORITY from sysmodule t  left join (select * from sys_moduleuser where userid='{0}') u on t.MODULEID=u.MODULEID
                              where  t.ParentId='{1}' order by t.SortIndex";
                         sql = string.Format(sql, userid, Request["id"]);
                     }
                     result = "[";
                     if (!string.IsNullOrEmpty(sql))
                     {
                         DataTable dt = DBMgr.GetDataTable(sql);
                         int i = 0;
                         string children = string.Empty;
                         foreach (DataRow dr in dt.Rows)
                         {
                             children = getchildren(dr["MODULEID"].ToString(), userid);
                             if (i != dt.Rows.Count - 1)
                             {
                                 result += "{id:'" + dr["MODULEID"] + "',name:'" + dr["NAME"] + "',ParentID:'" + dr["PARENTID"] + "',leaf:'" + dr["ISLEAF"] + "',checked:" + (string.IsNullOrEmpty(dr["AUTHORITY"] + "") ? "false" : "true") + ",children:" + children + "},";
                             }
                             else
                             {
                                 result += "{id:'" + dr["MODULEID"] + "',name:'" + dr["NAME"] + "',ParentID:'" + dr["PARENTID"] + "',leaf:'" + dr["ISLEAF"] + "',checked:" + (string.IsNullOrEmpty(dr["AUTHORITY"] + "") ? "false" : "true") + ",children:" + children + "}";
                             }
                             i++;
                         }
                     }
                     result += "]";
                     Response.Write(result);
                     Response.End();
                     break;
             }
        }

        private void updateChildrenAuthority()
        {
            try
            {
                //主账号的ModuleId集合
                DataTable moduleIdDt = DBMgr.GetDataTable("select MODULEID from SYS_MODULEUSER where userid = " + userid);
                List<string> mIdList = Extension.getColumnFromDatatable(moduleIdDt, "MODULEID");

                //子账号ID集合
                DataTable cdIds = DBMgr.GetDataTable("select ID from SYS_USER where parentid = " + userid);

                //遍历子账号
                foreach (DataRow drId in cdIds.Rows)
                {
                    //查询该子账号的moduleIds
                    DataTable mIdsDt = DBMgr.GetDataTable("select MODULEID from SYS_MODULEUSER where userid = " + drId["ID"].ToString());

                    //删除该子账号原有的moduleIds
                    DBMgr.ExecuteNonQuery("DELETE FROM SYS_MODULEUSER WHERE USERID = " + drId["ID"].ToString());

                    //插入子账号moduleIds
                    foreach (DataRow mId in mIdsDt.Rows)
                    {
                        //过滤掉子账号中主账号没有的moduleIds
                        if (mIdList.Contains(mId["MODULEID"].ToString()))
                        {
                            DBMgr.ExecuteNonQuery("insert into SYS_MODULEUSER (USERID,MODULEID) values ('" + drId["ID"].ToString() + "','" + mId["MODULEID"].ToString() + "')");
                        }
                    }
                }
            }
            catch (Exception e)
            {
                //log.Error(e.Message + e.StackTrace);
            }

            Response.Write("{success:true}");
            Response.End();

        }

        private SysModule GetTree(DataTable moduleIdDt, SysModule obj, string userid)
        {
            try
            {
                string strSQL = @"select a.MODULEID as id,a.NAME,a.ISLEAF,a.URL,a.PARENTID,a.SORTINDEX,
                                              (select  b.ModuleId  from SYS_MODULEUSER b where a.MODULEID=b.MODULEID AND B.USERID='" + userid + "' and rownum=1) as CHECKED from sysmodule a  " +
                                      "where PARENTID ='" + obj.id + "' order by SORTINDEX";
                DataTable dtNext = DBMgr.GetDataTable(strSQL);
                obj.children = new List<SysModule>();

                foreach (DataRow dr in dtNext.Rows)
                {

                    if (moduleIdDt != null)
                    {
                        //过滤掉主账号没有的ModuleId
                        int count = 0;
                        foreach (DataRow mdr in moduleIdDt.Rows)
                        {
                            if (mdr["MODULEID"].ToString() == dr["id"].ToString())
                            {
                                count += 1;
                            }
                        }
                        if (count == 0)
                        {
                            continue;
                        }
                    }

                    SysModule st = new SysModule();
                    st.id = dr["id"].ToString();
                    st.name = dr["name"].ToString();
                    st.ParentID = dr["PARENTID"].ToString();
                    st.check = string.IsNullOrEmpty(dr["CHECKED"].ToString()) ? false : true;
                    // 递归调用
                    st = this.GetTree(moduleIdDt, st, userid);
                    st.leaf = dr["ISLEAF"] + "";
                    obj.children.Add(st);
                }
                return obj;
            }
            catch
            {
                throw;
            }
        }

        private string getchildren(string moduleid, string userid)
        {
            string children = "[";
            sql = @"select t.*,u.MODULEID AUTHORITY from sysmodule t left join (select * from sys_moduleuser where userid='{0}') u on t.MODULEID=u.MODULEID
                where  t.ParentId ='{1}' order by t.SortIndex";
            sql = string.Format(sql, userid, moduleid);
            DataTable dt = DBMgr.GetDataTable(sql);
            int i = 0;
            foreach (DataRow dr in dt.Rows)
            {
                string tmp_children = getchildren(dr["MODULEID"].ToString(), userid);
                if (i != dt.Rows.Count - 1)
                {
                    children += "{id:'" + dr["MODULEID"] + "',name:'" + dr["NAME"] + "',ParentID:'" + dr["PARENTID"] + "',leaf:'" + dr["ISLEAF"] + "',checked:" + (string.IsNullOrEmpty(dr["AUTHORITY"] + "") ? "false" : "true") + ",children:" + tmp_children + "},";
                }
                else
                {
                    children += "{id:'" + dr["MODULEID"] + "',name:'" + dr["NAME"] + "',ParentID:'" + dr["PARENTID"] + "',leaf:'" + dr["ISLEAF"] + "',checked:" + (string.IsNullOrEmpty(dr["AUTHORITY"] + "") ? "false" : "true") + ",children:" + tmp_children + "}";
                }
                i++;
            }
            children += "]";
            return children;
        }

    }
}