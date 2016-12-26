<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="NoticeEdit.aspx.cs" Inherits="Web_Admin.NoticeEdit" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <script src="/js/jquery-1.8.2.min.js"></script>
    <link href="/css/bootstrap32/css/bootstrap.min.css" rel="stylesheet" />

    <script type="text/javascript" src="/js/ueditor/ueditor.config.js"></script>
    <script type="text/javascript" src="/js/ueditor/ueditor.all.min.js"></script>
    <script type="text/javascript" src="/js/ueditor/lang/zh-cn/zh-cn.js"></script>

    <script src="/js/pan.js" type="text/javascript"></script>

    <style type="text/css">
        .input {
            text-align: left;
            background-color: #e5f1f4;
            border-top-style: none;
            border-right-style: none;
            border-left-style: none;
            border-bottom: green 1px solid;
        }
    </style>

    <script type="text/javascript">
        var option = getQueryString("option");

        $(document).ready(function () {
            
            initform(option);

            $("#btnCancel").click(function () {
                window.close();
            });

            $("#btnSubmit").click(function () {
                document.getElementById("form1").submit();
            });

        });

        function initform(option) {
            //绑定select
            var strjoson = eval('<%=Bind_rcbType()%>');
            $.each(strjoson, function (i) {
                $("#rcbType").append($("<option/>").text(this.TYPE).attr("value", this.TYPE));
            });

            //$("#img_att").css("display", "none");
            //$("#a_att").css("display", "none");

            if (option == "update") {
                var rcbType = "<%=rcbType %>";
                 if (rcbType != null && rcbType.length > 0) {
                     $("#rcbType").find("option[value='" + rcbType + "']").attr("selected", true);
                 }

                 var rcbIsinvalid = "<%=rcbIsinvalid %>";
                if (rcbIsinvalid != null && rcbIsinvalid.length > 0) {
                    if (rcbIsinvalid == "0") {
                        $("#rd_y").attr("selected", true);
                    }
                    if (rcbIsinvalid == "1") {
                        $("#rd_n").attr("selected", true);
                    }
                }

               <%-- var att = "<%=ATTACHMENT %>";
                if (att == "") {
                    $("#img_att").css("display", "none");
                    $("#a_att").css("display", "none");
                } else {
                    var tp = (att.substring(att.lastIndexOf("."))).toLowerCase();

                    if (tp != ".jpg" && tp != ".jpeg" && tp != ".gif" && tp != ".png" && tp != ".swf") {
                        $("#img_att").css("display", "none");
                    } else {
                        $("#img_att").css("display", "block");
                    }
                    $("#a_att").css("display", "block");
                }--%>

            }
        }

        var _editor = UE.getEditor('reContent');
        _editor.ready(function () {
            _editor.setContent('<%=reContent %>');
            _editor.addListener('beforeInsertImage', function (t, arg) { })
            _editor.addListener('afterUpfile', function (t, arg) { })
        });

        var ue = UE.getEditor("container");
        ue.ready(function () {
            //设置编辑器不可用
            //<pre name="code" class="html">container<span style="font-family: Arial, Helvetica, sans-serif;">.setDisabled();</span>
            //隐藏编辑器，因为不会用到这个编辑器实例，所以要隐藏 
            $("#container").hide();
         });

    </script>
</head>
<body>
    <form id="form1" runat="server">
        <input type="hidden" id="rtbID" name="rtbID" value="<%=rtbID %>" />
        <div class="panel panel-primary">
            <div class="panel-heading">资讯管理-新增||修改</div>
            <div class="panel-body">
                <table class="table table-bordered">
                    <tr>
                        <td style="width: 15%">
                            <label>标题</label>
                        </td>
                        <td>
                            <input type="text" style="width:100%;" id="rtbTitle" name="rtbTitle" value="<%=rtbTitle %>" class="input" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label>类型</label>
                        </td>
                        <td>
                            <select id="rcbType" name="rcbType" style="width:30%;"></select>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label>是否启用</label></td>
                        <td>
                            <input id="rd_y" type="radio" name="rd_valid" value="0" checked="checked" />是
                            &nbsp; &nbsp;&nbsp; &nbsp;
                            <input id="rd_n" type="radio" name="rd_valid" value="1" />否
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label>附件</label></td>
                        <td>
                           <script id="container" name="content" type="text/plain" style="width:100%;height:500px;">
                            </script>

                            <%--<img id="img_att" style="width:80px; height:40px;" src="<%=ATTACHMENT %>" />
                            <a id="a_att" onclick="opencenterwin('<%=ATTACHMENT %>', 1200, 600);"><span style="font-size:13px;">查看原件</span></a>
                            <input type="hidden" id="iatt" name="iatt" value="<%=ATTACHMENT %>" />   
                             
                            <input type="text" name="upfile" id="upfile" style="width:90%;" />  
                            <input type="button" value="选择文件" onclick="rtbAttachment.click()" 
                                style="border:1px solid #888888;background:#fff;padding-top:2px; padding-bottom:2px;border-radius:4px;" />  

                            <input type="file" id="rtbAttachment" name="rtbAttachment" style="display:none"  onchange="upfile.value=this.value" />  --%>       
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label>内容</label></td>
                        <td>
                            <textarea id="reContent"  name="reContent" style="width:100%;height:300px;"></textarea>
                        </td>
                    </tr>
                </table>

            </div>
            <div class=" panel-footer" style="text-align: center">
                <div class="btn-block">
                    <a id="btnSubmit" class="btn btn-primary btn-sm"><span class="fa fa-floppy-o"></span><strong>保 存</strong></a> 
                    <a id="btnCancel" class="btn btn-primary btn-sm"><span class="fa fa-undo"></span><strong>关 闭</strong></a>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
