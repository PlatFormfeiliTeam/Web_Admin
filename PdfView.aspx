<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PdfView.aspx.cs" Inherits="Web_Admin.PdfView" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <link href="/Extjs42/resources/css/ext-all-gray.css" rel="stylesheet" type="text/css" />
    <script src="/Extjs42/bootstrap.js" type="text/javascript"></script>
    <script src="js/pan.js"></script>
    <link href="/font-awesome/css/font-awesome.min.css" rel="stylesheet" />
    <style type="text/css">
        .x-grid-cell {
            border-bottom-color: black;
            border-right-color: black;
        }
    </style>
    <script type="text/javascript">
        var ordercode = getQueryString("ordercode");
        var filetype = getQueryString("filetype");
        //  var fileids = getQueryString("fileids");
        var userid = getQueryString("userid");
        var fileid = "";
        var path = "";
        var allow_sel;
        var filedarray = [];
        Ext.onReady(function () {
            Ext.Ajax.request({
                url: "PdfView.aspx",
                params: { ordercode: ordercode, action: 'loadform' },
                success: function (response, option) {
                    var json = Ext.decode(response.responseText);
                    var field_code = Ext.create('Ext.form.field.Text', {
                        margin: '10',
                        columnWidth: .25,
                        labelAlign: "right",
                        fieldLabel: '订单号',
                        name: 'CODE',
                        readOnly: true,
                        value: ordercode
                    });
                    var common_data_busitype = [
                    { "CODE": "10", "NAME": "空运出口" }, { "CODE": "11", "NAME": "空运进口" },
                    { "CODE": "20", "NAME": "海运出口" }, { "CODE": "21", "NAME": "海运进口" },
                    { "CODE": "30", "NAME": "陆运出口" }, { "CODE": "31", "NAME": "陆运进口" },
                    { "CODE": "40", "NAME": "国内出口" }, { "CODE": "41", "NAME": "国内进口" },
                    { "CODE": "50", "NAME": "特殊区域出口" }, { "CODE": "51", "NAME": "特殊区域进口" }];

                    var store_busitype = Ext.create('Ext.data.JsonStore', {
                        fields: ['CODE', 'NAME'],
                        data: common_data_busitype
                    })
                    var combo_busitype = Ext.create('Ext.form.field.ComboBox', {
                        name: 'BUSITYPE',
                        store: store_busitype,
                        displayField: 'NAME',
                        queryMode: 'local',
                        valueField: 'CODE',
                        margin: 10,
                        columnWidth: .25,
                        labelAlign: "right",
                        fieldLabel: '业务类型',
                        value: json.formdata.BUSITYPE,
                        readOnly: true
                    })

                    var field_busiunit = Ext.create('Ext.form.field.Text', {
                        name: 'BUSIUNITNAME',
                        margin: 10,
                        columnWidth: .25,
                        labelAlign: "right",
                        fieldLabel: '经营单位',
                        readOnly: true,
                        value: json.formdata.BUSIUNITNAME
                    });
                    var filedata = [];
                    for (var i = 0; i < json.filedata.length; i++) {
                        if (i == 0) {
                            filedata.push({ boxLabel: '订单文件' + (i + 1), name: 'cbg', inputValue: json.filedata[i].ID, checked: true });
                        }
                        else {
                            filedata.push({ boxLabel: '订单文件' + (i + 1), name: 'cbg', inputValue: json.filedata[i].ID });
                        }
                    }
                    var cbg_file = Ext.create('Ext.form.CheckboxGroup', {
                        id: 'cbg_orderfile',
                        fieldLabel: '订单文件',
                        labelAlign: "right",
                        columnWidth: 1,
                        columns: 8,
                        margin: 10,
                        items: filedata
                        //items: [
                        //    { boxLabel: 'Item 1', name: 'rb', inputValue: '1' },
                        //    { boxLabel: 'Item 2', name: 'rb', inputValue: '2', checked: true },
                        //    { boxLabel: 'Item 3', name: 'rb', inputValue: '3' },
                        //    { boxLabel: 'Item 4', name: 'rb', inputValue: '4' },
                        //    { boxLabel: 'Item 5', name: 'rb', inputValue: '5' },
                        //    { boxLabel: 'Item 6', name: 'rb', inputValue: '6' }
                        //]
                    })
                    //保存按钮
                    //var svaeButton = new Ext.Button({
                    //    text: '<i class="fa fa-floppy-o"></i> 保存',
                    //    margin: 10,
                    //    handler: function () {
                    //        var goodSnum = GOODSNUM.getValue();
                    //        var packKind = combo_PACKKIND.getValue();
                    //        var goodSgw = GOODSGW.getValue();
                    //        var goodSnw = GOODSNW.getValue();
                    //        Ext.Ajax.request({
                    //            url: "PdfView.aspx",
                    //            params: { ordercode: ordercode, action: 'saveGoodParam', goodSnum: GOODSNUM.getValue(), packKind: combo_PACKKIND.getValue(), goodSgw: GOODSGW.getValue(), goodSnw: GOODSNW.getValue() },
                    //            success: function (response, option) {
                    //                var json = Ext.decode(response.responseText);
                    //                panel.hide();
                    //                if (json.success) {
                    //                    Ext.MessageBox.alert("提示", "保存成功！", function () {
                    //                        panel.show();
                    //                    });
                    //                }
                    //                else {
                    //                    Ext.MessageBox.alert("提示", "保存失败！", function () {
                    //                        panel.show();
                    //                    });
                    //                }
                    //            }
                    //        });
                    //    }
                    //})

                    var formpanel = Ext.create('Ext.form.Panel', {
                        title: '文件拆分',
                        region: 'north',
                        height: 120,
                        items: [{ layout: 'column', border: 0, items: [field_code, combo_busitype, field_busiunit] },
                                { layout: 'column', border: 0, items: [cbg_file] }]
                    });
                    var html = '<div id="pdfdiv" style="width:100%;height:100%"></div>';
                    var panel = Ext.create('Ext.panel.Panel', {
                        region: 'center',
                        html: html
                    });
                    var toolbar = Ext.create("Ext.toolbar.Toolbar", {
                        items: [
                            {
                                text: '<i class="fa fa-sitemap"></i>&nbsp;原始文档', handler: function () {
                                    window.location.reload();
                                }
                            },
                            {
                                text: "<i class='fa fa-share-alt'></i>&nbsp;确定拆分", id: 'btn_confirmsplit', disabled: true, handler: function () {
                                    var allowsplit = false;
                                    var store_tmp = gridpanel.getStore();
                                    for (var i = 0; i < store_tmp.getCount() ; i++) {
                                        var rec = store_tmp.getAt(i);
                                        for (var j = 0; j < filedarray.length; j++) {
                                            if (rec.get(filedarray[j]) == "√") {
                                                allowsplit = true;
                                            }
                                        }
                                    }
                                    if (!allowsplit) {
                                        panel.hide();
                                        Ext.MessageBox.alert('提示', '请先勾选具体的拆分明细！', function () {
                                            panel.show();
                                        })
                                        return;
                                    }
                                    Ext.getCmp("btn_confirmsplit").setDisabled(true);
                                    var pages = Ext.encode(Ext.pluck(gridpanel.store.data.items, 'data'));
                                    Ext.Ajax.request({
                                        url: "PdfView.aspx?action=split&fileid=" + fileid + "&filetype=" + filetype + "&ordercode=" + ordercode + "&userid=" + userid,
                                        params: { pages: pages },
                                        success: function (response) {
                                            panel.hide();
                                            var json = Ext.decode(response.responseText);
                                            if (json.success) {
                                                Ext.MessageBox.alert('提示', '拆分成功！', function () {
                                                    panel.show();
                                                })
                                                Ext.getCmp('btn_cancelsplit').setDisabled(false);
                                                allow_sel = false;
                                                for (var i = 0; i < json.result.length; i++) {
                                                    //拆分完成后添加拆分好文件类型的查看按钮  
                                                    var btn = Ext.create('Ext.Button', {
                                                        id: json.result[i].FILETYPEID + "_" + json.result[i].ID,
                                                        text: '<i class="fa fa-file-pdf-o"></i>&nbsp;' + json.result[i].FILETYPENAME,
                                                        handler: function () {
                                                            gridpanel.getStore().removeAll();
                                                            loadfile(this.id);
                                                        }
                                                    })
                                                    toolbar.add(btn);
                                                }
                                            }
                                            else {
                                                Ext.MessageBox.alert('提示', '拆分失败，文件压缩中，请稍后再试！', function () {
                                                    panel.show();
                                                })
                                            }
                                        }
                                    });
                                }
                            }, {
                                text: "<i class='fa fa-undo'></i>&nbsp;撤销拆分", disabled: true, id: 'btn_cancelsplit', handler: function () {
                                    panel.hide();
                                    Ext.MessageBox.confirm('提示', '确定要撤销拆分吗？', function (btn) {
                                        if (btn == 'yes') {
                                            Ext.getCmp('btn_cancelsplit').setDisabled(true);
                                            Ext.Ajax.request({
                                                url: 'PdfView.aspx?action=cancelsplit&ordercode=' + ordercode + "&fileid=" + fileid + "&userid=" + userid,
                                                success: function (response, opts) {
                                                    panel.hide();
                                                    Ext.MessageBox.alert('提示', '撤销拆分成功！', function () {
                                                        panel.show();
                                                    })
                                                    Ext.getCmp("btn_confirmsplit").setDisabled(false);
                                                    allow_sel = true;
                                                    var times = toolbar.items.length
                                                    for (var i = 3; i < times; i++) {
                                                        var btn = toolbar.getComponent(3);//移除了第4个元素后，后面的元素会自动填充到第4的位置
                                                        if (btn) {
                                                            toolbar.remove(btn);
                                                        }
                                                    }
                                                }
                                            })
                                        }
                                        panel.show();
                                    })
                                }
                            }
                        ]
                    });
                    var gridpanel = Ext.create('Ext.grid.Panel', {
                        region: 'east',
                        columnLines: true,
                        rowLines: true,
                        width: 750,
                        tbar: toolbar,
                        sortableColumns: false,
                        enableColumnHide: false,
                        columns: [],
                        listeners: {
                            itemclick: function (grid, record, item, index, e, eOpts) {
                                var PDF = Ext.get("pdf").dom;
                                PDF.setCurrentPage(record.get("ID"));
                            },
                            cellclick: function (view, td, cellIndex, record, tr, rowIndex, e, eOpts) {
                                if (allow_sel) {
                                    var header = view.getHeaderCt().getHeaderAtIndex(cellIndex);
                                    if (header.dataIndex != "ID") {
                                        record.set(header.dataIndex, record.get(header.dataIndex) == "√" ? "" : "√");
                                    }
                                }
                            }
                        }
                    })
                    var viewport = Ext.create('Ext.container.Viewport', {
                        layout: 'border',
                        items: [formpanel, gridpanel, panel]
                    })
                    //如果只有一个订单文件,直接加载进行拆分;如果有多个订单文件，则不予加载,勾选后
                    //默认加载第一个订单文件 
                    Ext.Ajax.request({
                        url: "PdfView.aspx?action=loadpdf&ordercode=" + ordercode + "&fileid=" + cbg_file.getValue().cbg,
                        success: function (response) {
                            var box = document.getElementById('pdfdiv');
                            if (response.responseText) {
                                var json = Ext.decode(response.responseText);
                                path = json.src;
                                var str = '<embed  id="pdf" width="100%" height="100%" src="' + json.src + '"></embed>';
                                box.innerHTML = str;

                                //df_filetype.setValue(json.filetype);
                                Ext.getCmp("btn_confirmsplit").setDisabled(json.filestatus == 0 ? false : true);
                                Ext.getCmp('btn_cancelsplit').setDisabled(json.filestatus == 0 ? true : false);
                                allow_sel = (json.filestatus == 0 ? true : false);
                                fileid = json.fileid;
                                Ext.regModel('Pager', { fields: [] });

                                var columnarray = [];
                                for (var key in json.rows[0]) {
                                    filedarray.push(key);
                                    switch (key) {
                                        case "ID":
                                            columnarray.push({ header: '页码', dataIndex: key, width: 48, renderer: RowRender });
                                            columnarray.push({
                                                xtype: 'actioncolumn', width: 48, text: '操作'
                                                , items: [{
                                                    icon: '/images/shared/arrow_up.gif',
                                                    width: 30,
                                                    handler: function (grid, rowIndex, colIndex) { }
                                                }, {
                                                    icon: '/images/shared/arrow_down.gif',
                                                    handler: function (grid, rowIndex, colIndex) { }
                                                }
                                                ]
                                            });
                                            break;
                                        default:
                                            var start = key.indexOf("@");
                                            var header = key.slice(start + 1);
                                            columnarray.push({ header: header, dataIndex: key, width: 60 });
                                            break;
                                    }
                                }
                                Pager.setFields(filedarray); //Model构建完毕
                                store = Ext.create('Ext.data.JsonStore',
                                {
                                    model: 'Pager',
                                    data: json.rows
                                })
                                gridpanel.reconfigure(store, columnarray);

                                //拆分完成后添加拆分好文件类型的查看按钮     
                                for (var i = 0; i < json.result.length; i++) {
                                    var id = json.result[i].ID;
                                    var typeid = json.result[i].FILETYPEID;
                                    var btn = Ext.create('Ext.Button', {
                                        id: json.result[i].FILETYPEID + "_" + json.result[i].ID,
                                        text: '<i class="fa fa-file-pdf-o"></i>&nbsp;' + json.result[i].FILETYPENAME,
                                        handler: function () {
                                            gridpanel.getStore().removeAll();
                                            loadfile(this.id);
                                        }
                                    })
                                    toolbar.add(btn);
                                }
                                //加载好原始文件后直接进行压缩，以备拆分时使用
                                //compressfile();
                            }
                        }
                    })

                    //if (ordercode) {
                    //    Ext.Ajax.request({
                    //        url: "PdfView.aspx",
                    //        params: { ordercode: ordercode, action: 'loadGoodParam' },
                    //        success: function (response, option) {
                    //            var json = Ext.decode(response.responseText);
                    //            if (json) {
                    //                GOODSNUM.setValue(json.GOODSNUM);
                    //                combo_PACKKIND.setValue(json.PACKKIND);
                    //                GOODSGW.setValue(json.GOODSGW);
                    //                GOODSNW.setValue(json.GOODSNW);
                    //            }
                }
            });
            //}

        });
        //压缩文件
        function compressfile() {
            if (filetype == 44) {
                Ext.Ajax.request({
                    url: "PdfView.aspx?action=compress",
                    params: { ordercode: ordercode, fileid: fileid, path: path }
                })
            }
        }
        function RowRender(value, cellmeta, record, rowIndex, columnIndex, store) {
            return '第' + value + '页';
        }
        function loadfile(id) {
            var array1 = id.split('_');
            Ext.Ajax.request({
                url: "PdfView.aspx?action=loadfile&fileid=" + array1[1],
                success: function (response) {
                    var box = document.getElementById('pdfdiv');
                    if (response.responseText) {
                        var json = Ext.decode(response.responseText);
                        var str = '<embed id="pdf" width="100%" height="100%" src="' + json.src + '"></embed>';
                        box.innerHTML = str;
                    }
                }
            });
        }
    </script>
</head>
<body>
</body>
</html>
