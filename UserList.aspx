<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="UserList.aspx.cs" Inherits="Web_Admin.UserList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link href="/Extjs42/resources/css/ext-all-gray.css" rel="stylesheet" type="text/css" />
    <script src="/Extjs42/bootstrap.js" type="text/javascript"></script>
    <script src="/js/pan.js" type="text/javascript"></script>
    <script type="text/javascript">
        Ext.onReady(function () {
            var toolbar = Ext.create('Ext.toolbar.Toolbar', {
                items: [
                { xtype: 'textfield', fieldLabel: '登录账户', labelWidth: 60, labelAlign: 'right', id: 'NAME' },
                { xtype: 'textfield', fieldLabel: '姓名', labelWidth: 60, labelAlign: 'right', id: 'REALNAME' },
                {
                    xtype: 'button', text: '<i class="fa fa-search fa-fw"></i>&nbsp;查询', handler: function () {
                        store_user.load({ params: { start: 0, NAME: Ext.getCmp("NAME").getValue(), REALNAME: Ext.getCmp("REALNAME").getValue() } });
                    }
                }, '-', {
                    text: '<i class="fa fa-plus fa-fw"></i>&nbsp;添加账户', handler: function () {
                        opencenterwin("UserEdit.aspx", 800, 400);
                    }
                }, '-',
                {
                    text: '<i class="fa fa-key fa-fw"></i>&nbsp;初始化密码', handler: function () {
                        var recs = gridpanel.getSelectionModel().getSelection();
                        if (recs.length == 0) {
                            Ext.MessageBox.alert('提示', '请选择需要初始化密码的记录！');
                            return;
                        }
                        Ext.Ajax.request({
                            url: 'UserList.aspx?action=inipsd&id=' + recs[0].get("ID"),
                            success: function (response) {
                                if (response.responseText) {
                                    Ext.MessageBox.alert('提示', '初始化密码成功！');
                                }
                            }
                        });
                    }
                }
                , {
                    text: '<i class="fa fa-clipboard"></i>&nbsp;初始化经营单位', handler: function () {
                        var recs = gridpanel.getSelectionModel().getSelection();
                        if (recs.length == 0) {
                            Ext.MessageBox.alert('提示', '请选择需要初始化企业信息的记录！');
                            return;
                        }
                        Ext.MessageBox.confirm("提示", "初始化企业信息将对该客户以前的企业信息进行清空，确定要执行初始化操作吗？", function (btn) {
                            if (btn == 'yes') {
                                var mask = new Ext.LoadMask(Ext.getBody(), { msg: "企业信息初始化中，请稍等..." });
                                mask.show();
                                Ext.Ajax.request({
                                    url: 'UserList.aspx?action=import',
                                    timeout: 120000,
                                    params: { CustomerId: recs[0].get("CUSTOMERID") },
                                    success: function (response) {
                                        if (response.responseText) {
                                            var json = Ext.decode(response.responseText);
                                            if (json.result > 0) {
                                                Ext.MessageBox.alert('提示', "经营单位初始化成功！");
                                            }
                                            mask.hide();
                                        }
                                    },
                                    failure: function () {
                                        Ext.MessageBox.alert('提示', "经营单位初始化失败！");
                                        mask.hide();
                                    }
                                });
                            }
                        });
                    }
                }
                ]
            })
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
                    { header: '电话', dataIndex: 'TELEPHONE', width: 130 }
                   // { header: '手机', dataIndex: 'MOBILEPHONE', width: 120 },

                   // {
                   //    xtype: 'actioncolumn', width: 90, text: '操作', locked: true,
                   //    items: [{
                   //        icon: '../../images/shared/message_edit.png',
                   //        handler: function (grid, rowIndex, colIndex) {
                   //            var rec = grid.getStore().getAt(rowIndex);
                   //            opencenterwin("UserEdit.aspx?ID=" + rec.get("ID"), 900, 500);
                   //        }
                   //    }, {
                   //    }, {
                   //        icon: '../../images/shared/delete.gif',
                   //        handler: function (grid, rowIndex, colIndex) {
                   //            Ext.MessageBox.confirm('提示', '删除主账号会连同子账号一并删除，确定要执行该操作吗？', function (btn) {
                   //                if (btn == 'yes') {
                   //                    var rec = store_user.getAt(rowIndex);
                   //                    Ext.Ajax.request({
                   //                        url: 'UserList.aspx?action=delete',
                   //                        params: { id: rec.get("ID") },
                   //                        success: function (response) {
                   //                            if (response.responseText) {
                   //                                Ext.MessageBox.alert('提示', '删除成功！');
                   //                                store_user.load();
                   //                            }
                   //                        }
                   //                    })
                   //                }
                   //            })
                   //        }
                   //    }
                   //    ]
                   //}
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
                    columns: [
                        { xtype: 'rownumberer', width: 25 },
                        { header: 'ID', dataIndex: 'ID', hidden: true },
                        { header: '子账号名', dataIndex: 'NAME', width: 80 },
                        { header: '姓名', dataIndex: 'REALNAME', width: 90 },
                        { header: '邮箱', dataIndex: 'EMAIL', width: 150 },
                        { header: '电话', dataIndex: 'TELEPHONE', width: 110 },
                     //   { header: '手机', dataIndex: 'MOBILEPHONE', width: 110 },
                        { header: '状态', dataIndex: 'ENABLED', width: 50, renderer: render },
                        { header: '创建时间', dataIndex: 'CREATETIME', width: 130 }
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
    </script>
    <div id="renderto"></div>
</asp:Content>
