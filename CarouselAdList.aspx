<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CarouselAdList.aspx.cs" Inherits="Web_Admin.CarouselAdList" %>

 <asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link href="../../Extjs42/resources/css/ext-all-neptune.css" rel="stylesheet" type="text/css" />
    <script src="../../Extjs42/bootstrap.js" type="text/javascript"></script>
    <script src="../../js/pan.js" type="text/javascript"></script>
    <link href="../../font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css" />

    <style type="text/css">
        .tdValign {
            vertical-align: middle;
        }
    </style>

    <script type="text/javascript">
        var store_CarouselAd;
        Ext.onReady(function () {
            var toolbar = Ext.create('Ext.toolbar.Toolbar', {
                items: [
                    {
                        text: '<i class="fa fa-plus fa-fw"></i>&nbsp;添加', handler: function () {
                            opencenterwin("CarouselAdEdit.aspx", 800, 500);
                        }
                    }
                    , '-',
                    {
                        text: '<i class="fa fa-pencil-square-o"></i>&nbsp;修改', handler: function () {
                            var recs = gridpanel.getSelectionModel().getSelection();
                            if (recs.length == 0) {
                                Ext.MessageBox.alert('提示', '请选择需要修改的记录！');
                                return;
                            }
                            opencenterwin("CarouselAdEdit.aspx?id=" + recs[0].get('ID'), 800, 500);
                        }
                    }
                    , '-',
                    {
                        text: '<i class="fa fa-times"></i>&nbsp;删除', handler: function () {
                            var recs = gridpanel.getSelectionModel().getSelection();
                            if (recs.length == 0) {
                                Ext.MessageBox.alert('提示', '请选择需要删除的记录！');
                                return;
                            }
                            Ext.MessageBox.confirm("提示", "确定要删除所选择的记录吗？", function (btn) {
                                if (btn == 'yes') {
                                    Ext.Ajax.request({
                                        url: 'CarouselAdList.aspx?action=delete',
                                        params: { id: recs[0].get("ID") },
                                        callback: function () {
                                            Ext.MessageBox.alert('提示', '删除成功！');
                                            store_CarouselAd.reload();
                                        }
                                    })
                                }
                            });
                        }
                    }
                ]
            })

            Ext.regModel("CarouselAd",
            {
                fields: ["ID", "IMGURL", "LINKURL", "DESCRIPTION", "STATUS", "FILENAME", "SORTINDEX"]
            });

            store_CarouselAd = Ext.create("Ext.data.JsonStore", {
                model: "CarouselAd",
                pageSize: 25,
                proxy: {
                    url: "CarouselAdList.aspx?action=select",
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
                store: store_CarouselAd,
                displayMsg: '显示 {0} - {1} 条,共计 {2} 条',
                displayInfo: true
            })

            var gridpanel = Ext.create('Ext.grid.Panel', {
                tbar: toolbar,
                title: '轮播广告',
                region: 'center',
                selModel: { selType: 'checkboxmodel' },
                store: store_CarouselAd,
                columnLines: true,
                columns: [
                { xtype: 'rownumberer', width: 35, tdCls: 'tdValign' },
                { header: 'ID', dataIndex: 'ID', width: 200, sortable: true, hidden: true },
                { header: '图片名称', dataIndex: 'FILENAME', flex: 1, sortable: true, tdCls: 'tdValign' },
                { header: '链接地址', dataIndex: 'LINKURL', width: 200, sortable: true, tdCls: 'tdValign' },
                { header: '描述', dataIndex: 'DESCRIPTION', width: 200, sortable: true, tdCls: 'tdValign' },
                {
                    header: '缩略图', dataIndex: 'IMGURL', width: 100, renderer: function (value) {
                        return "<img style='width:80px;height:40px' src='" + value + "'/>";
                    }
                },
                {
                    header: '状态', dataIndex: 'STATUS', width: 100, sortable: true, renderer: function (value) {
                        if (value == 'true') {
                            return '启用';
                        } else {
                            return '停用';
                        };
                    }
                },
                { header: '排列顺序', dataIndex: 'SORTINDEX', width: 100, sortable: true }
                ],
                bbar: pgbar
            })

            var viewport = Ext.create('Ext.panel.Panel', {
                renderTo: 'renderTo',
                items: [gridpanel]
            })

        })

    </script>

<%--
    <form id="form1" >--%>
        <div id="renderTo">
        </div>
   <%-- </form>--%>
</asp:Content>
