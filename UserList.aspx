<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="UserList.aspx.cs" Inherits="Web_Admin.UserList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link href="/Extjs42/resources/css/ext-all-gray.css" rel="stylesheet" type="text/css" />
    <script src="/Extjs42/bootstrap.js" type="text/javascript"></script>
    <script src="/js/pan.js" type="text/javascript"></script>
    <link href="/font-awesome/css/font-awesome.min.css" rel="stylesheet" />

    <script type="text/javascript">
        Ext.onReady(function () {
            var store_user = Ext.create('Ext.data.JsonStore', {
                fields: ['ID', 'NAME', 'REALNAME', 'EMAIL', 'TELEPHONE', 'MOBILEPHONE', 'POSITIONID',
                    'CUSTOMERID', 'SEX', 'ENABLED', 'CREATETIME', 'TYPE'],
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
                autoLoad: true
            })
            var pgbar = Ext.create('Ext.toolbar.Paging', {
                displayMsg: '显示 {0} - {1} 条,共计 {2} 条',
                store: store_user,
                displayInfo: true
            })

            var gridpanel = Ext.create('Ext.grid.Panel', {
                title: '账户管理',
                renderTo: 'renderto',
                height: 450,
                store: store_user,
                selModel: { selType: 'checkboxmodel' },
                bbar: pgbar,
                columns: [
                    { xtype: 'rownumberer', width: 35 },
                    { header: 'ID', dataIndex: 'ID', hidden: true },
                    { header: '登录账户', dataIndex: 'NAME', width: 100 },
                    { header: '名称', dataIndex: 'REALNAME', width: 170 },
                    { header: '状态', dataIndex: 'ENABLED', width: 60, renderer: render },
                    { header: '账户类型', dataIndex: 'TYPE', width: 80, renderer: render },
                    { header: '创建时间', dataIndex: 'CREATETIME', width: 130 },
                    { header: '邮箱', dataIndex: 'EMAIL', width: 160 },
                    { header: '电话', dataIndex: 'TELEPHONE', width: 110 },
                    { header: '初始化密码', dataIndex: 'ID', width: 70, renderer: render }
                ],
                plugins: [{
                    ptype: 'rowexpander',
                    rowBodyTpl: ['<div id="div_{ID}"></div>']
                }]
            })

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
    </script>
    <div id="renderto"></div>
</asp:Content>
