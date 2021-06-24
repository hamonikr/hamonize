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

<style type="text/css">
.form-style-10{
	width:100%;
	padding:30px;
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
	setNav('정책관리 > 업데이트관리');
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

	getProgrmUpdtList2();
}

//입력폼 생성 - 텍스트
function mk_form_text(doc, step, defaultStep){
	var formText;
	formText = '<div id="gbcdval" data-value="' + step + '" data-upcode="' + $(doc).data("upcode") + '" data-code="' + $(doc).data("code") + '" data-orgseq="' + $(doc).data("orgseq") + '" class="addForm input-group mb-3 formBase">';
	formText += '<input type="text" name="selectOrgName" id="selectOrgName" placeholder="부대명" class="form-control" value="' + $(doc).text() + '"  readonly >';
	formText += '</div>';
	
	$("#selectGroupSgb").html( "[" + $(doc).text()  + "] 사지방 목록");
	return formText;
}
	
	
</script> 

<body> 
	<%@ include file="../template/topMenu.jsp" %>
	<%@ include file="../template/topNav.jsp" %>
	<!-- content body -->
	
	
	
	
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
						
						<form method="post" class="">
						
						
					    	<div class="section" style="display: none;"><span>2</span> <div id="selectGroupSgb">사지방 목록</div></div>
					    	<div class="inner-wrap row" style="display: none;">
								<div id="pageGrideInSgbList" class="row" style="width:50%;"></div>
					    	</div>
					    	
					    	
					    	<div class="section"><span>2</span>업데이트 프로그램 선택</div>
					    	<div class="inner-wrap row">
								<div id="pageGrideInHmprogramUdpt" class="row"  style="width:100%;"></div>
					    	</div>
					
					    	<div class="section"><span>3</span>업데이트 프로그램 적용</div>
					    	<div class="inner-wrap">
					        	<!-- <input type="button" id="signup" name="signup"  value="적용"> -->
				     			<button type="button" class="btn btn-outline-success" name="signup"  id="signup" ><span class="fa fa-check" ></span> 적용하기</button>  
					     		<span class="privacy-policy">
					     			<input type="checkbox" name="field7">선택한 프로그램을 클라이언트에 적용시 OS 재부팅이 필요합니다.
					     		</span>
					    	</div>
					   		
					   		<div id="groupForm" style="width: 20%;" hidden></div>
					   		<input type="text" name="orgNmCheckedList" id="orgNmCheckedList" hidden>
					   		<input type="text" name="progrmCheckedList" id="progrmCheckedList" hidden>
						</form>
					</div>
				</div>


		    </div>
		</article>
	</section>


<script type="text/javascript">


//부대 팝업
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
	
	// 저장
	$('#signup').click(function() {

		var allOrgNmCheckedList = tree.getCheckedList();
		var arrOrgNmCheckedList  = new Array();
		
		if( allOrgNmCheckedList.length <= 0){
			$.alert({
			    title: 'Alert!',
			    content:  '부대을 선택해주세요!',
			    buttons: {
			        확인: function(){
			         //   location.href = '/notice/notice';
			        }
			    }
			});
			return;
		}else{
			$("#orgNmCheckedList").val('');
			for( var i=0; i<allOrgNmCheckedList.length; i++){
				//console.log($("#"+allOrgNmCheckedList[i]+"> .tui-tree-content-wrapper > .tui-tree-text").attr("data-orgseq"));
				arrOrgNmCheckedList[i] = $("#"+allOrgNmCheckedList[i]+"> .tui-tree-content-wrapper > .tui-tree-text").attr("data-orgseq") ;
			}
			$("#orgNmCheckedList").val(arrOrgNmCheckedList);
			var str = $("#orgNmCheckedList").val();
			console.log("str==="+ str);
			
			// 쉼표제거
			if(',' == str.substr(str.length-1)) {
				str = str.substr(0, str.length -1);
			}
			
			console.log("str222==="+ str);
			$("#orgNmCheckedList").val(str);
			
		} 
		
		
		var progrmCheckedList = [];
        $.each($("input[name='programChkbx']:checked"), function(){            
        	progrmCheckedList.push($(this).val());
        }); 
        
        if( progrmCheckedList.length <= 0){
			$.alert({
			    title: 'Alert!',
			    content:  '프로그램을 선택해주세요!',
			    buttons: {
			        확인: function(){
			         //   location.href = '/notice/notice';
			        }
			    }
			});
			return;
		}else{
			console.log("program chk val =="+ progrmCheckedList.length);
	        $("#progrmCheckedList").val(progrmCheckedList);
		}
        

		$.ajax({
			url : '/gplcs/updateManagementInsert.proc',
			type: 'POST',
			data:$("form").serialize(),
			success : function(res) {
				if( res.success == true ){
					$.alert({
					    title: 'Alert!',
					    content:  res.msg + '!',
					    buttons: {
					        확인: function(){
					         //   location.href = '/notice/notice';
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
	});
});



function getProgrmUpdtList2(){
	var url ='/gplcs/updateManagement.proc';
	var keyWord = $("select[name=keyWord]").val();
	var vData = "selectOrgName=" + $("#gbcdval").attr("data-orgseq") +"&selectOrgUpperCode=" + $("#gbcdval").attr("data-code");
	callAjax('POST', url, vData, hmProgramUdptGetSuccess, getError, 'json');
}


</script>	

</body>
</html>