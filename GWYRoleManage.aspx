<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="GWYRoleManage.aspx.cs" Inherits="Web_Admin.GWYRoleManage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link href="/Extjs42/resources/css/ext-all-gray.css" rel="stylesheet" type="text/css" />
    <script src="/Extjs42/bootstrap.js" type="text/javascript"></script>

    <script>
        var treeModelstore, treeModel;
        var roleid = '';
        Ext.onReady(function () {
            var store_role = Ext.create('Ext.data.JsonStore', {
                fields: ['ID', 'CODE', 'NAME'],
                proxy: {
                    type: 'ajax',
                    reader: {
                        root: 'rows',
                        type: 'json',
                    },
                    url:'GWYRoleManage.aspx?action=loadManager',
                },
                autoLoad:true
            });

            var gridpanel_role = Ext.create('Ext.grid.Panel', {
                id: 'gridpanel_role',
                border: 1, columnWidth: .35,
                store: store_role,
                minHeight: 150,
                enableColumnHide: false,
                columns: [
                { xtype: 'rownumberer', width: 35 },
                { header: '客商代码', dataIndex: 'CODE' },
                { header: '客商名称', dataIndex: 'NAME' }
                ],
                listeners: {
                    itemclick: function (value, record, item, index, e, eOpts) {
                        //treeModelstore.setProxy({
                        //    type: 'ajax',
                        //    url: 'GWYRoleManage.aspx?action=loadmenu',
                        //    reader: 'json'
                        //});
                        roleid = record.data.ID;
                        treeModelstore.proxy.extraParams.roleid = roleid;
                        treeModelstore.load();
                    }
                },
                viewConfig: {
                    enableTextSelection: true
                },
                forceFit: true
            });

            var myMask = new Ext.LoadMask(Ext.getBody(), { msg: "数据加载中，请稍等..." });

            //系统模块
            var myMask = new Ext.LoadMask(Ext.getBody(), { msg: "数据加载中，请稍等..." });
            Ext.regModel("SysModelAuth", { fields: ["id", "name", "leaf", "ParentID", "frmname", "assemblyname", "remark", "args"] });
            treeModelstore = new Ext.data.TreeStore({
                model: 'SysModelAuth',
                nodeParam: 'id',
                proxy: {
                    type: 'ajax',
                    url: 'GWYRoleManage.aspx?action=loadmenu',
                    reader: 'json'
                },
                root: {
                    expanded: true,
                    name: '前端模块',
                    id: '-1'
                },
                listeners: {
                    beforeload: function () {
                        myMask.show();
                    },
                    load: function (st, rds, opts) {
                        if (myMask) { myMask.hide(); }
                    }
                }
            });
            treeModel = Ext.create('Ext.tree.Panel', {
                useArrows: true,
                animate: true,
                rootVisible: false, columnWidth: .65,
                store: treeModelstore,
                height: 500,
                columns: [
                { text: 'id', dataIndex: 'id', width: 500, hidden: true },
                { text: 'leaf', dataIndex: 'leaf', width: 100, hidden: true },
                { text: 'ParentID', dataIndex: 'ParentID', width: 100, hidden: true },
                { text: 'frmname', dataIndex: 'frmname', width: 100, hidden: true },
                { text: 'assemblyname', dataIndex: 'assemblyname', width: 100, hidden: true },
                { text: 'remark', dataIndex: 'remark', width: 100, hidden: true },
                { text: 'args', dataIndex: 'args', width: 100, hidden: true },
                { text: 'name', dataIndex: 'name', header: '模块名称', xtype: 'treecolumn', flex: 1 }
                ],
                listeners: {
                    'checkchange': function (node, checked) {
                        setChildChecked(node, checked);
                        setParentChecked(node, checked);
                    }
                }
            });
            var bbar_r = '<div class="btn-group" role="group">'
                      + '<button type="button" onclick="SaveRoleAuthor()" class="btn btn-primary btn-sm"><i class="icon iconfont" style="font-size:12px;">&#xe7d2;</i>&nbsp;分 配</button></div>'

            //保存按钮
            var toolbar = Ext.create('Ext.toolbar.Toolbar', {
                items: ["->", bbar_r]//{ text: '<button type="button"><i class="icon iconfont">&#xe60c;</i>&nbsp;保存</button>', border: 1, handler: function () { SaveRoleAuthor(); } }
            });

            var panel = Ext.create('Ext.panel.Panel', {
                title: "<font size=2>客商权限配置</font>",
                renderTo: "renderto",
                tbar: toolbar,
                layout: 'column',
                items: [gridpanel_role, treeModel]
            })
        });

        //选择子节点
        function setChildChecked(node, checked) {
            node.expand();
            node.set('checked', checked);
            if (node.hasChildNodes()) {
                node.eachChild(function (child) {
                    setChildChecked(child, checked);
                });
            }
        }

        //选择父节点
        function setParentChecked(node, checked) {
            node.set({ checked: checked });
            var parentNode = node.parentNode;
            if (parentNode != null) {
                var flag = false;
                parentNode.eachChild(function (childnode) {
                    if (childnode.get('checked')) {
                        flag = true;
                    }
                });
                if (checked == false) {
                    if (!flag) {
                        setParentChecked(parentNode, checked);
                    }
                } else {
                    if (flag) {
                        setParentChecked(parentNode, checked);
                    }
                }
            }
        }

        function SaveRoleAuthor() {
            if (roleid) {
                var moduleids = "";
                var recs = treeModel.getChecked();
                for (var i = 0; i < recs.length; i++) {
                    moduleids += recs[i].data.id + ",";
                }
                moduleids = moduleids = "" ? moduleids : moduleids.substr(0, moduleids.length - 1);

                var mask = new Ext.LoadMask(Ext.getBody(), { msg: "保存当前角色数据中，请稍等..." });
                mask.show();
                Ext.Ajax.request({
                    timeout: 1000000000,
                    url: 'GWYRoleManage.aspx?action=saveMenuConfig',
                    params: { moduleids: moduleids, roleid: roleid },
                    success: function (option, success, response) {
                        var data = Ext.decode(option.responseText);
                        if (data.success) {
                            treeModelstore.load();
                            Ext.MessageBox.alert('提示', '保存成功！');
                        } else {
                            Ext.MessageBox.alert('提示', '保存失败！');
                        }
                        mask.hide();
                    }
                });
            }
            else {
                Ext.MessageBox.alert('提示', '请先选择需要授权的角色！');
            }
        }
    </script>

    <div id="renderto"></div>
</asp:Content>
