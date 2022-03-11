<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>
<%@ include file="../template/left.jsp" %>



<script>
	$(document).ready(function () {
		// getPcloginoutList();
		
		// $("#txtSearch").keydown(function (key) {
		// 	if (key.keyCode == 13) {
		// 		key.preventDefault();
		// 		getPcloginoutList();
		// 	}
		// });
	});


	//메뉴 Tree onClick
	function onClick(event, treeId, treeNode, clickFlag) {
		
		$(".page_num").empty();
		$('#pageGrideInListTb').empty();
		$("#pagginationInList").empty();
		$("#txtSearch").val("");
		$("#currentPage").val(1);
		if ($("#date_fr").val() == "") {
			$("#date_fr").val(getMonthAgoday());
			$("#date_to").val(getToday());
		}
		var zTree = $.fn.zTree.getZTreeObj("tree");
		var node = zTree.getNodeByParam('id', treeNode.pId);
// 		zTree.selectNode(zTree.getNodeByTId(treeNode.id));
		$("#org_seq").val(treeNode.id);
		$.post("userLogList.proc", {
				org_seq: treeNode.id,
				domain: treeNode.domain,
				currentPage: $("#currentPage").val(),
				date_fr: $("#date_fr").val(),
				date_to: $("#date_to").val()
			},
			function (data) {
				var gbInnerHtml = "";

				if (data.list.length > 0) {
					var startPage = data.pagingVo.startPage;
					var endPage = data.pagingVo.endPage;
					var totalPageSize = data.pagingVo.totalPageSize;
					var currentPage = data.pagingVo.currentPage;
					var totalRecordSize = data.pagingVo.totalRecordSize;
					$.each(data.list, function (index, value) {
						var no = data.pagingVo.totalRecordSize - (index) - ((data.pagingVo.currentPage - 1) *
							10);
						const unexpt_shutdwon = "비정상적인 종료입니다.";

						if (value.logout_dt == null && value.last_seq != value.seq) {
							value.logout_dt = unexpt_shutdwon;
							value.spent_time = unexpt_shutdwon;
						} else if (value.logout_dt == null && value.last_seq == value.seq) {
							value.logout_dt = "-";
							value.spent_time = "-";
						}
						if (value.logout_dt == '-' && value.state == 'N') {
							value.logout_dt = unexpt_shutdwon;
							value.spent_time = unexpt_shutdwon;
						}

						gbInnerHtml += "<tr data-code='" + value.idx + "' data-guidcode='" + value.idx + "'>";
						gbInnerHtml += "<td>" + no + "</td>";
						gbInnerHtml += "<td>" + value.org_nm + "</td>";
						gbInnerHtml += "<td>" + value.pc_hostname + "</td>"
						gbInnerHtml += "<td>" + value.login_dt + "</td>";
						gbInnerHtml += "<td>" + value.logout_dt + "</td>";
						gbInnerHtml += "<td>" + value.spent_time + "</td>";
						gbInnerHtml += "</tr>";

					});
				} else {
					gbInnerHtml += "<tr><td colspan='6' style='text-align:center;'>등록된 데이터가 없습니다. </td></tr>";
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
						<header class="panel-heading"> # 사용자 접속 로그</header>


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
														onclick="javascript:getPcloginoutList();"> 검색</button>
												</div>
											</form>
										</div>
									</div>

									<table class="table table-striped m-b-none " id="DataTables_Table_0"
										aria-describedby="DataTables_Table_0_info">
										<thead>
											<tr role="row">
												<th width="7%">번호</th>
												<th width="15%">부서명</th>
												<th width="*">PC호스트이름</th>
												<th width="15%">최근접속일시</th>
												<th width="15%">종료일시</th>
												<th width="15%">사용시간</th>
											</tr>
										</thead>
										<tbody id="pageGrideInListTb"></tbody>
									</table>
									<!-- page number -->
									<div class="page_num" id="page_num"> </div>
								</div>
							</div>

						</div>

					</section>
				</section>
		</aside>


	</section>
</section>



<script>
	function getPcloginoutList() {
		var url = '/auditLog/userLogList.proc';
		var keyWord = $("select[name=keyWord]").val();
		if ($("#date_fr").val() == "") {
			$("#date_fr").val(getMonthAgoday());
			$("#date_to").val(getToday());
		}
		var vData = 'currentPage=' + $("#currentPage").val() + "&keyWord=" + keyWord + "&txtSearch=" + $("#txtSearch")
			.val() + "&org_seq=" + $("#org_seq").val() + "&date_fr=" + $("#date_fr").val() + "&date_to=" + $("#date_to")
			.val();
		callAjax('POST', url, vData, userLogGetSuccess, getError, 'json');
	}
	var userLogGetSuccess = function (data, status, xhr, groupId) {
		var gbInnerHtml = "";
		$('#pageGrideInListTb').empty();
		$("#pagginationInList").empty();
		$(".page_num").empty();

		if (data.list.length > 0) {
			$.each(data.list, function (index, value) {
				var no = data.pagingVo.totalRecordSize - (index) - ((data.pagingVo.currentPage - 1) * 10);
				if (value.logout_dt == null && value.last_seq != value.seq) {
					value.logout_dt = "비정상적인 종료입니다.";
					value.spent_time = "비정상적인 종료입니다.";
				} else if (value.logout_dt == null && value.last_seq == value.seq) {
					value.logout_dt = "-";
					value.spent_time = "-";
				}
				if (value.logout_dt == '-' && value.state == 'N') {
					value.logout_dt = "비정상적인 종료입니다.";
					value.spent_time = "비정상적인 종료입니다.";
				}
				gbInnerHtml += "<tr data-code='" + value.idx + "' data-guidcode='" + value.idx + "'>";
				gbInnerHtml += "<td>" + no + "</td>";
				gbInnerHtml += "<td>" + value.org_nm + "</td>";
				gbInnerHtml += "<td>" + value.pc_hostname + "</td>";
				gbInnerHtml += "<td>" + value.login_dt + "</td>";
				gbInnerHtml += "<td>" + value.logout_dt + "</td>";
				gbInnerHtml += "<td>" + value.spent_time + "</td>";
				gbInnerHtml += "</tr>";

			});
		} else {
			gbInnerHtml += "<tr><td colspan='6' style='text-align:center;'>등록된 데이터가 없습니다. </td></tr>";
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
				getPcloginoutList();
				break;
			default:
		}
	}
	$(document).ready(function () {
// 		onClick(null,$("#tree"),zNodes[0]);
	});
</script>
<%@ include file="../template/footer.jsp" %>