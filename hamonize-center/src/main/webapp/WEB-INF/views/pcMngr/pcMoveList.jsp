<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/css/tdemo.css" />
<link rel="stylesheet" type="text/css" href="/css/template/tui-grid.css" />
<link rel="stylesheet" type="text/css" href="/css/template/tui-pagination.css" />
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

#layer_area{
 width: 1200px;
 height: 700px;
 background-color: #fff;
 display:none;
 /*float:left;*/
 z-index: 1;
 position: fixed;
left: 50%;
top: 50%;

-webkit-transform: translate(-50%, -50%);
-ms-transform: translate(-50%, -50%);
-moz-transform: translate(-50%, -50%);
-o-transform: translate(-50%, -50%);
transform: translate(-50%, -50%);
 }
</style>
<script type="text/javascript">
	$(document).ready(function(){
		setNav('PC관리');
	
	//트리 init
	getPcMngrList();
	
	
});
function getPcMngrList(){
	var url ='/pcMngr/pcMngrList.proc';
	var pc_change = '${pc_change}';
	var keyWord = $("select[name=keyWord]").val();
	var vData = 'pcListInfoCurrentPage=' + $("#pcListInfoCurrentPage").val() +"&keyWord="+ keyWord + "&txtSearch=" + $("#txtSearch").val()+ "&org_seq=" + $("#org_seq").val()+ "&pc_change="+pc_change; 
	callAjax('POST', url, vData, userpcMngrGetSuccess, getError, 'json');
	
}
var userpcMngrGetSuccess = function(data, status, xhr, groupId){
	var gbInnerHtml = "";
	var classGroupList = data.list;
	$('#pageGrideInPcMngrListTb').empty();
	
	if( data.list.length > 0 ){
		$.each(data.list, function(index, value) {
			var no = data.pagingVo.totalRecordSize -(index ) - ((data.pagingVo.currentPage-1)*10);
			
			
			gbInnerHtml += "<tr data-code='" + value.seq + "' data-guidcode='" + value.pc_guid + "'>";
			gbInnerHtml += "<td style='text-align:center;'>"+no+"</td>";
			gbInnerHtml += "<td>"+value.deptname+"</td>";
			gbInnerHtml += "<td>"+value.pc_hostname+"</td>";
			gbInnerHtml += "<td>"+value.pc_ip+"</td>";
			gbInnerHtml += "<td>"+value.pc_macaddress+"</td>"; 
			gbInnerHtml += "<td>"+value.pc_disk+"</td>"; 
			gbInnerHtml += "<td>"+value.pc_cpu+"</td>"; 
			gbInnerHtml += "<td>"+value.pc_memory+"</td>";
			if(value.pc_change == 'R')
				gbInnerHtml += "<td><button type='button' onclick=\"javascript:fnChangeBtn('P',"+value.seq+")\">허용</button></td>";
			else if(value.pc_change == 'P')
				gbInnerHtml += "<td><button type='button' onclick=\"javascript:fnChangeBtn('R',"+value.seq+")\">허용취소</button></td>";
			else
				gbInnerHtml += "<td></td>"
			gbInnerHtml += "</tr>";
		
		});	
	}else{  
		gbInnerHtml += "<tr><td colspan='9' style='text-align:center;'>등록된 데이터가 없습니다. </td></tr>";
	}
	
	startPage = data.pagingVo.startPage;
	endPage = data.pagingVo.endPage; 
	totalPageSize = data.pagingVo.totalPageSize;
	currentPage = data.pagingVo.currentPage;
	totalRecordSize = data.pagingVo.totalRecordSize;
	
	console.log(startPage);
	console.log(endPage);
	console.log(totalPageSize);
	console.log(currentPage);
	console.log(totalRecordSize);
	
	var viewName='classMngrList';
	if(totalRecordSize > 0){
		$("#pagginationInPcMngrList").html(getPaging(startPage,endPage,totalPageSize,currentPage,'\''+viewName+'\''));
	}
	$('#pageGrideInPcMngrListTb').append(gbInnerHtml);
	
}

