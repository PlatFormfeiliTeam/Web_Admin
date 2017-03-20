<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="EXT_Declareall.aspx.cs" Inherits="Web_Admin.EXT_Declareall" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
     <link href="/Extjs42/resources/css/ext-all-neptune.css" rel="stylesheet" type="text/css" />
    <script src="/Extjs42/bootstrap.js" type="text/javascript"></script>
    <script src="/js/pan.js" type="text/javascript"></script>

    <script type="text/javascript">
        Ext.onReady(function () {
            var store_attach = Ext.create('Ext.data.JsonStore', {
                fields: [ 'ID','DECLARATIONCODE', 'TRADECODE', 'TRANSNAME', 'GOODSNUM', 'GOODSGW', 'SHEETNUM', 'COMMODITYNUM', 'CUSTOMSSTATUS',
                         'MODIFYFLAG', 'PREDECLCODE', 'CUSNO', 'OLDDECLARATIONCODE', 'ISDEL', 'DIVIDEREDISKEY', 'SUPPLYCHAINCODE', 'DATES'],
                pageSize: 20,
                proxy: {
                    type: 'ajax',
                    url: 'EXT_Declareall.aspx?action=loadattach',
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
                            CUSNO: Ext.getCmp("CUSNO").getValue(), DECLARATIONCODE: Ext.getCmp("DECLARATIONCODE").getValue(), FENKEY: Ext.getCmp("FENKEY").getValue()
                        }
                        Ext.apply(store.proxy.extraParams, new_params);
                    }
                }
            })
            var toolbar = Ext.create('Ext.toolbar.Toolbar', {
                items: [
                            {
                                xtype: 'textfield', fieldLabel: '客户编号', labelWidth: 80, labelAlign: 'right', id: 'CUSNO', flex: .90
                            },
                            {
                                xtype: 'textfield', fieldLabel: '报关单号', labelWidth: 80, labelAlign: 'right', id: 'DECLARATIONCODE', flex: .90
                            },
                            {
                                xtype: 'textfield', fieldLabel: '分KEY', labelWidth: 80, labelAlign: 'right', id: 'FENKEY', flex: .90
                            },                            
                            {
                                xtype: 'button', text: '<i class="iconfont">&#xe60b;</i>&nbsp;查询', handler: function () {
                                    pgbar.moveFirst();
                                    pgbar_fenkey.moveFirst();
                                    //gridpanel.store.load();
                                    //gridpanel_fenkey.store.load();
                                }
                            },'->'
                ]
            })

            var pgbar = Ext.create('Ext.toolbar.Paging', {
                displayMsg: '显示 {0} - {1} 条,共计 {2} 条',
                store: store_attach,
                displayInfo: true
            })

            var gridpanel = Ext.create('Ext.grid.Panel', {
                //title: '报关单--总KEY',
                //renderTo: 'renderto',
                height: 500,
                store: store_attach,
                selModel: { selType: 'checkboxmodel' },
                bbar: pgbar,
                //tbar: toolbar,
                columns: [
                     { xtype: 'rownumberer', width: 35 },
                    { header: 'ID', dataIndex: 'ID', width: 100, locked: true },
                    { header: '报关单号', dataIndex: 'DECLARATIONCODE', width: 150, locked: true },
                    { header: '贸易方式', dataIndex: 'TRADECODE', width: 100, locked: true },
                    { header: '运输工具', dataIndex: 'TRANSNAME', width: 150, locked: true },
                    { header: '件数', dataIndex: 'GOODSNUM', width: 80, locked: true },
                    { header: '毛重', dataIndex: 'GOODSGW', width: 80 },
                    { header: '报关单张数', dataIndex: 'SHEETNUM', width: 80 },
                    { header: '商品项数', dataIndex: 'COMMODITYNUM', width: 80 },
                    { header: '海关状态', dataIndex: 'CUSTOMSSTATUS', width: 80 },
                    { header: '删改单标志', dataIndex: 'MODIFYFLAG', width: 80 },
                    { header: '预制单编号', dataIndex: 'PREDECLCODE', width: 150 },
                    { header: '企业编号', dataIndex: 'CUSNO', width: 150 },
                    { header: '旧报关单号', dataIndex: 'OLDDECLARATIONCODE', width: 150 },
                    { header: '是否删除', dataIndex: 'ISDEL', width: 80 },
                    { header: '供应链代码', dataIndex: 'SUPPLYCHAINCODE', width: 100 },
                    { header: '分KEY', dataIndex: 'DIVIDEREDISKEY', width: 200 },
                    { header: '时间', dataIndex: 'DATES', width: 180 }
                ],
                viewConfig: {
                    enableTextSelection: true
                }
            })

            var panel = Ext.create('Ext.panel.Panel', {
                title: '报关单--总KEY',
                tbar: toolbar,
                renderTo: 'renderto',
                minHeight: 100,
                items: [gridpanel]
            });

           // 分key

            var store_attach_fenkey = Ext.create('Ext.data.JsonStore', {
                fields: ['ID','DECLARATIONCODE', 'TRADECODE', 'TRANSNAME', 'GOODSNUM', 'GOODSGW', 'SHEETNUM', 'COMMODITYNUM', 'CUSTOMSSTATUS',
                         'MODIFYFLAG', 'PREDECLCODE', 'CUSNO', 'OLDDECLARATIONCODE', 'ISDEL', 'SUPPLYCHAINCODE', 'CREATETIME'],
                pageSize: 20,
                proxy: {
                    type: 'ajax',
                    url: 'EXT_Declareall.aspx?action=loadattach1',
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
                            CUSNO: Ext.getCmp("CUSNO").getValue(), DECLARATIONCODE: Ext.getCmp("DECLARATIONCODE").getValue(), FENKEY: Ext.getCmp("FENKEY").getValue()
                        }
                        Ext.apply(store.proxy.extraParams, new_params);
                    }
                }
            })

            var pgbar_fenkey = Ext.create('Ext.toolbar.Paging', {
                displayMsg: '显示 {0} - {1} 条,共计 {2} 条',
                store: store_attach_fenkey,
                displayInfo: true
            })

            var gridpanel_fenkey = Ext.create('Ext.grid.Panel', {
                //title: '报关单--分KEY',
                //renderTo: 'rendertofenkey',
                height: 500,
                store: store_attach_fenkey,
                selModel: { selType: 'checkboxmodel' },
                bbar: pgbar_fenkey,
                columns: [
                    { xtype: 'rownumberer', width: 35 },
                    { header: '报关单号', dataIndex: 'DECLARATIONCODE', width: 150, locked: true },
                    { header: '贸易方式', dataIndex: 'TRADECODE', width: 100, locked: true },
                    { header: '运输工具', dataIndex: 'TRANSNAME', width: 150, locked: true },
                    { header: '件数', dataIndex: 'GOODSNUM', width: 80, locked: true },
                    { header: '毛重', dataIndex: 'GOODSGW', width: 80 },
                    { header: '报关单张数', dataIndex: 'SHEETNUM', width: 80 },
                    { header: '商品项数', dataIndex: 'COMMODITYNUM', width: 80 },
                    { header: '海关状态', dataIndex: 'CUSTOMSSTATUS', width: 80 },
                    { header: '删改单标志', dataIndex: 'MODIFYFLAG', width: 80 },
                    { header: '预制单编号', dataIndex: 'PREDECLCODE', width: 150 },
                    { header: '企业编号', dataIndex: 'CUSNO', width: 150 },
                    { header: '旧报关单号', dataIndex: 'OLDDECLARATIONCODE', width: 150 },
                    { header: '是否删除', dataIndex: 'ISDEL', width: 80 },
                    { header: '供应链代码', dataIndex: 'SUPPLYCHAINCODE', width: 100 },
                    { header: '创建时间', dataIndex: 'CREATETIME', width: 120 }
                ],
                viewConfig: {
                    enableTextSelection: true
                }
            })

            var panelfenkey = Ext.create('Ext.panel.Panel', {
                title: '报关单--分KEY',
                renderTo: 'rendertofenkey',
                minHeight: 100,
                items: [gridpanel_fenkey]
            });
        });
    </script>
    <div id="renderto"></div>
    <p></p>
    <div id="rendertofenkey"></div>
</asp:Content>
