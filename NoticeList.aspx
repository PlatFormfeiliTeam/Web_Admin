<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="NoticeList.aspx.cs" Inherits="Web_Admin.NoticeList" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link href="/Extjs42/resources/css/ext-all-neptune.css" rel="stylesheet" type="text/css" />
    <script src="/Extjs42/bootstrap.js" type="text/javascript"></script>
    <script src="/js/pan.js" type="text/javascript"></script>

    <script type="text/javascript">
        var pgbar;
        Ext.onReady(function () {

            var store_Notice = Ext.create('Ext.data.JsonStore', {
                fields: ['ID', 'TITLE', 'UPDATEID', 'UPDATENAME', 'ISINVALID', 'TYPE', 'UPDATETIME'],
                pageSize: 20,
                proxy: {
                    type: 'ajax',
                    url: 'NoticeList.aspx?action=load',
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
                            TITLE: Ext.getCmp("TITLE").getValue()
                        }
                        Ext.apply(store.proxy.extraParams, new_params);
                    }
                }
            })

            var toolbar = Ext.create('Ext.toolbar.Toolbar', {
                items: [
                            {
                                xtype: 'textfield', fieldLabel: '标题', labelWidth: 60, labelAlign: 'right', id: 'TITLE', flex: .80
                            },
                              {
                                  xtype: 'button', text: '<i class="iconfont">&#xe615;</i>&nbsp;查 询', handler: function () {
                                      pgbar.moveFirst();
                                  }
                              }, '-', {
                                  text: '<i class="iconfont">&#xe60b;</i>&nbsp;添 加', handler: function () {
                                      opencenterwin_no("NoticeEdit.aspx?option=add", 950, 800);
                                  }
                              }
                              , '-', {
                                  text: '<i class="icon iconfont">&#xe607;</i>&nbsp;修 改', handler: function () {

                                      var recs = gridpanel.getSelectionModel().getSelection();
                                      if (recs.length == 0) {
                                          Ext.Msg.alert("提示", "请选择修改记录!");
                                          return;
                                      }
                                      opencenterwin_no("NoticeEdit.aspx?action=load&option=update&ID=" + recs[0].get("ID"), 950, 800);
                                  }
                              }
                              , '-', {
                                  text: '<i class="icon iconfont">&#xe606;</i>&nbsp;删 除', handler: function () {
                                      var recs = gridpanel.getSelectionModel().getSelection();
                                      if (recs.length == 0) {
                                          Ext.MessageBox.alert('提示', '请选择需要删除的记录！');
                                          return;
                                      }

                                      var formIds = "";
                                      Ext.each(recs, function (rec) {
                                          formIds += "'" + rec.get("ID") + "',";
                                      })
                                      if (formIds.length > 0) { formIds = formIds.substr(0, formIds.length - 1); }

                                      Ext.MessageBox.confirm("提示", "确定要删除所选择的记录吗？", function (btn) {
                                          if (btn == 'yes') {
                                              Ext.Ajax.request({
                                                  url: 'NoticeList.aspx?action=delete',
                                                  params: { Id: formIds },
                                                  success: function (response, success, option) {
                                                      var res = Ext.decode(response.responseText);
                                                      if (res.success) {
                                                          Ext.MessageBox.alert('提示', '删除成功！');
                                                          pgbar.moveFirst();
                                                      }
                                                      else {
                                                          Ext.MessageBox.alert('提示', '删除失败！');
                                                      }
                                                  }
                                              });
                                          }
                                      });
                                  }
                              }, '->'
                ]
            })

            pgbar = Ext.create('Ext.toolbar.Paging', {
                displayMsg: '显示 {0} - {1} 条,共计 {2} 条',
                store: store_Notice,
                displayInfo: true
            })

            var gridpanel = Ext.create('Ext.grid.Panel', {
                store: store_Notice,
                height: 500,
                selModel: { selType: 'checkboxmodel' },
                bbar: pgbar,
                columns: [
                    { xtype: 'rownumberer', width: 35 },
                    { header: 'ID', dataIndex: 'ID', hidden: true },
                    { header: '标题', dataIndex: 'TITLE', width: 550 },
                    { header: '类型', dataIndex: 'TYPE', width: 150 },
                    { header: '是否启用', dataIndex: 'ISINVALID', width: 100 },
                    { header: '更新时间', dataIndex: 'UPDATETIME', width: 150 },
                    { header: '更新人', dataIndex: 'UPDATENAME', width: 150 }
                ],
                //添加双击事件
                listeners:
                {
                    'itemdblclick': function (view, record, item, index, e) {                       
                        opencenterwin_no("NoticeEdit.aspx?action=load&option=update&ID=" + record.data.ID, 950, 800);
                    }
                },
                viewConfig: {
                    enableTextSelection: true
                }
            });

            var panel = Ext.create('Ext.panel.Panel', {
                title: '资讯管理',
                tbar: toolbar,
                renderTo: 'renderto',
                minHeight: 100,
                items: [gridpanel]
            });

        });
    </script>
    <div id="renderto"></div>
</asp:Content>
