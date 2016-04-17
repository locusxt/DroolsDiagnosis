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
    <%--<link rel="stylesheet" href="static/css/demo.css" type="text/css">--%>
    <link rel="stylesheet" href="static/css/zTreeStyle/zTreeStyle.css" type="text/css">

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
    <script src="static/jquery.ztree.all.js"></script>
    <style>
        .table th, .table td {
            text-align: center;
            height:38px;
        }
    </style>
    <script>


        var zTreeObj;
        // zTree 的参数配置，深入使用请参考 API 文档（setting 配置详解）
        var setting = {
            data: {
                simpleData: {
                    enable: true,
                    idKey: "id",
                    pIdKey: "pId",
                    rootPId: 0
                }
            },
            view: {
                showIcon : false,
                addHoverDom: addHoverDom,
                removeHoverDom: removeHoverDom,
                selectedMulti: false
            },
            edit: {
                enable: true
            },
            callback: {
                onClick: zTreeOnClick
            }
        };
        // zTree 的数据属性，深入使用请参考 API 文档（zTreeNode 节点数据详解）
        var zNodes = [
            {"id":1,"pId":0,"name":"root"},{"id":112,"pId":1,"name":"疾病"},{"id":116,"pId":112,"name":"呼吸道"},
            {"id":117,"pId":116,"name":"上呼吸道"},{"id":118,"pId":117,"name":"普通感冒"},{"id":119,"pId":117,"name":"咽炎"},
            {"id":120,"pId":116,"name":"肺炎"},{"id":157,"pId":112,"name":"胆"},{"id":158,"pId":157,"name":"胆绞痛"},
            {"id":159,"pId":157,"name":"胆囊炎"},{"id":113,"pId":1,"name":"症状"},{"id":151,"pId":113,"name":"疼痛"},
            {"id":152,"pId":113,"name":"黄疸"},{"id":153,"pId":113,"name":"发烧"},{"id":114,"pId":1,"name":"药物"},
            {"id":115,"pId":1,"name":"检查"},{"id":154,"pId":115,"name":"LFTs"},{"id":155,"pId":115,"name":"胆红素检查"},
            {"id":156,"pId":115,"name":"脂肪酶检查"},{"id":161,"pId":115,"name":"超声波检查"},{"id":163,"pId":115,"name":"核医学检查"},
            {"id":2,"pId":0,"name":"其他"},{"id":3,"pId":2,"name":"State"}
//            {"id":1,"pId":0,"name":"root"}
//            ,{"id":112,"pId":1,"name":"Disease"},{"id":116,"pId":112,"name":"Respiratory"},{"id":117,"pId":116,"name":"UpperRespiratory"},{"id":118,"pId":117,"name":"CommonCold"},{"id":119,"pId":117,"name":"Pharyngitis"},{"id":120,"pId":116,"name":"Pneumonia"},{"id":157,"pId":112,"name":"Bravery"},{"id":158,"pId":157,"name":"Cholecystalgia"},{"id":159,"pId":157,"name":"Cholecystitis"},{"id":113,"pId":1,"name":"Symptom"},{"id":151,"pId":113,"name":"Ache"},{"id":152,"pId":113,"name":"Jaundice "},{"id":153,"pId":113,"name":"Fever"},{"id":114,"pId":1,"name":"Medicine"},{"id":115,"pId":1,"name":"Examination"},{"id":154,"pId":115,"name":"LFTs"},{"id":155,"pId":115,"name":"Bilirubin"},{"id":156,"pId":115,"name":"Lipase"},{"id":161,"pId":115,"name":"UltrasonicInspection"},{"id":163,"pId":115,"name":"NuclearBiliaryPhotography"},{"id":2,"pId":0,"name":"other"},{"id":3,"pId":2,"name":"State"}
        ];
        $(document).ready(function(){
            zTreeObj = $.fn.zTree.init($("#treeDemo"), setting, zNodes);
            var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
            treeObj.expandAll(true);
        });

        cur_lang = "cn";
        var nodeName =
        {"0":{"en":""},"1":{"en":"root"},"2":{"en":"other"},"3":{"en":"State"},"112":{"en":"Disease"},
            "113":{"en":"Symptom"},"114":{"en":"Medicine"},"115":{"en":"Examination"},"116":{"en":"Respiratory"},
            "117":{"en":"UpperRespiratory"},"118":{"en":"CommonCold"},"119":{"en":"Pharyngitis"},"120":{"en":"Pneumonia"},
            "151":{"en":"Ache"},"152":{"en":"Jaundice"},"153":{"en":"Fever"},"154":{"en":"LFTs"},"155":{"en":"Bilirubin"},
            "156":{"en":"Lipase"},"157":{"en":"Bravery"},"158":{"en":"Cholecystalgia"},"159":{"en":"Cholecystitis"},
            "161":{"en":"UltrasonicInspection"},"163":{"en":"NuclearBiliaryPhotography"}}; //多语言支持 {id:{en:ename, cn:cname}}


        var curMax = 170;
        var curNodeId = -1;
        var curNodePid = -1;
        //id : {name:{type:t, enum:[]}}
        var nodeProperty =
        {"2":{},"3":{"id":"int","text":"String"},"112":{},"113":{},"114":{},"115":{},"116":{},"117":{},"118":{"duration_":"int","have_cough":"boolean"},"119":{},"120":{},"151":{"position":"String","duration_":"int"},"152":{},"153":{},"154":{"state":"String"},"155":{"state":"String"},"156":{"state":"String"},"157":{},"158":{},"159":{},"160":{},"161":{"result_":"String", "position":"String"},"162":{},"163":{"result_":"String"}};
        function requestNewId(){
            curMax += 1;
            return curMax;
        }

        function addHoverDom(treeId, treeNode) {
            var sObj = $("#" + treeNode.tId + "_span");
            if (treeNode.editNameFlag || $("#addBtn_"+treeNode.tId).length>0) return;
            var addStr = "<span class='button add' id='addBtn_" + treeNode.tId
                    + "' title='add node' onfocus='this.blur();'></span>";
            sObj.after(addStr);
            var btn = $("#addBtn_"+treeNode.tId);
            if (btn) btn.bind("click", function(){
                var zTree = $.fn.zTree.getZTreeObj("treeDemo");
                var newNodeId = requestNewId();
                zTree.addNodes(treeNode, {id:(newNodeId), pId:treeNode.id, name:"new node " + (newNodeId)});
                return false;
            });
        };

        function removeHoverDom(treeId, treeNode) {
            $("#addBtn_"+treeNode.tId).unbind().remove();
        };

        function update_en_name(){
            nodeName[curNodeId]["en"] = $("#en_name").val();
            updateDeclare();
        }

        function zTreeOnClick(event, treeId, treeNode) {
//            alert(treeNode.tId + ", " + treeNode.name);
            console.log(treeNode);
            curNodeId = treeNode.id;
            curNodePid = treeNode.pId;
            $('#node_name').html(treeNode.id + ", " + treeNode.name);
            if (!(curNodeId in nodeProperty)) nodeProperty[curNodeId] = {};
            if (!(curNodeId in nodeName)) {nodeName[curNodeId] = {"en":""};}
            $("#en_name").val(nodeName[curNodeId]["en"]);

            updatePropertyTable();
        };

        function dectectType(name){
            if (name == "int" || name == "float" || name == "String" || name == "boolean" || name == "enum")
                    return true;
            var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
            var nodes = treeObj.transformToArray(treeObj.getNodes());
            for (i = 0; i < nodes.length; ++i){
                if (name == nodes[i]["name"]) return true;
            }
            alert("No such class");
            return false;
        };

        function addNewProperty(){
            if (curNodeId == -1) {
                console.log("not found");
                return ;
            }
            var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
            var nodes = treeObj.transformToArray(treeObj.getNodes());
            for (i = 0; i < nodes.length; ++i){
//            for (n in nodes){
                n = nodes[i];
                if (n["id"] == curNodeId && $("#property_name").val() != "" && $("#property_type").val() != ""){
                    if (dectectType($("#property_type").val()) == false)
                            return false;
                    if (!(n["id"] in nodeProperty)) {nodeProperty[n["id"]] = {};}
//                    if (!(n["id"] in nodeName)) {nodeName[n["id"]] = {};}
                    nodeProperty[n["id"]][$("#property_name").val()] = $("#property_type").val();
//                    treeObj.updateNode(n);
                }
            }
            $("#property_name").val('');
            $("#property_type").val('');
            updatePropertyTable();
        };

        function delProperty(key){
            if (curNodeId == -1) {
                console.log("not found");
                return ;
            }
            if (!(curNodeId in nodeProperty)) return;
            delete nodeProperty[curNodeId][key];
            updatePropertyTable();
        };

        function updatePropertyTable(){
            if (curNodeId == -1) {
                console.log("not found");
                return ;
            }
            str = "";
            if ((curNodeId in nodeProperty)){
                for (p in nodeProperty[curNodeId]){
                    str += "<tr><td>" + nodeProperty[curNodeId][p] + "</td> <td>" + p +
                                    "</td> <td><button type='button' class='btn btn-primary' onclick=\"delProperty('" + p + "')\">删除</button></td></tr>";
                }
            }
            console.log(str);
            $("#property_tbl").html(str);
            updateDeclare();
        };

        function genDeclare(targetId){
            console.log("------" + targetId);
            var targetName = "";
            var targetPName = "";
            if (targetId == -1) return "not found";
            str = "";
            if (targetId in nodeProperty) {
                var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
                var nodes = treeObj.transformToArray(treeObj.getNodes());
                targetPId = -1;
                for (i = 0; i < nodes.length; ++i) {
                    n = nodes[i];
                    if (n["id"] == targetId) {
                        targetName = nodeName[targetId]["en"];
                        targetPId = n["pId"];
                    }
                }
                if (!(targetPId in nodeName)) nodeName[targetPId] = {"en":""};
                targetPName = nodeName[targetPId]["en"];
                if (targetName == "" || targetPName == "") str = "错误:缺少当前节点或者父节点英文名称";
                else {
                    str = "declare " + targetName;
                    if (targetPName != "root" && targetPName != "other") str += " extends " + targetPName;
                    str += "\n";
                    for (p in nodeProperty[targetId]) {
                        str += "    " + p + " : " + nodeProperty[targetId][p] + "\n";
                    }
                    str += "end\n";
                }
            }
//            if (targetId in nodeProperty) {
//                var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
//                var nodes = treeObj.transformToArray(treeObj.getNodes());
//                targetPId = -1;
//                for (i = 0; i < nodes.length; ++i) {
//                    n = nodes[i];
//                    if (n["id"] == targetId) {
//                        targetName = n["name"];
//                        targetPId = n["pId"];
//                    }
//                }
//                for (i = 0; i < nodes.length; ++i) {
//                    n = nodes[i];
//                    if (n["id"] == targetPId) targetPName = n["name"];
//                }
//                if (targetName == "" || targetPName == "") str = "error";
//                else {
//                    str = "declare " + targetName;
//                    if (targetPName != "root" && targetPName != "other") str += " extends " + targetPName;
//                    str += "\n";
//                    for (p in nodeProperty[targetId]) {
//                        str += "    " + p + " : " + nodeProperty[targetId][p] + "\n";
//                    }
//                    str += "end\n";
//                }
//            }
            return str;
        }

        function genTotalDeclare(){
            console.log("====start");
            var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
            var nodes = treeObj.transformToArray(treeObj.getNodes());
            console.log("LEN" + nodes.length);
            str = "\n";
            for (var t = 0; t < nodes.length; ++t){
//                console.log("--"+t);
                n = nodes[t];
                if (n["name"] == "root" || n["name"] == "other") continue;
                str += genDeclare(n["id"]) + "\n";
//                console.log(n["id"]);
//                console.log(genDeclare(n["id"]));
//                console.log("=="+i + " " + n["id"] + " " + n["name"]);
            }
            console.log("=====end")
            return str;
        }

        function updateDeclare(){
            var curName = "";
            var curPname = "";
            if (curNodeId == -1) {
                console.log("not found");
                return ;
            }
            str = genDeclare(curNodeId);
//            if ((curNodeId in nodeProperty)){
//            var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
//            var nodes = treeObj.transformToArray(treeObj.getNodes());
//            for (i = 0; i < nodes.length; ++i){
//                n = nodes[i];
//                if (n["id"] == curNodeId) curName = n["name"];
//                if (n["id"] == curNodePid) curPname = n["name"];
//            }
//            if (curName == "" || curPname == "") str="error";
//            else{
//                str = "declare " + curName;
//                if (curPname != "root") str += " extends " + curPname;
//                str += "\n";
//                for (p in nodeProperty[curNodeId]){
//                    str += "    " + p + " : " + nodeProperty[curNodeId][p] + "\n";
//                }
//                str += "end\n";
//            }}
            console.log(str);
            $("#declare_area").html(str);
        };

        function exportJson(){
            var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
            var nodes = treeObj.transformToArray(treeObj.getNodes());
            res = [];

            for (i = 0; i < nodes.length; ++i){
                n = nodes[i];
                res.push({"id":n["id"], "pId":n["pId"], "name":n["name"]});
            }
            console.log(res);
            tmp = JSON.stringify(res);
            return tmp;
        }

        tmp_enum_list = [];
        function add_enum_item(){
            item_content = $('#enum_input').val();
            if (item_content == ""){
                alert('缺少内容');
                return ;
            }

            p_type = $('#property_type').val();
            p_name = $('#property_name').val();
            if (p_type == "int"){
                item2num = parseInt(item_content);
                if (!isNaN(item2num)){
                    if (tmp_enum_list.indexOf(item2num) != -1){alert('已存在');return ;}
                    tmp_enum_list.push(item2num);
                    tmp_enum_list.sort();
                }
                else{
                    alert('输入内容不是int类型');
                    return ;
                }
            }
            else if (p_type == "float"){
                item2num = parseFloat(item_content);
                if (!isNaN(item2num)){
                    if (tmp_enum_list.indexOf(item2num) != -1){alert('已存在');return ;}
                    tmp_enum_list.push(item2num);
                    tmp_enum_list.sort();
                }
                else{
                    alert('输入内容不是float类型');
                    return ;
                }
            }
            else if(p_type == "boolean"){
                alert('boolean类型不需要编辑');
                return ;
            }
            else if(p_type == "String"){
                tmp_enum_list.push(item2num);
            }

            render_item_list();
        }

        function render_item_list(){
            str = "";
            for (i = 0; i < tmp_enum_list.length; ++i){
                str += "<option>" + tmp_enum_list[i] + "</option>" + "\n";
            }

            $('#item_list').html(str);
        }
    </script>
    <style type="text/css">
        .ztree li span.button.add {margin-left:2px; margin-right: -1px; background-position:-144px 0; vertical-align:top; *vertical-align:middle}
    </style>
