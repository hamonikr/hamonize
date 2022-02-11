<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>
<%@ include file="../template/left.jsp" %>



<script>
	$(document).ready(function () {
		//등록버튼
		$("#btnSave").click(fnSaveUpdt);

	});
	//메뉴 Tree onClick
	function onClick(event, treeId, treeNode, clickFlag) {

		$('input:checkbox[name=pu_seq]').prop("checked", false);
		var zTree = $.fn.zTree.getZTreeObj("tree");
		var node = zTree.getNodeByParam('id', treeNode.pId);
		console.log(treeNode);
			$('form[name=frm] input[name=org_seq]').val(treeNode.id);
			$('form[name=frm] input[name=domain]').val(treeNode.domain);
			$('form[name=frm] input[name=inventory_id]').val(treeNode.inventoryId);
			$('form[name=frm] input[name=group_id]').val(treeNode.groupId);
		// if (treeNode.checked) {
			$.post("/gplcs/ushow", {
					org_seq: treeNode.id,
					domain: treeNode.domain
				},
				function (result) {
					var agrs = result;
					var jsonData = JSON.stringify(agrs.dataInfo);
					var obj = JSON.parse(jsonData);

					if(obj !=  null){
						var ppm_seq = obj.ppm_seq; //agrs.dataInfo.ppm_seq;
						ppm_seq = ppm_seq.split(",");
						for (var i = 0; i < ppm_seq.length; i++) {
							$('input:checkbox[name=pu_seq]').each(function () {
								if ($(this).val() == ppm_seq[i]) {
									$(this).prop("checked", true);
								}
							});
						}
						//$('form[name=frm] input[name=org_seq]').val(treeNode.id);
						//$('form[name=frm] input[name=pOrgNm]').val(agrs.pOrgNm);
						
					}


				});
		// }
	}

	function beforeClick(treeId, treeNode, clickFlag) {

		var zTree = $.fn.zTree.getZTreeObj("tree");
		zTree.checkNode(treeNode, !treeNode.checked, true, true);
		return true;
	}

	// 	checkbox click event
	function onCheck(event, treeId, treeNode) {
		// $('input:checkbox[name=pu_seq]').prop("checked", false);
		// var zTree = $.fn.zTree.getZTreeObj("tree");
		// var node = zTree.getNodeByParam('id', treeNode.pId);
		// if (treeNode.checked) {
		// 	$.post("/gplcs/ushow", {
		// 			org_seq: treeNode.id
		// 		},
		// 		function (result) {
		// 			var agrs = result;
		// 			var ppm_seq = agrs.dataInfo.ppm_seq;
		// 			ppm_seq = ppm_seq.split(",");
		// 			for (var i = 0; i < ppm_seq.length; i++) {
		// 				$('input:checkbox[name=pu_seq]').each(function () {
		// 					if ($(this).val() == ppm_seq[i]) {
		// 						$(this).prop("checked", true);
		// 					}
		// 				});
		// 			}
		// 			$('form[name=frm] input[name=org_seq]').val(agrs.dataInfo.org_seq);
		// 			$('form[name=frm] input[name=pOrgNm]').val(agrs.pOrgNm);
		// 		});
		// }
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
							# 프로그램 설치 관리
							<i class="fa fa-info-sign text-muted" data-toggle="tooltip" data-placement="bottom"
								data-title="ajax to load the data." data-original-title="" title=""></i>
						</header>
						<div class="wrapper">


							<section class="panel panel-default">

								<form name="frm" method="post" action="/gplcs/orgManage" class="row">
									<input type="hidden" name="org_seq" id="org_seq" value="" />
									<input type="hidden" name="ppm_seq" id="ppm_seq" value="" />
									<input type="hidden" name="section" id="section" value="" />
									<input type="hidden" name="inventory_id" id="inventory_id" value="" />
									<input type="hidden" name="group_id" id="group_id" value="" />
									<input type="hidden" name="domain" id="domain" value="" />

									<!-- update list -->
									<ul class="promlist">
										<c:forEach items="${pList}" var="data" varStatus="status">

											<c:if test="${data.pu_name.indexOf('hamonize')!=0}">
												<li>


													<div class="form-check">
														<input class="form-check-input" type="checkbox" name="pu_seq"
															id="${data.pu_seq}" value='<c:out value="${data.pu_seq}"/>'
															id="${data.pu_seq}">
														<label class="form-check-label" for="${data.pu_seq}">
															<c:out value="${data.pu_name}" />
														</label>
													</div>


													<c:if
														test="${data.deb_now_version ne data.deb_new_version and data.deb_now_version ne null}">
														<p>업데이트가 필요합니다. 최신버전은
															<c:out value="${data.deb_new_version}" /> 입니다.</p>
													</c:if>
													<c:if test="${data.deb_now_version eq null}">
														<p>신규 프로그램</p>
													</c:if>
												</li>
											</c:if>
										</c:forEach>
									</ul>

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
	//등록 처리결과(공통명 : 프로그램명Json )
	function fnSaveUpdt() {
		var button = document.getElementById('btnSave');
		if (confirm("하위부서 및 부서가 있다면 하위부서 및 부서에도 전부 적용됩니다 적용하시겠습니까?")) {
			var ppm_seq = "";
			$('input:checkbox[name=pu_seq]').each(function (i) {
				if ($(this).is(':checked'))
					ppm_seq += ($(this).val()) + ",";
			});
			ppm_seq = ppm_seq.substr(0, ppm_seq.length - 1);

			var zTree = $.fn.zTree.getZTreeObj("tree");
			var nodes = zTree.getCheckedNodes(true);
			var nodeLength = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
			var queryArr = [];

			queryArr.push({"org_seq": parseInt($('form[name=frm] input[name=org_seq]').val())});
			$.ajax({
				url : '/org/orgManage',
				type: 'POST',
				async:false,
				data:{type:'searchChildDept',seq:$('form[name=frm] input[name=org_seq]').val()},
				success : function(res) {
					if(res.length > 0){
						console.log(res.length);
						$.each(res,function(i,v){
							console.log("v===" + v.seq);
							var data = {
								"org_seq": v.seq
									}
								console.log("data===" + data);
								queryArr.push(data);
						});
						console.log("sss=== "+JSON.stringify(queryArr));
					}
				},
				error:function(request,status,error){
					console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
				}
			});


			// $.each(zTree.transformToArray(zTree.getNodes()) && nodes, function (i, v) {
			// 	console.log("i===" + i);
			// 	if (i >= 0) {
			// 		if (v.children != null)
			// 			nodeLength[v.level] = 0;
			// 		nodeLength[eval(v.level - 1)]++;
			// 		var data = {
			// 			"org_seq": v.id
			// 			//,"name":v.name //확인용도
			// 		}
			// 		console.log("data===" + data);
			// 		queryArr.push(data);
			// 	}
			// });

			if (queryArr.length == 0) {
				alert("정책을 적용할 조직을 선택해주세요.");
				return false;
			}

			button.disabled = true;

			$.post("/gplcs/usave", {
					dataType: 'json',
					ppm_seq: ppm_seq,
					data: JSON.stringify(queryArr),
					inventory_id: $('form[name=frm] input[name=inventory_id]').val(),
					group_id: $('form[name=frm] input[name=group_id]').val(),
					org_seq: $('form[name=frm] input[name=org_seq]').val(),
					domain: $('form[name=frm] input[name=domain]').val()
				},
				function (result) {
					if (result == "SUCCESS") {
						alert("정상적으로  처리되었습니다.");
						button.disabled = false;
						location.reload();
					} else {
						alert("실패하였습니다.");
						button.disabled = false;
					}

				});

			return false;
		}
	}
</script>

<%@ include file="../template/footer.jsp" %>