<%@ Page Language="C#" MasterPageFile="~/Site.Master"  AutoEventWireup="true" CodeBehind="DeclStatus.aspx.cs" Inherits="Web_Admin.DeclStatus" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link href="/Extjs42/resources/css/ext-all-gray.css" rel="stylesheet" type="text/css" />
    <script src="/Extjs42/bootstrap.js" type="text/javascript"></script>
    <script src="/js/pan.js" type="text/javascript"></script>

    <script type="text/javascript">
        Ext.onReady(function () {
            var store_Redis_Declare = Ext.create('Ext.data.JsonStore', {
                fields: ['ORDECODE', 'STATUSCODE', 'STATUSNAME', 'STATUSTIME','TYPE'],
                pageSize: 20,
                proxy: {
                    type: 'ajax',
                    url: 'DeclStatus.aspx?action=loadredisclareStatus',
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
                                  xtype: 'button', text: '<i class="iconfont">&#xe60c;</i>写入报关状态缓存', handler: function () {
                                      Ext.Ajax.request({
                                          url: 'DeclStatus.aspx?action=WriteRedisDeclStatus',
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
                                          url: 'DeclStatus.aspx?action=ClearRedisDeclStatus',
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
                                  },
                                {
                                xtype: 'textfield', fieldLabel: '订单编号', labelWidth: 80, labelAlign: 'right', id: 'ORDERCODE'
                                },
                              {
                                  xtype: 'button', text: '<i class="iconfont">&#xe60c;</i>指定单号写入', handler: function () {
                                      Ext.Ajax.request({
                                          url: 'DeclStatus.aspx?action=WriteRedisDeclStatus',
                                          params: {
                                              ordercode: Ext.getCmp("ORDERCODE").getValue(),
                                          },
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
                                  xtype: 'textfield', fieldLabel: '关键字', labelWidth: 80, labelAlign: 'right', id: 'cusno'
                              },
                              {
                                  xtype: 'button', text: '<i class="iconfont">&#xe60c;</i>查询', handler: function () {
                                      store_Redis_Declare.getProxy().setExtraParam("cusno", Ext.getCmp("cusno").getValue());
                                      store_Redis_Declare.load();
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
                title: '报关状态缓存信息',
                renderTo: 'renderto',
                height: 550,
                store: store_Redis_Declare,
                selModel: { selType: 'checkboxmodel' },
                bbar: pgbar,
                tbar: toolbar,
                columns: [
                    { xtype: 'rownumberer', width: 35 },
                    { header: '状态', dataIndex: 'TYPE', width: 150 },
                    { header: '客户编号', dataIndex: 'ORDERCODE', width: 150 },
                    { header: '状态码', dataIndex: 'STATUSCODE', width: 150 },
                    { header: '状态名', dataIndex: 'STATUSNAME', width: 130 },
                    { header: '状态更新时间', dataIndex: 'STATUSTIME', width: 150 }
                    //{ header: '海关状态', dataIndex: 'CUSTOMSSTATUS', width: 150 },
                    //{ header: '客户编号', dataIndex: 'ORDERCODE', width: 150 }
                ]
            })

        });


    </script>
    <div id="renderto"></div>
</asp:Content>
