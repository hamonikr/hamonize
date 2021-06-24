<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/css/notice/noticeInsert.css" />
<link rel="stylesheet" type="text/css" href="/css/template/bootstrap4.css" />


<script type="text/javascript" src="/js/jquery-1.12.3.min.js"></script>
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


<!-- jquery alert -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jquery-confirm/3.3.2/jquery-confirm.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-confirm/3.3.2/jquery-confirm.min.js"></script>


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
		$("#noti_orgcode").val($(doc).data("code") );
		$("#noti_orguppercode").val($(doc).data("upcode") );
		$("#orgname").val( $(doc).text() );
		$( "#orgnameLabel" ).addClass( "active" );
		$('#element_to_pop_up').bPopup().close();
	}
	
</script>    
    
    
<style> 
.contentLayer {
  max-width: 1000px;
  margin: 0 auto;
 /*  margin: auto;
  padding: 10px; */
}
</style>

<body >
	<%@ include file="../template/topMenu.jsp" %>
	<%@ include file="../template/topNav.jsp" %>
	
	<!-- content body -->
	<section class=" contentLayer">
		<article>
			<div class="code-html ">
				<p id="contentTitle">공지사항</p>
				
				<hr/>
				
				<form method="post" class="">
					
					
					<div class="row mb-3">
						<div class="">
					        <div class="input-group">
						            <div class="input-group-prepend">
						                <span class="input-group-text">
						                    <span class=""> 공지제목 </span>
						                </span>                    
						            </div>
						             <input type="text" id="noti_title" name="noti_title" class="form-control" style="width:500px;">
						        </div>
					    </div>
				    </div>
					
					<div class="row mb-3 ">
					    <div class=" mr-sm-3">
					        <div class="input-group">
					            <div class="input-group-prepend">
					                <span class="input-group-text">
					                    <span class="">공지 등급</span>
					                </span>                    
					            </div>
					            <select class="form-control " id="noti_group" name="noti_group">
									<c:forEach var="item" items="${retAttributeVo}">
										<option value="${item.attr_value_code }">${item.attr_value_name}</option>
									</c:forEach>
								</select> 
					        </div>
					    </div>
					    
					    
					    <div class="mr-sm-3">
					        <div class="input-group">
					            <div class="input-group-prepend">
					                <span class="input-group-text">
					                    <span class="">부대선택</span>
					                </span>                    
					            </div>
					            <input id="orgname" name="orgname" type="text" data-length="10" >
					            <input type="text" name="noti_orgcode" id="noti_orgcode" value="">
					            <input type="text" name="noti_orguppercode" id="noti_orguppercode" value="">
					        </div>
					    </div>
					    
					    <div class="w-23">
					        <div class="input-group">
					            <div class="input-group-prepend">
					                <span class="input-group-text">
					                    <span class="">계급선택</span>
					                </span>                    
					            </div>
					            <select class=" " id="noti_rank" name="noti_rank" >
									<c:forEach var="item" items="${retSoldierClassesVo}">
										<option value="${item.attr_value_code }">${item.attr_value_name}</option>
									</c:forEach>
								</select>  
					        </div>
					    </div>
					    
					</div>
					
					
					<div class="row mb-3 w-100">
						<div class=" w-100">
					        <div class="input-group">
						            <div class="input-group-prepend">
						                <span class="input-group-text">
						                    <span class="w-25"> 공지내용 </span>
						                </span>                    
						            </div>
						        </div>
						        <div class="contentDetailDiv">
									<input type="text" name="noti_contents" id="noti_contents" hidden>
						            <div class="code-html">
						                <script src="/tui-editor/tui-editor/dist/tui-editor-Editor.js"></script>
						                <link rel="stylesheet" href="/tui-editor/tui-editor/dist/tui-editor.css">
						                <link rel="stylesheet" href="/tui-editor/tui-editor/dist/tui-editor-contents.css"> 
						                <div id="editSection"></div>
						            </div>
						            <script class="code-js">
						                var editor = new tui.Editor({
						                    el: document.querySelector('#editSection'),
						                    initialEditType: 'wysiwyg',
			//			                    initialEditType: 'markdown',
						                    previewStyle: 'vertical',
						                    height: '400px'
						                });
						            </script>
								</div>
					    </div>
				    </div>
				    
				    
					
					<div class="row mb-3">
						
					</div>
					
					<hr style="margin: 10px 0;"/>
				

        
					<div id="contentUpdateBtn">
		       			<button type="button" class="btn btn-outline-success" name="cmCreate"  id="cmCreate" ><span class="fa fa-check" ></span> Success</button>
				        <button type="button" class="btn btn-outline-info" name="cmCreateCanCel" id="cmCreateCanCel"><span class="fa fa-check"></span> Info</button>
					</div>
				</form>
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
    <div class="row">부대선택</div>
    <div class="row"><%@ include file="../template/groupMenuPopup.jsp" %></div>
</div>


	
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
	//$('input[name=cmCreate]').click(function() {
	$('#cmCreate').click(function(e) {
		
		// editor contents 
		var contents = document.querySelector("#noti_contents");
        // contents.value = editor.getMarkdown(); //markdown 저장
        contents.value = editor.getHtml(); //html 저장
        console.log(contents.value);
	        
		$.ajax({
			url : '/notice/noticeInsert.proc',
			type: 'POST',
			data:$("form").serialize(),
			success : function(res) {
				if( res.success == true ){
					$.alert({
					    title: 'Alert!',
					    content:  res.msg + '!',
					    buttons: {
					        확인: function(){
					            location.href = '/notice/notice';
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
	
	// 취소
	/* $('input[name=cmCreateCanCel]').click(function() {
		location.href="/customer/cmMain";
	}); */
});
</script>	
</body>
</html>