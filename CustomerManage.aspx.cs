using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
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
    public partial class CustomerManage : System.Web.UI.Page
    {
        IsoDateTimeConverter iso = new IsoDateTimeConverter();//序列化JSON对象时,日期的处理格式
        int totalProperty = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            string action = Request["action"];
            iso.DateTimeFormat = "yyyy-MM-dd HH:mm:ss";
            
            switch (action)
            {
                case "loadData":
                    loadData();
                    break;
                case "delete":
                    deleteData();
                    break;
                case "export":
                    exportData();
                    break;
            }
        }
        /// <summary>
        /// 加载数据
        /// </summary>
        private void loadData()
        {
            string strWhere = string.Empty;

            if (!string.IsNullOrEmpty(Request["code"]))
            {
                strWhere = " and code='" + Request["code"] + "'";
            }
            if (!string.IsNullOrEmpty(Request["cnname"]))
            {
                strWhere = " and (name like '%" + Request["cnname"] + "%' or chineseabbreviation like '%" + Request["cnname"] + "%')";
            }
            if (!string.IsNullOrEmpty(Request["enname"]))
            {
                strWhere = " and englishname like '%" + Request["enname"] + "%'";
            }
            if (!string.IsNullOrEmpty(Request["hscode"]))
            {
                strWhere = " and hscode='" + Request["hscode"] + "'";
            }
            if (!string.IsNullOrEmpty(Request["ciqcode"]))
            {
                strWhere = " and ciqcode='" + Request["ciqcode"] + "'";
            }
            if (!string.IsNullOrEmpty(Request["enabled"]))
            {
                strWhere = " and enabled='" + Request["enabled"] + "'";
            }
            string sql = "select * from cusdoc.sys_customer where 1=1 " + strWhere;
            sql = Extension.GetPageSql(sql, "ID", "desc", ref totalProperty, Convert.ToInt32(Request["start"]), Convert.ToInt32(Request["limit"]));
            DataTable dt = DBMgr.GetDataTable(sql);
            string json = JsonConvert.SerializeObject(dt, iso);
            Response.Write("{rows:" + json + ",total:" + totalProperty + "}");
            Response.End();
        }
        /// <summary>
        /// 删除数据
        /// </summary>
        /// <param name="id"></param>
        private void deleteData()
        {
            string id = Request["ID"];
            string sql = "delete from cusdoc.sys_customer where id='{0}'";
            string str = DBMgr.ExecuteNonQuery(string.Format(sql, id)) > 0 ? "true" : "false";
            Response.Write("{\"success\":" + str + "}");
            Response.End();
        }
        private void exportData()
        {
            string sql = @"SELECT * FROM cusdoc.sys_customer order by id desc";
            DataTable dt = DBMgr.GetDataTable(sql);

            //创建Excel文件的对象
            NPOI.HSSF.UserModel.HSSFWorkbook book = new NPOI.HSSF.UserModel.HSSFWorkbook();
            //添加一个导出成功sheet
            NPOI.SS.UserModel.ISheet sheet_S = book.CreateSheet("客商信息");
            NPOI.SS.UserModel.IRow row1 = sheet_S.CreateRow(0);
            row1.CreateCell(0).SetCellValue("代码"); 
            row1.CreateCell(1).SetCellValue("海关代码");
            row1.CreateCell(2).SetCellValue("国检代码");
            row1.CreateCell(3).SetCellValue("中文名称");
            row1.CreateCell(4).SetCellValue("中文简称");
            row1.CreateCell(5).SetCellValue("中文地址");
            row1.CreateCell(6).SetCellValue("英文名称");
            row1.CreateCell(7).SetCellValue("英文地址");
            row1.CreateCell(8).SetCellValue("是否启用");
            row1.CreateCell(9).SetCellValue("备注");
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                NPOI.SS.UserModel.IRow rowtemp = sheet_S.CreateRow(i + 1);
                rowtemp.CreateCell(0).SetCellValue(dt.Rows[i]["CODE"].ToString());
                rowtemp.CreateCell(1).SetCellValue(dt.Rows[i]["HSCODE"].ToString());
                rowtemp.CreateCell(2).SetCellValue(dt.Rows[i]["CIQCODE"].ToString());
                rowtemp.CreateCell(3).SetCellValue(dt.Rows[i]["NAME"].ToString());
                rowtemp.CreateCell(4).SetCellValue(dt.Rows[i]["CHINESEABBREVIATION"].ToString());
                rowtemp.CreateCell(5).SetCellValue(dt.Rows[i]["CHINESEADDRESS"].ToString());
                rowtemp.CreateCell(6).SetCellValue(dt.Rows[i]["ENGLISHNAME"].ToString());
                rowtemp.CreateCell(2).SetCellValue(dt.Rows[i]["ENGLISHADDRESS"].ToString());
                rowtemp.CreateCell(8).SetCellValue(dt.Rows[i]["ENABLED"].ToString() == "1" ? "是" : "否");
                rowtemp.CreateCell(9).SetCellValue(dt.Rows[i]["REMARK"].ToString());
            }
            try
            {
                // 输出Excel
                string filename = "客商信息.xls";
                Response.ContentType = "application/vnd.ms-excel";
                Response.AddHeader("Content-Disposition", string.Format("attachment;filename={0}", Server.UrlEncode(filename)));
                Response.Clear();

                MemoryStream ms = new MemoryStream();
                book.Write(ms);
                Response.BinaryWrite(ms.GetBuffer());
                Response.End();
            }
            catch(Exception e)
            {
                Console.WriteLine(e.Message);
            }
            
        }
    }
}