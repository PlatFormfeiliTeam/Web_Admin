using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using Web_Admin.Common;

namespace Web_Admin
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string action = Request["action"];
            switch (action)
            {
                case "Login":

                    break;
            }
        }

        protected void btn_login_Click(object sender, EventArgs e)
        {
            string returnUrl = Request["ReturnUrl"] + "";
            string username = this.user_name.Text;
            string password = this.password.Text;
            string sql = "select * from sys_user where name = '" + username + "' and password = '" + Extension.ToSHA1(password) + "'";
            DataTable dt = DBMgr.GetDataTable(sql);
            string msg = "";
            if (dt.Rows.Count > 0)
            {
                if (dt.Rows[0]["TYPE"] + "" == "4")
                {
                    msg = "内部账号不允许登录!";
                }
                if (dt.Rows[0]["ENABLED"] + "" != "1")
                {
                    msg = "账号已停用!";
                }
            }
            else
            {
                msg = "账号/密码错误!";
            }

            if (string.IsNullOrEmpty(msg))
            {
                FormsAuthentication.SetAuthCookie(username, false);
                if (!string.IsNullOrEmpty(returnUrl) && returnUrl!="/")
                {
                    Response.Redirect(returnUrl);
                }
                else
                {
                    Response.Redirect("Home.aspx");
                }

                // FormsAuthenticationTicket ticket = new FormsAuthenticationTicket(username, true, 300);
                //  FormsAuthentication.RedirectFromLoginPage(username, false);
                //Session["user"] = username;
                // msg = "success";
            }
            else
            {
                //Response.Write(msg);
                //Response.End();
            }

        }
    }
}