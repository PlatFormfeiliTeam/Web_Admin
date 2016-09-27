<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Web_Admin.Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <link href="css/bootstrap32/css/bootstrap.min.css" rel="stylesheet" />
    <script src="js/jquery-2.1.1.min.js"></script>
    <script src="css/bootstrap32/js/bootstrap.min.js"></script>
    <link href="css/common.css" rel="stylesheet" />
    <link href="css/iconfont/iconfont.css" rel="stylesheet" />
</head>
<body>
    <div class="container">
        <div style="margin: 5px 0px">
            <img src="Images/banner.jpg" />
        </div>
        <div style="height: 2px; background-color: #363c64"></div>
        <div class="container" style="padding-top: 80px">
            <div class="carousel slide" id="carousel-595514" data-ride="carousel" style="width: 645px; float: left">
                <ol class="carousel-indicators">
                    <li class="active" data-slide-to="0" data-target="#carousel-595514"></li>
                    <li data-slide-to="1" data-target="#carousel-595514"></li>
                    <li data-slide-to="2" data-target="#carousel-595514"></li>
                </ol>
                <div class="carousel-inner">
                    <div class="item active">
                        <img src="/Images/login_01.png" alt="" />
                    </div>
                    <div class="item">
                        <img src="/Images/login_02.png" alt="" />
                    </div>
                    <div class="item">
                        <img src="/Images/login_03.jpg" alt="" />
                    </div>
                </div>
            </div>
            <div style="border: 1px solid #363c64; float: right; width: 350px; padding: 50px 50px 35px 50px;">
                <form runat="server">
                    <label for="user_name">登录名</label>
                    <div class="input-group" style="margin-bottom: 20px">
                        <span class="input-group-addon ico iconfont">&#xe605;</span>
                        <asp:TextBox ID="user_name" runat="server" CssClass="form-control"> </asp:TextBox>
                        <%-- <input type="text" class="form-control" id="user_name" placeholder="请输入登录账号" />--%>
                    </div>
                    <label for="password">登录密码</label>
                    <div class="input-group">
                        <span class="input-group-addon icon iconfont">&#xe608;</span>
                        <asp:TextBox ID="password" runat="server" CssClass="form-control" TextMode="Password"> </asp:TextBox>
                        <%--  <input type="password" class="form-control" id="password" placeholder='请输入登录密码' />--%>
                    </div>
                    <div style="height: 35px">
                        <label style="color: red" id="validate"></label>
                    </div>
                    <asp:Button runat="server" ID='btn_login' OnClick="btn_login_Click" Text="登录" Height="40px"  Width="100%"/>
                </form>
            </div>
        </div>
        <script type="text/javascript">
            //$(document).ready(function () {
            //    $('#btn_login').bind('click', function () {
            //        var user_name = $("#user_name").val();
            //        var password = $("#password").val();
            //        if (!user_name) {
            //            $("#validate").text("账号不能为空!");
            //            return;
            //        }
            //        if (!password) {
            //            $("#validate").text("密码不能为空!");
            //            return;
            //        }
            //        //$.ajax({
            //        //    url: "Login.aspx?action=Login",
            //        //    data: { username: user_name, password: password },
            //        //    success: function (result) {
            //        //        alert(result);
            //        //        if (result == "success") {
            //        //            window.location.href = 'Home.aspx';
            //        //        }
            //        //        else {
            //        //            $("#validate").text(result);
            //        //        }
            //        //    }
            //        //});
            //    });
            //    $("input").bind('focus', function () {
            //        $("#validate").text("");
            //    });
            //});
        </script>

    </div>
</body>
</html>
