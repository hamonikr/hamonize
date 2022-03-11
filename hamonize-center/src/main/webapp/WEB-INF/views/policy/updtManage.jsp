<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>
<%@ include file="../template/left.jsp" %>



<script type="text/javascript">

$(document).ready(function(){ 
	var currentPosition = parseInt($(".quickmenu").css("top")); $(window).scroll(function() { var position = $(window).scrollTop(); $(".quickmenu").stop().animate({"top":position+currentPosition+"px"},1000); }); });

</script>
<script>
	$(document).ready(function () {
		//등록버튼
		$("#btnSave").click(fnSaveUpdt);
		$("#btnInit").click(fnInit);
		if($('form[name=frm] input[name=job_id]').val() > 0){
			window.onload = function() {checkAnsibleJobStatus($('form[name=frm] input[name=job_id]').val())};
		}
	});

	//메뉴 Tree onClick
	function onClick(event, treeId, treeNode, clickFlag) {
		$('form[name=frm] input[name=former_ppm_name]').val("");
		$('input:checkbox[name=pu_seq]').prop("checked", false);
		var zTree = $.fn.zTree.getZTreeObj("tree");
		var node = zTree.getNodeByParam('id', treeNode.pId);
// 		zTree.selectNode(zTree.getNodeByTId(treeNode.id));
		var queryArr = [];
		
		$('form[name=frm] input[name=org_seq]').val(treeNode.id);
		$('form[name=frm] input[name=domain]').val(treeNode.domain);
		$('form[name=frm] input[name=inventory_id]').val(treeNode.inventoryId);
		$('form[name=frm] input[name=group_id]').val(treeNode.groupId);
		$.ajaxSetup({ async:false });
		$.post("/gplcs/ushow", {
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
// 				$(".bodyDataLayer").removeClass("boder-line_off");
				
				if(obj !=  null){
					var ppm_seq = obj.ppm_seq; //agrs.dataInfo.ppm_seq;
					ppm_seq = ppm_seq.split(",");
					for (var i = 0; i < ppm_seq.length; i++) {
						$('input:checkbox[name=pu_seq]').each(function () {
							if ($(this).val() == ppm_seq[i]) {
								$(this).prop("checked", true);

								$("#btn"+ppm_seq[i]).addClass("active");
								// $(this).removeClass("class_name");
							
								queryArr.push($(this).data("package"));
								$("#btn" + ppm_seq[i]).addClass("active");
								$(this).closest('blockquote').addClass('boder-line_on');
								$(this).closest('blockquote').removeClass('boder-line_off');
								console.log("$(this).val() ==="+$(this).val() );
								$("#div"+$(this).val()).appendTo("#checkedUpdt");
							}
						});
					}
					//$('form[name=frm] input[name=pOrgNm]').val(agrs.pOrgNm);
					
				}
				//checkAnsibleJobStatus(agrs.job_id);
			});
		$('form[name=frm] input[name=former_ppm_name]').val(queryArr);                               
	}

	function beforeClick(treeId, treeNode, clickFlag) {
		var zTree = $.fn.zTree.getZTreeObj("tree");
		zTree.checkNode(treeNode, !treeNode.checked, true, true);
		return true;
	}

	// 	checkbox click event
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
							# 프로그램 설치 관리
							<i class="fa fa-info-sign text-muted" data-toggle="tooltip" data-placement="bottom" data-title="ajax to load the data." data-original-title="" title=""></i>
						</header>
						
						<div class="wrapper">

								<form name="frm" method="post" action="/gplcs/orgManage" class="row">
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
									<c:forEach items="${pList}" var="data" varStatus="status">
										<c:if test="${data.pu_name.indexOf('hamonize')!=0}">
											<div class="col-lg-3" id="div${data.pu_seq }">
												<blockquote class="bodyDataLayer boder-line_off">
													<div class="form-check">
														<input  width=0 height=0 style="visibility:hidden" class="form-check-input" data-package="<c:out value='${data.pu_name}' />" type="checkbox" name="pu_seq" id="${data.pu_seq}" value="<c:out value='${data.pu_seq}'/>">
														<label class="form-check-label" for="${data.pu_seq}">
															<p><c:out value="${data.pu_name}" /></p>
														</label>
													</div>
													<small>
														<c:if test="${data.deb_now_version ne data.deb_new_version and data.deb_now_version ne null}">
															업데이트가 필요합니다. 최신버전은 <c:out value="${data.deb_new_version}" /> 입니다.
														</c:if>
														<c:if test="${data.deb_now_version eq null}">
															신규 프로그램
														</c:if>
														<a href="#" name="selectName" data-toggle="class" class="btn btn-default btn-xs"  onClick="updtClickCellbox('${data.pu_seq}')" id="btn${data.pu_seq}">
															<i class="fa fa-square-o text-muted text"></i>
															<i  class="fa fa-check-square-o text-danger text-active">선택</i> 
															
														</a>
													</small>
												</blockquote>
											</div>
										</c:if>
									</c:forEach>
									
									

								</form>

						</div>
					</section>
					<div class="panel-body fotter-bg"  id="bodyfooter">
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
$('#div1').scrollTop($('#div1')[0].scrollHeight);
	//등록 처리결과(공통명 : 프로그램명Json )
	function fnSaveUpdt() {
		var button = document.getElementById('btnSave');
		let ppm_names = [];
		if (confirm("하위부서 및 부서가 있다면 하위부서 및 부서에도 전부 적용됩니다 적용하시겠습니까?")) {
			var ppm_seq = "";
			$('input:checkbox[name=pu_seq]').each(function (i) {
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
								queryArr.push(data);
						});
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
		$('input:checkbox[name=pu_seq]').each(function (i) {
			if ($(this).is(':checked')){
				updtClickCellbox($(this).attr('id'));
			}
		});
		$('a[name=selectName]').removeClass("btn btn-default btn-xs active");
		$('a[name=selectName]').addClass("btn btn-default btn-xs");
	}

	function updtClickCellbox(_val){

		if( $("input:checkbox[id='"+_val+"']").is(":checked") == true ){
			$("input:checkbox[id='"+_val+"']").prop("checked", false);
			$("input:checkbox[id='" + _val + "']").closest('blockquote').removeClass('boder-line_on');
			$("input:checkbox[id='" + _val + "']").closest('blockquote').addClass('boder-line_off');
		}else{
			$("input:checkbox[id='"+_val+"']").prop("checked", true);
			$("input:checkbox[id='" + _val + "']").closest('blockquote').addClass('boder-line_on');
			$("input:checkbox[id='" + _val + "']").closest('blockquote').removeClass('boder-line_off');
		}
		
	}
	
	$(document).ready(function () {
// 		onClick(null,$("#tree"),zNodes[0]);;
	});
</script>

<%@ include file="../template/footer.jsp" %>