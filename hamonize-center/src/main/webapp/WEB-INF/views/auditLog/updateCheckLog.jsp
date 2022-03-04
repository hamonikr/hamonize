<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>
<%@ include file="../template/left.jsp" %>



<script>
	

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
		zTree.selectNode(zTree.getNodeByTId(treeNode.id));

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
				type: 'view',
				domain: treeNode.domain
			},
			function (data) {
				var shtml = "";
				var shtml_r = "";

				var textCutLength = 20;

				$("#org_seq").val(treeNode.id);
				
				$(".programResultTr").empty();
				$(".programResultTbody").empty();
				var programResultTrHtml = '<th data-property="toponymName" class="sortable">프로그램명</th>';
// 				programResultTrHtml += '<th data-property="countrycode" class="sortable">버전</th>';
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
// 						let data = JSON.parse(value.data);
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
// 								shtml += "<li><a style='color:#555;' href='#' data-toggle='tooltip' title='" +
// 									value.pc_hostname + "' onclick=\"relaunch('" + data.host + "','" + value.job_id + "','" + value.seq + "','" + value.pc_uuid + "')\">" +
// 									data.changed + value.job_id+"</a></li>";
						} else {
							shtml += "<li><a style='color:#555;' href='#' data-toggle='tooltip' title='" +
							value.pc_hostname + "' onclick=\"detail('" + value.pc_uuid + "')\">" +
							hostnameVal + "</a></li>";
// 							shtml += "<li><a style='color:#555;' href='#' data-toggle='tooltip' title='" +
// 								value.pc_hostname + "' onclick=\"relaunch('" + data.host + "','" + value.job_id + "','" + value.seq + "','" + value.pc_uuid + "')\">" +
// 								data.changed + value.job_id+"</a></li>";
						}
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
							if (data.policyUpdtResult[i].kind == "INSTALL" || data.policyUpdtResult[i].kind == "UPGRADE") {
								if (data.policyUpdtResult[i].status == 0) {
									data.policyUpdtResult[i].count--;
								}

							} else if (data.policyUpdtResult[i].kind == "DELETE") {
								if (data.policyUpdtResult[i].status == 1) {
									data.policyUpdtResult[i].count--;
								}
							}
							var noinstall = data.pcList.length - data.policyUpdtResult[i].count;
							progrmResultHtml += "<tr>";
							progrmResultHtml += "<td>" + data.policyUpdtResult[i].debname + "</td>";
