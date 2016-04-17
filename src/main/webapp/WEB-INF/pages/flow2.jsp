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
    <script src="static/go.js"></script>

    <script>
        function init() {
            if (window.goSamples) goSamples();  // init for these samples -- you don't need to call this
            var $ = go.GraphObject.make;  // for conciseness in defining templates
            myDiagram =
                    $(go.Diagram, "myDiagram",  // must name or refer to the DIV HTML element
                            {
                                initialContentAlignment: go.Spot.Center,
                                allowDrop: true,  // must be true to accept drops from the Palette
                                "LinkDrawn": showLinkLabel,  // this DiagramEvent listener is defined below
                                "LinkRelinked": showLinkLabel,
                                "animationManager.duration": 800, // slightly longer than default (600ms) animation
                                "undoManager.isEnabled": true,  // enable undo & redo
                                "ChangedSelection": onSelectionChanged
                            });
            // when the document is modified, add a "*" to the title and enable the "Save" button
            myDiagram.addDiagramListener("Modified", function (e) {
                var button = document.getElementById("SaveButton");
                if (button) button.disabled = !myDiagram.isModified;
                var idx = document.title.indexOf("*");
                if (myDiagram.isModified) {
                    if (idx < 0) document.title += "*";
                } else {
                    if (idx >= 0) document.title = document.title.substr(0, idx);
                }
            });


        function nodeStyle() {
            return [
                // The Node.location comes from the "loc" property of the node data,
                // converted by the Point.parse static method.
                // If the Node.location is changed, it updates the "loc" property of the node data,
                // converting back using the Point.stringify static method.
                new go.Binding("location", "loc", go.Point.parse).makeTwoWay(go.Point.stringify),
                {
                    // the Node.location is at the center of each node
                    locationSpot: go.Spot.Center,
                    //isShadowed: true,
                    //shadowColor: "#888",
                    // handle mouse enter/leave events to show/hide the ports
                    mouseEnter: function (e, obj) { showPorts(obj.part, true); },
                    mouseLeave: function (e, obj) { showPorts(obj.part, false); }
                }
            ];
        }
        // Define a function for creating a "port" that is normally transparent.
        // The "name" is used as the GraphObject.portId, the "spot" is used to control how links connect
        // and where the port is positioned on the node, and the boolean "output" and "input" arguments
        // control whether the user can draw links from or to the port.
        function makePort(name, spot, output, input) {
            // the port is basically just a small circle that has a white stroke when it is made visible
            return $(go.Shape, "Circle",
                    {
                        fill: "transparent",
                        stroke: null,  // this is changed to "white" in the showPorts function
                        desiredSize: new go.Size(8, 8),
                        alignment: spot, alignmentFocus: spot,  // align the port on the main Shape
                        portId: name,  // declare this object to be a "port"
                        fromSpot: spot, toSpot: spot,  // declare where links may connect at this port
                        fromLinkable: output, toLinkable: input,  // declare whether the user may draw links to/from here
                        cursor: "pointer"  // show a different cursor to indicate potential link point
                    });
        }
        // define the Node templates for regular nodes
        var lightText = 'whitesmoke';
        myDiagram.nodeTemplateMap.add("",  // the default category
                $(go.Node, "Spot", nodeStyle(),
                        // the main object is a Panel that surrounds a TextBlock with a rectangular Shape
                        $(go.Panel, "Auto",
                                $(go.Shape, "Rectangle",
                                        { fill: "#00A9C9", stroke: null },
                                        new go.Binding("figure", "figure")),
                                $(go.TextBlock,
                                        {
                                            font: "bold 11pt Helvetica, Arial, sans-serif",
                                            stroke: lightText,
                                            margin: 8,
                                            maxSize: new go.Size(160, NaN),
                                            wrap: go.TextBlock.WrapFit,
                                            editable: true
                                        },
                                        new go.Binding("text").makeTwoWay())
                        ),
                        // four named ports, one on each side:
                        makePort("T", go.Spot.Top, false, true),
                        makePort("L", go.Spot.Left, true, true),
                        makePort("R", go.Spot.Right, true, true),
                        makePort("B", go.Spot.Bottom, true, false)
                ));
        myDiagram.nodeTemplateMap.add("Start",
                $(go.Node, "Spot", nodeStyle(),
                        $(go.Panel, "Auto",
                                $(go.Shape, "Circle",
                                        { minSize: new go.Size(40, 40), fill: "#79C900", stroke: null }),
                                $(go.TextBlock, "Start",
                                        { font: "bold 11pt Helvetica, Arial, sans-serif", stroke: lightText },
                                        new go.Binding("text"))
                        ),
                        // three named ports, one on each side except the top, all output only:
                        makePort("L", go.Spot.Left, true, false),
                        makePort("R", go.Spot.Right, true, false),
                        makePort("B", go.Spot.Bottom, true, false)
                ));
        myDiagram.nodeTemplateMap.add("End",
                $(go.Node, "Spot", nodeStyle(),
                        $(go.Panel, "Auto",
                                $(go.Shape, "Circle",
                                        { minSize: new go.Size(40, 40), fill: "#DC3C00", stroke: null }),
                                $(go.TextBlock, "End",
                                        { font: "bold 11pt Helvetica, Arial, sans-serif", stroke: lightText },
                                        new go.Binding("text"))
                        ),
                        // three named ports, one on each side except the bottom, all input only:
                        makePort("T", go.Spot.Top, false, true),
                        makePort("L", go.Spot.Left, false, true),
                        makePort("R", go.Spot.Right, false, true)
                ));
        myDiagram.nodeTemplateMap.add("Comment",
                $(go.Node, "Auto", nodeStyle(),
                        $(go.Shape, "File",
                                { fill: "#EFFAB4", stroke: null }),
                        $(go.TextBlock,
                                {
                                    margin: 5,
                                    maxSize: new go.Size(200, NaN),
                                    wrap: go.TextBlock.WrapFit,
                                    textAlign: "center",
                                    editable: true,
                                    font: "bold 12pt Helvetica, Arial, sans-serif",
                                    stroke: '#454545'
                                },
                                new go.Binding("text").makeTwoWay())
                        // no ports, because no links are allowed to connect with a comment
                ));
        // replace the default Link template in the linkTemplateMap
        myDiagram.linkTemplate =
                $(go.Link,  // the whole link panel
                        {
                            routing: go.Link.AvoidsNodes,
                            curve: go.Link.JumpOver,
                            corner: 5, toShortLength: 4,
                            relinkableFrom: true,
                            relinkableTo: true,
                            reshapable: true,
                            resegmentable: true,
                            // mouse-overs subtly highlight links:
                            mouseEnter: function(e, link) { link.findObject("HIGHLIGHT").stroke = "rgba(30,144,255,0.2)"; },
                            mouseLeave: function(e, link) { link.findObject("HIGHLIGHT").stroke = "transparent"; }
                        },
                        new go.Binding("points").makeTwoWay(),
                        $(go.Shape,  // the highlight shape, normally transparent
                                { isPanelMain: true, strokeWidth: 8, stroke: "transparent", name: "HIGHLIGHT" }),
                        $(go.Shape,  // the link path shape
                                { isPanelMain: true, stroke: "gray", strokeWidth: 2 }),
                        $(go.Shape,  // the arrowhead
                                { toArrow: "standard", stroke: null, fill: "gray"}),
                        $(go.Panel, "Auto",  // the link label, normally not visible
                                { visible: true, name: "LABEL", segmentIndex: 2, segmentFraction: 0.5},
                                new go.Binding("visible", "visible").makeTwoWay(),
                                $(go.Shape, "RoundedRectangle",  // the label shape
                                        { fill: "transparent", stroke: "transparent" }),
                                $(go.TextBlock, "",  // the label
                                        {
                                            textAlign: "center",
                                            font: "10pt helvetica, arial, sans-serif",
                                            stroke: "#333333",
                                            editable: false
                                        },
                                        new go.Binding("text", "text").makeTwoWay())
                        )
                );
        // Make link labels visible if coming out of a "conditional" node.
        // This listener is called by the "LinkDrawn" and "LinkRelinked" DiagramEvents.
        function showLinkLabel(e) {
            var label = e.subject.findObject("LABEL");
            console.log(label);
//            if (label !== null) label.visible = (e.subject.fromNode.data.figure === "Diamond");
//            if (label == "") label.visible = false;
//            else label.visible = true;
        }

        // temporary links used by LinkingTool and RelinkingTool are also orthogonal:
        myDiagram.toolManager.linkingTool.temporaryLink.routing = go.Link.Orthogonal;
        myDiagram.toolManager.relinkingTool.temporaryLink.routing = go.Link.Orthogonal;
        load();  // load an initial diagram from some JSON text
        // initialize the Palette that is on the left side of the page
        myPalette =
                $(go.Palette, "myPalette",  // must name or refer to the DIV HTML element
                        {
                            "animationManager.duration": 800, // slightly longer than default (600ms) animation
                            nodeTemplateMap: myDiagram.nodeTemplateMap,  // share the templates used by myDiagram
                            model: new go.GraphLinksModel([  // specify the contents of the Palette
                                { category: "Start", text: "Start" },
                                { text: "Step" },
                                { text: "???", figure: "Diamond" },
                                { category: "End", text: "End" },
                                { category: "Comment", text: "Comment" }
                            ])
                        });
        }
        // Make all ports on a node visible when the mouse is over the node
        function showPorts(node, show) {
            var diagram = node.diagram;
            if (!diagram || diagram.isReadOnly || !diagram.allowLink) return;
            node.ports.each(function(port) {
                port.stroke = (show ? "white" : null);
            });
        }
        // Show the diagram's model in JSON format that the user may edit
        function save() {
            document.getElementById("mySavedModel").value = myDiagram.model.toJson();
            myDiagram.isModified = false;
        }
        function load() {
            myDiagram.model = go.Model.fromJson(document.getElementById("mySavedModel").value);
        }
        // add an SVG rendering of the diagram at the end of this page
        function makeSVG() {
            var svg = myDiagram.makeSvg({
                scale: 0.5
            });
            svg.style.border = "1px solid black";
            obj = document.getElementById("SVGArea");
            obj.appendChild(svg);
            if (obj.children.length > 0) {
                obj.replaceChild(svg, obj.children[0]);
            }
        }

        function onSelectionChanged(e) {
//            var node = e.diagram.selection.first();
//            console.log(node.data);
//            if (node instanceof go.Node) {
//                updateProperties(node.data);
//            } else {
//                updateProperties(null);
//            }
            var part = e.diagram.selection.first();
//            console.log(part.data);
            if (part instanceof go.Link){
                console.log("sss");
                updateProperties(part.data, "link");
            }
            else if(part instanceof go.Node){
                updateProperties(part.data, "node");
            }
            else {
                updateProperties(null, null);
            }
        }

        function updateProperties(data, ptype) {
            console.log(data);
            if (ptype == "link"){
                $('#linkProperty').show();
                $('#nodeProperty').hide();
                $('#linkText').val(data.text || "");
                $('#linkCond').val(data.cond || "");
                $('#linkDoc').val(data.doc || "");
            }
            else if (ptype == "node"){
                $('#linkProperty').hide();
                $('#nodeProperty').show();
                $('#nodeText').val(data.text || "");
                $('#nodeCmt').val(data.cmt || "");
            }
            else{
                $('#linkProperty').hide();
                $('#nodeProperty').hide();
                $('#linkText').val("");
                $('#linkCond').val("");
                $('#linkDoc').val("");
                $('#nodeText').val("");
                $('#nodeCmt').val("");
            }
//            if (data === null) {
//                document.getElementById("propertiesPanel").style.display = "none";
//                document.getElementById("advice").value = "";
//                document.getElementById("relatedDoc").value = "";
//                document.getElementById("comments").value = "";
//            } else {
//                document.getElementById("propertiesPanel").style.display = "block";
//                document.getElementById("advice").value = data.advice || "";
//                document.getElementById("relatedDoc").value = data.relatedDoc || "";
//                document.getElementById("comments").value = data.comments || "";
//            }
        }

        function updateData(text, field) {
            var node = myDiagram.selection.first();
            // maxSelectionCount = 1, so there can only be one Part in this collection
            var data = node.data;
            if ((node instanceof go.Node || node instanceof go.Link)&& data !== null) {
                var model = myDiagram.model;
                model.startTransaction("modified " + field);
//                if (field === "Advice") {
//                    model.setDataProperty(data, "Advice", text);
//                } else if (field === "RelatedDoc") {
//                    model.setDataProperty(data, "RelatedDoc", text);
//                } else if (field === "Comments") {
//                    model.setDataProperty(data, "Comments", text);
//                }
                model.setDataProperty(data, field, text);
                model.commitTransaction("modified " + field);
            }
        }

        function genRule(){
            myjson = myDiagram.model.toJson();
            myjson = eval("(" + myjson + ")");
            links = myjson["linkDataArray"];
            nodes = myjson["nodeDataArray"];

            totalRules = ""

            for (t = 0; t < links.length; ++t){
                li = links[t];
                console.log(li);
                fromid = li["from"];
                toid = li["to"];
                cond = li["cond"];
                docs = li["doc"];
                if (docs != undefined && docs != "") docs = " [" + docs + "]";
                else docs = "";
                totext = "";
                for (u = 0; u < nodes.length; ++u){no = nodes[u]; if(no["key"] == toid) totext = no["text"];}
                if(totext == "End") continue;
                str = "rule \"" + fromid + "->"+ toid + "\"\n";
                str += "when\n";
                str += "s: State(id == " + fromid + ")\n";
                str += "r: ReasonChain()\n";
                str += cond + "\n";
                str += "then\n";
                str += "modify(s){id = " + toid + ", text = \"" + totext + "\"};\n";
                str += "modify(r){text += \""+ li["text"] + "->" + totext + docs +"\\n\"};\n";
                str += "end";
//                console.log(str);
                totalRules += str + "\n\n\/\/\n";
            }
            console.log(totalRules);
        }

        function check_flow_chart(){
            myjson = myDiagram.model.toJson();
            myjson = eval("(" + myjson + ")");
            links = myjson["linkDataArray"];
            nodes = myjson["nodeDataArray"];

            //检查唯一开始结束节点
            start_count = 0;
            end_count = 0;
            start_tid = -1;
            end_tid = -1;
            str = "";
            for (t = 0; t < nodes.length; ++t){
                if ("category" in nodes[t]){
                    if (nodes[t]["category"] == "Start") {
                        start_count += 1;
                        start_tid = nodes[t]["key"];
                    }
                    else if(nodes[t]["category"] == "End") {
                        end_count += 1;
                        end_tid = nodes[t]["key"];
                    }
                }
            }
            if (start_count == 0) str += "缺少开始节点\n";
            else if(start_count > 1) str += "发现多余的开始节点\n";
            if (end_count == 0) str += "缺少结束节点\n";
            else if(end_count > 1) str += "发现多余的结束节点\n";

            if (str != ""){
                $('#check_info').html(str);
                return;
            }

            //检查没有断头链
//            find_num = 0;
            link_map = {}
            for (t = 0; t < links.length; ++t){
                li = links[t];
//                console.log(li);
                fromid = li["from"];
                toid = li["to"];
                cond = li["cond"];
                docs = li["doc"];
                if (!(fromid in link_map)){
                    link_map[fromid] = {};
                }
                link_map[fromid][toid] = 1;
            }
            connect_map = {};
            visit_map = {start_tid:1};
            connect_map[start_tid] = 1;
            _cur_count = 0;
            _last_count = 0;
            while(true){
                for (k in connect_map){
                    delete connect_map[k];
                    if (k in visit_map) continue;
                    visit_map[k] = 1;
                    _cur_count += 1;
                    if (k in link_map){
                        for (k2 in link_map[k]){
                            connect_map[k2] = 1;
                        }
                    }
                }
                if(_cur_count == _last_count) break;
                _last_count = _cur_count;
            }
            if(_cur_count < nodes.length) str += "存在开始节点无法到达的节点<br />";
//            console.log("count:" + _cur_count);

            link_map = {}
            for (t = 0; t < links.length; ++t){
                li = links[t];
//                console.log(li);
                toid = li["from"];
                fromid = li["to"];
                cond = li["cond"];
                docs = li["doc"];
                if (!(fromid in link_map)){
                    link_map[fromid] = {};
                }
                link_map[fromid][toid] = 1;
            }
            connect_map = {};
            visit_map = {end_tid:1};
            connect_map[end_tid] = 1;
            _cur_count = 0;
            _last_count = 0;
            while(true){
                for (k in connect_map){
                    delete connect_map[k];
                    if (k in visit_map) continue;
                    visit_map[k] = 1;
                    _cur_count += 1;
                    if (k in link_map){
                        for (k2 in link_map[k]){
                            connect_map[k2] = 1;
                        }
                    }
                }
                if(_cur_count == _last_count) break;
                _last_count = _cur_count;
            }
            if(_cur_count < nodes.length) str += "存在无法到达结束节点的节点<br />";

            $('#check_info').html(str);

        }

    </script>

