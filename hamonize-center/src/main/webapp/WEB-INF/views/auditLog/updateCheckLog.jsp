<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>
<%@ include file="../template/left.jsp" %>



<script>
	function onCheck(event, treeId, treeNode) {}

	function beforeClick(treeId, treeNode, clickFlag) {
		className = (className === "dark" ? "" : "dark");
		return (treeNode.click != false);
	}
	
	function onClick(event, treeId, treeNode, clickFlag) {

		$(".right_box_l").empty();
		var cnt = 0;
		var zTree = $.fn.zTree.getZTreeObj("tree");
		var node = zTree.getNodeByParam('id', treeNode.pId);
		if(node == null ){
			onClick(null,$("#tree"),zNodes[1]);
			return false;
		}
		zTree.selectNode(zTree.getNodeByTId(treeNode.id));

		$("#org_seq").val(treeNode.id);
		$.post("/mntrng/pcPolicyList", {
				org_seq: treeNode.id,
				type: 'view',
				domain: treeNode.domain
			},
			function (data) {
				var shtml = "";
				var shtml_r = "";

				var textCutLength = 20;
				$(".viewPolicyDetail").show();
				$("#org_seq").val(treeNode.id);
				
				$(".programResultTr").empty();
				$(".programResultTbody").empty();
				var programResultTrHtml = '<th data-property="" class="sortable">정책 적용일</th>';
				programResultTrHtml += '<th data-property="toponymName" class="sortable">프로그램명</th>';
				programResultTrHtml += '<th data-property="population" class="sortable">구분</th>';
				programResultTrHtml += '<th data-property="fcodeName" class="sortable">전체</th>';
				programResultTrHtml += '<th data-property="fcodeName" class="sortable">완료</th>';
				programResultTrHtml += '<th data-property="geonameId" class="sortable">미완료</th>';
				$(".programResultTr").append(programResultTrHtml);
				

				$(".programBlockResultTr").empty();
				$(".programBlockResultTbody").empty();
				var programBlockResultTrHtml = '';
				programBlockResultTrHtml += '<th data-property="" class="sortable">정책 적용일</th>';
				programBlockResultTrHtml +='<th data-property="toponymName" class="sortable">프로그램명</th>';
				programBlockResultTrHtml += '<th data-property="population" class="sortable">구분</th>';
				programBlockResultTrHtml += '<th data-property="fcodeName" class="sortable">전체</th>';
				programBlockResultTrHtml += '<th data-property="geonameId" class="sortable">완료</th>';
				programBlockResultTrHtml += '<th data-property="geonameId" class="sortable">미완료</th>';
				$(".programBlockResultTr").append(programBlockResultTrHtml);

				
				$(".firewallResultTr").empty();
				$(".firewallResultTbody").empty();
				var firewallResultTrHtml = '<th data-property="" class="sortable">정책 적용일</th>';
				firewallResultTrHtml += '<th data-property="toponymName" class="sortable">포트번호</th>';
				firewallResultTrHtml += '<th data-property="population" class="sortable">구분</th>';
				firewallResultTrHtml += '<th data-property="fcodeName" class="sortable">전체</th>';
				firewallResultTrHtml += '<th data-property="fcodeName" class="sortable">완료</th>';
				firewallResultTrHtml += '<th data-property="geonameId" class="sortable">미완료</th>';
				$(".firewallResultTr").append(firewallResultTrHtml);


				$(".deviceResultTr").empty();
				$(".deviceResultTbody").empty();
				var deviceResultTrHtml = '<th data-property="" class="sortable">정책 적용일</th>';
				deviceResultTrHtml += '<th data-property="toponymName" class="sortable">디바이스</th>';
				deviceResultTrHtml += '<th data-property="population" class="sortable">구분</th>';
				deviceResultTrHtml += '<th data-property="fcodeName" class="sortable">전체</th>';
				deviceResultTrHtml += '<th data-property="fcodeName" class="sortable">완료</th>';
				deviceResultTrHtml += '<th data-property="geonameId" class="sortable">미완료</th>';
				$(".deviceResultTr").append(deviceResultTrHtml);
				
				if (data.pcList.length > 0) {



// ========================================= aa
					// 선택한 조직의 pc 목록
// 					shtml += '<ul class="monitor_list">';

// 						$("#ortParent").html('<i class="fa fa-home"></i>  '+treeNode.domain);
// 						$("#ortSub").html('<i class="fa fa-list-ul"></i>  '+treeNode.name);
						$("#ortParent").html(treeNode.name);
// 						$("#ortSub").html(treeNode.name);

					$.each(data.pcList, function (index, value) {
						var hostnameVal = '';
// 						let data = JSON.parse(value.data);
						if (value.pc_hostname.length >= textCutLength) {
							hostnameVal = value.pc_hostname.substr(0, textCutLength) + '...';
						} else {
							hostnameVal = value.pc_hostname;
						}
// 						if (value.pc_status == "true") {
// 							cnt++;
// 							shtml += "<li class='on'><a href='#' data-toggle='tooltip' title='" + value.pc_hostname + "' onclick=\"detail('" + value.pc_uuid + "')\"><span>" + hostnameVal +"</span></a>";
// 							shtml += "<input type='hidden' data-hostname='"+value.pc_hostname+"' name='pcuuid' value='"+value.pc_uuid+"'></li>";
// 						} else {
// 							shtml += "<li><a style='color:#555;' href='#' data-toggle='tooltip' title='" +value.pc_hostname + "' onclick=\"detail('" + value.pc_uuid + "')\"><span>" +hostnameVal + "</span></a>";
// 							shtml += "<input type='hidden' data-hostname='"+value.pc_hostname+"' name='pcuuid' value='"+value.pc_uuid+"'></li>";
// 						}
						
						shtml += '<div class="panel-body col-xs-6 monitor_list">';
						shtml += '<blockquote class="bodyDataLayer " onclick="detailPcInfo(\''+value.pc_uuid +'\')" style="font-size: 15.5px;">';
						shtml += '<span class="fa-stack pull-left m-r-sm" style="margin-left: -34px; margin-top: -15px;">';
						if (value.pc_status == "true") {
							shtml += '<i class="fa fa-play"></i>';
							shtml += "<input type='hidden' data-hostname='"+value.pc_hostname+"' name='pcuuid' value='"+value.pc_uuid+"'></li>";
						}else{
							shtml += '<i class="fa fa-pause"></i>';
							shtml += "<input type='hidden' data-hostname='"+value.pc_hostname+"' name='pcuuid' value='"+value.pc_uuid+"'></li>";
						}
						shtml +='</span>';
						shtml +=  hostnameVal +'</blockquote></div>';
						
// 						shtml +=  'aaaaaaaaawerwerwerwerweaaaaa</blockquote></div>';
						
					});

					$(".right_box_l").append(shtml);


					// 프로그램 설치 결과 전체 =======================================================

					var progrmResultHtml = "";
					$("#policyProgrmUpdtDetailData").val(data.policyUpdtResult[data.policyUpdtResult.length-1].run_status);
					console.log("data.policyUpdtResult.length==="+data.policyUpdtResult.length);
					for (var i = 0; i < data.policyUpdtResult.length; i++) {
						var noinstall = data.pcList.length - data.policyUpdtResult[i].count;
						
						progrmResultHtml += "<tr>";
						progrmResultHtml += "<td class='updtRgstrData'>" + data.policyUpdtResult[i].rgstr_date + "</td>";
						progrmResultHtml += "<td>" + data.policyUpdtResult[i].debname + "</td>";
						if (data.policyUpdtResult[i].gubun == "INSERT" || data.policyUpdtResult[i].gubun == "M") {
							progrmResultHtml += "<td>설치</td>";
						}else{
							progrmResultHtml += "<td>삭제</td>";
						}
						progrmResultHtml += "<td>" + data.pcList.length + "</td>";
						progrmResultHtml += "<td>" + data.policyUpdtResult[i].count + "</td>";
						progrmResultHtml += "<td>" + noinstall + "</td>";
						progrmResultHtml += "</tr>";
						
					}

					if(data.policyUpdtResult.length == 0){
						$(".programResultTbody").append('<tr><td colspan="6">등록된 데이터가 없습니다.</td></tr>'); 
					}
					$(".programResultTbody").append(progrmResultHtml);
					genRowspan('updtRgstrData');


					//프로그램 차단 배포 결과 ==============================================================================================


					var programBlockResult = '';
					$("#policyProgrmDetailData").val(data.policyProgrmResult[data.policyProgrmResult.length-1].run_status);
					for (var i = 0; i < data.policyProgrmResult.length; i++) {
						var noinstall = data.pcList.length - data.policyProgrmResult[i].count;
						programBlockResult += "<tr>";
						programBlockResult += "<td class='blockRgstrData'>" + data.policyProgrmResult[i].rgstr_date + "</td>";
						programBlockResult += "<td>" + data.policyProgrmResult[i].progrmname + "</td>";
						programBlockResult += "<td>" + data.pcList.length + "</td>";
						if( data.policyProgrmResult[i].gubun == 'DELETE'){
							programBlockResult += "<td>허용</td>";
						}else {
							programBlockResult += "<td>차단</td>";
						}
						programBlockResult += "<td>" + data.policyProgrmResult[i].count + "</td>";
						programBlockResult += "<td>" + noinstall + "</td>";
						programBlockResult += "</tr>";
					}
					if(data.policyProgrmResult.length == 0){
						$(".programBlockResultTbody").append('<tr><td colspan="5">등록된 데이터가 없습니다.</td></tr>');
					}
					$(".programBlockResultTbody").append(programBlockResult);
					genRowspan('blockRgstrData');
					
					//방화벽 차단 배포 결과 // ========================================================================
					

					var firewallResult = '', isViewDetail=false;
					$("#policyFirewallDetailData").val(data.policyFirewallResult[data.policyFirewallResult.length-1].run_status);
// 					if( data.policyFirewallResult.length == 0 ){
// 						firewallResult += "<td colspan='5' class='NoFireWallApplc'>방화벽 정책 적용 안함</td>";
// 					}else{
						
						for (var i = 0; i < data.policyFirewallResult.length; i++) {
							var noinstall = data.pcList.length - data.policyFirewallResult[i].count;
							firewallResult += "<tr>";
							firewallResult += "<td class='fireRgstrData'>" + data.policyFirewallResult[i].rgstr_date + "</td>";
							firewallResult += "<td>" + data.policyFirewallResult[i].retport + "</td>";
							if( data.policyFirewallResult[i].gubun == "INSERT" ||  data.policyFirewallResult[i].gubun == 'M'){
								firewallResult += "<td>허용</td>";
								isViewDetail = true;
							}else { 
								firewallResult += "<td>차단</td>";
								isViewDetail = false;
							}
							firewallResult += "<td>" + data.pcList.length + "</td>";
							firewallResult += "<td>" + data.policyFirewallResult[i].count + "</td>";
							firewallResult += "<td>" + noinstall + "</td>";
							firewallResult += "</tr>";
						}
// 					}
					
					if(data.policyFirewallResult.length == 0){
						$(".firewallResultTbody").append('<tr><td colspan="5">등록된 데이터가 없습니다.</td></tr>');
					}
					$(".firewallResultTbody").append(firewallResult);
					genRowspan('fireRgstrData');
				
					//디바이스 차단 배포 결과 ================================================

					var deviceResult = '';		
					$("#policyDeviceDetailData").val(data.policyDeviceResult[data.policyDeviceResult.length-1].run_status);
					for (var i = 0; i < data.policyDeviceResult.length; i++) {
						var noinstall = data.pcList.length - data.policyDeviceResult[i].count;
						deviceResult += "<tr>";
						deviceResult += "<td class='deviceRgstrData'>" + data.policyDeviceResult[i].rgstr_date + "</td>";
						deviceResult += "<td>" + data.policyDeviceResult[i].product + "</td>";
						if( data.policyDeviceResult[i].gubun == "INSERT" ||  data.policyDeviceResult[i].gubun == 'M'){
							deviceResult += "<td>허용</td>";
						}else { 
							deviceResult += "<td>차단</td>";
						}
						deviceResult += "<td>" + data.pcList.length + "</td>";
						deviceResult += "<td>" + data.policyDeviceResult[i].count + "</td>";
						deviceResult += "<td>" + noinstall + "</td>";
						deviceResult += "</tr>";
					}
					if(data.policyDeviceResult.length == 0){
						$(".deviceResultTbody").append('<tr><td colspan="5">등록된 데이터가 없습니다.</td></tr>');
					}
					$(".deviceResultTbody").append(deviceResult);
					genRowspan('deviceRgstrData');
					
					

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
		<aside class="col-lg-4 b-l b-r-2" style="background-color:white;">
			<section class="vbox">
				<section class="scrollable">
	               <ul class="breadcrumb">
                    <li> [<b> <a style="font-size:17px;" href="#" id="ortParent"></a></b>] <span>조직에 등록된 컴퓨터 목록</span></li>
<!--                     <li><a href="#" id="ortSub"></a></li> -->
                  </ul>
							<div class="right_box_l row m-l-none m-r-none bg-light lter monitor_list"></div>
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
								<section class="panel panel-default">
                    				<header class="panel-heading">
                    					<span class="label pull-right viewPolicyDetail">
	                    					<a href='javascript:;' data-toggle='dropdown' class='fireWalltarget btn  btn-default btn-rounded' data-gubun='progrm' data-target='#fireWallDetailLayer' style="font-size:10px;">
                    							상세보기</a></span> 프로그램 정책 결과 목록 
                    				</header>
                   				<table  class="table table-striped datagrid m-b-sm">
										<thead><tr class="programResultTr"></tr></thead>
										<tbody class="programResultTbody"></tbody>
									</table>
                  			</section>
							</div>					
						</div>

						<div class="tab-pane" id="progrmBlockResult">
							<div class="table-responsive">
								<section class="panel panel-default">
                    				<header class="panel-heading">
                    					<span class="label  pull-right viewPolicyDetail">
                    					<a href='javascript:;' data-toggle='dropdown' class='fireWalltarget btn  btn-default btn-rounded' data-gubun='progrm' data-target='#fireWallDetailLayer' style="font-size:10px;">
                    							상세보기</a></span> 프로그램 차단 정책 결과 목록 
                    				</header>
                   				<table  class="table table-striped datagrid m-b-sm">
										<thead><tr class="programBlockResultTr"></tr></thead>
										<tbody class="programBlockResultTbody"></tbody>
									</table>
                  			</section>
                  		</div>
                  	</div>
                  
                  
						
						<div class="tab-pane " id="firewallResult">
							<div class="table-responsive">
								<section class="panel panel-default">
                    				<header class="panel-heading">
                    					<span class="label  pull-right viewPolicyDetail">
                    					<a href='javascript:;' data-toggle='dropdown' class='fireWalltarget btn  btn-default btn-rounded' data-gubun='progrm' data-target='#fireWallDetailLayer' style="font-size:10px;">
                    							상세보기</a></span> 방화벽 정책 결과 목록
                    				</header>
                   				<table  class="table table-striped datagrid m-b-sm">
										<thead><tr class="firewallResultTr"></tr></thead>
										<tbody class="firewallResultTbody"></tbody>
									</table>
                  			</section>
							</div>
						</div>

						<div class="tab-pane " id="deviceResult">
							<div class="table-responsive">
								<section class="panel panel-default">
                    				<header class="panel-heading">
                    					<span class="label  pull-right viewPolicyDetail">
                    					<a href='javascript:;' data-toggle='dropdown' class='fireWalltarget btn  btn-default btn-rounded' data-gubun='progrm' data-target='#fireWallDetailLayer' style="font-size:10px;">
                    							상세보기</a></span> 디바이스 정책 결과 목록
                    				</header>
                   				<table  class="table table-striped datagrid m-b-sm">
										<thead>
											<tr class="deviceResultTr"></tr>
										</thead>
										<tbody class="deviceResultTbody"></tbody>
									</table>
                  			</section>
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
function detailPcInfo(uuid){
	
	 $.post("detailPolicy.proc",{pc_uuid:uuid, org_seq:$("#org_seq").val()},
			function(data){
			var shtml = "";
			
			$(".viewPolicyDetail").hide();
			// 프로그램 설치/삭제 배포 결과] ===============================================================
			$(".programResultTr").empty();
			$(".programResultTbody").empty();

			var programResultTr = '<th data-property="toponymName" class="sortable">프로그램명</th>';
			programResultTr += '<th data-property="population" class="sortable">구분</th>';
			programResultTr += '<th data-property="fcodeName" class="sortable">상태</th>';
			programResultTr += '<th data-property="fcodeName" class="sortable">적용일</th>';
			$(".programResultTr").append(programResultTr);
			
			var programResult = '';
			console.log("data.udpt============+"+data.udpt);
			$.each(data.udpt, function(index, value) {
				var inset_dt = value.rgstr_date;
				var date = new Date(inset_dt);
				
				date = date.getFullYear()+"-"+addZero(date.getMonth()+1)+"-"+addZero(date.getDate().toString())+" "+addZero(date.getHours().toString())+":"+addZero(date.getMinutes().toString());
				programResult += "<tr>";
				programResult += "<td>"+value.debname+"</td>";
				if(value.kind == "INSTALL"){
					programResult += "<td>설치</td>";
				}else{
					programResult += "<td>삭제</td>";
				}
				
				
				if(value.kind == "INSTALL" || value.kind == "UPGRADE" ){
					if(value.status >= 1){
						programResult += "<td>완료</td>";
					}else{
						programResult += "<td>미완료</td>";
					}
				}else if(value.kind == "DELETE"){
					if(value.status == 0){
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
				var inset_dt = value.rgstr_date;
				var date = new Date(inset_dt);
			
				date = date.getFullYear()+"-"+addZero(date.getMonth()+1)+"-"+addZero(date.getDate().toString())+" "+addZero(date.getHours().toString())+":"+addZero(date.getMinutes().toString());
			
				programBlockResult += "<tr>";
				programBlockResult += "<td>"+value.progrmname+"</td>";
				if(value.status == "Y"){
					programBlockResult += "<td>차단</td>";
				} else{
					programBlockResult += "<td>허용</td>";
				}
				if(value.status == "Y"){
					programBlockResult += "<td>완료</td>";
				} else {
					programBlockResult += "<td>미완료</td>";
				}
				programBlockResult += "<td>"+value.rgstr_date+"</td>";
				programBlockResult += "</tr>";
			});	
			$(".programBlockResultTbody").append(programBlockResult);
			
			
			// 방화벽 정책 배포 결과] ===============================================================
			$(".firewallResultTr").empty();
			$(".firewallResultTbody").empty();
				
			var firewallResultTrHtml = '<th width="20%">포트번호</th>';
			firewallResultTrHtml += '<th width="15%">상태</th>';
			firewallResultTrHtml += '<th width="15%">적용여부</th>';
			firewallResultTrHtml += '<th width="*">적용일</th>';
			$(".firewallResultTr").append(firewallResultTrHtml);
			
			var firewallResult = '';
			$.each(data.firewall, function(index, value) {
				firewallResult += "<tr>";
				firewallResult += "<td>"+value.sm_port+"</td>";
				if( value.kind == "deny"){
					firewallResult += "<td>차단</td>";	
				}else{
					firewallResult += "<td>허용</td>";
				}
			
// 				firewallResult += "<td>"+value.kind+"</td>";
				if(value.status == "Y"){
					firewallResult += "<td>완료</td>";
				} else {
					firewallResult += "<td>미완료</td>";
				}
				if( typeof value.rgstr_date ==  "undefined" || value.rgstr_date == "" || value.rgstr_date == null){
					firewallResult += "<td>.</td>";
				}else{
					firewallResult += "<td>"+value.rgstr_date+"</td>";
				}				
				firewallResult += "</tr>";
			});	
			$(".firewallResultTbody").append(firewallResult);
	


			// 디바이스 정책 배포 결과] ===============================================================
			$(".deviceResultTr").empty();
			$(".deviceResultTbody").empty();
			var deviceResultTrHtml = '<th width="20%">디바이스</th>';
			deviceResultTrHtml += '<th width="15%">적용여부</th>';
			deviceResultTrHtml += '<th width="15%">전체</th>';
			deviceResultTrHtml += '<th width="*">적용일</th>';
			$(".deviceResultTr").append(deviceResultTrHtml);

			console.log("data.device==" , data.device);
			var deviceResult = '';
			$.each(data.device, function(index, value) {
				deviceResult += "<tr>";
				deviceResult += "<td>"+value.sm_name+"("+value.sm_device_code+")</td>";
				if(value.status == "Y"){
					deviceResult += "<td>허용</td>";
				}else{
					deviceResult += "<td>차단</td>";
				}
					
				if( typeof value.rgstr_date ==  "undefined" || value.rgstr_date == "" || value.rgstr_date == null){
					deviceResult += "<td>미완료</td>";
					deviceResult += "<td>.</td>";
				}else{
					deviceResult += "<td>완료</td>";
					deviceResult += "<td>"+value.rgstr_date+"</td>";
				}		
				deviceResult += "</tr>";
			});	
			$(".deviceResultTbody").append(deviceResult);	
				
		
	}); 

}
function addZero(data){
    return (data<10) ? "0"+data : data;
}

function relaunch(host_id,job_id,seq,pc_uuid){
	console.log(host_id);
	console.log(job_id);
	console.log(seq);
	console.log(pc_uuid);
	if (confirm("최신정책을 적용 하시겠습니까?")) {
	$.ajax({
		url : '/gplcs/makePolicyToSingle',
		type: 'POST',
		async:false,
		data:{job_id:job_id,host_id:host_id,seq:seq,pc_uuid:pc_uuid},
		success : function(res) {
			if (res.STATUS == "SUCCESS") {
				alert("정상적으로 처리되었습니다.");
// 				checkAnsibleJobRelaunchStatus(res.ID,res.PARENTS_ID,res.PC_UUID);
				//location.reload();
			} else {
				alert("실패하였습니다.");
				//button.disabled = false;
			}
		},
		error:function(request,status,error){
			console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		}
	});
}
}

//ansible group작업상태확인
function checkAnsibleJobRelaunchStatus(job_id,parents_job_id,pc_uuid){
	//const target = document.getElementById('btnSave');
	console.log("job_id===="+job_id);
	$.ajax({
		url : '/gplcs/checkAnsibleJobStatus',
		type: 'POST',
		async:false,
		data:{job_id:job_id},
		success : function(res) {
			console.log(res);
			if(res.status == "running"){
				console.log("작업중입니다.");
				//target.disabled = true;
				setTimeout(checkAnsibleJobRelaunchStatus,3000,job_id,parents_job_id,pc_uuid);
				//checkAnsibleJobStatus(job_id);
			}else if(job_id != 0){
				console.log("작업성공여부=="+res.status);
				//target.disabled = false;
				console.log(res.inventory,res.limit,job_id,parents_job_id,pc_uuid);
				addAnsibleJobRelaunchEventByHost(res.inventory,res.limit,job_id,parents_job_id,pc_uuid);
			}
		},
		error:function(request,status,error){
			console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		}
	});
}

//ansible작업상태확인
function addAnsibleJobRelaunchEventByHost(...args){
	const target = document.getElementById('btnSave');
	$.ajax({
		url : '/gplcs/addAnsibleJobRelaunchEventByHost',
		type: 'POST',
		async:false,
		data:{inventory_id:args[0],org_seq:args[1],job_id:args[2],parents_job_id:args[3],pc_uuid:args[4]},
		success : function(res) {
			console.log("res===="+res);
		},
		error:function(request,status,error){
			console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		}
	});
}

 
function genRowspan(className){
    $("." + className).each(function() {
        var rows = $("." + className + ":contains('" + $(this).text() + "')");
        if (rows.length > 1) {
            rows.eq(0).attr("rowspan", rows.length);
            rows.not(":eq(0)").remove();
        }
    });
}


function genRowspan2(className){
    $("." + className).each(function() {
        var rows = $("." + className + ":contains('" + $(this).text() + "')");
        console.log("rows.length=========+"+$(this).text()  +"=="+rows.length);
        if (rows.length > 1) {
//             rows.eq(0).attr("rowspan", rows.length);
            rows.not(":eq(0)").remove();
        }
    });
}


$(document).ready(function () {


	
	$(".fireWalltarget").click(function(){
		$("#detailFireWallLayer").empty();
		$($(this).data("target")).show();
		var policyFirewallDetailData = '';
		
		console.log("###############$(this).data(", $(this).data("gubun"));
		if( $(this).data("gubun") == 'progrmBlock'){
			policyFirewallDetailData = $("#policyProgrmDetailData").val().split(",");
		}else if( $(this).data("gubun") == 'ufw'){
			policyFirewallDetailData = $("#policyFirewallDetailData").val().split(",");	
		}else if( $(this).data("gubun") == 'progrm'){
			policyFirewallDetailData = $("#policyProgrmUpdtDetailData").val().split(",");	
		}
		
		
		var firewallDatailListHTML = '';
		$(".monitor_list  input").each(function( index, element ) {
			var pcUuid =  $(this).val();
			var pcHostname = $(this).data("hostname");
			
			policyFirewallDetailData.forEach (function (el, index) {
				var tmpElement = el;
// 				console.log('element', index, el, pcUuid, tmpElement.indexOf(pcUuid));
				if(tmpElement.indexOf(pcUuid) > -1 ){
					tmpElement.split(":")
					firewallDatailListHTML += "<tr>";
					firewallDatailListHTML += "<td>" + pcHostname +"</td>";
					
					if( tmpElement.split(":")[1] == 'false'){
						firewallDatailListHTML += "<td>미완료</td>";
						firewallDatailListHTML += "<td> Pc Power Off";
						firewallDatailListHTML += '<a href="#comment-form" class="btn btn-default btn-xs"><i class="fa fa-mail-reply text-muted"></i> 정책 적용하기</a></small></td>';
					}else{
						firewallDatailListHTML += "<td>완료</td>";
					}
					firewallDatailListHTML += "</tr>";
					
				}
			});
		     
		});
		
		$("#detailFireWallLayer").append(firewallDatailListHTML);
		
		console.log("policyFirewallDetailData==="+policyFirewallDetailData.length);
		
	})
});


</script>


<div id="fireWallDetailLayer" class="dropup">
		<section class="dropdown-menu on aside-md m-l-n" style="width:800px; height: 700px; top: 0;    margin-left: 884px; margin-top: 110px;">
			<section class="panel bg-white">
				<header class="panel-heading b-b b-light">[정책 결과 상세정보 ]</header>

				<div class="panel-body animated fadeInRight">

					<table class="table table-striped m-b-none ">
						<colgroup>
							<col style="width:*" />
							<col style="width:15%;" />
							<col style="width:30%;" />
							<col />
						</colgroup>
						<thead>
							<tr>
								<th>Pc Host Name</th>
								<th>성공여부</th>
								<th>비고</th>
							</tr>
						</thead>
						<tbody id="detailFireWallLayer"></tbody>
					</table>
				</div>

<!-- 				<button type="button" class="btn btn-s-md btn-default btn-rounded" id="deleteFirewall">삭제</button> -->
<!-- 				<button type="button" class="btn btn-s-md btn-default btn-rounded insertBtn">방화벽 추가</button> -->
			</section>
		</section>
	</div>
	
<input type="hidden" name="policyFirewallDetailData" id="policyFirewallDetailData" value="">
<input type="hidden" name="policyProgrmDetailData" id="policyProgrmDetailData" value="">
<input type="hidden" name="policyProgrmUpdtDetailData" id="policyProgrmUpdtDetailData" value="">
<input type="hidden" name="policyDeviceDetailData" id="policyDeviceDetailData" value="">
<input type="hidden" name="org_seq" id="org_seq" value="">  
<%@ include file="../template/footer.jsp" %>