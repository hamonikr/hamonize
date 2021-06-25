<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>
<link rel='stylesheet' type='text/css' href='/css/tui/tui-chart.css'/>
<link rel='stylesheet' type='text/css' href='/css/tui/codemirror.css'/>
<link rel='stylesheet' type='text/css' href='/css/tui/lint.css'/>
<link rel='stylesheet' type='text/css' href='/css/tui/neo.css'/>

<script type='text/javascript' src='/js/tui/core.js'></script>
<script type='text/javascript' src='/js/tui/tui-code-snippet.min.js'></script>
<script type='text/javascript' src='/js/tui/raphael.js'></script>
<script type='text/javascript' src='/js/tui/tui-chart.js'></script>
<script>

$(document).ready(function(){
	$(".tui-chart-chartExportMenu-area").hide();
});
</script>

<body>
	<%@ include file="../template/topMenu.jsp" %>
	<%@ include file="../template/topNav.jsp" %>

	<div class='wrap'>
    <div class='code-html' id='code-html'>
                    <div class="board_view mT20">
                    <table>
                            <tbody>
                                <tr>
                                    <td class="subject"><c:out value="${pcvo.pc_hostname}" /></td>
                                </tr>
                                <tr>
                                    <td>
                                        <ul>
                                            <li>Cpu정보 : <c:out value="${pcvo.pc_cpu}" /></li>
                                            <li>Memory정보  : <c:out value="${pcvo.pc_memory}" /></li>
                                            <li>Disk정보 : <c:out value="${pcvo.pc_disk}" /></li>
                                            <li>MacAddress : <c:out value="${pcvo.pc_macaddress}" /></li>
                                            <li>IpAddress : <c:out value="${pcvo.pc_ip}" /></li>
                                            <li>VpnIpAddress : <c:out value="${pcvo.pc_vpnip}" /></li>
                                            <li>PC MachineId: <c:out value="${pcvo.pc_uuid}" /></li>
                                        </ul>
                                    </td>
                                </tr>
                                </tbody>
                                </table>
                    </div>
    <div>
        <div id='chart-area'></div>
        <div id='chart-area2'></div>
        </div>
        <div>
        <div id='chart-area3'></div>
        <div id='chart-area4'></div>
        </div>
    </div>
    <div class='custom-area'>
        <div id='error-dim'>
            <span id='error-text'></span>
            <div id='error-stack'></div>
            <span id='go-to-dev-tool'></span>
        </div>
    </div>
</div>
<%@ include file="../template/footer.jsp" %>
	
	<script class='code-js'id='code-js' >
	
	function getRandom(start, end) {
	    return start + (Math.floor(Math.random() * (end - start + 1)));
	}

	function zeroFill(number) {
	    var filledNumber;

	    if (number < 10) {
	        filledNumber = '0' + number;
	    } else {
	        filledNumber = number;
	    }

	    return filledNumber;
	}

	function adjustTime(time, addTime) {
	    addTime = addTime || 60;
	    if (time < 0) {
	        time += addTime;
	    }
	    return time;
	}

	function makeDate(hour, minute, second) {
	    return zeroFill(adjustTime(hour, 24)) + ':' + zeroFill(adjustTime(minute)) + ':' + zeroFill(adjustTime(second));
	}

	var legends = ['used메모리','slab_unrecl메모리','slab_recl메모리','free메모리','cached메모리','buffered메모리'];
	var legends2 = ['usedCPU'];
	var seriesData = tui.util.map(tui.util.range(6), function (value, index) {
	    var name = legends[index];
	    var data = tui.util.map(tui.util.range(40), function () {
	        return 0;
	    });
	    return {
	        name: name,
	        data: data
	    };
	});
	var seriesData2 = tui.util.map(tui.util.range(1), function (value, index) {
	    var name = legends2[index];
	    var data = tui.util.map(tui.util.range(40), function () {
	        return 0;
	    });
	    return {
	        name: name,
	        data: data
	    };
	});
	var baseNow = new Date();
	var startSecond = baseNow.getSeconds() - seriesData[0].data.length - 1;
	var categories = tui.util.map(seriesData[0].data, function (value, index) {
	    var hour = baseNow.getHours();
	    var minute = baseNow.getMinutes();
	    var second = startSecond + index;

	    if (second < 0) {
	        minute -= 1;
	    }

	    if (minute < 0) {
	        hour -= 1;
	    }
	    return makeDate(hour, minute, (startSecond + index));
	});
	var categories2 = tui.util.map(seriesData2[0].data, function (value, index) {
	    var hour = baseNow.getHours();
	    var minute = baseNow.getMinutes();
	    var second = startSecond + index;

	    if (second < 0) {
	        minute -= 1;
	    }

	    if (minute < 0) {
	        hour -= 1;
	    }
	    return makeDate(hour, minute, (startSecond + index));
	});
	var container = document.getElementById('chart-area');
	var container2 = document.getElementById('chart-area2');
	var data = {
	    categories: categories,
	    series: seriesData
	};
	var data2 = {
		    categories: categories2,
		    series: seriesData2
		};
	var options = {
	    chart: {
	        width: 1900,
	        height: 410,
	        title: 'memory 사용량'
	    },
	    xAxis: {
	        title: '시간',
	        labelInterval: 3,
	        tickInterval: 'auto'
	    },
	    yAxis: {
	        title: '사용량 ',
	        suffix: '%',
	        min: 0,
	        max: 100
	    },
	    series: {
	        spline: true,
	        showDot: true,
	        shifting: true
	    },
	    tooltip: {
	        grouped: true
	    }
	};
	var options2 = {
		    chart: {
		        width: 1850,
		        height: 410,
		        title: 'cpu 사용량'
		    },
		    xAxis: {
		        title: '시간',
		        labelInterval: 3,
		        tickInterval: 'auto'
		    },
		    yAxis: {
		        title: '사용량 ',
		        suffix: '%',
		        min: 0,
		        max: 100
		    },
		    series: {
		        spline: true,
		        showDot: true,
		        shifting: true
		    },
		    tooltip: {
		        grouped: true
		    }
		};
	var chart = tui.chart.lineChart(container, data, options);
	var chart2 = tui.chart.lineChart(container2, data2, options2);

	chart.on('load', function () {
	    var index = categories.length;
	    setInterval(function () {
	    		 $.post("memoryUsage.do",{dataType:'json',uuid:'${uuid}'},
	    		function(data){
	    			var values = [];
	    			var agrs = data;
	    			for(var i = 0; i < agrs.length;i++){
	    				values.push(agrs[i].memory);
	    			}
	        var now = new Date();
	        var category = makeDate(now.getHours(), now.getMinutes(), now.getSeconds());

	        chart.addData(category, values);
	        index += 1;
	    		 });
	    }, 5000);
	});  
	 chart2.on('load', function () {
		    var index = categories.length;
		    setInterval(function () {
		    		 $.post("cpuUsage.do",{dataType:'json',uuid:'${uuid}'},
		    		function(data){
		    			var values = [];
		    			var agrs = data;
		    			for(var i = 0; i < agrs.length;i++){
		    			console.log("agrs"+i+"===="+agrs[i].cpu);
		    			values.push(agrs[i].cpu);
		    			}
		        var now = new Date();
		        var category = makeDate(now.getHours(), now.getMinutes(), now.getSeconds());

		        chart2.addData(category, values);
		        index += 1;
		    		 });
		    }, 5000);
		}); 
	

</script>
</body>
</html>