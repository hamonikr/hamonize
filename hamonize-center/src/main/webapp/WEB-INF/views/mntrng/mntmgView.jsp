<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>
<%@ include file="../template/left.jsp" %>


<script type="text/javascript" src="/js/ztree/fuzzysearch.js"></script>
<script type="text/javascript" src="/js/ztree/jquery.ztree.exhide.js"></script>

<section class="scrollable">
	<section class="hbox stretch">
		<!-- body left Start  -->
		<!-- <%@ include file="../template/orgTree.jsp" %> -->
		<!-- body left End  -->


		<!-- body right -->
		<aside class="bg-white">
			<section class="vbox">
				<section class="scrollable">
					<div class="wrapper">

						<!-- 상세 페이지인경우 페이지 네비을 본문 상단에 표시한다.-->
						<ul class="breadcrumb no-border no-radius b-b b-light pull-in">
							<li><a href="javascript:;"><i class="fa fa-home"></i> Home</a></li>
							<li><a href="/mntrng/pcControlList"> 모니터링</a></li>
							<li class="active"> 모니터링 상세</li>
						</ul>
						<section class="panel ">
							

							<div class="col-sm-12">


								<section class="panel panel-default">

									<header class="panel-heading bg-light">
										<span class="hidden-sm">컴퓨터 정보</span>
									</header>
									<div class="panel-body">
										<h5>Device Hostname :
											<c:out value="${pcvo.pc_hostname}" />
										</h5>
										<h5>Device MachineId :
											<c:out value="${pcvo.pc_uuid}" />
										</h5>

										<h5>Cpu정보 :
											<c:out value="${pcvo.pc_cpu}" />
										</h5>
										<h5>Memory정보:
											<c:out value="${pcvo.pc_memory}" />
										</h5>
										<h5>Disk정보:
											<c:out value="${pcvo.pc_disk}" />
										</h5>
										<h5>IpAddress:
											<c:out value="${pcvo.pc_ip}" />
										</h5>
										<h5>VpnIpAddress:
											<c:out value="${pcvo.pc_vpnip}" />
										</h5>
										<h5>MacAddress:
											<c:out value="${pcvo.pc_macaddress}" />
										</h5>

									</div>

									<div class="row">
										<div class="col-md-12">
											<section class="panel panel-default">
												<header class="panel-heading font-bold">실시간 사용 정보</header>
												<div class="panel-body">
													<iframe title="Monitoring detail view" src="http://${gvo.svr_ip}:${gvo.svr_port}/d-solo/IDKTE7Gnz/hamonize-monitoring2?orgId=1&refresh=10s&var-uuid=${pcvo.pc_uuid}&panelId=7" width="19.5%" height="200" frameborder="1"></iframe>
													<iframe title="Monitoring detail view" src="http://${gvo.svr_ip}:${gvo.svr_port}/d-solo/IDKTE7Gnz/hamonize-monitoring2?orgId=1&refresh=10s&var-uuid=${pcvo.pc_uuid}&panelId=9" width="19.5%" height="200" frameborder="1"></iframe>
													<iframe title="Monitoring detail view" src="http://${gvo.svr_ip}:${gvo.svr_port}/d-solo/IDKTE7Gnz/hamonize-monitoring2?orgId=1&refresh=10s&var-uuid=${pcvo.pc_uuid}&panelId=11" width="19.5%" height="200" frameborder="1"></iframe>
													<iframe title="Monitoring detail view" src="http://${gvo.svr_ip}:${gvo.svr_port}/d-solo/IDKTE7Gnz/hamonize-monitoring2?orgId=1&refresh=10s&var-uuid=${pcvo.pc_uuid}&panelId=14" width="19.5%" height="200" frameborder="1"></iframe>
													<iframe title="Monitoring detail view" src="http://${gvo.svr_ip}:${gvo.svr_port}/d-solo/IDKTE7Gnz/hamonize-monitoring2?orgId=1&refresh=10s&var-uuid=${pcvo.pc_uuid}&panelId=13" width="19.5%" height="200" frameborder="1"></iframe>
												</div>
											</section>
										</div>
									</div>

									<div class="row">
										<div class="col-md-12">
											<section class="panel panel-default">
												<header class="panel-heading font-bold">그래프 정보</header>
												<div class="panel-body">
													<iframe title="Monitoring detail view" src="http://${gvo.svr_ip}:${gvo.svr_port}/d-solo/IDKTE7Gnz/hamonize-monitoring2?orgId=1&refresh=10s&var-uuid=${pcvo.pc_uuid}&panelId=2" width="49.5%" height="300" frameborder="1"></iframe>
													<iframe title="Monitoring detail view" src="http://${gvo.svr_ip}:${gvo.svr_port}/d-solo/IDKTE7Gnz/hamonize-monitoring2?orgId=1&refresh=10s&var-uuid=${pcvo.pc_uuid}&panelId=5" width="49.5%" height="300" frameborder="1"></iframe>
													<iframe title="Monitoring detail view" src="http://${gvo.svr_ip}:${gvo.svr_port}/d-solo/IDKTE7Gnz/hamonize-monitoring2?orgId=1&refresh=10s&var-uuid=${pcvo.pc_uuid}&panelId=4" width="49.5%" height="300" frameborder="1"></iframe>
													<iframe title="Monitoring detail view" src="http://${gvo.svr_ip}:${gvo.svr_port}/d-solo/IDKTE7Gnz/hamonize-monitoring2?orgId=1&refresh=10s&var-uuid=${pcvo.pc_uuid}&panelId=3" width="49.5%" height="300" frameborder="1"></iframe>
												</div>
											</section>
										</div>
									</div>

								</section>
								<!-- </form> -->

							</div>

						</section>

					</div>
				</section>
			</section>
		</aside>


	</section>
</section>



<%@ include file="../template/footer.jsp" %>