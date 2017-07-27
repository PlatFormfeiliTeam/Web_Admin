<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CarouselAdEdit.aspx.cs" Inherits="Web_Admin.CarouselAdEdit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="../../Extjs42/resources/css/ext-all-neptune.css" rel="stylesheet" type="text/css" />
    <script src="../../Extjs42/bootstrap.js" type="text/javascript"></script>
    <script src="../../Extjs42/TreePicker.js" type="text/javascript"></script>
    <script src="../../js/pan.js" type="text/javascript"></script>

    <style type="text/css">
        .bgcolor {
            background: #FFFFFF !important;
        }
    </style>

    <script type="text/javascript">

        var formpanel;
        var id = getQueryString("id");
        var action = id ? 'update' : 'create';

        Ext.onReady(function () {

            var imgUrl = Ext.create('Ext.form.field.File', {
                id: 'IMGURL', name: 'IMGURL', fieldLabel: '图片地址', labelAlign: 'right', msgTarget: 'under', margin: '10', anchor: '90%', buttonText: '上传图片', regex: /.*(.jpg|.png|.gif)$/, regexText: '只能上传JPG'
            });
            var linkUrl = Ext.create('Ext.form.field.Text', {
                name: 'LINKURL', fieldLabel: '链接地址', labelAlign: 'right', msgTarget: 'under', margin: '10', anchor: '90%'
            });

            var description = Ext.create('Ext.form.field.TextArea', {
                name: 'DESCRIPTION', fieldLabel: '描述', labelAlign: 'right', anchor: '90%', margin: '10', height: 60
            });

            var status = Ext.create('Ext.form.RadioGroup', {
                name: "STATUS", id: "STATUS", fieldLabel: '状态', labelAlign: 'right', anchor: '40%', margin: '10',
                items: [
                    { boxLabel: '启用', name: 'STATUS', inputValue: 'true', checked: true },
                    { boxLabel: '停用', name: 'STATUS', inputValue: 'false' }
                ]
            });

            var SORTINDEX = Ext.create('Ext.form.Number', {
                name: 'SORTINDEX', fieldLabel: '排列顺序', allowBlank: false, labelAlign: 'right', anchor: '90%', margin: '10', msgTarget: 'under', blankText: '排列顺序不能为空!'
            }
            );

            formpanel = Ext.create('Ext.form.Panel', {
                id: 'formpanel',
                title: '轮播广告',
                region: 'center',
                //frame: true,
                bodyPadding: 10,
                buttonAlign: 'center',
                items: [imgUrl, linkUrl, SORTINDEX, status, description, {
                    xtype: 'label',
                    text: '提示:上传图片尺寸必须为1920*460!',
                    margin: '0 0 0 80'
                }],
                buttons: [{
                    text: '保 存',
                    handler: function () {
                        if (formpanel.getForm().isValid()) {
                            var formdata = Ext.encode(formpanel.getForm().getValues());
                            
                            formpanel.getForm().submit({
                                url: 'CarouselAdEdit.aspx',
                                params: { id: id, formdata: formdata, action: action },
                                waitMsg: '保存中...', //提示等待信息  
                                success: function (form, action) {
                                    Ext.Msg.alert('提示', '保存成功', function () {
                                        if (window.opener.store_CarouselAd) {
                                            window.opener.store_CarouselAd.load();
                                        }
                                        window.close();
                                    });
                                },
                                failure: function (form, action) {//失败要做的事情 
                                    Ext.MessageBox.alert("提示", "图片尺寸必须为1920*460!", function () { window.close(); });
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
                    url: 'CarouselAdEdit.aspx?action=loadform&id=' + id,
                    method: 'POST', //请求方式   
                    success: function (form, action) {
                        if (action.result.success == true) {
                            Ext.getCmp("STATUS").setValue({ STATUS: action.result.data.STATUS });
                            imgUrl.disable(true);
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
