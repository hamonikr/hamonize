<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>


<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
<script type="text/javascript" src="/js/common.js"></script>




 <style> 
/* .contentLayer {
  max-width: 1000px;
  margin: 0 auto;
}  */
</style>

<body>

	<%@ include file="../template/topMenu.jsp" %>
	<%@ include file="../template/topNav.jsp" %>
	
	
	 <!-- content -->
    <div class="hamo_container">
        <div class="content_con">

            <h2>서버관리</h2>
            <ul class="location">
            </ul>

            <!-- content list -->
            <div class="con_box">
                <!-- 검색 -->
                <div class="top_search">
                    <select id="" name="" title="" class="sel_type1">
                        <option value="">전체</option>
                        <option value="">-</option>
                    </select>
                    <label for=""></label><input type="text" name="" id="" class="input_type1" />
                    <button type="button" class="btn_type3"> 검색</button>
                </div><!-- //검색 -->
                <div class="board_view2 mT20">
                <form method="post" id="addForm" class="form-inline col-md-12 row" style="display:none;">
                    <table>
                        <colgroup>
                            <col style="width:7%;" />
                            <col style="width:10%;" />
                            <col style="width:7%;" />
                            <col style="width:13%;" />
                            <col style="width:7%;" />
                            <col style="width:13%;" />
                            <col style="width:7%;" />
                            <col style="width:10%;" />
                            <col />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th>서버명</th>
                                <td><input type="text" name="svr_nm" id="svr_nm" class="input_type1"></td>
                                <th>도메인</th>
                                <td><input type="text" name="svr_domain" id="svr_domain" class="input_type1"></td>
                                <th>IP</th>
                                <td><input type="text" name="svr_ip" id="svr_ip" class="input_type1"></td>
                                <th>Port</th>
                                <td><input type="text" name="svr_port" id="svr_port" class="input_type1" style="width:150px" /></td>
                                <td class="t_right">
                                    <button type="button" class="btn_type3 btnAdd" >등록</button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    </form>
                </div><!-- //List -->

				<input type="hidden" id="svrlstInfoCurrentPage" name="svrlstInfoCurrentPage" value="1" >
                <div class="board_list mT20">
                    <table>
                        <colgroup>
                            <col style="width:10%;" />
                            <col style="width:10%;" />
                            <col style="width:15%;" />
                            <col style="width:10%;" />
                            <col style="width:20%;" />
                            <col />
                        </colgroup>
                        <thead>
                            <tr>
                            	<th></th>
                                <th>번호</th>
                                <th>서버명</th>
                                <th>도메인</th>
                                <th>IP</th>
                                <th>Port</th>
                                <th>등록일</th>
                            </tr>
                        </thead>
                        <tbody id="pageGrideInSvrlstListTb">
                        </tbody>
                    </table>
                </div><!-- //List -->
                <div class="mT20 inblock">
                    <button type="button" class="btn_type3" id="chkDel">선택삭제</button>
                </div>
                <div class="right mT20">
                    <button type="button" class="btn_type2 insertBtn"> 서버 등록</button>
                </div>
                <!-- page number -->
                <div class="page_num">
                </div>
            </div><!-- //con_box -->
        </div>
    </div><!-- //content -->
	
	<!-- content body -->
	<!--  <section class="contentLayer">
	

		<article>
			<div class="code-html">
				    
				<hr/>
		  				
				<input type="button" value="서버등록" id="btnAdd" class="btn insertBtn " style="float: right;">
		        
				<div class="table-responsive" id="grid">
					<input type="hidden" id="svrlstInfoCurrentPage" name="svrlstInfoCurrentPage" value="1" >
					<table data-toggle="table" id="dataTable" width="100%" cellspacing="0" border=0 class="table table-striped table-bordered" >
						<thead>
						<tr class="filters">
	                        <th width="15%">
	                        	<input id="allCheck" type="checkbox" onclick="allChk(this);" style="display: -webkit-inline-box;"/>
	                        	<input type="button" class="" value="삭제" id="chkDel" >
	                        </th>
	                        <input type="text" class="form-control"  >
	                        <th><input type="text" class="form-control" placeholder="번호" disabled></th>
	                        <th><input type="text" class="form-control" placeholder="서버명" disabled></th>
	                        <th><input type="text" class="form-control" placeholder="도메인" disabled></th>
	                        <th><input type="text" class="form-control" placeholder="IP" disabled></th>
	                        <th><input type="text" class="form-control" placeholder="등록일" disabled></th>
	                    </tr>
		        		</thead>
						<tbody id="pageGrideInSvrlstListTb">
							<div id="addInputLayer" style="display:none; float: right;">
							<br>
								<form method="post">
								서버명:<input type="text" name="svr_nm" id="svr_nm"> 
								도메인:<input type="text" name="svr_domain" id="svr_domain"> 
								IP:<input type="text" name="svr_ip" id="svr_ip">
								port:<input type="text" name="svr_port" id="svr_port">
								
           		 				<input type="button" class="btnAdd" value="등록">
           		 				<input type="button" class="btnCancle" value="취소">
           		 				</form>
							</div>
						</tbody>
					</table>
				</div>
				
				페이징
				<ul class="pagination" id="pagginationInSvrlstList"></ul>
				
				
		    </div>
		</article>
	</section> -->
	
	

	
