<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="superPWD.aspx.cs" Inherits="Web_Admin.superPWD" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link href="/Extjs42/resources/css/ext-all-neptune.css" rel="stylesheet" type="text/css" />
    <script src="/Extjs42/bootstrap.js" type="text/javascript"></script>

    <script type="text/javascript">
        Ext.onReady(function () {


          
            var pwd="";
            Ext.Ajax.request({
                url: "superPWD.aspx?action=show",
                success: function (response, option) {
                    var data = Ext.decode(response.responseText);
                    var field_PWD = Ext.create('Ext.form.field.Text', {
                        id: 'field_PWD',
                        name: 'PWD',
                        fieldLabel: '超级密码',
                        readOnly: false,
                        allowBlank: false,
                        blankText: '密码不能为空!'
                    });
                    var field_PWD_2 = Ext.create('Ext.form.field.Hidden', {
                        id:'field_PWD_2',
                        name: 'field_PWD'
                    })
                    var panel = Ext.create('Ext.form.Panel', {
                        title: '管理员超级密码',
                        renderTo: 'renderto',
                        minHeight: 100,
                        items: [field_PWD,
                            {
                                xtype: 'button',
                                text: '修改密码',
                                handler: function () {
                                    if (Ext.getCmp('field_PWD').getValue() == Ext.getCmp('field_PWD_2').getValue()) {
                                        Ext.MessageBox.alert('提示', '与原密码相同，不能修改！');
                                    }
                                    else {
                                        Ext.Ajax.request({
                                            url: "superPWD.aspx?action=update",
                                            params: { pwd: Ext.String.trim(Ext.getCmp('field_PWD').getValue()) },
                                            success: function (response, option) {
                                              var result= Ext.decode(response.responseText)
                                              if (result.success==true) {
                                                Ext.MessageBox.alert('提示', '密码修改成功！');
                                                }
                                                
                                            }
                                        });
                                    }
                                }
                            }
                        ]
                    });
                    Ext.getCmp('field_PWD').setValue(data[0].PWD);
                    Ext.getCmp('field_PWD_2').setValue(data[0].PWD);
                }
            });
         
        });
    </script>
    <div id="renderto"></div>
</asp:Content>