function show_layer(sttus,seq){
	$("#layer_area").show();
	//$("#sttus").val(sttus);
	$("#seq").val(seq);

	var shtml = "";
	if(sttus == 'null' || sttus == 'C'){
		shtml += "<button type=\"button\" onclick=\"fnChangeBtn('R')\" class=\"btn act\">신청</button>";
		shtml += "<button type=\"button\" onclick=\"hide_layer()\" class=\"btn act\">닫기</button>";
		
	}
	if(sttus == 'R'){
		shtml += "<button type=\"button\" onclick=\"fnChangeBtn('C')\" class=\"btn act\">신청취소</button>";
		shtml += "<button type=\"button\" onclick=\"hide_layer()\" class=\"btn act\">닫기</button>";
		
	}
	if(sttus == 'P'){
		shtml += "<button type=\"button\" onclick=\"fnChangeBtn('C')\" class=\"btn act\">변경완료</button>";
		shtml += "<button type=\"button\" onclick=\"hide_layer()\" class=\"btn act\">닫기</button>";
		
	}
	$('#btn_area').empty();
	$('#btn_area').append(shtml);
	

}
function hide_layer(){
	$("#layer_area").hide();
}

//상태 버튼 변경
function fnChangeBtn(sttus,seq){
	if(sttus == 'P'){
	if (confirm("PC하드웨어 변경을 허용하시겠습니까?")){    
		$.post("changeStts", { pc_change : "P" , seq : seq }
		,function(result){
			if(result=="SUCCESS"){
				alert("처리되었습니다.");
				location.reload();
			}else
				alert("실패되었습니다.");
	    });
	}else{   //취소
	    return;
	}
	}else if(sttus == 'R'){
		if (confirm("PC하드웨어 변경을 허용취소 하시겠습니까?")){    
			$.post("changeStts", { pc_change : "R" , seq : seq }
			,function(result){
				if(result=="SUCCESS"){
					alert("처리되었습니다.");
					location.reload();
				}else
					alert("실패되었습니다.");
		    });
		}else{   //취소
		    return;
		}
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
	
	if($("#org_nm").val()==""){
		alert("부대명을 입력해주세요.");
		return false;
	}
	
	
    console.log($("#seq").val());
    console.log($("#p_seq").val());
    console.log($("#org_nm").val());
    
	$('form[name=frm]').append("<input type='hidden' name='type' value='save' />");        
    $('form[name=frm]').submit();
    alert("정상적으로 저장되었습니다.");
	
    return false;
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
function searchView(viewName, page){
	switch(viewName){
		case 'classMngrList' : $("#pcListInfoCurrentPage").val(page);getPcMngrList(); break;
	default :
	}
}
//]]>
</script>

<body>
	<%@ include file="../template/topMenu.jsp" %>
	<%@ include file="../template/topNav.jsp" %>
	
	
	<section class="body haveGroup">
		<article>
			<div class="code-html contents row">

				<div class="col-md-9" style="margin-top: 22px;">
					
						<input type="hidden" id="pcListInfoCurrentPage" name="pcListInfoCurrentPage" value="1" >
						<input type="hidden" id="org_seq" name="org_seq" value="">
						
						<div class="input_area" style="display: inline-block; width: 100%;">
						<section class="row">
					<h1 class="col-md-8" id="groupForm" style="width: 50%; margin: 0;"></h1>
				  	<div class="table-responsive" id="grid">
					<table data-toggle="table" id="dataTable" width="100%" cellspacing="0" border=0 class="table table-striped table-bordered" >
						<thead>
						<tr class="filters">
							<th><input type="text" class="form-control" placeholder="번호" disabled></th>
							<th><input type="text" class="form-control" placeholder="사지방명" disabled></th>
	                        <th><input type="text" class="form-control" placeholder="PC관리번호" disabled></th>
	                        <th><input type="text" class="form-control" placeholder="IP" disabled></th>
	                        <th><input type="text" class="form-control" placeholder="MacAddress" disabled></th>
	                        <th><input type="text" class="form-control" placeholder="HDD" disabled></th>
	                        <th><input type="text" class="form-control" placeholder="CPU" disabled></th>
	                        <th><input type="text" class="form-control" placeholder="Memory" disabled></th>
	                        <th><input type="text" class="form-control" placeholder="변경신청" disabled></th>
	                    </tr>
		        		</thead>
						<tbody id="pageGrideInPcMngrListTb">
						</tbody>
					</table>
				</div>
				<!-- 페이징 -->
				<ul class="pagination" id="pagginationInPcMngrList"></ul>
				</section>

						</div>
					
					
				</div>
			
			</div>
		</article>
	</section>

	
	<p id="data"></p>
	
	<%@ include file="../template/grid.jsp" %>
	<%@ include file="../template/footer.jsp" %>
	
	
</body>
</html>