<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>
<%@ include file="../template/left.jsp" %>

<!-- <link rel="stylesheet" href="/logintemplet/notebook/js/fuelux/fuelux.css" type="text/css" />
<script src="/logintemplet/notebook/js/fuelux/fuelux.js"></script> -->
<style>
	.boxborder {
		border: 1px solid #e0e4e8;
		padding: 10px;
		border-radius: 4 px;
	}

	.line_bg {
		*width: 100%;
		height: 2px;
		margin: 10 px;
		font-size: 0;
		overflow: hidden;
		background-color: transparent;
		border-width: 0;
		border-top: 1px solid #e8e8e8;
	}

	/* [라디오 버튼 커스텀 스타일 변경 실시] */
	input[type='radio'] {
		-webkit-appearance: none;
		width: 17px;
		height: 17px;
		/* [라디오 버튼 테두리 색상 정의] */
		border: 1px solid darkgray;
		border-radius: 50%;
		outline: none;
		/* [라디오 버튼 배경 색상 정의] */
		background: #ffffff;
	}

	input[type='radio']:before {
		/* [content null 설정해서 커스텀 지정] */
		content: '';
		display: block;
		width: 70%;
		height: 70%;
		margin: 15% auto;
		border-radius: 50%;
	}

	input[type='radio']:checked:before {
		/* [라디오 버튼이 클릭 되었을 경우 내부 원형 색상] */
		background: #007bff;
	}
