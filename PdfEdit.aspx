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
         
        .datagrid-header td,
        .datagrid-body td,
        .datagrid-footer td {
          border-width: 0 1px 1px 0;
          border-style: solid;
          margin: 0;
          padding: 0;
        }
    </style>
    <script type="text/javascript">
        var ordercode = getQueryString("ordercode");
        var userid = getQueryString("userid");
        var filetype = 44;
        var fileid = "";
        var allow_sel;

        $(function () {
            iniform();
        });

        function iniform() {
            $.ajax({
                type: 'Post',
                url: "PdfEdit.aspx",
                dataType: "text",
                data: { ordercode: ordercode, action: 'loadform' },
                async: false,
                success: function (data) {
                    var obj = eval("(" + data + ")");//将字符串转为json
                    var formdata = obj.formdata;
                    $("#txt_Busitype").val(formdata["BUSITYPENAME"]);
                    $("#txt_busiunit").val(formdata["BUSIUNITNAME"]);
                    $("#txt_Splitstatus").val(formdata["FILESTATUSDESC"]);

                    if ($.trim($("#td_radio").text()) == "") {
                        $('<input />', {
                            type: "radio", name: "rdo", checked: "checked", val: formdata["CODE"],
                            change: function () {
                                ordercode = $(this).val();
                                iniform();
                            }
                        }).appendTo("#td_radio");
                        $("<span style='margin-right:50px;'>" + formdata["CODE"] + "</span>").appendTo("#td_radio");

                        if (formdata["ASSOCIATENO"] != "") {
                            $('<input />', {
                                type: "radio", name: "rdo", val: formdata["ASSOCIATENO"],
                                change: function () {
                                    ordercode = $(this).val();
                                    iniform();
                                }
                            }).appendTo("#td_radio");

                            $("<span style='margin-right:50px;'>" + formdata["ASSOCIATENO"] + "</span>").appendTo("#td_radio");
                        }
                    }

                    $("#td_cbl").text('');
                    var filedata = eval(obj.filedata);
                    for (var i = 0; i < filedata.length; i++) {
                        $('<input />', {
                            type: "checkbox", name: "cbox", val: filedata[i]["ID"],
                            change: function () {
                                fileid = $(this).val();
                                pdfview();
                            }
                        }).appendTo("#td_cbl");
                        $("<span style='margin-right:60px;'>订单文件" + (i + 1) + "</span>").appendTo("#td_cbl");
                    }

                    if (filedata.length == 1) {
                        $("input[name='cbox']").get(0).click(); /*$("input[name='cbox']").get(0).checked = true;  $("input[name='cbox']").trigger("change");*/
                    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {//请求失败处理函数  
                    alert(XMLHttpRequest.status);
                    alert(XMLHttpRequest.readyState);
                    alert(textStatus);
                }
            });

        }


        function pdfview() {
            $.ajax({
                type: 'Post',
                url: "PdfEdit.aspx",
                dataType: "text",
                data: { ordercode: ordercode, fileid: fileid, action: 'loadpdf' },
                async: false,
                success: function (data) {
                    var obj = eval("(" + data + ")");//将字符串转为json
                    var str = '<embed  id="pdf" width="100%" height="98%" src="/file/' + obj.src + '"></embed>';
                    $("#pdfdiv").html(str);
                    //按钮控制开始
                    var ordertatus = $("#txt_Splitstatus").val();
                    if (ordertatus == '已拆分') {//订单的拆分状态
                        $("#btn_merge").linkbutton('disable');
                        $("#btn_confirmsplit").linkbutton('disable');
                        allow_sel = false;
                        if (obj.filestatus == 0) {//文件的拆分状态
                            $("#btn_cancelsplit").linkbutton('disable');
                        }
                        else {
                            $("#btn_cancelsplit").linkbutton('enable');
                        }
                    }
                    else {
                        if ($("input[name='cbox']:checked").length > 1) {
                            $("#btn_merge").linkbutton('enable');
                        }
                        else {
                            $("#btn_merge").linkbutton('disable');
                        }
                        $("#btn_confirmsplit").linkbutton('enable');
                        allow_sel = true;
                        $("#btn_cancelsplit").linkbutton('disable');
                    }
                    //按钮控制结束 

                    var columnarray_frozen = new Array(); var columnarray = new Array();

                    for (var key in obj.rows[0]) {
                        switch (key) {
                            case "ID":
                                columnarray_frozen.push({
                                    title: '页码', field: key, width: 48, align: 'center', frozen: true, formatter: function (value, row, index) {
                                        return '第' + value + '页';
                                    }
                                });
                                columnarray_frozen.push({
                                    width: 48, title: '操作', field: '_operate', align: 'center', formatter: function (value, row, index) {
                                        return '<img alt="" src="/images/shared/arrow_up.gif" onclick="" /><img alt="" src="/images/shared/arrow_down.gif" onclick="" />';
                                    }
                                });
                                break;
                            default:
                                var start = key.indexOf("|");
                                var header = key.slice(start + 1);
                                columnarray.push({ title: header, field: key, width: 65, align: 'center' });
                                break;
                        }
                    }
                    var cols_frozen = new Array(columnarray_frozen); var cols = new Array(columnarray);

                    $('#appConId').datagrid({
                        singleSelect: true,
                        frozenColumns: cols_frozen,
                        columns: cols,
                        data: obj.rows,
                        onClickRow: function (index, row) {
                            var PDF = document.getElementById("pdf");
                            PDF.setCurrentPage(row["ID"]);
                        },
                        onClickCell: function (index, field, value) {
                            if (allow_sel) {
                                if (field != "ID") {
                                    var rows = $('#appConId').datagrid("getRows");
                                    rows[index][field] = value == "√" ? "" : "√";

                                    alert(rows[index][field]);

                                    //$('#appConId').datagrid('beginEdit', index);
                                    //var ed = $('#dg').datagrid('getEditor', { index: index, field: field });
                                    ////修改内容
                                    //ed.target.val('√');
                                    //$('#appConId').datagrid('endEdit', index);
                                    //$('#appConId').datagrid('updateRow', { index: index });
                                }
                            }
                        },
                        onLoadError: function (XMLHttpRequest, textStatus, errorThrown) {//请求失败处理函数
                            alert(XMLHttpRequest.status); alert(XMLHttpRequest.responseText); document.write(XMLHttpRequest.responseText);
                            alert(XMLHttpRequest.readyState);
                            alert(textStatus);
                        }
                    });
                    /*
                    //清除追加的button按钮
                        var times = toolbar.items.length
                        for (var i = 3; i < times; i++) {
                            var btn = toolbar.getComponent(3);//移除了第4个元素后，后面的元素会自动填充到第4的位置
                            if (btn) {
                                toolbar.remove(btn);
                            }
                        }
                        //拆分完成后添加拆分好文件类型的查看按钮    
                        for (var i = 0; i < json.result.length; i++) {
                            var id = json.result[i].ID;
                            var typeid = json.result[i].FILETYPEID;
                            var btn = Ext.create('Ext.Button', {
                                id: json.result[i].FILETYPEID + "_" + json.result[i].ID,
                                text: '<i class="iconfont">&#xe61d;</i>&nbsp;' + json.result[i].FILETYPENAME,
                                handler: function () {
                                    gridpanel.getStore().removeAll();
                                    loadfile(this.id);
                                }
                            })
                            toolbar.add(btn);
                        }
                    */
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {//请求失败处理函数  
                    alert(XMLHttpRequest.status);
                    alert(XMLHttpRequest.readyState);
                    alert(textStatus);
                }
            });
        }

        function AddAccount() {
            $("input[name='cbox']").each(function () {
                if (this.checked) {
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
                        <td style="width:25%;" id="td_radio">
                        </td>
                        <td style="width:25%">业务类型：<input id="txt_Busitype" type="text" class="input" readonly /></td>
                        <td style="width:25%">经营单位：<input id="txt_busiunit" type="text" class="input" readonly /></td>
                        <td style="width:25%">拆分状态：<input id="txt_Splitstatus" type="text" class="input"  readonly /></td>
                    </tr>
                    <tr>
                        <td style="width:5%; text-align:right;">订单文件：</td>
                        <td colspan="4" style="width:95%" id="td_cbl">
                        </td>
                    </tr>
                </table>
            </div>           
            <div id="pdfdiv" region="center"></div>
            <div region="east" style="width:40%">
                 <div id="tb" style="padding:5px;height:auto"> 
                    <div style="margin-bottom: 5px;">
                        <a id="btn_merge" href="#" class="easyui-linkbutton" iconcls="icon-add" plain="true" disabled="true" onclick="AddAccount()">文件合并</a>
                        <a id="btn_confirmsplit" href="#" class="easyui-linkbutton" iconcls="icon-edit" plain="true" disabled="true" onclick="EditAccount()">确定拆分</a>
                        <a id="btn_cancelsplit" href="#" class="easyui-linkbutton" iconcls="icon-remove" plain="true" disabled="true" onclick="DeleteAccount()">撤销拆分</a>
                    </div>          
                </div> 
                <table id="appConId" class="easyui-datagrid" toolbar="#tb" style="height:100%;width:100%;"></table>
            </div>
        </div>        
    </form>
</body>
</html>



                    <%--
                        


                        //var str = '<input type="radio" name="rdo" checked="checked" value="' + formdata["CODE"] + '" />' + formdata["CODE"];
                        //$("#td_radio").html(str);
                        
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
                    //}--%>

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