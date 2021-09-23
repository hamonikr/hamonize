<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/css/ztree/zTreeStyle.css" />
<script type="text/javascript" src="/js/ztree/jquery.ztree.core.js"></script>
<script type="text/javascript" src="/js/ztree/jquery.ztree.exedit.js"></script>
<script type="text/javascript" src="/js/ztree/jquery.ztree.excheck.js"></script>
<script type="text/javascript" src="/js/common.js"></script>


<style>
a{
color: white;
}
a:hover{
color: #0056b3;
text-decoration: none; 
}
</style>

<script type="text/javascript">
	var textCutLength = 20;
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
				enable: true,
				showRemoveBtn: false,
				showRenameBtn: false
			},
			callback: {
				beforeClick: beforeClick,
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
		setNav('모니터링');
	//트리 init
	$.fn.zTree.init($("#tree"), setting, zNodes); 
	
	$("#expandAllBtn").bind("click", {type:"expandAll"}, expandNode);
	$("#collapseAllBtn").bind("click", {type:"collapseAll"}, expandNode);
		
	getMntrngList();
	
	
});
	function getMntrngList(){
		var url ='/mntrng/pcList';
		$.post(url,{org_seq:1},
				function(result){
						var agrs = result.pcList;
						var strHtml ="";
						for(var i =0; i< agrs.length;i++){
							var uuid = agrs[i].pc_uuid;
							var hostnameVal = '';
							if( agrs[i].pc_hostname.length >= textCutLength ){
				                hostnameVal = agrs[i].pc_hostname.substr(0,textCutLength)+'...'; 
				           }else{
				        	   hostnameVal = agrs[i].pc_hostname; 
				            }
							if( agrs[i].pc_status == "true"){
								strHtml += '<li class="on"><a href="pcView.do?uuid='+uuid+'" data-toggle="tooltip" title="'+agrs[i].pc_hostname+'">'+hostnameVal+'</a></li>'
							}else{
								strHtml += '<li><div data-toggle="tooltip" data-placement="top" title="'+agrs[i].pc_hostname+'">'+hostnameVal+'</div></li>'	
							}
						}
						$(".monitor_list").append(strHtml);
						$("#total").append("<font class=\"total\">●</font>TOTAL - "+(parseInt(result.on)+parseInt(result.off))+"대");
						$("#on").append("<font class=\"on\">●</font>ON - "+result.on+"대");
						$("#off").append("<font class=\"off\">○</font>OFF - "+result.off+"대");
				});
		
	}
 
 var log, className = "dark", curDragNodes, autoExpandNode;
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
		$('.monitor_list').empty();
		$('#total').empty();
		$('#on').empty();
		$('#off').empty();
		var zTree = $.fn.zTree.getZTreeObj("tree");
		var node = zTree.getNodeByParam('id', treeNode.pId);
		$.post("pcList.do",{org_seq:treeNode.id},
		function(result){
				var agrs = result.pcList;
				var strHtml ="";
				
				if(agrs.length > 0){
					for(var i =0; i< agrs.length;i++){
						var uuid = agrs[i].pc_uuid;
						var hostnameVal = '';
						if( agrs[i].pc_hostname.length >= textCutLength ){
			                hostnameVal = agrs[i].pc_hostname.substr(0,textCutLength)+'...'; 
			           }else{
			        	   hostnameVal = agrs[i].pc_hostname; 
			            }
					 
						if( agrs[i].pc_status == "true"){
							strHtml += '<li class="on"><a href="pcView.do?uuid='+uuid+'" data-toggle="tooltip" title="'+agrs[i].pc_hostname+'">'+hostnameVal+'</a></li>'
						}else{
							strHtml += '<li><div data-toggle="tooltip" data-placement="top" title="'+agrs[i].pc_hostname+'">'+hostnameVal+'</div></li>'	
						}
					}
				}else{
					strHtml += "<div class=\"mr-sm-3\">등록된 pc가 없습니다</div>";
				}
				$(".monitor_list").append(strHtml);
				$("#total").append("<font class=\"total\">●</font>TOTAL - "+(parseInt(result.on)+parseInt(result.off))+"대");
				$("#on").append("<font class=\"on\">●</font>ON - "+result.on+"대");
				$("#off").append("<font class=\"off\">○</font>OFF - "+result.off+"대");

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
 

//등록 처리결과(공통명 : 프로그램명Json )
function fnSave(){
	
	if($("#org_nm").val()==""){
		alert("부대명을 입력해주세요.");
		return false;
	}
	
    $('form[name=frm]').append("<input type='hidden' name='type' value='save' />");        
    $('form[name=frm]').submit();
    alert("정상적으로 저장되었습니다.");
    return false;
}
//]]>
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
                <h2 class="tree_head">모니터링</h2>

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

                <h3>PC 리스트</h3>
                <ul class="veiwcheck">
                	  <li id="total">
                		</li>
                    <li id="on">
                    </li>
                    <li id="off">
                    </li>
                </ul>
				<form name="frm" method="post" action="orgManage.do" class="row">					
					<input type="hidden" name="org_seq"  id="org_seq" value="" />
					<input type="hidden" name="ppm_seq" id="ppm_seq" value="" />
					<input type="hidden" name="section" id="section" value="" />
					<ul class="monitor_list"></ul>
				</form>
            </div>
        </div>


    </div><!-- //content -->
	
	<%@ include file="../template/grid.jsp" %>
	<%@ include file="../template/footer.jsp" %>
	
	
</body>
<script>

$(function(){
	$('[data-toggle="tooltip"]').tooltip({
	html: true,
	trigger: 'hover focus'
	});
});
</script>


</html>