</style>
<script>
	function selectPcRecovery(_val){
		console.log("========+++++>" + _val);
		// var radioId = $('input[name="COLOR"]:checked').val();
        // var rasioNm = $("label[for='"+radioId+"']").text(); // 라벨값을 불러온다.
        // alert(rasioNm);


	}
	$(document).ready(function () {

		//등록버튼
		$("#btnSave").click(fnSaveRecoovery);
		$("#recoveryPclist").show();
		$("#recoveryPclist").append('복구할 PC를 선택해 주세요.');

		
	});
	//메뉴 Tree onClick
	function onClick(event, treeId, treeNode, clickFlag) {
		$("#recoveryMsg").empty();
		$("#recoveryPclist").empty();
		$("#recoveryPcBackuplist").empty();
		
		var zTree = $.fn.zTree.getZTreeObj("tree");
		var node = zTree.getNodeByParam('id', treeNode.pId);

		$.post("backupRCShow", {
				org_seq: treeNode.id
			},
			function (result) {
				var agrs = result;
				var strHtml = "";
				var tmp = "";
				// strHtml = " <div class=\"some-class\">";

				if (agrs.length == 0) {
					strHtml += "등록된 조직의 컴퓨터 정보가 없습니다.";
					$("#selectPcOne").text('');
				} else {

					for (var i = 0; i < agrs.length; i++) {
						console.log(agrs[i]);
						if (i == 0) {
							tmp = "checked";
						}

						// strHtml += "";
						// strHtml += "<div class=\"radio-holder\">";
						// strHtml += "<input id='dept_seq" + i + "' name='dept_seq' type='radio' value='" + agrs[i].seq +"'>";
						// strHtml += "<label for='dept_seq" + i + "'>" + agrs[i].pc_hostname + "</label>";
						// strHtml += "</div>";

						strHtml += '<div class="radio col-sm-2" >';
						strHtml += '<label class="radio-custom">';
						strHtml += '<input type="radio" name="dept_seq" value="' + agrs[i].seq + '" onClick="selectPcRecovery('+agrs[i].seq+')">';
						strHtml += agrs[i].pc_hostname;
						strHtml += '</label>';
						strHtml += '</div>';




					}



					// $("#selectPcOne").text("복구할 PC를 선택해주세요.");
					$("#recoveryMsg").append('* 복구할 PC를 선택해주세요.');
				}
				strHtml += "</div>";
				$("#recoveryPclist").show();
				$("#recoveryPclist").append(strHtml);

			});
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
							<form class="form-horizontal" method="get">

								<div class="form-group">
									<label class="col-sm-2 control-label">PC 목록(HostName)</label>
									<div class="col-sm-10" id="pclistLayer">

										<!-- pc list -->
										<div class="col-sm-10 boxborder" style="display:none;" id="recoveryPclist"></div>

										<!-- pc backup list -->
										<div class="col-sm-10 boxborder" style="display:none;" id="recoveryPcBackuplist"></div>

										<div class="col-sm-10">
											<span class="help-block m-b-none" id="recoveryMsg"> </span>
										</div>
									</div>

									<div class="form-group">
										<div class="col-sm-4 col-sm-offset-2">
											<button type="button" class="btn btn-primary" id="btnSave">복구하기</button>
										</div>
									</div>
								</div>
								<!-- <div class="line_bg line-dashed line-lg pull-in"></div> -->
							</form>
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

		var dept_seq = $('input[name="dept_seq"]:checked').val();

		var br_seq = $('input[name="br_seq"]:checked').val();
		var org_seq = $("#org_seq").val();

		console.log("dept_seq====" + $('input[name="dept_seq"]:checked').val());
		console.log("br_seq====" + $('input[name="br_seq"]:checked').val());
		console.log("org_seq====" + $("#org_seq").val());

		if (dept_seq == null) {
			alert("pc를 선택해주세요.");
			return false;
		}
		if (br_seq == null) {
			alert("백업본을 선택해주세요.");
			return false;
		}

		$('form[name=frm] input[name=dept_seq]').val(dept_seq);
		$('form[name=frm] input[name=br_seq]').val(br_seq);
		$('form[name=frm] input[name=org_seq]').val(org_seq);

		button.disabled = true;

		$.post("backupRCSave", {
				dataType: 'json',
				dept_seq: dept_seq,
				br_seq: br_seq,
				org_seq: org_seq
			},
			function (result) {
				if (result == "SUCCESS") {

					alert("정상적으로 처리되었습니다.");
					button.disabled = false;

					location.reload();
				} else {
					alert("실패하였습니다.");
				}
			});
		return false;
	}

	
	$(document).ready(function () {

	// 	$("#pclistLayer").on("click", "label", function(){
	// 	// $check = $(this).prev();
	// 	// if($check.prop('checked'))
	// 	// $check.prop( "checked", false );
	// 	// else 
	// 	// $check.prop( "checked", true );
	// 	console.log("recoveryPclist");
		 
	// 	//console.log($check.prop("checked"));
	// });

	
		
		/*
		//라디오 이벤트 - PC 목록 클릭시
		$("#recoveryPclist").on("click", function () {
				// $(this).prev().prop("checked", true);
				$("#recoveryPcBackuplist").empty();
				console.log("recoveryPclist");
				// console.log("event : "+event.data[0]);

				var seq = $("input:radio[name='dept_seq']:checked").val();
				console.log("seq :" + seq); 

				$.post("backupRCList", {
						seq: seq
					},
					function (result) {
						var agrs = result; 
						var strHtml = "";

						for (var i = 0; i < agrs.length; i++) {
							strHtml += "<li style='padding-right: 0px; font-size:14px; min-width: unset;'>";
							strHtml += "<span>";
							strHtml += "<input type=\"radio\" name=\"br_seq\" id=\"br_seq" + i + "\" value='" + agrs[i]
								.br_seq + "'/>";
							strHtml += "<label style='float: unset;' for=\"br_seq" + i + "\" class=\"\">";

							$.post("backupRCList", {
									seq: seq
								}, 
								function (result) {
									var agrs = result;
									var strHtml = "";
									for (var i = 0; i < agrs.length; i++) {
										strHtml += "<li style='padding-right: 0px; font-size:14px; min-width: unset;'>";
										strHtml += "<span>";
										strHtml += "<input type=\"radio\" name=\"br_seq\" id=\"br_seq" + i + "\" value='" + agrs[i].br_seq + "'/>";
										strHtml += "<label style='float: unset;' for=\"br_seq" + i + "\" class=\"\">";

										if (agrs[i].br_backup_gubun == 'A') strHtml += "초기백업본 ";
										else if (agrs[i].br_backup_gubun == 'B') strHtml += "일반백업본 ";

										strHtml += "</label>";
										strHtml += "</span>";
										strHtml += "<div style='padding: 10px 10px 10px 22px; font-size: 18px;'> 백업일자 : " + agrs[i].br_backup_name + "</div>";
										strHtml += "</li>";

									}

									$("#recoveryPcBackuplist").append(strHtml);
									$("#selectPcOne").text('');
									if (agrs[0] != undefined || agrs[0] != null) {
										$('form[name=frm] input[name=org_seq]').val(agrs[0].br_org_seq);
									}

									if (agrs.length == 0) {
										$("#selectPcOne").text('등록된 정보가 없습니다.');

									}

								});
						}
					}
				);


			// //라디오 이벤트 - 백업목록 클릭시
			// $("#recoveryPcBackuplist").on("click", "label", function () {
			// 	console.log("recoveryPcBackuplist");
			// 	$(this).children('input').prop('checked', true);
			// });

		});
		*/
});
</script>

<%@ include file="../template/footer.jsp" %>