﻿using Newtonsoft.Json;
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
    public partial class PositionAuthList : System.Web.UI.Page
    {
        string action = string.Empty; string positionid = string.Empty;
        string sql = string.Empty;
        protected void Page_Load(object sender, EventArgs e)
        {
            action = Request["action"]; positionid = Request["positionid"];
            string result = "";
            switch (action)
            {
                case "loadroleauthority":
                    if (!string.IsNullOrEmpty(positionid))
                    {
                        sql = @"select t.* from sysmodule t where  t.ParentId='{0}' order by t.SortIndex";
                        sql = string.Format(sql, Request["id"]);
                    }
                    result = "[";
                    if (!string.IsNullOrEmpty(sql))
                    {
                        DataTable dt = DBMgr.GetDataTable(sql);
                        int i = 0;
                        string children = string.Empty;
                        foreach (DataRow dr in dt.Rows)
                        {
                            children = getchildren(dr["MODULEID"].ToString(), positionid);
                            if (i != dt.Rows.Count - 1)
                            {
                                result += "{id:'" + dr["MODULEID"] + "',name:'" + dr["NAME"] + "',ParentID:'" + dr["PARENTID"] + "',leaf:'" + dr["ISLEAF"] + "',checked:" + (string.IsNullOrEmpty(dr[positionid] + "") ? "false" : "true") + ",children:" + children + "},";
                            }
                            else
                            {
                                result += "{id:'" + dr["MODULEID"] + "',name:'" + dr["NAME"] + "',ParentID:'" + dr["PARENTID"] + "',leaf:'" + dr["ISLEAF"] + "',checked:" + (string.IsNullOrEmpty(dr[positionid] + "") ? "false" : "true") + ",children:" + children + "}";
                            }
                            i++;
                        }
                    }
                    result += "]";
                    Response.Write(result);
                    Response.End();
                    break;
                case "PositionAuthorSave":
                    sql = @"update sysmodule set {0} = null"; sql = string.Format(sql, positionid);
                    DBMgr.ExecuteNonQuery(sql);

                    if (!string.IsNullOrEmpty(Request["moduleids"]))
                    {
                        sql = @"update sysmodule set {0} = 1 where MODULEID in({1})"; sql = string.Format(sql, positionid, Request["moduleids"]);
                        DBMgr.ExecuteNonQuery(sql);
                    }

                    Response.Write("{success:true}");
                    Response.End();
                    break;
            }
        }
        private string getchildren(string moduleid, string positionid)
        {
            string children = "[";
            sql = @"select t.* from sysmodule t where  t.ParentId ='{0}' order by t.SortIndex";
            sql = string.Format(sql, moduleid);
            DataTable dt = DBMgr.GetDataTable(sql);
            int i = 0;
            foreach (DataRow dr in dt.Rows)
            {
                string tmp_children = getchildren(dr["MODULEID"].ToString(), positionid);
                if (i != dt.Rows.Count - 1)
                {
                    children += "{id:'" + dr["MODULEID"] + "',name:'" + dr["NAME"] + "',ParentID:'" + dr["PARENTID"] + "',leaf:'" + dr["ISLEAF"] + "',checked:" + (string.IsNullOrEmpty(dr[positionid] + "") ? "false" : "true") + ",children:" + tmp_children + "},";
                }
                else
                {
                    children += "{id:'" + dr["MODULEID"] + "',name:'" + dr["NAME"] + "',ParentID:'" + dr["PARENTID"] + "',leaf:'" + dr["ISLEAF"] + "',checked:" + (string.IsNullOrEmpty(dr[positionid] + "") ? "false" : "true") + ",children:" + tmp_children + "}";
                }
                i++;
            }
            children += "]";
            return children;
        }
    }
}