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
		setNav('정책관리 > 프로그램관리');

		if($("#org_seq").val()==""){
			$("#org_seq").val("1");
		}
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
	$('input:checkbox[name=pcm_seq]').prop("checked", false);
		var zTree = $.fn.zTree.getZTreeObj("tree");
		var node = zTree.getNodeByParam('id', treeNode.pId);
		if(treeNode.checked){
		$.post("pshow.do",{org_seq:treeNode.id},
		function(result){
			var agrs = result;
			
				var html = "";
				for(var y=0; y < agrs.pList.length; y++){
					html += "<li>";
					html += "<span>";
					html += "<input type=\"checkbox\" name=\"pcm_seq\" id=\""+agrs.pList[y].pcm_seq+"\" class=\"check2\" value=\""+agrs.pList[y].pcm_seq+"\">";
					html += "<label for=\""+agrs.pList[y].pcm_seq+"\"></label>";
					html += agrs.pList[y].pcm_name;
					html += "</span>";
					html += "<p class=\"card-text\"></p>";
					html += "</li>";
				}
				$(".promlist").html();
				$(".promlist").html(html);
				console.log(agrs.dataInfo);
				if(agrs.dataInfo != null){
				var ppm_seq = agrs.dataInfo.ppm_seq;
				ppm_seq = ppm_seq.split(",");
				for(var i=0; i < ppm_seq.length; i++){
				 $('input:checkbox[name=pcm_seq]').each(function() {
					 if($(this).val() == ppm_seq[i] ){
						 $(this).prop("checked", true);
					 }
				    });
				}

				$('form[name=frm] input[name=org_seq]').val(agrs.dataInfo.org_seq);
				$('form[name=frm] input[name=pOrgNm]').val(agrs.pOrgNm);
			}
			});
		}	
	}
function onCheck(event, treeId, treeNode) {
	$('input:checkbox[name=pcm_seq]').prop("checked", false);
	var zTree = $.fn.zTree.getZTreeObj("tree");
	var node = zTree.getNodeByParam('id', treeNode.pId);
	if(treeNode.checked){
	$.post("pshow.do",{org_seq:treeNode.id},
	function(result){
		var agrs = result;
			var html = "";
			for(var y=0; y < agrs.pList.length; y++){
				html += "<li>";
				html += "<span>";
				html += "<input type=\"checkbox\" name=\"pcm_seq\" id=\""+agrs.pList[y].pcm_seq+"\" class=\"check2\" value=\""+agrs.pList[y].pcm_seq+"\">";
				html += "<label for=\""+agrs.pList[y].pcm_seq+"\"></label>";
				html += agrs.pList[y].pcm_name;
				html += "</span>";
				html += "<p class=\"card-text\"></p>";
				html += "</li>";
			}
			$(".promlist").html();
			$(".promlist").html(html);
			if(agrs.dataInfo != null){
				var ppm_seq = agrs.dataInfo.ppm_seq;
			ppm_seq = ppm_seq.split(",");
			for(var i=0; i < ppm_seq.length; i++){
			 $('input:checkbox[name=pcm_seq]').each(function() {
				 if($(this).val() == ppm_seq[i] ){
					 $(this).prop("checked", true);
				 }
			    });
			}
			
			$('form[name=frm] input[name=org_seq]').val(agrs.dataInfo.org_seq);
			$('form[name=frm] input[name=pOrgNm]').val(agrs.pOrgNm);
		}
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

	if(confirm("하위부서가 있다면 하위부서들에도 전부 적용됩니다 적용하시겠습니까?")){
	var ppm_seq = "";
    $('input:checkbox[name=pcm_seq]').each(function(i) {
       if($(this).is(':checked'))
    	   ppm_seq += ($(this).val())+",";
    });
    ppm_seq = ppm_seq.substr(0,ppm_seq.length -1);
    
    var zTree = $.fn.zTree.getZTreeObj("tree");
	var nodes = zTree.getCheckedNodes(true);
	var nodeLength=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
	var queryArr=[];
    
    $.each(zTree.transformToArray(zTree.getNodes()) && nodes,function(i,v){
    	if(i>=0){
			if(v.children!=null)
			nodeLength[v.level]=0;
			nodeLength[eval(v.level-1)]++;
			 var data={
					 "org_seq": v.id
			} 
			queryArr.push(data);
    	}
	})
	
	button.disabled	= true;

	$.post("psave.do", {dataType:'json',ppm_seq:ppm_seq, data:JSON.stringify(queryArr)}, 
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
	        <h2 class="tree_head">프로그램관리</h2>
	
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
	
	         <h3>프로그램 관리 <span>차단 프로그램 선택</span></h3>
	         
						<form name="frm" method="post" action="orgManage.do" class="row">
	         			<input type="hidden" name="org_seq"  id="org_seq" value="" />
								<input type="hidden" name="ppm_seq" id="ppm_seq" value="" />
								<input type="hidden" name="section" id="section" value="" />
								
			         <!-- update list -->
			         <ul class="promlist">
	        				<c:forEach items="${pList}" var="data" varStatus="status" >
			             <li>
			                 <span>
			                 	<input type="checkbox" name="pcm_seq" id="${data.pcm_seq}" class="check2" value="<c:out value="${data.pcm_seq}" />">
			                 	<label for="${data.pcm_seq}"></label>
			                 	<c:out value="${data.pcm_name}" />
			                 </span>
			                 
											<p class="card-text"><c:out value="${data.pcm_dc}" /></p>
			             </li>
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
	
	<%@ include file="../template/footer.jsp" %>
	
	
</body>
</html>
