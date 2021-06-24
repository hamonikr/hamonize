<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>
<!-- <link rel="stylesheet" type="text/css" href="/css/notice/noticeInsert.css" />
<link rel="stylesheet" type="text/css" href="/css/template/bootstrap4.css" /> -->


<!-- <script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/js/common.js"></script>
<script src="/js/views/notice/noticeInsert.js"></script> -->


<!-- <script src="/tui-editor/jquery/dist/jquery.js"></script>
<script src="/tui-editor/markdown-it/dist/markdown-it.js"></script>
<script src="/tui-editor/to-mark/dist/to-mark.js"></script>
<script src="/tui-editor/tui-code-snippet/dist/tui-code-snippet.js"></script>
<script src="/tui-editor/codemirror/lib/codemirror.js"></script>
<script src="/tui-editor/highlightjs/highlight.pack.js"></script>
<script src="/tui-editor/squire-rte/build/squire-raw.js"></script>
<link rel="stylesheet" href="/tui-editor/codemirror/lib/codemirror.css">
<link rel="stylesheet" href="/tui-editor/highlightjs/styles/github.css"> -->

<!-- <link href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet"> -->


<!-- jquery alert -->
<!-- <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jquery-confirm/3.3.2/jquery-confirm.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-confirm/3.3.2/jquery-confirm.min.js"></script>
 -->
    <script type="text/javascript">


	$(document).ready(function(){
		
		$("#btn_update").click(function(){
			location.href="noticeUpdate?noti_seq=${retNvo.noti_seq}";
		});

		$("#btn_delete").click(function(){
			var chk = confirm("삭제하시겠습니까?");
			if(chk) {
				location.href="noticeDelete?noti_seq=${retNvo.noti_seq}";
				alert("삭제되었습니다.");
			}
		});
	});
	
</script>
<body>
	<%@ include file="../template/topMenu.jsp" %>
	<%@ include file="../template/topNav.jsp" %>
	
	<div class="hamo_container">
            <div class="content_con">

                <!-- content list -->
                <div class="con_box">
                   <h2>공지사항</h2>
                    <ul class="location">
                        <li>Home</li>
                        <li>공지사항</li>
                    </ul>

                    <div class="board_view mT20">
                        <table>
                            <tbody>
                                <tr>
                                    <td class="subject"><c:out value="${retNvo.noti_title }" /></td>
                                </tr>
                                <tr>
                                    <td>
                                        <ul>
                                            <li>
                                            <c:if test="${ retNvo.noti_group eq '000'}">전체</c:if>
                                            <c:if test="${ retNvo.noti_group eq '001'}">특별</c:if>
                                            <c:if test="${ retNvo.noti_group eq '002'}">상시</c:if>
                                            </li>
                                            <li>사지방 번호 : <c:out value="${retNvo.orgname }"/></li>
                                            <li>국방부</li>
                                            <li>작성일 : <c:out value="${retNvo.first_date }"/></li>
                                        </ul>
                                    </td>
                                </tr>
                               <!--  <tr>
                                    <td>
                                        <font class="mR20">파일첨부 :</font><a href="#"><img src="../images/icon_file.gif" alt="file" />  2019file.hwp</a>
                                    </td>
                                <tr> -->
                                <tr>
                                    <td class="view">
                                        <c:out value="${retNvo.noti_contents }" escapeXml="false"/>
                                    </td>
                                </tr>
                                <!-- <tr>
                                    <td>
                                        <font class="mR20">이전글 :</font><a href="#">사지방 중요 보안 업데이트 공지</a>
                                    </td>
                                <tr>
                                <tr>
                                    <td>
                                        <font class="mR20">다음글 :</font><a href="#">다음글이 없습니다.</a>
                                    </td>
                                <tr> -->
                            </tbody>
                        </table>
                    </div><!-- //List -->
                    <div class="t_center mT20">
                    	<button type="button" class="btn_type2" id="btn_delete">삭제하기</button>
                       <button type="button" class="btn_type2" id="btn_update"> 수정하기</button>
                       <button type="button" class="btn_type2" onclick="history.back()"> 목록</button>
                    </div>

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
					<input id="noti_seq" name="noti_seq" type="text" value="${retNvo.noti_seq }" hidden>
					
					<div class="row mb-3">
						<div class="">
					        <div class="input-group">
						            <div class="input-group-prepend">
						                <span class="input-group-text">
						                    <span class=""> 공지제목 </span>
						                </span>                    
						            </div>
						             <input type="text" id="noti_title" name="noti_title" class="form-control" style="width:500px;" value="${retNvo.noti_title }">
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
										<option value="${item.attr_value_code }" <c:if test="${ item.attr_value_code == retNvo.noti_group }">selected</c:if>>${item.attr_value_name}</option>
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
					            <input id="orgname" name="orgname" type="text" data-length="10" value="${retNvo.orgname }">
					            <input type="hidden" name="orgcode" id="orgcode" value="${retNvo.noti_orgcode }">
					            <input type="hidden" name="orguppercode" id="orguppercode" value="${retNvo.noti_orguppercode }">
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
										<option value="${item.attr_value_code }" <c:if test="${ item.attr_value_code == retNvo.noti_rank }">selected</c:if>>${item.attr_value_name}</option>
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
								</div>
					    </div>
				    </div>
				    
				    
					
					<div class="row mb-3">
						
					</div>
					
					<hr style="margin: 10px 0;"/>
        
					<div id="contentUpdateBtn">
		       			<button type="button" class="btn btn-outline-success" name="cmCreate"  id="cmCreate" ><span class="fa fa-check" ></span> 수정하기</button>
				        <button type="button" class="btn btn-outline-info" name="cmCreateCanCel" id="cmCreateCanCel"><span class="fa fa-check"></span> 목록으로</button>
					</div>
					
				</form>
		</div>
	</article>
</section> --%>
<%@ include file="../template/footer.jsp" %>
</body>
</html>