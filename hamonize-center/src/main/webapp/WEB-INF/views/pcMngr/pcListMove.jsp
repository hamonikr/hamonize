<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>
<!-- <link rel="stylesheet" href="/css/materialize.css" /> -->
<!--
<link rel="stylesheet" type="text/css" href="/css/tdemo.css" />
<link rel="stylesheet" type="text/css" href="/css/template/tui-grid.css" />
<link rel="stylesheet" type="text/css" href="/css/template/tui-pagination.css" />
<link rel="stylesheet" type="text/css" href="/css/ztree/zTreeStyle.css" />
<script type="text/javascript" src="/js/ztree/jquery.ztree.core.js"></script>
<script type="text/javascript" src="/js/ztree/jquery.ztree.exedit.js"></script>
<script type="text/javascript" src="/js/ztree/jquery.ztree.excheck.js"></script>
<script type="text/javascript" src="/js/common.js"></script>
-->

<!-- <link rel="stylesheet" href="/css/materialize.css"> -->



<link rel="stylesheet" type="text/css" href="/css/ztree/zTreeStyle.css" />
<script type="text/javascript" src="/js/ztree/jquery.ztree.core.js"></script>
<script type="text/javascript" src="/js/ztree/jquery.ztree.exedit.js"></script>
<script type="text/javascript" src="/js/ztree/jquery.ztree.excheck.js"></script>

<style>
/* a{
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
 } */
