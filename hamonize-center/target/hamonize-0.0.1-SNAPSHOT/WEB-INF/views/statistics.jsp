<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="./template/head.jsp" %>

<script type="text/javascript">
var data = <%= request.getAttribute("gList") %>;
</script>

<link rel='stylesheet' type='text/css' href='/css/template/tui-chart.css'/>
<link rel='stylesheet' type='text/css' href='/css/template/codemirror-5.43.0.css'/>
<link rel='stylesheet' type='text/css' href='/css/template/lint-5.43.0.css'/>
<link rel='stylesheet' type='text/css' href='/css/template/neo-5.43.0.css'/>
<link rel='stylesheet' type='text/css' href='/css/template/chart.css'/>
<link rel='stylesheet' type='text/css' href='/css/statistics.css'/>

<script type='text/javascript' src='/js/views/statistics.js'></script>

<body>
	<%@ include file="./template/topMenu.jsp" %>
	<%@ include file="./template/topNav.jsp" %>
	<%@ include file="./template/groupMenu.jsp" %>
	
	<section class="body">
		<div class="tab">
			<div class="content-container">
				<ul class="tab-menus" data-testid="detail-tab">
					<li class="tab-item selected" data-testid="chart-time"><button>기간별 사용시간</button></li>
					<li class="tab-item " data-testid="chart-fault"><button>장애 처리현황</button></li>
					<li class="tab-item " data-testid="chart-support"><button>기술지원 처리현황</button></li>
				</ul>
			</div>
		</div>
		
		
		<article>
			
			<!-- 기간별 사용시간 -->
			<div class='wrap'>
				<div class='code-html' id='code-html'>
					<div id='chart-time'></div>
					<div id='chart-fault' style="display: none;"></div>
					<div id='chart-support' style="display: none;"></div>
				</div>
				
				<div class='custom-area' style="display: none;">
			        <div id='error-dim'>
			            <span id='error-text'></span>
			            <div id='error-stack'></div>
			            <span id='go-to-dev-tool'>For more detail, open browser's developer tool and check it out.</span>
			        </div>
			        <div class="try-it-area">
			            <h3>try it</h3>
			            <textarea id="code"></textarea>
			            <div class="apply-btn-area">
			                <button class="btn" onclick='evaluationCode(chartCM, codeString);'>Run it!</button>
			            </div>
			        </div>
			    </div>
			</div>
			
		</article>
	</section>
	
	<%@ include file="./template/footer.jsp" %>


	<script type='text/javascript' src='/js/template/core-2.5.7.js'></script>
	<script type='text/javascript' src='/js/template/tui-code-snippet-v1.5.0.min.js'></script>
	<script type='text/javascript' src='/js/template/raphael.js'></script>
	<script type='text/javascript' src='/js/template/tui-chart.js'></script>
	
	<script type='text/javascript'>
		$('.tab-item').click(function(){
			/* 선택 표시 */
			$('.tab-item').removeClass('selected');
			$(this).addClass('selected');
			
			/* 표시 페이지 */
			var $chart_name = $(this).data('testid');
			
			$('#code-html > div').css('display', 'none');
			$('#'+$chart_name).css('display', '');
		});
	</script>
	
	
	<!-- demo data -->
	<script src="/demo_data/statistics-chart-time.js"></script>
	<script src="/demo_data/statistics-chart-fault.js"></script>
	<script src="/demo_data/statistics-chart-support.js"></script>
	
	<script class='code-js' id='code-js'></script>
	
	
	<!--For tutorial page-->
	<script src='/js/template/jshint.js'></script>
	<script src='/js/template/codemirror-5.43.0.js'></script>
	<script src='/js/template/matchbrackets-5.43.0.js'></script>
	<script src='/js/template/active-line-5.43.0.js'></script>
	<script src='/js/template/javascript-5.43.0.js'></script>
	<script src='/js/template/lint-5.43.0.js'></script>
	<script src='/js/template/javascript-lint-5.43.0.js'></script>
	<script src='/js/template/chart.js'></script>
</body>
</html>