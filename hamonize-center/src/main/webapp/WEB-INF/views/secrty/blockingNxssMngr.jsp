<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>
<script type="text/javascript" src="/js/common.js"></script>

<body>
<%@ include file="../template/topMenu.jsp" %>
<%@ include file="../template/topNav.jsp" %>	
	<!-- content -->
    <div class="hamo_container">
        <div class="content_con">
            <!-- content list -->
            <div class="con_box">
               <h2>유해사이트 관리</h2>
                <ul class="location">
                    <li>Home</li>
                    <li>Location</li>
                    <li>Location</li>
                </ul>
                <div class="w100">
         			<form class="form-inline col-md-5" action="" id="forwardDomainForm">
                    <label for="forwardDomain">유해사이트 접속 시 이동할 사이트</label> 
                    <input type="text" name="forwardDomain" id="forwardDomain" class="input_type1" style="width:300px;" placeholder="http:// "/>
                    <label class="mL20" for="forwardDomain">유해사이트 접속 시 알람 메세지</label> 
                    <input type="text" name="forwardNotice" id="forwardNotice" class="input_type1" style="width:300px;" placeholder="차단시 메세지를 입력해주세요."/>
                    <button type="button" id="updateForwardDomain" class="btn_type3"> 변경저장</button>
                  </form>
                </div>
                
              	<!-- 검색 -->
                <div class="top_search">
         			<form class="form-inline col-md-5" action="">
						<select id="keyWord" name="keyWord" title="keyWord" class="sel_type1">
							<option value="0">전체</option>
							<option value="1">주소</option>
							<option value="2">정보</option>
						</select>
						<label for="txtSearch"></label>
						<input type="text" name="txtSearch" id="txtSearch" class="input_type1" />
						<button type="button" class="btn_type3" onclick="javascript:getList();"> 검색</button>
					</form>
                </div>
            	<!-- //검색 -->

                <div class="board_view mT20">
					<form id="addForm" class="form-inline col-md-12 row" action="" style="display:none;">
						<table>
							<colgroup>
								<col style="width:10%;" />
								<col style="width:40%;" />
								<col style="width:10%;" />
								<col style="width:30%;" />
								<col />
							</colgroup>
							<tbody>
								<tr>
									<th>주소(URL)</th>
										<td>
											<input id="blockingAddress" name="blockingAddress" class="input_type1" type="text">
										</td>
									<th>정보</th>
									<td>
										<input id="infomation" name="infomation" class="input_type1" type="text" data-length="10">
									</td>
									<td class="t_right">
										<button type="button" id="addAddress" class="btn_type3"> 등록 </button>
									</td>
								</tr>
							</tbody>
						</table>
					</form>
                </div>
                
				<input type="hidden" id="mngeListInfoCurrentPage" name="mngeListInfoCurrentPage" value="1">
                
				<div class="board_list mT20">
                   <table>
                       <colgroup>
                           <col style="width:10%;" />
                           <col style="width:10%;" />
                           <col style="width:40%;" />
                           <col />
                       </colgroup>
                       <thead>
						<tr>
							<th><input type="checkbox" id="ck_all"><label for="ck_all" >전체</label></th>
							<th>번호</th>
							<th>주소(URL)</th>
							<th>정보</th>
						</tr>
                       </thead>
                       <tbody id="pageGrideInMngrListTb">
                       </tbody>
                   </table>
                </div><!-- //List -->

                <div class="mT20 inblock">
                    <button type="button" id="deleteAddress" class="btn_type3">삭제</button>
                </div>
                <div class="right mT20">
                    <button type="button" class="btn_type2 insertBtn">사이트 관리</button>
                </div>

                <!-- page number -->
                <div class="page_num">
                </div>
            </div><!-- //con_box -->

        </div>
    </div><!-- //content -->
	
<script type="text/javascript">
var blockingNxssGetSuccess = function(data, status, xhr, groupId){
var gbInnerHtml = "";
var classGroupList = data.list;
	
	$('#pageGrideInMngrListTb').empty();
	
	if( data.list.length > 0 ){
		$.each(data.list, function(index, value) {
			var no = data.pagingVo.totalRecordSize -(index ) - ((data.pagingVo.currentPage-1)*10);

			gbInnerHtml += '<tr data-code=' + value.seq + '>';
			gbInnerHtml += '<td><input type="checkbox" name="' + value.seq + '" id="' + value.seq + '"><label for="' + value.seq + '" ></label></td>';
			gbInnerHtml += '<td>' + no + '</td>';
			gbInnerHtml += '<td>' + value.domain + '</td>';
			gbInnerHtml += '<td>' + value.info + '</td>';
			gbInnerHtml += '</tr>';
		});	 
	}else{ 
		gbInnerHtml += "<tr><td colspan='5'>등록된 정보가 없습니다. </td></tr>";
	}
	
	startPage = data.pagingVo.startPage;
	endPage = data.pagingVo.endPage; 
	totalPageSize = data.pagingVo.totalPageSize;
	currentPage = data.pagingVo.currentPage;
	totalRecordSize = data.pagingVo.totalRecordSize;
	
	var viewName='classMngrList';
	if(totalRecordSize > 0){
		$(".page_num").html(getPaging(startPage,endPage,totalPageSize,currentPage,'\''+viewName+'\''));
	}
	$('#pageGrideInMngrListTb').append(gbInnerHtml);
}


