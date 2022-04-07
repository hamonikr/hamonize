<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>
<%@ include file="../template/left.jsp" %>

<style>
	.file-drop-area {
		position: relative;
		display: flex;
		align-items: center;
		width: 90%;
		max-width: 100%;
		padding: 10px;
		border: 1px dashed #ccc;
	
	border-radius: 3px;
		transition: 0.2s
	}

</style>

<script type="text/javascript">

$(document).ready(function(){ 
	var currentPosition = parseInt($(".quickmenu").css("top")); $(window).scroll(function() { var position = $(window).scrollTop(); $(".quickmenu").stop().animate({"top":position+currentPosition+"px"},1000); }); });

</script>
<script>
	$(document).ready(function () {
		//등록버튼
		$("#btnSave").click(fnSaveUpdt);
		$("#btnInit").click(fnInit);

		//  팝업] 패키지 등록 버튼
		$('#saveUpdt').on('click', function () {
			addUpdtFnt();
		});

		// 팝업]  패키지 삭제 버튼
		$('#deleteUpdt').on('click', function () {
			deleteUpdtFnt();
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

		$(document).on('change', '.file-input', function() {
			var filesCount = $(this)[0].files.length;
			var textbox = $(this).prev();
		
			if (filesCount === 1) {
				var fileName = $(this).val().split('\\').pop();
				textbox.text(fileName);
			} else {
				textbox.text('선택된 파일이 없습니다');
			}
		});
		//getList();
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
						<header class="bg-dark dk header navbar navbar-fixed-top-xs">
							<ul class="nav navbar-nav hidden-xs">
								<li>
									<div class="m-t m-l">
										# 프로그램 설치 관리
									</div>
								</li>
							</ul>


							<ul class="nav navbar-nav navbar-right m-n hidden-xs nav-user">

								<li class="hidden-xs ">
									<a href="javascript:;" data-toggle="dropdown"
										data-target="#updtLayer">
										<i class="fa fa-plus-circle"></i>
										패키지추가
										<!-- <span class="badge badge-sm up bg-danger m-l-n-sm count" style="display: inline-block;">방화벽추가</span> -->
									</a>

									<div id="updtLayer" class="dropup">
										<section class="dropdown-menu on aside-md m-l-n"
											style="width:800px; height: 700px; top: 0;">
											<section class="panel bg-white">
												<header class="panel-heading b-b b-light">패키지 관리</header>

												<div class="panel-body animated fadeInRight">

													<form id="addForm" class="form-inline col-md-12 row" action=""
														style="display:none;">
														<input type="hidden" id="kind"
														name="kind" value="updt" />
														<div class="well m-t">
															<div class="col-xs-12">
																<div class="form-group pull-in clearfix">
																	<div class="col-sm-4">
																		<label>패키지 이름</label>
																		<input id="pu_name" name="pu_name" type="text"
																			class="form-control parsley-validated"
																			placeholder="패키지 이름" />
																	</div>
																	<div class="col-sm-4">
																		<label>패키지 상세 정보</label>
																		<input id="pu_dc" name="pu_dc" type="text"
																			class="form-control parsley-validated"
																			maxlength="20" placeholder="패키지 상세 정보" />
																	</div>
																	<div class="col-sm-4">
																		<label>첨부파일</label>
																		<input type="file" style="position: fixed; left: -1500px; display: none;" class="filestyle" data-icon="false" data-classbutton="btn btn-default" 
																		data-classinput="form-control inline input-s" name="keyfile" id="filestyle-0">
																	</div>
																</div>
															</div>
															<button type="button" class="btn btn-rounded pull-right btn-sm btn-facebook" id="saveUpdt">신규 패키지 등록 </button>
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
															<col style="width:15%;" />
															<col style="width:15%;" />
															<col />
														</colgroup>
														<thead>
															<tr>
																<th></th>
																<th>번호</th>
																<th>패키지 이름</th>
																<th>패키지 버전</th>
																<th>패키지 상세 정보</th>
															</tr>
														</thead>

														<tbody id="pageGrideInMngrListTb"></tbody>
													</table>
													<div class="dataTables_wrapper">
														<!-- page number -->
														<div class="page_num"></div>
													</div>
												</div>

												<button type="button" class="btn btn-s-md btn-default btn-rounded" id="deleteUpdt">삭제</button>
												<button type="button" class="btn btn-s-md btn-default btn-rounded insertBtn">패키지 추가</button>
											</section>
										</section>
									</div>

								</li>
							</ul>
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

	function getListAddDeleteVer() {
		var url = '/gplcs/uManagePopList';

		var keyWord = $("select[name=keyWord]").val();
		var vData = 'MngeListInfoCurrentPage=' + $("#MngeListInfoCurrentPage").val() + "&keyWord=" + keyWord +
			"&txtSearch=" + $("#txtSearch").val();

		function fnt(data, status, xhr, groupId) {
			deviceGetSuccess(data, status, xhr, groupId);
			$('.mdl-data-table__cell--non-numeric .form-control').css('opacity', '1');
		}

		callAjax('POST', url, vData, fnt, getError, 'json');
	}

	function getList() {
		var url = '/gplcs/uManagePopList';

		var keyWord = $("select[name=keyWord]").val();
		var vData = 'MngeListInfoCurrentPage=' + $("#MngeListInfoCurrentPage").val() + "&keyWord=" + keyWord +
			"&txtSearch=" + $("#txtSearch").val();
		callAjax('POST', url, vData, deviceGetSuccess, getError, 'json');
	}

	var deviceGetSuccess = function (data, status, xhr, groupId) {
		var gbInnerHtml = "";
		var classGroupList = data.list;
		$('#pageGrideInMngrListTb').empty();
		if (data.list.length > 0) {
			$.each(data.list, function (index, value) {
				var no = data.pagingVo.totalRecordSize - (index) - ((data.pagingVo.currentPage - 1) * 5);
				if (value.pu_dc == null)
					value.pu_dc = "설명이 없습니다";

				gbInnerHtml += "<tr data-code='" + value.pu_seq + "'>";
				gbInnerHtml += "<td>";

				if (value.ppm_seq == value.pu_seq) {
					gbInnerHtml += "<input type='checkbox' id=u" + no +
						" disabled class='updtCheck'><label for=u" + no + " ></label></td>";
				} else {
					gbInnerHtml += "<input type='checkbox' id=u" + no + " class='updtCheck'><label for=u" +
						no + "  ></label></td>";
				}

				gbInnerHtml += "<td><span>" + no + "</span>";
				gbInnerHtml += "<td>" + value.pu_name + "</td>";
				gbInnerHtml += "<td>" + value.deb_new_version + "</td>";
				gbInnerHtml += "<td>" + value.pu_dc + "</td>";
				//gbInnerHtml += "<td>" + data.filelist.filerealname + "</td>";
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

	// 패키지 추가
	function addUpdtFnt() {
		var name = $('#pu_name').val();
		var info = $('#pu_dc').val();
		//var port = $('#sm_port').val();
		var regExp = /^[0-9_]/;
		var InputFiles;
		
		InputFiles = $("#filestyle-0")[0];
		var filename =  $("#filestyle-0").val().split('\\').pop();
	
		if(InputFiles.files.length === 0){
				alert("파일을 선택해주세요");
			return false;
			}

		// 검증
		if (name.length <= 0) {
			alert('패키지명을 입력해 주세요!');
			return false;
		}

		if (info.length <= 0) {
			alert('패키지설명을 입력해 주세요!');
			return false;
		}

		var form = $('#addForm')[0];
    var formData = new FormData(form);

		// 전송
		$.ajax({
			url: '/gplcs/uManagePopSave',
			type: 'POST',
			enctype: 'multipart/form-data',
			data: formData,
			processData: false,    
      contentType: false,      
      cache: false,
			success: function (res) {
				if (res.success == true) {
					alert(res.msg);
					getListAddDeleteVer();
					fromReset();
					location.reload();

				} else {
					alert(res.msg);
				}
			},
			error: function (request, status, error) {
				console.log("code:" + request.status + "\n" + "message:" + request.responseText + "\n" +
					"error:" + error);
			}
		});
	}

	// 패키지 삭제 버튼
	function deleteUpdtFnt() {
		var iptArr = $('.updtCheck:checked');
		var packageArr = [];

		// 검증
		$.each(iptArr, function (idx, ipt) {
			packageArr.push($(ipt).parent().parent().attr('data-code'));
		});

		if (0 >= packageArr.length) {
			alert('삭제할 패키지를 선택해 주시기 바랍니다!');
			return;
		}



		function ftn(data, status, xhr, groupId) {
			alert('정상적으로 삭제되었습니다!');
			getListAddDeleteVer();
			fromReset();
			location.reload();
		}

		// 전송
		var url = '/gplcs/uManagePopDelete';
		var vData = "deleteList=" + addressArr;
		console.log("a===" + vData);
		callAjax('POST', url, vData, ftn, getError, 'json');
	}

	// 입력폼 초기화
	function fromReset() {
		$('#pu_name').val('');
		$('#pu_dc').val('');
		$('#sm_port').val('');
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

	function uploadFile(){
		var InputFiles;
		
		InputFiles = $("#filestyle-0")[0];
		var filename =  $("#filestyle-0").val().split('\\').pop();
	
		if(InputFiles.files.length === 0){
				alert("파일을 선택해주세요");
			return;
			}
		
		var formData = new FormData();
		formData.append("keyfile", InputFiles.files[0]);
		//formData.append("keytype", keytype);
	
		$.ajax({
			type:"POST",
			url: "/file/upload",
			processData: false,
			contentType: false,
			data: formData,
		success: function(retval){
			if(retval=="S"){
				//alert("업로드 성공");
				//location.reload();
			}else{
				//alert("업로드 실패");
				//location.reload();
			}
		},
		err: function(err){
			console.log("err:", err)
		}
		});
	
	}
	
	function fnFileDownload(seq, filename, filerealname){
		
		$.ajax({
			type:"POST",
			url: "/file/download",
			data: {
				filename:filename,
				filerealname:filerealname,
				seq : seq
			},
			success: function(ret){
				var blob = new Blob([ret], { type: "application/octetstream" });
	 
				var isIE = false || !!document.documentMode;
				if (isIE) {
					window.navigator.msSaveBlob(blob, filerealname);
				} else {
					var url = window.URL || window.webkitURL;
					var a = $("<a class='openFile'/>");
				
					link = url.createObjectURL(blob);
					a.attr("download", filerealname);
					a.attr("href", link);
					$("body").append(a);
					a[0].click();
					$(".openFile").remove();
				}
			},
			err: function(err){
				console.log("err:", err)
			}
			});
	}
	
	function deleteFile(seq, filename){
		
		console.log("seq : "+seq);
		console.log("filename : "+filename);
			$.ajax({
			type:"POST",
			url: "/file/delete",
			data: {
				seq : seq, 
				filename : filename
			},
			success: function(ret){
				if(ret=="S"){
					alert("파일이 정상적으로 삭제되었습니다.");
				}else{
					alert("파일 삭제에 실패했습니다. 관리자에게 문의주세요.");
				}
				location.reload();
			},
			err: function(err){
				console.log("err:", err)
			}
			});
	}

	function searchView(viewName, page){
		switch(viewName){
			case 'classMngrList' : $("#MngeListInfoCurrentPage").val(page); getList(); break;	//	공지사항
			default :
		}
	}
	/*
	 * 이전 페이지
	 */
	function prevPage(viewName, currentPage){
		var page = eval(currentPage) - 1;
			if(page < 1){
				page = 1;
			}
		searchView(viewName, page);
	}
	/*
	 * 다음 페이지
	 */
	function nextPage(viewName, currentPage, totalPageSize){
		var page = eval(currentPage) + 1;
		var totalPageSize = eval(totalPageSize);
		if(page > totalPageSize){
			page = totalPageSize;
		}
		searchView(viewName, page);
	}

</script>
<script src="/logintemplet/notebook/js/file-input/bootstrap-filestyle.min.js"></script>
<%@ include file="../template/footer.jsp" %>