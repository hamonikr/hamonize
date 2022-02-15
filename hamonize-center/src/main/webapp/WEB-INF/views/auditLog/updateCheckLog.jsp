<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>
<%@ include file="../template/left.jsp" %>



<script>
	$(document).ready(function () {

		// getList();
		// //등록버튼
		// $("#excelBtn").on("click", function () {
		// 	location.href = "prcssBlockLogExcel?org_seq=" + $("#org_seq").val() + "&date_fr=" + $(
		// 			"#date_fr").val() + "&date_to=" + $("#date_to").val() + "&txtSearch=" + $("#txtSearch")
		// 		.val() + "&keyWord=" + $("#keyWord").val();
		// });
		// $("#txtSearch").keydown(function (key) {
		// 	if (key.keyCode == 13) {
		// 		key.preventDefault();
		// 		getList();
		// 	}
		// });


	});

	function onCheck(event, treeId, treeNode) {}

	function beforeClick(treeId, treeNode, clickFlag) {
		className = (className === "dark" ? "" : "dark");
		return (treeNode.click != false);
	}
	//메뉴 Tree onClick - 부서별 정책 결과
	function onClick(event, treeId, treeNode, clickFlag) {

		$(".right_box_l").empty();

		// $(".monitor_list").remove();
		// $("#list_info").empty();
		// $(".info").empty();
		// $(".result_detail").remove();
		// $(".content_bapo").remove();
		// $(".veiwcheck").css("display", "block");

		var cnt = 0;
		var zTree = $.fn.zTree.getZTreeObj("tree");
		var node = zTree.getNodeByParam('id', treeNode.pId);
		// if (node == null) {
		// 	$(".right_box_r").hide();
		// 	$('.right_box_l').width('100%');
		// } else {
		// 	$(".right_box_r").show();
		// 	$('.right_box_l').width('40%');
		// }


		$("#org_seq").val(treeNode.id);

		$.post("/mntrng/pcPolicyList", {
				org_seq: treeNode.id,
				type: 'view'
			},
			function (data) {
				var shtml = "";
				var shtml_r = "";

				var textCutLength = 20;

				$(".programResultTr").empty();
				$(".programResultTbody").empty();
				var programResultTrHtml = '<th data-property="toponymName" class="sortable">프로그램명</th>';
				programResultTrHtml += '<th data-property="countrycode" class="sortable">버전</th>';
				programResultTrHtml += '<th data-property="population" class="sortable">구분</th>';
				programResultTrHtml += '<th data-property="fcodeName" class="sortable">전체</th>';
				programResultTrHtml += '<th data-property="fcodeName" class="sortable">완료</th>';
				programResultTrHtml += '<th data-property="geonameId" class="sortable">미완료</th>';
				$(".programResultTr").append(programResultTrHtml);
				

				$(".programBlockResultTr").empty();
				$(".programBlockResultTbody").empty();
				var programBlockResultTrHtml = '<th data-property="toponymName" class="sortable">프로그램명</th>';
				programBlockResultTrHtml += '<th data-property="population" class="sortable">구분</th>';
				programBlockResultTrHtml += '<th data-property="fcodeName" class="sortable">전체</th>';
				programBlockResultTrHtml += '<th data-property="geonameId" class="sortable">완료</th>';
				programBlockResultTrHtml += '<th data-property="geonameId" class="sortable">미완료</th>';
				$(".programBlockResultTr").append(programBlockResultTrHtml);

				
				$(".firewallResultTr").empty();
				$(".firewallResultTbody").empty();
				var firewallResultTrHtml = '<th data-property="toponymName" class="sortable">포트번호</th>';
				firewallResultTrHtml += '<th data-property="population" class="sortable">구분</th>';
				firewallResultTrHtml += '<th data-property="fcodeName" class="sortable">전체</th>';
				firewallResultTrHtml += '<th data-property="fcodeName" class="sortable">완료</th>';
				firewallResultTrHtml += '<th data-property="geonameId" class="sortable">미완료</th>';
				$(".firewallResultTr").append(firewallResultTrHtml);


				$(".deviceResultTr").empty();
				$(".deviceResultTbody").empty();
				var deviceResultTrHtml = '<th data-property="toponymName" class="sortable">포트번호</th>';
				deviceResultTrHtml += '<th data-property="population" class="sortable">구분</th>';
				deviceResultTrHtml += '<th data-property="fcodeName" class="sortable">전체</th>';
				deviceResultTrHtml += '<th data-property="fcodeName" class="sortable">완료</th>';
				deviceResultTrHtml += '<th data-property="geonameId" class="sortable">미완료</th>';
				$(".deviceResultTr").append(deviceResultTrHtml);
				
				if (data.pcList.length > 0) {



// ========================================= aa
					// 선택한 조직의 pc 목록
					shtml += '<ul class="monitor_list">';
					$.each(data.pcList, function (index, value) {
						var hostnameVal = '';
						if (value.pc_hostname.length >= textCutLength) {
							hostnameVal = value.pc_hostname.substr(0, textCutLength) + '...';
						} else {
							hostnameVal = value.pc_hostname;
						}
						if (value.pc_status == "true") {
							cnt++;
							shtml += "<li class='on'><a href='#' data-toggle='tooltip' title='" + value
								.pc_hostname + "' onclick=\"detail('" + value.pc_uuid + "')\">" + hostnameVal +
								"</a></li>";
						} else
							shtml += "<li><a style='color:#555;' href='#' data-toggle='tooltip' title='" +
							value.pc_hostname + "' onclick=\"detail('" + value.pc_uuid + "')\">" +
							hostnameVal + "</a></li>";

					});

// <ul class="monitor_list"><li>
// <a style="color:#555;" href="#" data-toggle="tooltip" title="hamonize-clientpc2" onclick="detail('7490a9f7d989432b9f0f5314ce82e956')">hamonize-clientpc2</a></li><li class="on"><a href="#" data-toggle="tooltip" title="hamonize-clientpc" onclick="detail('3571bd5fea17439e80e1f2d05b3bd2ad')">hamonize-clientpc</a></li></ul>

					$(".right_box_l").append(shtml);


					// 프로그램 설치 결과 전체 =======================================================

					

					var progrmResultHtml = "";
					for (var i = 0; i < data.policyUpdtResult.length; i++) {
						var chk = 1;
						if ((i + 1) == data.policyUpdtResult.length) {
							chk = 0;
						}
						if (data.policyUpdtResult[i].debname != data.policyUpdtResult[i + chk].debname) {
							var inset_dt = data.policyUpdtResult[i].ins_date;
							var date = new Date(inset_dt);
							date = date.getFullYear() + "-" + addZero(date.getMonth() + 1) + "-" + addZero(date.getDate().toString()) + " " + addZero(date.getHours().toString()) + ":" + addZero(date.getMinutes().toString()) + ":" + addZero(date.getSeconds().toString());

							//성공여부 체크 카운트
							if (data.policyUpdtResult[i].gubun == "INSTALL" || data.policyUpdtResult[i].gubun == "UPGRADE") {
								if (data.policyUpdtResult[i].state == 0) {
									data.policyUpdtResult[i].count--;
								}

							} else if (data.policyUpdtResult[i].gubun == "DELETE") {
								if (data.policyUpdtResult[i].state == 1) {
									data.policyUpdtResult[i].count--;
								}
							}
							var noinstall = data.pcList.length - data.policyUpdtResult[i].count;
							progrmResultHtml += "<tr>";
							progrmResultHtml += "<td>" + data.policyUpdtResult[i].debname + "</td>";
							if (typeof data.policyUpdtResult[i].debver === "undefined")
								progrmResultHtml += "<td>-</td>";
							else
								progrmResultHtml += "<td>" + data.policyUpdtResult[i].debver + "</td>";

							progrmResultHtml += "<td>" + data.policyUpdtResult[i].gubun + "</td>";
							progrmResultHtml += "<td>" + data.pcList.length + "</td>";
							progrmResultHtml += "<td>" + data.policyUpdtResult[i].count + "</td>";
							progrmResultHtml += "<td>" + noinstall + "</td>";
							progrmResultHtml += "</tr>";

						} else if ((i + 1) == data.policyUpdtResult.length) {
							var inset_dt = data.policyUpdtResult[i].ins_date;
							var date = new Date(inset_dt);
							date = date.getFullYear() + "-" + addZero(date.getMonth() + 1) + "-" + addZero(date.getDate().toString()) + " " + addZero(date.getHours().toString()) + ":" + addZero(date.getMinutes().toString()) + ":" + addZero(date.getSeconds().toString());
							//성공여부 체크 카운트
							if (data.policyUpdtResult[i].gubun == "INSTALL" || data.policyUpdtResult[i].gubun ==
								"UPGRADE") {
								if (data.policyUpdtResult[i].state == 0) {
									data.policyUpdtResult[i].count--;
								}

							} else if (data.policyUpdtResult[i].gubun == "DELETE") {
								if (data.policyUpdtResult[i].state == 1) {
									data.policyUpdtResult[i].count--;
								}
							}

							var noinstall = data.pcList.length - data.policyUpdtResult[i].count;
							progrmResultHtml += "<tr>";
							progrmResultHtml += "<td>" + data.policyUpdtResult[i].debname + "</td>";
							progrmResultHtml += "<td>" + data.policyUpdtResult[i].debver + "</td>";
							progrmResultHtml += "<td>" + data.policyUpdtResult[i].gubun + "</td>";
							progrmResultHtml += "<td>" + data.pcList.length + "</td>";
							progrmResultHtml += "<td>" + data.policyUpdtResult[i].count + "</td>";
							progrmResultHtml += "<td>" + noinstall + "</td>";
							progrmResultHtml += "</tr>";
						}
					}

					if(data.policyUpdtResult.length == 0){
						$(".programResultTbody").append('<tr><td colspan="6">등록된 데이터가 없습니다.</td></tr>');
					}
					
					$(".programResultTbody").append(progrmResultHtml);


					//프로그램 차단 배포 결과 ==============================================================================================


					console.log("data.policyProgrmResult.length========+++"+ data.policyProgrmResult.length);
					var programBlockResult = '';
					for (var i = 0; i < data.policyProgrmResult.length; i++) {
						var chk = 1;
						if ((i + 1) == data.policyProgrmResult.length) {
							chk = 0;
						}
						if (data.policyProgrmResult[i].progrmname != data.policyProgrmResult[i + chk].progrmname) {
							var inset_dt = data.policyProgrmResult[i].ins_date;
							var date = new Date(inset_dt);
							date = date.getFullYear() + "-" + addZero(date.getMonth() + 1) + "-" + addZero(date.getDate().toString()) + " " + addZero(date.getHours().toString()) + ":" + addZero(date.getMinutes().toString()) + ":" + addZero(date.getSeconds().toString());
							var noinstall = data.pcList.length - data.policyProgrmResult[i].count;
							programBlockResult += "<tr>";
							programBlockResult += "<td>" + data.policyProgrmResult[i].progrmname + "</td>";
							programBlockResult += "<td>" + data.policyProgrmResult[i].status_yn + "</td>";
							programBlockResult += "<td>" + data.pcList.length + "</td>";
							programBlockResult += "<td>" + data.policyProgrmResult[i].count + "</td>";
							programBlockResult += "<td>" + noinstall + "</td>";
							programBlockResult += "</tr>";
						} else if ((i + 1) == data.policyProgrmResult.length) {
							var inset_dt = data.policyProgrmResult[i].ins_date;
							var date = new Date(inset_dt);
							date = date.getFullYear() + "-" + addZero(date.getMonth() + 1) + "-" + addZero(date.getDate().toString()) + " " + addZero(date.getHours().toString()) + ":" + addZero(date.getMinutes().toString()) + ":" + addZero(date.getSeconds().toString());
							var noinstall = data.pcList.length - data.policyProgrmResult[i].count;
							programBlockResult += "<tr>";
							programBlockResult += "<td>" + data.policyProgrmResult[i].progrmname + "</td>";
							programBlockResult += "<td>" + data.policyProgrmResult[i].status_yn + "</td>";
							programBlockResult += "<td>" + data.pcList.length + "</td>";
							programBlockResult += "<td>" + data.policyProgrmResult[i].count + "</td>";
							programBlockResult += "<td>" + noinstall + "</td>";
							programBlockResult += "</tr>";
						}
					}

					if(data.policyProgrmResult.length == 0){
						$(".programBlockResultTbody").append('<tr><td colspan="5">등록된 데이터가 없습니다.</td></tr>');
					}
					

					$(".programBlockResultTbody").append(programBlockResult);

					//방화벽 차단 배포 결과 // ========================================================================
					

					var firewallResult = '';
					for (var i = 0; i < data.policyFirewallResult.length; i++) {
						var chk = 1;
						if ((i + 1) == data.policyFirewallResult.length) {
							chk = 0;
						}
						if (data.policyFirewallResult[i].retport != data.policyFirewallResult[i + chk].retport) {
							var inset_dt = data.policyFirewallResult[i].ins_date;
							var date = new Date(inset_dt);
							date = date.getFullYear() + "-" + addZero(date.getMonth() + 1) + "-" + addZero(date.getDate().toString());
							var noinstall = data.pcList.length - data.policyFirewallResult[i].count;
							firewallResult += "<tr>";
							firewallResult += "<td>" + data.policyFirewallResult[i].retport + "</td>";
							firewallResult += "<td>" + data.policyFirewallResult[i].status + "</td>";
							firewallResult += "<td>" + data.pcList.length + "</td>";
							firewallResult += "<td>" + data.policyFirewallResult[i].count + "</td>";
							firewallResult += "<td>" + noinstall + "</td>";
							firewallResult += "</tr>";
						} else if ((i + 1) == data.policyFirewallResult.length) {
							var inset_dt = data.policyFirewallResult[i].ins_date;
							var date = new Date(inset_dt);
							date = date.getFullYear() + "-" + addZero(date.getMonth() + 1) + "-" + addZero(date.getDate().toString());
							var noinstall = data.pcList.length - data.policyFirewallResult[i].count;
							firewallResult += "<tr>";
							firewallResult += "<td>" + data.policyFirewallResult[i].retport + "</td>";
							firewallResult += "<td>" + data.policyFirewallResult[i].status + "</td>";
							firewallResult += "<td>" + data.pcList.length + "</td>";
							firewallResult += "<td>" + data.policyFirewallResult[i].count + "</td>";
							firewallResult += "<td>" + noinstall + "</td>";
							firewallResult += "</tr>";
						}
					}
					if(data.policyFirewallResult.length == 0){
						$(".firewallResultTbody").append('<tr><td colspan="5">등록된 데이터가 없습니다.</td></tr>');
					}
					$(".firewallResultTbody").append(firewallResult);

					//디바이스 차단 배포 결과 ================================================

					var deviceResult = '';					
					for (var i = 0; i < data.policyDeviceResult.length; i++) {
						var chk = 1;
						if ((i + 1) == data.policyDeviceResult.length) {
							chk = 0;
						}
						if (data.policyDeviceResult[i].product != data.policyDeviceResult[i + chk].product) {
							var inset_dt = data.policyDeviceResult[i].rgstr_date;
							var date = new Date(inset_dt);
							date = date.getFullYear() + "-" + addZero(date.getMonth() + 1) + "-" + addZero(date.getDate().toString()) + " " + addZero(date.getHours().toString()) + ":" + addZero( date.getMinutes().toString()) + ":" + addZero(date.getSeconds().toString());
							var noinstall = data.pcList.length - data.policyDeviceResult[i].count;
							deviceResult += "<tr>";
							deviceResult += "<td>" + data.policyDeviceResult[i].product + "</td>";
							deviceResult += "<td>" + data.policyDeviceResult[i].status + "</td>";
							deviceResult += "<td>" + data.pcList.length + "</td>";
							deviceResult += "<td>" + data.policyDeviceResult[i].count + "</td>";
							deviceResult += "<td>" + noinstall + "</td>";
							deviceResult += "</tr>";
						} else if ((i + 1) == data.policyDeviceResult.length) {
							var inset_dt = data.policyDeviceResult[i].rgstr_date;
							var date = new Date(inset_dt);
							date = date.getFullYear() + "-" + addZero(date.getMonth() + 1) + "-" + addZero(date.getDate().toString()) + " " + addZero(date.getHours().toString()) + ":" + addZero(date.getMinutes().toString()) + ":" + addZero(date.getSeconds().toString());
							var noinstall = data.pcList.length - data.policyDeviceResult[i].count;
							deviceResult += "<tr>";
							deviceResult += "<td>" + data.policyDeviceResult[i].product + "</td>";
							deviceResult += "<td>" + data.policyDeviceResult[i].status + "</td>";
							deviceResult += "<td>" + data.pcList.length + "</td>";
							deviceResult += "<td>" + data.policyDeviceResult[i].count + "</td>";
							deviceResult += "<td>" + noinstall + "</td>";
							deviceResult += "</tr>";
						}
					}
					if(data.policyDeviceResult.length == 0){
						$(".deviceResultTbody").append('<tr><td colspan="5">등록된 데이터가 없습니다.</td></tr>');
					}
					$(".deviceResultTbody").append(deviceResult);
					
					

				} else {
					shtml_r += "<tr><td colspan='7' style='text-align:center;'>등록된 데이터가 없습니다. </td></tr>";
				}

			});


	}
