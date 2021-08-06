<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>


<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
<script type="text/javascript" src="/js/common.js"></script>


<link rel="stylesheet" href="/css/materialize.css">
<script src="/js/materialize.js"></script>
<link href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">


<!-- jquery alert -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jquery-confirm/3.3.2/jquery-confirm.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-confirm/3.3.2/jquery-confirm.min.js"></script>
<link href='http://fonts.googleapis.com/css?family=Bitter' rel='stylesheet' type='text/css'>


<%@ include file="../template/backupRecoveryHead.jsp" %>

<style type="text/css">
.form-style-10{
	width:100%;
	padding:20px;
	margin:40px auto;
	background: #FFF;
	border-radius: 10px;
	-webkit-border-radius:10px;
	-moz-border-radius: 10px;
	box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.13);
	-moz-box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.13);
	-webkit-box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.13);
}
.form-style-10 .inner-wrap{
	padding: 30px;
	background: #F8F8F8;
	border-radius: 6px;
	margin-bottom: 15px;
}

.form-style-10 .section{
	color: #2A88AD;
	margin-bottom: 5px;
}
.form-style-10 .section span {
	background: #2A88AD;
	padding: 5px 10px 5px 10px;
	position: absolute;
	border-radius: 50%;
	-webkit-border-radius: 50%;
	-moz-border-radius: 50%;
	border: 4px solid #fff;
	font-size: 14px;
	margin-left: -45px;
	color: #fff;
	margin-top: -3px;
}

.lnb {
	width: 100%;
	border-right: 0;
}

#tree { padding-top: 0; }

#tree .tui-checkbox { display: inline-block }
.lnb .search-container { display: block }
</style>

<script type="text/javascript">
var data = <%= request.getAttribute("gList") %>;

$(document).ready(function(){
	setNav('백업 및 복구 > 복구관리');
	
	// 그룹 클릭
	$('.groupLabel').on('click', function(){
		group_label_fnt(this);
		// checkbox - 변경필요
		$(this).children('.tui-checkbox').children('.tui-ico-check').children('input[type=checkbox]').eq(0).trigger('click');
	});

	$('#tree .groupLabel').eq(0).trigger('click');
});

function group_label_fnt(doc){
	var $lavel = $(doc).parent('div').parent('li').find('.groupLabel');
	var $defaultStep = $(doc).data("value");
	var formText = '';
	
	// 초기화
	$('#insert').css('display', 'block');
	$('#groupForm').empty();
	
	formText += mk_form_text($lavel[0], $($lavel[0]).data("value"), $defaultStep);
	$('#groupForm').html(formText);
	
	getBackupRecovery2();
}

//입력폼 생성 - 텍스트
function mk_form_text(doc, step, defaultStep){
	var formText;
	formText = '<div id="gbcdval" data-value="' + step + '" data-upcode="' + $(doc).data("upcode") + '" data-code="' + $(doc).data("code") + '" data-orgseq="' + $(doc).data("orgseq") + '" class="addForm input-group mb-3 formBase">';
	formText += '<input type="text" name="selectOrgName" id="selectOrgName" placeholder="부대명" class="form-control" value="' + $(doc).text() + '"  readonly >';
	formText += '</div>';
	return formText;
}
</script>

<body>
	<%@ include file="../template/topMenu.jsp" %>
	<%@ include file="../template/topNav.jsp" %>
	
	
	<section class="body" style="width: 100%; margin-top: -50px; ">
		<article>
			<div class="code-html contents row">

				<div class="col-md-3">
					<div class="form-style-10">
							<div class="inner-wrap row" style="padding:0; background: rgba(0,0,0,0)">
							<div class="section"><span>1</span>그룹선택</div>
							<%@ include file="../template/groupMenu.jsp" %>
							</div>
					</div>
				</div>
				
				
				<div class="col-md-9">
					<div class="form-style-10">
						
						
				    	<div class="section" style="display: none;"><span>2</span> <div id="selectGroupSgb">PC 목록</div></div>
				    	<div class="inner-wrap row" style="display: none;">
							<div id="pageGrideInSgbList" class="row" style="width:100%;"></div>
				    	</div>
				    	
				    	
				    	<div class="section"><span>2</span>백업본 선택</div>
				    	<div class="inner-wrap row">
							<div id="pageGrideInRecoveryList" class="row" style="width: 100%"></div>
				    	</div>
						
				    	<div class="section"><span>3</span>복구 적용</div>
				    	<div class="inner-wrap">
			     			<button type="button" class="btn btn-outline-success" name="signup"  id="signup" ><span class="fa fa-check" ></span> 복원하기</button>  
				     		<span class="privacy-policy">
				     			<input type="checkbox" name="field7">클라이언트에 적용시 OS 재부팅이 필요합니다.
				     		</span>
				    	</div>
					   	
						<form method="post" class="">
					   		<div id="groupForm" style="width: 20%;" hidden></div>
					   		<input type="text" name="orgNmCheckedList" id="orgNmCheckedList" hidden>
					   		<input type="text" name="pcCheckedList" id="pcCheckedList" hidden>
					   		<input type="text" name="recoveryChecked" id="recoveryChecked" hidden>
						</form>
					</div>
				</div>


		    </div>
		</article>
	</section>




