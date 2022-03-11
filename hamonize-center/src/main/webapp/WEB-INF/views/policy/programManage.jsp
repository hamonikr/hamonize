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
		$("#btnInit").click(fnInit);
		if($('form[name=frm] input[name=job_id]').val() > 0){
			window.onload = function() {checkAnsibleJobStatus($('form[name=frm] input[name=job_id]').val())};
		}
	});

	// 	var treeObj = $.fn.zTree.getZTreeObj("tree");
	// treeObj.checkAllNodes(true);


	//메뉴 Tree onClick 
	function onClick(event, treeId, treeNode, clickFlag) {
		$('form[name=frm] input[name=former_ppm_name]').val("");
		$('input:checkbox[name=pcm_seq]').prop("checked", false);
		var zTree = $.fn.zTree.getZTreeObj("tree");
		var node = zTree.getNodeByParam('id', treeNode.pId);
// 		zTree.selectNode(zTree.getNodeByTId(treeNode.id));
		let former_ppm_name = [];
			$('form[name=frm] input[name=org_seq]').val(treeNode.id);
			$('form[name=frm] input[name=domain]').val(treeNode.domain);
			$('form[name=frm] input[name=inventory_id]').val(treeNode.inventoryId);
			$('form[name=frm] input[name=group_id]').val(treeNode.groupId);
			$(".promlist").html("");
		// if (treeNode.checked) {
			$.ajaxSetup({ async:false });
			$.post("/gplcs/pshow", {
					org_seq: treeNode.id,
					domain: treeNode.domain
				},
				function (result) {

					$('form[name=frm] a[name=selectName]').removeClass("active");
					$(".bodyDataLayer").removeClass("boder-line_on");
// 					$(".bodyDataLayer").removeClass("boder-line_off");

					var agrs = result;
					var jsonData = JSON.stringify(agrs.dataInfo);
					var obj = JSON.parse(jsonData);
					var html = "";
					$('form[name=frm] input[name=job_id]').val(agrs.job_id);
					console.log("leng===="+agrs.pList.length);
					if(agrs.pList.length > 0){
						for (var y = 0; y < agrs.pList.length; y++) {

							html += '<div class="panel-body col-lg-3 " id="div'+agrs.pList[y].pcm_seq+'"><blockquote class="bodyDataLayer boder-line_off">';
							html += '<div class="form-check">';
							html += '<input width=0 height=0 style="visibility:hidden"  class="form-check-input" type="checkbox" name="pcm_seq" id="' + agrs.pList[y].pcm_seq + '" value="' + agrs.pList[y].pcm_seq + '"data-package="'+agrs.pList[y].pcm_name+'" />';
							html += '<label class="form-check-label" for="' + agrs.pList[y].pcm_seq + '">';
							html += agrs.pList[y].pcm_name;
							html += '</label>';
							html += '</div>';
							html += '<small>프로그램 차단 상태 :';
							html += '<a href="#" data-toggle="class" name="selectName" class="btn btn-default btn-xs" onClick="updtClickCellbox(' + agrs.pList[y].pcm_seq + ')" id="btn' + agrs.pList[y].pcm_seq + '">';
							html += '<i class="fa fa-square-o text-muted text"></i>';
							html += '<i class="fa fa-check-square-o text-danger text-active">차단</i>';
							html += '</a>';
							html += '</small>';
							html += '</blockquote></div>';
						}
					}else{
						html += '<li>';
						html += '설치된 패키지가 없습니다.';
						html += '</li>';
					}
					$(".promlist").html(html);
					if(obj !=  null){
						var ppm_seq = agrs.dataInfo.ppm_seq;
						ppm_seq = ppm_seq.split(",");
						
						for (var i = 0; i < ppm_seq.length; i++) {
							$('input:checkbox[name=pcm_seq]').each(function () {
								if ($(this).val() == ppm_seq[i]) {
									console.log("ppm_seq[i]=========+++"+ $(this).val() +"==+"+ ppm_seq[i]);
									$(this).prop("checked", true);
									former_ppm_name.push($(this).data("package"));
									$("#btn" + ppm_seq[i]).addClass("active");
									$(this).closest('blockquote').addClass('boder-line_on');
									$(this).closest('blockquote').removeClass('boder-line_off');
									
									$("#div"+$(this).val()).appendTo("#checkedUpdt");
								}
							});
						}
						$('form[name=frm] input[name=former_ppm_name]').val(former_ppm_name);
						//$('form[name=frm] input[name=org_seq]').val(agrs.dataInfo.org_seq);
						//$('form[name=frm] input[name=pOrgNm]').val(agrs.pOrgNm);
					}
					//checkAnsibleJobStatus(agrs.job_id);
				});
		// }
	}


	function beforeClick(treeId, treeNode, clickFlag) {
		var zTree = $.fn.zTree.getZTreeObj("tree");
		zTree.checkNode(treeNode, !treeNode.checked, true, true);

		return true;
	}

	function onCheck(event, treeId, treeNode) {
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

					<section class="panel panel-default" style="overflow-y:scroll; height:89%;">
						<header class="panel-heading">
							# 프로그램 차단 관리
							<i class="fa fa-info-sign text-muted" data-toggle="tooltip" data-placement="bottom"
								data-title="ajax to load the data." data-original-title="" title=""></i>
						</header>
						<div class="wrapper">



								<form name="frm" method="post" action="orgManage" class="row ">
									<input type="hidden" name="org_seq" id="org_seq" value="" />
									<input type="hidden" name="ppm_seq" id="ppm_seq" value="" />
									<input type="hidden" name="section" id="section" value="" />
									<input type="hidden" name="inventory_id" id="inventory_id" value="" />
									<input type="hidden" name="group_id" id="group_id" value="" />
									<input type="hidden" name="job_id" id="job_id" value="" />
									<input type="hidden" name="domain" id="domain" value="" />
									<input type="hidden" name="former_ppm_name" id="former_ppm_name" value="" />
									<input type="hidden" name="ppm_name" id="ppm_name" value="" />

									<div id="checkedUpdt" ></div>
									<div class="promlist"></div>
									
								</form>


						</div>
					</section>
					<div class="panel-body fotter-bg">
						<div class="right">
							<button type="reset" class="btn btn-s-md btn-default btn-rounded" id="btnInit"> 초기화</button>
							<button type="button" class="btn btn-s-md btn-default btn-rounded" id="btnSave"> 저장</button>
						</div>
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
			let ppm_names = [];
			$('input:checkbox[name=pcm_seq]').each(function (i) {
				if ($(this).is(':checked')){
					ppm_seq += ($(this).val()) + ",";
					ppm_names.push($(this).data("package"));
				}
			});
			ppm_seq = ppm_seq.substr(0, ppm_seq.length - 1);
			$('form[name=frm] input[name=ppm_name]').val(ppm_names);
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
					}
				},
				error:function(request,status,error){
					console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
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
			
			console.log("queryArr===" + queryArr);
			if (queryArr.length == 0) {
				alert("정책을 적용할 조직을 선택해주세요.");
				return false;
			}

			button.disabled = true;

			$.post("/gplcs/psave", {
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
						//checkAnsibleJobStatus(result.ID);
						location.reload();
					} else {
						alert("실패하였습니다.");
						//button.disabled = false;
					}

				});

			return false;
		}
	}

	function fnInit(){
		$('input:checkbox[name=ppm_seq]').each(function (i) {
			if ($(this).is(':checked')){
				updtClickCellbox($(this).attr('id'));
			}
		});
		$('a[name=selectName]').removeClass("btn btn-default btn-xs active");
		$('a[name=selectName]').addClass("btn btn-default btn-xs");
	}

	function updtClickCellbox(_val) {
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
	$(document).ready(function () {
// 		onClick(null,$("#tree"),zNodes[0]);
	});
</script>

<%@ include file="../template/footer.jsp" %>