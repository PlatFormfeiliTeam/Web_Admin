<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PdfTab.aspx.cs" Inherits="Web_Admin.PdfTab" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <link href="/Extjs42/resources/css/ext-all-neptune.css" rel="stylesheet" type="text/css" />
    <script src="/Extjs42/bootstrap.js" type="text/javascript"></script>
    <script src="js/pan.js"></script>
    <link href="css/bootstrap32/css/bootstrap.min.css" rel="stylesheet" />
    <link href="/font-awesome/css/font-awesome.min.css" rel="stylesheet" />
    <script type="text/javascript">
        var ordercode = getQueryString("ordercode");
        Ext.onReady(function () {
            var html = '<div id="pdfdiv" style="width:100%;height:100%"></div>';
            var toolbar = Ext.create("Ext.toolbar.Toolbar", {
                items: []
            });
            var panel = Ext.create('Ext.panel.Panel', {
                tbar: toolbar,
                region: 'center',
                html: html
            });
            var viewport = Ext.create('Ext.container.Viewport', {
                layout: 'border',
                items: [panel]
            })
            Ext.Ajax.request({
                url: "PdfTab.aspx?action=load&ordercode=" + ordercode,
                timeout: 40000,
                success: function (response) {
                    var box = document.getElementById('pdfdiv');
                    var json = Ext.decode(response.responseText);
                    if (json.success == true) {
                        var str = '<embed id="pdf" width="100%" height="100%" src="' + json.src + '"></embed>';
                        box.innerHTML = str;
                        //动态生成按钮组     
                        var oritypeid = "";
                        var type_index = 1;
                        var html1 = '<div class="btn-group" role="group">';
                        for (var i = 0; i < json.rows.length; i++) {
                            var id = json.rows[i].ID;
                            var typeid = json.rows[i].FILETYPE;
                            if (typeid != oritypeid) {
                                oritypeid = typeid;
                                type_index = 1;
                            }
                            else {
                                type_index += 1;
                            }
                            var newid = typeid + "_" + id;
                            html1 += '<button type="button" class="btn  btn-primary btn-sm" onclick="loadfile(\'' + newid + '\')"><i class="fa fa-file-pdf-o"></i>&nbsp;' + json.rows[i].FILETYPENAME + "_" + type_index + '</button>';
                        }
                        html1 += '</div>';
                        toolbar.add(html1);
                    }
                }
            })
        });
        function loadfile(id) {
            var array1 = id.split('_');
            Ext.Ajax.request({
                url: "PdfTab.aspx?action=loadfile&ordercode=" + ordercode + "&fileid=" + array1[1],
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
