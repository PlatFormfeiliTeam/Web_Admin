<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="UserList.aspx.cs" Inherits="Web_Admin.UserList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link href="/Extjs42/resources/css/ext-all-gray.css" rel="stylesheet" type="text/css" />
    <script src="/Extjs42/bootstrap.js" type="text/javascript"></script>
    <script src="/js/pan.js" type="text/javascript"></script>
    <link href="/font-awesome/css/font-awesome.min.css" rel="stylesheet" />

    <script type="text/javascript">
        var store_user;
        Ext.onReady(function () {
            var txtCode = Ext.create('Ext.form.field.Text', {
                id: 'name',
                fieldLabel: '账号',
                width: 180,
                labelWidth: 60
            });
            var txtCNName = Ext.create('Ext.form.field.Text', {
                id: 'realname',
                fieldLabel: '名称',
                width: 180,
                labelWidth: 60
            });
            var enstore = Ext.create('Ext.data.Store', {
                fields: ['code', 'name'],
                data: [
                    { "code": "0", "name": "无" },
                    { "code": "1", "name": "前台管理" },
                    { "code": "2", "name": "后台管理" }
                ]
            });
            var comb = Ext.create('Ext.form.field.ComboBox', {
                id: 'positionid',
                fieldLabel: '管理权限',
                store: enstore,
                displayField: 'name',
                valueField: 'code',
                width: 180,
                labelWidth: 60
            });
            var serachPnl = Ext.create('Ext.toolbar.Toolbar', {
                border: 0,
                padding: '0 0 0 10',
                items: [txtCode, txtCNName,comb]
            });
            //创建按钮栏
            var btnAdd = Ext.create('Ext.Button', {
                text: '新 增',
                width: 80,
                handler: function () {
                    opencenterwin("/addUser.aspx", 1040, 340);
                }
            });
            var btnAlt = Ext.create('Ext.Button', {
                text: '修 改',
                width: 80,
                handler: function () {
                    var recs = gridpanel.getSelectionModel().getSelection();
                    if (recs.length == 0) {
                        Ext.MessageBox.alert('提示', '请选择需要查看详细的记录！');
                        return;
                    }
                    opencenterwin("/addUser.aspx?id=" + recs[0].get("ID"), 1040, 340);
                }
            });
            var btnDel = Ext.create('Ext.Button', {
                text: '删 除',
                width: 80,
                handler: function () {
                    var recs = gridpanel.getSelectionModel().getSelection();
                    if (recs.length == 0) {
                        Ext.MessageBox.alert('提示', '请选择要删除的记录！');
                        return;
                    }
                    Ext.Ajax.request({
                        url: 'UserList.aspx',
                        params: { action: 'delete', ID: recs[0].get("ID") },
                        type: 'Post',
                        success: function (response, option) {
                            var data = Ext.decode(response.responseText);
                            if (data.success) {
                                store_user.load();
                                Ext.MessageBox.alert('提示', '删除成功');
                            }
                            else
                                Ext.MessageBox.alert('提示', '删除失败');
                        }
                    })
                }
            });
            var btnEnabled = Ext.create('Ext.Button', {
                text: '启 用',
                width: 80,
                handler: function () {
                    var recs = gridpanel.getSelectionModel().getSelection();
                    if (recs.length == 0) {
                        Ext.MessageBox.alert('提示', '请选择要删除的记录！');
                        return;
                    }
                    Ext.Ajax.request({
                        url: 'UserList.aspx',
                        params: { action: 'enabled', FLAG: 1, ID: recs[0].get("ID") },
                        type: 'Post',
                        success: function (response, option) {
                            var data = Ext.decode(response.responseText);
                            if (data.success) {
                                store_user.load();
                            }
                        }
                    })
                }
            });
            var btnDisabled = Ext.create('Ext.Button', {
                text: '禁 用',
                width: 80,
                handler: function () {
                    var recs = gridpanel.getSelectionModel().getSelection();
                    if (recs.length == 0) {
                        Ext.MessageBox.alert('提示', '请选择要删除的记录！');
                        return;
                    }
                    Ext.Ajax.request({
                        url: 'UserList.aspx',
                        params: { action: 'enabled', FLAG: 0, ID: recs[0].get("ID") },
                        type: 'Post',
                        success: function (response, option) {
                            var data = Ext.decode(response.responseText);
                            if (data.success) {
                                store_user.load();
                            }
                        }
                    })
                }
            });
            var btnQuery = Ext.create('Ext.Button', {
                text: '查 询',
                width: 80,
                handler: function () {
                    store_user.load();
                }
            });
            var btnReset = Ext.create('Ext.Button', {
                text: '重 置',
                width: 80,
                handler: function () {
                    Ext.getCmp("name").setValue("");
                    Ext.getCmp("realname").setValue("");
                    Ext.getCmp("positionid").setValue("")
                }
            });
            var toolbar = Ext.create('Ext.toolbar.Toolbar', {
                items: [btnAdd, btnAlt, btnDel, btnEnabled, btnDisabled, '->', btnQuery, btnReset]
            });

           store_user = Ext.create('Ext.data.JsonStore', {
                fields: ['ID', 'NAME', 'REALNAME', 'EMAIL', 'TELEPHONE', 'MOBILEPHONE', 'POSITIONID',
                    'CUSTOMERID', 'ENABLED', 'CREATETIME', 'TYPE'],
                pageSize: 20,
                proxy: {
                    type: 'ajax',
                    url: 'UserList.aspx?action=loaduser',
                    reader: {
                        root: 'rows',
                        type: 'json',
                        totalProperty: 'total'
                    }
                },
                autoLoad: true,
                listeners: {
                    beforeload: function (store, options) {
                        var new_params = {
                            name: Ext.getCmp("name").getValue(),
                            realname: Ext.getCmp("realname").getValue(),
                            positionid: Ext.getCmp("positionid").getValue()
                        }
                        Ext.apply(store.proxy.extraParams, new_params);
                    }
                }
            })
            var pgbar = Ext.create('Ext.toolbar.Paging', {
                displayMsg: '显示 {0} - {1} 条,共计 {2} 条',
                store: store_user,
                displayInfo: true
            })

            var gridpanel = Ext.create('Ext.grid.Panel', {
                height: 450,
                store: store_user,
                selModel: { selType: 'checkboxmodel' },
                bbar: pgbar,
                tbar: serachPnl,
                columns: [
                    { xtype: 'rownumberer', width: 35 },
                    { header: 'ID', dataIndex: 'ID', hidden: true },
                    { header: '登录账户', dataIndex: 'NAME', width: 100 },
                    { header: '名称', dataIndex: 'REALNAME', width: 250 },
                    { header: '状态', dataIndex: 'ENABLED', width: 60, renderer: render },
                    { header: '创建时间', dataIndex: 'CREATETIME', width: 130 },
                    { header: '邮箱', dataIndex: 'EMAIL', width: 160 },
                    { header: '电话', dataIndex: 'TELEPHONE', width: 110 },
                    { header: '管理权限', dataIndex: 'POSITIONID', renderer: gridrender, width: 80 },
                    { header: '是否启用', dataIndex: 'ENABLED', renderer: gridrender, width: 80 },
                    { header: '初始化密码', dataIndex: 'ID', width: 70, renderer: render }
                ],
                plugins: [{
                    ptype: 'rowexpander',
                    rowBodyTpl: ['<div id="div_{ID}"></div>']
                }]
            })
            Ext.create('Ext.form.Panel', {
                title: '主账号管理',
                renderTo: 'renderto',
                tbar: toolbar,
                items: [gridpanel]
            });
            gridpanel.view.on('expandBody', function (rowNode, record, expandRow, eOpts) {
                displayInnerGrid(record.get('ID'));
            });
            gridpanel.view.on('collapsebody', function (rowNode, record, expandRow, eOpts) {
                destroyInnerGrid(record.get("ID"));
            });
            function displayInnerGrid(div) {
                var store_inner = Ext.create('Ext.data.JsonStore', {
                    fields: ['ID', 'NAME', 'REALNAME', 'EMAIL', 'TELEPHONE', 'MOBILEPHONE', 'POSITIONID', 'SEX', 'ENABLED', 'CREATETIME'],
                    proxy: {
                        url: 'UserList.aspx?action=loadchildaccount&id=' + div,
                        type: 'ajax',
                        reader: {
                            type: 'json',
                            root: 'innerrows'
                        }
                    },
                    autoLoad: true
                })
                var grid_inner = Ext.create('Ext.grid.Panel', {
                    store: store_inner,
                    margin: '0 0 0 70',
                    selModel: { selType: 'checkboxmodel' },
                    columns: [
                        { xtype: 'rownumberer', width: 25 },
                        { header: 'ID', dataIndex: 'ID', hidden: true },
                        { header: '子账号名', dataIndex: 'NAME', width: 80 },
                        { header: '姓名', dataIndex: 'REALNAME', width: 90 },
                        { header: '邮箱', dataIndex: 'EMAIL', width: 150 },
                        { header: '电话', dataIndex: 'TELEPHONE', width: 110 },
                        { header: '状态', dataIndex: 'ENABLED', width: 50, renderer: render },
                        { header: '创建时间', dataIndex: 'CREATETIME', width: 130 },
                        { header: '操作', dataIndex: 'ID', width: 130, renderer: render }
                    ],
                    renderTo: 'div_' + div
                })

                grid_inner.getEl().swallowEvent([
                    'mousedown', 'mouseup', 'click',
                    'contextmenu', 'mouseover', 'mouseout',
                    'dblclick', 'mousemove'
                ]);

            }
            function gridrender(value, cellmeta, record, rowIndex, columnIndex, stroe) {
                var dataindex = cellmeta.column.dataIndex;
                var str = "";
                switch (dataindex) {
                    case "POSITIONID":
                        if (value == 1)
                            str = "前台管理";
                        else if (value == 2)
                            str = "后台管理"
                        else
                            str = "无";
                        break;
                    case "ENABLED":
                        str = value == "0" ? "否" : "是";
                }
                return str;
            }
            function destroyInnerGrid(div) {
                var parent = document.getElementById('div_' + div);
                var child = parent.firstChild;
                while (child) {
                    child.parentNode.removeChild(child);
                    child = child.nextSibling;
                }
            }
        });


        function inipsd(id, name) {
            Ext.MessageBox.confirm('提示', '初始化密码，确定要执行该操作吗？', function (btn) {
                if (btn == 'yes') {
                    Ext.Ajax.request({
                        url: 'UserList.aspx?action=inipsd&id=' + id + "&name=" + name,
                        success: function (response) {
                            if (response.responseText) {
                                Ext.MessageBox.alert('提示', '初始化密码成功！');
                            }
                        }
                    });
                }
            })
           
        }
        function refreshData() {
            store_user.load();
        }
        
    </script>
    <div id="renderto"></div>
</asp:Content>
