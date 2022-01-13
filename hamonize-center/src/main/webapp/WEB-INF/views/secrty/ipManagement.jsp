<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>

<!-- <link rel="stylesheet" type="text/css" href="/css/notice/notice.css" />
<link rel="stylesheet" type="text/css" href="/css/template/bootstrap4.css" /> -->

<!-- <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script> -->
<script type="text/javascript" src="/js/common.js"></script>


<!-- <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/js/materialize.min.js"></script> -->
<!-- <link rel="stylesheet" href="/css/materialize.css"> -->
<!-- <script src="/js/materialize.js"></script> -->


<!-- jquery alert -->
<!-- <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jquery-confirm/3.3.2/jquery-confirm.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-confirm/3.3.2/jquery-confirm.min.js"></script> -->


<style> 
 /* #element_to_pop_up { 
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
/* .input-field { margin: 0 !important } 

#pageGrideInMngrListTb .mdl-data-table__cell--non-numeric input {
	display: inline-block;
	margin-left: 5px;
	opacity: 0;
	pointer-events: unset;
	position: unset;
	height: 20px;
	width: 20px;
} */
</style>

<body>
	<%@ include file="../template/topMenu.jsp" %>
	
	
	
	<!-- content -->
    <div class="hamo_container">
        <div class="content_con">

            <!-- content list -->
            <div class="con_box">
              <div class="w100">
                <h2>사이트IP 관리</h2>
                <ul class="location"></ul>
              </div> 
              
                <!-- 검색 -->
                <div class="top_search">
                    <select id="keyWord" name="keyWord" title="keyWord" class="sel_type1">
                        <option value="0">전체</option>
                        <option value="1">IP</option>
                        <option value="2">정보</option>
                    </select>
                    <label for="txtSearch"></label><input type="text" name="txtSearch" id="txtSearch" class="input_type1" />
                    <button type="button" class="btn_type3" onclick="javascript:getList();"> 검색</button> 
                </div><!-- //검색 -->
              
               
                <div class="board_view2 mT20 w100" id="insert">
                <form id="addForm" class="form-inline col-md-12 row" action="" style="display:none; width: 100%">
					<input id="sma_gubun" name="sma_gubun" type="hidden" value="Y">
                    <table>
                        <colgroup>
                            <col style="width:13%;" />
                            <col style="width:36%;" />
                            <!-- <col style="width:10%;" /> -->
                            <col style="width:15%;" />
                            <col style="width:5%;" />
                            <col />
                            <col style="width:10%;" />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th>IPAddress</th>
                                <td>
                                <input id="ip1" name="ip1" type="text" maxlength="3" style="width:40px" class="input_type1"/>
								  	<input id="ip2" name="ip2" type="text" maxlength="3" style="width:40px" class="input_type1"/>
								  	<input id="ip3" name="ip3" type="text" maxlength="3" style="width:40px" class="input_type1"/>
								  	<input id="ip4" name="ip4" type="text" maxlength="3" style="width:40px" class="input_type1"/>
								  	<input id="ipaddress" name="ipaddress" type="hidden" value="" />
                                </td>
                                <!-- <th>MacAddress</th>
                                <td>
                                	<input id="macaddress" name="macaddress" type="text" class="input_type1"/>
                                </td> -->
                                <th>정보</th>
                                <td><input id="infomation" name="infomation" type="text" class="input_type1"/></td>
                                <td class="t_right">
                                    <button type="button" id="addAddress" class="btn_type3">등록</button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    </form>
                </div><!-- //List -->
					<input type="hidden" id="mngeListInfoCurrentPage" name="mngeListInfoCurrentPage" value="1">

                <div class="board_list mT20">
                    <table>
                        <colgroup>
                        	<col style="width:5%;" />
                            <col style="width:8%;" />
                            <col style="width:35%;" />
                            <!-- <col style="width:35%;" /> -->
                            <col />
                        </colgroup>
                        <thead>
                            <tr>
                            	<th>선택</th>
                                <th>번호</th>
                                <th>IP</th>
                               <!--   <th>MacAddress</th>-->
                                <th>정보</th>
                            </tr>
                        </thead>
                        <tbody id="pageGrideInMngrListTb"></tbody>
                    </table>
                </div><!-- //List -->
                <div class="mT20 inblock">
                    <button type="button" class="btn_type3" id="deleteAddress">선택삭제</button>
                </div>
                <div class="right mT20">
                    <button type="button" class="btn_type3 insertBtn">IP 관리</button>
                </div>

                <!-- page number -->
                <div class="page_num">
                </div>
            </div><!-- //con_box -->

        </div>
    </div><!-- //content -->
	
	<!-- content body -->
	<!-- <section class="contentLayer">
	
		<article>
			<div class="code-html">
			<div class=" contents">
				<p id="contentTitle">사이트IP관리</p>
				
				<hr/>
				
				<div class="row">
		        	<form class="form-inline col-md-5" action="">
			  			<div class="input-field s3 mb-4 mr-sm-4">
						  	<input type="searchTitle" class="form-control mb-1 mr-sm-1" id="email">
						  	<input id="searchTitle" name="searchTitle" type="text" data-length="10" style="width:280px;">
			            	<label for="searchTitle" class="mb-4 mr-sm-4">검색 IP :</label>
			            	<button type="submit" class="btn btn-info mb-1">검색</button>
			          	</div>
					</form>
					
					<div class="col-md-5"></div>
					
					<div id="managementDiv" class="col-md-2">
						<input type="button" value="관리" class="btn insertBtn" style="width: 100%">
					</div>
					
					
					<form id="addForm" class="form-inline col-md-12 row" action="">
					<input id="sma_gubun" name="sma_gubun" type="hidden" value="Y">
			  			<div class="input-field s3 mb-4 mr-sm-4">
						  	<input id="ip1" name="ip1" type="text" data-length="3" style="width:40px;" >
						  	<input id="ip2" name="ip2" type="text" data-length="3" style="width:40px;">
						  	<input id="ip3" name="ip3" type="text" data-length="3" style="width:40px;">
						  	<input id="ip4" name="ip4" type="text" data-length="3" style="width:40px;">
						  	<input id="ipaddress" name="ipaddress" type="hidden" value="">
			            	<label for="ipaddress" class="mb-4 mr-sm-4" style="top: -20px;">IPAddress</label>
			          	</div>
			          	
			  			<div class="input-field s3 mb-4 mr-sm-4">
						  	<input id="macaddress" name="macaddress" type="text" data-length="10">
			            	<label for="macaddress" class="mb-4 mr-sm-4">MacAddress</label>
			          	</div>
			          	
			  			<div class="input-field s3 mb-4 mr-sm-4">
						  	<input id="infomation" name="infomation" type="text" data-length="10">
			            	<label for="infomation" class="mb-4 mr-sm-4" style="top: -20px;">정보</label>
			          	</div>
		            	<input type="button" id="addAddress" class="btn btn-info mb-1" value="등록">
						
						<div class="col-md-2">
							<input type="button" id="deleteAddress" class="btn btn-info mb-1" value="삭제">
						</div>
					</form>
		        </div>
				
				
				
				<div class="table-responsive" id="grid">
					<table data-toggle="table" id="dataTable" width="100%" cellspacing="0" border=0 class="table table-striped table-bordered" >
						<thead>
						<tr class="filters">
	                        <th><input type="text" class="form-control" placeholder="번호" disabled></th>
	                        <th><input type="text" class="form-control" placeholder="IP" disabled></th>
	                        <th><input type="text" class="form-control" placeholder="Mac" disabled></th>
	                        <th><input type="text" class="form-control" placeholder="정보" disabled></th>
	                        <th><input type="text" class="form-control" placeholder="등록일시" disabled></th>
	                    </tr>
		        		</thead>
						<tbody id="pageGrideInMngrListTb">
							<input type="hidden" id="notiListCurrentPage" name="notiListCurrentPage" value="1" class="form-control" >
						</tbody>
					</table>
				</div>
				
				페이징
				<ul class="pagination" id="pagginationInMngrList"></ul>
				
				
		    </div>
		</article>
	</section> -->
	
	
	
