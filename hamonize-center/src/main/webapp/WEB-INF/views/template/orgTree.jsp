<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>



<aside class="aside-lg bg-orgtree  b-r">
	<section class="vbox">
		<section class="scrollable">
			<div class="wrapper">

				<div class="clearfix m-b">
					<div class="clear" style="float:right">
						<small class="text-nav" id="navInfo"><i class="fa fa-map-marker"></i> </small>
					</div>
				</div>


				<div class=" wrapper-sm ">
					<div class="row">
						<div class="btn-group btn-group-justified m-b">
							<a class="btn btn-primary btn-rounded" id="expandAllBtn"><span
									class="text">전체열기</span></a>
							<a class="btn btn-dark btn-rounded" id="collapseAllBtn"><span
									class="text">전체닫기</span></a>
						</div>
						<div class="tree_list">
							<ul id="tree" class="ztree"></ul>
						</div>
					</div>


				</div>
				
					
				<input type="hidden" name="pagegubun" id="pagegubun" value="">
			</div>	
			<div class="panel-body fotter-bg" id="orgTreeBtnLayer">
				<div class="btn-group btn-group-justified ">
					<a href="javascript:;" class="btn btn-default" id="btnAddOrg"><i class="fa fa-plus-circle"></i> 추가</a>
					<a href="javascript:;" class="btn btn-default" id="btnDelOrg"><i class="fa fa-minus-circle"></i> 삭제</a>
<!-- 						<button class="btn btn-default" id="btnAddOrg_s" name="btnAddOrg_s"><i class="fa fa-arrow-right"></i>팀추가</button> -->
				</div>
			</div>
		</section>
	</section>
