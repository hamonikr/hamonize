<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp"%>


<!-- <script type="text/javascript" src="/js/jquery.js"></script> -->
<script type="text/javascript" src="/js/common.js"></script>

<script src="/tui-editor/jquery/dist/jquery.js"></script>
<script src='/tui-editor/markdown-it/dist/markdown-it.js'></script>
<script src="/tui-editor/to-mark/dist/to-mark.js"></script>
<script src="/tui-editor/tui-code-snippet/dist/tui-code-snippet.js"></script>
<script src="/tui-editor/codemirror/lib/codemirror.js"></script>
<script src="/tui-editor/highlightjs/highlight.pack.js"></script>
<script src="/tui-editor/squire-rte/build/squire-raw.js"></script>
<link rel="stylesheet" href="/tui-editor/codemirror/lib/codemirror.css">
<link rel="stylesheet" href="/tui-editor/highlightjs/styles/github.css">


<!-- jquery alert -->
<!-- <link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/jquery-confirm/3.3.2/jquery-confirm.min.css"> -->
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/jquery-confirm/3.3.2/jquery-confirm.min.js"></script>

<!-- <link rel="stylesheet" href="/css/materialize.css">
<script src="/js/materialize.js"></script> -->

<style>
.contentLayer {
	max-width: 1000px;
	margin: 0 auto;
	/*  margin: auto;
  padding: 10px; */
}

.code-html {
	width: 100%
}

#element_to_pop_up {
	background-color: #fff;
	border-radius: 15px;
	color: #000;
	display: none;
	padding: 20px;
	min-width: 400px;
	min-height: 180px;
	margin-top: 10%;
}

.b-close {
	cursor: pointer;
	position: absolute;
	right: 10px;
	top: 5px;
}

#contentUpdateBtn {
	margin-bottom: 40px
}

.card-delete-btn {
	float: right
}
.view img {width:100%;height:100%}
</style>


