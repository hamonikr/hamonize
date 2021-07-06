<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/css/ztree/zTreeStyle.css" />
<script type="text/javascript" src="/js/ztree/jquery.ztree.core.js"></script>
<script type="text/javascript" src="/js/ztree/jquery.ztree.exedit.js"></script>
<script type="text/javascript" src="/js/ztree/jquery.ztree.excheck.js"></script>
<script type="text/javascript">
	//zTree 셋팅
	var setting = {
			view: {
				selectedMulti: false
			},
			data: {
				simpleData: {
					enable: true
				}
			},
			edit: {
				drag: {
					autoExpandTrigger: true,
					prev: dropPrev,
					inner: dropInner,
					next: dropNext
				}, 
				enable: true,
				showRemoveBtn: false,
				showRenameBtn: false
			},
			callback: {
				beforeDrag: beforeDrag,
				beforeDrop: beforeDrop,
				beforeDragOpen: beforeDragOpen,
				onDrag: onDrag,
				onDrop: onDrop,
				onExpand: onExpand,
				beforeClick: beforeClick,
				onClick: onClick
			}
		};
	var zNodes =[
		//  { id:0, pId:"", name:"부서관리", open:true}, 
		<c:forEach items="${oList}" var="data" varStatus="status" >
		{ id:"${data.seq}", pId:"${data.p_seq}",
			<c:if test="${data.section ne 'S'}">
			name:"${data.org_nm} - ${data.seq}",
			icon:"/images/icon_tree1.png"
			</c:if>
			<c:if test="${data.section eq 'S'}">
			name:"[B]"+"${data.org_nm}",
			icon:"/images/icon_tree2.png"
			</c:if>
			,od:"${data.org_ordr}"
			<c:if test="${data.level eq '0' or data.level eq '1'}">
			,open:true
			</c:if>
			},
		</c:forEach>				
	];
	
	$(document).ready(function(){
		setNav('조직관리');
	//트리 init
	$.fn.zTree.init($("#tree"), setting, zNodes); 
	var treeObj =  $.fn.zTree.getZTreeObj("tree");
	var sNodes = treeObj.getSelectedNodes();
	console.log(sNodes.length);
	if (sNodes.length > 0) {
		var isOpen = sNodes[2].open;
	}
	
	$("#expandAllBtn").bind("click", {type:"expandAll"}, expandNode);
	$("#collapseAllBtn").bind("click", {type:"collapseAll"}, expandNode);
	$("#btnAddOrg").bind("click", {isParent:false}, addOrgcht);
	$("#btnAddOrg_s").bind("click", {isParent:false}, addOrgcht_s);
	$("#btnDelOrg").bind("click", removeOrgcht);
		
	//등록버튼
	$("#btnSave").click(fnSave);
	
	//순서 변경저장
    //$("#btnChange").click(fnChange);	
	
});

 $(document).on("click", ':button',  function() {
	
	var buttonName = this.name; 
	
	//담당업무 추가
	if(buttonName.indexOf('btnAddChrg') != -1) {		
		addRowChrgjob(); //담당업무 추가
	}
	
	//담당업무 삭제
	if(buttonName.indexOf("btnDelChrg") != -1) {
		var idx = $(this).index("button[name='"+buttonName+"'");
		var jobSeq = $("input[name=jobSeq]:eq("+idx+")").val()
		console.log(idx);
		console.log(jobSeq);
		removeRowChrgjob(idx,jobSeq); //담당업무 삭제
	}
}); 
//드래그 관련
 function dropPrev(treeId, nodes, targetNode) {
		var pNode = targetNode.getParentNode();
		if (pNode && pNode.dropInner === false) {
			return false;
		} else {
			for (var i=0,l=curDragNodes.length; i<l; i++) {
				var curPNode = curDragNodes[i].getParentNode();
				if (curPNode && curPNode !== targetNode.getParentNode() && curPNode.childOuter === false) {
					return false;
				}
			}
		}
		return true;
	}
	function dropInner(treeId, nodes, targetNode) {
		if (targetNode && targetNode.dropInner === false) {
			return false;
		} else {
			for (var i=0,l=curDragNodes.length; i<l; i++) {
				if (!targetNode && curDragNodes[i].dropRoot === false) {
					return false;
				} else if (curDragNodes[i].parentTId && curDragNodes[i].getParentNode() !== targetNode && curDragNodes[i].getParentNode().childOuter === false) {
					return false;
				}
			}
		}
		return true;
	}
	function dropNext(treeId, nodes, targetNode) {
		var pNode = targetNode.getParentNode();
		if (pNode && pNode.dropInner === false) {
			return false;
		} else {
			for (var i=0,l=curDragNodes.length; i<l; i++) {
				var curPNode = curDragNodes[i].getParentNode();
				if (curPNode && curPNode !== targetNode.getParentNode() && curPNode.childOuter === false) {
					return false;
				}
			}
		}
		return true;
	}
	
	var log, className = "dark", curDragNodes, autoExpandNode;
	function beforeDrag(treeId, treeNodes) {
		className = (className === "dark" ? "":"dark");
		//showLog("[ "+getTime()+" beforeDrag ]&nbsp;&nbsp;&nbsp;&nbsp; drag: " + treeNodes.length + " nodes." );
		for (var i=0,l=treeNodes.length; i<l; i++) {
			if (treeNodes[i].drag === false) {
				curDragNodes = null;
				return false;
			} else if (treeNodes[i].parentTId && treeNodes[i].getParentNode().childDrag === false) {
				curDragNodes = null;
				return false;
			}
		}
		curDragNodes = treeNodes;
		return true;
	}
	function beforeDragOpen(treeId, treeNode) {
		autoExpandNode = treeNode;
		return true;
	}
	function beforeDrop(treeId, treeNodes, targetNode, moveType, isCopy) {
		className = (className === "dark" ? "":"dark");
		//showLog("[ "+getTime()+" beforeDrop ]&nbsp;&nbsp;&nbsp;&nbsp; moveType:" + moveType);
		//showLog("target: " + (targetNode ? targetNode.name : "root") + "  -- is "+ (isCopy==null? "cancel" : isCopy ? "copy" : "move"));
		return true;
	}
	function onDrag(event, treeId, treeNodes) {
		className = (className === "dark" ? "":"dark");
		//showLog("[ "+getTime()+" onDrag ]&nbsp;&nbsp;&nbsp;&nbsp; drag: " + treeNodes.length + " nodes." );
	}
	function onDrop(event, treeId, treeNodes, targetNode, moveType, isCopy) {
		className = (className === "dark" ? "":"dark");
		//showLog("[ "+getTime()+" onDrop ]&nbsp;&nbsp;&nbsp;&nbsp; moveType:" + moveType);
		//showLog("target: " + (targetNode ? targetNode.name : "root") + "  -- is "+ (isCopy==null? "cancel" : isCopy ? "copy" : "move"))
	}
	function onExpand(event, treeId, treeNode) {
		if (treeNode === autoExpandNode) {
			className = (className === "dark" ? "":"dark");
			//showLog("[ "+getTime()+" onExpand ]&nbsp;&nbsp;&nbsp;&nbsp;" + treeNode.name);
		}
	}
	function setTrigger() {
		var zTree = $.fn.zTree.getZTreeObj("tree");
		zTree.setting.edit.drag.autoExpandTrigger = $("#callbackTrigger").attr("checked");
	}
	function beforeClick(treeId, treeNode, clickFlag) {
		className = (className === "dark" ? "":"dark");
		return (treeNode.click != false);
	}

