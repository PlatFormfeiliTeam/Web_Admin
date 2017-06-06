using Newtonsoft.Json;
using System;
using System.Data;
using System.IO;
using Web_Admin.Common;

namespace Web_Admin
{
    public partial class CarouselAdList : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string sql = "";
            string action = Request["action"];
            DataTable dt;
            switch (action)
            {
                case "select":
                    sql = @"select ID,IMGURL,LINKURL,DESCRIPTION,STATUS,FILENAME,SORTINDEX from web_banner order by SORTINDEX";
                    dt = DBMgr.GetDataTable(sql);
                    string json = JsonConvert.SerializeObject(dt);
                    Response.Write("{rows:" + json + "}");
                    Response.End();
                    break;
                case "delete":
                    //先删除对应的本地文件
                    sql = "select * from web_banner where id='" + Request["id"] + "'";
                    dt = DBMgr.GetDataTable(sql);
                    string path = Server.MapPath(dt.Rows[0]["IMGURL"] + "");
                    if (File.Exists(path))
                    {
                        File.Delete(path);
                    }
                    sql = @"delete from web_banner where id = '" + Request["id"] + "'";
                    DBMgr.ExecuteNonQuery(sql);
                    break;
            }
        }
    }
}