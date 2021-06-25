<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>

<link rel="stylesheet" type="text/css" href="/css/notice/noticeInsert.css" />
<link rel="stylesheet" type="text/css" href="/css/template/bootstrap4.css" />

<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/js/jquery.form.js"></script>
<script type="text/javascript" src="/js/common.js"></script>
<script src="/js/views/notice/noticeInsert.js"></script>


<script src="/tui-editor/jquery/dist/jquery.js"></script>
<script src='/tui-editor/markdown-it/dist/markdown-it.js'></script>
<script src="/tui-editor/to-mark/dist/to-mark.js"></script>
<script src="/tui-editor/tui-code-snippet/dist/tui-code-snippet.js"></script>
<script src="/tui-editor/codemirror/lib/codemirror.js"></script>
<script src="/tui-editor/highlightjs/highlight.pack.js"></script>
<script src="/tui-editor/squire-rte/build/squire-raw.js"></script>
<link rel="stylesheet" href="/tui-editor/codemirror/lib/codemirror.css">
<link rel="stylesheet" href="/tui-editor/highlightjs/styles/github.css">

<link href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
    
    
<style> 
.content {
  max-width: 800px;
  margin: 0 auto;
 /*  margin: auto;
  padding: 10px; */
}
</style> 

<body >
	<%@ include file="../template/topMenu.jsp" %>
	<%@ include file="../template/topNav.jsp" %>
	
	<!-- content body -->
	<section class=" content">
		<article>
			<div class="code-html contents">
			
				<form method="post" class="">
					
					<hr style="margin: 10px 0;"/>
					<%-- 
					<select class="form-control " id="mentor_area_zone" name="mentor_area_zone">
						<c:forEach var="item" items="${retAttributeVo}">
							<option value="${item.attr_value_code }">${item.attr_value_name}</option>
						</c:forEach>
					</select> --%>
					
					
 					<label class="radio-inline">
				      <input type="radio" name="optradio" value="A" checked >대분류
				    </label>
				    
				    <label class="radio-inline">
				      <input type="radio" name="optradio" value="B">중분류
				    </label>
				    
				    <br>
					
					attr_code: 	<input type="text" class="form-control" name="attr_code" id="attr_code" >
					attr_name : <input type="text" class="form-control" name="attr_name" id="attr_name">
					attr_value_name : <input type="text" class="form-control" name="attr_value_name" id="attr_value_name">					
					<!-- <input type="text" class="form-control" name="attr_value_code" id="attr_value_code"> -->
					
					
					<div class="row mb-3">
						
					</div>
					
					<hr style="margin: 10px 0;"/>
				

        
					<div id="contentUpdateBtn">
		       			<button type="button" class="btn btn-outline-success" name="cmCreate"  id="cmCreate" ><span class="fa fa-check" ></span> Success</button>
        
				        <button type="button" class="btn btn-outline-info" name="cmCreateCanCel" id="cmCreateCanCel"><span class="fa fa-check"></span> Info</button>
        
					</div>
				</form>
				
	
<script type="text/javascript">
$(document).ready(function() {
	//$('input[name=cmCreate]').click(function() {
	
		
	$('#cmCreate').click(function() {
	     
		
		var st = $(":input:radio[name=optradio]:checked").val();
		
		
		$.ajax({
			url : '/test/test.proc',
			type: 'POST',
			data:$("form").serialize(),
			success : function(res) {
				alert(res);
			},
			error:function(request,status,error){
				console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
				$('#textInfo').text(msg.AJAX_FAIL);
			}
		});
		
	});
	
	// 취소
	/* $('input[name=cmCreateCanCel]').click(function() {
		location.href="/customer/cmMain";
	}); */
});
</script>	
</body>
</html>