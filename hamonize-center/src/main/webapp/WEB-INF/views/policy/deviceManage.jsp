<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/css/ztree/zTreeStyle.css" />
<script type="text/javascript" src="/js/ztree/jquery.ztree.core.js"></script>
<script type="text/javascript" src="/js/ztree/jquery.ztree.exedit.js"></script>
<script type="text/javascript" src="/js/ztree/jquery.ztree.excheck.js"></script>
<!-- jquery alert -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jquery-confirm/3.3.2/jquery-confirm.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-confirm/3.3.2/jquery-confirm.min.js"></script>

<script src="/js/materialize.js"></script>
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
		setNav('정책관리 > 디바이스관리');
	//트리 init
	$.fn.zTree.init($("#tree"), setting, zNodes); 
	
	$("#expandAllBtn").bind("click", {type:"expandAll"}, expandNode);
	$("#collapseAllBtn").bind("click", {type:"collapseAll"}, expandNode);

	
	//등록버튼
	$("#btnSave").click(fnSave);
	
	$("#btnManage").click(fnManage);

	
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
	$('input:checkbox[name=sm_seq]').prop("checked", false);
		var zTree = $.fn.zTree.getZTreeObj("tree");
		var node = zTree.getNodeByParam('id', treeNode.pId);
		if(treeNode.checked){
		$.post("dshow",{org_seq:treeNode.id},
		function(result){
				var agrs = result;
				var ppm_seq = agrs.dataInfo.ppm_seq;
				ppm_seq = ppm_seq.split(",");
				for(var i=0; i < ppm_seq.length; i++){
				 $('input:checkbox[name=sm_seq]').each(function() {
					 if($(this).val() == ppm_seq[i] ){
						 $(this).prop("checked", true);
					 }
				    });
				}
				
					
				$('form[name=frm] input[name=org_seq]').val(agrs.dataInfo.org_seq);
				$('form[name=frm] input[name=pOrgNm]').val(agrs.pOrgNm);
		});
		}	
		}
		
