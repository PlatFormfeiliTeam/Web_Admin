<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PdfTab.aspx.cs" Inherits="Web_Admin.PdfTab" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <style type="text/css">
        *{margin:0;padding:0;list-style-type:none; font-size:12px;font-family: 'Microsoft YaHei' !important;}
        /* box */
        .box{background:#fff;border:1px solid #d3d3d3;}
        .tab_menu{overflow:hidden;}
        .tab_menu li{width:150px;float:left;height:30px;line-height:30px;color:#fff;background:#428BCA;text-align:center;cursor:pointer;}
        .tab_menu li.current{color:#333;background:#fff;}
        .tab_box{padding:5px;}
        .tab_box .hide{display:none;}
    </style>

    <script src="js/jquery-1.4.2.min.js"></script>
    <script src="js/jquery.tabs.js"></script>
	<script src="js/jquery.lazyload.js"></script>
    <script src="js/pan.js"></script>

    <script type="text/javascript">
        var ordercode = getQueryString("ordercode");
        $(function () {
            $.ajax({
                type: 'Post',
                url: "PdfTab.aspx",
                dataType: 'text',
                data: { action: "load", ordercode: ordercode },
                async: false,
                success: function (data) {
                    var infor = "";
                    var obj = eval("(" + data + ")");//将字符串转为json
                    if (obj.success) {
                        var json = eval(obj.rows);
                        var strul = "", strdiv = "";
                        $.each(json, function (idx, item) {
                           
                            if (idx == 0) {
                                strul += '<li class="current">';
                                strdiv += '<div';
                            } else {
                                strul += '<li>';
                                strdiv += '<div class="hide"';
                            }
                            strul += item.FILETYPENAME + '_' + (idx + 1) + '</li>';
                            strdiv += ' style="height:' + ($(window).height() - 60) + 'px">'
                                + '<embed id="pdf"  width="100%" height="100%" src="/file/' + item.FILENAME + '"></embed>' + '</div>';
                        });

                        infor = '<ul class="tab_menu">' + strul + '</ul>' + '<div class="tab_box">' + strdiv + '</div>';

                    } else {
                        infor = "没有文件!";
                    }
                    $('#pdfdiv').html(infor);
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    $('#pdfdiv').html(XMLHttpRequest.status + ":" + XMLHttpRequest.responseText);
                }

            });
        });   
    </script>
		
	<script type="text/javascript">
		$(function () {
		    $('#pdfdiv').Tabs({
		        event: 'click'
		    });
		});
	</script>
</head>
<body>
    <div id="pdfdiv" class="box"></div>
</body>
</html>
