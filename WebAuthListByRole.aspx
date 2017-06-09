<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="WebAuthListByRole.aspx.cs" Inherits="Web_Admin.WebAuthListByRole" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link href="/Extjs42/resources/css/ext-all-gray.css" rel="stylesheet" type="text/css" />
    <script src="/Extjs42/bootstrap.js" type="text/javascript"></script>
    <script src="/js/pan.js" type="text/javascript"></script>

    <script>
        var store_user; var treeModelstore, treeModel;
        var userid = "";
        Ext.onReady(function () {
            //保存按钮
            var bbar_r = '<div class="btn-group" role="group">'
                        + '<button type="button" onclick="SaveAuthorByRole()" class="btn btn-primary btn-sm"><i class="icon iconfont" style="font-size:12px;">&#xe7d2;</i>&nbsp;分 配</button></div>'
            var toolbar = Ext.create('Ext.toolbar.Toolbar', {
                items: [ '->', bbar_r]
            })

            Ext.regModel('User', { fields: ['ID', 'CUSTOMERNAME', 'REALNAME', 'NAME', 'ISCUSTOMER', 'ISSHIPPER', 'ISCOMPANY'] })
            store_user = Ext.create('Ext.data.JsonStore', {
                model: 'User',
                proxy: {
                    type: 'ajax',
                    url: 'WebAuthListByRole.aspx?action=loaduser',
                    reader: {
                        root: 'rows',
                        type: 'json'
                    }
                },
                autoLoad: true
            })

            var gridUser = Ext.create('Ext.grid.Panel', {
                border: 1, columnWidth: .65, height: 500,
                store: store_user,
                columns: [
                    { xtype: 'rownumberer', width: 35 },
                    { header: 'ID', dataIndex: 'ID', hidden: true },
                    { header: '账号', dataIndex: 'NAME', width: 90 },
                    { header: '姓名', dataIndex: 'REALNAME', width: 180 },
                    { header: '所属客户', dataIndex: 'CUSTOMERNAME', width: 250 },
                    { header: '客户', dataIndex: 'ISCUSTOMER', width: 60, renderer: render },
                    { header: '供应商', dataIndex: 'ISSHIPPER', width: 65, renderer: render },
                    { header: '生产型企业', dataIndex: 'ISCOMPANY', width: 85, renderer: render }
                ],
                listeners: {
                    itemclick: function (value, record, item, index, e, eOpts) {
                        treeModelstore.setProxy({
                            type: 'ajax',
                            url: 'WebAuthListByRole.aspx?action=loadauthority',
                            reader: 'json'
                        });
                        userid = record.get("ID");
                        var proxys = treeModelstore.proxy;
                        proxys.extraParams.userid = userid; 
                        proxys.extraParams.ISCUSTOMER = record.get("ISCUSTOMER"); proxys.extraParams.ISSHIPPER = record.get("ISSHIPPER"); proxys.extraParams.ISCOMPANY = record.get("ISCOMPANY");
                        treeModelstore.load();
                    }
                }
            });

            var myMask = new Ext.LoadMask(Ext.getBody(), { msg: "数据加载中，请稍等..." });

            //系统模块
            Ext.regModel("SysModelAuth", { fields: ["id", "name", "leaf", "url", "ParentID"] });
            treeModelstore = new Ext.data.TreeStore({
                model: 'SysModelAuth',
                nodeParam: 'id',
                proxy: {
                    type: 'ajax',
                    url: 'WebAuthListByRole.aspx?action=loadauthority',
                    reader: 'json'
                },
                root: {
                    expanded: true,
                    name: '前端模块',
                    id: '91a0657f-1939-4528-80aa-91b202a593ab'
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
                rootVisible: false, columnWidth: .35,
                store: treeModelstore,
                height: 500,
                columns: [
                { text: 'id', dataIndex: 'id', width: 500, hidden: true },
                { text: 'leaf', dataIndex: 'leaf', width: 100, hidden: true },
                { header: '模块名称', xtype: 'treecolumn', text: 'name', dataIndex: 'name', flex: 1 },
                { text: 'ParentID', dataIndex: 'ParentID', width: 100, hidden: true }
                ],
                listeners: {
                    'checkchange': function (node, checked) {
                        setChildChecked(node, checked);
                        setParentChecked(node, checked);
                    }
                }
            });

            var panel = Ext.create('Ext.panel.Panel', {
                title: '<font size=2>主账号BY角色</font>', tbar: toolbar,
                layout: 'column',
                renderTo: 'renderto',
                minHeight: 100,
                items: [gridUser, treeModel]
            });
        });

        function SaveAuthorByRole() {
            if (userid) {
                var moduleids = "";
                var recs = treeModel.getChecked();
                for (var i = 0; i < recs.length; i++) {
                    moduleids += recs[i].data.id + ',';
                }
                var mask = new Ext.LoadMask(Ext.getBody(), { msg: "保存当前账户权限数据并同步更新子账号数据中，请稍等..." });
                mask.show();
                Ext.Ajax.request({
                    timeout: 1000000000,
                    url: 'WebAuthListByRole.aspx?action=SaveAuthorByRole',
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

    </script>

    <div id="renderto"></div>
</asp:Content>
