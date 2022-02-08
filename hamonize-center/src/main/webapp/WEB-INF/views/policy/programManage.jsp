<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>
<%@ include file="../template/left.jsp" %>


<script>
	$(document).ready(function () {

		if ($("#org_seq").val() == "") {
			$("#org_seq").val("1");
		}
		//등록버튼
		$("#btnSave").click(fnSavePmanage);

	});
	//메뉴 Tree onClick
	function onClick(event, treeId, treeNode, clickFlag) {
		$('input:checkbox[name=pcm_seq]').prop("checked", false);
		var zTree = $.fn.zTree.getZTreeObj("tree");
		var node = zTree.getNodeByParam('id', treeNode.pId);
		if (treeNode.checked) {
			$.post("/gplcs/pshow", {
					org_seq: treeNode.id
				},
				function (result) {
					var agrs = result;

					var html = "";
					for (var y = 0; y < agrs.pList.length; y++) {
						html += '<div class="form-check">';
						html += '<input class="form-check-input" type="checkbox" name="pcm_seq" id="'+agrs.pList[y].pcm_seq +'" value="'+agrs.pList[y].pcm_seq +'" />';
						html += '<label class="form-check-label" for="'+agrs.pList[y].pcm_seq +'">';
						html += agrs.pList[y].pcm_name;
						html += '</labe>';
					}
					$(".promlist").html();
					$(".promlist").html(html);
					console.log(agrs.dataInfo);
					if (agrs.dataInfo != null) {
						var ppm_seq = agrs.dataInfo.ppm_seq;
						ppm_seq = ppm_seq.split(",");
						for (var i = 0; i < ppm_seq.length; i++) {
							$('input:checkbox[name=pcm_seq]').each(function () {
								if ($(this).val() == ppm_seq[i]) {
									$(this).prop("checked", true);
								}
							});
						}

						$('form[name=frm] input[name=org_seq]').val(agrs.dataInfo.org_seq);
						$('form[name=frm] input[name=pOrgNm]').val(agrs.pOrgNm);
					}
				});
		}
	}
	function beforeClick(treeId, treeNode,clickFlag) {
		var zTree = $.fn.zTree.getZTreeObj("tree");
		zTree.checkNode(treeNode, !treeNode.checked, true, true);
		return true;
	}
	function onCheck(event, treeId, treeNode) {
		$('input:checkbox[name=pcm_seq]').prop("checked", false);
		var zTree = $.fn.zTree.getZTreeObj("tree");
		var node = zTree.getNodeByParam('id', treeNode.pId);
		if (treeNode.checked) {
			$.post("/gplcs/pshow", {
					org_seq: treeNode.id
				},
				function (result) {
					var agrs = result;
					var html = "";
					for (var y = 0; y < agrs.pList.length; y++) {

						html += '<div class="form-check">';
						html += '<input class="form-check-input" type="checkbox" name="pcm_seq" id="'+agrs.pList[y].pcm_seq +'" value="'+agrs.pList[y].pcm_seq +'" />';
						html += '<label class="form-check-label" for="'+agrs.pList[y].pcm_seq +'">';
						html += agrs.pList[y].pcm_name;
						html += '</labe>';

					}
					$(".promlist").html();
					$(".promlist").html(html);
					if (agrs.dataInfo != null) {
						var ppm_seq = agrs.dataInfo.ppm_seq;
						ppm_seq = ppm_seq.split(",");
						for (var i = 0; i < ppm_seq.length; i++) {
							$('input:checkbox[name=pcm_seq]').each(function () {
								if ($(this).val() == ppm_seq[i]) {
									$(this).prop("checked", true);
								}
							});
						}

						$('form[name=frm] input[name=org_seq]').val(agrs.dataInfo.org_seq);
						$('form[name=frm] input[name=pOrgNm]').val(agrs.pOrgNm);
					}
				});
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
				<section class="scrollable">
					<div class="wrapper">


						<section class="panel panel-default">

							<form name="frm" method="post" action="orgManage" class="row">
								<input type="hidden" name="org_seq" id="org_seq" value="" />
								<input type="hidden" name="ppm_seq" id="ppm_seq" value="" />
								<input type="hidden" name="section" id="section" value="" />

								<!-- update list -->
								<ul class="promlist">
									<c:forEach items="${pList}" var="data" varStatus="status">
										<li>
										

											<div class="form-check">
												<input class="form-check-input" type="checkbox" name="pcm_seq" id="${data.pcm_seq}" value="<c:out value=" ${data.pcm_seq}" />" id="${data.pcm_seq}">
												<label class="form-check-label" for="${data.pcm_seq}">
													<c:out value="${data.pcm_name}" />
												</label>
											</div>

											<p class="card-text">
												<c:out value="${data.pcm_dc}" />
											</p>
										</li>
									</c:forEach>
								</ul>
								<!-- //update list -->
								<div class="right mT20">
									<button type="reset" class="btn_type2" id="btnInit"> 초기화</button>
									<button type="button" class="btn_type2" id="btnSave"> 저장</button>
								</div>
							</form>


						</section>

					</div>
				</section>
			</section>
		</aside>


	</section>
</section>

<script>


	//등록 처리결과(공통명 : 프로그램명Json )
	function fnSavePmanage() {
		var button = document.getElementById('btnSave');

		if (confirm("하위부서가 있다면 하위부서들에도 전부 적용됩니다 적용하시겠습니까?")) {
			var ppm_seq = "";
			$('input:checkbox[name=pcm_seq]').each(function (i) {
				if ($(this).is(':checked'))
					ppm_seq += ($(this).val()) + ",";
			});
			ppm_seq = ppm_seq.substr(0, ppm_seq.length - 1);

			var zTree = $.fn.zTree.getZTreeObj("tree");
			var nodes = zTree.getCheckedNodes(true);
			var nodeLength = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
			var queryArr = [];

			$.each(zTree.transformToArray(zTree.getNodes()) && nodes, function (i, v) {
				if (i >= 0) {
					if (v.children != null)
						nodeLength[v.level] = 0;
					nodeLength[eval(v.level - 1)]++;
					var data = {
						"org_seq": v.id
					}
					queryArr.push(data);
				}
			})

			button.disabled = true;

			$.post("/gplcs/psave", {
					dataType: 'json',
					ppm_seq: ppm_seq,
					data: JSON.stringify(queryArr)
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