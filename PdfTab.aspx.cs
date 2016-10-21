using Web_Admin.Common;
using iTextSharp.text;
using iTextSharp.text.pdf;
using iTextSharp.text.pdf.parser;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Web_Admin
{
    public partial class PdfTab : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string ordercode = Request["ordercode"];
            string action = Request["action"];
            string json = "";
            string sql = "";
            DataTable dt;
            switch (action)
            {
                case "load":
                    //取出该订单下所有上传的pdf文件 先按类型排序 再按文件上传时间排序
                    sql = @"select t.ID,t.FILENAME,t.FILETYPE,f.sortindex,f.filetypename from list_attachment t  
                          left join sys_filetype f on t.filetype=f.filetypeid
                          where t.confirmstatus=1 and lower(t.FILESUFFIX)='pdf' and instr(ordercode,'" + ordercode + "')>0 order by f.sortindex asc ,t.uploadtime asc";
                    dt = DBMgr.GetDataTable(sql);
                    if (dt.Rows.Count > 0)
                    {
                        json = JsonConvert.SerializeObject(dt);
                        Response.Write("{\"success\":true,\"rows\":" + json + "}");
                    }
                    else
                    {
                        Response.Write("{\"success\":false}");
                    }
                    Response.End();
                    break;
            }
        }
    }
}