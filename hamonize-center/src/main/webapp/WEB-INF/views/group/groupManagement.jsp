<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/css/template/tui-grid.css" />
<link rel="stylesheet" type="text/css" href="/css/template/tui-pagination.css" />
<link rel="stylesheet" type="text/css" href="/css/groupManagement.css" />
<script src="/js/views/groupManagement.js"></script>

<script type="text/javascript">
var data = <%= request.getAttribute("gList") %>;
</script>

<body>
	<%@ include file="../template/topMenu.jsp" %>
	<%@ include file="../template/topNav.jsp" %>
	<%@ include file="../template/groupMenu.jsp" %>
	
	<!-- content body -->
	<section class="body">
		<article>
			<div class="code-html contents">
				<p id="contentTitle"></p>
				<hr/>
				
				<div id="insert" style="display: none;">
					<label>
						<input type="button" id="addGroup" value="하위부대 생성" class="btn btn-info">
					</label>
					<div id="groupForm"></div>
				</div>
				
				<div id="grid" style="display: none"></div>
		    </div>
		</article>
	</section>
	
	<p id="data"></p>
	
	
	<%@ include file="../template/footer.jsp" %>
	
	
</body>
</html>