<script type="text/javascript">
setNav('정책관리 > 사이트IP관리');

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
			getList();
		}
	});
	// 관리 버튼
	$('.insertBtn').on('click', function(){
		var ipt = $('#insert');
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



	getList();
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
	$('#ipaddress').val('');
	$('#macaddress').val('');
	$('#infomation').val('');
	$('#ip1').val('');
	$('#ip2').val('');
	$('#ip3').val('');
	$('#ip4').val('');
}


function getList(){
	var url ='/gplcs/ipManagementList.proc';
	
	var keyWord = $("select[name=keyWord]").val();
	var vData = 'mngeListInfoCurrentPage=' + $("#mngeListInfoCurrentPage").val() +"&keyWord="+ keyWord + "&txtSearch=" + $("#txtSearch").val();
	callAjax('POST', url, vData, ipMngrGetSuccess , getError, 'json');
}

// 사이트IP관리 리스트
var ipMngrGetSuccess = function(data, status, xhr, groupId){
	var gbInnerHtml = "";
	var classGroupList = data.list;
	
	$('#pageGrideInMngrListTb').empty();
	
	if( data.list.length > 0 ){
		$.each(data.list, function(index, value) {
			var no = data.pagingVo.totalRecordSize -(index ) - ((data.pagingVo.currentPage-1)*10);
			
			gbInnerHtml += "<tr data-code='" + value.sma_seq + "'>";
			gbInnerHtml += "<td class='t_left'>";
			gbInnerHtml += "<input type='checkbox' name='' id="+no+" class='form-control'><label for="+no+" class='dook'></label></td>";
			gbInnerHtml += "<td>"+no+"</td>";
			gbInnerHtml += "<td>"+value.sma_ipaddress+"</td>";
			//gbInnerHtml += "<td>"+value.sma_macaddress+"</td>";
			gbInnerHtml += "<td>"+value.sma_info+"</td>";
			gbInnerHtml += "</tr>";
			
			/*gbInnerHtml += "<tr data-code='" + value.sma_seq + "'>";
			gbInnerHtml += "<td class='mdl-data-table__cell--non-numeric'><span>"+no+"</span>";
			gbInnerHtml += '<input type="checkbox" class="form-control"></td>';
			gbInnerHtml += "<td class='mdl-data-table__cell--non-numeric'>"+value.sma_ipaddress+"</td>";
			gbInnerHtml += "<td class='mdl-data-table__cell--non-numeric'>"+value.sma_macaddress+"</td>";
			gbInnerHtml += "<td class='mdl-data-table__cell--non-numeric'>"+value.sma_info+"</td>";
			gbInnerHtml += "<td class='mdl-data-table__cell--non-numeric'>"+value.sma_insert_dt+"</td>";
			gbInnerHtml += "</tr>";*/
		});	 
	}else{ 
		gbInnerHtml += "<tr><td colspan='5'>등록된 정보가 없습니다. </td></tr>";
	}
	
	var startPage = data.pagingVo.startPage;
	var endPage = data.pagingVo.endPage; 
	var totalPageSize = data.pagingVo.totalPageSize;
	var currentPage = data.pagingVo.currentPage;
	var totalRecordSize = data.pagingVo.totalRecordSize;
	
	console.log(startPage);
	console.log(endPage);
	console.log(totalPageSize);
	console.log(currentPage);
	console.log(totalRecordSize);
	
	var viewName='classMngrList';
	if(totalRecordSize > 0){
		$(".page_num").html(getPaging(startPage,endPage,totalPageSize,currentPage,'\''+viewName+'\''));
	}
	$('#pageGrideInMngrListTb').append(gbInnerHtml);
}

function getListAddDeleteVer(){
	var url ='/gplcs/ipManagementList.proc';
	
	var keyWord = $("select[name=keyWord]").val();
	var vData = 'mngeListInfoCurrentPage=' + $("#mngeListInfoCurrentPage").val() +"&keyWord="+ keyWord + "&txtSearch=" + $("#txtSearch").val();
	
	function fnt(data, status, xhr, groupId){ 
		ipMngrGetSuccess(data, status, xhr, groupId); 
		$('.mdl-data-table__cell--non-numeric .form-control').css('opacity', '1');
	}
	
	callAjax('POST', url, vData, fnt, getError, 'json');
}




// 등록 버튼
function addAddressFnt(){
	var ip = $('#ip1').val()+"."+$('#ip2').val()+"."+$('#ip3').val()+"."+$('#ip4').val();
	var mac = $('#macaddress').val();
	var info = $('#infomation').val();
	$("#ipaddress").val(ip);
	
	// 검증
	if(ip.length  <= 0 ){
		alert("IP 주소를 입력해 주세요.");
		/* $.alert({
		    title: 'Alert!',
		    content:  'IP 혹은 Mac 주소를 입력해 주세요!',
		    buttons: {
		        확인: function(){
		        }
		    }
		}); */
		return;
	}

	/* if(mac.length  <= 0 ){
		alert("mac 주소를 입력해 주세요.");
		/* $.alert({
		    title: 'Alert!',
		    content:  'IP 혹은 Mac 주소를 입력해 주세요!',
		    buttons: {
		        확인: function(){
		        }
		    }
		}); 
		return;
	} */

	if(info.length  <= 0){
		alert("정보를 입력해 주세요.");
		/* $.alert({
		    title: 'Alert!',
		    content:  '정보를 입력해 주세요!',
		    buttons: {
		        확인: function(){
		        }
		    }
		}); */
		return;
	}
	
	
	// 전송
	$.ajax({
		url : '/gplcs/ipManagement.proc',
		type: 'POST',
		data: $('#addForm').serialize(),
		success : function(res) {
			if( res.success == true ){
				alert("정상적으로 등록되었습니다.");
				getListAddDeleteVer();
	        	fromReset();
				/* $.alert({
				    title: 'Alert!',
				    content:  res.msg + '!',
				    buttons: {
				        확인: function(){
				        	getListAddDeleteVer();
				        	fromReset();
				        }
				    }
				}); */
			}else{
				alert("등록되지 않았습니다.");
				/* $.alert({
				    title: 'Alert!',
				    content:  res.msg + '!',
				}); */
			}
		},
		error:function(request,status,error){
			console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		}
	}); 
}


// 삭제 버튼
function deleteAddressFnt(){
	var iptArr = $('.form-control:checked');
	var addressArr = [];

	// 검증
	$.each(iptArr, function(idx, ipt){
		addressArr.push($(ipt).parent().parent().attr('data-code'));
	});
	
	if(0 >= addressArr.length){
		alert("삭제할 주소를 선택해 주시기 바랍니다.");
		/* $.alert({
		    title: 'Alert!',
		    content:  '삭제할 주소를 선택해 주시기 바랍니다!',
		    buttons: {
		        확인: function(){
		        }
		    }
		}); */
		return;
	}
	
	
	
	function ftn(data, status, xhr, groupId){
		alert("정상적으로 삭제되었습니다.");
		location.reload();
		/* $.alert({
		    title: 'Alert!',
		    content:  '정상적으로 삭제되었습니다!',
		    buttons: {
		        확인: function(){
			        location.reload();
		        	//deleteIpSuccess(data, status, xhr, groupId);
		        }
		    }
		}); */
	}
	
	// 전송
	var url = '/gplcs/deleteIpManagement.proc';
	var vData = "deleteAdressList=" + addressArr;
	callAjax('POST', url, vData, ftn, getError, 'json');
}


</script>
	<%@ include file="../template/footer.jsp" %>
</body>
</html>
