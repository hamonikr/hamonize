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
		<c:forEach items="${oList}" var="data" varStatus="status" >
		{ id:"${data.seq}", pId:"${data.p_seq}",domain:"${data.domain}",
			<c:if test="${data.section ne 'S'}">
			name:"${data.org_nm} "
			</c:if>
			<c:if test="${data.section eq 'S'}">
			name:"${data.org_nm}"
			</c:if>
			,od:"${data.org_ordr}"
			<c:if test="${data.level eq '0' or data.level eq '1' or data.level eq '2'}">
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
	// console.log(sNodes.length);
	if (sNodes.length > 0) {
		var isOpen = sNodes[2].open;
	}
	//최상위부서가 없을시 도메인명으로 자동등록
	if (treeObj.getNodes().length < 1) {
		if(confirm("최상위 부서가 등록되지 않았습니다. 등록하시겠습니까?")){
				$.ajax({
				url: 'orgManage',							// Any URL
				type: 'post',
				data: {type:'save',org_nm:'${domain}',all_org_nm:'',p_org_nm:'',section:''},                 // Serialize the form data
				success: function (data) { 					// If 200 OK
					location.reload();
				},
				error: function (xhr, text, error) {              // If 40x or 50x; errors
					alert("최상위 부서가 등록되지 않았습니다. QnA에 문의 주기시 바랍니다.");
					return false;
				}
			});
		}
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
		return true;
	}
	function onDrag(event, treeId, treeNodes) {
		className = (className === "dark" ? "":"dark");
	}
	function onDrop(event, treeId, treeNodes, targetNode, moveType, isCopy) {
		className = (className === "dark" ? "":"dark");
	}
	function onExpand(event, treeId, treeNode) {
		if (treeNode === autoExpandNode) {
			className = (className === "dark" ? "":"dark");
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

		$.post("orgManage",{type:'show',seq:treeNode.id,domain:treeNode.domain},
		function(result){
				var agrs = result;
				console.log(agrs);
				if(agrs.section == "S"){
					
					$("#trOrg_num").remove();
					$("#trPseq").remove();
					$('#nm').html("팀명");
				
					var shtml = "<tr id=\"trPseq\"><th>상위 부서번호</th> <td><input type=\"text\" name=\"p_seq\" id=\"p_seq\" class=\"input_type1 w100\" readonly /></td></tr>";
					$(".board_view tbody").append(shtml);
				}else{
					$('#nm').html("부서명");
					$("#trOrg_num").remove();
					$("#trPseq").remove();
					 
					var shtml = "<tr id=\"trPseq\"><th>상위 부서번호</th> <td><input type=\"text\" name=\"p_seq\" id=\"p_seq\" class=\"input_type1 w100\" /></td></tr>";

					
					$(".board_view tbody").append(shtml);
				}
				$('form[name=frm] input[name=p_org_nm]').val($(pSpan).text());
				$('form[name=frm] input[name=seq]').val(agrs.seq);
				$('form[name=frm] input[name=p_seq]').val(agrs.p_seq);
				$('form[name=frm] input[name=org_ordr]').val(agrs.org_ordr);
				$('form[name=frm] input[name=org_nm]').val(agrs.org_nm);
				$('form[name=frm] input[name=sido]').val(agrs.sido);
				$('form[name=frm] input[name=gugun]').val(agrs.gugun);
				$('form[name=frm] input[name=all_org_nm]').val(agrs.all_org_nm);
				$('form[name=frm] input[name=section]').val(agrs.section);
				$('form[name=frm] input[name=inventory_id]').val(agrs.inventory_id);
				$('form[name=frm] input[name=group_id]').val(agrs.group_id);
		
		});
			
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

//부서 추가
 function addOrgcht(e) {
	$("#trOrg_num").remove();
	$("#trSido").remove();
	$("#trGugun").remove();
	$("#trPseq").remove();
	var shtml = "";
	$(".board_view tbody").append(shtml);
		
		var zTree = $.fn.zTree.getZTreeObj("tree"),
		isParent = e.data.isParent,
		nodes = zTree.getSelectedNodes(),
		treeNode = nodes[0];
		$("#nm").html("부서명");
		$("#org_nm").attr("placeholder","부서명을 입력하세요");
				
		console.log("isParent: "+ isParent);
		console.log(nodes);
		console.log("treeNode: "+ treeNode);
		
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
				console.log($("#inventoty_id").val());
				console.log($("#group_id").val());
			
		} else {
			alert("부서를 선택해 주세요.");
		}
	};
	
	//팀 추가
	 function addOrgcht_s(e) {
		 $("#trSido").remove();
		 $("#trGugun").remove();
		 $("#trOrg_num").remove();
		 $("#trPseq").remove();
		
		var shtml = "";
		$(".board_view tbody").append(shtml);
		
		var zTree = $.fn.zTree.getZTreeObj("tree"),
			isParent = e.data.isParent,
			nodes = zTree.getSelectedNodes(),
			treeNode = nodes[0];
			$("#nm").html("팀명");
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
				alert("상위 부서를 선택해 주세요.");
			}
		};
		
		//부서 삭제 
 function removeOrgcht(e) {
	 	var all_org_nm = $("#all_org_nm").val();
		var zTree = $.fn.zTree.getZTreeObj("tree"),
		nodes = zTree.getSelectedNodes(),
		treeNode = nodes[0];
		
		if (nodes.length == 0) {
			alert("부서를 선택해 주세요");
			return;
		}else{
			if(confirm("하위부서가 있다면 하위부서도 전부 삭제됩니다 삭제하시겠습니까?")){
				
				 $.post("orgManage",{
						 type: 'delt'
						,seq:treeNode.id
						,p_seq:treeNode.pId
						,org_ordr:treeNode.od
						,org_nm:$("#org_nm").val()
						,all_org_nm:$("#all_org_nm").val()
						,domain:treeNode.domain
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
	
	var button = document.getElementById('btnSave');

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
				button.disabled	= true;

    $.ajax({
		url: 'orgManage',							// Any URL
		type: 'post',
		data: $('#frm').serialize(),                 // Serialize the form data
		success: function (data) { 					// If 200 OK
			alert("등록되었습니다.");
			button.disabled	= true;
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
                    <button type="button" class="btn_type3" id="btnAddOrg" name="btnAddOrg">+ 부서추가</button>
                    <button type="button" class="btn_type3" id="btnAddOrg_s" name="btnAddOrg_s">+ 팀추가</button>
                	<button type="button" class="btn_type3" id="btnDelOrg" name="btnDelOrg">- 삭제</button>
                </div>
                
            </div>
        </div>
	
	<!-- 우측 리스트 -->
        <div class="con_right" >
            <div class="right_box" >

                <h3>조직정보</h3>
                <form name="frm" id="frm" method="post" action="orgManage" class="row">
                	<input type="hidden" name="seq" id="seq" value="" />
					<input type="hidden" name="section" id="section" value="" />
					<input type="hidden" name="all_org_nm" id="all_org_nm" value="" />
					<input type="hidden" name="inventory_id" id="inventory_id" value="" />
					<input type="hidden" name="group_id" id="group_id" value="" />
                <div class="board_view mT20" id="org_info">
                    <table>
                        <colgroup>
                            <col style="width:20%;" />
                            <col />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th>상위부서</th>
                                <td><input type="text" name="p_org_nm" id="p_org_nm" class="input_type1 w100" readonly="readonly"/></td>
                            </tr>
                            <tr>
                                <th>순서</th>
                                <td><input type="text" name="org_ordr" id="org_ordr" class="input_type1 w100" readonly="readonly"/></td>
                            </tr>
                            <tr>
                                <th id="nm">팀명</th>
                                <td><input type="text" name="org_nm" id="org_nm" class="input_type1 w100" placeholder="팀명을 적으세요"/></td>
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
	
	
	<%@ include file="../template/footer.jsp" %>
	
	
</body>
</html>