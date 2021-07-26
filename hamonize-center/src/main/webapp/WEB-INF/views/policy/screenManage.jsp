<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp"%>
<link rel="stylesheet" type="text/css" href="/css/ztree/zTreeStyle.css" />
<script type="text/javascript" src="/js/ztree/jquery.ztree.core.js"></script>
<script type="text/javascript" src="/js/ztree/jquery.ztree.exedit.js"></script>
<script type="text/javascript" src="/js/ztree/jquery.ztree.excheck.js"></script>

<link rel="stylesheet" href="/css/materialize.css">
<script src="/js/materialize.js"></script>
<style>
.tts {
    position: absolute;
    left: -9999px;
    width: 1px;
    height: 1px;
    font-size: 0;
    line-height: 0;
    overflow: hidden;
}

.btn {
	display: inline-block;
	text-align: center;
	vertical-align: middle;
	white-space: nowrap;
	text-decoration: none !important;
}

</style>
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
			 /* check: {
				enable: true,
				chkboxType: { "Y" : "s", "N" : "ps" }
			}, */
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
				onExpand: onExpand,*/
				beforeClick: beforeClick,
				onClick: onClick
			}
		};
	var zNodes =[
		/* { id:0, pId:"", name:"부대관리", open:true}, */
		<c:forEach items="${oList}" var="data" varStatus="status" >
		{ id:"${data.seq}", pId:"${data.p_seq}",
			<c:if test="${data.section ne 'S'}">
			name:"${data.org_nm}"
				</c:if>
			<c:if test="${data.section eq 'S'}">
			name:"[S]"+"${data.org_nm}"
				</c:if>
			,od:"${data.org_ordr}"
			<c:if test="${data.level eq '0' or data.level eq '1' or data.level eq '2'}">
			,open:true
			</c:if>},
		</c:forEach>				
	];
	
	$(document).ready(function(){
		setNav('정책관리 > 디바이스관리');
	//트리 init
	$.fn.zTree.init($("#tree"), setting, zNodes); 
	
	$("#expandAllBtn").bind("click", {type:"expandAll"}, expandNode);
	$("#collapseAllBtn").bind("click", {type:"collapseAll"}, expandNode);
		
	//등록버튼
	$("#btnSave").click(fnSave);
	
	// 파일첨부 디자인 버튼
	$('.btn-attach, .input-fake').bind("click", function(){
		$(this).siblings('input[type=file]').click();
	});
	$('input[type=file]').bind("change", function(){
		if(window.FileReader) {
			// modern browser
			var filename = $(this)[0].files[0].name;
		} else {
			// old IE 
			var filename = $(this).val().split('/').pop().split('\\').pop();
		} 
		$(this).siblings('.input-fake').val(filename); 
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
		var zTree = $.fn.zTree.getZTreeObj("tree");
		var node = zTree.getNodeByParam('id', treeNode.pId);
		$.post("sview.do",{seq:treeNode.id},
		function(result){
				var agrs = result;
				console.log(agrs);	
				
				$('form[name=frm] input[name=org_seq]').val(agrs.org_seq);
				$('form[name=frm] input[name=input-fake]').val(agrs.filename);

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
	
	//if($("#org_seq").val()==""){
	//	alert("부대를 선택해 주세요.");
	//	return false;
	//}
	
	
    console.log($("#org_seq").val());
   
    $('form[name=frm]').submit();
    alert("정상적으로 저장되었습니다.");
    console.log($("#frm").serialize());
    /* $.post("smanageSave.do", {dataType:"json",enctype="multipart/form-data",data:$("#frm").serialize()},
			 function(result){
		if(result=="SUCCESS"){
			alert("정상적으로  처리되었습니다.");
			location.reload();
		}
		else
			alert("실패하였습니다.");
   });  */
    return false;
}
//]]>
</script>

<body>
	<%@ include file="../template/topMenu.jsp"%>
	<%@ include file="../template/topNav.jsp"%>


	<section class="body haveGroup">
		<article>
			<div class="code-html contents row">

				<div class="col-md-3 row">
					<div class="form-style-10 col-md-12 boxDiv">
						<div class="inner-wrap row"
							style="padding: 0; background: rgba(0, 0, 0, 0)">
							<div class="section">
								<span class="numTxt">1</span>그룹선택
							</div>

							<!-- search -->

							<div class="tree_area" style="display: inline-block;">
								<div class="tree_ctrl">
									<button type="button" class="btn bg-success btn-md"
										id="expandAllBtn" style="float: left;">
										<i class="fa fa-check" aria-hidden="true"></i> 전체열기
									</button>
									&nbsp;
									<button type="button" class="btn btn-md bg-dark"
										id="collapseAllBtn">
										<i class="fa fa-check" aria-hidden="true"></i> 전체닫기
									</button>
								</div>
								<div class="scroll_area">
									<ul id="tree" class="ztree"></ul>
								</div>
							</div>
							<div class="input_area" style="display: inline-block;"></div>
						</div>
					</div>
				</div>

				<div class="col-md-9">
					<div class="form-style-10 boxDiv">
						<div class="section">
							<span class="numTxt">2</span>바탕화면 이미지 등록
						</div>
						<div class="input_area"
							style="display: inline-block; width: 100%;">

							<form name="frm" method="post" action="smanageSave.do"
								class="row" enctype="multipart/form-data">
								<input type="hidden" name="org_seq" id="org_seq" value="" />
								<!-- <input type="hidden" name="ppm_seq" id="ppm_seq" value="" />
								<input type="hidden" name="section" id="section" value="" /> -->

								<div class="inner-wrap row">

									<table>
										<!-- <caption>파일</caption> -->
										<colgroup>
											<col style="width: 180px">
											<col style="width: 180px">
											<col style="width: 130px">
											<col>
										</colgroup>
										<tbody>
											<tr>
												<th scope="row">바탕화면 이미지<span class="req"></span></th>
												<td colspan="2"><input type="file" name="filename" id="filename" class="tts" title="파일첨부" value=""><br /> 
												<input type="text" class="input-fake" name="input-fake" title="파일명" style="width:calc(100% - 190px);" readonly>
													<button type="button" class="btn btn-default btn-attach">찾아보기</button>
													<!-- <span class="color-orange ml10"></span>
													<p class="color-brown mt5"></p> --></td>
											</tr>
										</tbody>
									</table>

								</div>

								<div class="col-md-12 row btn_area">
									<div class="col-md-2">
										<button type="reset" class="btn nav" id="btnInit"
											style="float: left;">
											<i class="fa fa-check" aria-hidden="true"></i> 초기화
										</button>
									</div>
									<div class="col-md-2">
										<button type="button" class="btn act" id="btnSave">
											<i class="fa fa-check" aria-hidden="true"></i> 변경저장
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

	<!-- content body -->
	<%-- <div class="mng_menu org" style="width: 100%; text-align: center;">
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
			<input type="hidden" name="org_seq"  id="org_seq" value="" />
			<input type="hidden" name="ppm_seq" id="ppm_seq" value="" />
			<input type="hidden" name="section" id="section" value="" />
			
			<c:forEach items="${pList}" var="data" varStatus="status" >
			<c:if test="${data.sm_gubun eq 'D'}">
			<input type="checkbox" name="sm_seq" value="<c:out value="${data.sm_seq}" />">
			<c:out value="${data.sm_name}" /><c:out value="${data.sm_dc}" />
			</c:if>
			</c:forEach>	
			<div class="btn_area">
				<button type="reset" class="btn nav"  id="btnInit" style="float: left;">초기화</button>
				<button type="button" class="btn act" id="btnSave">변경저장</button>		
			</div>
		</form>
		</div>
	</div> --%>


	<%@ include file="../template/grid.jsp"%>
	<%@ include file="../template/footer.jsp"%>


</body>
</html>