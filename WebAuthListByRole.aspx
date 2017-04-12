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
                        + '<button type="button" onclick="SaveAuthorByRole()" class="btn btn-primary btn-sm"><i class="icon iconfont" style="font-size:12px;">&#xe60c;</i>&nbsp;保 存</button></div>'
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
                    { header: '生产型企业', dataIndex: 'ISCOMPANY', width: 85, renderer: render }//,
                    //{
                    //    header: '操作权限', dataIndex: 'ID', flex:1, renderer: function render(value, cellmeta, record, rowIndex, columnIndex, store) {
                    //        var str = "<span style='cursor: pointer;' onclick='SaveAuthorByRole(\"" + record.get("ID") + "\",\"" + record.get("ISCUSTOMER") + "\",\"" + record.get("ISSHIPPER") + "\",\"" + record.get("ISCOMPANY") + "\")'><i class='iconfont'>&#xe7d2;</i>&nbsp;分配</span>";
                    //        str += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    //        str += "<span style='cursor: pointer;' onclick='SearchByRole(\"" + record.get("ID") + "\")'><i class='iconfont'>&#xe62f;</i>&nbsp;查看</span>";
                    //        return str;
                    //    }
                    //}
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
                rootVisible: false, columnWidth: .35,
                store: treeModelstore,
                height: 500,
                columns: [
                { text: 'id', dataIndex: 'id', width: 500, hidden: true },
                { text: 'leaf', dataIndex: 'leaf', width: 100, hidden: true },
                { header: '模块名称', xtype: 'treecolumn', text: 'name', dataIndex: 'name', flex: 1 },
                { text: 'ParentID', dataIndex: 'ParentID', width: 100, hidden: true }
                ]
            });

            var panel = Ext.create('Ext.panel.Panel', {
                title: '<font size=2>主账号BY角色</font>', tbar: toolbar,
                layout: 'column',
                renderTo: 'renderto',
                minHeight: 100,
                items: [gridUser, treeModel]
            });
        });

        function SaveAuthorByRole(userid, ISCUSTOMER, ISSHIPPER, ISCOMPANY) {
            var mask = new Ext.LoadMask(Ext.getBody(), { msg: "保存当前账户权限数据并同步更新子账号数据中，请稍等..." });
            mask.show();
            Ext.Ajax.request({
                timeout: 1000000000,
                url: 'WebAuthListByRole.aspx?action=SaveAuthorByRole',
                params: { userid: userid, ISCUSTOMER: ISCUSTOMER, ISSHIPPER: ISSHIPPER, ISCOMPANY: ISCOMPANY },
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

    </script>

    <div id="renderto"></div>
</asp:Content>
