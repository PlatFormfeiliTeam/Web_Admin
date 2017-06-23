using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Services;
using ICSharpCode.SharpZipLib.Zip;
using ICSharpCode.SharpZipLib.Core;
using Web_Admin.Common;


namespace Web_Admin
{
    /// <summary>
    /// WsZip 的摘要说明
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // 若要允许使用 ASP.NET AJAX 从脚本中调用此 Web 服务，请取消注释以下行。 
    // [System.Web.Script.Services.ScriptService]
    public class WsZip : System.Web.Services.WebService
    {

        [WebMethod]
        public string getZipFile(string codelist)
        {
            string dir = @"d:/ftpserver/";
            string tmp_dir = @"d:/ftpserver/declare_tmp_zip/";
            if (!Directory.Exists(tmp_dir))
            {
                Directory.CreateDirectory(tmp_dir);
            }
            try
            {
                string sql = @"select A.*,B.DECLARATIONCODE from (select t.* from list_attachment t where t.filetype='61' and t.declcode in " + codelist + " order by pgindex asc,uploadtime asc) A"
                       + " left join list_declaration B on A.DECLCODE=B.CODE";
                DataTable dt = DBMgr.GetDataTable(sql);


                string filepath = string.Empty;
                MemoryStream ms = new MemoryStream();
                ZipEntryFactory zipEntryFactory = new ZipEntryFactory();
                ZipFile zipFile = new ZipFile(ms);
                string filename = DateTime.Now.ToString("yyyyMMddhhmmssff") + ".zip";
                string newfilename = string.Empty;
                string sourcefile = string.Empty;
                using (ZipOutputStream outPutStream = new ZipOutputStream(System.IO.File.Create(tmp_dir + filename)))
                {

                    outPutStream.SetLevel(5);
                    ZipEntry entry = null;
                    byte[] buffer = null;
                    foreach (DataRow dr in dt.Rows)
                    {
                        sourcefile = dr["FILENAME"].ToString();
                        filepath = dir + sourcefile;
                        newfilename =dr["DECLARATIONCODE"].ToString() + sourcefile.Substring(sourcefile.LastIndexOf("."));
                        buffer = new byte[4096];
                        entry = zipEntryFactory.MakeFileEntry(newfilename);
                        outPutStream.PutNextEntry(entry);
                        using (FileStream fileStream = File.OpenRead(filepath))
                        {
                            StreamUtils.Copy(fileStream, outPutStream, buffer);

                        }
                    }
                    outPutStream.Finish();
                    outPutStream.Close();

                }

                GC.Collect();
                GC.WaitForPendingFinalizers();

                return  "/file/declare_tmp_zip/" + filename;
            }
            catch (Exception)
            {
                
                throw;
            }
           


        }
    }
}
