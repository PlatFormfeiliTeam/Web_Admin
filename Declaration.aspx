<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Declaration.aspx.cs" Inherits="Web_Admin.Declaration" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link href="/Extjs42/resources/css/ext-all-gray.css" rel="stylesheet" type="text/css" />
    <script src="/Extjs42/bootstrap.js" type="text/javascript"></script>
    <script src="/js/pan.js" type="text/javascript"></script>

    <script type="text/javascript">
        Ext.onReady(function () {
            var store_Redis_Declare = Ext.create('Ext.data.JsonStore', {
                fields: ['ID', 'CODE', 'DECLARATIONCODE', 'CUSTOMAREACODE', 'STATUS', 'CUSTOMSSTATUS', 'ORDERCODE'],
                pageSize: 20,
                proxy: {
                    type: 'ajax',
                    url: 'Declaration.aspx?action=loadredisclare',
                    reader: {
                        root: 'rows',
                        type: 'json',
                        totalProperty: 'total'
                    }
                },
                autoLoad: true
            })
            var toolbar = Ext.create('Ext.toolbar.Toolbar', {
                items: [
                              {
                                  xtype: 'button', text: '<i class="iconfont">&#xe60c;</i>写入报关单及明细缓存', handler: function () {
                                      Ext.Ajax.request({
                                          url: 'Declaration.aspx?action=WriteRedisDecl',
                                          callback: function (option, success, response) {
                                              var result = Ext.decode(response.responseText);
                                              if (result.success) {
                                                  Ext.Msg.alert("提示", "写入成功!", function () {
                                                      store_Redis_Declare.load();
                                                  });
                                              }
                                          }
                                      })
                                  }
                              },
                              {
                                  xtype: 'button', text: '<i class="iconfont">&#xe609;</i>清除缓存', handler: function () {
                                      Ext.Ajax.request({
                                          url: 'Declaration.aspx?action=ClearRedisDecl',
                                          callback: function (option, success, response) {
                                              var result = Ext.decode(response.responseText);
                                              if (result.success) {
                                                  Ext.Msg.alert("提示", "清除成功!", function () {
                                                      store_Redis_Declare.load();
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
                title: '报关缓存信息',
                renderTo: 'renderto',
                height: 550,
                store: store_Redis_Declare,
                selModel: { selType: 'checkboxmodel' },
                bbar: pgbar,
                tbar: toolbar,
                columns: [
                    { xtype: 'rownumberer', width: 35 },
                    { header: 'ID', dataIndex: 'ID', width: 80},//renderer: render
                    { header: '预制单编号', dataIndex: 'CODE', width: 150 },
                    { header: '报关单号', dataIndex: 'DECLARATIONCODE', width: 150 },
                    { header: '申报关区', dataIndex: 'CUSTOMAREACODE', width: 130 },
                    { header: '报关状态', dataIndex: 'STATUS', width: 150 },
                    { header: '海关状态', dataIndex: 'CUSTOMSSTATUS', width: 150 },
                    { header: '客户编号', dataIndex: 'ORDERCODE', width: 150 }
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