</style>
<script type="text/javascript">
//<![CDATA[
	
	$(document).ready(function(){
		setNav('PC관리');

	getPcMngrList();
	//등록버튼
	//$("#btnSave").click(fnSave);
	
	
	
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
	$('.page_num').empty();
	if( data.list.length > 0 ){
		$.each(data.list, function(index, value) {
			var no = data.pagingVo.totalRecordSize -(index ) - ((data.pagingVo.currentPage-1)*10);
			
			console.log("z"+value.pc_change)
			gbInnerHtml += "<tr data-code='" + value.seq + "' data-guidcode='" + value.pc_guid + "'>";
			gbInnerHtml += "<td style='text-align:center;'>"+no+"</td>";
			gbInnerHtml += "<td>"+value.sgbsido+"</td>";
			 gbInnerHtml += "<td>"+value.sgbname+"</td>"; 
			gbInnerHtml += "<td><a href='#' onclick=\"javascript:show_layer('"+value.pc_change+"'," +value.seq+")\">"+value.pc_hostname+"</a></td>";
			gbInnerHtml += "<td>"+value.pc_ip+"</td>";
			gbInnerHtml += "<td>"+value.pc_macaddress+"</td>"; 
			gbInnerHtml += "<td>"+value.pc_disk+"</td>"; 
			gbInnerHtml += "<td>"+value.pc_cpu+"</td>"; 
			gbInnerHtml += "<td>"+value.pc_memory+"</td>";
			gbInnerHtml += "<td>"+value.first_date+"</td>";
			if(value.pc_change == 'R')
				gbInnerHtml += "<td>승인요청</td>";
			else if(value.pc_change == 'P')
				gbInnerHtml += "<td>승인완료</td>";
			else if(value.pc_change == 'M')
				gbInnerHtml += "<td>이동중</td>";
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
		$("#page_num").html(getPaging(startPage,endPage,totalPageSize,currentPage,'\''+viewName+'\''));
	}
	$('#pageGrideInPcMngrListTb').append(gbInnerHtml);
	
}

function show_layer(sttus,seq){
	console.log("d"+sttus)
	$("#popup").show();
	$("#bg_fix").show();
	$("#seq").val(seq);
	
	 $.post("getMovePcInfo", { pc_change : sttus , seq : seq }
	,function(result){
		var agrs  = result;

		if(agrs){
			console.log(agrs.result)
			$("#move_org_nm").val(agrs.result.move_org_nm);
			$("#org_nm").val(agrs.result.org_nm);
			//alert("처리되었습니다.");
			//location.reload();
		}else{
			//alert("실패되었습니다.");
		}
			
    }); 

	var shtml = "";
	if(sttus == 'R'){
		shtml += "<button type=\"button\" class=\"btn_type3\" onclick=\"fnChangeBtn('P',"+seq+")\">승인</button>";
		
	}
	if(sttus == 'P'){
		shtml += "<button type=\"button\" class=\"btn_type3\" onclick=\"fnChangeBtn('F',"+seq+")\">승인취소</button>";
		
	}
	$('#btn_area').empty();
	$('#btn_area').append(shtml);
}
function hide_layer(){
	$("#popup").hide();
	$("#bg_fix").hide();
}

//상태 버튼 변경
function fnChangeBtn(sttus,seq){
	var move_org_nm = $("#move_org_nm").val();
	if(sttus == 'P'){
	if (confirm("PC이동을 승인하시겠습니까?")){    
		$.post("changeStts", { pc_change : "P" , seq : seq ,move_org_nm : move_org_nm}
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
	}else if(sttus == 'F'){
		if (confirm("PC이동 승인 취소 하시겠습니까?")){    
			$.post("changeStts", { pc_change : "R" , seq : seq ,move_org_nm : move_org_nm,sttus:sttus}
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
    console.log($("#seq").val());
    console.log($("#p_seq").val());
    console.log($("#org_nm").val());
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
	
	<div class="hamo_container other">

		<!-- 우측 리스트 -->
		<div class="con_right">
        <div class="right_box">
<h2>PC이동관리</h2>
	                <!-- 검색 -->
	        <div class="top_search">
	            <select id="" name="" title="" class="sel_type1">
	                <option value="0">전체</option>
	                <option value="1">지역</option>
	                <option value="2">사지방번호</option>
	                <option value="3">IP</option>
	                <option value="4">Mac Address</option>
	                <option value="5">PC관리번호</option>
	            </select>
	            <label for="txtSearch"></label><input type="text" name="txtSearch" id="txtSearch" class="input_type1" />
	            <button type="button" class="btn_type3" onclick="javascript:getPcMngrList();">  검색</button>
	        </div>
			        <!-- //검색 -->
					
					<input type="hidden" id="pcListInfoCurrentPage" name="pcListInfoCurrentPage" value="1" >
					<input type="hidden" id="org_seq" name="org_seq" value="" >
					
					<!-- List -->
	        <div class="board_list mT20">
	            <table>
	                <colgroup>
	                   <col style="width:5%;" />
	                   <col style="width:7%;" />
	                   <col style="width:8%;" />
	                   <col style="width:10%;" />
	                   <col style="width:12%;" />
	                   <col style="width:10%;" />
	                   <col style="width:17%;" />
	                   <col style="width:15%;" />
	                   <col style="width:8%;" />
	                   <col />
	                </colgroup>
	                <thead>
	                   <tr>
	                       <th>번호</th>
	                       <th>지역</th>
	                       <th>사지방번호</th>
	                       <th>PC관리번호</th>
	                       <th>IP</th>
	                       <th>Mac Address</th>
	                       <th>HDD</th>
	                       <th>CPU</th>
	                       <th>Memory</th>
	                       <th>설치일</th>
	                       <th>상태</th>
	                   </tr>
	                </thead>
	                <tbody id="pageGrideInPcMngrListTb"></tbody>
	            </table>
	        </div>
	        <!-- //List -->
		        	
	        <!-- page number -->
          <div class="page_num" id="page_num">
          </div>
		    </div>
		</div>
	</div>
	<!--  레이어 팝업 -->
            <div id="popup" class="popa" style="display:none;">
                <h3>pc이동신청</h3>
                <div class="pop_content">
                    <!-- 검색 -->
				<div class="board_view mT20" id="insert">
                	<form id="addForm" class="form-inline col-md-12 row" action="">
						<input id="sma_gubun" name="sma_gubun" type="hidden" value="Y">
                    	<table>
                       		<colgroup>
	                            <col style="width:25%;" />
	                            <col style="width:25%;" />
	                            <col style="width:25%;" />
	                            <col style="width:25%;" />
                        	</colgroup>
		                        <tbody>
		                            <tr>
		                                <th>현재사지방번호</th>
		                                <td>
										  	<input id="org_nm" name="org_nm" type="text" class="input_type1" readonly/>
		                                </td>
		                                <th>이동할사지방번호</th>
		                                <td>
		                                	<input id="move_org_nm" name="move_org_nm" type="text" class="input_type1" readonly/>
		                                </td>
		                               
		                            </tr>
		                        </tbody>
		                    </table>
		                    </form>
		                </div><!-- //List -->
                   
                    <div class="right mT20" id="btn_area">
                    	<!-- <button type="button" class="btn_type3 request" onclick="fnChangeBtn('P')">승인</button> -->
                    	<!-- <button type="button" class="btn_type3" onclick="hide_layer()">닫기</button> -->
               		</div>


                </div>
                <a href="#" onclick="hide_layer();" class="pop_close">닫기</a>
            </div>
	<div id="bg_fix" style="display:none;"></div>
	
	<%@ include file="../template/footer.jsp" %>
	
	
</body>
</html>