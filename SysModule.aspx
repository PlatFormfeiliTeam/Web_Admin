<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SysModule.aspx.cs" Inherits="Web_Admin.SysModule" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link href="/Extjs42/resources/css/ext-all-gray.css" rel="stylesheet" type="text/css" />
    <script src="/Extjs42/bootstrap.js" type="text/javascript"></script>
    <script src="/js/pan.js" type="text/javascript"></script>
    <script type="text/javascript">
        var treepanel;
        var nodeid = getQueryString("nodeid");
        Ext.onReady(function () {
            Ext.regModel("SysModule", { fields: ["MODULEID", "NAME", "leaf", "URL", "PARENTID", "SORTINDEX"] });

            var toolbar = Ext.create('Ext.toolbar.Toolbar', {
                items: [
                {
                    text: '<span class="icon iconfont">&#xe60b;</span>&nbsp;添 加', handler: function () {
                        var recs = Ext.getCmp('treepanel').getSelectionModel().getSelection();
                        //可以选择父节点，也可以不选择父节点，如果不选择的话默认父节点就是根节点 
                        var parentNode;
                        if (recs.length == 0) {
                            parentNode = Ext.getCmp('treepanel').store.getRootNode();
                        }
                        else {
                            parentNode = recs[0];
                        }
                        module_edit_win(parentNode, "create");
                    }
                }, '-',
                {
                    text: '<span class="icon iconfont">&#xe607;</span>&nbsp;修 改', handler: function () {
                        var recs = treepanel.getSelectionModel().getSelection();
                        if (recs.length == 0) {
                            Ext.Msg.alert("提示", "请选择要修改的节点!");
                            return;
                        }                       
                        module_edit_win(recs[0], "update");
                    }
                }, '-', {
                    text: '<span class="icon iconfont">&#xe606;</span>&nbsp;删 除', handler: function () {
                        var recs = treepanel.getSelectionModel().getSelection();
                        if (recs.length==0) {
                            Ext.Msg.alert("提示", "请选择要删除的节点!");
                            return;
                        } 
                        if (!recs[0].data.leaf) {//删除某个节点后有可能父节点不存在
                            Ext.Msg.alert("提示", "包含子节点的对象不允许删除!");
                            return;
                        }
                        Ext.Ajax.request({
                            url: 'SysModule.aspx?action=delete',
                            params: { json: Ext.encode(recs[0].data) },
                            callback: function (option, success, response) {
                                var result = Ext.decode(response.responseText);
                                if (result.success) {
                                    Ext.Msg.alert("提示", "删除成功!", function () {
                                        var pnode = recs[0].parentNode;
                                        pnode.removeChild(recs[0]);
                                        if (!pnode.hasChildNodes()) {//删除某个节点后有可能父节点不存在
                                            pnode.set("leaf", true);
                                        }
                                    });
                                }
                            }
                        })
                    }
                }]
            })
            var treepanelstore = new Ext.data.TreeStore({
                model: 'SysModule',
                proxy: {
                    type: 'ajax',
                    url: 'SysModule.aspx?action=select',
                    reader: 'json',
                    extraParams: {
                        MODULEID: ''
                    }
                },
                root: {
                    expanded: true,
                    text: '系统模块'
                }
            });
            treepanel = Ext.create('Ext.tree.Panel', {
                id: 'treepanel',
                title: '模块管理',
                useArrows: true,
                animate: true,
                selModel: { selType: 'checkboxmodel' },
                //region: 'center',
                renderTo: 'renderto',
                tbar: toolbar,
                rootVisible: false,
                store: treepanelstore,
                columns: [
                { dataIndex: 'MODULEID', width: 120, hidden: true },
                { dataIndex: 'leaf', width: 100, hidden: true },
                { header: '模块名称', xtype: 'treecolumn', dataIndex: 'NAME', width: 300 },
                { header: '链接地址', dataIndex: 'URL', flex: 1 },
                { header: '显示顺序', dataIndex: 'SORTINDEX', width: 100, hidden: false },
                { dataIndex: 'PARENTID', hidden: true }
                ],
                listeners: {
                    itemclick: function (view, record, item, index, e, eOpts) {
                        //  view_cur = view;, hidden: true
                        //  rec_cur = record;
                        //node_cur = node;
                        //cur_index = index;
                    },
                    beforeitemexpand: function (curnode, options) {
                        var proxy = treepanel.store.getProxy();
                        proxy.extraParams.MODULEID = curnode.data.MODULEID;
                    }
                }
            });
        });
    </script>
    <div id="renderto"></div>
</asp:Content>
