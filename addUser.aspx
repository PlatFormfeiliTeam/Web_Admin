<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="addUser.aspx.cs" Inherits="Web_Admin.addUser" %>

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
            var cusstore = Ext.create('Ext.data.Store', {
                fields: ["ID", "NAME"],
                proxy: {
                    url: 'addUser.aspx?action=customer',
                    type: 'ajax',
                    reader: {
                        root: 'rows',
                        type: 'json',
                        totalProperty: 'total'
                    }
                },
                autoLoad: true
            });

            var txtName = Ext.create('Ext.form.field.Text', {
                id: 'name',
                name: 'NAME',
                fieldLabel: '账号',
                width: 180,
                labelWidth: 40
            });
            var txtRealName = Ext.create('Ext.form.field.Text', {
                id: 'realname',
                name: 'REALNAME',
                fieldLabel: '名称',
                width: 280,
                labelWidth: 40
            });
            var txtMPhone = Ext.create('Ext.form.field.Text', {
                id: 'mobilephone',
                name: 'MOBILEPHONE',
                fieldLabel: '手机',
                width: 180,
                labelWidth: 40
            });
            var txtTPhone = Ext.create('Ext.form.field.Text', {
                id: 'telephone',
                name: 'TELEPHONE',
                fieldLabel: '电话',
                width: 180,
                labelWidth: 40
            });

            var txtEMail = Ext.create('Ext.form.field.Text', {
                id: 'email',
                name: 'EMAIL',
                fieldLabel: '邮箱',
                width: 180,
                labelWidth: 40
            });
            
            
            var combCustomer = Ext.create('Ext.form.field.ComboBox', {
                id: 'customername',
                name: 'CUSTOMERID',
                fieldLabel: '客商',
                store: cusstore,
                displayField: 'NAME',
                valueField: 'ID',
                width: 280,
                labelWidth: 40
            });
           
            var enstore = Ext.create('Ext.data.Store', {
                fields: ['code', 'name'],
                data: [
                    { "code": 0, "name": "否" },
                    { "code": 1, "name": "是" }
                ]
            });
            var combEnabled = Ext.create('Ext.form.field.ComboBox', {
                id: 'enabled',
                name: 'ENABLED',
                fieldLabel: '启用',
                store: enstore,
                displayField: 'name',
                valueField: 'code',
                width: 180,
                labelWidth: 40
            });
            var posstore = Ext.create('Ext.data.Store', {
                fields: ['code', 'name'],
                data: [
                    { "code": 0, "name": "无" },
                    { "code": 1, "name": "前台管理" },
                    { "code": 2, "name": "后台管理" }
                ]
            });
            var combPosition = Ext.create('Ext.form.field.ComboBox', {
                id: 'positionid',
                name:'POSITIONID',
                fieldLabel: '权限',
                store: posstore,
                displayField: 'name',
                valueField: 'code',
                width: 180,
                labelWidth: 40
            });
            var txtRemark = Ext.create('Ext.form.field.Text', {
                id: 'remark',
                name: 'REMARK',
                fieldLabel: '备注',
                width: 865,
                labelWidth: 40
            });

            var btnSave = Ext.create("Ext.Button", {
                id: 'saveid',
                handler: function () {
                    var formdata = Ext.encode(Ext.getCmp('formpanel').getForm().getValues());
                    Ext.Ajax.request({
                        url: 'addUser.aspx',
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
                handler: function () {
                    //window.opener.location.href = window.opener.location.href;//刷新父页面
                    window.opener.refreshData();
                    window.close();

                }
            });
            var tbar1 = Ext.create("Ext.toolbar.Toolbar", {
                items: [btnSave, btnBack]
            })

            var colItem = [
                    { layout: 'column', height: 62, border: 0, margin: '10 0 0 0', items: [txtName, txtRealName, txtMPhone, txtTPhone] },
                    { layout: 'column', height: 62, border: 0, items: [txtEMail, combCustomer, combPosition, combEnabled] },
                    { layout: 'column', height: 62, border: 0, items: [txtRemark] }
            ];
            var mianPnl = Ext.create("Ext.form.Panel", {
                id: 'formpanel',
                renderTo: 'fpanel',
                border: 1,
                width: 920,
                tbar: tbar1,
                fieldDefaults: {
                    margin: '0 5 10 10',
                    labelWidth: 80,
                    labelAlign: 'center'
                },
                items: colItem
            });
            Ext.Ajax.request({
                url: 'addUser.aspx?action=initData',
                params: { ID: id },
                success: function (response, opts) {
                    var userInfo = Ext.decode(response.responseText)

                    initData(userInfo)
                }
            })


        })
        function initData(info) {
            if (info != null) {
                //Ext.getCmp("name").setValue(info.NAME);
                //Ext.getCmp("realname").setValue(info.REALNAME);
                //Ext.getCmp("mobilephone").setValue(info.MOBILEPHONE);
                //Ext.getCmp("telephone").setValue(info.TELEPHONE);
                //Ext.getCmp("email").setValue(info.EMAIL);
                //Ext.getCmp("customername").setValue(info.COMPANYIDS);
                //Ext.getCmp("position").setValue(info.POSITIONID);
                //Ext.getCmp("remark").setValue(info.REMARK);
                //Ext.getCmp("enabled").setValue(info.ENABLED == 1 ? "是" : "否");
                Ext.getCmp('formpanel').getForm().setValues(info);
            }
        }
    </script>
</head>
<body>
    <div id="fpanel" style="margin-left:60px;margin-top:30px;"></div>
</body>
</html>
