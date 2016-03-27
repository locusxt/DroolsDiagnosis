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
    <title>Spring Test</title>

    <!-- 新 Bootstrap 核心 CSS 文件 -->
    <link rel="stylesheet" href="//cdn.bootcss.com/bootstrap/3.3.5/css/bootstrap.min.css">
    <%--<link rel="stylesheet" href="static/css/demo.css" type="text/css">--%>
    <%--<link rel="stylesheet" href="static/css/zTreeStyle/zTreeStyle.css" type="text/css">--%>

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
    <%--<script src="static/jquery.ztree.all.js"></script>--%>

</head>
<body>
<script>
    var zNodes = [
        {"id":1,"pId":0,"name":"root"},{"id":112,"pId":1,"name":"Disease"},{"id":116,"pId":112,"name":"Respiratory"},{"id":117,"pId":116,"name":"UpperRespiratory"},{"id":118,"pId":117,"name":"CommonCold"},{"id":119,"pId":117,"name":"Pharyngitis"},{"id":120,"pId":116,"name":"Pneumonia"},{"id":157,"pId":112,"name":"Bravery"},{"id":158,"pId":157,"name":"Cholecystalgia"},{"id":159,"pId":157,"name":"Cholecystitis"},{"id":113,"pId":1,"name":"Symptom"},{"id":151,"pId":113,"name":"Ache"},{"id":152,"pId":113,"name":"Jaundice"},{"id":153,"pId":113,"name":"Fever"},{"id":114,"pId":1,"name":"Medicine"},{"id":115,"pId":1,"name":"Examination"},{"id":154,"pId":115,"name":"LFTs"},{"id":155,"pId":115,"name":"Bilirubin"},{"id":156,"pId":115,"name":"Lipase"},{"id":161,"pId":115,"name":"UltrasonicInspection"},{"id":163,"pId":115,"name":"NuclearBiliaryPhotography"},{"id":2,"pId":0,"name":"other"},{"id":3,"pId":2,"name":"State"}
    ];
    var nodeProperty =
    {"2":{},"3":{"id":"int","text":"String"},"112":{},"113":{},"114":{},"115":{},"116":{},"117":{},"118":{"duration_":"int","have_cough":"boolean"},"119":{},"120":{},"151":{"position":"String","duration_":"int"},"152":{},"153":{},"154":{"state":"String"},"155":{"state":"String"},"156":{"state":"String"},"157":{},"158":{},"159":{},"160":{},"161":{"result_":"String", "position":"String"},"162":{},"163":{"result_":"String"}};

    function test_post(){
        var myary=[];
        var data1 = {"name":"hhhh", "keyList":["speed", "height"], "valueList":["7", "17"]};
        var data2 = {"name":"hhhhh", "keyList":["hh", "hhh"], "valueList":["yh", "yhh"]};
        myary.push(data1);
        myary.push(data2);
        $.ajax({
            type:"POST",
            url:"/test/ajax/test",
            dataType:"json",
            contentType:"application/json;charset=UTF-8",
            data:JSON.stringify(myary),
            success:function(data){

            }
        });
    }

    function get_recommend(){
        var mydata = [];
        for (k in exam_d){
            mydata.push(exam_d[k]);
        }
        for (k in symp_d){
            mydata.push(symp_d[k]);
        }
        console.log(mydata);
        $.ajax({
            type:"POST",
            url:"/test/ajax/test",
            dataType:"json",
            contentType:"application/json;charset=UTF-8",
            data:JSON.stringify(mydata),
            success:function(data){
                console.log(data);
                $('#recommend_body').html(data['msg']);
            }
        });
    }

    cur_type = "exam";
