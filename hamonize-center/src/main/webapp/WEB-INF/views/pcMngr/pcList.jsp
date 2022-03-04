<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>
<%@ include file="../template/left.jsp" %>


<link rel="stylesheet" href="/logintemplet/notebook/css/popupLayer.css" type="text/css" />

<script>
	function beforeClick(treeId, treeNode, clickFlag) {
		className = (className === "dark" ? "":"dark");
		return (treeNode.click != false);
	}
	function onCheck(event, treeId, treeNode) {
	}
	
	//메뉴 Tree onClick
	function onClick(event, treeId, treeNode, clickFlag) {
		$('#pageGrideInPcMngrListTb').empty();
		$('.page_num').empty();

		var zTree = $.fn.zTree.getZTreeObj("tree");
		var node = zTree.getNodeByParam('id', treeNode.pId);
		zTree.selectNode(zTree.getNodeByTId(treeNode.id));

		$("#org_seq").val(treeNode.id);
		$("#domain").val(treeNode.domain);
		$.post("/pcMngr/pcMngrList.proc", {
				org_seq: treeNode.id,
				pcMngrListCurrentPage: $("#pcMngrListCurrentPage").val(),
				domain: treeNode.domain
			},
			function (data) {
				var gbInnerHtml = "";
				var classGroupList = data.list;
				vpn_used = data.svo.svr_used;
				console.log("svr_used" + vpn_used);

				if (data.list.length > 0) {

					$.each(data.list, function (index, value) {
						var no = data.pagingVo.totalRecordSize - (index) - ((data.pagingVo.currentPage - 1) * 10);


						gbInnerHtml += "<tr data-code='" + value.seq + "' data-guidcode='" + value.pc_guid +
							"'>";
						gbInnerHtml += "<td style='text-align:center;'>" + no + "</td>";
						gbInnerHtml += "<td>" + value.deptname + "</td>";

						if (value.pc_os == "H") {
							gbInnerHtml += "<td>" + hamonikrIcon + "</td>";
						} else if (value.pc_os == "W") {
							gbInnerHtml += "<td>" + windowIcon + "</td>";
						} else if (value.pc_os == "G") {
							gbInnerHtml += "<td>" + gooroomIcon + "</td>";
						} else if (value.pc_os == "D") {
							gbInnerHtml += "<td>" + debianIcon + "</td>";
						} else if (value.pc_os == "L") {
							gbInnerHtml += "<td>" + linuxmintIcon + "</td>";
						} else if (value.pc_os == "U") {
							gbInnerHtml += "<td>" + ubuntuIcon + "</td>";
						} else {
							gbInnerHtml += "<td>" + hamonikrIcon + "</td>";
						}

						gbInnerHtml += "<td><a href=\"#\" onclick=\"detail_popup('" + no + "','" + value
							.deptname + "','" + value.pc_os + "','" + value.pc_hostname + "','" + value
							.pc_ip + "','" + value.pc_vpnip + "','" + value.pc_macaddress + "','" + value
							.pc_disk + "','" + value.pc_cpu + "','" + value.pc_memory + "','" + value
							.rgstr_date.substr(0, value.rgstr_date.length - 7) + "','" + value.seq +
							"','" + value.org_seq + "','" + value.host_id + "','" + value.pc_uuid + "')\">" + value.pc_hostname + "</a></td>";

						gbInnerHtml += "<td>" + timestampTodate(value.rgstr_date) +
							"</td>";
						gbInnerHtml += "</tr>";

					});
				} else {
					gbInnerHtml += "<tr><td colspan='11' style='text-align:center;'>등록된 데이터가 없습니다. </td></tr>";
				}

				startPage = data.pagingVo.startPage;
				endPage = data.pagingVo.endPage;
				totalPageSize = data.pagingVo.totalPageSize;
				currentPage = data.pagingVo.currentPage;
				totalRecordSize = data.pagingVo.totalRecordSize;
				$('#count').html("검색결과: " + totalRecordSize + "대");
				// $('#count').html("검색결과: "+numberWithCommas(totalRecordSize)+"대");

				var viewName = 'classMngrList';
				if (totalRecordSize > 0) {
					$("#page_num").html(getPaging(startPage, endPage, totalPageSize, currentPage, '\'' + viewName +
						'\''));
				} else {
					$("#page_num").empty();
				}
				$('#pageGrideInPcMngrListTb').append(gbInnerHtml);
			});
	}

	/*
	 * 이전 페이지
	 */
	function prevPage(viewName, currentPage) {
		var page = eval(currentPage) - 1;

		if (page < 1) {
			page = 1;
		}
		searchView(viewName, page);
	}

	/*
	 * 다음 페이지
	 */
	function nextPage(viewName, currentPage, totalPageSize) {
		var page = eval(currentPage) + 1;
		var totalPageSize = eval(totalPageSize);

		if (page > totalPageSize) {
			page = totalPageSize;
		}
		searchView(viewName, page);
	}

	function searchView(viewName, page) {
		switch (viewName) {
			case 'classMngrList':
				$("#pcListInfoCurrentPage").val(page);
				getPcMngrList();
				break;
			default:
		}
	}
