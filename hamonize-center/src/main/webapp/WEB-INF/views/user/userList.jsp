<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>
<%@ include file="../template/left.jsp" %>


<link rel="stylesheet" href="/logintemplet/notebook/css/popupLayer.css" type="text/css" />
<link rel="stylesheet" href="/logintemplet/notebook/js/select2/select2.css" type="text/css" />
<link rel="stylesheet" href="/logintemplet/notebook/js/select2/theme.css" type="text/css" />

<script>
	$(document).ready(function () {
			$('#select2-option').change(function(){
				$('form[name=popfrm] input[name=org_seq]').val($("#select2-option option:selected").val());
			});
			$('#user_id').change(function(){
				$.ajax({
					url : '/user/idDuplCheck',
					type: 'POST',
					data:{user_id:$('form[name=popfrm] input[name=user_id]').val()},
					success : function(res) {
						if(res > 0){
							alert("이미 사용중인 아이디 입니다.");
							$('form[name=popfrm] input[name=user_id]').val("");
							$('form[name=popfrm] input[name=user_id]').focus();
							return false;
						}

					},
					error:function(request,status,error){
						console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
					}
				});
			});
	});
	
	function beforeClick(treeId, treeNode, clickFlag) {
		className = (className === "dark" ? "":"dark");
		return (treeNode.click != false);
	}
	function onCheck(event, treeId, treeNode) {
	}
	
	//메뉴 Tree onClick
	function onClick(event, treeId, treeNode, clickFlag) {
		$('#pageGrideInUserListTb').empty();
		$('.page_num').empty();

		var zTree = $.fn.zTree.getZTreeObj("tree");
		var node = zTree.getNodeByParam('id', treeNode.pId);
// 		zTree.selectNode(zTree.getNodeByTId(treeNode.id));

		$("#org_seq").val(treeNode.id);
		$("#domain").val(treeNode.domain);
		$.post("/user/userList.proc", {
				org_seq: treeNode.id,
				ListInfoCurrentPage: $("#ListInfoCurrentPage").val(),
				domain: treeNode.domain
			},
			function (data) {
				var gbInnerHtml = "";
				var classGroupList = data.list;

				if (data.list.length > 0) {

					$.each(data.list, function (index, value) {
						var no = data.paging.totalRecordSize - (index) - ((data.paging.currentPage - 1) * 10);


						gbInnerHtml += "<tr data-code='" + value.seq + "' data-guidcode='" + value.org_seq +
							"'>";
						gbInnerHtml += "<td>" + no + "</td>";
						gbInnerHtml += "<td>" + value.org_nm + "</td>";
						gbInnerHtml += "<td>" + value.user_id + "</td>";
						gbInnerHtml += "<td>" + value.user_name + "</td>";

						/*gbInnerHtml += "<td><a href=\"#\" onclick=\"detail_popup('" + no + "','" + value
							.deptname + "','" + value.pc_os + "','" + value.pc_hostname + "','" + value
							.pc_ip + "','" + value.pc_vpnip + "','" + value.pc_macaddress + "','" + value
							.pc_disk + "','" + value.pc_cpu + "','" + value.pc_memory + "','" + value
							.rgstr_date.substr(0, value.rgstr_date.length - 7) + "','" + value.seq +
							"','" + value.org_seq + "','" + value.host_id + "','" + value.pc_uuid + "')\">" + value.pc_hostname + "</a></td>";*/

						gbInnerHtml += "<td>" + timestampTodate(value.rgstr_date) +
							"</td>";
						gbInnerHtml += "</tr>";

					});
				} else {
					gbInnerHtml += "<tr><td colspan='5' style='text-align:center;'>등록된 데이터가 없습니다. </td></tr>";
				}

				startPage = data.paging.startPage;
				endPage = data.paging.endPage;
				totalPageSize = data.paging.totalPageSize;
				currentPage = data.paging.currentPage;
				totalRecordSize = data.paging.totalRecordSize;
				//$('#count').html("검색결과: " + totalRecordSize + "대");
				// $('#count').html("검색결과: "+numberWithCommas(totalRecordSize)+"대");

				var viewName = 'classUserList';
				if (totalRecordSize > 0) {
					$("#page_num").html(getPaging(startPage, endPage, totalPageSize, currentPage, '\'' + viewName +
						'\''));
				} else {
					$("#page_num").empty();
				}
				$('#pageGrideInUserListTb').append(gbInnerHtml);
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
			case 'classUserList':
				$("#ListInfoCurrentPage").val(page);
				getUserList();
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
							사용자 목록
							<i class="fa fa-info-sign text-muted" data-toggle="tooltip" data-placement="bottom"
								data-title="ajax to load the data." data-original-title="" title=""></i>
								<a href="javascript:;" onClick="addUser(); return false;" data-toggle="dropdown"
										data-target="#popupLayerUserAdd">
										<i class="fa fa-plus-circle"></i>
										사용자추가
									</a>
						</header>
						<div class="table-responsive">
							
								<div class="row">

									<div class="col-sm-12">
										<form class="form-inline" role="form" style="float:right;">
											<select id="keyWord" name="keyWord" title="keyWord" class="form-control">
												<option value="0">전체</option>
												<option value="2">부서이름</option>
												<option value="3">아이디</option>
											</select>
											<div class="form-group">
												<label for="txtSearch"></label><input type="text" name="txtSearch"
													id="txtSearch" class="form-control" />
												<button type="button" class="fom-control"
													onclick="javascript:getUserList();"> 검색</button>
											</div>
										</form>



										<input type="hidden" id="ListInfoCurrentPage" name="ListInfoCurrentPage"
											value="1">
										<input type="hidden" id="org_seq" name="org_seq" value="">
										<input type="hidden" id="domain" name="domain" value="">
									</div>

								</div>
								<table class="table table-striped datagrid m-b-sm" id="" >
									<thead>
										<tr role="row">
											<th width="10%">번호</th>
											<th width="25%">부서이름</th>
											<th width="10%">아이디</th>
											<th width="*%">이름</th>
											<th width="15%">등록일</th>
										</tr>
									</thead>
									<tbody id="pageGrideInUserListTb"></tbody>
								</table>
								<div class="dataTables_wrapper" role="grid">
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
				getUserList();
			}
		});

		// getUserList();

		/* $("#excelBtn").on("click", function () {
			location.href = "pcMngrListExcel?org_seq=" + $("#org_seq").val() + "&date_fr=" + $("#date_fr")
				.val() + "&date_to=" + $("#date_to").val() + "&txtSearch=" + $("#txtSearch").val() +
				"&keyWord=" + $("#keyWord").val();
		}); */

	});

	function getUserList() {
		var url = '/user/userList.proc';
		var keyWord = $("select[name=keyWord]").val();
		var vData = 'ListInfoCurrentPage=' + $("#ListInfoCurrentPage").val() + "&keyWord=" + keyWord + "&txtSearch=" +
			$("#txtSearch").val() + "&org_seq=" + $("#org_seq").val() + "&domain=" + $("#domain").val();
		callAjax('POST', url, vData, userListGetSuccess, getError, 'json');

	}
	var userListGetSuccess = function (data, status, xhr, groupId) {
		var gbInnerHtml = "";
		var classGroupList = data.list;
		$('#pageGrideInUserListTb').empty();
		$('.page_num').empty();

		if (data.list.length > 0) {

			$.each(data.list, function (index, value) {
				var no = data.paging.totalRecordSize - (index) - ((data.paging.currentPage - 1) * 10);

				gbInnerHtml += "<tr data-code='" + value.seq + "' data-guidcode='" + value.org_seq + "'>";
				gbInnerHtml += "<td>" + no + "</td>";
				gbInnerHtml += "<td>" + value.org_nm + "</td>";
				gbInnerHtml += "<td>" + value.user_id + "</td>";
				gbInnerHtml += "<td>" + value.user_name + "</td>";

				/*gbInnerHtml += "<td><a href=\"#\" onclick=\"detail_popup('" + no + "','" + value
					.deptname + "','" + value.pc_os + "','" + value.pc_hostname + "','" + value
					.pc_ip + "','" + value.pc_vpnip + "','" + value.pc_macaddress + "','" + value
					.pc_disk + "','" + value.pc_cpu + "','" + value.pc_memory + "','" + value
					.rgstr_date.substr(0, value.rgstr_date.length - 7) + "','" + value.seq +
					"','" + value.org_seq + "','" + value.host_id + "','" + value.pc_uuid + "')\">" + value.pc_hostname + "</a></td>";
				*/
				gbInnerHtml += "<td>" + timestampTodate(value.rgstr_date) + "</td>";
				gbInnerHtml += "</tr>";

			});
		} else {
			gbInnerHtml += "<tr><td colspan='5' style='text-align:center;'>등록된 데이터가 없습니다. </td></tr>";
		}

		startPage = data.paging.startPage;
		endPage = data.paging.endPage;
		totalPageSize = data.paging.totalPageSize;
		currentPage = data.paging.currentPage;
		totalRecordSize = data.paging.totalRecordSize;
		console.log(startPage);
		console.log(endPage);
		console.log(totalPageSize);
		console.log(currentPage);
		console.log(totalRecordSize);
		$('#count').html("검색결과: " + totalRecordSize + "대");
		// $('#count').html("검색결과: "+numberWithCommas(totalRecordSize)+"대");

		var viewName = 'classUserList';
		if (totalRecordSize > 0) {
			$("#page_num").html(getPaging(startPage, endPage, totalPageSize, currentPage, '\'' + viewName + '\''));
		}
		$('#pageGrideInUserListTb').append(gbInnerHtml);

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
						option.innerText = data[x].level+"-"+data[x].org_nm;
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

	function addUser(){
		$("#popupLayer").show();
		$("#bg_fix").show();
		console.log($("#domain").val());
		$('form[name=popfrm] input[name=domain]').val($("#domain").val());
	}
</script>



<!-- 레이어 팝업 -->
<div id="popupLayer" class="popa" style="display: none;">

	<div class="col-sm-12">
			<form data-validate="parsley" method="post" action="/user/userSave" name="popfrm" autocomplete="off">
				<input type="hidden" name="domain" value="">
				<input type="hidden" name="org_seq" value="">
				<section class="panel panel-default">
					<header class="panel-heading"> <span class="h4">사용자추가</span> </header>
					<div class="panel-body">
						<p class="text-muted">정보를 입력하세요.</p>
						<div class="form-group"> <label>아이디</label> <input type="text" name="user_id" id="user_id" class="form-control parsley-validated"
								data-required="true"> </div>
						<div class="form-group"> <label>이름</label> <input type="text" name="user_name" class="form-control parsley-validated"
								data-required="true"> </div>
								<div class="form-group"> <label>조직</label>
									<div class="m-b">
										<!-- <div class="select2-container" id="s2id_select2-option" style="width:260px">
											<a href="javascript:void(0)" onclick="return false;" class="select2-choice" tabindex="-1">
												<span class="select2-chosen"></span>
												<abbr class="select2-search-choice-close"></abbr>
												<span class="select2-arrow">
													<b></b>
												</span>
											</a>
											<input class="select2-focusser select2-offscreen" type="text" id="s2id_autogen1">
											<div class="select2-drop select2-display-none select2-with-searchbox">
												<div class="select2-search"> <input type="text" autocomplete="off" autocorrect="off" autocapitalize="off"
														spellcheck="false" class="select2-input"> </div>
												<ul class="select2-results"> </ul>
											</div>
										</div> -->
										<select id="select2-option" style="width:260px" tabindex="-1" class="select2-offscreen">
											<c:forEach var="vo" items="${oList}" varStatus="vs" >
												<option value="${vo.seq}">${vo.org_nm}</option>
											 </c:forEach>
										</select>
									</div>
								</div>
						<div class="form-group pull-in clearfix">
							<div class="col-sm-6"> <label>비밀번호</label> <input type="password"
									class="form-control parsley-validated" data-required="true" id="pwd" name="pass_wd"> </div>
							<div class="col-sm-6"> <label>비밀번호 확인</label> <input type="password"
									class="form-control parsley-validated" data-equalto="#pwd" data-required="true"> </div>
						</div>
					</div>
					<footer class="panel-footer text-right bg-light lter"> <button type="submit"
							class="btn btn-success btn-s-xs">등록</button> </footer>
				</section>
			</form>
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

<script type="text/javascript" src="/logintemplet/notebook/js/parsley/parsley.min.js"></script>
<script type="text/javascript" src="/logintemplet/notebook/js/parsley/parsley.extend.js"></script>
<script type="text/javascript" src="/logintemplet/notebook/js/select2/select2.min.js"></script>
<script type="text/javascript" src="/logintemplet/notebook/js/app.plugin.js"></script>
<%@ include file="../template/footer.jsp" %>