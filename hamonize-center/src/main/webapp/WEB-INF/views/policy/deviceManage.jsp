<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>
<%@ include file="../template/left.jsp" %>


<script>
	$(document).ready(function () {


		$("#btnSave").click(fnSaveDeviceMange);
		$("#btnManage").click(fnManage);



		// 디바이스 등록 버튼
		$('#saveDevice').on('click', function () {
			addDeviceFnt();
		});

		// 삭제 버튼
		$('#deleteDevice').on('click', function () {
			deleteDeviceFnt();
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


		getDeviceListLayer();
		window.onload = function() {checkAnsibleJobStatus($('form[name=frm] input[name=job_id]').val())};

	});


	//메뉴 Tree onClick
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
		$.post("/gplcs/dshow", {
				org_seq: treeNode.id,
				domain: treeNode.domain
			},
			function (result) {
				var agrs = result;
				var jsonData = JSON.stringify(agrs.dataInfo);
				var obj = JSON.parse(jsonData);
				$('form[name=frm] input[name=job_id]').val(agrs.job_id);
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
								former_ppm_names.push($(this).data("device") + "-" + $(this).data("devicecode"));
								
								$("#btn" + ppm_seq[i].trim()).addClass("active");
								$(this).closest('blockquote').addClass('boder-line_on');
								$(this).closest('blockquote').removeClass('boder-line_off');
							}
						});
					}

					$('form[name=frm] input[name=former_ppm_name]').val(former_ppm_names);
					//$('form[name=frm] input[name=org_seq]').val(agrs.dataInfo.org_seq);
					//$('form[name=frm] input[name=pOrgNm]').val(agrs.pOrgNm);
				}

			});
		// }
	}

	function onCheck(event, treeId, treeNode) {}

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
										# 디바이스관리
									</div>
								</li>
							</ul>

							<ul class="nav navbar-nav navbar-right m-n hidden-xs nav-user">

								<li class="hidden-xs ">
									<a href="javascript:firewallMngrOpen();" data-toggle="dropdown"
										data-target="#firewallLayer">
										<!-- <i class="fa fa-bell"></i> -->
										디바이스 추가
										<!-- <span class="badge badge-sm up bg-danger m-l-n-sm count" style="display: inline-block;">방화벽추가</span> -->
									</a>

									<div id="firewallLayer" class="dropup">
										<section class="dropdown-menu on aside-md m-l-n"
											style="width:800px; height: 700px; top: 0;">
											<section class="panel bg-white">
												<header class="panel-heading b-b b-light">디바이스 관리</header>

												<div class="panel-body animated fadeInRight">

													<form id="addForm" class="form-inline col-md-12 row" action=""
														style="display:none;">
														<input id="sma_gubun" name="sma_gubun" type="hidden" value="Y">
														<input id="sm_device_code" name="sm_device_code" type="hidden"
															value="">
														<div class="well m-t">
															<div class="col-xs-12">
																<div class="form-group pull-in clearfix">
																	<div class="col-sm-4">
																		<label>* 디바이스 이름</label>
																		<input id="sm_name" name="sm_name" type="text"
																			class="form-control parsley-validated"
																			maxlength="20" placeholder="디바이스 이름" />
																	</div>
																	<div class="col-sm-4">
																		<label>* Vendor ID</label>
																		<input id="vendor_id" name="vendor_id"
																			type="text"
																			class="form-control parsley-validated"
																			maxlength="4" placeholder="Vendor ID" />
																	</div>
																	<div class="col-sm-4">
																		<label>* Product ID</label>
																		<input id="product_id" name="product_id"
																			type="text"
																			class="form-control parsley-validated"
																			maxlength="4" placeholder="Product ID" />
																	</div>

																</div>
																<div class="form-group pull-in clearfix">
																	<div class="col-sm-8">
																		<input id="sm_dc" name="sm_dc" type="text"
																			class="form-control parsley-validated"
																			maxlength="30"
																			placeholder="디바이스에 대한 상세 설명을 입력해주세요."
																			style="width: 539px;" />
																	</div>
																	<button class="btn btn-rounded pull-right btn-sm btn-facebook" id="saveDevice">디바이스 규칙 추가</button>
																</div>
															</div>
															<footer class="panel-footer " style="border-top: 0;">
															</footer>
														</div>
													</form>
													<input type="hidden" id="MngeListInfoCurrentPage"
														name="MngeListInfoCurrentPage" value="1" />
												</div>


												<div class="panel-body animated fadeInRight">
													<table class="table table-striped m-b-none ">
														<colgroup>
															<col style="width:10%;" />
															<col style="width:10%;" />
															<col style="width:14%;" />
															<col style="width:10%;" />
															<col />
														</colgroup>
														<thead>
															<tr>
																<th></th>
																<th>번호</th>
																<th>디바이스</th>
																<th>VendorId</th>
																<th>ProductId</th>
																<th>설명</th>
															</tr>
														</thead>

														<tbody id="pageGrideInMngrListTb"></tbody>
													</table>
													<div class="dataTables_wrapper">
														<!-- page number -->
														<div class="page_num" id="page_num"></div>
													</div>
												</div>

												<button type="button" class="btn btn-s-md btn-default btn-rounded" id="deleteDevice">삭제</button>
												<button type="button" class="btn btn-s-md btn-default btn-rounded insertBtn">디바이스 추가</button>
											</section>
										</section>
									</div>
								</li>
							</ul>

						</header>

							<div class="wrapper">

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
										<blockquote class="boder-line_off bodyDataLayer">
											<div class="form-check">
												<input width=0 height=0 style="visibility:hidden" class="form-check-input" type="checkbox" name="sm_seq"
													id="${data.sm_seq}" value="<c:out value='${data.sm_seq}' />"
													data-device="${data.sm_name}"
													data-devicecode="${data.sm_device_code}" />
												<label class="form-check-label" for="${data.sm_seq}">
													<c:out value="${data.sm_name}" />
												</label>
											</div>
											<small>
												<c:out value="${data.sm_dc}" />
												<a href="#" data-toggle="class" name="selectName" class="btn btn-default btn-xs" onClick="deviceClickCellbox('${data.sm_seq}')" id="btn${data.sm_seq}">
													<i class="fa fa-square-o text-muted text"></i>
													<i class="fa fa-check-square-o text-danger text-active">선택</i>
												</a>
											</small>
										</blockquote>
									</div>

								</c:forEach>


							</form>


						</div>
					</section>
					<div class="panel-body fotter-bg" >
						<div class="right">
							<button type="reset" class="btn btn-s-md btn-default btn-rounded" id="btnInit"> 초기화</button>
							<button type="button" class="btn btn-s-md btn-default btn-rounded" id="btnSave"> 저장</button>
						</div>
					</div>
				</section>
		</aside>


	</section>
