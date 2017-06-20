<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CollectInforCateEdit.aspx.cs" Inherits="Web_Admin.CollectInforCateEdit" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="/Extjs42/resources/css/ext-all-neptune.css" rel="stylesheet" type="text/css" />
    <script src="/Extjs42/bootstrap.js" type="text/javascript"></script>
    <script src="/Extjs42/TreePicker.js" type="text/javascript"></script>
    <script src="/js/pan.js" type="text/javascript"></script>

    <style type="text/css">
        .bgcolor {
            background: #FFFFFF !important;
        }
    </style>

    <script type="text/javascript">

        var formpanel;
        var id = getQueryString("id"); var rid_type = getQueryString("rid_type");
        var action = id ? 'update' : 'create';

        Ext.onReady(function () {
            var label_baseinfo = {
                xtype: 'label', margin: '100',
                html: '<span style="color:blue; font-size:12px;">说明：修改时，图标不变，则不需要重新上传</span>'
            }

            var icon = Ext.create('Ext.form.field.File', {
                id: 'ICON', name: 'ICON', fieldLabel: '图标', labelAlign: 'right', msgTarget: 'under', margin: '10', anchor: '90%'
                , buttonText: '上传图片', regex: /.*(.jpg|.png|.gif)$/, regexText: '只能上传JPG,png,gif'
            });
            var name = Ext.create('Ext.form.field.Text', {
                name: 'NAME', fieldLabel: '名称', labelAlign: 'right', msgTarget: 'under', margin: '10', anchor: '90%'
            })

            var url = Ext.create('Ext.form.field.Text', {
                name: 'URL', fieldLabel: '链接地址', labelAlign: 'right', msgTarget: 'under', margin: '10', anchor: '90%'
            });

            var isinvalid = Ext.create('Ext.form.RadioGroup', {
                name: "ISINVALID", id: "ISINVALID", fieldLabel: '状态', labelAlign: 'right', anchor: '40%', margin: '10',
                items: [
                    { boxLabel: '启用', name: 'ISINVALID', inputValue: 0, checked: true },
                    { boxLabel: '停用', name: 'ISINVALID', inputValue: 1 }
                ]
            });

            var icon_old = Ext.create('Ext.form.field.Hidden', { name: 'ICON_OLD' });

            //var imageurl = {
            //    xtype: 'box', //或者xtype: 'component',  
            //    width: 46, //图片宽度  
            //    height: 60, //图片高度  
            //    autoEl: {
            //        tag: 'img',    //指定为img标签  
            //        src: '/FileUpload/InforCate/tip1.png'    //指定url路径  
            //    }
            //};


            formpanel = Ext.create('Ext.form.Panel', {
                id: 'formpanel',
                title: '常用查询',
                region: 'center',
                bodyPadding: 10,
                buttonAlign: 'center',
                items: [icon,label_baseinfo, name, url, isinvalid, icon_old],
                buttons: [{
                    text: '保 存',
                    handler: function () {
                        if (formpanel.getForm().isValid()) {
                            var formdata = Ext.encode(formpanel.getForm().getValues());

                            formpanel.getForm().submit({
                                url: 'CollectInforCateEdit.aspx',
                                params: { id: id, rid_type: rid_type, formdata: formdata, action: action },
                                waitMsg: '保存中...', //提示等待信息  
                                success: function (form, action) {
                                    Ext.Msg.alert('提示', '保存成功', function () {
                                        if (window.opener.store_CollectInforCate) {
                                            window.opener.store_CollectInforCate.load();
                                        }
                                        window.close();
                                    });
                                },
                                failure: function (form, action) {//失败要做的事情 
                                    Ext.MessageBox.alert("提示", "图片尺寸必须为46*60!", function () { window.close(); });
                                }
                            });

                        }
                    }
                }]
            });

            var viewport = Ext.create('Ext.container.Viewport', {
                layout: 'border',
                items: [formpanel]
            })

            if (id) {
                formpanel.getForm().load({
                    url: 'CollectInforCateEdit.aspx?action=loadform&id=' + id,
                    method: 'POST', //请求方式   
                    success: function (form, action) {
                        if (action.result.success == true) {
                            Ext.getCmp("ISINVALID").setValue({ ISINVALID: action.result.data.ISINVALID });
                        }
                    }
                });
            }
        })
    </script>
</head>
<body>
</body>
</html>
