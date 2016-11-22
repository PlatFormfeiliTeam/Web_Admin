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

            //pdfview();
        
        });
        function pdfview() {
            $.ajax({
                type: 'Post',
                url: "PdfEdit.aspx/loadpdf",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: "{ordercode:'" + ordercode + "',fileid:'" + fileid + "'}",
                async: false,
                success: function (data) {
                    //alert(data);

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
                error: function (XMLHttpRequest, textStatus, errorThrown) {//请求失败处理函数  
                    alert(XMLHttpRequest.status);
                    alert(XMLHttpRequest.readyState);
                    alert(textStatus);
                }

            })

        }
        
        function loadfile(id) {
            //var array1 = id.split('_');
            //Ext.Ajax.request({
            //    url: "PdfEdit.aspx?action=loadfile&fileid=" + array1[1],
            //    success: function (response) {
            //        var box = document.getElementById('pdfdiv');
            //        if (response.responseText) {
            //            var json = Ext.decode(response.responseText);
            //            var str = '<embed id="pdf" width="100%" height="100%" src="' + json.src + '"></embed>';
            //            box.innerHTML = str;
            //        }
            //    }
            //});
        }
       
        $("#cbl_attach").change(function () {
            alert(1); 
        });
        function AddAccount() {
            $("input[name^='cbl_attach']").each(function () {
                alert($(this).val());
                if ($(this).attr("checked")) {
                    alert($(this).val());
                }
            });
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
                        <td style="width:25%;"><asp:RadioButtonList ID="rbl_Code" runat="server" RepeatDirection="Horizontal" AutoPostBack="true"></asp:RadioButtonList></td>
                        <td style="width:25%">业务类型：<asp:TextBox ID="txt_Busitype" runat="server" CssClass="input" ReadOnly="true"></asp:TextBox></td>
                        <td style="width:25%">经营单位：<asp:TextBox ID="txt_busiunit" runat="server" CssClass="input" ReadOnly="true"></asp:TextBox></td>
                        <td style="width:25%">拆分状态：<asp:TextBox ID="txt_Splitstatus" runat="server" CssClass="input" ReadOnly="true"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td style="width:5%; text-align:right;">订单文件：</td>
                        <td colspan="4" style="width:95%">
                            <asp:CheckBoxList ID="cbl_attach" runat="server" RepeatDirection="Horizontal"></asp:CheckBoxList>
                        </td>
                    </tr>
                </table>
            </div>           
            <div id="pdfdiv" region="center">
                <embed  id="pdf" width="100%" height="100%"></embed>
            </div>
            <div region="east" style="width:40%">
                 <div id="tb" style="padding:5px;height:auto"> 
                    <div style="margin-bottom: 5px;">
                        <a href="#" class="easyui-linkbutton" iconcls="icon-add" plain="true" onclick="AddAccount()">文件合并</a>
                        <a href="#" class="easyui-linkbutton" iconcls="icon-edit" plain="true" onclick="EditAccount()">确定拆分</a>
                        <a href="#" class="easyui-linkbutton" iconcls="icon-remove" plain="true" onclick="DeleteAccount()">撤销拆分</a>
                    </div>   
        
                </div> 
                <table id="appConId" class="easyui-datagrid" toolbar="#tb"></table> <%--style="height:600px;width:100%;"--%>
            </div>
        </div>        
        <asp:TextBox ID="txt_ordercode" runat="server" ReadOnly="true"></asp:TextBox>
        <asp:TextBox ID="txt_field" runat="server" ReadOnly="true"></asp:TextBox>
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