</script>

<section class="scrollable">
	<section class="hbox stretch">
		<!-- body left Start  -->
		<%@ include file="../template/orgTree.jsp" %>
		<!-- body left End  -->

<style>
.monitor_list li {
    width: 201.7px;
    display: inline-block;
    border-radius: 10px;
    color: #555;
    border: 1px solid #ddd;
    box-sizing: border-box;
    line-height: 22px;
    /* height: 100px; */
    vertical-align: middle;
    box-shadow: 0 1px 2px 0 rgb(0 0 0 / 10%);
    background-color: #fff;
    text-align: center;
    margin: 10px;
    vertical-align: middle;
    padding: 10px;
}
.monitor_list li.on {
    background-color: #7759c3;
    color: #fff;
    border: 1px solid #7759c3;
    box-shadow: 0 3px 2px 0 rgb(0 0 0 / 10%);
}
</style>
		<!-- body right -->
		<aside class="col-lg-4 b-l">
			<section class="vbox">
				<section class="scrollable">
					<div class="wrapper">
						<section class="panel panel-default">
							
							<div class="right_box_l"> 


							

								
							</div>
						</section>
					</div>
				</section>
			</section>
		</aside>


		<!-- body right -->
		<aside class="bg-white">
			<section class="vbox">
				<header class="header bg-light bg-gradient">
					<ul class="nav nav-tabs nav-white">
						<li class="active"><a href="#programResult" data-toggle="tab">프로그램 설치 정책 결과</a></li>
						<li class=""><a href="#progrmBlockResult" data-toggle="tab">프로그램 차단 정책 결과</a></li>
						<li class=""><a href="#firewallResult" data-toggle="tab">방화벽 정책 결과</a></li>
						<li class=""><a href="#deviceResult" data-toggle="tab">디바이스 정책 결과</a></li>
					</ul>
				</header>

				<section class="scrollable">
					<div class="tab-content">
						<div class="tab-pane active " id="programResult">
							<div class="table-responsive">
								<table  class="table table-striped datagrid m-b-sm">
									<thead>
										<tr class="programResultTr">
											
										</tr>
									</thead>
									<tbody class="programResultTbody"></tbody>
								</table>
							</div>					
						</div>

						<div class="tab-pane" id="progrmBlockResult">
							<div class="table-responsive">
								<table  class="table table-striped datagrid m-b-sm">
									<thead>
										<tr class="programBlockResultTr"></tr>
									</thead>
									<tbody class="programBlockResultTbody"></tbody>
								</table>
							</div>
						</div>
						
						<div class="tab-pane " id="firewallResult">
							<div class="table-responsive">
								<table  class="table table-striped datagrid m-b-sm">
									<thead>
										<tr class="firewallResultTr"></tr>
									</thead>
									<tbody class="firewallResultTbody"></tbody>
								</table>
							</div>
						</div>

						<div class="tab-pane " id="deviceResult">
							<div class="text-center wrapper">
								<div class="table-responsive">
									<table  class="table table-striped datagrid m-b-sm">
										<thead>
											<tr class="deviceResultTr"></tr>
										</thead>
										<tbody class="deviceResultTbody"></tbody>
									</table>
								</div>
							</div>
						</div>

					</div>
				</section>
			</section>
		</aside>


	</section>
