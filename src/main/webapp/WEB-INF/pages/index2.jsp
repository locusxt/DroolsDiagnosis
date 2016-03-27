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
</head>
<body>
<script>
    var formsAPI = new jBPMFormsAPI();
    var inner_iframe;
    function showProcessForm() {
        var onsuccessCallback = function(response) {
            setTimeout('startProcess()', 15000);
            setTimeout('getTask()', 20000);
        }

        var onerrorCallback = function(errorMessage) {
            alert("Unable to load the form, something wrong happened: " + errorMessage);
            formsAPI.clearContainer("myform");
        }
        formsAPI.showStartProcessForm("http://localhost:8080/jbpm-console/", "demo:mytest:1.0.11", "mytest.breathe", "myform", onsuccessCallback, onerrorCallback);
    }

    function startProcess() {
        var onsuccessCallback = function(response) {
            formsAPI.clearContainer("myform");
            console.log(response);
        }

        var onerrorCallback = function(response) {
            formsAPI.clearContainer("myform");
            console.log("Unable to start the process, something wrong happened: " + response);
        }
        formsAPI.startProcess("myform", onsuccessCallback, onerrorCallback);
    }

    function getTask(){
        $.getJSON("/jbpm-console/rest/task/query", {'status': 'Reserved'}, function(d){
            console.log(d);
            console.log(d.taskSummaryList);
            tasklist = d.taskSummaryList;
            if (tasklist.length == 0) return;
            last_tid = tasklist[tasklist.length - 1].id;
            last_name = tasklist[tasklist.length - 1].name;
            if (last_name.indexOf('conclusion') != -1){
                conclusions[last_name] = "";
                sync_tables();
            }
            showTaskForm(last_tid);
        });
    }

    function showTaskForm(tid) {
        var onsuccessCallback = function(response) {
            //update_task_item();
            setTimeout('startTask()',15000);
            setTimeout('update_task_item()',20000);
        }

        var onerrorCallback = function(errorMessage) {
            alert("Unable to load the task, something wrong happened: " + errorMessage);
            formsAPI.clearContainer("mytask");
        }
        formsAPI.showTaskForm("http://localhost:8080/jbpm-console/", tid, "mytask", onsuccessCallback, onerrorCallback);
    }

    function startTask(){
        var onsuccessCallback = function(response) {
//            formsAPI.clearContainer("myform");
            console.log(response);
        }
        var onerrorCallback = function(response) {
//            formsAPI.clearContainer("myform");
            console.log("Unable to start the task, something wrong happened: " + response);
        }
        formsAPI.startTask("mytask", onsuccessCallback, onerrorCallback);
    }

    function complete_task(){
        var onsuccessCallback = function(response) {
            formsAPI.clearContainer("myform");
            console.log(response);
            setTimeout('getTask()', 5000);
        }
        var onerrorCallback = function(response) {
//            formsAPI.clearContainer("myform");
            console.log("Unable to complete the task, something wrong happened: " + response);
        }
        //formsAPI.startTask("mytask", onsuccessCallback, onerrorCallback);
        formsAPI.completeTask("mytask", onsuccessCallback, onerrorCallback);
    }

    function update_task_item(){
        a = $('#mytask_form')[0].contentWindow.document;
        b = $('.gwt-Frame', a);
        c = b[0].contentWindow.document;
        item = $('label', c).attr('for');
        console.log(item);
        inner_iframe = c;
        itype = $('#' + item, c).attr('type');
        if (basic_info[item] != undefined){
            if (itype == "checkbox") {
                if (basic_info[item] != "No") $('#' + item, c)[0].checked = true;
                else $('#' + item, c)[0].checked = false;
            }
            else{
                $('#' + item, c).val(basic_info[item]);
            }
        }
        else if (complaints[item] != undefined){
            if (itype == "checkbox") {
                if (complaints[item] != "No") $('#' + item, c)[0].checked = true;
                else $('#' + item, c)[0].checked = false;
            }
            else{
                $('#' + item, c).val(complaints[item]);
            }
        }
        else if (medical_checkups[item] != undefined){
            console.log('checkup');
            if (itype == "checkbox") {
                if (medical_checkups[item] != "No") $('#' + item, c)[0].checked = true;
                else $('#' + item, c)[0].checked = false;
            }
            else{
                $('#' + item, c).val(medical_checkups[item]);
            }
        }
        else
            medical_checkups[item] = "";
        $('#' + item, c)[0].onchange();
        sync_tables();
    }

    function render_table(table_name, data){
        str = "";
        for (k in data){
            str += "<tr><th>" + k + "</th><td><input id='" + k + "_input' type='text' value=\'" + data[k]  + "\' /></td></tr>";
        }
        str += "<tr><th><span id='test' onclick=\"add_data_item(\'" + table_name + "\', " + table_name.substring(0, table_name.length-6) + ");\" > add new item </span></th><td></td></tr>"
        $('#' + table_name).html(str);
    }

    function add_data_item(table_name, data){
        var new_key = prompt("please input the name of the new item", "");
        if (new_key != "" && data[new_key] == undefined){
            data[new_key] = "";
        }
        render_table(table_name, data);
    }

    function del_data_item(data, k){
        delete data[k];
    }

    function get_table_data(table_name){
        inputs = $("#" + table_name + " input");
        tmp =  {};
        for (i = 0; i < inputs.length; ++i){
            id = inputs[i].id.substring(0, inputs[i].id.length-6);
            tmp[id] = $('#'+ inputs[i].id).val();
        }
        return tmp;
    }

    function sync_tables(){
        render_table('basic_info_table', basic_info);
        render_table('complaints_table', complaints);
        render_table('medical_checkups_table', medical_checkups);
        render_table('conclusions_table', conclusions);
    }

    function update_tables(){
        basic_info = get_table_data('basic_info_table');
        complaints = get_table_data('complaints_table');
        medical_checkups = get_table_data('medical_checkups_table');
        conclusions = get_table_data('conclusions_table');
    }

    var basic_info = {'Name':'', 'Age':'', 'Gender':'male'};
    var complaints = {};
    var medical_checkups = {};
    var conclusions = {};
