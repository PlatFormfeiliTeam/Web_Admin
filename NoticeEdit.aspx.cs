using Newtonsoft.Json;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using Web_Admin.Common;

namespace Web_Admin
{
    public partial class NoticeEdit : System.Web.UI.Page
    {
        string sql = "";
        protected string action = "";
        public string rtbID = string.Empty;
        public string rtbTitle = string.Empty;
        public string rcbType = string.Empty;
        public string rcbValid = string.Empty;
        public string reContent = string.Empty;
        public string rchAttachment = string.Empty;
        public string UPDATEID= string.Empty;
        public string UPDATENAME = string.Empty;
        public string rtbPublishDate = string.Empty;
        public string rtbREFERENCESOURCE = string.Empty;

        DataTable dt;
        protected void Page_Load(object sender, EventArgs e)
        {
            FormsIdentity identity = User.Identity as FormsIdentity;
            if (identity == null)
            {
                return;
            }
            dt = DBMgr.GetDataTable("select * from sys_user where name = '" + identity.Name + "'");
            if (dt.Rows.Count>0)
            {
                UPDATEID = dt.Rows[0]["ID"].ToString(); UPDATENAME = dt.Rows[0]["REALNAME"].ToString();
            }

            string action = Request["action"]; string ID = Request["ID"];
            switch (action)
            {
                case "uploadfile":
                    var fileUpload = Request.Files[0];
                    var uploadPath = Server.MapPath("/FileUpload/file");
                    int chunk = Request.Params["chunk"] != null ? int.Parse(Request.Params["chunk"]) : 0;
                    string name = Request.Params["name"] != null ? Request.Params["name"] : "";

                    using (var fs = new FileStream(Path.Combine(uploadPath, name), chunk == 0 ? FileMode.Create : FileMode.Append))
                    {
                        var buffer = new byte[fileUpload.InputStream.Length];
                        fileUpload.InputStream.Read(buffer, 0, buffer.Length);
                        fs.Write(buffer, 0, buffer.Length);
                    }
                    Response.End();
                    break;
                case "load":
                    sql = "select t.id,t.type,t.title,t.CONTENT,t.ATTACHMENT,to_char(t.publishdate,'yyyy/mm/dd') publishdate,t.ISINVALID,t.REFERENCESOURCE from WEB_NOTICE t where id = '" + ID + "' ";
                    dt = DBMgr.GetDataTable(sql);
                    if (dt.Rows.Count > 0)
                    {
                        rtbID = dt.Rows[0]["ID"] + ""; rtbTitle = dt.Rows[0]["TITLE"] + ""; rcbType = dt.Rows[0]["TYPE"] + "";
                        reContent = dt.Rows[0]["CONTENT"] + ""; rcbValid = dt.Rows[0]["ISINVALID"] + ""; rchAttachment = dt.Rows[0]["ATTACHMENT"] + "";
                        rtbPublishDate = dt.Rows[0]["PublishDate"] + ""; rtbREFERENCESOURCE = dt.Rows[0]["REFERENCESOURCE"] + "";
                    }
                    break;
                case "save":
                    rtbID = Request.Form["rtbID"]; rtbTitle = Request.Form["rtbTitle"]; rcbType = Request.Form["rcbType"];
                    reContent = Request.Form["reContent"]; rcbValid = Request.Form["rcbValid"]; rchAttachment = Request.Form["rchAttachment"];
                    rtbPublishDate = Request.Form["rtbPublishDate"]; rtbREFERENCESOURCE = Request.Form["rtbREFERENCESOURCE"];
                    rtbPublishDate = "to_date('" + rtbPublishDate + "','yyyy-MM-dd')";

                    if (!string.IsNullOrEmpty(rtbID))
                    {
                        sql += @" update WEB_NOTICE set TITLE = '{1}', TYPE = '{2}', CONTENT = :recon, ISINVALID = '{3}',ATTACHMENT='{4}'
                                ,UPDATEID='{5}', UPDATENAME='{6}',UPDATETIME=sysdate,PublishDate={7},REFERENCESOURCE='{8}' where id = '{0}' ";
                        sql = string.Format(sql, rtbID, rtbTitle, rcbType, rcbValid, rchAttachment, UPDATEID, UPDATENAME, rtbPublishDate, rtbREFERENCESOURCE);
                    }
                    else
                    {
                        sql += @" insert into WEB_NOTICE (ID,TITLE,CONTENT,TYPE,ISINVALID,UPDATEID, UPDATENAME,UPDATETIME,ATTACHMENT,PublishDate,REFERENCESOURCE) 
                                    values (WEB_NOTICE_ID.Nextval,'{0}',:recon,'{1}','{2}','{3}','{4}',sysdate,'{5}',{6},'{7}') ";
                        sql = string.Format(sql, rtbTitle, rcbType, rcbValid, UPDATEID, UPDATENAME, rchAttachment, rtbPublishDate, rtbREFERENCESOURCE);
                    }

                    OracleParameter[] parameters = new OracleParameter[]
                       {                  
                           new OracleParameter(":recon",OracleDbType.Clob)
                       };
                    parameters[0].Value = reContent;

                    int i = DBMgr.ExecuteNonQuery(sql, parameters);

                    if (i > 0)
                    {
                        Response.Write("<script>alert('保存成功');</script>");
                    }
                    else
                    {
                        Response.Write("<script>alert('保存失败');</script>");
                    }

                    Response.Write("<script>window.opener.pgbar.moveFirst();</script>");
                    Response.Write("<script>window.close();</script>");
                    Response.End();
                    break;
            }
        }

        //动态绑定类型
        public string Bind_rcbType()
        {
            NewCategoryHandler nc = new NewCategoryHandler();
            string json = nc.getCate();
            return json;
        }

    }
}