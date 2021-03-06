﻿using System;
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
    public partial class WebAuthList_After : System.Web.UI.Page
    {
        string action = string.Empty;
        string userid = string.Empty;
        string ParentID = string.Empty;
        string GroupId = string.Empty;
        string AllId = string.Empty;
        string type = "";
        string sql = string.Empty; DataTable ents;
        protected void Page_Load(object sender, EventArgs e)
        {
            action = Request["action"];
            ID = Request["id"]; userid = Request["userid"]; ParentID = Request["parentid"];
            GroupId = Request["groupid"]; AllId = Request["allid"]; type = Request["type"];

            string result = "";

            switch (action)
            {
                case "loadauthority":
                    string sql = string.Empty;
                    if (!string.IsNullOrEmpty(userid))
                    {
                        sql = @"select t.*,u.MODULEID AUTHORITY from sysmodule t  left join (select * from sys_moduleuser_back where userid='{0}') u on t.MODULEID=u.MODULEID
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
                case "loaduser":
                    sql = "SELECT * FROM sys_user where ENABLED=1 and type!=4 order by name";
                    ents = DBMgr.GetDataTable(sql);
                    result = "{rows:" + JsonConvert.SerializeObject(ents) + "}";
                    Response.Write(result);
                    Response.End();
                    break;
                case "AuthorizationSave":
                    string moduleids = Request["moduleids"];
                    sql = @"DELETE FROM SYS_MODULEUSER_back WHERE USERID = '{0}'";
                    sql = string.Format(sql, userid);
                    DBMgr.ExecuteNonQuery(sql);
                    string[] ids = moduleids.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                    foreach (string moduleid in ids)
                    {
                        sql = @"insert into SYS_MODULEUSER_back (USERID,MODULEID) values ('{0}','{1}')";
                        sql = string.Format(sql, userid, moduleid);
                        DBMgr.ExecuteNonQuery(sql);
                    }

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
                DataTable moduleIdDt = DBMgr.GetDataTable("select MODULEID from SYS_MODULEUSER_back where userid = " + userid);
                List<string> mIdList = Extension.getColumnFromDatatable(moduleIdDt, "MODULEID");

                //子账号ID集合
                DataTable cdIds = DBMgr.GetDataTable("select ID from SYS_USER where parentid = " + userid);

                //遍历子账号
                foreach (DataRow drId in cdIds.Rows)
                {
                    //查询该子账号的moduleIds
                    DataTable mIdsDt = DBMgr.GetDataTable("select MODULEID from SYS_MODULEUSER_back where userid = " + drId["ID"].ToString());

                    //删除该子账号原有的moduleIds
                    DBMgr.ExecuteNonQuery("DELETE FROM SYS_MODULEUSER_back WHERE USERID = " + drId["ID"].ToString());

                    //插入子账号moduleIds
                    foreach (DataRow mId in mIdsDt.Rows)
                    {
                        //过滤掉子账号中主账号没有的moduleIds
                        if (mIdList.Contains(mId["MODULEID"].ToString()))
                        {
                            DBMgr.ExecuteNonQuery("insert into SYS_MODULEUSER_back (USERID,MODULEID) values ('" + drId["ID"].ToString() + "','" + mId["MODULEID"].ToString() + "')");
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

        private string getchildren(string moduleid, string userid)
        {
            string children = "[";
            sql = @"select t.*,u.MODULEID AUTHORITY from sysmodule t left join (select * from sys_moduleuser_back where userid='{0}') u on t.MODULEID=u.MODULEID
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