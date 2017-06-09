<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="WebAuthListByPosition.aspx.cs" Inherits="Web_Admin.WebAuthListByPosition" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
        <link href="/Extjs42/resources/css/ext-all-gray.css" rel="stylesheet" type="text/css" />
    <script src="/Extjs42/bootstrap.js" type="text/javascript"></script>
    <script src="/js/pan.js" type="text/javascript"></script>

    <script>
        var treeModelstore, treeModel; var treeModelstore_r, treeModel_r;
        var userid = "";
        Ext.onReady(function () {
            //保存按钮
            var bbar_r = '<div class="btn-group" role="group">'
                        + '<button type="button" onclick="SaveAuthorByPosition()" class="btn btn-primary btn-sm"><i class="icon iconfont" style="font-size:12px;">&#xe7d2;</i>&nbsp;分 配</button></div>'
            var toolbar = Ext.create('Ext.toolbar.Toolbar', {
                items: ['->', bbar_r]
            })

            var myMask = new Ext.LoadMask(Ext.getBody(), { msg: "数据加载中，请稍等..." });

            Ext.regModel("sysuser", { fields: ["id", "name", "leaf", "url", "ParentID", "REALNAME", "positionid", "type"] });
            treeModelstore = new Ext.data.TreeStore({
                model: 'sysuser',
                nodeParam: 'id',
                proxy: {
                    type: 'ajax',
                    url: 'WebAuthListByPosition.aspx?action=loaduser',
                    reader: 'json'
                },
                root: {
                    expanded: true
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
                rootVisible: false, columnWidth: .40,
                store: treeModelstore,
                height: 500,
                columns: [
                { text: 'id', dataIndex: 'id', hidden: true },
                { text: 'leaf', dataIndex: 'leaf', width: 100, hidden: true },
                { header: '登录账号', xtype: 'treecolumn', text: 'name', dataIndex: 'name', width: 180 },
                { header: '登录名', dataIndex: 'REALNAME', flex: 1 },
                { text: 'ParentID', dataIndex: 'ParentID',hidden: true },
                { text: 'positionid', dataIndex: 'positionid', hidden: true },
                { text: 'type', dataIndex: 'type', hidden: true }
                ],
                listeners: {
                    itemclick: function (thisTree, record, item, index, e, eOpts) {
                        treeModelstore_r.setProxy({
                            type: 'ajax',
                            url: 'WebAuthListByPosition.aspx?action=loadauthority',
                            reader: 'json'
                        });
                        userid = record.data.id; type = record.data.type; positionid = record.data.positionid; ParentID = record.data.ParentID;
                        var proxys = treeModelstore_r.proxy;
                        proxys.extraParams.userid = userid; proxys.extraParams.type = type; proxys.extraParams.positionid = positionid; proxys.extraParams.ParentID = ParentID;
                        treeModelstore_r.load();
                    }
                }
            });


            var myMask_r = new Ext.LoadMask(Ext.getBody(), { msg: "数据加载中，请稍等..." });

            Ext.regModel("SysModule", { fields: ["id", "name", "leaf", "url", "ParentID"] });
            treeModelstore_r = new Ext.data.TreeStore({
                model: 'SysModule',
                nodeParam: 'id',
                proxy: {
                    type: 'ajax',
                    url: 'WebAuthListByPosition.aspx?action=loadauthority',
                    reader: 'json'
                },
                root: {
                    expanded: true,
                    id: '91a0657f-1939-4528-80aa-91b202a593ac'
                },
                listeners: {
                    beforeload: function () {
                        myMask_r.show();
                    },
                    load: function (st, rds, opts) {
                        if (myMask_r) { myMask_r.hide(); }
                    }
                }
            });
            treeModel_r = Ext.create('Ext.tree.Panel', {
                useArrows: true,
                animate: true,
                rootVisible: false, columnWidth: .60,
                store: treeModelstore_r,
                height: 500,
                columns: [
                { text: 'id', dataIndex: 'id', width: 500, hidden: true },
                { text: 'leaf', dataIndex: 'leaf', width: 100, hidden: true },
                { header: '模块名称', xtype: 'treecolumn', text: 'name', dataIndex: 'name', flex: 1 },
                { text: 'ParentID', dataIndex: 'ParentID', hidden: true }
                ],
                listeners: {
                    'checkchange': function (node, checked) {
                        setChildChecked(node, checked);
                        setParentChecked(node, checked);
                    }
                }
            });

            var panel = Ext.create('Ext.panel.Panel', {
                title: '<font size=2>账号BY组别</font>', tbar: toolbar,
                layout: 'column',
                renderTo: 'renderto',
                minHeight: 100,
                items: [treeModel, treeModel_r]
            });
            //treeModel.expandAll();
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

        function SaveAuthorByPosition() {
            if (userid) {
                var moduleids = "";
                var recs = treeModel_r.getChecked();
                for (var i = 0; i < recs.length; i++) {
                    moduleids += recs[i].data.id + ',';
                }
                var mask = new Ext.LoadMask(Ext.getBody(), { msg: "保存当前账户权限数据并同步更新子账号数据中，请稍等..." });
                mask.show();
                Ext.Ajax.request({
                    timeout: 1000000000,
                    url: 'WebAuthListByPosition.aspx?action=SaveAuthorByPosition',
                    params: { moduleids: moduleids, userid: userid },
                    success: function (option, success, response) {
                        if (option.responseText == '{success:true}') {
                            Ext.MessageBox.alert('提示', '保存成功！');
                        } else {
                            Ext.MessageBox.alert('提示', '保存失败！');
                        }
                        mask.hide();
                    }
                })
            } else {
                Ext.MessageBox.alert('提示', '请先选择需要授权的账号！');
            }
        }

    </script>

    <div id="renderto"></div>
</asp:Content>