</script>

<section class="scrollable">
	<section class="hbox stretch">
		<!-- body left Start  -->
		<%@ include file="../template/orgTree.jsp" %>
		<!-- body left End  -->


		<!-- body right -->
		<aside class="bg-white">
			<section class="vbox">
				<section class="scrollable padder">

					<section class="panel panel-default">
						<header class="panel-heading">
							PC 목록
							<i class="fa fa-info-sign text-muted" data-toggle="tooltip" data-placement="bottom"
								data-title="ajax to load the data." data-original-title="" title=""></i>
						</header>
						<div class="table-responsive">
							<div class="dataTables_wrapper" role="grid">
								<div class="row">

									<div class="col-sm-12">
										<form class="form-inline" role="form" style="float:right;">
											<select id="keyWord" name="keyWord" title="keyWord" class="form-control">
												<option value="0">전체</option>
												<option value="2">부서이름</option>
												<option value="3">IP</option>
												<option value="4">Mac Address</option>
												<option value="5">PC 호스트 이름</option>
											</select>
											<div class="form-group">
												<label for="txtSearch"></label><input type="text" name="txtSearch"
													id="txtSearch" class="form-control" />
												<button type="button" class="fom-control"
													onclick="javascript:getPcMngrList();"> 검색</button>
											</div>
										</form>



										<input type="hidden" id="pcListInfoCurrentPage" name="pcListInfoCurrentPage"
											value="1">
										<input type="hidden" id="org_seq" name="org_seq" value="">
									</div>

								</div>
								<table class="table table-striped m-b-none " id="DataTables_Table_0"
									aria-describedby="DataTables_Table_0_info">
									<thead>
										<tr role="row">
											<th width="20%">번호</th>
											<th width="25%">부서이름</th>
											<th width="25%">OS</th>
											<th width="15%">PC 호스트명</th>
											<th width="15%">등록일</th>
										</tr>
									</thead>
									<tbody id="pageGrideInPcMngrListTb"></tbody>
								</table>
								<!-- page number -->
								<div class="page_num" id="page_num"> </div>
							</div>
						</div>
					</section>
				</section>
			</section>
		</aside>


	</section>
</section>


