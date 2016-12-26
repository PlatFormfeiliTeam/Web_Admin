using Newtonsoft.Json;
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

        }

        //动态绑定类型
        public string Bind_rcbType()
        {
            sql = "select distinct type from  web_notice t  where t.isinvalid=0 order by type";
            dt = DBMgr.GetDataTable(sql);
            string json = JsonConvert.SerializeObject(dt);
            return json;
        }
    }
}