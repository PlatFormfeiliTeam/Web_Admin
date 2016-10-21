<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Declaration.aspx.cs" Inherits="Web_Admin.Declaration" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
        <link href="/Extjs42/resources/css/ext-all-gray.css" rel="stylesheet" type="text/css" />
    <script src="/Extjs42/bootstrap.js" type="text/javascript"></script>
    <script src="/js/pan.js" type="text/javascript"></script>

    <script type="text/javascript">
        Ext.onReady(function () {
            var store_Redis_Declare = Ext.create('Ext.data.JsonStore', {
                fields: ['ID'],
                pageSize: 20,
                proxy: {
                    type: 'ajax',
                    url: 'Declaration.aspx?action=loadredisceclare',
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
                            CODE: Ext.getCmp("CODE").getValue()
                        }
                        Ext.apply(store.proxy.extraParams, new_params);
                    }
                }
            })
            var toolbar = Ext.create('Ext.toolbar.Toolbar', {
                items: [
                            {
                                xtype: 'textfield', fieldLabel: '预制单编号', labelWidth: 80, labelAlign: 'right', id: 'CODE'
                            },
                              {
                                  xtype: 'button', text: '<i class="iconfont">&#xe615;</i>查询', handler: function () {
                                      gridpanel.store.load();
                                  }
                              },
                              {
                                  xtype: 'button', text: '<i class="iconfont">&#xe60d;</i>写入报关单及明细缓存', handler: function () {
                                      Ext.Ajax.request({
                                          url: 'Declaration.aspx?action=WriteRedisDecl',
                                          callback: function (option, success, response) {
                                              var result = Ext.decode(response.responseText);
                                              if (result.success) {
                                                  Ext.Msg.alert("提示", "写入成功!", function () {
                                                      gridpanel.store.load();
                                                  });
                                              }
                                          }
                                      })
                                  }
                              }
                ]
            })

            var pgbar = Ext.create('Ext.toolbar.Paging', {
                displayMsg: '显示 {0} - {1} 条,共计 {2} 条',
                store: store_Redis_Declare,
                displayInfo: true
            })

            var gridpanel = Ext.create('Ext.grid.Panel', {
                title: '报关单-缓存信息',
                renderTo: 'renderto',
                height: 500,
                store: store_Redis_Declare,
                selModel: { selType: 'checkboxmodel' },
                bbar: pgbar,
                tbar: toolbar,
                columns: [
                    { xtype: 'rownumberer', width: 35 },
                    { header: 'ID', dataIndex: 'ID', width: 80, hidden: true },//renderer: render
                    { header: 'CODE', dataIndex: '预制单编号', width: 80, hidden: true },                    
                    { header: 'DECLARATIONCODE', dataIndex: '报关单号', width: 80, hidden: true },
                    { header: 'CUSTOMAREACODE', dataIndex: '申报关区', width: 80, hidden: true },
                    { header: 'STATUS', dataIndex: '报关状态', width: 80, hidden: true },
                    { header: 'CUSTOMSSTATUS', dataIndex: '海关状态', width: 80, hidden: true },
                    { header: 'ORDERCODE', dataIndex: '客户编号', width: 80, hidden: true },
                ]
            })

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
