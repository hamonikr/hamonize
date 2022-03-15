<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>
<%@ include file="../template/left.jsp" %>

<script>
	$(document).ready(function () {
		//등록버튼
		$("#btnSave").click(fnSaveRecoovery);
		$("#recoveryPclist").show();
		$("#recoveryPclist").append('복구할 PC의 조직을 선택해 주세요.');
	});

	//메뉴 Tree onClick
	function onClick(event, treeId, treeNode, clickFlag) {
		$("#recoveryPclist").empty();
		$("#recoveryPcBackuplist").empty();

		var zTree = $.fn.zTree.getZTreeObj("tree");
		var node = zTree.getNodeByParam('id', treeNode.pId);
		//zTree.selectNode(zTree.getNodeByTId(treeNode.id));
		$('form[name=frm] input[name=org_seq]').val(treeNode.id);
		$('form[name=frm] input[name=domain]').val(treeNode.domain);
		$('form[name=frm] input[name=inventory_id]').val(treeNode.inventoryId);
		$('form[name=frm] input[name=group_id]').val(treeNode.groupId);
		
		$("#pcInfoNav").text("[ " +treeNode.name +"] 조직의 PC 목록");
		$.post("backupRCShow", {
				org_seq: treeNode.id,
				domain: treeNode.domain
			},
			function (result) {
				var agrs = result;
				var strHtml = "";
				var tmp = "";

				if (agrs.length == 0) {
					strHtml += "등록된 조직의 컴퓨터 정보가 없습니다.";
					$("#selectPcOne").text('');
				} else {
					$("#org_seq").val(treeNode.id);
					strHtml += '<div class="wrapperBackupR">';
					for (var i = 0; i < agrs.length; i++) {

						var hostnameVal = '';
						if (agrs[i].pc_hostname.length >= 20) {
							hostnameVal = agrs[i].pc_hostname.substr(0, 20) + '...';
						} else {
							hostnameVal = agrs[i].pc_hostname;
						}
						
						strHtml += '<div class="col-sm-4">';
						strHtml += '<input type="radio" id="control_0'+agrs[i].seq+'" name="pc_seq" value="'+agrs[i].seq+'">';
						strHtml += '<label class="labels" for="control_0'+agrs[i].seq+'" onClick="selectPcRecovery('+agrs[i].seq+')">';
						strHtml += hostnameVal;
						strHtml += '</label>';
						strHtml += '</div>';
					
					}
						strHtml += '</div>';
					$("#recoveryPcBackuplist").append('* 복구할 PC를 선택해주세요.');
				}
				strHtml += "</div>";
				$("#recoveryPclist").show();
				$("#recoveryPclist").append(strHtml);
				console.log("org_seq==="+$('form[name=frm] input[name=org_seq]').val());
			});
			//checkAnsibleJobStatus(agrs.job_id);
	}

	function beforeClick(treeId, treeNode, clickFlag) {
		var zTree = $.fn.zTree.getZTreeObj("tree");
		zTree.checkNode(treeNode, !treeNode.checked, true, true);
		return true;
	}

	function onCheck(event, treeId, treeNode) {}
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
						<header class="panel-heading font-bold">
							컴퓨터 복구 관리
						</header>
						<div class="panel-body">
							<form class="form-horizontal" name="frm" method="post" action="backupRCSave">
								<input type="hidden" name="org_seq"  id="org_seq" value="" />
								<input type="hidden" name="br_seq"  id="br_seq" value="" />
								<input type="hidden" name="inventory_id" id="inventory_id" value="" />
								<input type="hidden" name="group_id" id="group_id" value="" />
								<input type="hidden" name="job_id" id="job_id" value="" />
								<input type="hidden" name="domain" id="domain" value="" />

								<div class="form-group">
									<label id="pcInfoNav" class="col-sm-2 control-label">PC 목록</label>
									<div class="col-sm-10" id="pclistLayer">

										<!-- pc list -->
										<div class="col-sm-10 boxborder" style="display:none;" id="recoveryPclist"></div>
										
										<!-- pc backup list -->
										<div class="col-sm-10 boxborder" style="display:none;" id="recoveryPcBackuplist"></div>

										<div class="col-sm-10">
											<span class="help-block m-b-none" id="recoveryMsg"> </span>
										</div>
									</div>
								</div>
<!-- 								<div class="line_bg line-dashed line-lg pull-in"></div> -->
							</form>
						</div>
						<div class="panel-body fotter-bg"  id="bodyfooter">
							<div class="right">
								<button type="button" class="btn btn-s-md btn-default btn-rounded" id="btnSave"> 복구하기</button>
							</div>
						</div>
						
					</section>

				</section>
		</aside>


	</section>
