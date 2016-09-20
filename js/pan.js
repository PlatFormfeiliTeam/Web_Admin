function opencenterwin(url, width, height) {
    var iWidth = width ? width : "1000", iHeight = height ? height : "600";
    var iTop = (window.screen.availHeight - 30 - iHeight) / 2; //获得窗口的垂直位置;
    var iLeft = (window.screen.availWidth - 10 - iWidth) / 2; //获得窗口的水平位置; 
    window.open(url, '', 'height=' + iHeight + ',,innerHeight=' + iHeight + ',width=' + iWidth + ',innerWidth=' + iWidth + ',top=' + iTop + ',left=' + iLeft + ',toolbar=no,menubar=no,scrollbars=yes,resizable=yes');
}
function getQueryString(name) {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
    var r = window.location.search.substr(1).match(reg);
    if (r != null) return unescape(r[2]); return null;
}
//列渲染 by panhuaguo 2016-09-07
function render(value, cellmeta, record, rowIndex, columnIndex, store) {
    var rtn = "";
    var dataindex = cellmeta.column.dataIndex;
    switch (dataindex) {
        case "TYPE":
            rtn = value != 4 ? '外部账户' : '内部账户';
            break;
        case "ENABLED":
            rtn = value ? '启用' : '停用';
            break;      
    }
    return rtn;
}
//系统模块编辑窗口 by panhuaguo 2016-08-30
function module_edit_win(parentNode, action) {
    var formpanel_module = Ext.create('Ext.form.Panel', {
        layout: 'anchor',
        region: 'center',
        // title: '系统模块',
        defaults: { labelAlign: 'right', xtype: 'textfield', msgTarget: 'under', margin: '10' },
        items: [
        { name: 'NAME', anchor: '95%', fieldLabel: '模块名称', allowBlank: false, blankText: '模块名称不能为空', emptyText: '请输入模块名称' },
        { name: 'URL', anchor: '95%', fieldLabel: '链接地址', allowBlank: true, emptyText: '请输入链接地址' },
        { name: 'SORTINDEX', anchor: '95%', fieldLabel: '显示顺序', xtype: 'numberfield' },
        { name: 'MODULEID', xtype: 'hidden' },
        { name: 'PARENTID', xtype: 'hidden', id: 'field_parentid' }
        ],
        buttons: [{
            text: '保 存', handler: function () {
                var baseForm = formpanel_module.getForm();
                if (baseForm.isValid()) {
                    Ext.Ajax.request({
                        url: "SysModule.aspx",
                        params: { action: action, json: Ext.encode(baseForm.getValues()) },
                        callback: function (option, success, response) {
                            var result = Ext.decode(response.responseText);
                            if (result.success) {
                                Ext.Msg.alert("提示", "保存成功!", function () {
                                    if (action == "create") { //如果是新增 
                                        if (parentNode.data.leaf) {//如果是叶子
                                            parentNode.set("leaf", false);
                                            parentNode.expand();
                                        }
                                        else {
                                            if (parentNode.isExpanded()) {//如果已经展开了
                                                var childNode = parentNode.createNode({ MODULEID: result.data.MODULEID, NAME: result.data.NAME, leaf: true, URL: result.data.URL });
                                                parentNode.appendChild(childNode);
                                            }
                                            else {//如果未展开
                                                parentNode.expand();
                                            }
                                        }
                                    }
                                    else { //如果是修改
                                        parentNode.set("NAME", result.data.NAME);
                                        parentNode.set("URL", result.data.URL);
                                    }
                                    win_sysmodule.close();
                                });
                            }
                        }
                    });
                }
            }
        }],
        buttonAlign: 'center'
    })
    var win_sysmodule = Ext.create("Ext.window.Window", {
        title: '系统模块',
        width: 700,
        height: 570,
        modal: true,
        items: [formpanel_module],
        layout: 'border',
        buttonAlign: 'center'
    });
    win_sysmodule.show();
    if (action == "update") {//如果是修改 
        formpanel_module.getForm().setValues(parentNode.data);
    }
    if (action == "create" && parentNode.data.MODULEID) {
        Ext.getCmp("field_parentid").setValue(parentNode.get('MODULEID'));
    }
}


