using Newtonsoft.Json;
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
    public partial class PdfEdit : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string action = Request["action"];
            string filetype = Request["filetype"];
            string ordercode = Request["ordercode"];
            string fileid = Request["fileid"];
            string userid = Request["userid"];
            //string json = "";
            string sql = "";
            DataTable dt;
            //PdfReader pdfReader;
            //IDatabase db = SeRedis.redis.GetDatabase();
            //FileInfo fi;
            //switch (action)
            //{
            //    case "loadform":
                    string result = "", result_file = ""; 
                    //ListItem item = new ListItem();

                    sql = @"SELECT CODE,BUSITYPE,BUSIUNITNAME,FILESTATUS,ASSOCIATENO,(select name from cusdoc.sys_busitype where code=a.busitype)  as BUSITYPENAME 
                            ,(case FILESTATUS when 1 then '已拆分' else '未拆分' end) as FILESTATUSDESC
                            FROM list_order a WHERE CODE = '" + ordercode + "'";
                    dt = DBMgr.GetDataTable(sql);
                    if (dt.Rows.Count == 1)
                    {
                        //item.Text = dt.Rows[0]["CODE"].ToString(); item.Value = item.Text; rbl_Code.Items.Add(item);
                        if (!string.IsNullOrEmpty(dt.Rows[0]["ASSOCIATENO"].ToString()))
                        {
                            sql = @"SELECT  CODE,BUSITYPE,BUSIUNITNAME,FILESTATUS,ASSOCIATENO,(select name from cusdoc.sys_busitype where code=a.busitype)  as BUSITYPENAME 
                            ,(case FILESTATUS when 1 then '已拆分' else '未拆分' end) as FILESTATUSDESC 
                            FROM list_order a WHERE CODE != '" + ordercode + "' and ASSOCIATENO='" + dt.Rows[0]["ASSOCIATENO"] + "'";
                            DataTable dt_gl = DBMgr.GetDataTable(sql);
                            if (dt_gl.Rows.Count == 1)
                            {
                                dt.Rows[0]["ASSOCIATENO"] = dt_gl.Rows[0]["CODE"];
                                //item = new ListItem(); item.Text = dt.Rows[0]["ASSOCIATENO"].ToString(); item.Value = item.Text; rbl_Code.Items.Add(item);
                            }

                        }
                        result = JsonConvert.SerializeObject(dt).TrimStart('[').TrimEnd(']');

                        sql = "select * from list_attachment where ordercode='" + ordercode + "' and filetype=44 order by uploadtime asc";
                        DataTable dt_file = DBMgr.GetDataTable(sql);
                        result_file = JsonConvert.SerializeObject(dt_file);

                        txt_Busitype.Text = dt.Rows[0]["BUSITYPENAME"].ToString();
                        txt_busiunit.Text = dt.Rows[0]["BUSIUNITNAME"].ToString();
                        txt_Splitstatus.Text = dt.Rows[0]["FILESTATUSDESC"].ToString();
                        //rbl_Code.DataBind();
                    }

            //        Response.Write("{\"formdata\":" + result + ",\"filedata\":" + result_file + "}");
            //        Response.End();
            //        break;
            //}
        }

        
        [WebMethod(EnableSession = true)]
        public static string SayHello(string action, string ordercode)
        {
            return "Hello Ajax!";  
            //return "{\"formdata\":true}";
            //Response.Write("{\"formdata\":true}");
            //Response.End();
        }


    }
}