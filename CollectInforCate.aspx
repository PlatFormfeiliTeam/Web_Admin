<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CollectInforCate.aspx.cs" Inherits="Web_Admin.CollectInforCate" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link href="/Extjs42/resources/css/ext-all-neptune.css" rel="stylesheet" type="text/css" />
    <script src="/Extjs42/bootstrap.js" type="text/javascript"></script>
    <script src="/js/pan.js" type="text/javascript"></script>

    <script type="text/javascript">
        var store_CollectInforCate;
        Ext.onReady(function () {

            Ext.regModel("CollectInforCate", { fields: ["ID", "NAME", "ICON", "DESCRIPTION", "SORTINDEX"] });
            store_CollectInforCate = Ext.create("Ext.data.JsonStore", {
                model: "CollectInforCate",
                pageSize: 25,
                proxy: {
                    url: "CollectInforCate.aspx?action=select",
                    type: "ajax",
                    reader: {
                        type: "json",
                        root: "rows",
                        totalProperty: "total"
                    }
                },
                autoLoad: true
            });

            var pgbar = Ext.create("Ext.toolbar.Paging", {
                store: store_CollectInforCate,
                displayMsg: '显示 {0} - {1} 条,共计 {2} 条',
                displayInfo: true
            })

            var gridpanel = Ext.create('Ext.grid.Panel', {
                title: '常用查询',
                height: 550,
                region: 'center',
                selModel: { selType: 'checkboxmodel' },
                store: store_CollectInforCate,
                columnLines: true,
                columns: [
                { xtype: 'rownumberer', width: 35, tdCls: 'tdValign' },
                { header: 'ID', dataIndex: 'ID', width: 200, sortable: true, hidden: true },
                { header: '常用类别', dataIndex: 'NAME', width: 200, sortable: true, tdCls: 'tdValign' },
                { header: '描述', dataIndex: 'DESCRIPTION', flex: 1, sortable: true, tdCls: 'tdValign' },
                {
                    header: '图标', dataIndex: 'ICON', width: 100, renderer: function (value) {
                        return "<i class=\"icon iconfont\" style=\"font-size: 23px;\">&#x" + value + ";</i>";
                    }
                },
                { header: '排列顺序', dataIndex: 'SORTINDEX', width: 100, sortable: true },
                {
                    header: '操作', dataIndex: 'ID', width: 70, renderer: function render(value, cellmeta, record, rowIndex, columnIndex, store) {
                        return "<a style='cursor: pointer;' onclick='editcate(\"" + record.get("ID") + "\",\"" + record.get("NAME") + "\",\"" + record.get("DESCRIPTION") + "\",\"" + record.get("SORTINDEX") + "\")'><i class=\"icon iconfont\">&#xe632;</i></a>";
                    }
                }
                ],
                bbar: pgbar,
                plugins: [{
                    ptype: 'rowexpander',
                    rowBodyTpl: ['<div id="div_{ID}"></div>']
                }]

            })

            var viewport = Ext.create('Ext.panel.Panel', {
                renderTo: 'renderTo',
                items: [gridpanel]
            });

            gridpanel.view.on('expandBody', function (rowNode, record, expandRow, eOpts) {
                displayInnerGrid(record.get('ID'));
            });
            gridpanel.view.on('collapsebody', function (rowNode, record, expandRow, eOpts) {
                destroyInnerGrid(record.get("ID"));
            });

        });

        function editcate(id, name, description, sortindex) {
            var field_id = Ext.create('Ext.form.field.Hidden', { name: 'ID', value: id });

            var field_NAME = Ext.create('Ext.form.field.Text', {
                name: 'NAME', fieldLabel: '类别', allowBlank: false, labelAlign: 'right', msgTarget: 'under', margin: '5', anchor: '90%', blankText: '名称不能为空!', value: name
            });
            var field_DESCRIPTION = Ext.create('Ext.form.field.Text', {
                name: 'DESCRIPTION', fieldLabel: '描述', allowBlank: false, labelAlign: 'right', msgTarget: 'under', margin: '5', anchor: '90%', blankText: '描述不能为空!', value: description
            });
            var field_SORTINDEX = Ext.create('Ext.form.Number', {
                name: 'SORTINDEX', fieldLabel: '排列顺序', allowBlank: false, labelAlign: 'right', anchor: '90%', margin: '5', msgTarget: 'under', blankText: '排列顺序不能为空!', value: sortindex
            });
            var formpanel = Ext.create('Ext.form.Panel', {
                id: 'f_formpanel',
                region: 'center',
                height: 250,
                buttonAlign: 'center',
                items: [field_id, field_NAME, field_DESCRIPTION, field_SORTINDEX],
                buttons: [{
                    text: '保 存',
                    handler: function () {
                        if (formpanel.getForm().isValid()) {
                            var formdata = Ext.encode(Ext.getCmp('f_formpanel').getForm().getValues());

                            Ext.getCmp('f_formpanel').getForm().submit({
                                url: 'CollectInforCate.aspx',
                                params: { formdata: formdata, action: 'save' },
                                waitMsg: '保存中...', //提示等待信息  
                                success: function (form, action) {
                                    Ext.Msg.alert('提示', '保存成功', function () {
                                        store_CollectInforCate.load();
                                        Ext.getCmp("win_d").close();
                                    });
                                },
                                failure: function (form, action) {//失败要做的事情 
                                    Ext.MessageBox.alert("提示", "保存失败!", function () { Ext.getCmp("win_d").close(); });
                                }
                            });

                        }
                    }
                }]
            });
            var win = Ext.create("Ext.window.Window", {
                id: "win_d",
                title: '常用查询',
                width: 500,
                height: 300,
                modal: true,
                items: [Ext.getCmp('f_formpanel')]
            });
            win.show();
        }

        function displayInnerGrid(div) {
            var toolbar = Ext.create('Ext.toolbar.Toolbar', {
                items: [
                    {
                        text: '<i class="iconfont">&#xe622;</i>&nbsp;添加', handler: function () {
                            opencenterwin("CollectInforCateEdit.aspx?rid_type=" + div, 600, 300);
                        }
                    }
                    , '-',
                    {
                        text: '<i class="icon iconfont">&#xe632;</i>&nbsp;修改', handler: function () {
                            var recs = grid_inner.getSelectionModel().getSelection();
                            if (recs.length == 0) {
                                Ext.MessageBox.alert('提示', '请选择需要修改的记录！');
                                return;
                            }
                            opencenterwin("CollectInforCateEdit.aspx?rid_type=" + div + "&id=" + recs[0].get('ID'), 600, 300);
                        }
                    }
                    , '-',
                    {
                        text: '<i class="icon iconfont">&#xe6d3;</i>&nbsp;删除', handler: function () {
                            var recs = grid_inner.getSelectionModel().getSelection();
                            if (recs.length == 0) {
                                Ext.MessageBox.alert('提示', '请选择需要删除的记录！');
                                return;
                            }
                            Ext.MessageBox.confirm("提示", "确定要删除所选择的记录吗？", function (btn) {
                                if (btn == 'yes') {
                                    Ext.Ajax.request({
                                        url: 'CollectInforCate.aspx?action=delete',
                                        params: { id: recs[0].get("ID"), icon: recs[0].get("ICON") },
                                        callback: function () {
                                            Ext.MessageBox.alert('提示', '删除成功！');
                                            store_inner.reload();
                                        }
                                    })
                                }
                            });
                        }
                    }
                ]
            })
            var store_inner = Ext.create('Ext.data.JsonStore', {
                fields: ['ID', 'NAME', 'URL', 'RID_TYPE', 'ICON', 'ISINVALID', 'CREATETIME'],
                proxy: {
                    url: 'CollectInforCate.aspx?action=loaddetail&id=' + div,
                    type: 'ajax',
                    reader: {
                        type: 'json',
                        root: 'innerrows'
                    }
                },
                autoLoad: true
            })
            var grid_inner = Ext.create('Ext.grid.Panel', {
                store: store_inner, tbar: toolbar,
                margin: '0 0 0 70',
                selModel: { selType: 'checkboxmodel' },
                columns: [
                    { xtype: 'rownumberer', width: 25 },
                    { header: 'ID', dataIndex: 'ID', hidden: true },                    
                    { header: '名称', dataIndex: 'NAME', width: 200 },
                    { header: '链接地址', dataIndex: 'URL', flex: 1 },
                    {
                        header: '图标', dataIndex: 'ICON', width: 100, renderer: function (value) {
                            return "<img style='width:46px;height:60px' src='" + value + "'/>";
                        }
                    },
                    {
                        header: '状态', dataIndex: 'ISINVALID', width: 120, renderer: function (value) {
                            return value = "0" ? "启用" : "禁用";
                        }
                    },
                    { header: '创建时间', dataIndex: 'CREATETIME', width: 150 }
                ],
                renderTo: 'div_' + div
            })

            grid_inner.getEl().swallowEvent([
                'mousedown', 'mouseup', 'click',
                'contextmenu', 'mouseover', 'mouseout',
                'dblclick', 'mousemove'
            ]);

        }
        function destroyInnerGrid(div) {
            var parent = document.getElementById('div_' + div);
            var child = parent.firstChild;
            while (child) {
                child.parentNode.removeChild(child);
                child = child.nextSibling;
            }
        }

    </script>

    <div id="renderTo"></div>
</asp:Content>