</aside>



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
			check: {
				enable: false,
				chkboxType: { "Y" : "s", "N" : "ps" }
			},
			callback: {
				// beforeDrag: beforeDrag,
				// beforeDrop: beforeDrop,
				// beforeDragOpen: beforeDragOpen,
				// onDrag: onDrag,
				// onDrop: onDrop,
				// onExpand: onExpand,
				beforeClick: beforeClick,
				onCheck: onCheck, // checkbox click Event
				onClick: onClick
			}
		};
		
	var zNodes =[
		<c:forEach items="${oList}" var="data" varStatus="status" >
		{ id:"${data.seq}", pId:"${data.p_seq}", domain:"${data.domain}",
		inventoryId:"${data.inventory_id}", groupId:"${data.group_id}",
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

		//트리 init
		$.fn.zTree.init($("#tree"), setting, zNodes); 
		var treeObj =  $.fn.zTree.getZTreeObj("tree");
		var sNodes = treeObj.getSelectedNodes();
		console.log(window.location.href.split("/").reverse()[0]);
		if(window.location.href.split("/").reverse()[0] == "orgManage"){
			if (treeObj.getNodes().length < 1) {
				if(confirm("조직정보가 등록되어 있지 않았습니다. 확인버튼을 클릭하여 조직정보를 등록하세요.?")){
						$.ajax({
						url: '/org/orgManage',							// Any URL
						type: 'post',
						data: {type:'save',org_nm:'${domain}',all_org_nm:'',p_org_nm:'',section:''},                 // Serialize the form data
						success: function (data) { 					// If 200 OK
							location.reload();
						},
						error: function (xhr, text, error) {              // If 40x or 50x; errors
							alert("조직 정보가 등록되지 않았습니다. QnA에 문의 주기시 바랍니다.");
							return false;
						}
					});
				}
			}
		}
		//treeObj.checkNode(zNodes, zNodes.checked, true, true);
		//beforeClick($("#tree"),zNodes[0]);
// 		onClick(null,$("#tree"),zNodes[0]);
		onClick(null,$("#tree"),zNodes[0]);
// 		var zTree = $.fn.zTree.getZTreeObj("tree");
// 		treeObj.selectNode(treeObj.getNodeByTId('tree_1'));
		//console.log(zNodes[0]);
		if (sNodes.length > 0) {
			var isOpen = sNodes[2].open;
		}


		$("#expandAllBtn").bind("click", {type:"expandAll"}, expandNode);
		$("#collapseAllBtn").bind("click", {type:"collapseAll"}, expandNode);
		

		// all check
		// var treeObj = $.fn.zTree.getZTreeObj("tree");
		// treeObj.checkAllNodes(false);

		// test 
		// var aa = treeObj.getNodes()[0];
		// treeObj.selectNode(aa);

		// setting.callback.onClick(null, treeObj.setting.treeId, aa, true);
		// console.log( treeObj.setting.treeId);
		// console.log(aa);
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
//ansible 작업상태확인
function checkAnsibleJobStatus(job_id){
	const target = document.getElementById('btnSave');
	console.log("job_id===="+job_id);
	$.ajax({
		url : '/gplcs/checkAnsibleJobStatus',
		type: 'POST',
		async:false,
		data:{job_id:job_id},
		success : function(res) {
			console.log(res);
			if(res.status == "running"){
				console.log("작업중입니다.");
				target.disabled = true;
				setTimeout(checkAnsibleJobStatus,3000,job_id);
				//checkAnsibleJobStatus(job_id);
			}else if(res.status == "wating"){
				console.log("작업 대기중입니다.");
				target.disabled = true;
				setTimeout(checkAnsibleJobStatus,3000,job_id);
				//checkAnsibleJobStatus(job_id);
			}else if(res.status == "pending"){
				console.log("작업 대기중입니다.");
				target.disabled = true;
				setTimeout(checkAnsibleJobStatus,3000,job_id);
				//checkAnsibleJobStatus(job_id);
			}else if(job_id != 0){
				console.log("작업성공여부=="+res.status);
				target.disabled = false;
				//addAnsibleJobEventByHosts(res.inventory,res.limit,job_id);
			}
		},
		error:function(request,status,error){
			console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		}
	});
}

//ansible작업상태등록
function addAnsibleJobEventByHosts(...args){
	const target = document.getElementById('btnSave');
	$.ajax({
		url : '/gplcs/addAnsibleJobEventByHosts',
		type: 'POST',
		async:false,
		data:{inventory_id:args[0],org_seq:args[1],job_id:args[2]},
		success : function(res) {
			console.log("res===="+res);
		},
		error:function(request,status,error){
			console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		}
	});
}

//OS 아이콘
var windowIcon = "<img src='/images/icon_w.png' style='width:22px; height:22px;'>";
var hamonikrIcon = "<img src='/images/icon_h.png' style='width:22px; height:22px;'>";
var gooroomIcon = "<img src='/images/icon_g.png' style='width:22px; height:22px;'>";
var linuxmintIcon = "<img src='/images/icon_lm.png' style='width:22px; height:22px;'>";
var debianIcon = "<img src='/images/icon_d.png' style='width:22px; height:22px;'>";
var ubuntuIcon = "<img src='/images/icon_u.png' style='width:22px; height:22px;'>";
var vpn_used;



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
</script>                

<script>
	var _url = $(location).attr('pathname');
	switch(_url){
		case '/mntrng/pcControlList' :  $("#navInfo").text('Home / 모니터링');  $("#orgTreeBtnLayer").hide(); $("#pagegubun").val('mntrng'); break;
		
		case '/org/orgManage' :  $("#navInfo").text('Home / 조직관리' ); $("#pagegubun").val('org'); break;
		case '/pcMngr/pcMngrList' :  $("#navInfo").text('Home / PC관리' );  $("#orgTreeBtnLayer").hide();  $("#pagegubun").val('mntrnglist');  break;

		case '/gplcs/umanage' :  $("#navInfo").text('Home / 정책관리 / 프로그램 설치 관리' ); $("#orgTreeBtnLayer").hide();   setting.check.enable=false; break;
		case '/gplcs/pmanage' :  $("#navInfo").text('Home / 정책관리 / 프로그램 차단 관리' ); $("#orgTreeBtnLayer").hide(); setting.check.enable=false;    break;
		case '/gplcs/fmanage' :  $("#navInfo").text('Home / 정책관리 / 방화벽관리' ); $("#orgTreeBtnLayer").hide(); setting.check.enable=false;  break;
		case '/gplcs/dmanage' :  $("#navInfo").text('Home / 정책관리 / 디바이스관리' ); $("#orgTreeBtnLayer").hide(); setting.check.enable=false; break;
		case '/auditLog/updateCheckLog' :  $("#navInfo").text('Home / 정책관리 / 정책배포결과' ); $("#orgTreeBtnLayer").hide();  break;
		case '/backupRestore/backupC' :  $("#navInfo").text('Home / 백업관리 / 백업주기설정' ); break;
		case '/backupRestore/backupR' :  $("#navInfo").text('Home / 백업관리 / 복구관리' ); $("#orgTreeBtnLayer").hide(); break;
		
		case '/auditLog/pcUserLog' :  $("#navInfo").text('Home / 로그감사/ 사용자접속로그' );  $("#orgTreeBtnLayer").hide(); break;
		case '/auditLog/prcssBlockLog' :  $("#navInfo").text('Home / 로그감사 / 프로그램차단로그' ); $("#orgTreeBtnLayer").hide(); break;
		case '/auditLog/pcChangeLog' :  $("#navInfo").text('Home / 로그감사 / 하드웨어변경로그' ); $("#orgTreeBtnLayer").hide(); break;
		case '/auditLog/unAuthLog' :  $("#navInfo").text('Home / 로그감사 / 디바이스로그' ); $("#orgTreeBtnLayer").hide(); break;
	}
</script>


