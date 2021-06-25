<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>
<!-- <link rel="stylesheet" type="text/css" href="/css/notice/noticeInsert.css" />
<link rel="stylesheet" type="text/css" href="/css/template/bootstrap4.css" /> -->


<!-- <script type="text/javascript" src="/js/jquery-1.12.3.min.js"></script>
<script type="text/javascript" src="/js/common.js"></script>
<script src="/js/views/notice/noticeInsert.js"></script> -->




<script src="/tui-editor/jquery/dist/jquery.js"></script>
<script src='/tui-editor/markdown-it/dist/markdown-it.js'></script>
<script src="/tui-editor/to-mark/dist/to-mark.js"></script>
<script src="/tui-editor/tui-code-snippet/dist/tui-code-snippet.js"></script>
<script src="/tui-editor/codemirror/lib/codemirror.js"></script>
<script src="/tui-editor/highlightjs/highlight.pack.js"></script>
<script src="/tui-editor/squire-rte/build/squire-raw.js"></script>
<link rel="stylesheet" href="/tui-editor/codemirror/lib/codemirror.css">
<link rel="stylesheet" href="/tui-editor/highlightjs/styles/github.css">

<!-- <link href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet"> -->


<!-- jquery alert -->
<!-- <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jquery-confirm/3.3.2/jquery-confirm.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-confirm/3.3.2/jquery-confirm.min.js"></script> -->

<link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
<script src="//code.jquery.com/jquery.min.js"></script>
<script src="//code.jquery.com/ui/1.11.4/jquery-ui.min.js"></script>

<script type="text/javascript" src="/js/select2.js"></script>
<style>
.tts {
    position: absolute;
    left: -9999px;
    width: 1px;
    height: 1px;
    font-size: 0;
    line-height: 0;
    overflow: hidden;
}

.btn {
	display: inline-block;
	text-align: center;
	vertical-align: middle;
	white-space: nowrap;
	text-decoration: none !important;
}

