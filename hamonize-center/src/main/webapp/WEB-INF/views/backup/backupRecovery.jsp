<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>

<link rel="stylesheet" type="text/css" href="/css/ztree/zTreeStyle.css" />
<link href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
<link href='http://fonts.googleapis.com/css?family=Bitter' rel='stylesheet' type='text/css'>

<script type="text/javascript" src="/js/ztree/jquery.ztree.core.js"></script>
<script type="text/javascript" src="/js/ztree/jquery.ztree.exedit.js"></script>
<script type="text/javascript" src="/js/ztree/jquery.ztree.excheck.js"></script>

<style type="text/css">
.some-class {
  /* float: left; */
  clear: none;
}

label {
  float: left;
  clear: none;
  display: block;
  padding: 2px 1em 0 0;
}

input[type=radio],
input.radio {
  float: left;
  clear: none;
  margin: 6px 7px 6px 2px;
}
#pc_list , #rc_list { width: 100% }
</style>

<style>
div.radio-holder {
  /* padding: 10px; */
}
input[type="radio"] {
 &:checked+label {
  border-bottom: 2px solid #222222;
  padding-bottom: 0px;
 }
}
</style>

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
			name:"[B]"+"${data.org_nm}",
			icon:"/images/icon_tree2.png"
			</c:if>
			,od:"${data.org_ordr}"
			<c:if test="${data.level eq '0' or data.level eq '1' or data.level eq '2'}">
			,open:true
			</c:if>},
		</c:forEach>				
	];
	
	$(document).ready(function(){
		setNav('백업관리 > 복구관리');
		
	//트리 init
	$.fn.zTree.init($("#tree"), setting, zNodes); 
	
	$("#expandAllBtn").bind("click", {type:"expandAll"}, expandNode);
	$("#collapseAllBtn").bind("click", {type:"collapseAll"}, expandNode);
		
	//등록버튼
	$("#btnSave").click(fnSave);
	
	
		  
		
  	 //라디오 이벤트 - PC 목록 클릭시
	 $("#pc_list").on("click", "label", function(){
		 $(this).prev().prop( "checked", true );
		 $("#rc_list").empty();
		 
		 var seq = $("input:radio[name='dept_seq']:checked").val();
		 
		 $.post("backupRCList.do",{seq:seq},
					function(result){
							var agrs = result;
							var strHtml = "";
					
							for(var i = 0; i < agrs.length; i++){
								console.log(i+"bbb==dept_seq="+agrs[i].dept_seq);
							
								strHtml += "<input type=\"radio\" name=\"br_seq\" id=\"br_seq"+i+"\" value='"+agrs[i].br_seq+"'/>";
								strHtml += "<label for=\"br_seq"+i+"\" class=\"pR50\">";
								
								if(agrs[i].br_backup_gubun == 'A')
								strHtml += "초기백업본 ";
								else if(agrs[i].br_backup_gubun == 'B')
								strHtml += "일반백업본 ";
								
								strHtml += "" + agrs[i].br_backup_name + "";
								strHtml += "</label>"
								
							} 
							$("#rc_list").append(strHtml);
							
							if(agrs[0] != undefined || agrs[0] != null){
								$('form[name=frm] input[name=org_seq]').val(agrs[0].br_org_seq);
							}							
							
					});
		}); 
  	
  	
		//라디오 이벤트 - 백업목록 클릭시
		$("#rc_list").on("click", "label", function(){
			$(this).children('input').prop('checked', true);
		});

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
		$("#pc_list").empty();
		$("#rc_list").empty();
		var zTree = $.fn.zTree.getZTreeObj("tree");
		var node = zTree.getNodeByParam('id', treeNode.pId);
		$.post("backupRCShow.do",{org_seq:treeNode.id},
				function(result){
						var agrs = result;
						var strHtml = "";
						var tmp = "";
						strHtml = " <div class=\"some-class\">";
						for(var i = 0; i < agrs.length; i++){
							console.log(agrs[i]);
							if( i == 0 ){ tmp = "checked"; }
						
							strHtml += "";							
							strHtml += "<div class=\"radio-holder\">";
							strHtml += " <input id='dept_seq"+i+"' name='dept_seq' type='radio' value='"+agrs[i].seq+"'>";
							strHtml += "<label for='dept_seq"+i+"'>" +agrs[i].pc_hostname+ "</label>";
							strHtml += "</div>";
						  
						
						}
						strHtml += "</div>";
						$("#pc_list").append(strHtml);
						
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
	
	var button = document.getElementById('btnSave');

	var dept_seq = $('input[name="dept_seq"]:checked').val();
	var br_seq = $('input[name="br_seq"]:checked').val();
	var org_seq = $("#org_seq").val();
	
	console.log("dept_seq===="+$('input[name="dept_seq"]:checked').val());
	console.log("br_seq===="+$('input[name="br_seq"]:checked').val());
	console.log("org_seq===="+$("#org_seq").val());
	
	if(dept_seq == null){
		alert("pc를 선택해주세요.");
		return false;
	}
	if(br_seq == null){
		alert("백업본을 선택해주세요.");
		return false;
	}

	$('form[name=frm] input[name=dept_seq]').val(dept_seq);
	$('form[name=frm] input[name=br_seq]').val(br_seq);
	$('form[name=frm] input[name=org_seq]').val(org_seq);

	button.disabled	= true;

	$.post("backupRCSave.do", {dataType:'json',dept_seq:dept_seq,
		br_seq:br_seq,org_seq:org_seq}, 
			function(result){
				if(result=="SUCCESS"){

					alert("정상적으로 처리되었습니다.");
					button.disabled	= false;

					location.reload();
				} else{
					alert("실패하였습니다.");
				}
    });   
    return false;
}
//]]>
</script>

<body>
	<%@ include file="../template/topMenu.jsp" %>
	<%@ include file="../template/topNav.jsp" %>
	<div class="hamo_container other">

            <!-- 좌측 트리 -->
    <div class="con_left">
        <div class="left_box">
            <ul class="location">
            </ul>
            <h2 class="tree_head">백업관리</h2>
			
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
        <div class="con_right" >
            <div class="right_box" >

                <h3>복구관리</h3>
                 <div class="board_view mT20">
                <form name="frm" method="post" action="backupRCSave.do" class="row">
								<input type="hidden" name="org_seq"  id="org_seq" value="" />
								<input type="hidden" name="br_seq"  id="br_seq" value="" />
								<input type="hidden" name="dept_seq"  id="dept_seq" value="" />

                <table>
                    <colgroup>
                        <col style="width:15%;" />
                        <col />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th rowspan="3">PC 목록<br />(HostName)</th>
                            <td id="pc_list" class="relist">부서를 선택해 주세요.</td>
                            
                        </tr>
                        <tr>
                            <td id="rc_list" class="relist">부서를 선택해 주세요.</td>
                        </tr>
                    </tbody>
                </table>
                    </form>
                </div><!-- //List -->
                <div class="t_center mT20">
                    <button type="button" class="btn_type2" id="btnSave">저장</button>
                </div>
            </div>
        </div>
      </div>
	
	<form>
</form>

	<%@ include file="../template/grid.jsp" %>
	<%@ include file="../template/footer.jsp" %>
	
	
</body>
</html>