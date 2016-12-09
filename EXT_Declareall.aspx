<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="EXT_Declareall.aspx.cs" Inherits="Web_Admin.EXT_Declareall" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
     <link href="/Extjs42/resources/css/ext-all-gray.css" rel="stylesheet" type="text/css" />
    <script src="/Extjs42/bootstrap.js" type="text/javascript"></script>
    <script src="/js/pan.js" type="text/javascript"></script>

    <script type="text/javascript">
        Ext.onReady(function () {
            var store_attach = Ext.create('Ext.data.JsonStore', {
                fields: [ 'ID','DECLARATIONCODE', 'TRADECODE', 'TRANSNAME', 'GOODSNUM', 'GOODSGW', 'SHEETNUM', 'COMMODITYNUM', 'CUSTOMSSTATUS',
                         'MODIFYFLAG', 'PREDECLCODE', 'CUSNO', 'OLDDECLARATIONCODE', 'ISDEL', 'DIVIDEREDISKEY'],
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
                            CUSNO: Ext.getCmp("CUSNO").getValue(), FENKEY: Ext.getCmp("FENKEY").getValue()
                        }
                        Ext.apply(store.proxy.extraParams, new_params);
                    }
                }
            })
            var toolbar = Ext.create('Ext.toolbar.Toolbar', {
                items: [
                            {
                                xtype: 'textfield', fieldLabel: '客户编号', labelWidth: 80, labelAlign: 'right', id: 'CUSNO'
                            },
                            {
                                xtype: 'textfield', fieldLabel: '分KEY', labelWidth: 80, labelAlign: 'right', id: 'FENKEY'
                            },
                            {
                                xtype: 'button', text: '<i class="iconfont">&#xe615;</i>查询', handler: function () {
                                    gridpanel.store.load();
                                    gridpanel_fenkey.store.load();
                                }
                            }
                ]
            })

            var pgbar = Ext.create('Ext.toolbar.Paging', {
                displayMsg: '显示 {0} - {1} 条,共计 {2} 条',
                store: store_attach,
                displayInfo: true
            })

            var gridpanel = Ext.create('Ext.grid.Panel', {
                title: '报关单--总KEY',
                renderTo: 'renderto',
                height: 500,
                store: store_attach,
                selModel: { selType: 'checkboxmodel' },
                bbar: pgbar,
                tbar: toolbar,
                columns: [
                    { xtype: 'rownumberer', width: 35 },
                    { header: 'ID', dataIndex: 'ID', width: 80, locked: true },
                    { header: '报关单号', dataIndex: 'DECLARATIONCODE', width: 300, locked: true },
                    { header: '贸易方式', dataIndex: 'TRADECODE', width: 210, locked: true },
                    { header: '运输工具', dataIndex: 'TRANSNAME', width: 100, locked: true },
                    { header: '件数', dataIndex: 'GOODSNUM', width: 60, locked: true },
                    { header: '毛重', dataIndex: 'GOODSGW', width: 60 },
                    { header: '报关单张数', dataIndex: 'SHEETNUM', width: 120 },
                    { header: '商品项数', dataIndex: 'COMMODITYNUM', width: 80 },
                    { header: '海关状态', dataIndex: 'CUSTOMSSTATUS', width: 130 },
                    { header: '删改单标志', dataIndex: 'MODIFYFLAG', width: 60 },
                    { header: '预制单编号', dataIndex: 'PREDECLCODE', width: 130 },
                    { header: '企业编号', dataIndex: 'CUSNO', width: 60 },
                    { header: '旧报关单号', dataIndex: 'OLDDECLARATIONCODE', width: 130 },
                    { header: '是否删除', dataIndex: 'ISDEL', width: 60 },
                    { header: '分KEY', dataIndex: 'DIVIDEREDISKEY', width: 130 }
                ]
            })



           // 分key

            var store_attach_fenkey = Ext.create('Ext.data.JsonStore', {
                fields: ['ID','DECLARATIONCODE', 'TRADECODE', 'TRANSNAME', 'GOODSNUM', 'GOODSGW', 'SHEETNUM', 'COMMODITYNUM', 'CUSTOMSSTATUS',
                         'MODIFYFLAG', 'PREDECLCODE', 'CUSNO', 'OLDDECLARATIONCODE', 'ISDEL', 'DIVIDEREDISKEY'],
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
                            CUSNO: Ext.getCmp("CUSNO").getValue(), FENKEY: Ext.getCmp("FENKEY").getValue()
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
                title: '报关单--分KEY',
                renderTo: 'rendertofenkey',
                height: 500,
                store: store_attach_fenkey,
                selModel: { selType: 'checkboxmodel' },
                bbar: pgbar_fenkey,
                columns: [
                    { xtype: 'rownumberer', width: 35 },
                    { header: 'ID', dataIndex: 'ID', width: 80, locked: true },
                    { header: '报关单号', dataIndex: 'DECLARATIONCODE', width: 300, locked: true },
                    { header: '贸易方式', dataIndex: 'TRADECODE', width: 210, locked: true },
                    { header: '运输工具', dataIndex: 'TRANSNAME', width: 100, locked: true },
                    { header: '件数', dataIndex: 'GOODSNUM', width: 60, locked: true },
                    { header: '毛重', dataIndex: 'GOODSGW', width: 60 },
                    { header: '报关单张数', dataIndex: 'SHEETNUM', width: 120 },
                    { header: '商品项数', dataIndex: 'COMMODITYNUM', width: 80 },
                    { header: '海关状态', dataIndex: 'CUSTOMSSTATUS', width: 130 },
                    { header: '删改单标志', dataIndex: 'MODIFYFLAG', width: 60 },
                    { header: '预制单编号', dataIndex: 'PREDECLCODE', width: 130 },
                    { header: '企业编号', dataIndex: 'CUSNO', width: 60 },
                    { header: '旧报关单号', dataIndex: 'OLDDECLARATIONCODE', width: 130 },
                    { header: '是否删除', dataIndex: 'ISDEL', width: 60 },
                    { header: '分KEY', dataIndex: 'DIVIDEREDISKEY', width: 130 }
                ]
            })
        });
    </script>
    <div id="renderto"></div>
    <p></p>
    <div id="rendertofenkey"></div>
</asp:Content>
