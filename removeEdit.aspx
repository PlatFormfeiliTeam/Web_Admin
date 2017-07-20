<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="removeEdit.aspx.cs" Inherits="Web_Admin.removeEdit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link href="../../Extjs42/resources/css/ext-all-neptune.css" rel="stylesheet" type="text/css" />
    <script src="../../Extjs42/bootstrap.js" type="text/javascript"></script>
    <link href="../../font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
     <script type="text/javascript">
         Ext.onReady(function () {
             var removeItem = Ext.create('Ext.form.RadioGroup', {
                 name: "removeItem", id: "removeItem", fieldLabel: '解除项目选择', labelAlign: 'right', anchor: '40%', margin: '10',
                 items: [
                     { boxLabel: '解除客服编辑', name: 'item', inputValue: 'kf', checked: true },
                     { boxLabel: '解除制单编辑', name: 'item', inputValue: 'zd' },
                     { boxLabel: '解除审单编辑', name: 'item', inputValue: 'sd' }
                 ]
             });


             var store_bhtype = Ext.create('Ext.data.JsonStore', {
                 fields: ['CODE', 'NAME'],
                 data: [{ "CODE": "ddbh", "NAME": "订单编号" }, { "CODE": "qybh", "NAME": "企业编号" }]
             })
             var combo_bhxz = Ext.create('Ext.form.field.ComboBox', {
                 id: 'combo_bhxz',
                 margin: '0 5 0 25',
                 name: 'combo_bhxz',
                 store: store_bhtype,
                 displayField: 'NAME',
                 valueField: 'CODE',
                 editable: false,
                 queryMode: 'local',
                 width: 100,
                 value: 'ddbh'
             });
             var field_bhsr = Ext.create('Ext.form.field.Text', {
                 id: 'field_bhsr',
                 name: 'itembh'
             });

             var container_bh = Ext.create('Ext.form.FieldContainer', {
                 id: 'container_bh',
                 layout: 'hbox',
                 items: [combo_bhxz, field_bhsr]
             })
             formpanel = Ext.create('Ext.form.Panel', {
                 id: 'formpanel',
                 title: '解编辑',
                 region: 'center',
                 renderTo: 'renderto',
                 bodyPadding: 10,
                 buttonAlign: 'center',
                 items: [removeItem, container_bh],
                 buttons: [{
                     text: '解除编辑',
                     handler: function () {
                         var formdata = Ext.encode(formpanel.getForm().getValues());
                         formpanel.getForm().submit({
                             url: 'removeEdit.aspx?action=remove',
                             params:formdata,
                             waitMsg: '解除中...',
                             success: function (form, action) {
                                 Ext.Msg.alert('提示', '解除成功！', function () {
                                     //formpanel.getForm().reset()
                                 });
                             },
                             failure: function (form, action) {//失败要做的事情 
                                 Ext.MessageBox.alert("提示", "解除失败！");
                             }
                         });
                     }
                 }]
             });


         });
     </script>

    <div id="renderto"></div>
</asp:Content>