<script>
	$(document).ready(function () {
		$("#txtSearch").keydown(function (key) {
			if (key.keyCode == 13) {
				key.preventDefault();
				getPcMngrList();
			}
		});

		// getPcMngrList();

		$("#excelBtn").on("click", function () {
			location.href = "pcMngrListExcel?org_seq=" + $("#org_seq").val() + "&date_fr=" + $("#date_fr")
				.val() + "&date_to=" + $("#date_to").val() + "&txtSearch=" + $("#txtSearch").val() +
				"&keyWord=" + $("#keyWord").val();
		});

	});

	function getPcMngrList() {
		var url = '/pcMngr/pcMngrList.proc';
		var pc_change = '${pc_change}';
		var keyWord = $("select[name=keyWord]").val();
		console.log(url + "==" + pc_change + "==" + keyWord);
		var vData = 'pcListInfoCurrentPage=' + $("#pcListInfoCurrentPage").val() + "&keyWord=" + keyWord + "&txtSearch=" +
			$("#txtSearch").val() + "&org_seq=" + $("#org_seq").val() + "&pc_change=" + pc_change;
		callAjax('POST', url, vData, userpcMngrGetSuccess, getError, 'json');

	}
	var userpcMngrGetSuccess = function (data, status, xhr, groupId) {
		var gbInnerHtml = "";
		var classGroupList = data.list;
		$('#pageGrideInPcMngrListTb').empty();
		$('.page_num').empty();

		vpn_used = data.svo.svr_used;
		console.log("svr_used : " + vpn_used);

		if (data.list.length > 0) {

			$.each(data.list, function (index, value) {
console.log("value=========+++"+value);
				var no = data.pagingVo.totalRecordSize - (index) - ((data.pagingVo.currentPage - 1) * 10);

				gbInnerHtml += "<tr data-code='" + value.seq + "' data-guidcode='" + value.pc_guid + "'>";
				gbInnerHtml += "<td style='text-align:center;'>" + no + "</td>";
				gbInnerHtml += "<td>" + value.deptname + "</td>";

				if (value.pc_os == "H") {
					gbInnerHtml += "<td>" + hamonikrIcon + "</td>";
				} else if (value.pc_os == "W") {
					gbInnerHtml += "<td>" + windowIcon + "</td>";
				} else if (value.pc_os == "G") {
					gbInnerHtml += "<td>" + gooroomIcon + "</td>";
				} else if (value.pc_os == "D") {
					gbInnerHtml += "<td>" + debianIcon + "</td>";
				} else if (value.pc_os == "L") {
					gbInnerHtml += "<td>" + linuxmintIcon + "</td>";
				} else if (value.pc_os == "U") {
					gbInnerHtml += "<td>" + ubuntuIcon + "</td>";
				} else {
					gbInnerHtml += "<td>" + hamonikrIcon + "</td>";
				}

				gbInnerHtml += "<td><a href=\"#\" onclick=\"detail_popup('" + no + "','" + value
					.deptname + "','" + value.pc_os + "','" + value.pc_hostname + "','" + value
					.pc_ip + "','" + value.pc_vpnip + "','" + value.pc_macaddress + "','" + value
					.pc_disk + "','" + value.pc_cpu + "','" + value.pc_memory + "','" + value
					.rgstr_date.substr(0, value.rgstr_date.length - 7) + "','" + value.seq +
					"','" + value.org_seq + "','" + value.host_id + "','" + value.pc_uuid + "')\">" + value.pc_hostname + "</a></td>";

				gbInnerHtml += "<td>" + timestampTodate(value.rgstr_date) + "</td>";
				gbInnerHtml += "</tr>";

			});
		} else {
			gbInnerHtml += "<tr><td colspan='11' style='text-align:center;'>등록된 데이터가 없습니다. </td></tr>";
		}

		startPage = data.pagingVo.startPage;
		endPage = data.pagingVo.endPage;
		totalPageSize = data.pagingVo.totalPageSize;
		currentPage = data.pagingVo.currentPage;
		totalRecordSize = data.pagingVo.totalRecordSize;
		$('#count').html("검색결과: " + totalRecordSize + "대");
		// $('#count').html("검색결과: "+numberWithCommas(totalRecordSize)+"대");

		var viewName = 'classMngrList';
		if (totalRecordSize > 0) {
			$("#page_num").html(getPaging(startPage, endPage, totalPageSize, currentPage, '\'' + viewName + '\''));
		}
		$('#pageGrideInPcMngrListTb').append(gbInnerHtml);

	}


	function detail_popup(no, name, pc_os, hostname, pc_ip, pc_vpnip, macaddress, pc_disk, cpu, memory, rgstr_date, seq,
		old_org_seq, host_id,pc_uuid) {
		console.log("detail_popup >> ");
		console.log("host_id >> " + host_id);
		if (pc_os == "H") {
			pc_os = hamonikrIcon;
		} else if (pc_os == "W") {
			pc_os = windowIcon;
		} else if (pc_os == "L") {
			pc_os = linuxmintIcon;
		} else if (pc_os == "D") {
			pc_os = debianIcon;
		} else if (pc_os == "U") {
			pc_os = ubuntuIcon;
		} else if (pc_os == "G") {
			pc_os = gooroomIcon;
		} else {
			pc_os = "";
		}

		var innerHtml = "";


		$("#detail_no").html(no);
		$("#detail_pc_os").html(pc_os);
		$("#detail_hostname").html(hostname);
		$("#detail_name").html(name);
		$("#detail_pc_ip").html(pc_ip);
		$("#detail_macaddress").html(macaddress);
		$("#detail_pc_disk").html(pc_disk);
		$("#detail_cpu").html(cpu);
		$("#detail_memory").html(memory);
		$("#detail_rgstr_date").html(rgstr_date);
		$("#seq").val(seq);
		$("#old_org_seq").val(old_org_seq);
		$("#host_id").val(host_id);
		$("#pc_uuid").val(pc_uuid);

		console.log("vpn_uwwwwwwwwwwwwwwsed >> " + vpn_used);
		// if (vpn_used != 0 && pc_vpnip != "no vpn") {
			// innerHtml += "<th>VPN IP</th>";
			// innerHtml += "<td colspan='3'><span id='vpnip_val'></span></td>";
			// $('#detail_vpnip').append(innerHtml);
			$("#detail_vpnip").text(pc_vpnip);
		// }

		$('#popupLayer').show();
		$("#bg_fix").show();
	};

	function hide_layer() {
		$('#popupLayer').hide();
		$("#bg_fix").hide();
		$("#detail_vpnip").empty();
	};

	function open_move() {
		if ($('#team').css("display") == "none") {
			$.ajax({
				url: '/pcMngr/teamList',
				type: 'post',
				data: {domain: $('#domain').val()},
				success: function (data) {
					for (var x = 0; x < data.length; x++) {
						var option = document.createElement("option");
						option.innerText = data[x].org_nm;
						option.value = data[x].seq;
						$('#team').append(option);
					}
				},
				error: function (request, status, error) {
					alert("error!!");

				}
			});
			$('#team').show();
			$('#moveteam').show();
		} else {
			$('#team').html("");
			$('#team').hide();
			$('#moveteam').hide();
		}
	}

	function move_team() {
		console.log("1========"+$('#seq').val());
		console.log("2========"+$('#team option:selected').val());
		console.log("3========"+$('#old_org_seq').val());
		console.log("4========"+$('#host_id').val());
		console.log("4========"+$("#detail_vpnip").text());
		console.log("4========"+$('#pc_uuid').val());
		if (confirm("부서를 이동할 경우 기존 부서에서 내린 정책이 포함된 \n일반 백업본은 모두 삭제됩니다. \n부서를 이동하시겠습니까?")) {
			$.ajax({
				url: '/pcMngr/moveTeam',
				type: 'post',
				data: {
					seq: $('#seq').val(),
					org_seq: $('#team option:selected').val(),
					old_org_seq: $('#old_org_seq').val(),
					pc_hostname: $("#detail_hostname").text(),
					domain: $('#domain').val(),
					host_id: $('#host_id').val(),
					pc_vpnip: $("#detail_vpnip").text(),
					pc_uuid: $('#pc_uuid').val()
				},
				success: function (data) {
					if (data == 1) {
						alert("완료되었습니다.");
						location.reload();
					}
				},
				error: function (request, status, error) {
					alert("오류가 발생하였습니다. 지속적으로 오류가 발생할 경우 기술지원으로 요청해 주시기바랍니다.");

				}
			});

		}

	}

	function delete_pc() {


		if (confirm("한번 삭제한 PC는 복구 할 수 없습니다. 삭제 하시겠습니까?")) {
			$.ajax({
				url: '/pcMngr/deletePc',
				type: 'post',
				data: {
					seq: $('#seq').val(),
					org_seq: $('#old_org_seq').val(),
					pc_hostname: $("#detail_hostname").text(),
					domain: $('#domain').val(),
					host_id: $('#host_id').val()
				},
				success: function (data) {
					if (data == 1) {
						alert("완료되었습니다.");
						location.reload();
					}
				},
				error: function (request, status, error) {
					alert("오류가 발생하였습니다. 지속적으로 오류가 발생할 경우 기술지원으로 요청해 주시기바랍니다.");

				}
			});

		}
	}
