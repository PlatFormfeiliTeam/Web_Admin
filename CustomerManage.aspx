<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CustomerManage.aspx.cs" Inherits="Web_Admin.CustomerManage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link href="/Extjs42/resources/css/ext-all-neptune.css" rel="stylesheet" type="text/css" />
    <script src="/Extjs42/bootstrap.js" type="text/javascript"></script>
    <script src="/js/pan.js" type="text/javascript"></script>
    <script src="/js/import/importExcel.js" type="text/javascript"></script>
    <link href="/font-awesome/css/font-awesome.min.css" rel="stylesheet" />

<script type="text/javascript" >
    var store_customer;
    Ext.onReady(function () {
        //创建查询条件
        var enstore = Ext.create('Ext.data.Store', {
            fields: ['code', 'name'],
            data: [
                { "code": "0", "name": "否" },
                { "code": "1", "name": "是" }
            ]
        });
        var comb=Ext.create('Ext.form.field.ComboBox',{
            id:'enabled',
            fieldLabel: '是否启用',
            store: enstore,
            displayField: 'name',
            valueField: 'code',
            width: 180,
            labelWidth: 60
        });
        var txtCode=Ext.create('Ext.form.field.Text',{
            id: 'code',
            fieldLabel: '客户代码',
            width: 180,
            labelWidth: 60
        });
        var txtCNName = Ext.create('Ext.form.field.Text', {
            id: 'cnname',
            fieldLabel: '中文名称',
            width: 180,
            labelWidth: 60
        });
        var txtENName = Ext.create('Ext.form.field.Text', {
            id: 'enname',
            fieldLabel: '英文名称',
            width: 180,
            labelWidth: 60
        });
        var txtHSCode = Ext.create('Ext.form.field.Text', {
            id: 'hscode',
            fieldLabel: '海关编码',
            width: 180,
            labelWidth: 60
        });
        var txtCIQCode = Ext.create('Ext.form.field.Text', {
            id: 'ciqcode',
            fieldLabel: '国检代码',
            width: 180,
            labelWidth: 60

        });
        var serachPnl = Ext.create('Ext.toolbar.Toolbar', {
            border: 0,
            padding:'0 0 0 30',
            items: [txtCode, txtCNName, txtCNName, txtENName, txtHSCode, txtCIQCode, comb]
        });
        //创建按钮栏
        var btnAdd = Ext.create('Ext.Button', {
            text: '新 增',
            width:80,
            handler: function () {
                opencenterwin("/addCustomer.aspx", 940, 340);
            }
        });
        var btnAlt = Ext.create('Ext.Button', {
            text: '修 改',
            width: 80,
            handler: function () {
                var recs = gridpanel.getSelectionModel().getSelection();
                if (recs.length == 0) {
                    Ext.MessageBox.alert('提示', '请选择需要查看详细的记录！');
                    return;
                }
                opencenterwin("/addCustomer.aspx?id=" + recs[0].get("ID"), 940, 340);
            }
        });
        var btnDel = Ext.create('Ext.Button', {
            text: '删 除',
            width: 80,
            handler: function () {
                var recs = gridpanel.getSelectionModel().getSelection();
                if (recs.length == 0) {
                    Ext.MessageBox.alert('提示', '请选择要删除的记录！');
                    return;
                }
                Ext.Ajax.request({
                    url: 'CustomerManage.aspx',
                    params: {action:'delete',ID:recs[0].get("ID")},
                    type: 'Post',
                    success:function(response,option)
                    {
                        var data = Ext.decode(response.responseText);
                        if (data.success)
                        {
                            store_customer.load();
                            Ext.MessageBox.alert('提示', '删除成功');
                        }
                        else
                            Ext.MessageBox.alert('提示', '删除失败');
                    }
                })
            }
        });
        var btnImport = Ext.create('Ext.Button', {
            text: '导 入',
            width: 80,
            handler: function () {
                onItemUpload('customer');
            }
        });
        var btnExport = Ext.create('Ext.Button', {
            text: '导 出',
            width: 80,
            handler: function () {
                var path = '/CustomerManage.aspx?action=export';
                $('#exportform').attr("action", path).submit();
            }
        });
        var btnQuery = Ext.create('Ext.Button', {
            text: '查 询',
            width: 80,
            handler: function () {
                //pgbar.moveFirst();也可以
                store_customer.load();
                //alert('You clicked the button!');
            }
        });
        var btnReset = Ext.create('Ext.Button', {
            text: '重 置',
            width: 80,
            handler: function () {
                Ext.getCmp("code").setValue("");
                Ext.getCmp("cnname").setValue("");
                Ext.getCmp("enname").setValue(""),
                Ext.getCmp("hscode").setValue("");
                Ext.getCmp("ciqcode").setValue("");
                Ext.getCmp("enabled").setValue("");
            }
        });
        
        var toolbar = Ext.create('Ext.toolbar.Toolbar', {
            items: [btnAdd, btnAlt, btnDel, btnImport, btnExport,'->', btnQuery, btnReset]
        });
        //创建gridview
        store_customer = Ext.create('Ext.data.JsonStore', {
            fields: ['CODE', 'HSCODE', 'CIQCODE', 'NAME', 'CHINESEABBREVIATION', 'CHINESEADDRESS', 'ISCUSTOMER'
                , 'ISSHIPPER', 'ISCOMPANY', 'DOCSERVICECOMPANY', 'ENABLED', 'LOGICAUDITFLAG', 'ENGLISHNAME', 'ENGLISHADDRESS','ID'],
            pageSize: 20,
            proxy: {
                type: 'ajax',
                url: 'CustomerManage.aspx?action=loadData',
                reader: {
                    root: 'rows',
                    type: 'json',
                    totalProperty: 'total'
                }
            },
            autoLoad: true,
            listeners: {
                beforeload: function (store, options) {
                    var new_params = {
                        code: Ext.getCmp("code").getValue(),
                        cnname: Ext.getCmp("cnname").getValue(),
                        enname: Ext.getCmp("enname").getValue(),
                        hscode: Ext.getCmp("hscode").getValue(),
                        ciqcode: Ext.getCmp("ciqcode").getValue(),
                        enabled: Ext.getCmp("enabled").getValue()
                    }
                    Ext.apply(store.proxy.extraParams, new_params);
                }
            }
        })
        var pgbar = Ext.create('Ext.toolbar.Paging', {
            displayMsg: '显示 {0} - {1} 条,共计 {2} 条',
            store: store_customer,
            displayInfo: true
        })
        var gridpanel = Ext.create('Ext.grid.Panel', {
            height: 560,
            store: store_customer,
            selModel: { selType: 'checkboxmodel' },
            tbar:serachPnl,
            bbar: pgbar,
            border:0,
            columns: [
                { xtype: 'rownumberer', width: 35 },
                { header: '客户代码', dataIndex: 'CODE', width: 120, locked: true },
                { header: '海关编码', dataIndex: 'HSCODE', width: 100, locked: true },
                { header: '国检编码', dataIndex: 'CIQCODE', width: 100, locked: true },
                { header: '中文简称', dataIndex: 'CHINESEABBREVIATION', locked: true, width: 180 },
                { header: '中文名称', dataIndex: 'NAME', width: 250,  tdCls: 'tdValign' },
                { header: '中文地址', dataIndex: 'CHINESEADDRESS', width: 250 },
                { header: '客户', dataIndex: 'ISCUSTOMER', renderer: gridrender, width: 60 },
                { header: '供应商', dataIndex: 'ISSHIPPER', renderer: gridrender, width: 60 },
                { header: '生产型企业', dataIndex: 'ISCOMPANY', renderer: gridrender, width: 80 },
                { header: '单证服务单位', dataIndex: 'DOCSERVICECOMPANY', renderer: gridrender, width: 100 },
                { header: '是否启用', dataIndex: 'ENABLED', renderer: gridrender, width: 70 },
                { header: '逻辑审核强制通过', dataIndex: 'LOGICAUDITFLAG', renderer: gridrender, width: 120 },
                { header: '英文名称', dataIndex: 'ENGLISHNAME', width: 200 },
                { header: '英文地址', dataIndex: 'ENGLISHADDRESS', width: 200 },
                { header: 'ID', dataIndex: 'ID', width: 200,hidden:true }
            ],
            viewConfig: {
                enableTextSelection: true
            }
        });
        
        Ext.create('Ext.form.Panel', {
            title: '客商管理',
            renderTo: 'div_form',
            tbar: toolbar,
            items: [ gridpanel]
        });

        
    })
    //value:将要像是单元格里的值，即dataIndex的值
    //cellmeta:单元格的相关属性，主要是id和CSS
    //record：这行的数据对象。通过record.data['id']方式得到其他列的值
    //rowIndex:行号
    //columnIndex:当前列的行号
    //store:构造表格时传递的ds，也就是说，表格里所有的数据都可以通过store获得。
    ///
    function gridrender(value,cellmeta,record,rowIndex,columnIndex,stroe)
    {
        var dataindex = cellmeta.column.dataIndex;
        var str="";
        switch(dataindex)
        {
            case "ISCUSTOMER":
            case "ISSHIPPER":
            case "ISCOMPANY":
            case "DOCSERVICECOMPANY":
            case "ENABLED":
            case "LOGICAUDITFLAG":
                str = value == "0" ? "否" : "是";
        }
        return str;
    }
    //刷新列表数据，store_customer要定义成全局的，不然子页面调用不到
    function refreshData() {
        store_customer.load();
    }
    
</script>
    <div><form id="exportform" name="form" enctype="multipart/form-data" method="post" style="display:inline-block">
                   
           </form>
        </div>
 <div id="div_form" ></div>
</asp:Content>