function onCheck(event, treeId, treeNode) {
	$('input:checkbox[name=sm_seq]').prop("checked", false);
	var zTree = $.fn.zTree.getZTreeObj("tree");
	var node = zTree.getNodeByParam('id', treeNode.pId);
	if(treeNode.checked){
	$.post("dshow",{org_seq:treeNode.id},
	function(result){
			var agrs = result;
			var ppm_seq = agrs.dataInfo.ppm_seq;
			ppm_seq = ppm_seq.split(",");
			for(var i=0; i < ppm_seq.length; i++){
			 $('input:checkbox[name=sm_seq]').each(function() {
				 if($(this).val() == ppm_seq[i] ){
					 $(this).prop("checked", true);
				 }
			    });
			}
			
				
			$('form[name=frm] input[name=org_seq]').val(agrs.dataInfo.org_seq);
			$('form[name=frm] input[name=pOrgNm]').val(agrs.pOrgNm);
			
			
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

function fnManage(){
	$("#popup").show();
	$("#bg_fix").show();

}
function hide_layer(){
	$("#popup").hide();
	$("#bg_fix").hide();
}

//등록 처리결과(공통명 : 프로그램명Json )
function fnSave(){
	var button = document.getElementById('btnSave');
	
	if(confirm("하위부문 및 부서가 있다면 하위부문 및 부서에도 전부 적용됩니다 적용하시겠습니까?")){
	var ppm_seq = "";
    $('input:checkbox[name=sm_seq]').each(function(i) {
       if($(this).is(':checked'))
    	   ppm_seq += ($(this).val())+",";
    });
    ppm_seq = ppm_seq.substr(0,ppm_seq.length -1);
	if(ppm_seq == ""){
		ppm_seq = 0;
	}
    
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
	
	$.post("dsave", {dataType:'json',ppm_seq:ppm_seq, data:JSON.stringify(queryArr)}, 
		function(result){	
		if(result=="SUCCESS"){
			alert("정상적으로  처리되었습니다.");
			button.disabled	= false;
	
			location.reload();
		}else{
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
	        </ul>
	        <h2 class="tree_head">디바이스관리</h2>
	
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
	
	         <h3 class="inblock">디바이스 관리 <span>허용 디바이스 선택</span></h3>
      			<div class="right"> <button type="button" id="btnManage" class="btn_type3"> 허용 디바이스 관리</button></div>
      					
						<form name="frm" method="post" action="orgManage" class="row">
	         			<input type="hidden" name="org_seq" id="org_seq" value="" />
								<input type="hidden" name="ppm_seq" id="ppm_seq" value="" />
								<input type="hidden" name="section" id="section" value="" />
								
			         <!-- update list -->
			         <ul class="promlist">
	        				<c:forEach items="${pList}" var="data" varStatus="status" >
				             <li>
				                 <span>
				                 	<input type="checkbox" name="sm_seq" id="${data.sm_seq}" class="check2" value="<c:out value="${data.sm_seq}" />">
				                 	<label for="${data.sm_seq}"></label>
				                 	<c:out value="${data.sm_name}" />
				                 </span>
				                 
												<p class="card-text"><c:out value="${data.sm_dc}" /></p>
				             </li>
	          			</c:forEach>
			         </ul>
			         			
			         <!-- //update list -->
			         <div class="right mT20">
			             <button type="reset" class="btn_type2" id="btnInit"> 초기화</button>
			             <button type="button" class="btn_type2" id="btnSave" > 저장</button>
			         </div>
						</form>
	    	</div>
		 </div>
	</div>
	
	<!--  레이어 팝업 -->
            <div id="popup" class="popa" style="display:none;">
                <h3>허용 디바이스 관리</h3>
                <div class="pop_content">
          		<div class="board_view2 mT20" id="insert">
                	<form id="addForm" class="form-inline col-md-12 row" action="" style="display:none;">
						<input id="sma_gubun" name="sma_gubun" type="hidden" value="Y">
						<input id="sm_device_code" name="sm_device_code" type="hidden" value="">
                    	<table>
                       		<colgroup>
	                            <col style="width:5%;" />
	                            <col style="width:10%;" />
	                            <col style="width:5%;" />
	                            <col style="width:10%;" />
	                            <col style="width:5%;" />
	                            <col style="width:10%;" />
	                            <col style="width:5%;" />
	                            <col />
                        	</colgroup>
		                        <tbody>
		                            <tr>
		                                <th>디바이스</th>
		                                <td>
										  	<input id="sm_name" name="sm_name" type="text" class="input_type1" style="width:100px;"  maxlength="20"/>
		                                </td>
		                                <th>VendorId</th>
		                                <td>
										  	<input id="vendor_id" name="vendor_id" type="text" class="input_type1" style="width:70px;" maxlength="4" />
		                                </td>
		                                <th>ProductId</th>
		                                <td>
										  	<input id="product_id" name="product_id" type="text" class="input_type1" style="width:70px;" maxlength="4" />
		                                </td>
		                                <th>설명</th>
		                                <td>
		                                	<input id="sm_dc" name="sm_dc" type="text" class="input_type1" style="width:270px;"  maxlength="30" />
		                                </td>
		                                <td class="t_right">
		                                    <button type="button" id="saveDevice" class="btn_type3">추가</button>
		                                </td>
		                            </tr>
		                        </tbody>
		                    </table>
		                    <input type="hidden" id="MngeListInfoCurrentPage" name="MngeListInfoCurrentPage" value="1">
		                    </form>
		                </div><!-- //List -->
                    <div class="board_list mT20">
                        <table>
                            <colgroup>
                                <col style="width:10%;" />
                                <col style="width:10%;" />
                                <col style="width:10%;" />
                                <col style="width:10%;" />
                                <col style="width:20%;" />
                                <col />
                            </colgroup>
                            <thead>
                                <tr>
                                	<th></th>
                                    <th>번호</th>
                                    <th>디바이스</th>
                                    <th>VendorId</th>
                                    <th>ProductId</th>
                                    <th>설명</th>
                                </tr>
                            </thead>
                            <tbody id="pageGrideInMngrListTb">
                            </tbody>
                        </table>
                    </div><!-- //List -->
                    <div class="mT20">
                        <button type="button" class="btn_type3" id="deleteDevice">삭제</button>
                    </div>
                    <div class="right mT20">
                    	<button type="button" class="btn_type2 insertBtn">디바이스 추가</button>
               		</div>
                    <!-- page number -->
                    <div class="page_num" id="page_num">
                    </div>

                </div>
                <a href="#" onclick="hide_layer();" class="pop_close">닫기</a>
            </div>
            <div id="bg_fix" style="display:none;"></div>
	

	
	<script type="text/javascript">

	function searchView(viewName, page){
			switch(viewName){
				case 'classMngrList' : $("#MngeListInfoCurrentPage").val(page); getList(); break;	//	공지사항
			default :
			}
		}
	
	/*
	 * 이전 페이지
	 */
	function prevPage(viewName, currentPage){
		var page = eval(currentPage) - 1;

			if(page < 1){
				page = 1;
			}
		searchView(viewName, page);
	}

	/*
	 * 다음 페이지
	 */
	function nextPage(viewName, currentPage, totalPageSize){
		var page = eval(currentPage) + 1;
		var totalPageSize = eval(totalPageSize);

		if(page > totalPageSize){
			page = totalPageSize;
		}
		searchView(viewName, page);
	}

	
	// 입력폼 초기화
	function fromReset(){
		$('#sm_name').val('');
		$('#sm_dc').val('');
		$('#sm_port').val('');
		$('#vendor_id').val('');
		$('#product_id').val('');
		}

	function getList(){
		var url ='/gplcs/dManagePopList';
		
		var keyWord = $("select[name=keyWord]").val();
		var vData = 'MngeListInfoCurrentPage=' + $("#MngeListInfoCurrentPage").val() +"&keyWord="+ keyWord + "&txtSearch=" + $("#txtSearch").val();
		callAjax('POST', url, vData, deviceGetSuccess , getError, 'json');
	}
	
	function getListAddDeleteVer(){
		var url ='/gplcs/dManagePopList';
		
		var keyWord = $("select[name=keyWord]").val();
		var vData = 'MngeListInfoCurrentPage=' + $("#MngeListInfoCurrentPage").val() +"&keyWord="+ keyWord + "&txtSearch=" + $("#txtSearch").val();
		
		function fnt(data, status, xhr, groupId){ 
			deviceGetSuccess(data, status, xhr, groupId); 
			$('.mdl-data-table__cell--non-numeric .form-control').css('opacity', '1');
		}
		
		callAjax('POST', url, vData, fnt, getError, 'json');
	}

	// 등록 버튼
	function addDeviceFnt(){
		var name = $('#sm_name').val();
		var info = $('#sm_dc').val();
		var vendor = $('#vendor_id').val();
		var product = $('#product_id').val();
		var regExp = /^[a-z0-9_]{4}$/;
		var regExpName = /^[ㄱ-ㅎ가-힣a-zA-Z0-9_]*$/;

		$('#sm_device_code').val($('#vendor_id').val()+":"+$('#product_id').val());
		
		// 검증
		if(name.length  <= 0){
			alert('디바이스명을 입력해 주세요!');
			return;
		}else{
			if(!regExpName.test(name)){
				alert('디바이스 이름에는 공백을 제외한 문자, 숫자, 특수문자는 "_"만 이용가능합니다(20자 내)');
				return;
			}
		}
		
		if(info.length  <= 0){
			alert('디바이스설명을 입력해 주세요!');
			return;
		}
		

		if(!regExp.test(vendor)){
			alert('vendorId는 4자리로된 영문 소문자, 숫자로 이루어진 코드입니다. 다시 확인해주세요!');
			return false;
		}

		if(!regExp.test(product)){
			alert('productId는 4자리로된 영문 소문자, 숫자로 이루어진 코드입니다. 다시 확인해주세요!');
			return false;
		}

		// 전송
		$.ajax({
			url : '/gplcs/dManagePopSave',
			type: 'POST',
			data: $('#addForm').serialize(),
			success : function(res) {
				if( res.success == true ){
					alert("등록되었습니다.");
					getListAddDeleteVer();
		        	fromReset();
					location.reload();

				}else{
					alert("등록되지 않았습니다.");
					$.alert({
					    title: 'Alert!',
					    content:  res.msg + '!',
					});
				}
			},
			error:function(request,status,error){
				console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}
		}); 
	}
	
	
	// 삭제 버튼
	function deleteDeviceFnt(){
		var iptArr = $('.form-control:checked');
		var addressArr = [];

		// 검증
		$.each(iptArr, function(idx, ipt){
			addressArr.push($(ipt).parent().parent().attr('data-code'));
		});
		
		if(0 >= addressArr.length){
			alert('삭제할 디바이스을 선택해 주시기 바랍니다!');
			return;
		}
		
		
		
		function ftn(data, status, xhr, groupId){
			alert("삭제 되었습니다.");
			getListAddDeleteVer();
        	fromReset();
			location.reload();
			
		}
		
		// 전송
		var url = '/gplcs/dManagePopDelete';
		var vData = "deleteList=" + addressArr;
		callAjax('POST', url, vData, ftn, getError, 'json');
	}
	
	$(document).ready(function(){
		
	// 관리 버튼
	$('.insertBtn').on('click', function(){
		var ipt = $('.mdl-data-table__cell--non-numeric .form-control');
		var form = $('#addForm');
		if(form.css('display') == 'none') {
			form.css('display', 'flex');
			ipt.css('opacity', '1');
		}else{
			form.css('display', 'none');
			ipt.css('opacity', '0');
			fromReset();
		}
	});
	
	// 등록 버튼
	$('#saveDevice').on('click', function(){
		addDeviceFnt();
	});
	
	// 삭제 버튼
	$('#deleteDevice').on('click', function(){
		deleteDeviceFnt();
	});



	getList();
});

//디바이스 리스트
var deviceGetSuccess = function(data, status, xhr, groupId){
	var gbInnerHtml = "";
	var classGroupList = data.list;
	$('#pageGrideInMngrListTb').empty();
	
	if( data.list.length > 0 ){
		$.each(data.list, function(index, value) {
			var no = data.pagingVo.totalRecordSize -(index ) - ((data.pagingVo.currentPage-1)*5);
			console.log(no);
			var code = new Array();
			code = value.sm_device_code.split(":");
			console.log(code[0]);
			
			if(value.sm_dc == null)
				value.sm_dc = "설명이 없습니다"

				gbInnerHtml += "<tr data-code='" + value.sm_seq + "'>";
				gbInnerHtml += "<td class='t_left'>";
			if(value.ppm_seq == value.sm_seq){
				gbInnerHtml += "<input type='checkbox' id=d"+no+" class='form-control' disabled><label for=d"+no+" class='dook'></label></td>";
			}else{
				gbInnerHtml += "<input type='checkbox' id=d"+no+" class='form-control'><label for=d"+no+" class='dook'></label></td>";	
			}
				gbInnerHtml += "<td><span>"+no+"</span>";
			
			gbInnerHtml += "<td>"+value.sm_name+"</td>";
			gbInnerHtml += "<td>"+code[0]+"</td>";
			gbInnerHtml += "<td>"+code[1]+"</td>";
			gbInnerHtml += "<td>"+value.sm_dc+"</td>";
			gbInnerHtml += "</tr>";
			
		});	 
	}else{ 
		gbInnerHtml += "<tr><td colspan='4'>등록된 정보가 없습니다. </td></tr>";
	}
	
	startPage = data.pagingVo.startPage;
	endPage = data.pagingVo.endPage; 
	totalPageSize = data.pagingVo.totalPageSize;
	currentPage = data.pagingVo.currentPage;
	totalRecordSize = data.pagingVo.totalRecordSize;

	console.log("startPage +++++ "+ startPage);
	console.log("endPage +++++ " + endPage);
	console.log("totalPageSize +++++ "+ totalPageSize);
	console.log("currentPage +++++ "+ currentPage);
	console.log("totalRecordSize +++++ "+ totalRecordSize);

	
	var viewName='classMngrList';
	if(totalRecordSize > 0){
		$(".page_num").html(getPaging(startPage,endPage,totalPageSize,currentPage,'\''+viewName+'\''));
	}
	$('#pageGrideInMngrListTb').append(gbInnerHtml);


}


</script>
	
	
	
	<%@ include file="../template/footer.jsp" %>
	
	
</body>
</html>
