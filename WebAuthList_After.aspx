<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="WebAuthList_After.aspx.cs" Inherits="Web_Admin.WebAuthList_After" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
        <link href="/Extjs42/resources/css/ext-all-gray.css" rel="stylesheet" type="text/css" />
    <script src="/Extjs42/bootstrap.js" type="text/javascript"></script>
    <script src="/js/pan.js" type="text/javascript"></script>
    <script type="text/javascript">
        var gridUser, store_user, treeModel, treeModelstore, gridStation, store_Station;
        var userid = '';
        Ext.onReady(function () {
            Ext.regModel('User', { fields: ['ID', 'NAME', 'REALNAME'] })
            store_user = Ext.create('Ext.data.JsonStore', {
                model: 'User',
                proxy: {
                    type: 'ajax',
                    url: 'WebAuthList_After.aspx?action=loaduser',
                    reader: {
                        root: 'rows',
                        type: 'json'
                    }
                },
                autoLoad: true
            })

            gridUser = Ext.create('Ext.grid.Panel', {
                width: 500,
                height: 500,
                renderTo: "div_west",
                store: store_user,
                columns: [
                    { xtype: 'rownumberer', width: 35 },
                    { header: 'ID', dataIndex: 'ID', hidden: true },
                    { header: '登录名', dataIndex: 'NAME', width: 180 },
                    { header: '姓名', dataIndex: 'REALNAME', width: 180 }
                ],
                listeners: {
                    itemclick: function (value, record, item, index, e, eOpts) {
                        treeModelstore.setProxy({
                            type: 'ajax',
                            url: 'WebAuthList.aspx?action=loadauthority',
                            reader: 'json'
                        });
                        userid = record.get("ID");
                        var proxys = treeModelstore.proxy;
                        proxys.extraParams.userid = userid;
                        treeModelstore.load();
                    }
                }
            })

            var myMask = new Ext.LoadMask(Ext.getBody(), { msg: "数据加载中，请稍等..." });

            //系统模块
            Ext.regModel("SysModelAuth", { fields: ["id", "name", "leaf", "url", "ParentID"] });
            treeModelstore = new Ext.data.TreeStore({
                model: 'SysModelAuth',
                nodeParam: 'id',
                proxy: {
                    type: 'ajax',
                    url: 'WebAuthList_After.aspx?action=loadauthority',
                    reader: 'json'
                },
                root: {
                    expanded: true,
                    name: '后端模块',
                    id: '91a0657f-1939-4528-80aa-91b202a593ac'
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
                rootVisible: false,
                renderTo: "div_east",
                store: treeModelstore,
                height: 500,
                // width: 600,
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
            //var tbar = Ext.create('Ext.toolbar.Toolbar', {
            //    renderTo: 'toolbar',
            //    items: ['->', '<button onclick="SaveAuthorization()" type="button"><span class="icon iconfont" onclick="SaveAuthorization()">&#xe60c;</span>&nbsp;保 存</button>']
            //})

            //======================联动选择==========================
            /*向上遍历父结点*/
            var nodep = function (node) {
                var bnode = true;
                Ext.Array.each(node.childNodes, function (v) {
                    if (!v.data.checked) {
                        bnode = true;
                        return;
                    }
                });
                return bnode;
            };
            var parentnode = function (node) {
                if (node.parentNode != null) {
                    if (nodep(node.parentNode)) {
                        node.parentNode.set('checked', true);
                    } else {
                        node.parentNode.set('checked', false);
                    }
                    parentnode(node.parentNode);
                }
            };
            /*遍历子结点 选中 与取消选中操作*/
            var chd = function (node, check) {
                node.set('checked', check);
                if (node.isNode) {
                    node.eachChild(function (child) {
                        chd(child, check);
                    });
                }
            };
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

        function SaveAuthorization() {
            if (userid) {
                var moduleids = "";
                var recs = treeModel.getChecked();
                for (var i = 0; i < recs.length; i++) {
                    moduleids += recs[i].data.id + ',';
                }
                var mask = new Ext.LoadMask(Ext.getBody(), { msg: "保存当前账户数据并同步更新子账号数据中，请稍等..." });
                mask.show();
                Ext.Ajax.request({
                    timeout: 1000000000,
                    url: 'WebAuthList_After.aspx?action=AuthorizationSave',
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
            }
            else {
                Ext.MessageBox.alert('提示', '请先选择需要授权的账号！');
            }
        }

    </script>
    <div class="btn-group" role="group">
        <button type="button" onclick="SaveAuthorization()" class="btn btn-primary btn-sm"><i class="icon iconfont">&#xe60c;</i>&nbsp;保存</button>
    </div>
    <div>
        <div id="div_west" style="float: left; width: 35%">
        </div>
        <div id="div_east" style="float: left; width: 65%">
        </div>
    </div>
</asp:Content>
