<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="/css/materialize.css">
<link rel="stylesheet" type="text/css" href="/css/notice/notice.css" />
<link rel="stylesheet" type="text/css" href="/css/template/bootstrap4.css" />
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
<script type="text/javascript" src="/js/common.js"></script>
<script src="/js/materialize.js"></script>
<!-- jquery alert -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jquery-confirm/3.3.2/jquery-confirm.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-confirm/3.3.2/jquery-confirm.min.js"></script>

<style> 
 #element_to_pop_up { 
    background-color:#fff;
    border-radius:15px;
    color:#000;
    display:none; 
    padding:20px;
    min-width:400px;
    min-height: 180px;
    margin-top:10%;
}
.b-close{
    cursor:pointer;
    position:absolute;
    right:10px;
    top:5px;
}
 
.contentLayer {
  max-width: 1000px;
  margin: 0 auto;
} 

#addForm { display: none }
/* .input-field { margin: 0 !important } */

#pageGrideInMngrListTb .mdl-data-table__cell--non-numeric input {
	display: inline-block;
	margin-left: 5px;
	opacity: 0;
	pointer-events: unset;
	position: unset;
	height: 20px;
	width: 20px;
}
</style>
<script type="text/javascript">

$(document).ready(function() {
	// 찾기
	$('#dateSearchBtn').click(function() {
		getList();
	});
	
	var getKeyWord = "${mngeVo.keyWord}";
	if(getKeyWord.length == 0){ 
		$("#keyWord option:eq(1)").prop("selected", true);		
	}else{
		$("#keyWordID").val(getKeyWord).attr("selected", true);
	}
	
	$("#txtSearch").keydown(function(key) {
		if (key.keyCode == 13) {
			key.preventDefault();
			getList();
		}
	});
	
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
			case 'classMngrList' : $("#notiListCurrentPage").val(page); getList(); break;	//	공지사항
		default :
		}
	}
	
	
	// 입력폼 초기화
	function fromReset(){
		$('#sm_name').val('');
		$('#sm_dc').val('');
		$('#sm_port').val('');
		}
	
	
	function getList(){
		var url ='/gplcs/fManagePopList';
		
		var keyWord = $("select[name=keyWord]").val();
		var vData = 'notiListCurrentPage=' + $("#notiListCurrentPage").val() +"&keyWord="+ keyWord + "&txtSearch=" + $("#txtSearch").val();
		callAjax('POST', url, vData, deviceGetSuccess , getError, 'json');
	}
	
	function getListAddDeleteVer(){
		var url ='/gplcs/fManagePopList';
		
		var keyWord = $("select[name=keyWord]").val();
		var vData = 'notiListCurrentPage=' + $("#notiListCurrentPage").val() +"&keyWord="+ keyWord + "&txtSearch=" + $("#txtSearch").val();
		
		function fnt(data, status, xhr, groupId){ 
			deviceGetSuccess(data, status, xhr, groupId); 
			$('.mdl-data-table__cell--non-numeric .form-control').css('opacity', '1');
		}
		
		callAjax('POST', url, vData, fnt, getError, 'json');
	}
	
	
	$('#portfolio-grid').on('click', '.thumbnail', function() {
		$("#ri_no").val($(this).data("code"));	
		$("#no").val($(this).data("code"));
		$("#vierFrm").submit();
	});
	
	
	
	// 등록 버튼
	function addDeviceFnt(){
		var name = $('#sm_name').val();
		var info = $('#sm_dc').val();
		// 검증
		if(name.length  <= 0){
			$.alert({
			    title: 'Alert!',
			    content:  '디바이스명을 입력해 주세요!',
			    buttons: {
			        확인: function(){
			        }
			    }
			});
			return;
		}

		if(info.length  <= 0){
			$.alert({
			    title: 'Alert!',
			    content:  '디바이스설명을 입력해 주세요!',
			    buttons: {
			        확인: function(){
			        }
			    }
			});
			return;
		}
		
		
		// 전송
		$.ajax({
			url : '/gplcs/fManagePopSave',
			type: 'POST',
			data: $('#addForm').serialize(),
			success : function(res) {
				if( res.success == true ){
					$.alert({
					    title: 'Alert!',
					    content:  res.msg + '!',
					    buttons: {
					        확인: function(){
					        	getListAddDeleteVer();
					        	fromReset();
					        }
					    }
					});
				}else{
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
		var iptArr = $('.mdl-data-table__cell--non-numeric .form-control:checked');
		var addressArr = [];

		// 검증
		$.each(iptArr, function(idx, ipt){
			addressArr.push($(ipt).parent().parent().attr('data-code'));
		});
		
		if(0 >= addressArr.length){
			$.alert({
			    title: 'Alert!',
			    content:  '삭제할 디바이스를 선택해 주시기 바랍니다!',
			    buttons: {
			        확인: function(){
			        }
			    }
			});
			return;
		}
		
		
		
		function ftn(data, status, xhr, groupId){
			$.alert({
			    title: 'Alert!',
			    content:  '정상적으로 삭제되었습니다!',
			    buttons: {
			        확인: function(){
			        	//deleteDeviceSuccess(data, status, xhr, groupId);
			        	getListAddDeleteVer();
			        	fromReset();
			        }
			    }
			});
		}
		
		// 전송
		var url = '/gplcs/fManagePopDelete';
		var vData = "deleteList=" + addressArr;
		callAjax('POST', url, vData, ftn, getError, 'json');
	}
	
	
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
			var no = data.pagingVo.totalRecordSize -(index ) - ((data.pagingVo.currentPage-1)*10);
			if(value.sm_dc == null)
				value.sm_dc = "설명이 없습니다"
			gbInnerHtml += "<tr data-code='" + value.sm_seq + "'>";
			gbInnerHtml += "<td class='mdl-data-table__cell--non-numeric'><span>"+no+"</span>";
				if(value.ppm_seq == value.sm_seq){
					gbInnerHtml += '<input type="checkbox" class="form-control" disabled></td>';
				}else{
					gbInnerHtml += '<input type="checkbox" class="form-control"></td>';	
				}
			gbInnerHtml += "<td class='mdl-data-table__cell--non-numeric'>"+value.sm_name+"</td>";
			gbInnerHtml += "<td class='mdl-data-table__cell--non-numeric'>"+value.sm_dc+"</td>";
			gbInnerHtml += "<td class='mdl-data-table__cell--non-numeric'>"+value.sm_port+"</td>";
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
	
	var viewName='classMngrList';
	if(totalRecordSize > 0){
		$("#pagginationInMngrList").html(getPaging(startPage,endPage,totalPageSize,currentPage,'\''+viewName+'\''));
	}
	$('#pageGrideInMngrListTb').append(gbInnerHtml);
}

</script>
</head>
<body>
<section class="contentLayer">
	
		<article>
			<div class="code-html">
				<p id="contentTitle"></p>
				
				<hr/>
				<div class="row" style="margin-left: 10px;">
		        	<form class="form-inline col-md-5" action="">
			  			<div class="input-field s3 mb-4 mr-sm-4">
						  	<input id="searchTitle" name="searchTitle" type="text" data-length="10" style="width:280px;">
			            	<label for="searchTitle" class="mb-4 mr-sm-4">검색 방화벽 :</label>
			            	<button type="submit" class="btn btn-info mb-1">검색</button>
			          	</div>
					</form>
					
					<div class="col-md-5"></div>
					
					<div id="managementDiv" class="col-md-2">
						<input type="button" value="관리" class="btn insertBtn" style="width: 100%">
					</div>
					
					
					<form id="addForm" class="form-inline col-md-12 row" action="">
			  			<div class="input-field s3 mb-4 mr-sm-4">
						  	<input id="sm_name" name="sm_name" type="text" value="">
			            	<label for="sm_name" class="mb-4 mr-sm-4">방화벽명</label>
			          	</div>
			          	
			  			<div class="input-field s3 mb-4 mr-sm-4">
						  	<input id="sm_dc" name="sm_dc" type="text" data-length="10">
			            	<label for="sm_dc" class="mb-4 mr-sm-4">방화벽정보</label>
			          	</div>
			          	
			  			 <div class="input-field s3 mb-4 mr-sm-4">
						  	<input id="sm_port" name="sm_port" type="text" data-length="10">
			            	<label for="sm_port" class="mb-4 mr-sm-4">포트</label>
			          	</div> 
		            	<input type="button" id="saveDevice" class="btn btn-info mb-1" value="등록">
						
						<div class="col-md-2">
							<input type="button" id="deleteDevice" class="btn btn-info mb-1" value="삭제">
						</div>
					</form>
		        </div>		
				<div class="table-responsive" id="grid">
					<table data-toggle="table" id="dataTable" width="100%" cellspacing="0" border=0 class="table table-striped table-bordered" >
						<thead>
						<tr class="filters">
	                        <th><input type="text" class="form-control" placeholder="번호" disabled></th>
	                        <th><input type="text" class="form-control" placeholder="방화벽" disabled></th>
	                        <th><input type="text" class="form-control" placeholder="방화벽설명" disabled></th>
	                        <th><input type="text" class="form-control" placeholder="포트" disabled></th>
	                        <!-- <th><input type="text" class="form-control" placeholder="등록일시" disabled></th> -->
	                    </tr>
		        		</thead>
						<tbody id="pageGrideInMngrListTb">
							<input type="hidden" id="notiListCurrentPage" name="notiListCurrentPage" value="1" class="form-control" >
						</tbody>
					</table>
				</div>
				
				<!-- 페이징 -->
				<ul class="pagination" id="pagginationInMngrList"></ul>
				
				
		    </div>
		</article>
	</section>
</body>
</html>