</head>
<body onload="init()">
<div id="sample">
    <div style="width:100%; white-space:nowrap;">
    <span style="display: inline-block; vertical-align: top; padding: 5px; width:100px">
      <div id="myPalette" style="border: solid 1px gray; height: 720px"></div>
    </span>
    <span style="display: inline-block; vertical-align: top; padding: 5px; width:80%">
      <div id="myDiagram" style="border: solid 1px gray; height: 720px" onmouseup="check_flow_chart();" onclick="check_flow_chart();" onkeyup="check_flow_chart();"></div>
    </span>
    </div>
    <%--<p>--%>
        <%--The FlowChart sample demonstrates several key features of GoJS,--%>
        <%--namely <a href="../intro/palette.html">Palette</a>s,--%>
        <%--<a href="../intro/links.html">Linkable nodes</a>, Drag/Drop behavior,--%>
        <%--<a href="../intro/textBlocks.html">Text Editing</a>, and the use of--%>
        <%--<a href="../intro/templateMaps.html">Node Template Maps</a> in Diagrams.--%>
    <%--</p>--%>
    <%--<p>--%>
        <%--Mouse-over a Node to view its ports.--%>
        <%--Drag from these ports to create new Links.--%>
        <%--Selecting Links allows you to re-shape and re-link them.--%>
        <%--Selecting a Node and then clicking its TextBlock will allow--%>
        <%--you to edit text (except on the Start and End Nodes).--%>
    <%--</p>--%>
    <%--<p>--%>
        <%--The Diagram Model data is loaded from the JSON below.--%>
    <%--</p>--%>
    <div>
        <div id="nodeProperty" style="display: none; background-color: aliceblue; border: solid 1px black">
            <b>Node Properties</b><br />
            Text: <input type="text" id="nodeText" style="width:50%" value="" onchange="updateData(this.value, 'text')" /><br />
            Comment: <input type="text" id="nodeCmt" style="width:50%" value="" onchange="updateData(this.value, 'cmt')" /><br />
        </div>
        <div id="linkProperty" style="display: none; background-color: aliceblue; border: solid 1px black">
            <b>Link Properties</b><br />
            Text: <input type="text" id="linkText" style="width:50%" value="" onchange="updateData(this.value, 'text')" /><br />
            Condition: <textarea type="text" id="linkCond" style="width:50%" value="" onchange="updateData(this.value, 'cond')"></textarea><br />
            Related Docs: <input type="text" id="linkDoc" style="width:50%" value="" onchange="updateData(this.value, 'doc')" /><br />

        </div>
    </div>
    <div id="check_info" style="background:#FFB6C1">

    </div>
    <button id="SaveButton" onclick="save()">Save</button>
    <button onclick="load()">Load</button>
    <button onclick="$('#mydata').toggle();">Toggle</button>
    <div id="mydata">
  <textarea id="mySavedModel" style="width:100%;height:300px">
      { "class": "go.GraphLinksModel",
  "linkFromPortIdProperty": "fromPort",
  "linkToPortIdProperty": "toPort",
  "nodeDataArray": [
{"category":"Start", "text":"Start", "key":-1, "loc":"125.109375 -637"},
{"text":"需要体温、LFTs、胆红素、脂肪酶检查", "key":-2, "loc":"131.109375 -524"},
{"text":"考虑胆绞痛，需要右上腹超声进一步检查", "key":-3, "loc":"-179.890625 -384"},
{"text":"结论：胆绞痛", "key":-4, "loc":"-175.890625 -247"},
{"text":"考虑胆囊炎，需要右上腹超声进一步检查", "key":-5, "loc":"138.109375 -385"},
{"text":"需要核医学胆道摄影", "key":-6, "loc":"28.109375 -252"},
{"text":"结论：胆囊炎", "key":-7, "loc":"235.109375 -149"},
{"text":"考虑胆总管结石和反流性胆管炎，若脂肪酶升高考虑胰腺炎。\n考虑行US、EUS、MRCP或ERCP", "key":-8, "loc":"460.109375 -346"},
{"category":"End", "text":"End", "key":-9, "loc":"224.109375 -14"}
 ],
  "linkDataArray": [
{"from":-1, "to":-2, "fromPort":"B", "toPort":"T", "points":[125.109375,-612.2266599078512,125.109375,-602.2266599078512,125.109375,-580.3010542581249,131.109375,-580.3010542581249,131.109375,-558.3754486083984,131.109375,-548.3754486083984], "cond":"Ache(position == \"venter superior\")", "text":"上腹痛"},
{"from":-2, "to":-3, "fromPort":"L", "toPort":"T", "points":[46.46046447753906,-524,36.46046447753906,-524,-179.890625,-524,-179.890625,-471.1877243041992,-179.890625,-418.3754486083984,-179.890625,-408.3754486083984], "cond":"Ache(position == \"venter superior\", duration_ < 7)\nnot (Jaundice())\nnot (Fever())\nLFTs(state == \"Normal\")\nLipase(state == \"Normal\")", "text":"发作时间短，无黄疸、发热，LFTs、脂肪酶正常", "doc":"123"},
{"from":-3, "to":-4, "fromPort":"B", "toPort":"T", "points":[-179.890625,-359.6245513916015,-179.890625,-349.6245513916015,-179.890625,-311.53113784790037,-175.890625,-311.53113784790037,-175.890625,-273.4377243041992,-175.890625,-263.4377243041992], "cond":"UltrasonicInspection(result_ == \"positive\")", "text":"（阳性）", "doc":"456"},
{"from":-2, "to":-5, "fromPort":"B", "toPort":"T", "points":[131.109375,-499.6245513916015,131.109375,-489.6245513916015,131.109375,-454.5,138.109375,-454.5,138.109375,-419.3754486083984,138.109375,-409.3754486083984], "text":"持续性腹痛，可能出现发热，胆红素、LFTs、脂肪酶正常", "cond":"Ache(position == \"venter superior\", duration_ >= 7)\nLFTs(state == \"Normal\")\nLipase(state == \"Normal\")"},
{"from":-5, "to":-6, "fromPort":"L", "toPort":"T", "points":[56.30943298339844,-385,46.30943298339844,-385,28.109375,-385,28.109375,-331.71886215209963,28.109375,-278.4377243041992,28.109375,-268.4377243041992], "text":"未确诊", "cond":"UltrasonicInspection(position==\"right upper quadrant\", result_==\"DU\")"},
{"from":-5, "to":-7, "fromPort":"R", "toPort":"T", "points":[219.90931701660156,-385,229.90931701660156,-385,235.109375,-385,235.109375,-280.21886215209963,235.109375,-175.4377243041992,235.109375,-165.4377243041992], "text":"胆结石伴胆囊壁增厚或水肿", "cond":"UltrasonicInspection(position==\"right upper quadrant\", result_ ==\"gall stone\" )"},
{"from":-6, "to":-7, "fromPort":"B", "toPort":"L", "points":[28.109375,-235.56227569580076,28.109375,-225.56227569580076,28.109375,-149,100.36939239501953,-149,172.62940979003906,-149,182.62940979003906,-149], "text":"胆道无显影", "cond":"NuclearBiliaryPhotography(result_ == \"absent of  biliary tract sign\")"},
{"from":-2, "to":-8, "fromPort":"R", "toPort":"T", "points":[215.2178192138672,-524,225.2178192138672,-524,460.109375,-524,460.109375,-464.09431076049805,460.109375,-404.1886215209961,460.109375,-394.1886215209961], "text":"持续性腹痛，可能出现发热，胆红素、脂肪酶或LFTs升高", "cond":"Ache(position == \"venter superior\", duration_ >= 7)\nLFTs(state == \"Up\")\nLipase(state == \"Up\")"},
{"from":-8, "to":-9, "fromPort":"B", "toPort":"R", "points":[460.109375,-297.8113784790039,460.109375,-287.8113784790039,460.109375,-14,357.42037844103436,-14,254.73138188206872,-14,244.73138188206872,-14]},
{"from":-7, "to":-9, "fromPort":"B", "toPort":"T", "points":[235.109375,-132.56227569580076,235.109375,-122.56227569580076,235.109375,-83.59214128893474,224.109375,-83.59214128893474,224.109375,-44.622006882068725,224.109375,-34.622006882068725]},
{"from":-4, "to":-9, "fromPort":"B", "toPort":"L", "points":[-175.890625,-230.56227569580076,-175.890625,-220.56227569580076,-175.890625,-14,8.798371558965641,-14,193.48736811793128,-14,203.48736811793128,-14]}
 ]}
  </textarea>
    </div>
    <%--<p>Click the button below to render the current GoJS Diagram into SVG at one-half scale.--%>
        <%--The SVG is not interactive like the GoJS diagram, but can be used for printing or display.--%>
        <%--For more information, see the page on <a href="../intro/makingSVG.html">making SVG</a>.</p>--%>
    <button onclick="makeSVG()">Render as SVG</button>
    <div id="SVGArea"></div>
</div>
</body>
</html>