</script>
<h1>Demo</h1>
<div>
    <span id="sp" onclick="showProcessForm();$('#sp').hide();">start process</span>
    <span id="ct" onclick="complete_task();">confirm</span>
</div>
<div class="col-sm-8" onchange="update_tables();update_task_item();">
    <div class="panel panel-info">
        <div class="panel-heading" onclick="$('#basic_info_form').toggle();">
            <h3 class="panel-title">Basic Info</h3>
        </div>
        <div class="panel-body" id="basic_info_form">
            <table id="basic_info_table" class="table">

            </table>
        </div>
    </div>
    <div class="panel panel-info">
        <div class="panel-heading" onclick="$('#complaints_form').toggle();">
            <h3 class="panel-title">Complaints</h3>
        </div>
        <div class="panel-body" id="complaints_form">
            <table id="complaints_table" class="table">

            </table>

        </div>
    </div>
    <div class="panel panel-info">
        <div class="panel-heading" onclick="$('#medical_checkups_form').toggle();">
            <h3 class="panel-title">Medical Checkups</h3>
        </div>
        <div class="panel-body" id="medical_checkups_form">
            <table id="medical_checkups_table" class="table">

            </table>
        </div>
    </div>
    <div class="panel panel-info">
        <div class="panel-heading" onclick="$('#conclusions_form').toggle();">
            <h3 class="panel-title">Conclusions</h3>
        </div>
        <div class="panel-body" id="conclusions_form">
            <table id="conclusions_table" class="table">

            </table>

        </div>
    </div>
    <div class="panel panel-info">
        <div class="panel-heading" onclick="$('#doctor_advice_form').toggle();">
            <h3 class="panel-title">Doctor's Advice</h3>
        </div>
        <div class="panel-body" id="doctor_advice_form">

        </div>
    </div>
</div>
<div class="col-sm-4">
    <div id="myform">

    </div>
    <div id="mytask">

    </div>
</div>
<script>
    sync_tables();
</script>


</body>
</html>