//메뉴펼침, 닫힘
function expandNode(e) {
	var zTree = $.fn.zTree.getZTreeObj("tree"),
	type = e.data.type,
	nodes = zTree.getSelectedNodes();
	if (type == "expandAll") {
		zTree.expandAll(true);
	} else if (type == "collapseAll") {
		zTree.expandAll(false);
	} 
}
//메뉴 Tree onClick
function onClick(event, treeId, treeNode, clickFlag) {
		var zTree = $.fn.zTree.getZTreeObj("tree");
		var node = zTree.getNodeByParam('id', treeNode.pId);
		var pSpan = "#"+treeNode.parentTId+"_span";
	
		$.post("orgManage.do",{type:'show',seq:treeNode.id},
		function(result){
				var agrs = result;
				console.log(agrs);
				if(agrs.section == "S"){
					$("#trSido").remove();
					 $("#trGugun").remove();
					 $("#trOrg_num").remove();
					 $("#trPseq").remove();
					var shtml = "<tr id='trSido'><th>광역시/도</th><td><input type='text' name='sido' id='sido' class='input_type1 w100' placeholder='광역시/도를 적으세요'/></td></tr>";
			        shtml += "<tr id='trGugun'><th>시/군/구</th><td><input type='text' name='gugun' id='gugun' class='input_type1 w100' placeholder='시/군/구를 적으세요'/></td></tr>";
			        shtml += "<tr id=\"trPseq\"><th>상위부서 고유번호</th> <td><input type=\"text\" name=\"p_seq\" id=\"p_seq\" class=\"input_type1 w100\" placeholder=\"이동할 상위부서 고유번호를 적으세요\"/></td></tr>";
					$(".board_view tbody").append(shtml);
				}else{
					$("#trOrg_num").remove();
					$("#trSido").remove();
					$("#trGugun").remove();
					$("#trPseq").remove();
					 
					// var shtml = "<tr id='trOrg_num'><th>부문번호</th><td><input type='text' name='org_num' id='org_num' class='input_type1 w100' placeholder='부문번호를 적으세요'/></td></tr>";
					
					// shtml += "<tr id=\"trPseq\"><th>상위부서 고유번호</th> <td><input type=\"text\" name=\"p_seq\" id=\"p_seq\" class=\"input_type1 w100\" placeholder=\"이동할 상위부서 고유번호를 적으세요\"/></td></tr>";
					var shtml = "<tr id=\"trPseq\"><th>상위부서 고유번호</th> <td><input type=\"text\" name=\"p_seq\" id=\"p_seq\" class=\"input_type1 w100\" placeholder=\"이동할 상위부서 고유번호를 적으세요\"/></td></tr>";

					
					$(".board_view tbody").append(shtml);
				}
				//$('form[name=frm] input[name=p_org_nm]').val(agrs.p_org_nm);
				$('form[name=frm] input[name=p_org_nm]').val($(pSpan).text());
				$('form[name=frm] input[name=seq]').val(agrs.seq);
				$('form[name=frm] input[name=p_seq]').val(agrs.p_seq);
				$('form[name=frm] input[name=org_ordr]').val(agrs.org_ordr);
				$('form[name=frm] input[name=org_nm]').val(agrs.org_nm);
				$('form[name=frm] input[name=sido]').val(agrs.sido);
				$('form[name=frm] input[name=gugun]').val(agrs.gugun);
				$('form[name=frm] input[name=all_org_nm]').val(agrs.all_org_nm);
				$('form[name=frm] input[name=section]').val(agrs.section);
				//console.log("section11111===="+agrs.section)

		});
		console.log("section===="+$("#section").val())
			
		}
		
