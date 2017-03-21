<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="NoticeList.aspx.cs" Inherits="Web_Admin.NoticeList" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link href="/Extjs42/resources/css/ext-all-neptune.css" rel="stylesheet" type="text/css" />
    <script src="/Extjs42/bootstrap.js" type="text/javascript"></script>
    <script src="/js/pan.js" type="text/javascript"></script>

    <script type="text/javascript">
        Ext.onReady(function () {
            var treepanelstore = Ext.create('Ext.data.TreeStore', {
                fields: ["ID", "NAME", "leaf", "PID"],
                proxy: {
                    type: 'ajax',
                    url: 'NewCategoryHandler.ashx',
                    reader:  'json',
                },
                root: {
                    expanded: true,
                    text: "my root"
                }
            });

            var treepanel = Ext.create('Ext.tree.Panel', {
                useArrows: true,
                animate: true,
                rootVisible: false,
                renderTo: "div_west",
                store: treepanelstore,
                height: 500,
                columns: [
                { text: 'ID', dataIndex: 'ID', width: 500, hidden: true },
                { text: 'leaf', dataIndex: 'leaf', width: 100, hidden: true },
                { header: '类别名称', xtype: 'treecolumn', text: 'NAME', dataIndex: 'NAME', flex: 1 },
                { text: 'PID', dataIndex: 'PID', width: 100, hidden: true }
                ],
                listeners: {
                    'itemclick': function (node, checked) {
                      
                    }
                }
            });
        });

    </script>
    <div>
        <div id="div_west" style="float: left; width: 15%">
        </div>
        <div id="div_east" style="float: left; width: 85%">
        </div>
    </div>
</asp:Content>
