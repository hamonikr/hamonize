<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/css/template/tui-grid.css" />
<link rel="stylesheet" type="text/css" href="/css/template/tui-pagination.css" />

<script src="/js/views/user/userInfo.js"></script>

<script type="text/javascript">
var data = <%= request.getAttribute("gList") %>;
</script>

<style>
.body .code-html.contents{
	border: 4px solid #bbb;
	border-radius: 10px;
	margin: auto;
	margin-top: 40px;
	overflow: hidden;
	width: 640px;
}

.code-html.contents > form > p { 
	background-color: #282153;
	padding: 0 20px 10px 20px; 
}

#soldierName {
	background-color: rgba(0,0,0,0);
	color: white;
	font-size: 25px;
	font-weight: bold;
	margin-top: 10px;
	margin-bottom: 0px;
	padding: 0;
	width: 100%;
}

.userDisabled {
	background-color: rgba(0,0,0,0);
	border: 0;
}

.soldierInfoDiv { padding: 20px 20px 0px 20px; }
.soldierInfoDiv:last-child { padding: 20px; }

#contentUpdateBtn { text-align: center; }

#contentUpdateBtn .btn ,
#contentFooter .btn { 
	font-weight: bold; 
	padding: 5px 40px;
}
.manageDiv { 
	float: right; 
	margin-right: 10px;
}
.listDiv { margin-left: 10px; }

.form-control { margin-bottom: 10px; }
</style>

<body>
	<%@ include file="../template/topMenu.jsp" %>
	<%@ include file="../template/topNav.jsp" %>
	<%@ include file="../template/groupMenu.jsp" %>
	
	<!-- content body -->
	<section class="body">
		<article>
			<div class="code-html contents">
				<form method="post">
					<p>
						<input type="text" name="soldierName" id="soldierName" value="로딩중.." disabled="disabled" class="form-control userDisabled">
					</p>
					
					<div class="soldierInfoDiv">
						<label>
							<strong>군번</strong>
							<input type="text" name="soldierNumber" id="soldierNumber" value="로딩중.." disabled="disabled" class="form-control userDisabled">
						</label>
						
						<label>
							<strong>계급</strong>
							<input type="text" name="solderRank" id="solderRank" value="로딩중.." disabled="disabled" class="form-control userDisabled">
						</label>
						
						<label>
							<strong>아이디</strong>
							<input type="text" name="solderId" id="solderId" value="로딩중.." disabled="disabled" class="form-control userDisabled">
						</label>
						
						<label>
							<strong>계정종류</strong>
							<input type="text" name="kind" id="kind" value="로딩중.." disabled="disabled" class="form-control userDisabled">
						</label>
						
						<label>
							<strong>전역일</strong>
							<input type="text" name="discharge_dt" id="discharge_dt" value="로딩중.." disabled="disabled" class="form-control userDisabled">
						</label>
					</div>
					
					<hr style="margin: 0;"/>
					
					<div class="soldierInfoDiv">
						<label>
							<strong>가입일시</strong>
							<input type="text" name="ist_dt" id="ist_dt" value="로딩중.." disabled="disabled" class="form-control userDisabled">
						</label>
						
						<label>
							<strong>수정일시</strong>
							<input type="text" name="udt_dt" id="udt_dt" value="로딩중.." disabled="disabled" class="form-control userDisabled">
						</label>
					</div>
					
					<hr style="margin: 0;"/>
					
					<div class="soldierInfoDiv">
						<div id="contentUpdateBtn" style="display: none;">
							<input type="button" value="수정" id="updateDoneBtn" class="btn">
							<input type="button" value="취소" id="cancelBtn" class="btn">
						</div>
						
						<div id="contentFooter">
							<p class="manageDiv">
								<input type="button" value="삭제" id="deleteBtn" class="btn">
								<input type="button" value="수정" id="updateBtn" class="btn">
							</p>
							<p class="listDiv">
								<input type="button" id="listBtn" value="목록으로" class="btn">
							</p>
						</div>
					</div>
				</form>
		    </div>
		</article>
	</section>
	
	<%@ include file="../template/footer.jsp" %>
</body>
</html>