function setCheck() {
	var zTree = $.fn.zTree.getZTreeObj("tree"),
	py = $("#py").attr("checked")? "p":"",
	sy = $("#sy").attr("checked")? "s":"",
	pn = $("#pn").attr("checked")? "p":"",
	sn = $("#sn").attr("checked")? "s":"",
	type = { "Y":py + sy, "N":pn + sn};
	zTree.setting.check.chkboxType = type;
	showCode('setting.check.chkboxType = { "Y" : "' + type.Y + '", "N" : "' + type.N + '" };');
}

//부문 추가
 function addOrgcht(e) {
	$("#trOrg_num").remove();
	$("#trSido").remove();
	$("#trGugun").remove();
	$("#trPseq").remove();
	//var shtml = "<tr id='trOrg_num'><th>부문번호</th><td><input type='text' name='org_num' id='org_num' class='input_type1 w100' placeholder='부문번호를 적으세요'/></td></tr>";
	var shtml = "";
	$(".board_view tbody").append(shtml);
		
		var zTree = $.fn.zTree.getZTreeObj("tree"),
		isParent = e.data.isParent,
		nodes = zTree.getSelectedNodes(),
		treeNode = nodes[0];
		$("#nm").html("부문명");
		console.log(isParent);
		console.log(nodes);
		console.log(treeNode);
		if (treeNode) {
			$('form[name=frm] input[name=type]').val('save');
			$('form[name=frm] input[name=p_org_nm]').val('');
			$('form[name=frm] input[name=org_nm]').val('');
			$('form[name=frm] input[name=p_seq]').val('');
			$('form[name=frm] input[name=seq]').val('');
			if(treeNode.children==null)
				$('form[name=frm] input[name=org_ordr]').val(1);
			else		
				$('form[name=frm] input[name=org_ordr]').val(treeNode.children.length+1);
				
				$('form[name=frm] input[name=p_org_nm]').val(treeNode.name);
				$('form[name=frm]').append("<input type='hidden' name='p_seq' id='p_seq' value='"+treeNode.id+"' />");
				$('form[name=frm] input[name=org_nm]').focus();
				
				console.log("treeNode.id==="+treeNode.id);
				console.log("all====="+$("#all_org_nm").val());
				console.log(treeNode.name);
				console.log(treeNode.id);
				console.log($("#seq").val());
				console.log();
			
		} else {
			alert("부문을 선택해 주세요.");
		}
	};
	
	//부서 추가
	 function addOrgcht_s(e) {
		 $("#trSido").remove();
		 $("#trGugun").remove();
		 $("#trOrg_num").remove();
		 $("#trPseq").remove();
		var shtml = "<tr id='trSido'><th>광역시/도</th><td><input type='text' name='sido' id='sido' class='input_type1 w100' placeholder='광역시/도를 적으세요'/></td></tr>";
        shtml += "<tr id='trGugun'><th>시/군/구</th><td><input type='text' name='gugun' id='gugun' class='input_type1 w100' placeholder='시/군/구를 적으세요'/></td></tr>";
		$(".board_view tbody").append(shtml);
		
		var zTree = $.fn.zTree.getZTreeObj("tree"),
			isParent = e.data.isParent,
			nodes = zTree.getSelectedNodes(),
			treeNode = nodes[0];
			$("#nm").html("부서명");
			console.log(isParent);
			console.log(nodes);
			console.log(treeNode);
			if (treeNode) {
				$('form[name=frm] input[name=p_org_nm]').val('');
				$('form[name=frm] input[name=org_nm]').val('');
				$('form[name=frm] input[name=p_seq]').val('');
				$('form[name=frm] input[name=seq]').val('');
				if(treeNode.children==null)
					$('form[name=frm] input[name=org_ordr]').val(1);
				else		
					$('form[name=frm] input[name=org_ordr]').val(treeNode.children.length+1);
					$('form[name=frm] input[name=p_org_nm]').val(treeNode.name);
					$('form[name=frm]').append("<input type='hidden' name='p_seq' id='p_seq' value='"+treeNode.id+"' />");
					$('form[name=frm] input[name=section]').val('S');
					$('form[name=frm] input[name=org_nm]').focus();
				
					console.log(treeNode.name);
					console.log(treeNode.id);
					console.log($("#seq").val());
					console.log($("#section").val());
				
			} else {
				alert("부문을 선택해 주세요.");
			}
		};
		
		//부서 삭제 
 function removeOrgcht(e) {
	 	var all_org_nm = $("#all_org_nm").val();
		var zTree = $.fn.zTree.getZTreeObj("tree"),
		nodes = zTree.getSelectedNodes(),
		treeNode = nodes[0];
		
		if (nodes.length == 0) {
			alert("부문을 선택해 주세요");
			return;
		}else{
			if(confirm("하위부서가 있다면 하위부서도 전부 삭제됩니다 삭제하시겠습니까?")){
				
				 $.post("orgManage.do",{
						 type: 'delt'
						,seq:treeNode.id
						,p_seq:treeNode.pId
						,org_ordr:treeNode.od
						,org_nm:$("#org_nm").val()
						,all_org_nm:$("#all_org_nm").val()
					},
					function(result){
						console.log("result===="+result);
						if(result > 0)
							alert("정상적으로 삭제되었습니다.");
						else
							alert("삭제가 실패되었습니다.");
						var callbackFlag = $("#callbackTrigger").attr("checked");
						zTree.removeNode(treeNode, callbackFlag);
						location.reload();
				    }); 
			}
		}
	};
 

