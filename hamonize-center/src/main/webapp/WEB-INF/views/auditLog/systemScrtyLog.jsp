<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/css/template/tui-grid.css" />
<link rel="stylesheet" type="text/css" href="/css/template/tui-pagination.css" />
<link rel='stylesheet' type='text/css' href='/css/template/tui-chart.css'/>
<script src="/js/views/securityLog.js"></script>

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
				<hr/>
				   
				<div id="grid"></div>
		    </div>
		</article>
	</section>
	
	<%@ include file="../template/grid.jsp" %>
	<%@ include file="../template/footer.jsp" %>	
	
	<script type="text/javascript" class="code-js">
	var gridData = [];
	var total = 200; // template/grid 에서도 사용

	for(var i=0;i<total;++i){
		/* dummy data - 하단의 컬럼에 따라 변수명을 지정하면 해당 값을 대입하여 그리드를 작성 */
		gridData.push({
				group_orgcode: '1-1-1중대', 
				number: ('060102-3004181'), 
				solderRank: '이등병',
				name: '홍길동',
				solderId: 'Gildong-Hong', 
				login_dt: '2019-04-26 11:53:47', 
				logout_dt: '2019-04-26 13:32:51'}
		);
	}
	
	
	var grid = new tui.Grid({
	    el: $('#grid'),
	    scrollX: false,
	    scrollY: false,
	    minBodyHeight: 30,
	    rowHeaders: ['rowNum'],
	    pagination: true,
	    columns: [
	    	{
	            title: '소속부대',
	            name: 'group_orgcode'
	        },
	    	{
	            title: '군번',
	            name: 'number'
	        },
	        {
	            title: '계급',
	            name: 'solderRank'
	        },
	        {
	            title: '이름',
	            name: 'name'
	        },
	        {
	            title: '아이디',
	            name: 'solderId'
	        },
	        {
	            title: '접속일시',
	            name: 'login_dt'
	        },
	        {
	            title: '종료일시',
	            name: 'logout_dt'
	        }
	    ]
	});
	grid.use('Net', {
	    perPage: 18,
	    readDataMethod: 'GET',
	    api: {
	        readData: 'api/readData'
	    }
	});
	</script>
</body>
</html>