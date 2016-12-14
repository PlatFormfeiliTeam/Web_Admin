<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="EXT_Inspectionall.aspx.cs" Inherits="Web_Admin.EXT_Inspectionall" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
     <link href="/Extjs42/resources/css/ext-all-gray.css" rel="stylesheet" type="text/css" />
    <script src="/Extjs42/bootstrap.js" type="text/javascript"></script>
    <script src="/js/pan.js" type="text/javascript"></script>

    <script type="text/javascript">
        Ext.onReady(function () {
            var store_attach = Ext.create('Ext.data.JsonStore', {
                fields: ['ID','APPROVALCODE','INSPECTIONCODE','TRADEWAY','CLEARANCECODE','SHEETNUM','COMMODITYNUM',
                        'INSPSTATUS','MODIFYFLAG','PREINSPCODE','CUSNO','OLDINSPECTIONCODE','ISDEL','ISNEEDCLEARANCE',
                        'LAWFLAG', 'DIVIDEREDISKEY', 'DATES'],
                pageSize: 20,
                proxy: {
                    type: 'ajax',
                    url: 'EXT_Inspectionall.aspx?action=loadattach',
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
                            CUSNO: Ext.getCmp("CUSNO").getValue(), APPROVALCODE: Ext.getCmp("APPROVALCODE").getValue()
                            , INSPECTIONCODE: Ext.getCmp("INSPECTIONCODE").getValue(), FENKEY: Ext.getCmp("FENKEY").getValue()
                        }
                        Ext.apply(store.proxy.extraParams, new_params);
                    }
                }
            })
            var toolbar = Ext.create('Ext.toolbar.Toolbar', {
                items: [
                            {
                                xtype: 'textfield', fieldLabel: '客户编号', labelWidth: 80, labelAlign: 'right', id: 'CUSNO', flex: .25
                            },
                            {
                                xtype: 'textfield', fieldLabel: '流水单号', labelWidth: 80, labelAlign: 'right', id: 'APPROVALCODE', flex: .25
                            },
                            {
                                xtype: 'textfield', fieldLabel: '报检单号', labelWidth: 80, labelAlign: 'right', id: 'INSPECTIONCODE', flex: .25
                            },
                            {
                                xtype: 'textfield', fieldLabel: '分KEY', labelWidth: 80, labelAlign: 'right', id: 'FENKEY', flex: .25
                            },
                            {
                                xtype: 'button', text: '<i class="iconfont">&#xe615;</i>查询', handler: function () {
                                    pgbar.moveFirst();
                                    pgbar_fenkey.moveFirst();
                                    //gridpanel.store.load();
                                    //gridpanel_fenkey.store.load();
                                }
                            }
                ],
                viewConfig: {
                    enableTextSelection: true
                }
            })

            var pgbar = Ext.create('Ext.toolbar.Paging', {
                displayMsg: '显示 {0} - {1} 条,共计 {2} 条',
                store: store_attach,
                displayInfo: true
            })

            var gridpanel = Ext.create('Ext.grid.Panel', {
                title: '报检单--总KEY',
                renderTo: 'renderto',
                height: 500,
                store: store_attach,
                selModel: { selType: 'checkboxmodel' },
                bbar: pgbar,
                tbar: toolbar,
                columns: [
                    { xtype: 'rownumberer', width: 35 },
                    { header: 'ID', dataIndex: 'ID', width: 80, locked: true },
                    { header: '流水单号', dataIndex: 'APPROVALCODE', width: 180, locked: true },
                    { header: '报检单号', dataIndex: 'INSPECTIONCODE', width: 180, locked: true },
                    { header: '监管方式', dataIndex: 'TRADEWAY', width: 100, locked: true },
                    { header: '通关单号', dataIndex: 'CLEARANCECODE', width: 180, locked: true },
                    { header: '张数', dataIndex: 'SHEETNUM', width: 60 },
                    { header: '商品项数', dataIndex: 'COMMODITYNUM', width: 60 },
                    { header: '国检状态', dataIndex: 'INSPSTATUS', width: 80 },
                    { header: '删改单标志', dataIndex: 'MODIFYFLAG', width: 80 },
                    { header: '预制单编号', dataIndex: 'PREINSPCODE', width: 120 },
                    { header: '企业编号', dataIndex: 'CUSNO', width: 110 },
                    { header: '旧报检单号', dataIndex: 'OLDINSPECTIONCODE', width: 120 },
                    { header: '是否删除', dataIndex: 'ISDEL', width: 60 },
                    { header: '通关标志', dataIndex: 'ISNEEDCLEARANCE', width: 60 },
                    { header: '法检标志', dataIndex: 'LAWFLAG', width: 60 },
                    { header: '分KEY', dataIndex: 'DIVIDEREDISKEY', width: 150 },
                    { header: '时间', dataIndex: 'DATES', width: 130 }
                ],
                viewConfig: {
                    enableTextSelection: true
                }
            })



            // 分key

            var store_attach_fenkey = Ext.create('Ext.data.JsonStore', {
                fields: ['ID', 'APPROVALCODE', 'INSPECTIONCODE', 'TRADEWAY', 'CLEARANCECODE', 'SHEETNUM', 'COMMODITYNUM',
                        'INSPSTATUS', 'MODIFYFLAG', 'PREINSPCODE', 'CUSNO', 'OLDINSPECTIONCODE', 'ISDEL', 'ISNEEDCLEARANCE',
                        'LAWFLAG', 'DIVIDEREDISKEY'],
                pageSize: 20,
                proxy: {
                    type: 'ajax',
                    url: 'EXT_Inspectionall.aspx?action=loadattach1',
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
                title: '报检单--分KEY',
                renderTo: 'rendertofenkey',
                height: 500,
                store: store_attach_fenkey,
                selModel: { selType: 'checkboxmodel' },
                bbar: pgbar_fenkey,
                columns: [
                    { xtype: 'rownumberer', width: 35 },
                    { header: '流水单号', dataIndex: 'APPROVALCODE', width: 180, locked: true },
                    { header: '报检单号', dataIndex: 'INSPECTIONCODE', width: 180, locked: true },
                    { header: '监管方式', dataIndex: 'TRADEWAY', width: 100, locked: true },
                    { header: '通关单号', dataIndex: 'CLEARANCECODE', width: 60, locked: true },
                    { header: '张数', dataIndex: 'SHEETNUM', width: 60 },
                    { header: '商品项数', dataIndex: 'COMMODITYNUM', width: 60 },
                    { header: '国检状态', dataIndex: 'INSPSTATUS', width: 80 },
                    { header: '删改单标志', dataIndex: 'MODIFYFLAG', width: 80 },
                    { header: '预制单编号', dataIndex: 'PREINSPCODE', width: 120 },
                    { header: '企业编号', dataIndex: 'CUSNO', width: 110 },
                    { header: '旧报检单号', dataIndex: 'OLDINSPECTIONCODE', width: 120 },
                    { header: '是否删除', dataIndex: 'ISDEL', width: 60 },
                    { header: '通关标志', dataIndex: 'ISNEEDCLEARANCE', width: 60 },
                    { header: '法检标志', dataIndex: 'LAWFLAG', width: 60 }
                ]
            })
        });
    </script>
    <div id="renderto"></div>
    <p></p>
    <div id="rendertofenkey"></div>
</asp:Content>
