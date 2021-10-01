<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>

<style>
.box {
	border: 1px solid rgb(112, 112, 112);
  background-color: rgb(255, 255, 255);
  padding: 40px;
  margin: 40px;
  width: 100px;
  height: 70px;
  display: inline-block;
  vertical-align: top;
}
.callout{border-radius:.25rem;box-shadow:0 1px 3px rgba(0,0,0,.12),0 1px 2px rgba(0,0,0,.24);background-color:#fff;border-left:5px solid #e9ecef;margin-bottom:1rem;padding-left: 10px;}.callout a{color:#495057;text-decoration:underline}.callout a:hover{color:#e9ecef}.callout p:last-child{margin-bottom:0}
.callout.callout-info{border-left-color:#117a8b}
</style>
<script>

$(document).ready(function(){
	$(".tui-chart-chartExportMenu-area").hide();
	$( "#deviceInfo" ).slideToggle( "slow" ); 

$( "#sp_on" ).click(function() {  
	$( "#deviceInfo" ).slideToggle( "slow" ); 
	if(document.getElementById('sp_on').innerText=="▲닫기"){
		document.getElementById('sp_on').innerText="▼펼치기";
	}else{
		document.getElementById('sp_on').innerText="▲닫기";
	}
});
});
</script>

<body>
	<%@ include file="../template/topMenu.jsp" %>
	<%@ include file="../template/topNav.jsp" %>
	<div class='wrap'>
    <div class='code-html' id='code-html'>
		<div class="main_title" style="margin-top: 20px; ">
		<span id="sp_on">▼펼치기</span>
			컴퓨터 정보
			&nbsp;
			<c:if test ="${svo.svr_used == 1}" >
				<button type="button" class="btn btn-link" onClick="location.href='hamonizecli://${pcvo.pc_vpnip}'">원격접속</button>
			</c:if>
			<c:if test ="${svo.svr_used == 0}" >
				<button type="button" class="btn btn-link" onClick="location.href='hamonizecli://${pcvo.pc_ip}'">원격접속</button>
			</c:if>

		<span></span>
		</div>

		 <div style="display: inline-block; width: 43%; vertical-align: top; margin-right: 6%">
			<div class="callout callout-info">
				<h5>Device Hostname <p><c:out value="${pcvo.pc_hostname}" /></p></h5>
			  </div>
		</div>
		<div style="display: inline-block; width: calc(100% - 54%); vertical-align: top;">
			<div class="callout callout-info">
				<h5>Device MachineId <p><c:out value="${pcvo.pc_uuid}" /></p></h5>
			  </div>
		</div>
<br>			
		<div id="deviceInfo">
            <!--- 좌측 -->
            <div style="display: inline-block; width: 43%; vertical-align: top; margin-right: 6%">
			<div class="callout callout-info">
				<h5>Cpu정보</h5>
				<p><c:out value="${pcvo.pc_cpu}" /></p>
			  </div>
			  <div class="callout callout-info">
				<h5>Memory정보</h5>
				<p><c:out value="${pcvo.pc_memory}" /></p>
			  </div>
			  <div class="callout callout-info">
				<h5>Disk정보</h5>
				<p><c:out value="${pcvo.pc_disk}" /></p>
			  </div> 
			</div>
			<div style="display: inline-block; width: calc(100% - 54%); vertical-align: top;">
			  <div class="callout callout-info">
				<h5>IpAddress</h5>
				<p><c:out value="${pcvo.pc_ip}" /></p>
			  </div>
			 
			<c:if test="${svo.svr_used == 1}">
			  <div class="callout callout-info">
				<h5>VpnIpAddress</h5>
				<p><c:out value="${pcvo.pc_vpnip}" /></p>
			  </div>
     		</c:if> 
			
			 <div class="callout callout-info">
				<h5>MacAddress</h5>
				<p><c:out value="${pcvo.pc_macaddress}" /></p>
			  </div>		
			</div>			
		</div>
					<div>
						<div style="margin-bottom: 50px;">
							<div class="main_title" style="margin-bottom: 20px;">
								실시간 사용 정보
							<span></span>
							</div>
							<iframe title="Monitoring detail view" src="http://${gvo.svr_ip}:3000/d-solo/IDKTE7Gnz/hamonize-monitoring?orgId=1&refresh=10s&var-host=${pcvo.pc_uuid}&panelId=7" width="19.5%" height="200" frameborder="1"></iframe>
							<iframe title="Monitoring detail view" src="http://${gvo.svr_ip}:3000/d-solo/IDKTE7Gnz/hamonize-monitoring?orgId=1&refresh=10s&var-host=${pcvo.pc_uuid}&panelId=9" width="19.5%" height="200" frameborder="1"></iframe>
							<iframe title="Monitoring detail view" src="http://${gvo.svr_ip}:3000/d-solo/IDKTE7Gnz/hamonize-monitoring?orgId=1&refresh=10s&var-host=${pcvo.pc_uuid}&panelId=11" width="19.5%" height="200" frameborder="1"></iframe>
							<iframe title="Monitoring detail view" src="http://${gvo.svr_ip}:3000/d-solo/IDKTE7Gnz/hamonize-monitoring?orgId=1&refresh=10s&var-host=${pcvo.pc_uuid}&panelId=14" width="19.5%" height="200" frameborder="1"></iframe>
							<iframe title="Monitoring detail view" src="http://${gvo.svr_ip}:3000/d-solo/IDKTE7Gnz/hamonize-monitoring?orgId=1&refresh=10s&var-host=${pcvo.pc_uuid}&panelId=13" width="19.5%" height="200" frameborder="1"></iframe>
						</div>
						<div style="margin:0 auto;">
							<div class="main_title" style="margin-bottom: 20px;">
								그래프 정보
							<span></span>
							</div>
							<iframe title="Monitoring detail view" src="http://${gvo.svr_ip}:3000/d-solo/IDKTE7Gnz/hamonize-monitoring?orgId=1&refresh=10s&var-host=${pcvo.pc_uuid}&panelId=2" width="49.5%" height="300" frameborder="1"></iframe>
							<iframe title="Monitoring detail view" src="http://${gvo.svr_ip}:3000/d-solo/IDKTE7Gnz/hamonize-monitoring?orgId=1&refresh=10s&var-host=${pcvo.pc_uuid}&panelId=5" width="49.5%" height="300" frameborder="1"></iframe>
							<iframe title="Monitoring detail view" src="http://${gvo.svr_ip}:3000/d-solo/IDKTE7Gnz/hamonize-monitoring?orgId=1&refresh=10s&var-host=${pcvo.pc_uuid}&panelId=4" width="49.5%" height="300" frameborder="1"></iframe>
							<iframe title="Monitoring detail view" src="http://${gvo.svr_ip}:3000/d-solo/IDKTE7Gnz/hamonize-monitoring?orgId=1&refresh=10s&var-host=${pcvo.pc_uuid}&panelId=3" width="49.5%" height="300" frameborder="1"></iframe>

						</div>
					</div>
    </div>
</div>
<%@ include file="../template/footer.jsp" %>
</body>
</html>