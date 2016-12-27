using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
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
        public string rcbIsinvalid = string.Empty;
        public string reContent = string.Empty;
        public string ATTACHMENT = string.Empty;

        DataTable dt;
        protected void Page_Load(object sender, EventArgs e)
        {
             string action = Request["action"]; 
            switch (action)
            {
                case "uploadfile":
                    var fileUpload = Request.Files[0];
                    var uploadPath = Server.MapPath("/FileUpload/file");
                    int chunk = Request.Params["chunk"] != null ? int.Parse(Request.Params["chunk"]) : 0;
                    string name = Request.Params["name"] != null ? Request.Params["name"] : "1.jpg";

                    using (var fs = new FileStream(Path.Combine(uploadPath, name), chunk == 0 ? FileMode.Create : FileMode.Append))
                    {
                        var buffer = new byte[fileUpload.InputStream.Length];
                        fileUpload.InputStream.Read(buffer, 0, buffer.Length);
                        fs.Write(buffer, 0, buffer.Length);
                    }
                    Response.End();
                    break;
            }
        }

        //动态绑定类型
        public string Bind_rcbType()
        {
            sql = "select distinct type from  web_notice t  where t.isinvalid=0 order by type";
            dt = DBMgr.GetDataTable(sql);
            string json = JsonConvert.SerializeObject(dt);
            return json;
        }

        //文件上传到web服务器
        //public ActionResult UploadFile(int? chunk, string name)
        //{
        //    var fileUpload = Request.Files[0];
        //    var uploadPath = Server.MapPath("/FileUpload/file");
        //    chunk = chunk ?? 0;
        //    using (var fs = new FileStream(Path.Combine(uploadPath, name), chunk == 0 ? FileMode.Create : FileMode.Append))
        //    {
        //        var buffer = new byte[fileUpload.InputStream.Length];
        //        fileUpload.InputStream.Read(buffer, 0, buffer.Length);
        //        fs.Write(buffer, 0, buffer.Length);
        //    }
        //    return Content("chunk uploaded", "text/plain");
        //}
    }
}