// 							if (typeof data.policyUpdtResult[i].debver === "undefined")
// 								progrmResultHtml += "<td>-</td>";
// 							else
// 								progrmResultHtml += "<td>" + data.policyUpdtResult[i].debver + "</td>";

							progrmResultHtml += "<td>" + data.policyUpdtResult[i].kind + "</td>";
							progrmResultHtml += "<td>" + data.pcList.length + "</td>";
							progrmResultHtml += "<td>" + data.policyUpdtResult[i].count + "</td>";
							progrmResultHtml += "<td>" + noinstall + "</td>";
							progrmResultHtml += "</tr>";

						} else if ((i + 1) == data.policyUpdtResult.length) {
							var inset_dt = data.policyUpdtResult[i].rgstr_date;
							var date = new Date(inset_dt);
							date = date.getFullYear() + "-" + addZero(date.getMonth() + 1) + "-" + addZero(date.getDate().toString()) + " " + addZero(date.getHours().toString()) + ":" + addZero(date.getMinutes().toString()) + ":" + addZero(date.getSeconds().toString());
							//성공여부 체크 카운트
							if (data.policyUpdtResult[i].kind == "INSTALL" || data.policyUpdtResult[i].kind ==
								"UPGRADE") {
								if (data.policyUpdtResult[i].status == 0) {
									data.policyUpdtResult[i].count--;
								}

							} else if (data.policyUpdtResult[i].kind == "DELETE") {
								if (data.policyUpdtResult[i].status == 1) {
									data.policyUpdtResult[i].count--;
								}
							}

							var noinstall = data.pcList.length - data.policyUpdtResult[i].count;
							progrmResultHtml += "<tr>";
							progrmResultHtml += "<td>" + data.policyUpdtResult[i].debname + "</td>";
// 							progrmResultHtml += "<td>" + data.policyUpdtResult[i].debver + "</td>";
							progrmResultHtml += "<td>" + data.policyUpdtResult[i].kind + "</td>";
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
					var tmp_progrmName='', tmp2_progrmName='', tmp3_progrmName='', tmp_rowcnt=0, tmp_rgstrdate='',tmp_rgstrdate2='';
					var tmp_installCnt2 = '', tmp_installCnt3 = '';
					var tmp_runStatus2 = '', tmp_runStatus3 = '';
					for (var i = 0; i < data.policyProgrmResult.length; i++) {
						
						
						var noinstall = data.pcList.length - data.policyProgrmResult[i].count;
// 						programBlockResult += "<tr class='aplusIcon' >";
// 						programBlockResult += "<td class='rgstr1'>" + data.policyProgrmResult[i].rgstr_date + "</td>";
// 						programBlockResult += "<td>" + data.policyProgrmResult[i].progrmname + "</td>";
// 						programBlockResult += "<td>" + data.pcList.length + "</td>";
// 						programBlockResult += "<td>" + data.policyProgrmResult[i].count + "</td>";
// 						programBlockResult += "<td >"+noinstall+"</td>";
// 						programBlockResult += "</tr>";
						
						var policyGubun = '';
						if( data.policyProgrmResult[i].kind == 'ins'){
							policyGubun = "(차단)";
						}else {
							policyGubun = "(허용)";
						}
						
						if( i > 0 ){
							if( tmp_rgstrdate == data.policyProgrmResult[i].rgstr_date){
								if( i == 1){
									tmp2_progrmName +=data.policyProgrmResult[0].progrmname+policyGubun + "," + data.policyProgrmResult[i].progrmname+policyGubun;
								}else{
									tmp2_progrmName += ", " + data.policyProgrmResult[i].progrmname+policyGubun;
								}
								tmp_rgstrdate = data.policyProgrmResult[i].rgstr_date;
								tmp_installCnt2 = "전체 : "+ data.pcList.length +", 완료 : "+ data.policyProgrmResult[i].count ;
								if( data.pcList.length > 1 ){
									tmp_installCnt2 += ", 미완료 : " + (data.pcList.length - data.policyProgrmResult[i].count);
								}
								tmp_runStatus2 = data.policyProgrmResult[i].run_status;
							}else{
								console.log("tmp3_progrmName.length=========+"+tmp3_progrmName.length);
							
								if(tmp3_progrmName.length == 0){
									tmp3_progrmName = data.policyProgrmResult[i].progrmname+policyGubun;
									tmp_rgstrdate2 = data.policyProgrmResult[i].rgstr_date;
								}else{
									tmp3_progrmName = ", " +data.policyProgrmResult[i].progrmname+policyGubun;
									tmp_rgstrdate2= data.policyProgrmResult[i].rgstr_date;
								}
								tmp_installCnt3 = "전체 : "+ data.pcList.length +", 완료 : "+data.policyProgrmResult[i].count ;
								if( data.pcList.length > 1 ){
									tmp_installCnt3 += ", 미완료 : " + (data.pcList.length - data.policyProgrmResult[i].count);
								}
								tmp_runStatus3 = data.policyProgrmResult[i].run_status;
							}
						}else if( i == 0 ) {
							tmp_rgstrdate = data.policyProgrmResult[i].rgstr_date;
							tmp_progrmName = data.policyProgrmResult[i].progrmname+policyGubun;
						}
					}
					if( tmp_rgstrdate.size != 0){
						programBlockResult += '<article id="comment-id-4" class="comment-item">';
						programBlockResult += '<span class="arrow left"></span>';
						programBlockResult += '<section class="comment-body panel panel-default">';
						programBlockResult += '<header class="panel-heading">';
						programBlockResult += '<a href="javascript:;"><정책 적용일> '+ tmp_rgstrdate+ '</a>';
						programBlockResult += '</header>';
						programBlockResult += '<div class="panel-body">';
						programBlockResult += '<p>프로그램 차단 정책 결과 : '+tmp_installCnt2+'</p>';
						programBlockResult += '<blockquote>';
						programBlockResult += '<p>프로그램 패키지명 </p>';
						programBlockResult += '<small>'+tmp2_progrmName +'</small>';
						programBlockResult += '<div class="comment-action m-t-sm">';
						programBlockResult += '<p> 미완료 정보  </p>';
						var tmpSplit = tmp_runStatus3.split(",");
						if(tmpSplit.length > 0){
							for(var i=0; i<tmpSplit.length; i++ ){
								if( tmpSplit[i].split(":")[0].trim() == 'false'){
								programBlockResult += "<small>Host Name : " + tmpSplit[i].split(":")[1] +",  미완료 사유 : Power Off, ";
								programBlockResult += '<a href="#comment-form" class="btn btn-default btn-xs"><i class="fa fa-mail-reply text-muted"></i> 정책 적용하기</a></small>';
								}
							}
						}
						programBlockResult += '</blockquote>';
						programBlockResult += '</div>';
						programBlockResult += '</div>';
						programBlockResult += '</section>';
						programBlockResult += '</article>';
					}			
					if(tmp_rgstrdate2.length != 0){
						programBlockResult += '<article id="comment-id-4" class="comment-item">';
						programBlockResult += '<span class="arrow left"></span>';
						programBlockResult += '<section class="comment-body panel panel-default">';
						programBlockResult += '<header class="panel-heading">';
						programBlockResult += '<a href="javascript:;"><정책 적용일> '+ tmp_rgstrdate+ '</a>';
						programBlockResult += '</header>';
						programBlockResult += '<div class="panel-body">';
						programBlockResult += '<div>프로그램 차단 정책 결과 : '+tmp_installCnt2+'</div>';
						programBlockResult += '<blockquote>';
						programBlockResult += '<p>프로그램 패키지명</p>';
						programBlockResult += '<small>'+tmp3_progrmName +'</small>';
						programBlockResult += '<div class="comment-action m-t-sm">';
						programBlockResult += '<p> 미완료 정보  </p>';
						var tmpSplit = tmp_runStatus3.split(",");
						if(tmpSplit.length > 0){
							for(var i=0; i<tmpSplit.length; i++ ){
								if( tmpSplit[i].split(":")[0].trim() == 'false'){
								programBlockResult += "<small>Host Name : " + tmpSplit[i].split(":")[1] +",  미완료 사유 : Power Off, ";
								programBlockResult += '<a href="#comment-form" class="btn btn-default btn-xs"><i class="fa fa-mail-reply text-muted"></i> 정책 적용하기</a></small>';
								}
							}
						}
						programBlockResult += '</blockquote>';
						programBlockResult += '</div>';
						programBlockResult += '</div>';
						programBlockResult += '</section>';
						programBlockResult += '</article>';
					}
					
// 					for (var i = 0; i < data.policyProgrmResult.length; i++) {
// 						var noinstall = data.pcList.length - data.policyProgrmResult[i].count;
// 						programBlockResult += '<article id="comment-id-4" class="comment-item">';
// 						programBlockResult += '<span class="arrow left"></span>';
// 						programBlockResult += '<section class="comment-body panel panel-default">';
// 						programBlockResult += '<header class="panel-heading">';
// 						programBlockResult += '<a href="javascript:;"><i class="fa fa-clock-o"></i>   '+ data.policyProgrmResult[i].rgstr_date+ '</a>';
// 						programBlockResult += '</header>';
// 						programBlockResult += '<div class="panel-body">';
// 						programBlockResult += '<blockquote>';
// 						programBlockResult += '<p>프로그램 차단 명 : '+data.policyProgrmResult[i].progrmname +'</p>';
// 						programBlockResult += '<p>프로그램 차단 구분  : '+data.policyProgrmResult[i].kind +'</p>';
// 						programBlockResult += '<small>Someone famous in <cite title="Source Title">Source Title</cite></small>';
// 						programBlockResult += '</blockquote>';
// 						programBlockResult += '<div>Lorem ipsum dolor sit amet, consecteter adipiscing elit...</div>';
// 						programBlockResult += '<div class="comment-action m-t-sm">';
// 						programBlockResult += '<a href="#" data-toggle="class" class="btn btn-default btn-xs">';
// 						programBlockResult += '<i class="fa fa-star-o text-muted text"></i>';
// 						programBlockResult += '<i class="fa fa-star text-danger text-active"></i>'; 
// 						programBlockResult += 'Like';
// 						programBlockResult += '</a>';
// 						programBlockResult += '<a href="#comment-form" class="btn btn-default btn-xs"><i class="fa fa-mail-reply text-muted"></i> Reply</a>';
// 						programBlockResult += '</div>';
// 						programBlockResult += '</div>';
// 						programBlockResult += '</section>';
// 						programBlockResult += '</article>';
// 					}
					if(data.policyProgrmResult.length == 0){
						$(".programBlockResultTbody").append('<tr><td colspan="5">등록된 데이터가 없습니다.</td></tr>');
					}
					

					$(".programBlockResultTbody").append(programBlockResult);
					genRowspan("rgstr1");
// 					genRowspan2("titles");
					
// 					$(".programBlockResultTbody").on("click", "tr", function(){

// 						alert( $(this).find("td:first-child").text() );

// 						alert( $(this).find("td:eq(1)").text() );

// 					});



// 					$(".aplusIcon").on("click",function(){
// 						  var obj = $(this);
// 						  console.log("obj=="+JSON.stringify(obj));
// 						  if( obj.hasClass("glyphicon-plus") ){
// 							  console.log(obj.parent());
// 						    obj.hide();
// // 						    var rows = $(".rgstr1:contains('" + $(this).text() + "')");
// // 						    console.log("1=="+ JSON.stringify(rows));
// 						    obj.next().show();            
// 						    obj.parent().parent().next().show();
// 						  }else{
// 						     obj.hide();
// 						     obj.prev().show();
// 						     obj.parent().parent().next().hide();
// 						  }
// 						});
					//방화벽 차단 배포 결과 // ========================================================================
					

					var firewallResult = '';
					for (var i = 0; i < data.policyFirewallResult.length; i++) {
						var chk = 1;
						if ((i + 1) == data.policyFirewallResult.length) {
							chk = 0;
						}
						if (data.policyFirewallResult[i].retport != data.policyFirewallResult[i + chk].retport) {
							var inset_dt = data.policyFirewallResult[i].rgstr_date;
							var date = new Date(inset_dt);
							date = date.getFullYear() + "-" + addZero(date.getMonth() + 1) + "-" + addZero(date.getDate().toString());
							var noinstall = data.pcList.length - data.policyFirewallResult[i].count;
							firewallResult += "<tr>";
							firewallResult += "<td>" + data.policyFirewallResult[i].retport + "</td>";
							firewallResult += "<td>" + data.policyFirewallResult[i].kind + "</td>";
							firewallResult += "<td>" + data.pcList.length + "</td>";
							firewallResult += "<td>" + data.policyFirewallResult[i].count + "</td>";
							firewallResult += "<td>" + noinstall + "</td>";
							firewallResult += "</tr>";
						} else if ((i + 1) == data.policyFirewallResult.length) {
							var inset_dt = data.policyFirewallResult[i].rgstr_date;
							var date = new Date(inset_dt);
							date = date.getFullYear() + "-" + addZero(date.getMonth() + 1) + "-" + addZero(date.getDate().toString());
							var noinstall = data.pcList.length - data.policyFirewallResult[i].count;
							firewallResult += "<tr>";
							firewallResult += "<td>" + data.policyFirewallResult[i].retport + "</td>";
							firewallResult += "<td>" + data.policyFirewallResult[i].kind + "</td>";
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
<!-- 								<table  class="table table-striped datagrid m-b-sm"> -->
<!-- 									<thead> -->
<!-- 										<tr class="programBlockResultTr"></tr> -->
<!-- 									</thead> -->
<!-- 									<tbody class="programBlockResultTbody"></tbody> -->
<!-- 								</table> -->
								<section class=" block programBlockResultTbody"> <!--  comment-list -->
								
								
<!--                     <article id="comment-id-1" class="comment-item"> -->
<!--                       <span class="arrow left"></span> -->
<!--                       <section class="comment-body panel panel-default"> -->
<!--                         <header class="panel-heading bg-white"> -->
                        
<!--                           <label class="label bg-info m-l-xs"><i class="fa fa-clock-o"></i> Editor</label>  -->
                          
<!--                         </header> -->
<!--                         <div class="panel-body"> -->
<!--                           <div>Lorem ipsum dolor sit amet, consecteter adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet.</div> -->
<!--                           <div class="comment-action m-t-sm"> -->
<!--                             <a href="#" data-toggle="class" class="btn btn-default btn-xs active"> -->
<!--                               <i class="fa fa-star-o text-muted text"></i> -->
<!--                               <i class="fa fa-star text-danger text-active"></i>  -->
<!--                               Like -->
<!--                             </a> -->
<!--                             <a href="#comment-form" class="btn btn-default btn-xs"> -->
<!--                               <i class="fa fa-mail-reply text-muted"></i> Reply -->
<!--                             </a> -->
<!--                           </div> -->
<!--                         </div> -->
<!--                       </section> -->
<!--                     </article> -->
                    
<!--                     <article id="comment-id-4" class="comment-item"> -->
<!--                       <span class="arrow left"></span> -->
<!--                       <section class="comment-body panel panel-default"> -->
<!--                         <header class="panel-heading"> -->
<!--                           <label class="label bg-info m-l-xs"><i class="fa fa-clock-o"></i> Editor</label> -->
<!--                         </header> -->
<!--                         <div class="panel-body"> -->
<!--                           <blockquote> -->
<!--                             <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer posuere erat a ante.</p> -->
<!--                             <small>Someone famous in <cite title="Source Title">Source Title</cite></small> -->
<!--                           </blockquote> -->
<!--                           <div>Lorem ipsum dolor sit amet, consecteter adipiscing elit...</div> -->
<!--                           <div class="comment-action m-t-sm"> -->
<!--                             <a href="#" data-toggle="class" class="btn btn-default btn-xs"> -->
<!--                               <i class="fa fa-star-o text-muted text"></i> -->
<!--                               <i class="fa fa-star text-danger text-active"></i>  -->
<!--                               Like -->
<!--                             </a> -->
<!--                             <a href="#comment-form" class="btn btn-default btn-xs"><i class="fa fa-mail-reply text-muted"></i> Reply</a> -->
<!--                           </div> -->
<!--                         </div> -->
<!--                       </section> -->
<!--                     </article> -->
                    <!-- comment form -->
<!--                     <article class="comment-item media" id="comment-form"> -->
<!--                       <a class="pull-left thumb-sm avatar"><img src="images/avatar.jpg" class="img-circle"></a> -->
<!--                       <section class="media-body"> -->
<!--                         <form action="" class="m-b-none"> -->
<!--                           <div class="input-group"> -->
<!--                             <input type="text" class="form-control" placeholder="Input your comment here"> -->
<!--                             <span class="input-group-btn"> -->
<!--                               <button class="btn btn-primary" type="button">POST</button> -->
<!--                             </span> -->
<!--                           </div> -->
<!--                         </form> -->
<!--                       </section> -->
<!--                     </article> -->
                  </section>
                  
                  
                  
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
	console.log("detail -=--- uuit ::: " + uuid +"=="+ $("#org_seq").val());
	
	 $.post("detailPolicy.proc",{pc_uuid:uuid, org_seq:$("#org_seq").val()},
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
				var inset_dt = value.rgstr_date;
				var date = new Date(inset_dt);
				
				date = date.getFullYear()+"-"+addZero(date.getMonth()+1)+"-"+addZero(date.getDate().toString())+" "+addZero(date.getHours().toString())+":"+addZero(date.getMinutes().toString());
				programResult += "<tr>";
				programResult += "<td>"+value.debname+"</td>";
				programResult += "<td>"+value.debver+"</td>";
				programResult += "<td>"+value.kind+"</td>";
				
				
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
				if(value.status == "Y")
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
				var inset_dt = value.rgstr_date;
				var date = new Date(inset_dt);
				date = date.getFullYear()+"-"+addZero(date.getMonth()+1)+"-"+addZero(date.getDate().toString())+" "+addZero(date.getHours().toString())+":"+addZero(date.getMinutes().toString());				shtml += "<tr>";
				firewallResult += "<tr>";
				firewallResult += "<td>"+value.retport+"</td>";

				
				if( value.kind == "deny"){
					firewallResult += "<td>차단</td>";	
				}else{
					firewallResult += "<td>허용</td>";
				}
			
// 				firewallResult += "<td>"+value.kind+"</td>";
				if(value.status == "Y")
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
				if(value.status == "Y")
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
	onClick(null,$("#tree"),zNodes[1]);
});
</script>

<input type="hidden" name="org_seq" id="org_seq" value=""> 
<%@ include file="../template/footer.jsp" %>