<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
<script type="text/javascript" src="/js/common.js"></script>
<link rel="stylesheet" type="text/css" href="/css/sgb/common.css">

<style>
/*--------------------
toggle button
----------------------*/
.switch {
  position: relative;
  display: inline-block;
  width: 60px;
  height: 34px;
}

.switch input { 
  opacity: 0;
  width: 0;
  height: 0;
}

.slider {
  position: absolute;
  cursor: pointer;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: #ccc;
  -webkit-transition: .4s;
  transition: .4s;
}

.slider:before {
  position: absolute;
  content: "";
  height: 26px;
  width: 26px;
  left: 4px;
  bottom: 4px;
  background-color: white;
  -webkit-transition: .4s;
  transition: .4s;
}

input:checked + .slider {
  background-color: #2196F3;
}

input:focus + .slider {
  box-shadow: 0 0 1px #2196F3;
}

input:checked + .slider:before {
  -webkit-transform: translateX(26px);
  -ms-transform: translateX(26px);
  transform: translateX(26px);
}

/* Rounded sliders */
.slider.round {
  border-radius: 34px;
}

.slider.round:before {
  border-radius: 50%;
}

</style>

<%@ include file="../template/topMenu.jsp" %>
<%@ include file="../template/topNav.jsp" %>
	
	 <!-- content -->
    <div class="hamo_container">
        <div class="content_con">
            <h2>서버 환경 설정</h2>
            <ul class="location">
            </ul>

            <!-- content list -->
            <div class="con_box">
                <!-- 검색 -->
			<h2>도메인 관리</h2>
            	
                <div class="board_view2 mT20">
                <form method="post" id="addForm" class="form-inline col-md-12 row" style="display:none;">
					<input type="hidden" name="seq" id="seq" value=0> 
                    <table>
                        <colgroup>
                            <col style="width:7%;" />
                            <col style="width:10%;" />
                            <col style="width:7%;" />
                            <col style="width:13%;" />
                            <col style="width:7%;" />
                            <col style="width:10%;" />
                            <col />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th>서버명</th>
                                <td><input type="text" style="border:none;" name="svr_nm" id="svr_nm" class="input_type1" readonly></td>
                                <th>IP</th>
                                <td><input type="text" name="svr_ip" id="svr_ip" class="input_type1"></td>
                                <th>Port</th>
                                <td><input type="text" name="svr_port" id="svr_port" class="input_type1" style="width:150px" /></td>
                                <td class="t_right">
                                    <button type="button" class="btn_type3 btnAdd" >저장</button>
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
                            <col style="width:5%;" />
                            <col style="width:5%;" />
                            <col style="width:15%;" />
                            <col style="width:20%;" />
		                    <col style="width:10%;" />
		                    <col style="width:15%;" />
                        </colgroup>
                        <thead>
                            <tr>
                            	<th></th>
                                <th>번호</th>
                                <th>서버명</th>
                                <th>IP</th>
                                <th>Port</th>
                                <th>사용여부</th>

                            </tr>
                        </thead>
                        <tbody id="pageGrideInSvrlstListTb">
                        </tbody>
                    </table>
                </div><!-- //List -->
                <div class="mT20 inblock">
                    <button type="button" class="btn_type3" id="chkDel">선택삭제</button>
                </div>
                <!-- page number -->
                <div class="page_num">
                </div>
            </div><!-- //con_box -->

			<div class="con_box">
               <h2>프로그램 관리</h2>
 				<div class="board_list mT20">
                        <table>
                            <colgroup>
                                <col style="width:10%;" />
                                <col style="width:15%;" />
                                <col style="width:20%;" />
                                <col />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>번호</th>
                                    <th>프로그램명</th>
                                    <th>폴링 주기</th>
                                </tr>
                            </thead>
                            <tbody>
							</tbody>
                        </table>
                    </div><!-- //List -->
                   
			</div>



        </div>
    </div><!-- //content -->

	

	
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

function vpnCheck(val){
	var vpn_used = 0;
	console.log("val : "+val.value);
	if($("input:checkbox[id='vpn_used']").is(":checked")==true){
		if(confirm("vpn을 사용하시겠습니까?")==true){
			vpn_used = 1;
		}else{
			$("input:checkbox[id='vpn_used']").removeAttr('checked');
		}
	}else{
		if(confirm("vpn대신 공인IP 사용으로 변경하시겠습니까?")==true){
			vpn_used = 0;
		}else{
			$("input:checkbox[id='vpn_used']").prop("checked", true);
		}
	}


	$.ajax({
		url : '/admin/vpnUsed',
		type: 'POST',
		data: {svr_used:vpn_used,svr_nm:val.value},
		success : function(res) {
			if( res == 1 ){
				alert("vpn 사용여부가 변경되었습니다.");
				location.reload();
			}else{
				alert("vpn 사용여부 변경이 실패되었습니다. 관리자에게 문의바랍니다.");	
			}
		}
	}); 


}

function edit(seq,servernm,ip,port){
	var form = $('#addForm');
	console.log($("#seq").val());
	console.log(seq);
	if($("#seq").val()==seq){
		form.css('display','none');
		$("#seq").val("");
		$("#svr_nm").val("");
		$("#svr_ip").val("");
		$("#svr_port").val("");
		console.log($("#seq").val())
	}else{
				
		if(port == "null"){
			port = '';
		}

		form.css('display','block');
		$("#seq").val(seq);
		$("#svr_nm").val(servernm);
		$("#svr_ip").val(ip);
		$("#svr_port").val(port);
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
			console.log("value.svr_nm : "+value.svr_nm);
			
			console.log("value.svr_port : "+value.svr_port);
			
			gbInnerHtml += "<tr data-code='" + value.seq + "'>";
			gbInnerHtml += "<td><input type='checkbox' name='RowCheck' value='" + value.seq + "' style=\"display: -webkit-inline-box;\"></td>";
			gbInnerHtml += "<td><span>"+no+"</span></td>";
			gbInnerHtml += "<td><a style='color: steelblue;' href='#' onclick=\"edit("+value.seq+",'"+value.svr_nm+"','"+value.svr_ip+"','"+value.svr_port+"'); return false;\" >"+value.svr_nm+"</a></td>";
			gbInnerHtml += "<td>"+value.svr_ip+"</td>";
			
			if(value.svr_port != null ){
				if(value.svr_port !=''){
					gbInnerHtml += "<td>"+value.svr_port+"</td>";
				}else{
					gbInnerHtml += "<td>"+ "-" +"</td>";
				}
			}else{
				gbInnerHtml += "<td>"+ "-" +"</td>";
			}

			if(value.svr_nm =="vpnip"){
				console.log("svr_nm : "+value.svr_nm);
				console.log("svr_used : "+value.svr_used);

				if(value.svr_used==0){
					gbInnerHtml += "<td>"+"<label class='switch'>"+ "<input type='checkbox' id='vpn_used' name='svr_used' value='"+value.svr_nm+"' onClick='vpnCheck(this)'><span class='slider round'></span>"+"</label>"+"</td>";
				}else{
					gbInnerHtml += "<td>"+"<label class='switch'>"+ "<input type='checkbox' checked id='vpn_used' name='svr_used' value='"+value.svr_nm+"' onClick='vpnCheck(this)'><span class='slider round'></span>"+"</label>"+"</td>";
				}

				
			}else{
				gbInnerHtml += "<td>"+"</td>";
			}
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
    if (check) {
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