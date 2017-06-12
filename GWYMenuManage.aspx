<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="GWYMenuManage.aspx.cs" Inherits="Web_Admin.GWYMenuManage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link href="/Extjs42/resources/css/ext-all-gray.css" rel="stylesheet" type="text/css" />
    <script src="/Extjs42/bootstrap.js" type="text/javascript"></script>
    <script src="/js/pan.js" type="text/javascript"></script>
    <script src="/js/import/importExcel.js" type="text/javascript"></script>
    <link href="/font-awesome/css/font-awesome.min.css" rel="stylesheet" />

<script type="text/javascript" >
    var treeModelstore;
    var lpanel;
    var treepanel;
    Ext.onReady(function () {

        var myMask = new Ext.LoadMask(Ext.getBody(), { msg: "数据加载中，请稍等..." });
        Ext.regModel("SysModelAuth", { fields: ["id", "name", "leaf", "ParentID", "frmname", "assemblyname", "remark", "args"] });
        treeModelstore = new Ext.data.TreeStore({
            model: 'SysModelAuth',
            nodeParam: 'id',
            proxy: {
                type: 'ajax',
                url: 'GWYMenuManage.aspx?action=loadMenu',
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
        treepanel = new Ext.tree.TreePanel(
            {
                id:'treepanel',
                useArrows: true,
                animate: true,
                rootVisible: false,
                columnWidth: .65,
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
                    itemclick: function (node,e) {
                        var recs = Ext.getCmp('treepanel').getSelectionModel().getSelection();
                        if (recs.length > 0) {
                            lpanel.getForm().setValues(recs[0].data);
                        }
                    }
                }
            }
        );

        //创建按钮栏
        var btnAdd = Ext.create('Ext.Button', {
            text: '新 增',
            width: 80,
            handler: function () {
                var recs = Ext.getCmp('treepanel').getSelectionModel().getSelection();
                if (recs.length == 0) {
                    Ext.MessageBox.alert('提示', '请选择要新增的父节点！');
                    return;
                }
                cat_edit_win(recs[0].data, "add")
            }
        });
        var btnAlt = Ext.create('Ext.Button', {
            text: '修 改',
            width: 80,
            handler: function () {
                var recs = Ext.getCmp('treepanel').getSelectionModel().getSelection();
                if (recs.length == 0) {
                    Ext.MessageBox.alert('提示', '请选择要修改的节点！');
                    return;
                }
                cat_edit_win(recs[0].data, "update")
            }
        });
        var btnDel = Ext.create('Ext.Button', {
            text: '删 除',
            width: 80,
            handler: function () {
                var recs = Ext.getCmp('treepanel').getSelectionModel().getSelection();
                if (recs.length == 0) {
                    Ext.MessageBox.alert('提示', '请选择要删除的节点！');
                    return;
                }
                Ext.MessageBox.confirm(
                     "请确认"
                    , "确定删除该节点及其子节点吗？"
                    , function (button, text) {
                        if (button == 'yes') {
                            Ext.Ajax.request({
                                url: 'GWYMenuManage.aspx',
                                params: { action: 'delete', ID: recs[0].data.id },//id区分大小写
                                type: 'Post',
                                success: function (response, option) {
                                    var data = Ext.decode(response.responseText);
                                    if (data.success) {
                                        //重新加载数据
                                        treeModelstore.load();
                                        //默认选中根节点
                                        var record = treepanel.getRootNode();
                                        treepanel.getSelectionModel().select(record);
                                        //置空form
                                        Ext.each(lpanel.getForm().getFields().items, function (field) {
                                            field.reset();
                                        });
                                        Ext.MessageBox.alert('提示', '删除成功');
                                    }
                                    else
                                        Ext.MessageBox.alert('提示', '删除失败');
                                }
                            })
                        }
                    }
                );
            }
        });
        var t_bar = Ext.create('Ext.toolbar.Toolbar', {
            items: [btnAdd, btnAlt, btnDel]
        });
        
        lpanel = Ext.create('Ext.form.Panel', {
            name: 'lpanel',
            width: 500,
            margin: '10,0,0,0',
            border:0,
            defaults:{xtype:'textfield',labelAlign:'right',labelWidth:80},
            items: [
                { name: 'name', anchor: '95%', fieldLabel: '菜 单' },
                { name: 'assemblyname', anchor: '95%', fieldLabel: '所属DLL' },
                { name: 'frmname', anchor: '95%', fieldLabel: 'FORM窗口' },
                { name: 'args', anchor: '95%', fieldLabel: '窗口参数' },
                { name: 'remark', anchor: '95%', fieldLabel: '备 注' }
            ]
        });


        Ext.create('Ext.form.Panel', {
            title: '菜单管理',
            renderTo: 'div_form',
            tbar: t_bar,
            layout:'column',
            items: [treepanel,lpanel]
        });
    })

    function cat_edit_win(item, action) {
        var formpanel_cat = Ext.create('Ext.form.Panel', {
            layout: 'anchor',
            region: 'center',
            defaults: { labelWidth:60,labelAlign: 'right', xtype: 'textfield', msgTarget: 'under', margin: '8,0,0,0,0' },
            items: [
            { name: 'name', anchor: '95%', fieldLabel: '菜 单' },
            { name: 'assemblyname', anchor: '95%', fieldLabel: '所属DLL' },
            { name: 'frmname', anchor: '95%', fieldLabel: 'FORM窗口' },
            { name: 'args', anchor: '95%', fieldLabel: '窗口参数' },
            { name: 'remark', anchor: '95%', fieldLabel: '备 注' },
            //{ name: 'REMARK', anchor: '95%', fieldLabel: '菜 单', allowBlank: true, emptyText: '请输入备注信息' },
            ],
            buttons: [{
                text: '保 存', handler: function () {
                    var baseForm = formpanel_cat.getForm();
                    var data = Ext.encode(formpanel_cat.getForm().getValues());
                    alert(data);
                    if (baseForm.isValid()) {
                        Ext.Ajax.request({
                            method: 'POST',
                            url: "GWYMenuManage.aspx",
                            params: { action: action, id: item.id, json: data },
                            //headers: { 'Content-Type': 'application/json;utf-8' },另一种传参方式
                            //params: "{ 'action': '" + action + "','json': '" + Ext.encode(baseForm.getValues()) + "'}",
                            success: function (response, option) {
                                var data = Ext.decode(response.responseText);
                                if (data.success) {
                                    treeModelstore.load();//重新加载数据
                                    var record = treepanel.getRootNode();//默认选中根节点
                                    treepanel.getSelectionModel().select(record);
                                    Ext.each(lpanel.getForm().getFields().items, function (field) {
                                        field.reset();
                                    });//置空form
                                    win_cat.close();//关闭维护窗口
                                    Ext.MessageBox.alert("保存成功");
                                }
                                else {
                                    Ext.MessageBox.alert("保存失败");
                                }
                            }
                        });
                    }
                }
            }],
            buttonAlign: 'center'
        })
        
        var win_cat = Ext.create("Ext.window.Window", {
            title: '菜单维护',
            width: 350,
            height: 250,
            modal: true,
            items: [formpanel_cat],
            layout: 'border',
            buttonAlign: 'center'
        });
        win_cat.show();
        if (action == "update" && item != undefined) {//如果是修改 
            formpanel_cat.getForm().setValues(item);
        }
        
    }
</script>
    <div id="div_form" ></div>
</asp:Content>