</head>
<body>
<script>

</script>


<div class="container">
    <h2>Demo</h2>
    <div class="col-sm-5">
        <ul id="treeDemo" class="ztree"></ul>
    </div>
    <div class="col-sm-7">
        <div>
            <div><h4 id="node_name">节点名称</h4></div>
            <br />
            <div>
            <form class="form-inline">
                <div class="form-group">
                    <label for="en_name_input">英文名称:</label>
                    <input id="en_name_input" type="text" class="form-control" onchange="update_en_name();" type="text" id="en_name" placeholder="英文名称" />
                </div>
                <br />
            </form>
            </div>
            <br />
            <div>
                <form class="form-inline">
                    <div class="form-group">
                        <input id="property_type" type="text" class="form-control" list="property_type_input" placeholder="属性类型" />
                        <datalist id="property_type_input">
                            <option>int</option>
                            <option>float</option>
                            <option>boolean</option>
                            <option>String</option>
                        </datalist>
                    </div>
                    <div class="form-group">
                        <input type="text" class="form-control" id="property_name" placeholder="属性名称" />
                    </div>
                    <div class="form-group">
                        <button type="button" class="btn btn-info" data-toggle="modal" data-target="#myModal">
                            编辑
                        </button>
                    </div>
                    <div class="form-group">
                        <button type="button" class="btn btn-primary" onclick="addNewProperty();">新建</button>
                    </div>
                    <br />
                </form>
            </div>

        </div>
        <br />
        <table id="property_tbl" class="table table-striped table-bordered table-condensed">

        </table>
        <div><span onclick="$('#declare_area').toggle();">toggle</span></div>
        <div >
            <pre id="declare_area">

            </pre>
        </div>
    </div>
</div>


<%--生成--%>
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">编辑</h4>
            </div>
            <div class="modal-body">
                <form class="form-inline">
                    <div class="form-group">
                        <%--<label for="enum_input">新建: </label>--%>
                        <input id="enum_input" type="text" class="form-control" placeholder="" />
                        <button type="button" class="btn btn-primary">
                            新建
                        </button>
                    </div>
                    <br />
                </form>
                <br />
                <select multiple class="form-control" id="item_list">
                </select>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary">保存</button>
            </div>
        </div>
    </div>
</div>

</body>
</html>