$(document).ready(function() {
	setNav('정책관리 > 유해사이트관리');
	// 전체선택
	$('#ck_all').click(function(){
		if($(this).prop('checked')) $('#pageGrideInMngrListTb input[type="checkbox"]').prop('checked', true);
		else $('#pageGrideInMngrListTb input[type="checkbox"]').prop('checked', false);
	});

	$("#txtSearch").keydown(function(key) {
		if (key.keyCode == 13) {
			key.preventDefault();
			getList();
		}
	});


	$('#portfolio-grid').on('click', '.thumbnail', function() {
		$("#ri_no").val($(this).data("code"));	
		$("#no").val($(this).data("code"));
		$("#vierFrm").submit();
	});
	
	
	// 변경 버튼 - 포워딩
	$('#updateForwardDomain').on('click', function(){
		var forwardDomain = $('#forwardDomain').val();
		var forwardNotice = $('#forwardNotice').val();
		
		// 검증
		if(forwardDomain.length  <= 0){
			alert("차단시 이동할 주소를 입력해 주세요.");
			return;
		}
		if(forwardNotice.length  <= 0){
			alert("차단시 메세지를 입력해 주세요.");
			return;
		}
		
		
		// 변경
		$.ajax({
			url : '/gplcs/updateBlockingNxssDomain.proc',
			type: 'POST',
			data: $('#forwardDomainForm').serialize(),
			success : function(res) {
				if( res.success == true ){
					alert("정상적으로 등록되었습니다.");
					getList();
		        	getForwardDomain();
				}else{
					alert("등록되지 않았습니다.");
				}
			},
			error:function(request,status,error){
				console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}
		}); 
	});
	
	
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
	$('#addAddress').on('click', function(){
		addAddressFnt();
	});
	
	// 삭제 버튼
	$('#deleteAddress').on('click', function(){
		deleteAddressFnt();
	});



	getList(); // 목록
	getForwardDomain(); // 포워딩
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
		case 'classMngrList' : $("#mngeListInfoCurrentPage").val(page); getList(); break;	//	공지사항
	default :
	}
}

// 입력폼 초기화
function fromReset(){
	$('#blockingAddress').val('');
	$('#infomation').val('');
}

function getForwardDomain(){
	var url ='/gplcs/getForwardDomain.proc';
	
	function fnt(data, status, xhr, groupId){
		if(data.success == true){ 
			$('#forwardDomain').val(data.forwardDomain);
			$('#forwardNotice').val(data.forwardNotice);
		}
	}
	
	callAjax('GET', url, null, fnt, getError, 'json');
}

function getList(){
	var url ='/gplcs/blockingNxssMngrList.proc';
	var keyWord = $("select[name=keyWord]").val();
	var vData = 'mngeListInfoCurrentPage=' + $("#mngeListInfoCurrentPage").val() +"&keyWord="+ keyWord + "&txtSearch=" + $("#txtSearch").val();
	callAjax('POST', url, vData, blockingNxssGetSuccess , getError, 'json');
}

function getListAddDeleteVer(){
	var url ='/gplcs/blockingNxssMngrList.proc';	
	var keyWord = $("select[name=keyWord]").val();
	var vData = 'mngeListInfoCurrentPage=' + $("#mngeListInfoCurrentPage").val() +"&keyWord="+ keyWord + "&txtSearch=" + $("#txtSearch").val();
	
	function fnt(data, status, xhr, groupId){ 
		blockingNxssGetSuccess(data, status, xhr, groupId); 
		$('.mdl-data-table__cell--non-numeric .form-control').css('opacity', '1');
	}
	
	callAjax('POST', url, vData, fnt, getError, 'json');
}

//삭제 버튼
function deleteAddressFnt(){
	var iptArr = $('#pageGrideInMngrListTb input[type=checkbox]:checked');
	var addressArr = [];

	// 검증
	$.each(iptArr, function(idx, ipt){
		addressArr.push($(ipt).parent().parent().attr('data-code'));
	});
	
	if(0 >= addressArr.length){
		alert("삭제할 사이트를 선택해 주시기 바랍니다.");
		return false;
	}
	
	
	
	function ftn(data, status, xhr, groupId){
		alert("정상적으로 삭제되었습니다.");
		deleteBlockingNxssSuccess(data, status, xhr, groupId);
	}
	
	// 전송
	var url = '/gplcs/deleteBlockingNxss.proc';
	var vData = "deleteAdressList=" + addressArr;
	callAjax('POST', url, vData, ftn, getError, 'json');
}
//등록 버튼
function addAddressFnt(){
	var blockingAddress = $('#blockingAddress').val();
	var info = $('#infomation').val();
	
	// 검증
	if(blockingAddress.length  <= 0){
		alert("차단할 주소를 입력해 주세요.");
		return;
	}

	if(info.length  <= 0){
		alert("정보를 입력해 주세요.");
		return;
	}
		
	// 전송
	$.ajax({
		url : '/gplcs/addBlockingNxss.proc',
		type: 'POST',
		data: $('#addForm').serialize(),
		success : function(res) {
			if( res.success == true ){
				alert("정상적으로 등록되었습니다.");
				getListAddDeleteVer();
	        	fromReset();
			}else{
				alert("등록되지 않았습니다.");
			}
		},
		error:function(request,status,error){
			console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		}
	}); 
}

</script>
		<%@ include file="../template/footer.jsp" %>
</body>
</html>