</section>


<script>
	function getList() {
		var url = '/mntrng/pcList';
		var keyWord = $("select[name=keyWord]").val();
		var vData = "org_seq=2";
		callAjax('POST', url, vData, iNetLogGetSuccess, getError, 'json');
	}

	var iNetLogGetSuccess = function (data, status, xhr, groupId) {
		var cnt = 0;
		var gbInnerHtml = "";
		$('#pageGrideInListTb').empty();
		$("#pagginationInList").empty();
		if (data.length > 0) {
			$.each(data, function (index, value) {
				if (value.pc_status == "true") {
					cnt++;
				}

				$(".cyberinfo li").each(function (i, v) {
					if (i == 0) {
						$(this).html(
							"<span>패키지명</span>hamonize-process-block<br/>hamonize-system-init<br/>hamonize-process-mngr<br/>chromium-browser-l10n"
						);
						$(this).css("color", "#333");
					}
					if (i == 1)
						$(this).html("<span>전체</span>" + data.length + "대<br/>" + data.length +
							"대<br/>" + data.length + "대<br/>" + data.length + "대");
					if (i == 2)
						$(this).html("<span>설치</span>" + cnt + "대<br/>" + cnt + "대<br/>" + cnt +
							"대<br/>" + cnt + "대");
					if (i == 3)
						$(this).html("<span>미설치</span>" + (data.length - cnt) + "대<br/>" + (data
							.length - cnt) + "대<br/>" + (data.length - cnt) + "대<br/>" + (data
							.length - cnt) + "대");


				});


			});
		} else {
			gbInnerHtml += "<tr><td colspan='7' style='text-align:center;'>등록된 데이터가 없습니다. </td></tr>";
		}

		$('#pageGrideInListTb').append(gbInnerHtml);

	}