</section>


<script>
	//등록 처리결과(공통명 : 프로그램명Json )
	function fnSaveRecoovery() {

		var button = document.getElementById('btnSave');
		const pc_seq = $('form[name=frm] input[name="pc_seq"]:checked').val();
		const br_seq = $('form[name=frm] input[name="br_seq"]:checked').val();
		const org_seq = $('form[name=frm] input[name=org_seq]').val();
		const br_backup_name = $('form[name=frm] input[name="br_seq"]:checked').data("name");
		const br_backup_path = $('form[name=frm] input[name="br_seq"]:checked').data("path");

		if (pc_seq == null) {
			alert("pc를 선택해주세요.");
			return false;
		}
		if (br_seq == null) {
			alert("백업본을 선택해주세요.");
			return false;
		}

		$('form[name=frm] input[name=pc_seq]').val(pc_seq);
		$('form[name=frm] input[name=br_seq]').val(br_seq);
		$('form[name=frm] input[name=org_seq]').val(org_seq);

		button.disabled = true;

		$.post("backupRCSave", {
				dataType: 'json',
				pc_seq: pc_seq,
				br_seq: br_seq,
				org_seq: org_seq,
				br_backup_name: br_backup_name,
				br_backup_path: br_backup_path,
				inventory_id: $('form[name=frm] input[name=inventory_id]').val(),
				group_id: $('form[name=frm] input[name=group_id]').val(),
				domain: $('form[name=frm] input[name=domain]').val(),
			},
			function (result) {
				if (result.STATUS == "SUCCESS") {
					alert("정상적으로 처리되었습니다.");
					checkAnsibleJobStatus(result.ID,"restore");
					location.reload();
				} else {
					alert("실패하였습니다.");
					//button.disabled = false;
				}
			});
		return false;
	}

	function selectPcRecovery(_val) {

		var seq = _val; //$("input:radio[name='pc_seq']:checked").val();
// 		var rasioNm = $("label[for='"+seq+"']").text(); 
// 		console.log("seq :" + seq + "=="+ rasioNm); 
		$("#recoveryPcBackuplist").empty();
		$.post("backupRCList", {
				seq: seq,
				domain: $('form[name=frm] input[name=domain]').val()
			},
			function (result) {
				var agrs = result;
				var strHtml = "";
				if (agrs.length == 0) {
// 					$("#recoveryPcBackuplist").empty();
					$("#recoveryPcBackuplist").append('* 등록된 PC의 백업파일이 없습니다.');
				} else {
					for (var i = 0; i < agrs.length; i++) {
						
// 						strHtml += '<div class="col-sm-4">';
// 						strHtml += '<input type="radio" id="br_seq'+i+'" name="pc_seq" value="'+agrs[i].br_seq+'" data-name="'+agrs[i].br_backup_name+'" data-path="'+agrs[i].br_backup_path+'">';
// 						strHtml += '<label class="labels" for="br_seq'+i+'" >';
// 						strHtml += agrs[i].br_backup_name;
// 						strHtml += '</label>';
// 						strHtml += '</div>';
						

					    
						
						strHtml += "<li style='padding-right: 0px; font-size:14px; min-width: unset;'>";
						strHtml += "<span>";
						strHtml += "<input type=\"radio\" name=\"br_seq\" id=\"br_seq" + i + "\" value='" + agrs[i].br_seq +"' data-name='"+agrs[i].br_backup_name+"' data-path='"+agrs[i].br_backup_path+"' checked/>";
						strHtml += "<label style='float: unset;' for=\"br_seq" + i + "\" class=\"\">";


						if (agrs[i].br_backup_status == 'A') strHtml += "초기백업본 ";
						else if (agrs[i].br_backup_status == 'B') strHtml += "일반백업본 ";

						strHtml += "</label>";
						strHtml += "</span>";
						strHtml += "<div style='padding: 10px 10px 10px 22px; font-size: 18px;'> 백업일자 : " + agrs[i].br_backup_name + "</div>";
						strHtml += "</li>";

					}
					

					if (agrs[0] != undefined || agrs[0] != null) {
						$('form[name=frm] input[name=org_seq]').val(agrs[0].br_org_seq);
					}

				}
				$("#recoveryPcBackuplist").show();
				$("#recoveryPcBackuplist").append(strHtml);
			});


	}
	
// 	$(document).ready(function () {
// 		onClick(null,$("#tree"),zNodes[0]);
// 	});
</script>



<%@ include file="../template/footer.jsp" %>