<body>
	<%@ include file="../template/topMenu.jsp"%>
	<%@ include file="../template/topNav.jsp"%>


	<!-- content -->
	<div class="hamo_container">
		<div class="content_con">

			<!-- content list -->
			<div class="con_box">  
              <h2>장애처리</h2>
              <ul class="location">
                  <li>Home</li>
                  <li>장애처리</li>
              </ul>
              
				<div class="board_view mT20">
					<table>
						<colgroup>
							<col style="width: 15%;" />
							<col style="width: 35%;" />
							<col style="width: 15%;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th>제목</th>
								<td colspan="3"><c:out value="${viewVo.title }" /></td>
							</tr>
							<tr>
								<th>사지방번호</th>
								<td><c:out value="${viewVo.org_nm }" /></td>
								<th>전화번호</th>
								<td><c:out value="${viewVo.tel_num }" /></td>
							</tr>
							<tr>
								<th>ID</th>
								<td><c:out value="${viewVo.user_id }" /></td>
								<th>이름</th>
								<td><c:out value="${viewVo.user_name }" /></td>
							</tr>
							<tr>
								<th>구분</th>
								<td><select name="sportType" class="sel_type1" disabled>
										<option value="${ viewVo.type }">${ viewVo.type }</option>
										<c:if test="${ viewVo.type != '고장신고' }">
											<option value="고장신고">고장신고</option>
										</c:if>
										<c:if test="${ viewVo.type != '개선사항' }">
											<option value="개선사항">개선사항</option>
										</c:if>
										<c:if test="${ viewVo.type != '기타문의' }">
											<option value="기타문의">기타문의</option>
										</c:if>
								</select>
								<c:if test="${ viewVo.type == '장애신고' }">
								<select name="sportType_detail2" class="sel_type1" disabled>
									<option value="" <c:if test="${viewVo.type_detail eq '0'}"> selected</c:if>>선택</option>
									<option value="" <c:if test="${viewVo.type_detail eq 'remote'}"> selected</c:if>>원격</option>
									<option value="" <c:if test="${viewVo.type_detail eq 'local'}"> selected</c:if>>현장</option>	
								</select>
								</c:if>
								</td>
								<th>진행상황</th>
								<td><select name="sportStatus" class="sel_type1" disabled>
										<option value="${ viewVo.status }">${ viewVo.status }</option>
										<option value="접수">접수</option>
										<option value="진행중">진행중</option>
										<option value="답변완료">답변완료</option>
								</select></td>
							</tr>
							<tr>
								<td colspan="4" class="view"><c:out
										value="${ viewVo.content }" escapeXml="false" /></td>
							</tr>

							<c:forEach items="${ answerList }" var="item">
								<tr>
									<td colspan="4">
									<span class="mB10 inblock" style="width:70%" >
									<img src="/images/icon_admin.png" alt="관리자" />${item.admin_id}(${item.admin_name})
										${ item.as_content }</span>
										<span class="right t_right inblock" style="width:30%">
                                        <div class="gray txt13">등록일시 : ${ item.as_insert_dt }</div>
                                        <div class="mL20"><button type="button" class="btn_type3 card-delete-btn" data-value="${ item.as_seq }"> 삭제</button></div> 
                                    </span>
									</td>
								</tr>
							</c:forEach>

							<tr>
								<th>답변작성</th>
								<td colspan="3"><label style="font-size: 0.8rem">진행상황</label>
									<form id="answerForm" method="post" class="row" style="display: block">
										<input id="admin_id" name="admin_id" type="hidden" value="${ userSession.user_id }" hidden> 
										<input id="admin_name" name="admin_name" type="hidden" value="${ userSession.user_name }" hidden> 
										<input id="seq" name="seq" type="text" value="${ viewVo.seq }" hidden> 
										<input id="tcngSeq" name="tcngSeq" type="text" value="${ viewVo.seq }" hidden> 
										<input type="text" name="answer" id="answer" hidden value="">
										<select name="sportStatus" id="sportStatus" class="sel_type1">
											<option value="${ viewVo.status }">${ viewVo.status }</option>
											<c:if test="${ viewVo.status != '접수' }">
												<option value="접수">접수</option>
											</c:if>
											<c:if test="${ viewVo.status != '진행중' }">
												<option value="진행중">진행중</option>
											</c:if>
											<c:if test="${ viewVo.status != '답변완료' }">
												<option value="답변완료">답변완료</option>
											</c:if>
										</select>
										<c:if test="${ viewVo.type == '장애신고' }">
											<select name="sportType_detail" id="sportType_detail" class="sel_type1">
												<option value="0">선택</option>
												<option value="remote">원격</option>
												<option value="local">현장</option>	
											</select>
										</c:if>
										<!-- <textarea name="textarea"></textarea> -->
										<input type="text" name="answerContent" id="answerContent"
											hidden value="">
										<script src="/tui-editor/tui-editor/dist/tui-editor-Editor.js"></script>
										<link rel="stylesheet"
											href="/tui-editor/tui-editor/dist/tui-editor.css">
										<link rel="stylesheet"
											href="/tui-editor/tui-editor/dist/tui-editor-contents.css">
										<div id="answerSection"></div>
										<script class="code-js">
											var editor = new tui.Editor(
													{
														el : document
																.querySelector('#answerSection'),
														initialEditType : 'wysiwyg',
														//			                    initialEditType: 'markdown',
														previewStyle : 'vertical',
														height : '180px'
													});
										</script>
									</form></td>
							</tr>
						</tbody>
					</table>
				</div>
				<!-- //List -->
				<div class="t_center mT20">
					<button type="button" class="btn_type2" id="addAnswerBtn">저장</button>
					<button type="button" class="btn_type2" id="deleteBtn">삭제</button>
					<button type="button" class="btn_type2" id="cmCreateCanCel">목록</button>
				</div>

			</div>
			<!-- //con_box -->
		</div>
	</div>



	<script type="text/javascript">
		$(document)
				.ready(
						function() {

							// 답변작성열기
							$('#openAnswerForm').on(
									'click',
									function() {
										$(this).parent('.card-content').css(
												'height', '320px');
									});

							// 답변작성닫기
							$('#closeAnswerForm').on(
									'click',
									function() {
										$(this).parent().parent('.card')
												.children('.card-content').css(
														'height', '');
									});

							// 답변작성
							$('#addAnswerBtn')
									.on(
											'click',
											function() {
												// editor contents 
												var contents = document
														.querySelector("#answerContent");
												// contents.value = editor.getMarkdown(); //markdown 저장
												contents.value = editor
														.getHtml(); //html 저장
												console.log(contents.value);
												console.log("aaa====="+$("#sportType_detail").val());
												

												$
														.ajax({
															url : '/tchnlgy/tchnlgyAnswerInsert.proc',
															type : 'POST',
															data : $(
																	"#answerForm")
																	.serialize(),
															success : function(
																	res) {

																if (true == res.success) {
																	alert("정상적으로 등록되었습니다.");
																	location.reload();
																	/* $
																			.alert({
																				title : 'Alert!',
																				content : res.msg
																						+ '!',
																				buttons : {
																					확인 : function() {
																						//					            location.href = '/tchnlgy/tchnlgyList';
																						location
																								.reload(); // 변경필요
																					}
																				}
																			}); */

																} else {
																	alert("등록되지 않았습니다.");
																}
															},
															error : function(
																	request,
																	status,
																	error) {
																console
																		.log("code:"
																				+ request.status
																				+ "\n"
																				+ "message:"
																				+ request.responseText
																				+ "\n"
																				+ "error:"
																				+ error);
																$('#textInfo')
																		.text(
																				msg.AJAX_FAIL);
															}
														});
											});

							// 답변 삭제
							$('.card-delete-btn')
									.on(
											'click',
											function() {
												$
														.ajax({
															url : '/tchnlgy/tchnlgyAnswerDelete.proc',
															type : 'POST',
															data : {
																as_seq : $(this)
																		.attr(
																				'data-value')
															},
															success : function(
																	res) {
																if (true == res.success) {
																	alert("정상적으로 삭제되었습니다.");
																	//location.href = '/tchnlgy/tchnlgyList';
																	location.reload();
																	/* $
																			.alert({
																				title : 'Alert!',
																				content : res.msg
																						+ '!',
																				buttons : {
																					확인 : function() {
																						//					            location.href = '/tchnlgy/tchnlgyList';
																						location
																								.reload(); // 변경필요
																					}
																				}
																			}); */

																} else {
																	alert("삭제되지 않았습니다.");
																}
															},
															error : function(
																	request,
																	status,
																	error) {
																console
																		.log("code:"
																				+ request.status
																				+ "\n"
																				+ "message:"
																				+ request.responseText
																				+ "\n"
																				+ "error:"
																				+ error);
																$('#textInfo')
																		.text(
																				msg.AJAX_FAIL);
															}
														});
											});

							$('#cmCreate')
									.click(
											function() {

												// editor contents 
												var contents = document
														.querySelector("#sportContent");
												// contents.value = editor.getMarkdown(); //markdown 저장
												contents.value = editor
														.getHtml(); //html 저장
												console.log(contents.value);

												$
														.ajax({
															url : '/tchnlgy/tchnlgyUpdate.proc',
															type : 'POST',
															data : $(
																	"#updateForm")
																	.serialize(),
															success : function(
																	res) {

																if (true == res.success) {
																	alert("정상적으로 등록되었습니다.");
																	location.href = '/tchnlgy/tchnlgyList';
																	/* $
																			.alert({
																				title : 'Alert!',
																				content : res.msg
																						+ '!',
																				buttons : {
																					확인 : function() {
																						location.href = '/tchnlgy/tchnlgyList';
																					}
																				}
																			}); */

																} else {
																	alert("등록되지 않았습니다.");
																	/* $
																			.alert({
																				title : 'Alert!',
																				content : res.msg
																						+ '!',
																			}); */
																}
															},
															error : function(
																	request,
																	status,
																	error) {
																console
																		.log("code:"
																				+ request.status
																				+ "\n"
																				+ "message:"
																				+ request.responseText
																				+ "\n"
																				+ "error:"
																				+ error);
																$('#textInfo')
																		.text(
																				msg.AJAX_FAIL);
															}
														});

											});

							// 삭제
							$('#deleteBtn')
									.click(
											function() {
												var answeLength = "${fn:length(answerList)}";
												if(answeLength > 0){
												alert("답변이 달린 글은 삭제 할수 없습니다.");
												return false;
												}
												$
														.ajax({
															url : '/tchnlgy/tchnlgyDelete.proc',
															type : 'POST',
															data : $("form")
																	.serialize(),
															success : function(
																	res) {

																if (true == res.success) {
																	alert("정상적으로 삭제되었습니다.");
																	location.href = '/tchnlgy/tchnlgyList';
																	/* $
																			.alert({
																				title : 'Alert!',
																				content : res.msg
																						+ '!',
																				buttons : {
																					확인 : function() {
																						location.href = '/tchnlgy/tchnlgyList';
																					}
																				}
																			}); */

																} else {
																	alert("삭제되지 않았습니다.");
																}
															},
															error : function(
																	request,
																	status,
																	error) {
																console
																		.log("code:"
																				+ request.status
																				+ "\n"
																				+ "message:"
																				+ request.responseText
																				+ "\n"
																				+ "error:"
																				+ error);
																$('#textInfo')
																		.text(
																				msg.AJAX_FAIL);
															}
														});

											});

							// 취소
							$('#cmCreateCanCel').click(function() {
								location.href = '/tchnlgy/tchnlgyList';
							});
						});
	</script>
<%@ include file="../template/footer.jsp" %>
</body>
</html>