<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>
<%@ include file="../template/left.jsp" %>



<script>


	$(document).ready(function () {
		// getList();
		$("#excelBtn").on("click", function () {
			location.href = "pcUserLogExcel?org_seq=" + $("#org_seq").val();
			location.href = "iNetLogExcel?org_seq=" + $("#org_seq").val() + "&date_fr=" + $("#date_fr")
				.val() + "&date_to=" + $("#date_to").val() + "&txtSearch=" + $("#txtSearch").val() +
				"&keyWord=" + $("#keyWord").val();
		});
		$("#txtSearch").keydown(function (key) {
			if (key.keyCode == 13) {
				key.preventDefault();
				getList();
			}
		});
	});


	//메뉴 Tree onClick
	function onClick(event, treeId, treeNode, clickFlag) {
		$(".page_num").empty();
		$('#pageGrideInListTb').empty();
		$("#pagginationInList").empty();
		$("#txtSearch").val("");
		//$("#keyWord").val("0");
		$("#currentPage").val(1);
		if ($("#date_fr").val() == "") {
			$("#date_fr").val(getMonthAgoday());
			$("#date_to").val(getToday());
		}
		var zTree = $.fn.zTree.getZTreeObj("tree");
		var node = zTree.getNodeByParam('id', treeNode.pId);
// 		zTree.selectNode(zTree.getNodeByTId(treeNode.id));
		$("#org_seq").val(treeNode.id);
		$.post("pcChangeLogList.proc", {
				org_seq: treeNode.id,
				domain: treeNode.domain,
				currentPage: $("#currentPage").val(),
				date_fr: $("#date_fr").val(),
				date_to: $("#date_to").val()
			},
			function (data) {
				var gbInnerHtml = "";

				if (data.list.length > 0) {

					$.each(data.list, function (index, value) {
						var no = data.pagingVo.totalRecordSize - (index) - ((data.pagingVo.currentPage - 1) *
							10);

						gbInnerHtml += "<tr data-code='' data-guidcode=''>";
						gbInnerHtml += "<td style='text-align:center;'>" + no + "</td>";
						gbInnerHtml += "<td>" + value.pc_cpu + "</td>";
						gbInnerHtml += "<td>" + value.pc_memory + "</td>";
						gbInnerHtml += "<td>" + value.pc_disk + "</td>";
						gbInnerHtml += "<td>" + value.pc_ip + "</td>";
						gbInnerHtml += "<td>" + value.pc_hostname + "</td>";
						gbInnerHtml += "<td>" + value.pc_disk_id + "</td>";
						gbInnerHtml += "<td>" + value.pc_cpu_id + "</td>";
						gbInnerHtml += "<td>" + timestampTodatetime(value.rgstr_date) + "</td>";
						gbInnerHtml += "</tr>";

					});
				} else {
					gbInnerHtml += "<tr><td colspan='11' style='text-align:center;'>등록된 데이터가 없습니다. </td></tr>";
				}
				var startPage = data.pagingVo.startPage;
				var endPage = data.pagingVo.endPage;
				var totalPageSize = data.pagingVo.totalPageSize;
				var currentPage = data.pagingVo.currentPage;
				var totalRecordSize = data.pagingVo.totalRecordSize;
				$('#count').html("검색결과: " + numberWithCommas(totalRecordSize) + "건");
				var viewName = 'classMngrList';
				if (totalRecordSize > 0) {
					$(".page_num").html(getPaging(startPage, endPage, totalPageSize, currentPage, '\'' + viewName +
						'\''));
				} else {
					$("#pagginationInList").empty();
				}
				$('#pageGrideInListTb').append(gbInnerHtml);

			});


	}

	function onCheck(event, treeId, treeNode) {}

	function beforeClick(treeId, treeNode, clickFlag) {
		className = (className === "dark" ? "" : "dark");
		return (treeNode.click != false);
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
						<header class="panel-heading"> # 하드웨어 변경로그</header>

						<section class="panel panel-default">

							<div class="table-responsive">
								<div class="dataTables_wrapper" role="grid">
									<div class="row">
										<input type="hidden" id="currentPage" name="currentPage" value="1">
										<input type="hidden" id="org_seq" name="org_seq" value="">

										<div class="col-sm-12">
											<form class="form-inline" role="form" style="float:left;">
												<label for="date_fr" style="display: initial;"></label>
												<input type="text" name="date_fr" id="date_fr" class="form-control"
													value="${auditLogVo.date_fr }" />
												<a href="#divCalendar" class="btn_cal"
													onclick="openCalendar(document.getElementById('date_fr')); return false;">
													<img src="/images/datepicker-icon.png"
														style="width:37px; height:37px;" alt="달력버튼" /></a>
												~
												<label for="date_to" style="display: initial;"></label>
												<input type="text" name="date_to" id="date_to" class="form-control"
													value="${auditLogVo.date_to }" />
												<a href="#divCalendar" class="btn_cal"
													onclick="openCalendar(document.getElementById('date_to')); return false;">
													<img src="/images/datepicker-icon.png"
														style="width:37px; height:37px;" alt="달력버튼" /></a>
											</form>

											<form class="form-inline" role="form" style="float:right;">

												<select id="keyWord" name="keyWord" title="keyWord"
													class="form-control">
													<option value="0">==선택==</option>
													<option value="1">PC호스트이름</option>
												</select>
												<div class="form-group">
													<label for="txtSearch"></label><input type="text" name="txtSearch"
														id="txtSearch" class="form-control" />
													<button type="button" class="fom-control"
														onclick="javascript:getList();"> 검색</button>
												</div>
											</form>
										</div>
									</div>

									<table class="table table-striped m-b-none " id="DataTables_Table_0"
										aria-describedby="DataTables_Table_0_info">
										<thead>
											<tr role="row">
												<th width="4%">번호</th>
												<th width="18%">CPU</th>
												<th width="8%">MEMORY</th>
												<th width="15%">DISK</th>
												<th width="10%">IP</th>
												<th width="10%">PC HOSTNAME</th>
												<th width="10%">DISK_ID</th>
												<th width="10%">CPU_ID</th>
												<th width="14%">변경일</th>
											</tr>
										</thead>
										<tbody id="pageGrideInListTb"></tbody>
									</table>
									<!-- page number -->
									<div class="page_num" id="page_num"> </div>
								</div>
							</div>
						</section>

						</div>

					</section>
				</section>
		</aside>


	</section>
</section>



<script>
	function getList() {
		var url = '/auditLog/pcChangeLogList.proc';
		if ($("#date_fr").val() == "") {
			$("#date_fr").val(getMonthAgoday());
			$("#date_to").val(getToday());
		}
		var keyWord = $("select[name=keyWord]").val();
		var vData = 'currentPage=' + $("#currentPage").val() + "&keyWord=" + keyWord + "&txtSearch=" + $("#txtSearch")
			.val() + "&org_seq=" + $("#org_seq").val() + "&date_fr=" + $("#date_fr").val() + "&date_to=" + $("#date_to")
			.val();
		callAjax('POST', url, vData, pcChangeLogGetSuccess, getError, 'json');
	}
	var pcChangeLogGetSuccess = function (data, status, xhr, groupId) {
		var gbInnerHtml = "";
		$('#pageGrideInListTb').empty();
		$("#pagginationInList").empty();
		$(".page_num").empty();

		if (data.list.length > 0) {
			$.each(data.list, function (index, value) {
				var no = data.pagingVo.totalRecordSize - (index) - ((data.pagingVo.currentPage - 1) * 10);

				gbInnerHtml += "<tr data-code='' data-guidcode=''>";
				gbInnerHtml += "<td style='text-align:center;'>" + no + "</td>";
				gbInnerHtml += "<td>" + value.pc_cpu + "</td>";
				gbInnerHtml += "<td>" + value.pc_memory + "</td>";
				gbInnerHtml += "<td>" + value.pc_disk + "</td>";
				// gbInnerHtml += "<td>"+value.pc_macaddress+"</td>"; 
				gbInnerHtml += "<td>" + value.pc_ip + "</td>";
				gbInnerHtml += "<td>" + value.pc_hostname + "</td>";
				gbInnerHtml += "<td>" + value.pc_disk_id + "</td>";
				gbInnerHtml += "<td>" + value.pc_cpu_id + "</td>";
				// gbInnerHtml += "<td>"+value.pc_uuid+"</td>"; 
				gbInnerHtml += "<td>" + timestampTodatetime(value.rgstr_date) + "</td>";
				gbInnerHtml += "</tr>";

			});
		} else {
			gbInnerHtml += "<tr><td colspan='11' style='text-align:center;'>등록된 데이터가 없습니다. </td></tr>";
		}

		var startPage = data.pagingVo.startPage;
		var endPage = data.pagingVo.endPage;
		var totalPageSize = data.pagingVo.totalPageSize;
		var currentPage = data.pagingVo.currentPage;
		var totalRecordSize = data.pagingVo.totalRecordSize;
		$('#count').html("검색결과: " + numberWithCommas(totalRecordSize) + "건");

		var viewName = 'classMngrList';
		if (totalRecordSize > 0) {
			$(".page_num").html(getPaging(startPage, endPage, totalPageSize, currentPage, '\'' + viewName + '\''));
		}
		$('#pageGrideInListTb').append(gbInnerHtml);

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
				$("#currentPage").val(page);
				getList();
				break;
			default:
		}
	}
	
	$(document).ready(function () {
// 		onClick(null,$("#tree"),zNodes[0]);
	});
</script>
<%@ include file="../template/footer.jsp" %>