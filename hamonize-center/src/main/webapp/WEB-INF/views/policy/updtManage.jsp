<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>

<link rel="stylesheet" type="text/css" href="/css/ztree/zTreeStyle.css" />
<script type="text/javascript" src="/js/ztree/jquery.ztree.core.js"></script>
<script type="text/javascript" src="/js/ztree/jquery.ztree.exedit.js"></script>
<script type="text/javascript" src="/js/ztree/jquery.ztree.excheck.js"></script>

<script type="text/javascript">
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
				enable: true,
				showRemoveBtn: false,
				showRenameBtn: false
			},
			callback: {
				beforeClick: beforeClick,
				onCheck: onCheck,
				onClick: onClick
			}
		};
	var zNodes =[
		<c:forEach items="${oList}" var="data" varStatus="status" >
		{ id:"${data.seq}", pId:"${data.p_seq}",
			<c:if test="${data.section ne 'S'}">
			name:"${data.org_nm}",
			icon:"/images/icon_tree1.png"
			</c:if>
			<c:if test="${data.section eq 'S'}">
			name:"${data.org_nm}",
			icon:"/images/icon_tree2.png"
			</c:if>
			,od:"${data.org_ordr}"
			<c:if test="${data.level eq '0' or data.level eq '1' or data.level eq '2'}">
			,open:true
			</c:if>},
		</c:forEach>				
	];
	
	$(document).ready(function(){
		setNav('정책관리 > 업데이트관리');
	
	//트리 init
	$.fn.zTree.init($("#tree"), setting, zNodes); 
	
	$("#expandAllBtn").bind("click", {type:"expandAll"}, expandNode);
	$("#collapseAllBtn").bind("click", {type:"collapseAll"}, expandNode);
	
		
	//등록버튼
	$("#btnSave").click(fnSave);
	
	
});

 
	var log, className = "dark", curDragNodes, autoExpandNode;
	
	function setTrigger() {
		var zTree = $.fn.zTree.getZTreeObj("tree");
		zTree.setting.edit.drag.autoExpandTrigger = $("#callbackTrigger").attr("checked");
	}
	function beforeClick(treeId, treeNode,clickFlag) {
		var zTree = $.fn.zTree.getZTreeObj("tree");
		zTree.checkNode(treeNode, !treeNode.checked, true, true);
		return true;
	}
	/* function beforeCheck(treeId, treeNode) {
		className = (className === "dark" ? "":"dark");
		console.log("[  beforeCheck ]&nbsp;&nbsp;&nbsp;&nbsp;" + treeNode.name );
		return (treeNode.doCheck !== false);
	} */

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
		$('input:checkbox[name=pu_seq]').prop("checked", false);
		var zTree = $.fn.zTree.getZTreeObj("tree");
		var node = zTree.getNodeByParam('id', treeNode.pId);
		if(treeNode.checked){
		$.post("ushow.do",{org_seq:treeNode.id},
		function(result){
				var agrs = result;
				var ppm_seq = agrs.dataInfo.ppm_seq;
				ppm_seq = ppm_seq.split(",");
				for(var i=0; i < ppm_seq.length; i++){
				 $('input:checkbox[name=pu_seq]').each(function() {
					 if($(this).val() == ppm_seq[i] ){
						 $(this).prop("checked", true);
					 }
				    });
				}
				$('form[name=frm] input[name=org_seq]').val(agrs.dataInfo.org_seq);
				//$('form[name=frm] input[name=orgLink]').val(agrs.dataInfo.orgLink);
				$('form[name=frm] input[name=pOrgNm]').val(agrs.pOrgNm);
				//$("#orgLank").val(agrs.dataInfo.orgLank);
				
				
			});
		}
	}
