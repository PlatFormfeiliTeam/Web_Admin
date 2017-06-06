using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Data;
using System.IO;
using System.Web;
using Web_Admin.Common;

namespace Web_Admin
{
    public partial class CarouselAdEdit : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string sql = "";
            string action = Request["action"];
            string id = Request["id"];
            string result = "{success:true}";

            switch (action)
            {
                case "create":
                    string formdata = Request["formdata"];
                    JObject json = (JObject)JsonConvert.DeserializeObject(formdata);                 
                    string LINKURL = json.Value<string>("LINKURL");
                    string DESCRIPTION = json.Value<string>("DESCRIPTION");
                    string STATUS = json.Value<string>("STATUS");
                    string SORTINDEX = json.Value<string>("SORTINDEX");

                    HttpPostedFile postedFile = Request.Files["IMGURL"];//获取上传信息对象  
                    string fileName = Path.GetFileName(postedFile.FileName);
                    System.Drawing.Image image=System.Drawing.Image.FromStream(postedFile.InputStream);
                    int  hig = image.Height; 
                    int  wid = image.Width;

                    if ((hig < 458 && hig > 462) || (wid < 1918 && wid < 1922))
                    {
                        result = "{success:false}";
                    }
                    else
                    {
                        string savepath = Server.MapPath(@"\FileUpload\Banner\");
                        string strGuid = Guid.NewGuid().ToString();
                        string IMGURL = @"\FileUpload\Banner\" + strGuid + "_" + fileName;
                        sql = @"insert into WEB_BANNER (ID,IMGURL,LINKURL,DESCRIPTION,STATUS,FILENAME,SORTINDEX) values ('" + strGuid + "','" + IMGURL + "','" + LINKURL + "','" + DESCRIPTION + "','" + STATUS + "','" + fileName + "','" + SORTINDEX + "')";
                        DBMgr.ExecuteNonQuery(sql);
                        postedFile.SaveAs(savepath + strGuid + "_" + fileName);//保存
                    }                    
                    Response.Write(result);
                    Response.End();
                    break;
                case "update":
                    formdata = Request["formdata"];
                    json = (JObject)JsonConvert.DeserializeObject(formdata);
                    LINKURL = json.Value<string>("LINKURL");
                    DESCRIPTION = json.Value<string>("DESCRIPTION");
                    STATUS = json.Value<string>("STATUS");
                    SORTINDEX = json.Value<string>("SORTINDEX");
                    sql = @"update WEB_BANNER set LINKURL='" + LINKURL + "',DESCRIPTION='" + DESCRIPTION + "',STATUS='" + STATUS + "',SORTINDEX='" + SORTINDEX + "' where id = '" + id + "'";
                    DBMgr.ExecuteNonQuery(sql);
                   // ts.Execute(sql, null, "");
                    Response.Write("{success:true}");
                    Response.End();
                    break;
                case "loadform":
                    sql = @"select ID,IMGURL,LINKURL,DESCRIPTION,STATUS,FILENAME,SORTINDEX from WEB_BANNER  where id = '" + id + "'";
                    //QueryDataObject qdo = ts.Query(sql, null, false, null);
                    //DataTable ents = qdo.dsk__BackingField.Tables[0];
                    DataTable ents = DBMgr.GetDataTable(sql);
                    string json2 = "";
                    json2 = JsonConvert.SerializeObject(ents);
                    json2 = json2.TrimStart('[').TrimEnd(']');
                    Response.Write("{success:true,data:" + json2 + "}");
                    Response.End();
                    break;
            }
        }
    }
}