﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RoleAuthList.aspx.cs" Inherits="Web_Admin.RoleAuthList" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link href="/Extjs42/resources/css/ext-all-gray.css" rel="stylesheet" type="text/css" />
    <script src="/Extjs42/bootstrap.js" type="text/javascript"></script>

    <script>
        var treeModelstore, treeModel;
        var roleid = '';
        Ext.onReady(function () {
            var store_role = Ext.create('Ext.data.JsonStore', {
                fields: ['ROLEID', 'ROLENAME'],
                data: [{ "ROLEID": "ISCUSTOMER", "ROLENAME": "客户" }, { "ROLEID": "ISSHIPPER", "ROLENAME": "供应商" }, { "ROLEID": "ISCOMPANY", "ROLENAME": "生产型企业" }]
            });

            var gridpanel_role = Ext.create('Ext.grid.Panel', {
                id: 'gridpanel_role',
                border: 1, columnWidth: .35,
                store: store_role,
                minHeight: 150,
                enableColumnHide: false,
                columns: [
                { xtype: 'rownumberer', width: 35 },
                { header: '角色名称', dataIndex: 'ROLENAME' }
                ],
                listeners: {
                    itemclick: function (value, record, item, index, e, eOpts) {
                        treeModelstore.setProxy({
                            type: 'ajax',
                            url: 'RoleAuthList.aspx?action=loadroleauthority',
                            reader: 'json'
                        });
                        roleid = record.get("ROLEID");
                        var proxys = treeModelstore.proxy;
                        proxys.extraParams.roleid = roleid;
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
            Ext.regModel("SysModelAuth", { fields: ["id", "name", "leaf", "url", "ParentID"] });
            treeModelstore = new Ext.data.TreeStore({
                model: 'SysModelAuth',
                nodeParam: 'id',
                proxy: {
                    type: 'ajax',
                    url: 'RoleAuthList.aspx?action=loadroleauthority',
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
                rootVisible: false, columnWidth: .65,
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
            var bbar_r = '<div class="btn-group" role="group">'
                      + '<button type="button" onclick="SaveRoleAuthor()" class="btn btn-primary btn-sm"><i class="icon iconfont" style="font-size:12px;">&#xe7d2;</i>&nbsp;分 配</button></div>'

            //保存按钮
            var toolbar = Ext.create('Ext.toolbar.Toolbar', {
                items: ["->", bbar_r]//{ text: '<button type="button"><i class="icon iconfont">&#xe60c;</i>&nbsp;保存</button>', border: 1, handler: function () { SaveRoleAuthor(); } }
            });

            var panel = Ext.create('Ext.panel.Panel', {
                title: "<font size=2>角色权限管理</font>",
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
                    moduleids += "'" + recs[i].data.id + "',";
                }
                moduleids = moduleids = "" ? moduleids : moduleids.substr(0, moduleids.length - 1);

                var mask = new Ext.LoadMask(Ext.getBody(), { msg: "保存当前角色数据中，请稍等..." });
                mask.show();
                Ext.Ajax.request({
                    timeout: 1000000000,
                    url: 'RoleAuthList.aspx?action=RoleAuthorSave',
                    params: { moduleids: moduleids, roleid: roleid },
                    success: function (option, success, response) {
                        if (option.responseText == '{success:true}') {
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
