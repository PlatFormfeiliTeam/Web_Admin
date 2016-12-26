<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AttachList.aspx.cs" Inherits="Web_Admin.AttachList" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link href="/Extjs42/resources/css/ext-all-neptune.css" rel="stylesheet" type="text/css" />
    <script src="/Extjs42/bootstrap.js" type="text/javascript"></script>
    <script src="/js/pan.js" type="text/javascript"></script>
    <style type="text/css">
        .tdValign {
            font-size:12px;
        }
    </style>
    <script type="text/javascript">
        Ext.onReady(function () {
            var store_attach = Ext.create('Ext.data.JsonStore', {
                fields: ['ID','FILENAME','ORIGINALNAME','UPLOADTIME','UPLOADUSERID','FILETYPE','CUSTOMERCODE'
                    , 'SIZES', 'ORDERCODE', 'FILESUFFIX', 'FILETYPENAME', 'SPLITSTATUS', 'IETYPE', 'PGINDEX'
                    , 'ORDERCOUNT', 'UPLOADUSERNAME'],
                pageSize: 20,
                proxy: {
                    type: 'ajax',
                    url: 'AttachList.aspx?action=loadattach',
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
                            ORDERCODE: Ext.getCmp("ORDERCODE").getValue()
                        }
                        Ext.apply(store.proxy.extraParams, new_params);
                    }
                }
            })
            var toolbar = Ext.create('Ext.toolbar.Toolbar', {
                items: [
                            {
                                xtype: 'textfield', fieldLabel: '订单编号', labelWidth: 80, labelAlign: 'right', id: 'ORDERCODE', flex: .25
                            },
                              {
                                  xtype: 'button', text: '<i class="iconfont">&#xe615;</i>&nbsp;查询', handler: function () {
                                      pgbar.moveFirst();
                                      //gridpanel.store.load();
                                  }
                              }, '->'
                ]
            })

            var pgbar = Ext.create('Ext.toolbar.Paging', {
                displayMsg: '显示 {0} - {1} 条,共计 {2} 条',
                store: store_attach,
                displayInfo: true
            })

            var gridpanel = Ext.create('Ext.grid.Panel', {
                //title: '文件列表',
                height: 500,
                store: store_attach,
                selModel: { selType: 'checkboxmodel' },
                bbar: pgbar,
                style: {
                    size:'12px'
                },
                columns: [
                    { xtype: 'rownumberer', width: 35 },
                    { header: 'ID', dataIndex: 'ID', width: 80, locked: true },
                    { header: '文件路径', dataIndex: 'FILENAME', width: 300, locked: true, tdCls: 'tdValign' },
                    { header: '原文件名', dataIndex: 'ORIGINALNAME', width: 250, locked: true },
                    { header: '订单编号', dataIndex: 'ORDERCODE', width: 120, locked: true },
                    { header: '是否拆分', dataIndex: 'SPLITSTATUS', width: 60, renderer: render, locked: true },
                    { header: '文件类型', dataIndex: 'FILETYPE', width: 60 },
                    { header: '上传时间', dataIndex: 'UPLOADTIME', width: 150 },
                    { header: '文件大小', dataIndex: 'SIZES', width: 80 },
                    { header: '文件扩展名', dataIndex: 'FILESUFFIX', width: 130 },
                    { header: '上传人', dataIndex: 'UPLOADUSERID', width: 60 },
                    { header: '上传人姓名', dataIndex: 'UPLOADUSERNAME', width: 130 }
                ],
                //添加双击事件
                listeners:
                {
                    'itemdblclick': function (view, record, item, index, e) {
                        // /Pdfview.aspx?ordercode=16055238810&fileids=5696&filetype=44&userid=12                         
                        opencenterwin("/PdfView.aspx?ordercode=" + record.data.ORDERCODE + "&fileids=" + record.data.ID + "&filetype=" + record.data.FILETYPE + "&userid=-1", 1600, 900);
                    }
                },
                viewConfig: {
                    enableTextSelection: true
                }
            });

            var panel = Ext.create('Ext.panel.Panel', {
                title: '文件列表',
                tbar: toolbar,
                renderTo: 'renderto',
                minHeight: 100,
                items: [gridpanel]
            });

        });
        function render(value, cellmeta, record, rowIndex, columnIndex, store) {
            var rtn = "";
            var dataindex = cellmeta.column.dataIndex;           
            switch (dataindex) {
                case "SPLITSTATUS":
                    rtn = value == "1" ? "是" : "否";
                    break;
            }
            return rtn;
        }
    </script>
    <div id="renderto"></div>
</asp:Content>