</style>
<script type="text/javascript">


	$(document).ready(function(){
		
		var availableTags = [
			<c:forEach items="${oList}" var="data" varStatus="status" >
			{value:"${data.org_nm}",key:"${data.seq}"},
			</c:forEach>
			 ];
			
		    $( "#org-name" ).autocomplete({
		      minLength: 2,
		      source: availableTags,
		      focus: function( event, ui ) {
		        $( "#org-name" ).val( ui.item.value );
		        return false;
		      },
		      select: function( event, ui ) {
		        $( "#org-name" ).val( ui.item.value );
		        $( "#noti_orgcode" ).val( ui.item.key );
		 
		        return false;
		      } 
			  });
		
		//등록
		$('#cmCreate').click(function(e) {
			
			// editor contents 
			var contents = document.querySelector("#noti_contents");
	        // contents.value = editor.getMarkdown(); //markdown 저장
	        contents.value = editor.getHtml(); //html 저장
	        console.log(contents.value);

	        if($('#noti_title').val() == '')
			{
				alert('제목을 입력해주세요.');
				$('#noti_title').focus();
				return true;
			} 

	        if($('#noti_orgcode').val() == '')
			{
				alert('부대가 선택되지 않았습니다. 셀렉트박스 목록에서 부대를 클릭으로 선택해주세요.');
				$('#org-name').focus();
				return true;
			}
	        var frm = $("notiForm")[0];
			var formData = new FormData(frm);
			formData.append("filename",$("input[name=filename]")[0].files[0]);
			formData.append("input-fake",$("input[name=input-fake]").val());
			formData.append("noti_contents",$("input[name=noti_contents]").val());
			formData.append("noti_title",$("input[name=noti_title]").val());
			formData.append("noti_group",$("select[name=noti_group]").val());
			formData.append("noti_rank",$("select[name=noti_rank]").val());
			formData.append("noti_orgcode",$("input[name=noti_orgcode]").val());
		        
			$.ajax({
				url : '/notice/noticeInsert.proc',
				type: 'POST',
				//data:$("#notiForm").serialize(),
				data:formData,
				processData: false,
			    contentType: false,
				success : function(res) {
					if( res.success == true ){
							alert("정상적으로 등록되었습니다.");
						    location.href = '/notice/notice';
					}else{
						
						alert("등록실패");
						
					}
				},
				error:function(request,status,error){
					console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
				}
			}); 
			
		});
		//수정
		$('#cmUpdate').click(function() {
			
			// editor contents 
			var contents = document.querySelector("#noti_contents");
	        // contents.value = editor.getMarkdown(); //markdown 저장
	        contents.value = editor.getHtml(); //html 저장
	        console.log(contents.value);

			$.ajax({
				url : '/notice/noticeUpdate.proc',
				type: 'POST',
				data:$("form").serialize(),
				success : function(res) {
					
					if(true == res.success){
						alert("정상적으로 수정되었습니다.");
					    location.href = '/notice/notice';
						
					}else{
						alert("수정실패");
					}
				},
				error:function(request,status,error){
					console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
					$('#textInfo').text(msg.AJAX_FAIL);
				}
			});
			
		});

		// 파일첨부 디자인 버튼
		$('.btn-attach, .input_type1').bind("click", function(){
			$(this).siblings('input[type=file]').click();
		});
		$('input[type=file]').bind("change", function(){
			if(window.FileReader) {
				// modern browser
				var filename = $(this)[0].files[0].name;
			} else {
				// old IE 
				var filename = $(this).val().split('/').pop().split('\\').pop();
			} 
			$(this).siblings('.input_type1').val(filename); 
		});
		
	});
	function uploadFile(){
        var form = $('#notiForm')[0];
        var formData = new FormData(form);
        formData.append("fileObj", $("#filename")[0].files[0]);
        //formData.append("fileObj2", $("#FILE_TAG2")[0].files[0]);

        $.ajax({
            url: '',
                    processData: false,
                    contentType: false,
                    data: formData,
                    type: 'POST',
                    success: function(result){
                        alert("업로드 성공!!");
                    }
            });
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
	
	
	<!-- content -->
        <div class="hamo_container">
            <div class="content_con">

                <!-- content list -->
                <div class="con_box">
                 <h2>공지사항</h2>
                  <ul class="location">
                      <li>Home</li>
                      <li>공지사항</li>
                  </ul>

              <form method="post" class="" id="notiForm" enctype="multipart/form-data">
              <c:if test="${retNvo.noti_seq != null }">
				<input type="hidden" id="noti_seq" name="noti_seq" value="${retNvo.noti_seq }" />
				</c:if>
                    <div class="board_view mT20">
                        <table>
                            <colgroup>
                                <col style="width:10%;" />
                                <col style="width:20%;" />
                                <col style="width:5%;" />
                                <col style="width:25%;" />
                                <col style="width:5%;" />
                                <col />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>제목</th>
                                    <td colspan="5">
                                        <label for="noti_title" class="none">제목</label>
                                        <input type="text" name="noti_title" id="noti_title" class="input_type1" placeholder="" value="${retNvo.noti_title }" style="width: 900px;"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>공지등급</th>
                                    <td>
                                        <select id="noti_group" name="noti_group" title="noti_group" class="sel_type1">
                                       		<c:forEach var="item" items="${retAttributeVo}">
                                       		<c:if test="${item.attr_value_code ne '000'}">
                                            	<option value="${item.attr_value_code }" <c:if test="${ item.attr_value_code == retNvo.noti_group }">selected</c:if>>${item.attr_value_name}</option>
                                              </c:if>
                                            </c:forEach>
                                        </select>
                                    </td>
                                    <th>부대</th>
                                    <td>
                                    <label for="org-name" class="none">부대</label>
                                       <%--  <input type="text" name="noti_orgcode" id="noti_orgcode" class="input_type1" placeholder="" value="${retNvo.noti_orgcode }"/> --%>
	                                  	<input id="org-name" name="org-name" class="input_type1" placeholder="자동완성 기능입니다." value="${retNvo.orgname }"/>
											<input type="hidden" id="noti_orgcode" name="noti_orgcode" value="${retNvo.noti_orgcode }"/>
	                                  <%--   <select id="noti_orgcode" name="noti_orgcode" title="noti_orgcode">
									        <c:forEach var="vo" items="${oList}" varStatus="vs" >
												<option value="${vo.seq}" <c:if test="${vo.seq == retNvo.noti_orgcode}">selected</c:if>>${vo.p_org_nm}(${vo.org_nm})</option>
											</c:forEach>
						      			</select> --%>
                                    </td>
                                    <th>계급</th>
                                    <td>
                                        <select id="noti_rank" name="noti_rank" title="" class="sel_type1">
                                            <c:forEach var="item" items="${retSoldierClassesVo}">
												<option value="${item.attr_value_code }" <c:if test="${ item.attr_value_code == retNvo.noti_rank }">selected</c:if>>${item.attr_value_name}</option>
											</c:forEach>
                                        </select>
                                    </td>
                                </tr>
                                 <tr>
                                    <th>첨부파일</th>
                                    <td colspan="5">
                                        <label for="filename" class="none">첨부파일</label>
                                          <input type="file" name="filename" id="filename" class="tts" title="파일첨부" value=""><br /> 
												<input type="text" class="input_type1" name="input-fake" title="파일명" style="width:calc(100% - 190px);" readonly>
												<button type="button" class="btn btn-default btn-attach">찾아보기</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="6" class="view">
                                       <input type="text" name="noti_contents" id="noti_contents" hidden value="">
                                        <div class="code-html">
						                <script src="/tui-editor/tui-editor/dist/tui-editor-Editor.js"></script>
						                <link rel="stylesheet" href="/tui-editor/tui-editor/dist/tui-editor.css">
						                <link rel="stylesheet" href="/tui-editor/tui-editor/dist/tui-editor-contents.css"> 
						                <div id="editSection">${retNvo.noti_contents }</div> 
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
                                    </td>
                                </tr>
                                <!-- <tr>
                                    <th>첨부</th>
                                    <td colspan="5">
                                        <div class="fileBox">
                                            <input type="text" class="fileName" readonly="readonly">
                                            <label for="uploadBtn" class="btn_file">찾아보기</label>
                                            <input type="file" id="uploadBtn" class="uploadBtn">
                                            <button type="button" class="btn_type3"> +</button>
                                            
                                            <input type="text" class="fileName" readonly="readonly">
                                            <label for="uploadBtn" class="btn_file">찾아보기</label>
                                            <input type="file" id="uploadBtn" class="uploadBtn">
                                            <button type="button" class="btn_type3"> +</button>
                                            <button type="button" class="btn_type3"> -</button>
                                        </div>
                                    </td>
                                </tr> -->
                            </tbody>
                        </table>
                    </div><!-- //List -->
                    <div class="t_center mT20">
                    	<c:if test="${retNvo.noti_seq != null }">
                        <button type="button" class="btn_type2" id="cmUpdate"> 수정하기</button>
                        </c:if>
                        <c:if test="${retNvo.noti_seq == null }">
                        <button type="button" class="btn_type2" id="cmCreate"> 등록하기</button>
                        </c:if>
                        <button type="button" class="btn_type2" onclick="history.back()"> 목록</button>
                    </div>
</form>
                </div><!-- //con_box -->
            </div>
        </div><!-- //content -->
	
	
	
	<!-- content body -->
	<%-- <section class=" contentLayer">
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
</section> --%>
		
<%@ include file="../template/footer.jsp" %>
</body>
</html>