function onCheck(event, treeId, treeNode) {
	$('input:checkbox[name=pu_seq]').prop("checked", false);
	var zTree = $.fn.zTree.getZTreeObj("tree");
	var node = zTree.getNodeByParam('id', treeNode.pId);
	if(treeNode.checked){
	$.post("ushow.do",{org_seq:treeNode.id},
	function(result){
			var agrs = result;
			var ppm_seq = agrs.dataInfo.ppm_seq;
			ppm_seq = ppm_seq.split(",");
			for(var i=0; i < ppm_seq.length; i++){
			 $('input:checkbox[name=pu_seq]').each(function() {
				 if($(this).val() == ppm_seq[i] ){
					 $(this).prop("checked", true);
				 }
			    });
			}
			$('form[name=frm] input[name=org_seq]').val(agrs.dataInfo.org_seq);
			//$('form[name=frm] input[name=orgLink]').val(agrs.dataInfo.orgLink);
			$('form[name=frm] input[name=pOrgNm]').val(agrs.pOrgNm);
			//$("#orgLank").val(agrs.dataInfo.orgLank);
			
			
	});
	}
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



//등록 처리결과(공통명 : 프로그램명Json )
function fnSave(){
	var button = document.getElementById('btnSave');

	if(confirm("하위부서 및 부서가 있다면 하위부서 및 부서에도 전부 적용됩니다 적용하시겠습니까?")){
	var ppm_seq = "";
    $('input:checkbox[name=pu_seq]').each(function(i) {
       if($(this).is(':checked'))
    	   ppm_seq += ($(this).val())+",";
    });
    ppm_seq = ppm_seq.substr(0,ppm_seq.length -1);
    
    var zTree = $.fn.zTree.getZTreeObj("tree");
	var nodes = zTree.getCheckedNodes(true);
	var nodeLength=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
	var queryArr=[];
   // alert('선택 노트 갯수 : ' + nodes.length);
    
    $.each(zTree.transformToArray(zTree.getNodes()) && nodes,function(i,v){
    	if(i>=0){
			if(v.children!=null)
			nodeLength[v.level]=0;
			nodeLength[eval(v.level-1)]++;
			 var data={
					 "org_seq": v.id
					//,"name":v.name //확인용도
			} 
			queryArr.push(data);
    	}
	})
	
	button.disabled	= true;

	$.post("usave.do", {dataType:'json',ppm_seq:ppm_seq, data:JSON.stringify(queryArr)}, 
			 function(result){
		if(result=="SUCCESS"){
			alert("정상적으로  처리되었습니다.");
			button.disabled	= false;
			location.reload();
		}
		else{
			alert("실패하였습니다.");
			button.disabled	= false;
		}
			
    }); 

    return false;
	}
}
//]]>
</script>

<body>
	<%@ include file="../template/topMenu.jsp" %>
	
	
	<div class="hamo_container other">
		
		 <!-- 좌측 트리 -->
		<div class="con_left">
	    <div class="left_box">
	        <ul class="location">
	            <li>Home</li>
	            <li>Location</li>
	        </ul>
	        <h2 class="tree_head">업데이트관리</h2>
	
	        <ul class="view_action">
				<li id="expandAllBtn">전체열기 </li>
				<li id="collapseAllBtn">전체닫기</li>
			</ul>

		<!-- 트리 리스트 -->
        <div class="tree_list">
			<ul id="tree" class="ztree"></ul>
        </div>
	    </div>
		</div>
		
		
		<!-- 우측 리스트 -->
		<div class="con_right">
	     <div class="right_box">
	
	         <h3>업데이트 관리 <span>업데이트 프로그램 선택</span></h3>
	         
						<form name="frm" method="post" action="orgManage.do" class="row">
	         			<input type="hidden" name="org_seq"  id="org_seq" value="" />
								<input type="hidden" name="ppm_seq" id="ppm_seq" value="" />
								<input type="hidden" name="section" id="section" value="" />
								
			         <!-- update list -->
			         <ul class="promlist">
         				<c:forEach items="${pList}" var="data" varStatus="status" >
         				
         				<c:if test="${data.pu_name.indexOf('hamonize')!=0}">
			             <li>
			                 <span>
			                 	<input type="checkbox" name="pu_seq" id="${data.pu_seq}" class="check2" value="<c:out value="${data.pu_seq}" />"><label for="${data.pu_seq}"></label><c:out value="${data.pu_name}" />
			                 </span>
			                 
											<c:if test="${data.deb_now_version ne data.deb_new_version and data.deb_now_version ne null}">
											<p>업데이트가 필요합니다. 최신버전은 <c:out value="${data.deb_new_version}" /> 입니다.</p>
											</c:if>
											<c:if test="${data.deb_now_version eq null}">
											<p>신규 프로그램</p>
											</c:if>
			             </li>
			             </c:if>
           			</c:forEach>
			         </ul>
			         <!-- //update list -->
			         <div class="right mT20">
			             <button type="reset" class="btn_type2" id="btnInit"> 초기화</button>
			             <button type="button" class="btn_type2" id="btnSave"> 저장</button>
			         </div>
						</form>
	     </div>
	 </div>
	 
	</div>
	
	
	
	<%-- 
	<section class="body haveGroup">
		<article>
			<div class="code-html contents row">
				
				<div class="col-md-3 row">
					<div class="form-style-10 col-md-12 boxDiv">
						<div class="inner-wrap row" style="padding:0; background: rgba(0,0,0,0)">
							<div class="section"><span class="numTxt">1</span>그룹선택</div>
								
								<!-- search -->
								
								<div class="tree_area" style="display: inline-block;">
									<div class="tree_ctrl">
										<button type="button" class="btn bg-success btn-md" id="expandAllBtn" style="float: left;">
											<i class="fa fa-check" aria-hidden="true"></i>
											전체열기
										</button>
										&nbsp;
										<button type="button" class="btn btn-md bg-dark" id="collapseAllBtn">
											<i class="fa fa-check" aria-hidden="true"></i>
											전체닫기
										</button>
									</div>
									<div class="scroll_area">
										<ul id="tree" class="ztree"></ul>
									</div>
								</div>
								<div class="input_area" style="display: inline-block;">
						
							</div>
						</div>
					</div>
				</div>
			
				<div class="col-md-9">
					<div class="form-style-10 boxDiv">
						<div class="section"><span class="numTxt">2</span>업데이트 프로그램 선택</div>
						
						<div class="input_area" style="display: inline-block; width: 100%;">
			
							<form name="frm" method="post" action="orgManage.do" class="row">					
								<input type="hidden" name="org_seq"  id="org_seq" value="" />
								<input type="hidden" name="ppm_seq" id="ppm_seq" value="" />
								<input type="hidden" name="section" id="section" value="" />
								
								<div class="inner-wrap row">
								
									<c:forEach items="${pList}" var="data" varStatus="status" >
	
										<div class="col-md-4">
											<div class="card bg-light mb-3" style="width: 100%">
												
												<div class="card-header">
													<div class="form-check">
														<label class="form-check-label">
															
															<input type="checkbox" name="pu_seq" value="<c:out value="${data.pu_seq}" />">
															<span class="form-check-sign"><c:out value="${data.pu_name}" />-<c:out value="${data.deb_now_version}" /></span>
															
														</label>
													</div>
												</div>
												
												<div class="card-body">
													<p class="card-text">
													<c:if test="${data.deb_now_version ne data.deb_new_version and data.deb_now_version ne ''}">
													업데이트가 필요합니다. 최신버전은 <c:out value="${data.deb_new_version}" /> 입니다.
													</c:if>
													<c:if test="${data.deb_now_version eq ''}">
													신규 프로그램
													</c:if>
													</p> 
												</div>
												
											</div>
										</div>
									</c:forEach>
								
								</div>
								
								<div class="col-md-12 row btn_area">
									<div class="col-md-2">
										<button type="reset" class="btn nav"  id="btnInit" style="float: left;">
											<i class="fa fa-check" aria-hidden="true"></i>
											초기화
										</button>
									</div>
									<div class="col-md-2">
										<button type="button" class="btn act" id="btnSave">
											<i class="fa fa-check" aria-hidden="true"></i>
											변경저장
										</button>
									</div>		
								</div>
							</form>
						</div>
					
					</div>
				</div>
			</div>
		</article>
	</section>
		 --%>
	
	
	<%@ include file="../template/footer.jsp" %>
	
</body>
</html>