</section>


<script>
	//등록 처리결과(공통명 : 프로그램명Json )
	function fnSaveDeviceMange() {
		var button = document.getElementById('btnSave');

		if (confirm("하위부문 및 부서가 있다면 하위부문 및 부서에도 전부 적용됩니다 적용하시겠습니까?")) {
			var ppm_seq = "";
			let ppm_names = [];
			$('input:checkbox[name=sm_seq]').each(function (i) {
				if ($(this).is(':checked'))
					ppm_seq += ($(this).val()) + ",";
				ppm_names.push($(this).data("device") + "-" + $(this).data("devicecode"));
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

			if (queryArr.length == 0) {
				alert("정책을 적용할 조직을 선택해주세요.");
				return false;
			}

			button.disabled = true;

			$.post("/gplcs/dsave", {
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

	// 입력폼 초기화
	function fromReset() {
		$('#sm_name').val('');
		$('#sm_dc').val('');
		// $('#sm_port').val('');
		$('#vendor_id').val('');
		$('#product_id').val('');
	}

	function getDeviceListLayer() {
		var url = '/gplcs/dManagePopList';

		var keyWord = $("select[name=keyWord]").val();
		var vData = 'MngeListInfoCurrentPage=' + $("#MngeListInfoCurrentPage").val() + "&keyWord=" + keyWord +
			"&txtSearch=" + $("#txtSearch").val();
		callAjax('POST', url, vData, deviceGetSuccess, getError, 'json');
	}

	function getListAddDeleteVer() {
		var url = '/gplcs/dManagePopList';

		var keyWord = $("select[name=keyWord]").val();
		var vData = 'MngeListInfoCurrentPage=' + $("#MngeListInfoCurrentPage").val() + "&keyWord=" + keyWord +
			"&txtSearch=" + $("#txtSearch").val();

		function fnt(data, status, xhr, groupId) {
			deviceGetSuccess(data, status, xhr, groupId);
			$('.mdl-data-table__cell--non-numeric .form-control').css('opacity', '1');
		}

		callAjax('POST', url, vData, fnt, getError, 'json');
	}

	// 신규 디바이스 규칙 등록 버튼
	function addDeviceFnt() {
		event.preventDefault();
		var name = $('#sm_name').val();
		var info = $('#sm_dc').val();
		var vendor = $('#vendor_id').val();
		var product = $('#product_id').val();
		var regExp = /^[a-z0-9_]{4}$/;
		var regExpName = /^[ㄱ-ㅎ가-힣a-zA-Z0-9_]*$/;

		$('#sm_device_code').val($('#vendor_id').val() + ":" + $('#product_id').val());


		// 검증
		if (name.length <= 0) {
			alert('디바이스명을 입력해 주세요!');
			// $("#firewallLayer").addClass("open");
			$('#sm_name').focus();
			return false;
		} else {
			if (!regExpName.test(name)) {
				alert('디바이스 이름에는 공백을 제외한 문자, 숫자, 특수문자는 "_"만 이용가능합니다(20자 내)');
				$('#sm_dc').focus();
				return false;
			}
		}

		// if (info.length <= 0) {
		// 	$('#sm_dc').focus();
		// 	alert('비고 입력해 주세요!');
		// 	return false;
		// }


		if (!regExp.test(vendor)) {
			alert('vendorId는 4자리로된 영문 소문자, 숫자로 이루어진 코드입니다. 다시 확인해주세요!');
			$('#vendor_id').focus();
			return false;
		}

		if (!regExp.test(product)) {
			alert('productId는 4자리로된 영문 소문자, 숫자로 이루어진 코드입니다. 다시 확인해주세요!');
			$('#product_id').focus();
			return false;
		}

		// 전송
		$.ajax({
			url: '/gplcs/dManagePopSave',
			type: 'POST',
			data: $('#addForm').serialize(),
			success: function (res) {
				if (res.success == true) {
					alert("등록되었습니다.");
					getListAddDeleteVer();
					fromReset();
					location.reload();

				} else {
					alert("등록되지 않았습니다.");
					$.alert({
						title: 'Alert!',
						content: res.msg + '!',
					});
				}
			},
			error: function (request, status, error) {
				console.log("code:" + request.status + "\n" + "message:" + request.responseText + "\n" +
					"error:" + error);
			}
		});
	}


	// 삭제 버튼
	function deleteDeviceFnt() {
		var iptArr = $('.deviceCheck:checked');
		var addressArr = [];

		// 검증
		$.each(iptArr, function (idx, ipt) {
			addressArr.push($(ipt).parent().parent().attr('data-code'));
		});

		if (0 >= addressArr.length) {
			alert('삭제할 디바이스을 선택해 주시기 바랍니다!');
			return;
		}



		function ftn(data, status, xhr, groupId) {
			alert("삭제 되었습니다.");
			getListAddDeleteVer();
			fromReset();
			location.reload();

		}

		// 전송
		var url = '/gplcs/dManagePopDelete';
		var vData = "deleteList=" + addressArr;
		callAjax('POST', url, vData, ftn, getError, 'json');
	}

	function searchView(viewName, page) {
		switch (viewName) {
			case 'classMngrList':
				$("#MngeListInfoCurrentPage").val(page);
				getDeviceListLayer();
				break; 
			default:
		}
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

	var deviceGetSuccess = function (data, status, xhr, groupId) {
		var gbInnerHtml = "";
		var classGroupList = data.list;
		$('#pageGrideInMngrListTb').empty();

		if (data.list.length > 0) {
			$.each(data.list, function (index, value) {
				var no = data.pagingVo.totalRecordSize - (index) - ((data.pagingVo.currentPage - 1) * 5);
				console.log(no);
				var code = new Array();
				code = value.sm_device_code.split(":");
				console.log(code[0]);

				if (value.sm_dc == null)
					value.sm_dc = "설명이 없습니다"

				gbInnerHtml += "<tr data-code='" + value.sm_seq + "'>";
				gbInnerHtml += "<td class='t_left'>";
				if (value.ppm_seq == value.sm_seq) {
					gbInnerHtml += "<input type='checkbox' id=d" + no +
						" class='deviceCheck' disabled><label for=d" + no + " class='dook'></label></td>";
				} else {
					gbInnerHtml += "<input type='checkbox' id=d" + no + " class='deviceCheck'><label for=d" +
						no + " class='dook'></label></td>";
				}
				gbInnerHtml += "<td><span>" + no + "</span>";

				gbInnerHtml += "<td>" + value.sm_name + "</td>";
				gbInnerHtml += "<td>" + code[0] + "</td>";
				gbInnerHtml += "<td>" + code[1] + "</td>";
				gbInnerHtml += "<td>" + value.sm_dc + "</td>";
				gbInnerHtml += "</tr>";

			});
		} else {
			gbInnerHtml += "<tr><td colspan='4'>등록된 정보가 없습니다. </td></tr>";
		}

		startPage = data.pagingVo.startPage;
		endPage = data.pagingVo.endPage;
		totalPageSize = data.pagingVo.totalPageSize;
		currentPage = data.pagingVo.currentPage;
		totalRecordSize = data.pagingVo.totalRecordSize;

		console.log("startPage +++++ " + startPage);
		console.log("endPage +++++ " + endPage);
		console.log("totalPageSize +++++ " + totalPageSize);
		console.log("currentPage +++++ " + currentPage);
		console.log("totalRecordSize +++++ " + totalRecordSize);


		var viewName = 'classMngrList';
		if (totalRecordSize > 0) {
			$(".page_num").html(getPaging(startPage, endPage, totalPageSize, currentPage, '\'' + viewName + '\''));
		}
		$('#pageGrideInMngrListTb').append(gbInnerHtml);


	}

	function deviceClickCellbox(_val) {

		if ($("input:checkbox[id='" + _val + "']").is(":checked") == true) {
			$("input:checkbox[id='" + _val + "']").prop("checked", false);
			// $("input:checkbox[id='" + _val + "']").closest('blockquote').addClass('boder-line_on');
			// $("input:checkbox[id='" + _val + "']").closest('blockquote').removeClass('boder-line_off');
		} else {
			$("input:checkbox[id='" + _val + "']").prop("checked", true);
			// $("input:checkbox[id='" + _val + "']").closest('blockquote').removeClass('boder-line_on');
			// $("input:checkbox[id='" + _val + "']").closest('blockquote').addClass('boder-line_off');
		}

	}
</script>



<%@ include file="../template/footer.jsp" %>