// pc 별상세 내역 출력
function detail(uuid){
		// $(".result_detail").remove();
		// $(".content_bapo").remove();
		// $(".right_box_r").show();
		// $('.right_box_l').width( '40%' );
	console.log("detail -=--- uuit ::: " + uuid);
	 $.post("detailPolicy.proc",{pc_uuid:uuid},
			function(data){
			var shtml = "";

			// 프로그램 설치/삭제 배포 결과] ===============================================================
			$(".programResultTr").empty();
			$(".programResultTbody").empty();

			var programResultTr = '<th data-property="toponymName" class="sortable">프로그램명</th>';
			programResultTr += '<th data-property="countrycode" class="sortable">버전</th>';
			programResultTr += '<th data-property="population" class="sortable">구분</th>';
			programResultTr += '<th data-property="fcodeName" class="sortable">상태</th>';
			programResultTr += '<th data-property="fcodeName" class="sortable">적용일</th>';
			$(".programResultTr").append(programResultTr);
			
			var programResult = '';
			console.log("data.udpt============+"+data.udpt);
			$.each(data.udpt, function(index, value) {
				var inset_dt = value.insert_dt;
				var date = new Date(inset_dt);
				
				date = date.getFullYear()+"-"+addZero(date.getMonth()+1)+"-"+addZero(date.getDate().toString())+" "+addZero(date.getHours().toString())+":"+addZero(date.getMinutes().toString());
				programResult += "<tr>";
				programResult += "<td>"+value.debname+"</td>";
				programResult += "<td>"+value.debver+"</td>";
				programResult += "<td>"+value.gubun+"</td>";
				
				
				if(value.gubun == "INSTALL" || value.gubun == "UPGRADE" ){
					if(value.state >= 1){
						programResult += "<td>완료</td>";
					}else{
						programResult += "<td>미완료</td>";
					}
				}else if(value.gubun == "DELETE"){
					if(value.state == 0){
						programResult += "<td>완료</td>";
					}else{
						programResult += "<td>미완료</td>";
					}
				}			
				programResult += "<td>"+date+"</td>";
				programResult += "</tr>";

			});	
			$(".programResultTbody").append(programResult);


			// 프로그램 차단 배포 결과] ===============================================================
			$(".programBlockResultTr").empty();
			$(".programBlockResultTbody").empty();

			var programBlockResultTrHtml = '<th data-property="toponymName" class="sortable">프로그램명</th>';
			programBlockResultTrHtml += '<th data-property="population" class="sortable">구분</th>';
			programBlockResultTrHtml += '<th data-property="fcodeName" class="sortable">적용여부</th>';
			programBlockResultTrHtml += '<th data-property="geonameId" class="sortable">적용일</th>';
			$(".programBlockResultTr").append(programBlockResultTrHtml);

			var programBlockResult = '';
			console.log("data.program==============+"+data.program);
			$.each(data.program, function(index, value) {
				var inset_dt = value.ins_date;
				var date = new Date(inset_dt);
			
				date = date.getFullYear()+"-"+addZero(date.getMonth()+1)+"-"+addZero(date.getDate().toString())+" "+addZero(date.getHours().toString())+":"+addZero(date.getMinutes().toString());
			
				programBlockResult += "<tr>";
				programBlockResult += "<td>"+value.progrmname+"</td>";
				if(value.status_yn == "Y")
					programBlockResult += "<td>차단</td>";
				else
					programBlockResult += "<td>허용</td>";
					programBlockResult += "<td>"+date+"</td>";
					programBlockResult += "</tr>";
			});	
			$(".programBlockResultTbody").append(programBlockResult);

			
			// 방화벽 정책 배포 결과] ===============================================================
			$(".firewallResultTr").empty();
			$(".firewallResultTbody").empty();
				
			var firewallResultTrHtml = '<th data-property="toponymName" class="sortable">포트번호</th>';
			firewallResultTrHtml += '<th data-property="population" class="sortable">상태</th>';
			firewallResultTrHtml += '<th data-property="fcodeName" class="sortable">적용여부</th>';
			firewallResultTrHtml += '<th data-property="fcodeName" class="sortable">적용일</th>';
			$(".firewallResultTr").append(firewallResultTrHtml);
			
			var firewallResult = '';
			$.each(data.firewall, function(index, value) {
				var inset_dt = value.ins_date;
				var date = new Date(inset_dt);
				date = date.getFullYear()+"-"+addZero(date.getMonth()+1)+"-"+addZero(date.getDate().toString())+" "+addZero(date.getHours().toString())+":"+addZero(date.getMinutes().toString());				shtml += "<tr>";
				firewallResult += "<tr>";
				firewallResult += "<td>"+value.retport+"</td>";
				firewallResult += "<td>"+value.status+"</td>";
				if(value.status_yn == "Y")
					firewallResult += "<td>완료</td>";
				else
					firewallResult += "<td>미완료</td>";
					firewallResult += "<td>"+date+"</td>";
					firewallResult += "</tr>";
			});	
			$(".firewallResultTbody").append(firewallResult);
	


			// 디바이스 정책 배포 결과] ===============================================================
			$(".deviceResultTr").empty();
			$(".deviceResultTbody").empty();
			var deviceResultTrHtml = '<th data-property="toponymName" class="sortable">디바이스</th>';
			deviceResultTrHtml += '<th data-property="population" class="sortable">적용여부</th>';
			deviceResultTrHtml += '<th data-property="fcodeName" class="sortable">전체</th>';
			deviceResultTrHtml += '<th data-property="fcodeName" class="sortable">적용일</th>';
			$(".deviceResultTr").append(deviceResultTrHtml);

			console.log(data.device);
			var deviceResult = '';
			$.each(data.device, function(index, value) {
				var inset_dt = value.rgstr_date;
				var date = new Date(inset_dt);
				
 				date = date.getFullYear()+"-"+addZero(date.getMonth()+1)+"-"+addZero(date.getDate().toString())+" "+addZero(date.getHours().toString())+":"+addZero(date.getMinutes().toString());				shtml += "<tr>";
				deviceResult += "<tr>";
				deviceResult += "<td>"+value.product+"("+value.vendorcode+":"+value.productcode+")</td>";
				if(value.status_yn == "Y")
					deviceResult += "<td>허용</td>";
				else
					deviceResult += "<td>차단</td>";
					deviceResult += "<td>"+date+"</td>";
					deviceResult += "</tr>";
			});	
			$(".deviceResultTbody").append(deviceResult);	
				
		
	}); 

}
function addZero(data){
    return (data<10) ? "0"+data : data;
}


</script>
<%@ include file="../template/footer.jsp" %>