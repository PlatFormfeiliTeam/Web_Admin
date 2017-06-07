<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="addCustomer.aspx.cs" Inherits="Web_Admin.addCustomer" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>

    <title></title>
     <link href="/Extjs42/resources/css/ext-all-gray.css" rel="stylesheet" type="text/css" />
    <script src="/Extjs42/bootstrap.js" type="text/javascript"></script>
    <script src="js/pan.js"></script>
    <link href="/css/iconfont/iconfont.css" rel="stylesheet" />

    <script type="text/javascript">
        var id = getQueryString("id");
        Ext.onReady(function () {
            var txtCode = Ext.create('Ext.form.field.Text', {
                id: 'code',
                name:'CODE',
                fieldLabel: '客户代码',
                width: 180,
                labelWidth: 60
            });
            var txtCNAbbrev = Ext.create('Ext.form.field.Text', {
                id: 'cnabbrev',
                name:'CHINESEABBREVIATION',
                fieldLabel: '中文简称',
                width: 180,
                labelWidth: 60
            });
            var txtCNName = Ext.create('Ext.form.field.Text', {
                id: 'cnname',
                name:'NAME',
                fieldLabel: '中文名称',
                width: 180,
                labelWidth: 60
            });
            var txtCNAddress = Ext.create('Ext.form.field.Text', {
                id: 'cnaddress',
                name:'CHINESEADDRESS',
                fieldLabel: '中文地址',
                width: 180,
                labelWidth: 60
            });
            
            var txtHSCode = Ext.create('Ext.form.field.Text', {
                id: 'hscode',
                name:'HSCODE',
                fieldLabel: '海关编码',
                width: 180,
                labelWidth: 60
            });
            var txtCIQCode = Ext.create('Ext.form.field.Text', {
                id: 'ciqcode',
                name:'CIQCODE',
                fieldLabel: '国检代码',
                width: 180,
                labelWidth: 60

            });
            var txtENName = Ext.create('Ext.form.field.Text', {
                id: 'enname',
                name:'ENGLISHNAME',
                fieldLabel: '英文名称',
                width: 180,
                labelWidth: 60
            });
            var txtENAddress = Ext.create('Ext.form.field.Text', {
                id: 'enaddress',
                name:'ENGLISHADDRESS',
                fieldLabel: '英文地址',
                width: 180,
                labelWidth: 60
            });
            var txtRemark = Ext.create('Ext.form.field.Text', {
                id: 'remark',
                name:'REMARK',
                fieldLabel: '备注',
                width: 780,
                labelWidth: 60
            });

            var enstore = Ext.create('Ext.data.Store', {
                fields: ['code', 'name'],
                data: [
                    { "code": "0", "name": "否" },
                    { "code": "1", "name": "是" }
                ]
            });
            var combEnabled = Ext.create('Ext.form.field.ComboBox', {
                id: 'enabled',
                name:'ENABLED',
                fieldLabel: '是否启用',
                store: enstore,
                displayField: 'name',
                valueField: 'code',
                width: 180,
                labelWidth: 60
            });

            var chkcustomer = Ext.create("Ext.form.field.Checkbox", {
                id: 'customerid',
                name:'ISCUSTOMER',
                boxLabel: '客户',
                width: 85,
            });
            var chkshipper = Ext.create("Ext.form.field.Checkbox", {
                id: 'shipperid',
                name:'ISSHIPPER',
                boxLabel: '供应商',
                width: 85,
            });
           
            var chkcompany = Ext.create("Ext.form.field.Checkbox", {
                id: 'companyid',
                name:'ISCOMPANY',
                boxLabel: '生产型企业',
                width: 100,
            });
            var chkdocservice = Ext.create("Ext.form.field.Checkbox", {
                id: 'docserviceid',
                name:'DOCSERVICECOMPANY',
                boxLabel: '单证服务单位',
                width: 110,
            });
            var chklogicaudit = Ext.create("Ext.form.field.Checkbox", {
                id: 'logicauditid',
                name:'LOGICAUDITFLAG',
                boxLabel: '逻辑审核强制通过',
                width: 120,
            });
            var btnSave = Ext.create("Ext.Button", {
                id: 'saveid',
                handler: function () {
                    var formdata = Ext.encode(Ext.getCmp('formpanel').getForm().getValues());
                    Ext.Ajax.request({
                        //url: 'addCustomer.aspx?action=save&formdata='+formdata,
                        url: 'addCustomer.aspx',
                        type: 'Post',
                        params: { action: 'save', formdata: formdata, ID: id },
                        success: function (response, option) {
                            var data = Ext.decode(response.responseText);
                            if (data.success) {
                                Ext.MessageBox.alert("保存成功");
                            }
                            else {
                                Ext.MessageBox.alert("保存失败");
                            }
                            
                        }
                    })
                    
                },
                text: '保 存',
                width: '80'
            });
            var btnBack = Ext.create("Ext.Button", {
                id: 'backid',
                text: '返 回',
                width: '80',
                handler:function()
                {
                    //window.opener.location.href = window.opener.location.href;//刷新父页面
                    window.opener.refreshData();
                    window.close();
                    
                }
            });
            var tbar1 = Ext.create("Ext.toolbar.Toolbar", {
                items:[btnSave,btnBack]
            })

            var colItem = [
                    { layout: 'column', height: 62, border: 0, items: [txtCode, txtCNAbbrev, txtCNName, txtCNAddress] },
                    { layout: 'column', height: 62, border: 0, items: [txtHSCode, txtCIQCode, txtENName, txtENAddress] },
                    { layout: 'column', height: 62, border: 0, items: [combEnabled, chkcustomer, chkshipper, chkcompany, chkdocservice, chklogicaudit] },
                    { layout: 'column', height: 62, border: 0, items: [txtRemark] }
            ];
            var mianPnl = Ext.create("Ext.form.Panel", {
                id: 'formpanel',
                renderTo: 'fpanel',
                border: 1,
                width: 820,
                tbar: tbar1,
                fieldDefaults: {
                    margin: '20 0 0 20',
                    labelWidth: 80,
                },
                items: colItem
            });
            Ext.Ajax.request({
                url: 'addCustomer.aspx?action=initData',
                params: { ID:  id},
                success: function (response, opts) {
                    var customerInfo = Ext.decode(response.responseText)
                   
                    initData(customerInfo)
                }
            })

            
        })
        function initData(info)
        {
            if (info != null)
            {
                Ext.getCmp("code").setValue(info.CODE);
                Ext.getCmp("cnabbrev").setValue(info.CHINESEABBREVIATION);
                Ext.getCmp("cnname").setValue(info.NAME);
                Ext.getCmp("cnaddress").setValue(info.CHINESEADDRESS);
                Ext.getCmp("enname").setValue(info.ENGLISHNAME);
                Ext.getCmp("enaddress").setValue(info.ENGLISHADDRESS);
                Ext.getCmp("hscode").setValue(info.HSCODE);
                Ext.getCmp("ciqcode").setValue(info.CIQCODE);
                Ext.getCmp("remark").setValue(info.REMARK);
                Ext.getCmp("enabled").setValue(info.ENABLED == 1 ? "是" : "否");
                Ext.getCmp("customerid").setValue(info.ISCUSTOMER);
                Ext.getCmp("shipperid").setValue(info.ISSHIPPER);
                Ext.getCmp("companyid").setValue(info.ISCOMPANY);
                Ext.getCmp("docserviceid").setValue(info.DOCSERVICECOMPANY); 
                Ext.getCmp("logicauditid").setValue(info.LOGICAUDITFLAG);
            }
        }
    </script>
</head>
<body>
    <div id="fpanel" style="margin-left:60px;margin-top:30px;"></div>
</body>
</html>
