using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;
using System.Data;
using System.IO;
using Web_Admin.Common;
using Newtonsoft.Json.Linq;


namespace Web_Admin
{
    public partial class CollectInforCateEdit : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string sql = "";
            string action = Request["action"];
            string id = Request["id"]; string rid_type = Request["rid_type"];
            string URL = string.Empty; string NAME = string.Empty; string ISINVALID = string.Empty; string ICON = string.Empty; string ICON_OLD = string.Empty;
            string result = "{success:true}"; string fileName = ""; string strGuid = ""; string savepath = ""; string formdata = "";
            string webpath = System.Web.HttpContext.Current.Request.PhysicalApplicationPath;
            switch (action)
            {
                case "create":
                    formdata = Request["formdata"];
                    JObject json = (JObject)JsonConvert.DeserializeObject(formdata);
                    URL = json.Value<string>("URL"); NAME = json.Value<string>("NAME"); ISINVALID = json.Value<string>("ISINVALID");

                    HttpPostedFile postedFile = Request.Files["ICON"];//获取上传信息对象  
                    fileName = Path.GetFileName(postedFile.FileName);
                    System.Drawing.Image image = System.Drawing.Image.FromStream(postedFile.InputStream);

                    if ((image.Height >= 58 && image.Height <= 62) && (image.Width >= 44 && image.Width <= 48))
                    {
                        savepath = Server.MapPath(@"/FileUpload/InforCate/");
                        strGuid = Guid.NewGuid().ToString();
                        ICON = @"/FileUpload/InforCate/" + strGuid + "_" + fileName;
                        sql = @"insert into list_collect_infor (ID,ICON,URL,NAME,ISINVALID,CREATEDATE,RID_TYPE) 
                                values (LIST_COLLECT_INFOR_ID.nextval,'" + ICON + "','" + URL + "','" + NAME + "','" + ISINVALID + "',sysdate,'" + rid_type + "')";
                        DBMgr.ExecuteNonQuery(sql);
                        postedFile.SaveAs(savepath + strGuid + "_" + fileName);//保存

                    }
                    else
                    {
                        result = "{success:false}";
                    }
                    Response.Write(result);
                    Response.End();
                    break;
                case "update":
                    formdata = Request["formdata"];
                    json = (JObject)JsonConvert.DeserializeObject(formdata);
                    URL = json.Value<string>("URL"); NAME = json.Value<string>("NAME"); ISINVALID = json.Value<string>("ISINVALID");ICON_OLD= json.Value<string>("ICON_OLD");

                    sql = @"update list_collect_infor set URL='" + URL + "',NAME='" + NAME + "',ISINVALID='" + ISINVALID + "'";

                    HttpPostedFile postedFile_update = Request.Files["ICON"];//获取上传信息对象  
                    if (postedFile_update.FileName != "")
                    {
                        fileName = Path.GetFileName(postedFile_update.FileName);
                        System.Drawing.Image image_update = System.Drawing.Image.FromStream(postedFile_update.InputStream);
                        if ((image_update.Height >= 58 && image_update.Height <= 62) && (image_update.Width >= 44 && image_update.Width <= 48))
                        {
                            savepath = Server.MapPath(@"/FileUpload/InforCate/");
                            strGuid = Guid.NewGuid().ToString();
                            ICON = @"/FileUpload/InforCate/" + strGuid + "_" + fileName;
                            sql = sql + ",ICON='" + ICON + "'";

                            sql = sql + " where id = '" + id + "'";
                            DBMgr.ExecuteNonQuery(sql);

                            if (File.Exists(webpath + ICON_OLD)) { File.Delete(webpath + ICON_OLD); }
                            postedFile_update.SaveAs(savepath + strGuid + "_" + fileName); //保存

                        }
                        else
                        {
                            result = "{success:false}";
                        }
                    }
                    else
                    {
                        sql = sql + " where id = '" + id + "'";
                        DBMgr.ExecuteNonQuery(sql);
                    }
                    


                    Response.Write(result);
                    Response.End();
                    break;
                case "loadform":
                    sql = @"select ID,NAME,ICON,URL,ISINVALID,ICON ICON_OLD from list_collect_infor  where id = '" + id + "'";
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