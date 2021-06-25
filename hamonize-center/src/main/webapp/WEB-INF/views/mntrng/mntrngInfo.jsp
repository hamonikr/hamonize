<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/css/template/tui-grid.css" />
<link rel="stylesheet" type="text/css" href="/css/template/tui-pagination.css" />
<link rel='stylesheet' type='text/css' href='/css/template/tui-chart.css'/>
<link rel='stylesheet' type='text/css' href='/css/pcinfo.css'/>
<script src="/js/views/pcinfo.js"></script>

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
					<input type="button" value="원격제어" class="btn" id="remoteControllBtn" data-value="-1">
				</p>
				<hr/>
				
				<!-- <div id="grid"></div> -->
				
				<!-- chart -->
				<div id='cpu_chart'></div>
				<div id='memory_chart'></div>
				<div id='network_chart'></div>
				<div id='disk_chart'></div>
				
				<!-- editer - not use -->
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
	
	<%@ include file="../template/footer.jsp" %>
	
	
	<script type='text/javascript' src='/js/template/raphael.js'></script>
	<script type='text/javascript' src='/js/template/tui-chart.js'></script>
	
	
	<!-- demo data -->
	<script type="text/javascript">
		var cpu_chart = document.getElementById('cpu_chart');
		var memory_chart = document.getElementById('memory_chart');
		var network_chart = document.getElementById('network_chart');
		var disk_chart = document.getElementById('disk_chart');
		
		var options_default = {
		    chart: {
		        width: 720,
		        height: 480
		    },
		    series: { 
		    	areaOpacity: 0.5, 
		    	showDot: false, 
		    	zoomable: false 
	    	},
		    xAxis: {
		        title: '',
		        pointOnColumn: true,
		        dateFormat: 'hh:mm',
		        tickInterval: 'auto'
		    },
		    yAxis: { title: '' },
	    	tooltip: { suffix: '' }
		};
		
		
		/* demo data */
		var dataCnt = 40;
		var deathDataCnt = 40;
		var maxVal = 25000;
		var demoData = [];
		var demoData1 = [];
		
		for(i=0;i<dataCnt;++i){
			demoData.push(Math.floor(Math.random() * maxVal) + 1);
			demoData1.push(Math.floor(Math.random() * maxVal) + 1);
		}
		
		for(i=0;i<deathDataCnt;++i){
			demoData.push(0);
			demoData1.push(0);
		}
		
		
		/* CPU START */
		var cpu_data = {
		    categories: ['9:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00', '16:00', '17:00', '18:00'],
		    series: [
		        {
					name: '사용 중',
					data: demoData
		        },
		        {
					name: '사용 가능',
					data: demoData1
		        }
		    ]
		};
		
		var cpu_options = options_default;
		cpu_options.chart.title = 'CPU';
		
		var cpu_theme = {
		    series: {
		        colors: [
		        	'#008000', '#bfff00', '#295ba0', '#2a4175', '#458a3f',
		            '#289399', '#617178', '#8a9a9a', '#516f7d', '#dddddd'
		        ]
		    }
		};
		// For apply theme
		tui.chart.registerTheme('cpu_theme', cpu_theme);
		cpu_options.theme = 'cpu_theme';
		var cpu_chart = tui.chart.areaChart(cpu_chart, cpu_data, cpu_options);
		/* CPU END */
		
		
		/* Memory START */
		maxVal = 99;
		demoData = [];
		
		for(i=0;i<dataCnt;++i){
			demoData.push(Math.floor(Math.random() * maxVal) + 1);
		}
		
		for(i=0;i<deathDataCnt;++i){
			demoData.push(0);
		}
		
		
		
		var memory_data = {
		    categories: ['9:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00', '16:00', '17:00', '18:00'],
		    series: [
		        {
					name: '사용 중',
					data: demoData
		        }
		    ]
		};
		
		var memory_options = options_default;
		memory_options.chart.title = 'Memory';
		memory_options.yAxis.title = '%';
		memory_options.tooltip.suffix = 'MiB';
		
		var memory_theme = {
		    series: {
		        colors: [
		        	'#a5e84b', '#bfff00', '#295ba0', '#2a4175', '#458a3f',
		            '#289399', '#617178', '#8a9a9a', '#516f7d', '#dddddd'
		        ]
		    }
		};
		// For apply theme
		tui.chart.registerTheme('memory_theme', memory_theme);
		memory_options.theme = 'memory_theme';
		var memory_chart = tui.chart.areaChart(memory_chart, memory_data, memory_options);
		/* Memory END */
		
		
		/* Network START */
		maxVal = 1000;
		demoData = [];
		demoData1 = [];
		
		for(i=0;i<dataCnt;++i){
			demoData.push(Math.floor(Math.random() * maxVal) + 1);
			demoData1.push(Math.floor(Math.random() * maxVal) + 1);
		}
		
		for(i=0;i<deathDataCnt;++i){
			demoData.push(0);
			demoData1.push(0);
		}
		
		
		var network_data = {
		    categories: ['9:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00', '16:00', '17:00', '18:00'],
		    series: [
		    	{
					name: '보내기',
					data: demoData
		        },
		        {
					name: '받기',
					data: demoData1
		        }
		    ]
		};
		
		var network_options = options_default;
		network_options.chart.title = 'Network';
		network_options.yAxis.title = 'bit/s';
		network_options.tooltip.suffix = 'Mbps';
		
		var network_theme = {
		    series: {
		        colors: [
		        	'#00ff5f', '#bfff00', '#295ba0', '#2a4175', '#458a3f',
		            '#289399', '#617178', '#8a9a9a', '#516f7d', '#dddddd'
		        ]
		    }
		};
		// For apply theme
		tui.chart.registerTheme('network_theme', network_theme);
		network_options.theme = 'network_theme';
		var network_chart = tui.chart.areaChart(network_chart, network_data, network_options);
		/* Network END */
		
		
		
		
		/* Disk START */
		maxVal = 6;
		demoData = [];
		demoData1 = [];
		
		for(i=0;i<dataCnt;++i){
			demoData.push(Math.floor(Math.random() * maxVal) + 1);
		}
		
		for(i=0;i<deathDataCnt;++i){
			demoData.push(0);
		}
		
		
		var disk_data = {
		    categories: ['9:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00', '16:00', '17:00', '18:00'],
		    series: [
		        {
					name: '사용 중',
					data: demoData
		        }
		    ]
		};
		
		
		var disk_options = options_default;
		disk_options.chart.title = 'Disk';
		disk_options.yAxis.title = 'Mil';
		disk_options.tooltip.suffix = 'Mil';
		
		var disk_theme = {
		    series: {
		        colors: [
		        	'#00ff5f', '#bfff00', '#295ba0', '#2a4175', '#458a3f',
		            '#289399', '#617178', '#8a9a9a', '#516f7d', '#dddddd'
		        ]
		    }
		};
		// For apply theme
		tui.chart.registerTheme('disk_theme', disk_theme);
		disk_options.theme = 'disk_theme';
		var disk_chart = tui.chart.areaChart(disk_chart, disk_data, disk_options);
		/* Network END */
	</script>
</body>
</html>