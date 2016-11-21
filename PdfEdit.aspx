<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PdfEdit.aspx.cs" Inherits="Web_Admin.PdfEdit" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <link rel="stylesheet" type="text/css" href="js/jquery-easyui-1.4.5/themes/default/easyui.css" />
    <link rel="stylesheet" type="text/css" href="js/jquery-easyui-1.4.5/themes/icon.css" />
    <script type="text/javascript" src="js/jquery-easyui-1.4.5/jquery.min.js"></script>
    <script type="text/javascript" src="js/jquery-easyui-1.4.5/jquery.easyui.min.js" ></script>
    <%--<script>
        $(function () {
            $(window).resize(function () {
                $("form.easyui-layout").layout("resize");
            });
        });
    </script>--%>
</head>
<body>
   <%--<form id="form1" runat="server">  --%>
       <div class="easyui-layout">
            <div region="north" style="height:120px">dede</div>
            <div region="west" style="width:100px" title="导航菜单" split="true">左侧</div>
            <div region="center">主工作区</div>
            <div region="east" style="width:500px">dede
            </div>
            <div region="south">底部</div>
        </div>
   <%--</form>--%>
</body>
</html>
