<%--
  Created by IntelliJ IDEA.
  User: zhuting
  Date: 15/10/14
  Time: 13:30
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <!-- 上述3个meta标签*必须*放在最前面，任何其他内容都*必须*跟随其后！ -->
  <title>SpringMVC Demo 首页</title>

  <!-- 新 Bootstrap 核心 CSS 文件 -->
  <link rel="stylesheet" href="//cdn.bootcss.com/bootstrap/3.3.5/css/bootstrap.min.css">

  <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
  <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
  <!--[if lt IE 9]>
  <script src="//cdn.bootcss.com/html5shiv/3.7.2/html5shiv.min.js"></script>
  <script src="//cdn.bootcss.com/respond.js/1.4.2/respond.min.js"></script>
  <![endif]-->
  <!-- jQuery文件。务必在bootstrap.min.js 之前引入 -->
  <script src="//cdn.bootcss.com/jquery/1.11.3/jquery.min.js"></script>

  <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
  <script src="//cdn.bootcss.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
  <script src="static/jbpm-forms.js"></script>
  <script>
    var formsAPI = new jBPMFormsAPI();
    function showProcessForm() {
        var onsuccessCallback = function(response) {
            document.getElementById("showformButton").style.display = "none";
            document.getElementById("startprocessButton").style.display = "block";
        }

        var onerrorCallback = function(errorMessage) {
            alert("Unable to load the form, something wrong happened: " + errorMessage);
            formsAPI.clearContainer("myform");
        }
        formsAPI.showStartProcessForm("http://localhost:8080/jbpm-console/", "demo:mytest:1.0.8", "mytest.dmtypetest", "myform", onsuccessCallback, onerrorCallback);
    }

    function startProcess() {
        var onsuccessCallback = function(response) {
            document.getElementById("showformButton").style.display = "block";
            document.getElementById("startprocessButton").style.display = "none";
            formsAPI.clearContainer("myform");
            alert(response);
        }

        var onerrorCallback = function(response) {
            document.getElementById("showformButton").style.display = "block";
            document.getElementById("startprocessButton").style.display = "none";
            formsAPI.clearContainer("myform");
            alert("Unable to start the process, something wrong happened: " + response);
        }
        formsAPI.startProcess("myform", onsuccessCallback, onerrorCallback);
    }
  </script>
</head>
<body>
<h1>SpringMVC</h1>
<input type="button" id="showformButton" value="Show Process Form" onclick="showProcessForm()">
<p/>
    <div id="myform" style="border: solid black 1px; width: 500px; height: 200px;">
    </div>
<p/>
<input type="button" id="startprocessButton"
       style="display: none;" value="Start Process" onclick="startProcess()">

</body>
</html>