//등록 처리결과(공통명 : 프로그램명Json )
function fnSave(){
	
	if($("#org_nm").val()==""){
		alert("부서명을 입력해주세요.");
		return false;
	}
	
	var regExp = /[\{\}\[\]\?.,;:|\*~`!^\-<>@\#$%&\\\=\'\"]/gi;
	 
	if(regExp.test($("#org_nm").val())){
		//특수문자 존재
		alert("허용되지 않은 특수문자가 있습니다.특수문자는 ( ) / _ + 만 사용하실수 있습니다.");
		return false;
	}
	
	if($("#seq").val() == null){
		console.log("등록");
	}else{
		console.log("수정");
		console.log("p_seq===="+$("#p_seq").val());
	}
	var all_org_nm = $("#all_org_nm").val();
	var org_nm = all_org_nm.split("|");

    $('form[name=frm]').append("<input type='hidden' name='type' value='save' />");        
    
    $.ajax({
		url: 'orgManage.do',							// Any URL
		type: 'post',
		data: $('#frm').serialize(),                 // Serialize the form data
		success: function (data) { 					// If 200 OK
			alert("등록되었습니다.");
				location.reload();
		},
		error: function (xhr, text, error) {              // If 40x or 50x; errors
			alert("등록되지 않았습니다.");
			return false;
		}
	});
}
</script>

<body>
	<%@ include file="../template/topMenu.jsp" %>
	<%@ include file="../template/topNav.jsp" %>
	
	
	<!-- width 100% 컨텐츠 other 추가 -->
    <div class="hamo_container other">

        <!-- 좌측 트리 -->
        <div class="con_left">
            <div class="left_box">
                <ul class="location">
                </ul>
                <h2 class="tree_head">조직관리</h2>

                <ul class="view_action">
                    <li id="expandAllBtn">전체열기 </li>
                    <li id="collapseAllBtn">전체닫기</li>
                </ul>
                <!-- 트리 리스트 -->
                <div class="tree_list">
                    <ul id="tree" class="ztree"></ul>
                </div>
                <div class="tree_btn">
                    <button type="button" class="btn_type3" id="btnAddOrg" name="btnAddOrg">+ 부문추가</button>
                    <button type="button" class="btn_type3" id="btnAddOrg_s" name="btnAddOrg_s">+ 부서추가</button>
                	<button type="button" class="btn_type3" id="btnDelOrg" name="btnDelOrg">- 삭제</button>
                </div>
                
            </div>
        </div>
	
	<!-- 우측 리스트 -->
        <div class="con_right" >
            <div class="right_box" >

                <h3>조직정보</h3>
                <form name="frm" id="frm" method="post" action="orgManage.do" class="row">
                	<input type="hidden" name="seq" id="seq" value="" />
					<input type="hidden" name="section" id="section" value="" />
					<input type="hidden" name="all_org_nm" id="all_org_nm" value="" />
                <div class="board_view mT20" id="org_info">
                    <table>
                        <colgroup>
                            <col style="width:20%;" />
                            <col />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th>상위부문</th>
                                <td><input type="text" name="p_org_nm" id="p_org_nm" class="input_type1 w100" readonly="readonly"/></td>
                            </tr>
                            <tr>
                                <th>부문순서</th>
                                <td><input type="text" name="org_ordr" id="org_ordr" class="input_type1 w100" readonly="readonly"/></td>
                            </tr>
                            <tr>
                                <th id="nm">부서명</th>
                                <td><input type="text" name="org_nm" id="org_nm" class="input_type1 w100" placeholder="부서명을 적으세요"/></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
				<!-- //List -->
                </form>
                <div class="t_center mT20">
                    <button type="reset" class="btn_type2" id="btnInit">초기화</button>
                    <button type="button" class="btn_type2" id="btnSave">저장</button>
                </div>
            </div>
        </div>


    </div><!-- //content -->
	
	<%@ include file="../template/grid.jsp" %>
	<%@ include file="../template/footer.jsp" %>
	
	
</body>
</html>