//    {"id":113,"pId":1,"name":"Symptom"}
    function get_symptoms(){
        return get_sons(113);
    }

    function get_exams(){
        return get_sons(115);
    }

    function get_sons(nodeid){
        res = []
        for (i = 0; i < zNodes.length; ++i){
            if (zNodes[i]["pId"] == nodeid){
                res.push([zNodes[i]["id"], zNodes[i]["name"]]);
            }
        }
        return res;
    }

    function update_symptoms_list(){
        str = '';
        item_list = get_symptoms();
        for (i = 0; i < item_list.length; ++i){
            str += "<option>" + item_list[i][1] + "(" +item_list[i][0].toString() + ")" + "</option>";
            str += "\n";
        }
//        return str;
        $('#new_item_input').html(str);
        $('#new_item').val("");
        $('#p_list').html("");
        cur_type =  "symp";
    }

    function update_exams_list(){
        str = '';
        item_list = get_exams();
        for (i = 0; i < item_list.length; ++i){
            str += "<option>" + item_list[i][1] + "(" +item_list[i][0].toString() + ")" + "</option>";
            str += "\n";
        }
//        return str;
        $('#new_item_input').html(str);
        $('#new_item').val("");
        $('#p_list').html("");
        cur_type = "exam";
    }

    cur_item = -1;
    cur_id = -1;
    function get_property(){
        now_item = $('#new_item').val();
        cur_item = now_item.substring(0, now_item.indexOf('('));
        pattern =new RegExp("\\((.| )+?\\)","igm");
        nids = now_item.match(pattern);
        if (nids.length != 1) return {};
        nid = parseInt(nids[0].substring(1, nids[0].length - 1));
        cur_id = nid;

//        console.log(nid);
        res = nodeProperty[nid.toString()];
//        console.log(cur_id, cur_item);
        return res;
    }

    function update_property_list(){
        str = "<br />";
        p_list = get_property();
        for (k in p_list){
            str += "<div>";
            str += "<span>" + k + ":</span>";
            str += "<input type='text' id='"+ k+"_tmp' placeholder='" + p_list[k] + "' />";
            str += "</div><br />";
        }
        $('#p_list').html(str);
    }

    myitem_list = {};
    exam_d = {};
    symp_d = {};
    function add_new_item(){
        new_item = {};
        new_item["name"] = cur_item;
//        new_item["id"] = cur_id;
        new_item["keyList"] = [];
        new_item["valueList"] = [];
        new_item["typeList"] = [];
        p_list = get_property();
        for (k in p_list){
            new_item["keyList"].push(k);
            new_item["valueList"].push($('#' + k + '_tmp').val());
            new_item["typeList"].push(p_list[k]);
        }
        if (cur_type == "exam") {exam_d[cur_id] = new_item;render_exam_list();}
        else if (cur_type == "symp") {symp_d[cur_id] = new_item;render_symp_list();}
//        console.log(exam_d);

    }
    function del_item(iid){
        if (iid in exam_d) delete(exam_d[iid]);
        if (iid in symp_d) delete(symp_d[iid]);
        render_exam_list();
        render_symp_list();
    }

    function render_symp_list(){
        str = "";
        for (k in symp_d){
            str += "<div><strong>[" + symp_d[k]["name"] + "] </strong>";
            for (i = 0; i < symp_d[k]["keyList"].length; ++i){
                str += symp_d[k]["keyList"][i] + ":" + symp_d[k]["valueList"][i] + " ";
            }
            str += "<button type='button' onclick='del_item(" + k + ");'>delete</button>";
            str += "</div>";
        }
        $('#symp_list').html(str);
    }

    function render_exam_list(){
        str = "";
        for (k in exam_d){
            str += "<div><strong>[" + exam_d[k]["name"] + "]</strong>";
            for (i = 0; i < exam_d[k]["keyList"].length; ++i){
                str += exam_d[k]["keyList"][i] + ":" + exam_d[k]["valueList"][i] + " ";
            }
            str += "<button type='button' onclick='del_item(" + k + ");'>delete</button>";
            str += "</div>";
        }
        $('#exam_list').html(str);
    }
</script>

<div class="container">
    <h2>Demo</h2>
    <!-- Button trigger modal -->
    <h3>Symptoms <a onclick="update_symptoms_list();" data-toggle="modal" data-target="#myModal"><small><strong> add</strong></small></a></h3>
    <div id="symp_list">

    </div>
    <br />
    <br />
    <br />
    <h3>Examinations <a onclick="update_exams_list();" data-toggle="modal" data-target="#myModal"><small><strong> add</strong></small></a></h3>
    <div id="exam_list">

    </div>
    <br />
    <br />
    <br />
    <h3>Recommend <a onclick="get_recommend();"><small><strong>sync</strong></small></a> </h3>
    <div id="recommend_body">

    </div>
    <%--<button type="button" onclick="update_exams_list();" class="btn btn-primary btn-lg" data-toggle="modal" data-target="#myModal">--%>
        <%--Launch demo modal--%>
    <%--</button>--%>

    <!-- Modal -->
    <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="myModalLabel">Add ...</h4>
                </div>
                <div class="modal-body" id="m_target">
                    <div>
                        <span>Add:</span>
                        <input id="new_item" list="new_item_input" placeholder="" onchange="update_property_list();"/>

                        <datalist id="new_item_input">

                        </datalist>

                        <%--<input type="text" id="property_name" placeholder="" />--%>

                        <%--<button type="button" onclick="">New Property</button>--%>
                    </div>
                    <div id="p_list">

                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary" onclick="add_new_item();" data-dismiss="modal">Confirm</button>
                </div>
            </div>
        </div>
    </div>

</div>

</body>
</html>