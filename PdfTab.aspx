<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PdfTab.aspx.cs" Inherits="Web_Admin.PdfTab" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <style type="text/css">
        *{margin:0;padding:0;list-style-type:none;}
        /* box */
        .box{background:#fff;border:1px solid #d3d3d3;}
        .tab_menu{overflow:hidden;}
        .tab_menu li{width:150px;float:left;height:30px;line-height:30px;color:#fff;background:#428BCA;text-align:center;cursor:pointer;}/*color:#333;background:#fff;*/
        .tab_menu li.current{color:#333;background:#fff;}/*color:#fff;background:#428BCA;*/
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
                    //alert(data);
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

                        document.getElementById('pdfdiv').innerHTML = '<ul class="tab_menu">' + strul + '</ul>' + '<div class="tab_box">' + strdiv + '</div>';

                    } else {
                        alert("没有订单文件！");
                    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {//请求失败处理函数  
                    alert(XMLHttpRequest.status);
                    alert(XMLHttpRequest.readyState);
                    alert(textStatus);
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
    <div id="pdfdiv" class="box">
       <%--<ul class="tab_menu">
			<li class="current">jquery特效</li>
			<li>javascript 特效</li>
			<li>div+css 教程</li>
		</ul>

        <div class="tab_box" style="">
            <div style="background-color:red;height:909px;">
                1
			</div>
            <div class="hide">
                2
            </div>
             <div class="hide">
                3
            </div>
        </div>--%>
    </div>
</body>
</html>
