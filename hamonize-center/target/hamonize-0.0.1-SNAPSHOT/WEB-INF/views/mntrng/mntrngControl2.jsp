<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/css/template/tui-grid.css" />
<link rel="stylesheet" type="text/css" href="/css/template/tui-pagination.css" />
<link rel="stylesheet" type="text/css" href="/css/mntgrControl.css" />
<script src="/js/views/mntgrControl.js"></script>

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
				<p id="contentTitle">로딩중..</p>
				<p class="statusInfo">
					<span class="pc_info_div">정상</span><span class="pc_info_div pc_info_off">OFF</span><span class="pc_info_div pc_info_err">장애</span>
				</p>
				<hr/>
				
				<!-- pc list -->
				<div id="pc_list"></div>
		    </div>
		</article>
	</section>
	
	<%@ include file="../template/grid.jsp" %>
	<%@ include file="../template/footer.jsp" %>
</body>
</html>