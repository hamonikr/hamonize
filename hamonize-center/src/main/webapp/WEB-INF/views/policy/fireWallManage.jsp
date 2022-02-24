<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>
<%@ include file="../template/left.jsp" %>

<script>
	$(document).ready(function () {

		if ($("#org_seq").val() == "") {
			$("#org_seq").val("1");
		}

		$("#btnSave").click(fnFireSave);
		$("#btnManage").click(fnManage);



		//  팝업] 방화벽 등록 버튼
		$('#saveFirewall').on('click', function () {
			addFirewallFnt();
		});

		// 팝업]  방화벽 삭제 버튼
		$('#deleteFirewall').on('click', function () {
			deleteFirewallFnt();
		});


		$('.insertBtn').on('click', function () {
			var ipt = $('.mdl-data-table__cell--non-numeric .form-control');
			var form = $('#addForm');
			if (form.css('display') == 'none') {
				form.css('display', 'flex');
				ipt.css('opacity', '1');
			} else {
				form.css('display', 'none');
				ipt.css('opacity', '0');
				fromReset();
			}
		});

		getList();
		//window.onload = function() {checkAnsibleJobStatus($('form[name=frm] input[name=job_id]').val())};
	});

	function onClick(event, treeId, treeNode, clickFlag) {
		$('form[name=frm] input[name=former_ppm_name]').val("");
		$('input:checkbox[name=sm_seq]').prop("checked", false);
		var zTree = $.fn.zTree.getZTreeObj("tree");
		var node = zTree.getNodeByParam('id', treeNode.pId);
		let former_ppm_names = [];
		$('form[name=frm] input[name=org_seq]').val(treeNode.id);
		$('form[name=frm] input[name=domain]').val(treeNode.domain);
		$('form[name=frm] input[name=inventory_id]').val(treeNode.inventoryId);
		$('form[name=frm] input[name=group_id]').val(treeNode.groupId);
		// if (treeNode.checked) {
		$.ajaxSetup({
			async: false
		});
		$.post("/gplcs/fshow", {
				org_seq: treeNode.id,
				domain: treeNode.domain
			},
			function (result) {
				var agrs = result;
				var jsonData = JSON.stringify(agrs.dataInfo);

				$('form[name=frm] input[name=job_id]').val(agrs.job_id);

				if (typeof jsonData != "undefined") {
					var obj = JSON.parse(jsonData);

					$('form[name=frm] a[name=selectName]').removeClass("active");
					$(".bodyDataLayer").removeClass("boder-line_on");
					$(".bodyDataLayer").removeClass("boder-line_off");
			

					if (obj != null) {

						
						var ppm_seq = agrs.dataInfo.ppm_seq;
						ppm_seq = ppm_seq.split(",");
						for (var i = 0; i < ppm_seq.length; i++) {
							$('input:checkbox[name=sm_seq]').each(function () {
								if ($(this).val() == ppm_seq[i]) {
									$(this).prop("checked", true);
									former_ppm_names.push($(this).data("port"));
									$("#btn" + ppm_seq[i]).addClass("active");
									$(this).closest('blockquote').addClass('boder-line_on');
									$(this).closest('blockquote').removeClass('boder-line_off');
								}
							});
						}
						$('form[name=frm] input[name=former_ppm_name]').val(former_ppm_names);
					}
				}
				checkAnsibleJobStatus(agrs.job_id);
			});
		// }
	}

	function onCheck(event, treeId, treeNode) {

	}

	function beforeClick(treeId, treeNode, clickFlag) {
		var zTree = $.fn.zTree.getZTreeObj("tree");
		zTree.checkNode(treeNode, !treeNode.checked, true, true);
		return true;
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

						<header class="bg-dark dk header navbar navbar-fixed-top-xs">
							<ul class="nav navbar-nav hidden-xs">
								<li>
									<div class="m-t m-l">
										# 방화벽관리
									</div>
								</li>
							</ul>


							<ul class="nav navbar-nav navbar-right m-n hidden-xs nav-user">

								<li class="hidden-xs ">
									<a href="javascript:firewallMngrOpen();" data-toggle="dropdown"
										data-target="#firewallLayer">
										<!-- <i class="fa fa-bell"></i> -->
										방화벽추가
										<!-- <span class="badge badge-sm up bg-danger m-l-n-sm count" style="display: inline-block;">방화벽추가</span> -->
									</a>

									<div id="firewallLayer" class="dropup">
										<section class="dropdown-menu on aside-md m-l-n"
											style="width:800px; height: 700px; top: 0;">
											<section class="panel bg-white">
												<header class="panel-heading b-b b-light">방화벽 관리</header>

												<div class="panel-body animated fadeInRight">

													<form id="addForm" class="form-inline col-md-12 row" action=""
														style="display:none;">
														<div class="well m-t">
															<div class="col-xs-12">
																<div class="form-group pull-in clearfix">
																	<div class="col-sm-4">
																		<label>방화벽 이름</label>
																		<input id="sm_name" name="sm_name" type="text"
																			class="form-control parsley-validated"
																			maxlength="10" placeholder="방화벽 이름" />
																	</div>
																	<div class="col-sm-4">
																		<label>방화벽 상세 정보</label>
																		<input id="sm_dc" name="sm_dc" type="text"
																			class="form-control parsley-validated"
																			maxlength="20" placeholder="방화벽 상세 정보" />
																	</div>
																	<div class="col-sm-4">
																		<label>Port</label>
																		<input id="sm_port" name="sm_port" type="text"
																			class="form-control parsley-validated"
																			maxlength="5" placeholder="port" />
																	</div>
																</div>
															</div>
															<footer class="panel-footer " style="border-top: 0;">
																<button class="btn btn-info pull-right btn-sm"
																	id="saveFirewall">확인</button>
															</footer>
														</div>
													</form>

													<input type="hidden" id="MngeListInfoCurrentPage"
														name="MngeListInfoCurrentPage" value="1" />
												</div>


												<div class="panel-body animated fadeInRight">
													<!-- <p class="text-sm">No active chats.</p> -->
													<!-- <p><a href="#" class="btn btn-sm btn-default">Start a chat</a></p> -->



													<table class="table table-striped m-b-none ">
														<colgroup>
															<col style="width:10%;" />
															<col style="width:10%;" />
															<col style="width:35%;" />
															<col style="width:35%;" />
															<col />
														</colgroup>
														<thead>
															<tr>
																<th></th>
																<th>번호</th>
																<th>허용서비스</th>
																<th>방화벽 상세 정보</th>
																<th>포트</th>
															</tr>
														</thead>

														<tbody id="pageGrideInMngrListTb"></tbody>
													</table>
													<div class="dataTables_wrapper">
														<!-- page number -->
														<div class="page_num"></div>
													</div>
												</div>

												<button type="button" class="btn_type3" id="deleteFirewall">삭제</button>
												<button type="button" class="btn_type2 insertBtn">방화벽 추가</button>
											</section>
										</section>
									</div>

								</li>
							</ul>
						</header>

						<div class="wrapper">

							<section class="panel panel-default">
								<form name="frm" method="post" action="orgManage" class="row">

									<input type="hidden" name="org_seq" id="org_seq" value="" />
									<input type="hidden" name="ppm_seq" id="ppm_seq" value="" />
									<input type="hidden" name="section" id="section" value="" />
									<input type="hidden" name="inventory_id" id="inventory_id" value="" />
									<input type="hidden" name="group_id" id="group_id" value="" />
									<input type="hidden" name="job_id" id="job_id" value="" />
									<input type="hidden" name="domain" id="domain" value="" />
									<input type="hidden" name="former_ppm_name" id="former_ppm_name" value="" />
									<input type="hidden" name="ppm_name" id="ppm_name" value="" />

									<!-- update list -->
									<c:forEach items="${pList}" var="data" varStatus="status">
										<div class="panel-body col-lg-3 ">
											<blockquote class="bodyDataLayer">
												<div class="form-check">
													<!-- width=0 height=0 style="visibility:hidden" -->
													<input  class="form-check-input" type="checkbox" name="sm_seq" id="${data.sm_seq}" value="<c:out value='${data.sm_seq}'/>" id="${data.sm_seq}" data-port="${data.sm_port}">
													<label class="form-check-label" for="${data.sm_seq}">
														<p><c:out value="${data.sm_name}" /></p>
													</label>
												</div>
												<small>
													<c:out value="${data.sm_dc}" /> - <c:out value="${data.sm_port}" />
													<a href="#" name="selectName" data-toggle="class" class="btn btn-default btn-xs"
														onClick="fireClickCellbox('${data.sm_seq}')"
														id="btn${data.sm_seq}">
														<i class="fa fa-square-o text-muted text"></i>
														<i class="fa fa-check-square-o text-danger text-active">선택</i>
													</a>
												</small>
											</blockquote>
										</div>

									</c:forEach>

								</form>


							</section>
							<div class="right mT20">
								<button type="reset" class="btn_type2" id="btnInit"> 초기화</button>
								<button type="button" class="btn_type2" id="btnSave"> 저장</button>
							</div>
						</div>
					</section>
				</section>
			</section>
		</aside>
	</section>
</section>


<script>
	function fnFireSave() {
		if (confirm("하위부서 및 부서가 있다면 하위부서 및 부서에도 전부 적용됩니다 적용하시겠습니까?")) {

			var ppm_seq = "";
			let ppm_names = [];
			$('input:checkbox[name=sm_seq]').each(function (i) {
				if ($(this).is(':checked'))
					ppm_seq += ($(this).val()) + ",";
				ppm_names.push($(this).data("port"));
			});


			ppm_seq = ppm_seq.substr(0, ppm_seq.length - 1);
			$('form[name=frm] input[name=ppm_name]').val(ppm_names);
			if (ppm_seq == "") {
				ppm_seq = 0;
			}

			var zTree = $.fn.zTree.getZTreeObj("tree");
			var nodes = zTree.getCheckedNodes(true);
			var nodeLength = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
			var queryArr = [];

			queryArr.push({
				"org_seq": parseInt($('form[name=frm] input[name=org_seq]').val())
			});
			$.ajax({
				url: '/org/orgManage',
				type: 'POST',
				async: false,
				data: {
					type: 'searchChildDept',
					seq: $('form[name=frm] input[name=org_seq]').val()
				},
				success: function (res) {
					if (res.length > 0) {
						console.log(res.length);
						$.each(res, function (i, v) {
							console.log("v===" + v.seq);
							var data = {
								"org_seq": v.seq
							}
							console.log("data===" + data);
							queryArr.push(data);
						});
					}
				},
				error: function (request, status, error) {
					console.log("code:" + request.status + "\n" + "message:" + request.responseText + "\n" +
						"error:" + error);
				}
			});

			// $.each(zTree.transformToArray(zTree.getNodes()) && nodes, function (i, v) {
			// 	if (i >= 0) {
			// 		if (v.children != null)
			// 			nodeLength[v.level] = 0;
			// 		nodeLength[eval(v.level - 1)]++;
			// 		var data = {
			// 			"org_seq": v.id
			// 		}
			// 		queryArr.push(data);
			// 	}
			// })


			console.log("queryArr========+++" + queryArr);
			if (queryArr.length == 0) {
				alert("정책을 적용할 조직을 선택해주세요.");
				return false;
			}

			$.post("/gplcs/fsave", {
					dataType: 'json',
					ppm_seq: ppm_seq,
					data: JSON.stringify(queryArr),
					inventory_id: $('form[name=frm] input[name=inventory_id]').val(),
					group_id: $('form[name=frm] input[name=group_id]').val(),
					org_seq: $('form[name=frm] input[name=org_seq]').val(),
					domain: $('form[name=frm] input[name=domain]').val(),
					former_ppm_name: $('form[name=frm] input[name=former_ppm_name]').val(),
					ppm_name: $('form[name=frm] input[name=ppm_name]').val()
				},
				function (result) {
					if (result.STATUS == "SUCCESS") {
						alert("정상적으로 처리되었습니다.");
						checkAnsibleJobStatus(result.ID);
						location.reload();
					} else {
						alert("실패하였습니다.");
						//button.disabled = false;
					}
				});

			return false;
		}
	}

	function fnManage() {
		$("#popup").show();
		$("#bg_fix").show();
	}

	function getList() {
		var url = '/gplcs/fManagePopList';

		var keyWord = $("select[name=keyWord]").val();
		var vData = 'MngeListInfoCurrentPage=' + $("#MngeListInfoCurrentPage").val() + "&keyWord=" + keyWord +
			"&txtSearch=" + $("#txtSearch").val();
		callAjax('POST', url, vData, deviceGetSuccess, getError, 'json');
	}

	function getListAddDeleteVer() {
		var url = '/gplcs/fManagePopList';

		var keyWord = $("select[name=keyWord]").val();
		var vData = 'MngeListInfoCurrentPage=' + $("#MngeListInfoCurrentPage").val() + "&keyWord=" + keyWord +
			"&txtSearch=" + $("#txtSearch").val();

		function fnt(data, status, xhr, groupId) {
			deviceGetSuccess(data, status, xhr, groupId);
			$('.mdl-data-table__cell--non-numeric .form-control').css('opacity', '1');
		}

		callAjax('POST', url, vData, fnt, getError, 'json');
	}

	var deviceGetSuccess = function (data, status, xhr, groupId) {
		var gbInnerHtml = "";
		var classGroupList = data.list;
		$('#pageGrideInMngrListTb').empty();

		if (data.list.length > 0) {
			$.each(data.list, function (index, value) {
				var no = data.pagingVo.totalRecordSize - (index) - ((data.pagingVo.currentPage - 1) * 5);
				if (value.sm_dc == null)
					value.sm_dc = "설명이 없습니다"

				gbInnerHtml += "<tr data-code='" + value.sm_seq + "'>";
				gbInnerHtml += "<td>";

				if (value.ppm_seq == value.sm_seq) {
					gbInnerHtml += "<input type='checkbox' id=p" + no +
						" disabled class='fireCheck'><label for=p" + no + " ></label></td>";
				} else {
					gbInnerHtml += "<input type='checkbox' id=p" + no + " class='fireCheck'><label for=p" +
						no + "  ></label></td>";
				}

				gbInnerHtml += "<td><span>" + no + "</span>";
				gbInnerHtml += "<td>" + value.sm_name + "</td>";
				gbInnerHtml += "<td>" + value.sm_dc + "</td>";
				gbInnerHtml += "<td>" + value.sm_port + "</td>";
				gbInnerHtml += "</tr>";

			});
		} else {
			gbInnerHtml += "<tr><td colspan='5'>등록된 정보가 없습니다. </td></tr>";
		}

		startPage = data.pagingVo.startPage;
		endPage = data.pagingVo.endPage;
		totalPageSize = data.pagingVo.totalPageSize;
		currentPage = data.pagingVo.currentPage;
		totalRecordSize = data.pagingVo.totalRecordSize;

		var viewName = 'classMngrList';
		if (totalRecordSize > 0) {
			$(".page_num").html(getPaging(startPage, endPage, totalPageSize, currentPage, '\'' + viewName + '\''));
		}
		$('#pageGrideInMngrListTb').append(gbInnerHtml);
	}

	// 입력폼 초기화
	function fromReset() {
		$('#sm_name').val('');
		$('#sm_dc').val('');
		$('#sm_port').val('');
	}
	// 방화벽 추가
	function addFirewallFnt() {
		var name = $('#sm_name').val();
		var info = $('#sm_dc').val();
		var port = $('#sm_port').val();
		var regExp = /^[0-9_]/;

		// 검증
		if (name.length <= 0) {
			alert('방화벽명을 입력해 주세요!');
			return;
		}

		if (info.length <= 0) {
			alert('방화벽설명을 입력해 주세요!');
			return;
		}

		if (port.length <= 0) {
			alert('방화벽설명을 입력해 주세요!');
			return;
		}

		if (!regExp.test(port)) {
			alert('방화벽은 숫자만 입력가능합니다!');
			return flase;
		}

		// 전송
		$.ajax({
			url: '/gplcs/fManagePopSave',
			type: 'POST',
			data: $('#addForm').serialize(),
			success: function (res) {
				if (res.success == true) {
					alert(res.msg + '!');
					getListAddDeleteVer();
					fromReset();
					location.reload();

				} else {
					alert(res.msg + '!');
				}
			},
			error: function (request, status, error) {
				console.log("code:" + request.status + "\n" + "message:" + request.responseText + "\n" +
					"error:" + error);
			}
		});
	}

	// 방화벽 삭제 버튼
	function deleteFirewallFnt() {
		var iptArr = $('.fireCheck:checked');
		var addressArr = [];

		// 검증
		$.each(iptArr, function (idx, ipt) {
			addressArr.push($(ipt).parent().parent().attr('data-code'));
		});

		if (0 >= addressArr.length) {
			alert('삭제할 방화벽을 선택해 주시기 바랍니다!');
			return;
		}



		function ftn(data, status, xhr, groupId) {
			alert('정상적으로 삭제되었습니다!');
			getListAddDeleteVer();
			fromReset();
			location.reload();
		}

		// 전송
		var url = '/gplcs/fManagePopDelete';
		var vData = "deleteList=" + addressArr;
		console.log("a===" + vData);
		callAjax('POST', url, vData, ftn, getError, 'json');
	}

	function fireClickCellbox(_val) {

		if ($("input:checkbox[id='" + _val + "']").is(":checked") == true) {
			$("input:checkbox[id='" + _val + "']").prop("checked", false);
			$("input:checkbox[id='" + _val + "']").closest('blockquote').removeClass('boder-line_on');
			$("input:checkbox[id='" + _val + "']").closest('blockquote').addClass('boder-line_off');
		} else {
			$("input:checkbox[id='" + _val + "']").prop("checked", true);
			$("input:checkbox[id='" + _val + "']").closest('blockquote').addClass('boder-line_on');
			$("input:checkbox[id='" + _val + "']").closest('blockquote').removeClass('boder-line_off');
		}

	}
</script>

<%@ include file="../template/footer.jsp" %>