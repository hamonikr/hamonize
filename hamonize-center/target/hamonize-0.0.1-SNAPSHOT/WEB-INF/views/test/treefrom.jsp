<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/css/template/tui-grid.css" />
<link rel="stylesheet" type="text/css" href="/css/template/tui-pagination.css" />
<link rel="stylesheet" type="text/css" href="/css/template/bootstrap_custom.css" />
<link rel="stylesheet" type="text/css" href="/css/securityManagement.css" />

<script type="text/javascript">
var data = <%= request.getAttribute("gList") %>;
</script>
<style>
#tree .tui-checkbox { display: inline-block }
</style>
<body>
	<%@ include file="../template/topMenu.jsp" %>
	<%@ include file="../template/topNav.jsp" %>
	<%@ include file="./treeMenu.jsp" %>
	
	<%@ include file="../template/footer.jsp" %>
	
	
</body>
</html>