<script type="text/javascript">
;(function($) {
    $(function() {
        $('#orgname').bind('click', function(e) {
            e.preventDefault();
            $('#element_to_pop_up').bPopup({
                modalClose: false,
                opacity: 0.6,
                positionStyle: 'fixed' //'fixed' or 'absolute'
            });
        });
    });
})(jQuery);


$(document).ready(function() {
	
	$('#signup').click(function() {
		
		var recovery = $('#pageGrideInRecoveryList input[name=recovery]:checked');
		var pcList = $('#pageGrideInSgbList input[type=checkbox]:checked');
		var allOrgNmCheckedList = tree.getCheckedList();
		var arrOrgNmCheckedList  = new Array();
		
		
		// pc 선택
		if(pcList.length <= 0){
			$.alert({
			    title: 'Alert!',
			    content:  'PC를 선택해주세요!',
			    buttons: {
			        확인: function(){
			         //   location.href = '/notice/notice';
			        }
			    }
			});
			return;
		}else{
			var str = '';
			$.each(pcList, function(i, pc){
				console.log(' -- pc' + i + ' : ' +$(pc).val());
				str += $(pc).val();
				if( pcList.length != i+1 ) str += ',';
			});
			$('#pcCheckedList').val(str);
		}
		
		
		if( allOrgNmCheckedList.length <= 0){
			$.alert({
			    title: 'Alert!',
			    content:  '부서을 선택해주세요!',
			    buttons: {
			        확인: function(){
			         //   location.href = '/notice/notice';
			        }
			    }
			});
			return;
		}else{
			for( var i=0; i<allOrgNmCheckedList.length; i++){
				console.log($("#"+allOrgNmCheckedList[i]+"> .tui-tree-content-wrapper > .tui-tree-text").attr("data-orgseq"));
				arrOrgNmCheckedList[i] = $("#"+allOrgNmCheckedList[i]+"> .tui-tree-content-wrapper > .tui-tree-text").attr("data-orgseq") ;
			}

			$("#orgNmCheckedList").val(arrOrgNmCheckedList);
			var str = $("#orgNmCheckedList").val();
			
			// 쉼표제거
			if(',' == str.substr(str.length-1)) {
				str = str.substr(0, str.length -1);
			}

			$("#orgNmCheckedList").val(str);
		}
		
		
		
		
        if( 0 == recovery.length ){
			$.alert({
			    title: 'Alert!',
			    content:  '백업주기를 선택해주세요!',
			    buttons: {
			        확인: function(){
			         //   location.href = '/notice/notice';
			        }
			    }
			});
			return;
		}else{
			console.log("$('#pageGrideInRecoveryList input[name=recovery]:checked') : " + recovery.length);
	        $("#recoveryChecked").val(recovery.eq(0).val());
		}
        
        
        // 전송
		$.ajax({
			url : '/backupRecovery/startRecovery.proc',
			type: 'POST',
			data:$("form").serialize(),
			success : function(res) {
				if( res.success == true ){
					 $.alert({
						    title: 'Alert!',
						    content:  '해당 PC의 시스템 재시작시 복구가 시작됩니다!',
						    buttons: {
						        확인: function(){
						        }
						    }
						});
				        return;
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
	});
	
	$('#userAdd').click(function() {
		location.href = "/user/userAdd.acnt";
	});
	// 팝업창에서 수정버튼
	$('#seveChng').click(function() {
		alert(1);
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
		case 'classSoliderList' : $("#soliderListCurrentPage").val(page); getList(); break
	default :
	}
}


function getBackupRecovery2(){
	var url ='/backupRecovery/restoreRecovery.proc';
	var keyWord = $("select[name=keyWord]").val();
	var vData = "selectOrgName=" + $("#gbcdval").attr("data-orgseq") +"&selectOrgUpperCode=" + $("#gbcdval").attr("data-code");
	callAjax('POST', url, vData, backupRecoveryGetSuccess, getError, 'json');
}
</script>
</body>
</html>