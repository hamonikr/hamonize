<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/css/ztree/zTreeStyle.css" />
<script type="text/javascript" src="/js/ztree/jquery.ztree.core.js"></script>
<script type="text/javascript" src="/js/ztree/jquery.ztree.exedit.js"></script>
<script type="text/javascript" src="/js/ztree/jquery.ztree.excheck.js"></script>
<script type="text/javascript">
//<![CDATA[
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
			 check: {
				enable: true,
				chkboxType: { "Y" : "s", "N" : "ps" }
			},
			edit: {
				drag: {
					/* autoExpandTrigger: true,
					prev: dropPrev,
					inner: dropInner,
					next: dropNext */
				}, 
				enable: true,
				showRemoveBtn: false,
				showRenameBtn: false
			},
			callback: {
				/* beforeDrag: beforeDrag,
				beforeDrop: beforeDrop,
				beforeDragOpen: beforeDragOpen,
				onDrag: onDrag,
				onDrop: onDrop,
				onExpand: onExpand,
				beforeClick: beforeClick,
				onClick: onClick */
			}
		};
	var zNodes =[
		{ id:0, pId:"", name:"부대관리", open:true},
		<c:forEach items="${oList}" var="data" varStatus="status" >
		{ id:"${data.seq}", pId:"${data.p_seq}",
			<c:if test="${data.section ne 'S'}">
			name:"${data.org_nm}"
				</c:if>
			<c:if test="${data.section eq 'S'}">
			name:"${data.org_nm}"
				</c:if>
			,od:"${data.org_ordr}"
			,open:true},
		</c:forEach>				
	];
	
	$(document).ready(function(){
	//트리 init
	$.fn.zTree.init($("#tree"), setting, zNodes); 
	
	$("#expandAllBtn").bind("click", {type:"expandAll"}, expandNode);
	$("#collapseAllBtn").bind("click", {type:"collapseAll"}, expandNode);
	$("#btnAddOrg").bind("click", {isParent:false}, addOrgcht);
	$("#btnAddOrg_s").bind("click", {isParent:false}, addOrgcht_s);
	$("#btnDelOrg").bind("click", removeOrgcht);
	$("#callbackTrigger").bind("change", {}, setTrigger);
		
	//등록버튼
	$("#btnSave").click(fnSave);
	
	//순서 변경저장
    $("#btnChange").click(fnChange);	
	
});

 $(document).on("click", ':button',  function() {
	
	var buttonName = this.name; 
	
	//부서추가
	/* if(buttonName.indexOf('btnAddOrg') != -1) {
		addOrgcht();
	} */
	//부서삭제
	/* if(buttonName.indexOf('btnDelOrg') != -1) {
		removeOrgcht();
	} */
	
	//담당업무 추가
	if(buttonName.indexOf('btnAddChrg') != -1) {		
		addRowChrgjob(); //담당업무 추가
	}
	
	//담당업무 삭제
	if(buttonName.indexOf("btnDelChrg") != -1) {
		var idx = $(this).index("button[name='"+buttonName+"'");
		var jobSeq = $("input[name=jobSeq]:eq("+idx+")").val()
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
		$.post("orgManage.do",{type:'show',seq:treeNode.id},
		function(result){
				var agrs = result;
				console.log(agrs);
				//조직도 관리
				/* if(agrs.dataInfo.orgLinkYn=='Y')
				$('#orgLinky').prop('checked',true);
				else
				$('#orgLinkn').prop('checked',true);
				if(agrs.dataInfo.openYn=='Y')
					$('#openy').prop('checked',true);
				else
					$('#openn').prop('checked',true); */
					
				$('form[name=frm] input[name=pOrgNm]').val('');
				$('form[name=frm] input[name=seq]').val(agrs.seq);
				$('form[name=frm] input[name=p_seq]').val(agrs.p_seq);
				$('form[name=frm] input[name=org_ordr]').val(agrs.org_ordr);
				$('form[name=frm] input[name=org_nm]').val(treeNode.name);
				//$('form[name=frm] input[name=orgLinkYn]').val(agrs.dataInfo.orgLinkYn);
				//$('form[name=frm] input[name=orgLink]').val(agrs.dataInfo.orgLink);
				$('form[name=frm] input[name=pOrgNm]').val(agrs.pOrgNm);
				//$("#orgLank").val(agrs.dataInfo.orgLank);
				
				//담당업무 & 연락처 관리
				/* $("#chrgjobTbody tr").remove();
				var strHtml = "";
				var tableObj = $("#chrgjobTbody");
				if(agrs.showChrgjob != null){
				for(var i = 0; i <agrs.showChrgjob.length;i++ ){
					console.log(agrs.showChrgjob[i].chrgjobNm);
					strHtml += "<tr>";
					strHtml += "	<td><input type=\"text\" name=\"chrgjobNm\" id=\"chrgjobNm\" value='"+agrs.showChrgjob[i].chrgjobNm+"' style=\"width:100%;\" /></td>";
					strHtml += "	<td><input type=\"text\" name=\"telNo\" id=\"telNo\" value='"+agrs.showChrgjob[i].telNo+"' style=\"width:100%;\" /></td>";
					strHtml += "	<td><input type=\"text\" name=\"faxNo\" id=\"faxNo\" value='"+agrs.showChrgjob[i].faxNo+"' style=\"width:100%;\" /></td>";
					strHtml += "	<td><input type=\"text\" name=\"jobOrdr\" id=\"jobOrdr\" value='"+agrs.showChrgjob[i].jobOrdr+"' style=\"width:100%;\" /></td>";
					strHtml += "	<td><button type=\"button\" class=\"btn inline\" name=\"btnDelChrg\">- 삭제</button></td>";
					strHtml += "<input type=\"hidden\" name=\"jobSeq\" id=\"jobSeq\" value="+agrs.showChrgjob[i].seq+" style=\"width:100%;\" />";
					strHtml += "</tr>";
				}
				$(tableObj).append(strHtml);
				$("input[name='jobSeq']").each(function(i,v){
			    	console.log($(this).val());
			    });
				} */  /* else{
					strHtml += "<tr>";
					strHtml += "	<td><input type=\"text\" name=\"chrgjobNm\" id=\"chrgjobNm\" value=\"\" style=\"width:100%;\" /></td>";
					strHtml += "	<td><input type=\"text\" name=\"telNo\" id=\"telNo\" value=\"\" style=\"width:100%;\" /></td>";
					strHtml += "	<td><input type=\"text\" name=\"faxNo\" id=\"faxNo\" value=\"\" style=\"width:100%;\" /></td>";
					strHtml += "	<td><button type=\"button\" class=\"btn inline\" name=\"btnDelChrg\">- 삭제</button></td>";
					strHtml += "<input type=\"hidden\" name=\"jobSeq\" id=\"jobSeq\" value=\"\" style=\"width:100%;\" />";
					strHtml += "</tr>";
					$(tableObj).append(strHtml);
				} */  
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
		var zTree = $.fn.zTree.getZTreeObj("tree"),
		isParent = e.data.isParent,
		nodes = zTree.getSelectedNodes(),
		treeNode = nodes[0];
		$("#nm").html("부대명");
		if (treeNode) {
			$('form[name=frm] input[name=type]').val('save');
			$('form[name=frm] input[name=pOrgNm]').val('');
			$('form[name=frm] input[name=org_nm]').val('');
			$('form[name=frm] input[name=p_seq]').val('');
			$('form[name=frm] input[name=seq]').val('');
			//$('form[name=frm] input[name=orgLinkYn]').prop('checked',false);
			//$('form[name=frm] input[name=orgLink]').val('');
			//$('form[name=frm] input[name=orgLank]').val('');
			//$('form[name=frm] input[name=openyn]').prop('checked',false);
			//$("#chrgjobTbody").find("tr").detach()
			if(treeNode.children==null)
				$('form[name=frm] input[name=org_ordr]').val(1);
			else		
				$('form[name=frm] input[name=org_ordr]').val(treeNode.children.length+1);
				
				$('form[name=frm] input[name=pOrgNm]').val(treeNode.name);
				$('form[name=frm] input[name=p_seq]').val(treeNode.id);
				$('form[name=frm] input[name=org_nm]').focus();
				
				
			
		} else {
			alert("부대를 선택해 주세요.");
		}
	};
	
	//사지방 추가
	 function addOrgcht_s(e) {
			var zTree = $.fn.zTree.getZTreeObj("tree"),
			isParent = e.data.isParent,
			nodes = zTree.getSelectedNodes(),
			treeNode = nodes[0];
			$("#nm").html("사지방명");
			if (treeNode) {
				$('form[name=frm] input[name=type]').val('save');
				$('form[name=frm] input[name=section]').val('S');
				$('form[name=frm] input[name=pOrgNm]').val('');
				$('form[name=frm] input[name=org_nm]').val('');
				$('form[name=frm] input[name=p_seq]').val('');
				$('form[name=frm] input[name=seq]').val('');
				//$('form[name=frm] input[name=orgLinkYn]').prop('checked',false);
				//$('form[name=frm] input[name=orgLink]').val('');
				//$('form[name=frm] input[name=orgLank]').val('');
				//$('form[name=frm] input[name=openyn]').prop('checked',false);
				//$("#chrgjobTbody").find("tr").detach()
				if(treeNode.children==null)
					$('form[name=frm] input[name=org_ordr]').val(1);
				else		
					$('form[name=frm] input[name=org_ordr]').val(treeNode.children.length+1);
					
					$('form[name=frm] input[name=pOrgNm]').val(treeNode.name);
					$('form[name=frm] input[name=p_seq]').val(treeNode.id);
					$('form[name=frm] input[name=org_nm]').focus();

				
			} else {
				alert("부대를 선택해 주세요.");
			}
		};


//부서 삭제 
 function removeOrgcht(e) {
		var zTree = $.fn.zTree.getZTreeObj("tree"),
		nodes = zTree.getSelectedNodes(),
		treeNode = nodes[0];
		
		if (nodes.length == 0) {
			alert("메뉴를 선택해 주세요");
			return;
		}else{
			if(confirm("하위메뉴가 있다면 하위메뉴도 전부 삭제됩니다 삭제하시겠습니까?")){
				
				 $.post("orgManage.do",{
						 type: 'delt'
						,seq:treeNode.id
						,pSeq:treeNode.pId
						,orgOrdr:treeNode.od
					},
					function(result){
						if(result > 0)
							alert("정상적으로 삭제되었습니다.");
						else
							alert("삭제가 실패되었습니다.");
						var callbackFlag = $("#callbackTrigger").attr("checked");
						zTree.removeNode(treeNode, callbackFlag);
						//location.reload();
				    }); 
			}
		}
	};

	//순서변경
	function fnChange(){
		var zTree = $.fn.zTree.getZTreeObj("tree");
		var nodeLength=[0,0,0,0,0,0,0,0,0,0];
		var queryArr=[];
		
		$.each(zTree.transformToArray(zTree.getNodes()),function(i,v){
			if(i>0){
				if(v.children!=null)
				nodeLength[v.level]=0;
				nodeLength[eval(v.level-1)]++;
				var data={
						"seq":v.id,
						"pSeq":v.pId,
						"orgOrdr":nodeLength[eval(v.level-1)]
				}
				queryArr.push(data);
			}
		})
		$.post("orgchtJson.do", {dataType:'json',type: 'change',data:JSON.stringify(queryArr)}, function(result){
			if(result=="SUCCESS")
				alert("정상적으로 순서 변경되었습니다.");
			else
				alert("순서변경이 실패되었습니다.");
	    });
		
	}
	
//담당업무 추가
var addRowChrgjob = function() {
	
	var strHtml = "";
	var tableObj = $("#chrgjobTbody");
	
	strHtml += "<tr>";
	strHtml += "	<td><input type=\"text\" name=\"org_nm\" id=\"chrgjobNm\" value=\"\" style=\"width:100%;\" /></td>";
	strHtml += "	<td><input type=\"hidden\" name=\"section\" id=\"section\" value=\"S\" style=\"width:100%;\" /></td>";
	//strHtml += "	<td><input type=\"text\" name=\"faxNo\" id=\"faxNo\" value=\"\" style=\"width:100%;\" /></td>";
	//strHtml += "	<td><input type=\"text\" name=\"jobOrdr\" id=\"jobOrdr\" value=\"\" style=\"width:100%;\" /></td>";
	strHtml += "	<td><button type=\"button\" class=\"btn inline\" name=\"btnDelChrg\">- 삭제</button></td>";
	//strHtml += "<input type=\"hidden\" name=\"jobSeq\" id=\"jobSeq\" value=\"\" style=\"width:100%;\" />";
	strHtml += "</tr>";
	
	$(tableObj).append(strHtml);
}
 

//담당업무 삭제
var removeRowChrgjob = function(rowIdx,jobSeq) {
	var tableObj = $("#chrgjobTbody").find("tr");	
	//$(tableObj).eq(rowIdx).detach();  //목록 삭제
	if(jobSeq != ""){
	if(confirm("담당업무를 삭제 하시겠습니까?")){
	$.post("orgchtJson.do",{
		 type: 'wdelt'
		,jobSeq:jobSeq
	},function(result){
	if(result==1){
		$(tableObj).eq(rowIdx).detach();	//목록 삭제
		alert("처리되었습니다.");
	}else
		alert("실패되었습니다.");
});
	}
	}else{
	$(tableObj).eq(rowIdx).detach();	//목록 삭제
	}
}

//부서링크 라디오 체크여부
$(document).on('click','#orgLinkn',function(){
	$('form[name=frm] input[name=orgLink]').prop('disabled',true);
}).on('click','#orgLinky',function(){
	$('form[name=frm] input[name=orgLink]').prop('disabled',false);
});

//등록 처리결과(공통명 : 프로그램명Json )
function fnSave(){
	
	if($("#org_nm").val()==""){
		alert("부대명을 입력해주세요.");
		return false;
	}
	
	//var value = new MiyaValidator(document.forms["frm"]);
		
	//value.add("orgOrdr" , {required: true ,message: "부서순서를 입력하세요"});
	//value.add("orgNm"    , {required: true ,message: "부대명을 입력하세요"});
	//value.add("orgLinkYn", {required: true ,message: "부서링크를 선택해주세요"});
	
	/*  if($("input[name='orgLinkYn']:checked").val() == 'Y' && $("#orgLink").val() == '') {
		value.add("orgLink", {required: true ,message: "부서링크를 입력하세요"});	
	} */ 
	
	//value.add("link"     , {required: true, option:"engonly", message: "영문으로만 입력하셔야 합니다"});
	//var msg = "등록하시겠습니끼?";
    //if(!confirm(msg)){return;}
    /* $("input[name='jobSeq']").each(function(v,k){
    	console.log( v+" : "+k);
    });*/
    /* $("#orgchtSeq").val($("#seq").val());
    if($("#chrgjobNm").val()!=null){
    	$("#chrgjob").val("y");
    } */
    $('form[name=frm]').append("<input type='hidden' name='type' value='save' />");        
    $('form[name=frm]').submit();
    alert("정상적으로 저장되었습니다.");
	/* var result = value.validate();
    if (!result) {
        //alert(value.getErrorMessage()); //디폴트 label 메세지
        //alert(value.getErrorMessage("{message}")); //동적 메세지
        value.getErrorElement().focus();
        return false;
    }else {		 
    	
        $('form[name=frm]').append("<input type='hidden' name='type' value='save' />");        
        $('form[name=frm]').submit(); 
    } */
    return false;
}
//]]>
</script>

<body>
	<%@ include file="../template/topMenu.jsp" %>
	<%@ include file="../template/topNav.jsp" %>
	
	<!-- content body -->
	<div class="mng_menu org" style="width: 100%; text-align: center;">
		<div class="tree_area" style="display: inline-block;">
			<div class="tree_ctrl">
				<button type="button" class="btn inline nav" id="expandAllBtn" style="float: left;">+ 전체열기</button>
				<button type="button" class="btn inline nav" id="collapseAllBtn">- 전체닫기</button>
			</div>
			<div class="scroll_area">
				<ul id="tree" class="ztree"></ul>
			</div>
			<!-- <div class="menu_ctrl">
				<button type="button" class="btn act" id="btnAddOrg" name="btnAddOrg">+ 부대추가</button>
				<button type="button" class="btn" id="btnDelOrg" name="btnDelOrg">- 부대삭제</button>
				<button type="button" class="btn act" id="btnAddOrg_s" name="btnAddOrg_s">+ 사지방추가</button>
				<button type="button" class="btn act" id="btnChange" name="btnChange">순서변경</button>
			</div> -->
		</div>
		<div class="input_area" style="display: inline-block;">
		
		<form name="frm" method="post" action="orgManage.do" >					
			<input type="hidden" name="seq"  id="seq" value="" />
			<input type="hidden" name="p_seq" id="p_seq" value="" />
			<input type="hidden" name="section" id="section" value="" />
			
			<c:forEach items="${pList}" var="data" varStatus="status" >
			<input type="checkbox" name="pcm_seq" value="<c:out value="${data.pcm_seq}" />">
			<c:out value="${data.pcm_name}" /><c:out value="${data.pcm_dc}" /></input>
			</c:forEach>
			<!-- <input type="hidden" name="orgchtSeq"  id="orgchtSeq" value="" />
			<input type="hidden" name="chrgjob"  id="chrgjob" value="" /> -->	
			
			<!-- <table class="tb_write">
			<caption>설정</caption>
			<colgroup>
				<col style="width:125px" />
				<col />
			</colgroup>
			<tbody>
			<tr>
				<th>상위부대</th>
				<td>
					<input type="text" name="pOrgNm" id="pOrgNm" value="" readonly="readonly"/>
				</td>
			</tr>			
			<tr>
				<th>부대순서</th>
				<td><input type="text" name="org_ordr" id="org_ordr" value="" readonly="readonly"/></td>
			</tr>
			<tr>
				<th id="nm">부대명</th>
				<td><input type="text" name="org_nm" id="org_nm" value=""  style="width:100%;" /></td>
			</tr>
			</tbody>
			</table> -->

			<!-- <table class="tb_write mt25">
			<caption class="tit1">사지방 추가<button type="button" class="btn fr"  name="btnAddChrg">+ 항목추가</button></caption>
			<colgroup>
				<col />
				<col style="width:130px" />
				<col style="width:130px" />
				<col style="width:50px" />
				<col style="width:70px" />
			</colgroup>
			<thead>
			<tr>
				<th>사지방명</th>
				<th>연락처</th>
				<th>팩스</th>
				<th>순서</th>
				<th>관리</th>
			</tr>
			</thead>
			<tbody id="chrgjobTbody">
			 <tr>
				<td><input type="text" name="chrgjobNm" id="chrgjobNm" value="" style="width:100%;" /></td>
				<td><input type="text" name="telNo" id="telNo" value="" style="width:100%;" /></td>
				<td><input type="text" name="faxNo" id="faxNo" value="" style="width:100%;" /></td>
				<td><button type="button" class="btn inline" name="btnDelChrg">- 삭제</button></td>
			</tr>
			</tbody>
			</table> -->
			
			<div class="btn_area">
				<button type="reset" class="btn nav"  id="btnInit" style="float: left;">초기화</button>
				<button type="button" class="btn act" id="btnSave">변경저장</button>		
			</div>
		</form>
		</div>
	</div>
	
	<p id="data"></p>
	
	
	<%@ include file="../template/footer.jsp" %>
	
	
</body>
</html>