<script type="text/javascript">
$(document).ready (function () {                
    $('#btnAdd').click (function () {                                        
    	if($("#addInputLayer").css("display") == "none"){   
            $('#addInputLayer').css("display", "block");   
        } else {  
            $('#addInputLayer').css("display", "none");   
        }  
    }); // end click    
    $('.btnCancle').click (function () {
    	$("#svr_nm").val('');
    	$("#svr_domain").val('');
    	$("#svr_ip").val('');
    	$("#svr_port").val('');
    	$('#addInputLayer').css("display", "none");   
    }); // end click    
    
    $('.btnAdd').click (function () {
    	$.ajax({
			url : '/admin/serverlistInsert.proc',
			type: 'POST',
			data:$("form").serialize(),
			success : function(res) {
				if( res.success == true ){
					$("#svr_nm").val('');
			    	$("#svr_domain").val('');
			    	$("#svr_ip").val('');
			    	$("#svr_port").val('');
			    	$('#addInputLayer').css("display", "none");   
			    	
					getList();
				}else{
					
				}
			},
			error:function(request,status,error){
				console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}
		}); 
    }); // end click     
 // 관리 버튼
	$('.insertBtn').on('click', function(){
		var ipt = $('#insert');
		var form = $('#addForm');
		if(form.css('display') == 'none') {
			form.css('display', 'block');
			ipt.css('opacity', '1');
		}else{
			form.css('display', 'none');
			ipt.css('opacity', '0');
			fromReset();
		}
	});
    
    //선택삭제
    $('#chkDel').click(function() {
    	var indexid = false;
		var checkRow = "";
    	
		$( "input[name='RowCheck']:checked" ).each (function (){
    		checkRow = checkRow + $(this).val()+"," ;
    		indexid = true;
    	});
    	checkRow = checkRow.substring(0,checkRow.lastIndexOf( ","));
		if(!indexid){
			alert("삭제할 데이터를 체크해 주세요");
			return;
		}
		
    	var agree=confirm("삭제 하시겠습니까?");
		if (agree){
			var $form = $('<form></form>').attr('action','/admin/serverlistDelete.proc').attr('method','POST');
			var $ipt = $('<input type="text" name="chkdel" id="chkdel"></input').val(checkRow);
			$form.append($ipt).appendTo('form').submit();
		} 
		
	});
    
    
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
	
	getList();
	
	
});

//입력폼 초기화
function fromReset(){
	$('#svr_nm').val('');
	$('#svr_domain').val('');
	$('#svr_ip').val('');
	$('#svr_port').val('');
	}

/*
 * 이전 페이지
 */
function prevPage(viewName, currentPage){
	var page = eval(currentPage) - 1;

		if(page < 1){
			page = 1;
		}
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
}

function searchView(viewName, page){
		switch(viewName){
			case 'classMngrList' :  $("#svrlstInfoCurrentPage").val(page); getList(); break;
		default :
		}
	}

function getList(){
	var url ='/admin/serverlist.proc';
	var keyWord = $("select[name=keyWord]").val();
	var vData = 'svrlstInfoCurrentPage=' + $("#svrlstInfoCurrentPage").val() +"&keyWord="+ keyWord + "&txtSearch=" + $("#txtSearch").val();
	callAjax('POST', url, vData, svrlstGetSuccess, getError, 'json');
}


var svrlstGetSuccess = function(data, status, xhr, groupId){
	var gbInnerHtml = "";
	var classGroupList = data.list;
	$('#pageGrideInSvrlstListTb').empty();
	
	if( data.list.length > 0 ){
		$.each(data.list, function(index, value) {
			var no = data.pagingVo.totalRecordSize -(index ) - ((data.pagingVo.currentPage-1)*10);
			
			gbInnerHtml += "<tr data-code='" + value.seq + "'>";
			gbInnerHtml += "<td><input type='checkbox' name='RowCheck' value='" + value.seq + "' style=\"display: -webkit-inline-box;\"></td>";
			gbInnerHtml += "<td><span>"+no+"</span></td>";
			gbInnerHtml += "<td>"+value.svr_nm+"</td>";
			gbInnerHtml += "<td>"+value.svr_domain+"</td>";
			gbInnerHtml += "<td>"+value.svr_ip+"</td>";
			gbInnerHtml += "<td>"+value.svr_port+"</td>";
			gbInnerHtml += "<td>"+value.insert_dt+"</td>";
			gbInnerHtml += "</tr>";
		});	 
	}else{ 
		gbInnerHtml += "<tr><td colspan='6'>등록된 정보가 없습니다. </td></tr>";
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
	$('#pageGrideInSvrlstListTb').append(gbInnerHtml);
}

function allChk(obj){
    var chkObj = document.getElementsByName("RowCheck");
    var rowCnt = chkObj.length - 1;
    var check = obj.checked;
    if (check) {﻿
        for (var i=0; i<=rowCnt; i++){
         if(chkObj[i].type == "checkbox")
             chkObj[i].checked = true; 
        }
    } else {
        for (var i=0; i<=rowCnt; i++) {
         if(chkObj[i].type == "checkbox"){
             chkObj[i].checked = false; 
         }
        }
    }
} 
</script>

</body>
</html>