<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/css/template/tui-grid.css" />
<link rel="stylesheet" type="text/css" href="/css/template/tui-pagination.css" />
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
<script type="text/javascript" src="/js/common.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
<link rel="stylesheet" href="/css/materialize.css">
<script src="/js/materialize.js"></script>

       
<script type="text/javascript">

	var data = <%= request.getAttribute("gList") %>;
	$(document).ready(function(){
		// 그룹 클릭
		$('.groupLabel').on('click', function(){
			group_label_fnt(this);
		});
		
	});
	
	function group_label_fnt(doc){
		var $lavel = $(doc).parent('div').parent('li').find('.groupLabel');
		var $defaultStep = $(doc).data("value");
		var formText = '';
		
		// 초기화
		$('#insert').css('display', 'block');		
		$("#orgname").val("");
		$("#orgname_upcode").val($(doc).data("upcode") );
		$("#orgname").val( $(doc).text() );
		$( "#orgnameLabel" ).addClass( "active" );
		$('#element_to_pop_up').bPopup().close();
	}
	
</script>    

 <style> 
.contentLayer {
  max-width: 1000px;
  margin: 0 auto;
  margin-top: 30px;
}
</style>

<body >
	<%@ include file="../template/topMenu.jsp" %>
	<%@ include file="../template/topNav.jsp" %>
	<!-- content body -->
	<section class=" contentLayer">
		<article>
			<div class="code-html ">  
			<input type="text" name="orgname_upcode" id="orgname_upcode" value="">
			
	        	<div class="input-field col s6">
	            	<input id="number" type="text" data-length="10">
	            	<label for="number">사번</label>
	          	</div>
	          	<div class="input-field col s12">
	          		<select class=" " id="mentor_area_zone" name="mentor_area_zone" >
						<c:forEach var="item" items="${retAttributeRankVo}">
							<option value="${item.attr_value_code }">${item.attr_value_name}</option>
						</c:forEach>
					</select> 
	    			
	    			<label>직급</label>
	  			</div>
	        </div>

	        <div class="row">
	        	<div class="input-field col s6">
	            	<input id="name" type="text" data-length="10">
	            	<label for="name">성명</label>
	          	</div>
	          	<div class="input-field col s6">
	            	<input id="id" type="text" data-length="10">
	            	<label for="id">아이디</label>
	          	</div>
	        </div>

	        <div class="row">
	        	
	        	<div class="input-field col s6">
	            	<input id="pw" type="text" data-length="10">
	            	<label for="pw">비밀번호</label>
	          	</div>
	        	<div class="input-field col s6">
	            	<input id="pw" type="text" data-length="10">
	            	<label for="pw">비밀번호확인</label>
	          	</div>
	        </div>

	        <div class="row">
	        	<div class="input-field col s6">
	            	<input id="discharge_dt" type="text" data-length="10">
	            	<label for="discharge_dt">입사일</label>
	          	</div>
	        </div>
			
		<div id="contentUpdateBtn">
      			<button type="button" class="btn btn-outline-success" name="cmCreate"  id="cmCreate" ><span class="fa fa-check" ></span> 등록</button>
	        <button type="button" class="btn btn-outline-info" name="cmCreateCanCel" id="cmCreateCanCel"><span class="fa fa-check"></span> 취소</button>
		</div>

</div>


</article>
</section>

<script src="/js/jquery.bpopup.min.js"></script>
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

</style>

<!-- Element to pop up -->
<div id="element_to_pop_up">
    <a class="b-close">x</a>
    <div class="row">부서선택</div>
    <div class="row"><%@ include file="../template/groupMenuPopup.jsp" %></div>
</div>


<script type="text/javascript">
   
//부서 팝업
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

	// select box init
	$('select').formSelect();

	$('#cmCreate').click(function() {
		var contents = document.querySelector("#noti_contents");
        contents.value = editor.getHtml(); //html 저장
        alert(contents.value);
	        
		$.ajax({
			url : '/notice/notiWrite.proc',
			type: 'POST',
			data:$("form").serialize(),
			success : function(res) { 
				if(msg.LOGIN_SUCCESS == res){
					location.href='/soldier/info?uID='+$soldierId;
					$('#responseId').val($soldierId).change();
				}else{
					$('#textInfo').text(res);
				}
			},
			error:function(request,status,error){
				console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
				$('#textInfo').text(msg.AJAX_FAIL);
			}
		});
		
	});
	
	
 	
	
});
</script>	
</body>
</html>