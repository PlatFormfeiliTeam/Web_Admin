<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Web_Admin.Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <link href="css/bootstrap32/css/bootstrap.min.css" rel="stylesheet" />
    <script src="js/jquery-1.8.2.min.js"></script>
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
                    </div>
                    <label for="password">登录密码</label>
                    <div class="input-group">
                        <span class="input-group-addon icon iconfont">&#xe608;</span>
                        <asp:TextBox ID="password" runat="server" CssClass="form-control" TextMode="Password"> </asp:TextBox>
                    </div>
                    <div style="height: 35px">
                        <asp:Label ID="lbl_msg" runat="server" Text="" Style=" color:red;"></asp:Label>                    
                    </div>
                    <asp:Button runat="server" ID='btn_login' OnClick="btn_login_Click" Text="登录" Height="40px"  Width="100%"/>
                    
                </form>
            </div>
        </div>

    </div>
</body>
</html>
