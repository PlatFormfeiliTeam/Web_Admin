using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Web_Admin.Common;
using Newtonsoft.Json;
using System.Data;

namespace Web_Admin
{
    public partial class WebAuthList : System.Web.UI.Page
    {
        //ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType); 
        string action = string.Empty;
        string ID = string.Empty; string userid = string.Empty; string ParentID = string.Empty; 
        string GroupId = string.Empty; string AllId = string.Empty; string type = "";
        string sql = string.Empty; DataTable ents;

        //IDatabase db = SeRedis.redis.GetDatabase();
        protected void Page_Load(object sender, EventArgs e)
        {
            action = Request["action"];
            ID = Request["id"]; userid = Request["userid"];ParentID = Request["parentid"];
            GroupId = Request["groupid"]; AllId = Request["allid"]; type = Request["type"];

            string result = "";

            switch (action)
            {
                case "selectModel":
                    if (!string.IsNullOrEmpty(userid))//当选择了人员后，显示该人员的权限
                    {
                        sql = @"select a.MODULEID,a.NAME,a.ISLEAF,a.URL,a.PARENTID,a.SORTINDEX,
                                                                  (select  b.ModuleId  from SYS_MODULEUSER b where a.MODULEID=b.MODULEID AND B.USERID='{0}' and rownum=1) as CHECKED from sysmodule a                             
                                                                  where PARENTID ='{1}' order by SORTINDEX";
                        sql = string.Format(sql, userid, Request["id"]);
                        ents = DBMgr.GetDataTable(sql);
                        SysModule obj = new SysModule();
                        obj.id = "91a0657f-1939-4528-80aa-91b202a593ab";
                        obj = GetTree(null, obj, userid);
                        result = JsonConvert.SerializeObject(obj.children, Formatting.None);
                        result = result.Replace("check", "checked");

                    }
               
                    Response.Write(result);
                    Response.End();
                    break;
                case "loaduser":
                    sql = "SELECT su.*, sc.name AS CUSTOMERNAME FROM sys_user su LEFT JOIN cusdoc.sys_customer sc ON su.customerid = sc.id WHERE su.customerid > 0 AND PARENTID IS NULL";
                    ents = DBMgr.GetDataTable(sql);
                    result = "{rows:" + JsonConvert.SerializeObject(ents) + "}";
                    Response.Write(result);
                    Response.End();
                    break;
                case "AuthorizationSave":
                    string moduleids = Request["moduleids"];
                    sql = @"DELETE FROM SYS_MODULEUSER WHERE USERID = '{0}'";
                    sql = string.Format(sql, userid);
                    DBMgr.ExecuteNonQuery(sql);
                    string[] ids = moduleids.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                    foreach (string moduleid in ids)
                    {
                        sql = @"insert into SYS_MODULEUSER (USERID,MODULEID) values ('{0}','{1}')";
                        sql = string.Format(sql, userid, moduleid);
                        DBMgr.ExecuteNonQuery(sql);
                    }

                    SysModule obj2 = new SysModule();
                    obj2.id = "91a0657f-1939-4528-80aa-91b202a593ab";
                    obj2 = GetTree(null, obj2, userid);
                    string json = JsonConvert.SerializeObject(obj2.children, Formatting.None);
                    json = json.Replace("check", "checked");

                    updateChildrenAuthority();

                    Response.Write("{success:true}");
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
                    DataTable mIdsDt =DBMgr.GetDataTable("select MODULEID from SYS_MODULEUSER where userid = " + drId["ID"].ToString());

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

                    //创建子账号权限配置数据集缓存
                    SysModule obj2 = new SysModule();
                    obj2.id = "91a0657f-1939-4528-80aa-91b202a593ab";
                    obj2 = GetTree(moduleIdDt, obj2, drId["ID"].ToString());
                    string json = JsonConvert.SerializeObject(obj2.children, Formatting.None);
                    json = json.Replace("check", "checked");
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


    }
}