</script>



<!-- 레이어 팝업 -->
<div id="popupLayer" class="popa" style="display: none;">

	<div class="col-sm-12">
		<section class="panel panel-default" style="margin:-14px -30px 0 -29px;">
			<header class="panel-heading font-bold">PC 상세정보</header>
			<div class="panel-body">
				<form class="bs-example form-horizontal">
					<div class="form-group">
						<label class="col-lg-2 control-label">번호</label>
						<div class="col-lg-10">
							<span class="help-block m-b-none" id="detail_no"></span>
						</div>
					</div>

					<div class="form-group">
						<label class="col-lg-2 control-label">부서이름</label>
						<div class="col-lg-2">
							<span class="help-block m-b-none" id="detail_name"></span>
						</div>
						<div class="col-lg-8">
							<button -type="button" onclick="open_move(); return false;">부서이동</button>
							<select name="team" id="team" style="width: 200px; display:none;"></select>
							<button type="button" name="moveteam" id="moveteam" onclick="move_team(); return false;"
								style="width: 100px; display:none;">확인</button>
							<input type="hidden" id="seq" />
							<input type="hidden" id="old_org_seq" />
							<input type="hidden" id="domain" name="domain">
							<input type="hidden" id="host_id" name="host_id">
							<input type="hidden" id="pc_uuid" name="pc_uuid">
						</div>
					</div>


					<div class="form-group">
						<label class="col-lg-2 control-label">OS</label>
						<div class="col-lg-10">
							<span class="help-block m-b-none" id="detail_pc_os"></span>
						</div>
					</div>

					<div class="form-group">
						<label class="col-lg-2 control-label">PC 호스트 이름</label>
						<div class="col-lg-10">
							<span class="help-block m-b-none" id="detail_hostname"></span>
						</div>
					</div>

					<div class="form-group">
						<label class="col-lg-2 control-label">IP</label>
						<div class="col-lg-10">
							<span class="help-block m-b-none" id="detail_pc_ip"></span>
						</div>
					</div>

					<div class="form-group">
						<label class="col-lg-2 control-label">VPN-IP</label>
						<div class="col-lg-10">
							<span class="help-block m-b-none" id="detail_vpnip"></span>
						</div>
					</div>

					<div class="form-group">
						<label class="col-lg-2 control-label">Mac Address</label>
						<div class="col-lg-10">
							<span class="help-block m-b-none" id="detail_macaddress"></span>
						</div>
					</div>

					<div class="form-group">
						<label class="col-lg-2 control-label">HDD</label>
						<div class="col-lg-10">
							<span class="help-block m-b-none" id="detail_pc_disk"></span>
						</div>
					</div>

					<div class="form-group">
						<label class="col-lg-2 control-label">CPU</label>
						<div class="col-lg-10">
							<span class="help-block m-b-none" id="detail_cpu"></span>
						</div>
					</div>

					<div class="form-group">
						<label class="col-lg-2 control-label">Memory</label>
						<div class="col-lg-10">
							<span class="help-block m-b-none" id="detail_memory"></span>
						</div>
					</div>

					<div class="form-group">
						<label class="col-lg-2 control-label">등록일</label>
						<div class="col-lg-10">
							<span class="help-block m-b-none" id="detail_rgstr_date"></span>
						</div>
					</div>
				</form>
			</div>

		</section>
	</div>

	<div class="form-group" style="text-align: right;">

		<button type="submit" class="btn btn-s-md btn-danger" onclick="delete_pc();">삭제</button>
		<button type="submit" class="btn btn-s-md btn-dark" onclick="hide_layer();">닫기</button>

	</div>
	<!-- <div class="board_view mT20">

		<div style="text-align: center;">
			<button type="button" class="btn_type1" onclick="delete_pc(); return false;">삭제</button>
		</div>
	</div> -->
	<a href="#" onclick="hide_layer();" class="pop_close">닫기</a>
</div>
<div id="bg_fix" style="display:none;"></div>

<script>
	$(document).ready(function () {
	onClick(null,$("#tree"),zNodes[0]);
});
</script>

<%@ include file="../template/footer.jsp" %>