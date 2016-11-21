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
            /*var common_data_busitype = [
            { "CODE": "10", "NAME": "空运出口" }, { "CODE": "11", "NAME": "空运进口" },
            { "CODE": "20", "NAME": "海运出口" }, { "CODE": "21", "NAME": "海运进口" },
            { "CODE": "30", "NAME": "陆运出口" }, { "CODE": "31", "NAME": "陆运进口" },
            { "CODE": "40", "NAME": "国内出口" }, { "CODE": "41", "NAME": "国内进口" },
            { "CODE": "50", "NAME": "特殊区域出口" }, { "CODE": "51", "NAME": "特殊区域进口" }];

            var store_busitype = Ext.create('Ext.data.JsonStore', {
                fields: ['CODE', 'NAME'],
                data: common_data_busitype
            })*/

            $('#dg').datagrid({
                data: {
                    "total": 28, "rows": [
        { "productid": "FI-SW-01", "productname": "Koi", "unitcost": 10.00, "status": "P", "listprice": 36.50, "attr1": "Large", "itemid": "EST-1" },
        { "productid": "K9-DL-01", "productname": "Dalmation", "unitcost": 12.00, "status": "P", "listprice": 18.50, "attr1": "Spotted Adult Female", "itemid": "EST-10" },
        { "productid": "RP-SN-01", "productname": "Rattlesnake", "unitcost": 12.00, "status": "P", "listprice": 38.50, "attr1": "Venomless", "itemid": "EST-11" },
        { "productid": "RP-SN-01", "productname": "Rattlesnake", "unitcost": 12.00, "status": "P", "listprice": 26.50, "attr1": "Rattleless", "itemid": "EST-12" },
        { "productid": "RP-LI-02", "productname": "Iguana", "unitcost": 12.00, "status": "P", "listprice": 35.50, "attr1": "Green Adult", "itemid": "EST-13" },
        { "productid": "FL-DSH-01", "productname": "Manx", "unitcost": 12.00, "status": "P", "listprice": 158.50, "attr1": "Tailless", "itemid": "EST-14" },
        { "productid": "FL-DSH-01", "productname": "Manx", "unitcost": 12.00, "status": "P", "listprice": 83.50, "attr1": "With tail", "itemid": "EST-15" },
        { "productid": "FL-DLH-02", "productname": "Persian", "unitcost": 12.00, "status": "P", "listprice": 23.50, "attr1": "Adult Female", "itemid": "EST-16" },
        { "productid": "FL-DLH-02", "productname": "Persian", "unitcost": 12.00, "status": "P", "listprice": 89.50, "attr1": "Adult Male", "itemid": "EST-17" },
        { "productid": "AV-CB-01", "productname": "Amazon Parrot", "unitcost": 92.00, "status": "P", "listprice": 63.50, "attr1": "Adult Male", "itemid": "EST-18" }
                    ]
                }
            });
        });
    </script>
</head>
<body>
    <form id="form1" runat="server">  
        <div class="easyui-layout" style="height:100%;">
            <div region="north" style="height:120px;">
                <table style="width: 100%;height:100%;" cellpadding=" 0" cellspacing="0" >
                    <tr>
                        <td style="width:25%">订单号：<asp:RadioButtonList ID="rbl_Code" runat="server" Width="70%"></asp:RadioButtonList></td>
                        <td style="width:25%">业务类型：<asp:TextBox ID="txt_Busitype" runat="server" CssClass="input"></asp:TextBox></td>
                        <td style="width:25%">经营单位：<asp:TextBox ID="txt_busiunit" runat="server" CssClass="input"></asp:TextBox></td>
                        <td style="width:25%">拆分状态：<asp:TextBox ID="txt_Splitstatus" runat="server" CssClass="input"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td colspan="4">
                            订单文件：<asp:CheckBoxList ID="cbl_attach" runat="server"></asp:CheckBoxList>
                        </td>
                    </tr>
                </table>
            </div>           
            <div id="pdfdiv" region="center">
                <embed  id="pdf" width="100%" height="100%"></embed>
            </div>
            <div region="east" style="width:40%">
                <table id="dg" class="easyui-datagrid" title="Cell Editing in DataGrid" style="width:700px;height:auto"
		            data-options="iconCls: 'icon-edit',singleSelect: true,method:'get',onClickCell: onClickCell">
	                <thead>
		                <tr>
			                <th data-options="field:'itemid',width:80">Item ID</th>
			                <th data-options="field:'productid',width:100,editor:'text'">Product</th>
			                <th data-options="field:'listprice',width:80,align:'right',editor:{type:'numberbox',options:{precision:1}}">List Price</th>
			                <th data-options="field:'unitcost',width:80,align:'right',editor:'numberbox'">Unit Cost</th>
				                <th data-options="field:'attr1',width:250,editor:'text'">Attribute</th>
			                <th data-options="field:'status',width:60,align:'center',editor:{type:'checkbox',options:{on:'P',off:''}}">Status</th>
			            </tr>
	                </thead>
	            </table>
 
	<script type="text/javascript">
	    $.extend($.fn.datagrid.methods, {
	        editCell: function (jq, param) {
	            return jq.each(function () {
	                var opts = $(this).datagrid('options');
	                var fields = $(this).datagrid('getColumnFields', true).concat($(this).datagrid('getColumnFields'));
	                for (var i = 0; i < fields.length; i++) {
	                    var col = $(this).datagrid('getColumnOption', fields[i]);
	                    col.editor1 = col.editor;
	                    if (fields[i] != param.field) {
	                        col.editor = null;
	                    }
	                }
	                $(this).datagrid('beginEdit', param.index);
	                for (var i = 0; i < fields.length; i++) {
	                    var col = $(this).datagrid('getColumnOption', fields[i]);
	                    col.editor = col.editor1;
	                }
	            });
	        }
	    });
   	    		
   	    var editIndex = undefined;
   	    function endEditing() {
   	    	if (editIndex == undefined) { return true }
   	    	if ($('#dg').datagrid('validateRow', editIndex)) {
   	    		$('#dg').datagrid('endEdit', editIndex);
   	    		editIndex = undefined;
   	    		return true;
   	    	} else {
   	    		return false;
   	    	}
   	    }
        function onClickCell(index, field){
            if (endEditing()) {
                $('#dg').datagrid('selectRow', index).datagrid('editCell', {index:index,field:field});
                editIndex = index;
            }
        }
    </script>


            </div>
        </div>
    </form>
</body>
</html>