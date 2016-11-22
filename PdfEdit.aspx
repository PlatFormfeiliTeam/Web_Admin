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
    <script src="js/pan.js"></script>
     <style>
         html, body, form {
             height: 99%;
         }
         .input{
            width: 70%;
            text-align: left;
            background-color: #e5f1f4;
            border-top-style: none;
            border-right-style: none;
            border-left-style: none;
            border-bottom: green 1px solid;
        }
    </style>
    <script type="text/javascript">        
        var ordercode = getQueryString("ordercode");
        var userid = getQueryString("userid");
        var filetype = 44;
        var fileid = "";
        $(function () {

            iniform();
        
        });
        function iniform() {
            $.ajax({
                type: 'Post',
                url: "PdfEdit.aspx/SayHello",
                dataType: "text",
                data: { action: "loadform", ordercode: ordercode },
                async: false,
                success: function (data) {
                    alert(data);

                    //var obj = eval("(" + data + ")");//将字符串转为json
                    //var formdata = obj.formdata;
                    //$("#txt_Busitype").val(formdata["BUSITYPENAME"]);
                    //$("#txt_busiunit").val(formdata["BUSIUNITNAME"]);
                    //$("#txt_Splitstatus").val(formdata["FILESTATUSDESC"]);

                    //if (obj.success) {
                    //    var json = eval(obj.rows);
                        //var strul = "", strdiv = "";
                        //$.each(json, function (idx, item) {
                           
                        //    if (idx == 0) {
                        //        strul += '<li class="current">';
                        //        strdiv += '<div';
                        //    } else {
                        //        strul += '<li>';
                        //        strdiv += '<div class="hide"';
                        //    }
                        //    var newid = typeid + "_" + id;
                        //    html1 += '<button type="button" class="btn  btn-primary btn-sm" onclick="loadfile(\'' + newid + '\')"><i class="fa fa-file-pdf-o"></i>&nbsp;' + json.rows[i].FILETYPENAME + "_" + type_index + '</button>';
                        //}
                        //html1 += '</div>';
                        //toolbar.add(html1);
                    //}
                },  
                error: function (err) {
                    alert(1);
                }

            })

        }
        
    </script>
</head>
<body>
    <form id="form1" runat="server">  
        <div class="easyui-layout" style="height:100%;">
            <div region="north" style="height:120px;">
                <table style="width: 100%;height:100%;" cellpadding=" 0" cellspacing="0" >
                    <tr>
                        <td style="width:5%; text-align:right;">订单号：</td>
                        <td style="width:25%;"><asp:RadioButtonList ID="rbl_Code" runat="server"></asp:RadioButtonList></td>
                        <td style="width:25%">业务类型：<%--<input id="txt_Busitype" type="text" class="input" />--%><asp:TextBox ID="txt_Busitype" runat="server" CssClass="input"></asp:TextBox></td>
                        <td style="width:25%">经营单位：<%--<input id="txt_busiunit" type="text" class="input" />--%><asp:TextBox ID="txt_busiunit" runat="server" CssClass="input"></asp:TextBox></td>
                        <td style="width:25%">拆分状态：<%--<input id="txt_Splitstatus" type="text" class="input" />--%><asp:TextBox ID="txt_Splitstatus" runat="server" CssClass="input"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td style="width:5%; text-align:right;">订单文件：</td>
                        <td colspan="4" style="width:95%">
                            <asp:CheckBoxList ID="cbl_attach" runat="server"></asp:CheckBoxList>
                        </td>
                    </tr>
                </table>
            </div>           
            <div id="pdfdiv" region="center">
                <embed  id="pdf" width="100%" height="100%"></embed>
            </div>
            <div region="east" style="width:40%">
                <table id="appConId" class="easyui-datagrid" toolbar="#tb" style="height:600px;width:100%;"></table>
            </div>
        </div>
    </form>
</body>
</html>

    <%--        /*$('#appConId').datagrid({
                url: "PdfEdit.aspx",
                pagination: true,//显示分页
                pageSize: 20,//分页大小
                rownumbers: true,//行号
                striped: true,
                remoteSort: true,
                loadMsg: '数据加载中......',
                queryParams: {
                    'ordercode': ordercode, 'action': 'loadform'
                },
                columns: [],
                onClickRow: function (rowIndex, rowData) {
                    $('#appConId').datagrid('unselectAll');
                    $('#appConId').datagrid('selectRow', rowIndex);
                },
                onDblClickRow: function (rowIndex, rowData) {
                    opencenterwin("/AccountManagement/ChildEdit?ID=" + rowData.ID, 1000, 400);
                },
                onLoadSuccess: function (data) {
                    $('.pagination-page-list').hide();//隐藏PageList
                },
                onLoadError: function (XMLHttpRequest, textStatus, errorThrown) {//请求失败处理函数
                    alert(XMLHttpRequest.status); alert(XMLHttpRequest.responseText); document.write(XMLHttpRequest.responseText);
                    alert(XMLHttpRequest.readyState);
                    alert(textStatus);
                }
            });
            var pager = $('#appConId').datagrid('getPager');	// get the pager of datagrid*/--%>