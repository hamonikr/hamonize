<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>
<%@ include file="../template/topMenu.jsp" %>
<%@ include file="../template/topNav.jsp" %>

<link rel="stylesheet" type="text/css" href="/css/sgb/common.css">
<link rel="stylesheet" type="text/css" href="/css/sgb/content.css">



<body>
	<div class="hamo_container other">
		<div class="content_con">
			<h2>환경 설정</h2>
			
			<!-- serverlist mngr box start -->
			<div class="con_box">
				<h3>서버 관리</h3>
				<div class="board_view2 mT20">
					<form method="post" id="addForm" class="form-inline col-md-12 row" style="display:none;">
						<input type="hidden" name="seq" id="seq" value=0> 
						<table>
							<colgroup>
							   <col style="width:10%;" />
							   <col style="width:10%;" />
							   <col style="width:10%;" />
							   <col style="width:15%;" />
							   <col style="width:10%;" />
							   <col style="width:15%;" />
							   <col style="width:10%;" />
							   <col style="width:15%;" />
							   <col style="width:5%;" />
							</colgroup>
							<tbody>
								<tr>
									<th>서버명</th>
									<td><input type="text" style="border:none;" name="svr_nm" id="svr_nm" class="input_type1" readonly></td>
									<th>IP</th>
									<td><input type="text" name="svr_ip" id="svr_ip" class="input_type1"></td>
									<th>VPN IP</th>
									<td><input type="text" name="svr_vip" id="svr_vip" class="input_type1"></td>
									<th>Port</th>
									<td><input type="text" name="svr_port" id="svr_port" class="input_type1" style="width:150px" /></td>
									<td>
										<button type="button" class="btnAdd btn-outline-info" >저장</button>
								   </td>
								</tr>
							</tbody>
						</table>
					</form>	   
					<input type="hidden" id="svrlstInfoCurrentPage" name="svrlstInfoCurrentPage" value="1" >
					
					<div class="board_list mT20">
						<table>
							<colgroup>
								<col style="width:5%;" />
								<col style="width:15%;" />
								<col style="width:20%;" />
								<col style="width:10%;" />
								<col style="width:20%;" />
							</colgroup>
							<thead>
								<tr>
									<th> </th>
									<th>서버명</th>
									<th>IP</th>
									<th>VPN IP</th>
									<th>PORT</th>
								</tr>
							</thead>
							<tbody id="pageGrideInSvrlstListTb">
							</tbody>
						</table>
					</div>
				
					<div class="mT20 inblock" style="margin-left:30px;">
						<button type="button" class="btn btn-outline-danger" id="chkDel">선택삭제</button>
					</div>
				</div>
			</div>
			<!-- serverlist mngr box end // -->
	
			<!-- progrm mngr box start -->
			<div class="con_box">
				<h3>프로그램 관리</h3>
				<div class="board_list mT20">
					<table>
						<colgroup>
							<col style="width:20%;" />
							<col style="width:30%;" />
							<col style="width:30%;" />
							<col style="width:5%;" />
	
							<col />
						</colgroup>
						<thead>
							<tr>
								<th>프로그램명</th>
								<th>설정</th>
								<th></th>
								<th></th>
	
							</tr>
						</thead>
						<tbody id="pageGrideInSvrProgrmListTb">
							<c:forEach var="list" items="${plist}" varStatus="status">
								<tr>
								<c:if test="${list.pu_name eq 'hamonize-agent' }">
								<input type="hidden" id ="pu_name" value=${list.pu_name}>
									<td>${list.pu_name}_${list.deb_new_version}</td>
									<td>
										<a style="color: steelblue;" href="#" onclick="setPoll();">폴링주기 설정</a>
									</td>
									<td>
										<div id="set_polling" style="display:none;">
											<select class="form-select " style="width: 60%;" id="polling_tm" name="polling_tm" style="width:50%;margin-left:5px">
												<c:if test="${list.polling_tm == 0}">
													<option selected hidden>폴링시간을 선택해주세요</option>
												</c:if>	
												<c:if test="${list.polling_tm  == 60}">
													<option value=10 selected hidden >1분</option>
												</c:if>														
												<c:if test="${list.polling_tm  == 300}">
													<option value=300 selected hidden >5분</option>
												</c:if>	
												<c:if test="${list.polling_tm  == 600}">
													<option value=600 selected hidden >10분</option>
												</c:if>	
												<c:if test="${list.polling_tm  == 1800}">
													<option value=1800 selected hidden >30분</option>
												</c:if>	
												<c:if test="${list.polling_tm  == 3600}">
													<option value=3600 selected hidden >1시간</option>
												</c:if>	
												<option value=10>10초</option>
												<option value=60>1분</option>
												<option value=300>5분</option>
												<option value=600>10분</option>
												<option value=1800>30분</option>
												<option value=3600> 1시간</option>
											</select>
										</div>
									</td>
									<td>
										<button id="btn_poll_save" class="btn btn-outline-info" style="display: none;margin-right:20px;" onclick="savePoll();"> 저장 </button>
									</td>	
								
								</c:if>
								</tr>
							</c:forEach>
	
						<tr>
							<c:forEach var="list" items="${slist}" varStatus="status">
								<c:if test="${list.svr_nm eq 'VPNIP' }">
									<td>
										vpn
									</td>
									<td>
										<a style="color: steelblue;" href="#">사용여부 설정</a>
									</td>
									<td id="set_vpn">
										<label class='switch'>
										<c:if test="${list.svr_used ==1 }">
											<input type='checkbox' checked id='vpn_used' name='svr_used' value='${list.svr_nm}' onClick='vpnCheck(this)'>
											<span class='slider round'></span>
										</c:if>
										<c:if test="${list.svr_used == 0 }">
											<input type='checkbox' id='vpn_used' name='svr_used' value='${list.svr_nm}' onClick='vpnCheck(this)'>
											<span class='slider round'></span>
										</c:if>
										</label>
									</td>
								</c:if>
							</c:forEach>
							<td></td>
							</tr>	
							<tr>
								<td>influx</td>
								<td>
									<a style="color: steelblue;" href="#" onclick="showEnvSet();">환경변수 설정</a>
								</td>
								<td>
									<div id="set_env" style="display:none;">
										<c:forEach var="list" items="${slist}" varStatus="status">
											<c:if test="${list.svr_nm eq 'INFLUX_TOKEN' or list.svr_nm eq 'INFLUX_ORG' or list.svr_nm eq 'INFLUX_BUCKET' }">
												<table>
												<colgroup>
													<col style="width:30%;" />
													<col style="width:30%;" />
													<col style="width:20%;" />
												</colgroup>
													<tr style="border: solid 2px transparent;">
														<td>
															${list.svr_nm}
														</td>
														<td>
															<input type="text" class="form-control" id="envVal_${list.seq}" value="${list.svr_ip}">
															
														</td>
														<td>
															<button id="btn_env_${list.seq}" class="btn btn-outline-info" style="margin-right:20px;" onclick="saveEnv('${list.seq}');"> 저장 </button>															</td>
														</td>
														
													</tr>
												</table>
											</c:if>
											
										</c:forEach>
									</div>
								</td>
								<td></td>	
	
							</tr>
						</tbody>
					</table>
				</div>	
			</div><!-- progrm mngr box end // -->
	
			<!--  admin key mngr box start -->
			<div class="con_box">
				<h3>어드민 관리</h3>
				<div class="board_list mT20">
					<table>
						<colgroup>
							<col style="width:30%;"/>
							<col style="width:40%;" />
							<col style="width:30%;" />
	
						</colgroup>
						<tr> 
							<td ><b>Public 키</b></td>
							<td> 
								<c:if test="${publickey.filename != null}">
									<a href="#" onclick="fnFileDownload('${publickey.seq}',' ${publickey.filename}', '${publickey.filerealname}');" style="color: steelblue;" > <img src="/images/key.svg"> ${publickey.filerealname}</a>
								</c:if>
								<c:if test="${publickey.filename == null}">
									<div class="container d-flex justify-content-center">
										<div class="file-drop-area"> 
											<span class="choose-file-button">파일 선택</span> 
											<span class="file-message">or drag&drop</span>
												<input id="file-input" name="keyfile" class="file-input" type="file" multiple>
										</div>
									</div>
								</c:if>
							</td> 
							<td>
								<c:if test="${publickey.filename == null}">
									<button class="btn btn-outline-info" style="margin-right:80%;" onclick="uploadFile('public')">업로드</button>
								</c:if>
								<c:if test="${publickey.filename != null}">
									<button class="btn btn-outline-danger" style="margin-right:80%;" onclick="deleteFile('${publickey.seq}','${publickey.filename}')">삭제</button>
								</c:if>
							</td>
						</tr> 
						<tr> 
							<td> <b>Private 키 </b></td>
							<td> 
								<c:if test="${privatekey.filename != null}">
									<a href="#" onclick="fnFileDownload('${privatekey.seq}',' ${privatekey.filename}', '${privatekey.filerealname}');" style="color:steelblue;" > <img src="/images/key.svg"> ${privatekey.filerealname}</a>
								</c:if>
								<c:if test="${privatekey.filename == null}">
									<div class="container d-flex justify-content-center">
										<div class="file-drop-area"> 
											<span class="choose-file-button">파일 선택</span> 
											<span class="file-message">or drag&drop</span>
												<input id="file-input2" class="file-input" type="file" multiple>
										</div>
									</div>
								</c:if>
							</td>
							<td>
								<c:if test="${privatekey.filename == null}">
									<button class="btn btn-outline-info" style="margin-right:80%;" onclick="uploadFile('private')">업로드</button>
								</c:if>
								<c:if test="${privatekey.filename != null}">
									<button class="btn btn-outline-danger" style="margin-right:80%;" onclick="deleteFile('${privatekey.seq}','${privatekey.filename}')">삭제</button>
								</c:if>								
							</td> 
						</tr>

						<tr> 
							<td> <b>Config 파일 </b></td>
							<td> 
								<c:if test="${config.filename != null}">
									<a href="#" onclick="fnFileDownload('${config.seq}',' ${config.filename}', '${config.filerealname}');" style="color:steelblue;" > ${config.filerealname}</a>
								</c:if>
								<c:if test="${config.filename == null}">
									<div class="container d-flex justify-content-center">
										<div class="file-drop-area"> 
											<span class="choose-file-button">파일 선택</span> 
											<span class="file-message">or drag&drop</span>
												<input id="file-input2" class="file-input" type="file" multiple>
										</div>
									</div>
								</c:if>
				
							</td>
							<td>
								<c:if test="${config.filename == null}">
									<button class="btn btn-outline-info" style="margin-right:80%;" onclick="uploadFile('adminconfig')">업로드</button>
								</c:if>
								<c:if test="${config.filename != null}">
									<button class="btn btn-outline-danger" style="margin-right:80%;" onclick="deleteFile('${config.seq}','${config.filename}')">삭제</button>
								</c:if>								
						</tr>
						 
					</table>
				</div>
			</div><!-- admin key mngr box end //-->
			
		</div><!-- content_con end //-->
	</div><!-- hamo_container end //-->


	<script type="text/javascript">

		function showEnvSet(){
			if($("#set_env").css("display") == "none"){   
				$('#set_env').css("display", "block");   
		
			} else {  
				$('#set_env').css("display", "none");
			  } 
		}
		
		
		function saveEnv(seq){
			var envVal = $("#envVal_"+seq).val();	
			$.ajax({
					url : '/admin/setEnv',
					type: 'POST',
					data:{seq:seq, svr_ip:envVal},
					success : function(res) {
						if( res == "SUCCESS" ){
							alert("성공적으로 변경되었습니다."+res);
							location.reload();
						}else{
							alert("변경이 실패되었습니다. 관리자에게 문의해주세요."+res);
						}
					},
					error:function(request,status,error){
						console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
					}
				}); 
		
		}
		
		function uploadFile(keytype){
			var InputFiles;
			
			if(keytype == "public"){
				InputFiles = $("#file-input")[0];
				var filename =  $("#file-input").val().split('\\').pop();
			}else{
				InputFiles = $("#file-input2")[0];
				var filename =  $("#file-input2").val().split('\\').pop();
			}
		
			if(InputFiles.files.length === 0){
				  alert("파일을 선택해주세요");
				return;
			  }
			
			var formData = new FormData();
			formData.append("keyfile", InputFiles.files[0]);
			formData.append("keytype", keytype);
		
			$.ajax({
				type:"POST",
				url: "/file/upload",
				processData: false,
				contentType: false,
				data: formData,
			success: function(retval){
				if(retval=="S"){
					alert("업로드 성공");
					location.reload();
				}else{
					alert("업로드 실패");
					location.reload();
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
		
		
		$(document).ready (function () {       
		
			$('#btnAdd').click (function () {                                        
				if($("#addInputLayer").css("display") == "none"){   
					$('#addInputLayer').css("display", "block");   
				} else {  
					$('#addInputLayer').css("display", "none");   
				}  
			}); // end click    
			$('.btnCancle').click (function () {
				$("#svr_nm").val('');
				$("#svr_domain").val('');
				$("#svr_ip").val('');
				$('#addInputLayer').css("display", "none");   
			}); // end click    
			
			$('.btnAdd').click (function () {
				var regExp = /[^0123456789.]/g;
				var port_regExp = /[^0123456789]/gi;
			
				console.log("ss"+!port_regExp.test($("#svr_port").val()));
			if(regExp.test($("#svr_ip").val())){
				alert("ip는 숫자와 . 만 입력해주세요.");
				return false;
			} else if(regExp.test($("#svr_vip").val())){
				alert("vpn ip는 숫자와 . 만 입력해주세요.");
				return false;
			}else if(port_regExp.test($("#svr_port").val())){
				alert("port는 숫자만 입력해주세요.");
				return false;
			}else{
				$.ajax({
					url : '/admin/serverlistInsert.proc',
					type: 'POST',
					data:$("form").serialize(),
					success : function(res) {
						if( res.success == true ){
							$("#svr_nm").val('');
							$("#svr_domain").val('');
							$("#svr_ip").val('');
							$("#svr_vip").val('');
							$("#svr_port").val('');
							$('#addInputLayer').css("display", "none");   
							
							getList();
		
							location.reload();
						}
					},
					error:function(request,status,error){
						console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
					}
				}); 
			}
		
			}); // end click     
		
			
			//선택삭제
			$('#chkDel').click(function() {
				var indexid = false;
				var checkRow = "";
				
				$( "input[name='RowCheck']:checked" ).each (function (){
					checkRow = checkRow + $(this).val()+"," ;
					indexid = true;
				});
				checkRow = checkRow.substring(0,checkRow.lastIndexOf( ","));
				if(!indexid){
					alert("삭제할 데이터를 체크해 주세요");
					return;
				}
				
				var agree=confirm("삭제 하시겠습니까?");
				if (agree){
					var $form = $('<form></form>').attr('action','/admin/serverlistDelete.proc').attr('method','POST');
					var $ipt = $('<input type="text" name="chkdel" id="chkdel"></input').val(checkRow);
					$form.append($ipt).appendTo('form').submit();
				} 
				
			});
			
			
			
			var getKeyWord = "${mngeVo.keyWord}";
			if(getKeyWord.length == 0){ 
				$("#keyWord option:eq(1)").prop("selected", true);		
			}else{
				$("#keyWordID").val(getKeyWord).attr("selected", true);
			}
			
			$("#txtSearch").keydown(function(key) {
				if (key.keyCode == 13) {
					getList();
				}
			});
			
			getList();
			
		
			
		});
		
		function setPoll(){
			if($('#set_polling').css("display") != "none" && $('#btn_poll_save').css("display") != "none"){
				$('#set_polling').hide();
				$('#btn_poll_save').hide();
		
			}else{
				$('#set_polling').show();
				$('#btn_poll_save').show();
			}
		}
		
		function savePoll(){
			var pu_name = $("#pu_name").val();
			var polling_tm = $("#polling_tm").val();
			var poll = polling_tm/60;
		
			if(polling_tm==10){
				poll = polling_tm+"초로";
			}else{
				poll = poll+"분으로";
			}
			console.log("polling_tm : "+polling_tm);
			if(confirm("폴링 주기를 "+poll+" 설정하시겠습니까?")==true){
				$.ajax({
					url : '/admin/setPollTime',
					type: 'POST',
					data: {pu_name:pu_name, polling_tm: polling_tm},
					success : function(res) {
						if( res == "SUCCESS" ){
							alert("성공적으로 변경했습니다.");
							location.reload();
						}else{
							alert("변경을 실패했습니다. 관리자에게 문의해주세요.");
							location.reload();
						}
					},
					error:function(request,status,error){
						console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
					}
				}); 
		   
			}
		
		
		
		}
		
		
		function vpnCheck(val){
			var vpn_used = 0;
			
			if($("input:checkbox[id='vpn_used']").is(":checked")==true){
				if(confirm("vpn을 사용하시겠습니까?")==true){	
					if(viplist.length >= 5){
						vpn_used = 1;
						saveVpnUsedVal(vpn_used,val);
					} else{
						alert("서버관리의 vpn ip가 모두 입력되지않았습니다. 다시 확인해주세요.");
						location.reload();
		
					}
				}else{
					$("input:checkbox[id='vpn_used']").removeAttr('checked');
				}
			}else{
				if(confirm("vpn 사용하지 않으시겠습니까?")==true){
					vpn_used = 0;
					saveVpnUsedVal(vpn_used,val);
				}else{
					vpn_used = 1;
					saveVpnUsedVal(vpn_used,val);
					$("input:checkbox[id='vpn_used']").prop("checked", true);
				}
			}
		
		}
		function saveVpnUsedVal(vpn_used,val){
			$.ajax({
				url : '/admin/vpnUsed',
				type: 'POST',
				data: {svr_used:vpn_used, svr_nm:val.value},
				success : function(res) {
					if( res >= 6 ){
						alert("vpn 사용여부가 변경되었습니다.");	
						location.reload();
					}else{
						alert("vpn 사용여부 변경이 실패되었습니다. 관리자에게 문의바랍니다.");	
					}
				}
			}); 
		
		}
		
		function edit(seq,servernm,ip,vip,port){
			var form = $('#addForm');
			console.log($("#seq").val());
			console.log(seq);
			if($("#seq").val()==seq){
				form.css('display','none');
				$("#seq").val("");
				$("#svr_nm").val("");
				$("#svr_ip").val("");
				$("#svr_vip").val("");
				$("#svr_port").val("");
		
				console.log("seq...s" + $("#seq").val())
		
		}else{
						
				if(port == "null"){
					port = '';
				}
		
				if(vip == "null"){
					vip = '';
				}
		
				form.css('display','block');
				$("#seq").val(seq);
				$("#svr_nm").val(servernm);
				$("#svr_ip").val(ip);
				$("#svr_vip").val(vip);
				$("#svr_port").val(port);
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
		}
		
		function searchView(viewName, page){
				switch(viewName){
					case 'classMngrList' :  $("#svrlstInfoCurrentPage").val(page); getList(); break;
				default :
				}
			}
		
		function getList(){
			var url ='/admin/serverlist.proc';
			var keyWord = $("select[name=keyWord]").val();
			var vData = 'svrlstInfoCurrentPage=' + $("#svrlstInfoCurrentPage").val() +"&keyWord="+ keyWord + "&txtSearch=" + $("#txtSearch").val();
			callAjax('POST', url, vData, svrlstGetSuccess, getError, 'json');
		}
		
		var viplist = new Array();
		var svrused;
		var svrlstGetSuccess = function(data, status, xhr, groupId){
			var gbInnerHtml = "";
			var classGroupList = data.list;
			$('#pageGrideInSvrlstListTb').empty();
			
			if( data.list.length > 0 ){
				$.each(data.list, function(index, value) {
					var no = data.pagingVo.totalRecordSize -(index ) - ((data.pagingVo.currentPage-1)*10);
				
					gbInnerHtml += "<tr data-code='" + value.seq + "'>";
					gbInnerHtml += "<td><input type='checkbox' name='RowCheck' value='" + value.seq + "' style=\"display: -webkit-inline-box;\"></td>";
				
					gbInnerHtml += "<td><a style='color: steelblue;' href='#' onclick=\"edit("+value.seq+",'"+value.svr_nm+"','"+value.svr_ip+"','"+value.svr_vip+"','"+value.svr_port+"'); return false;\" >"+value.svr_nm+"</a></td>";
					gbInnerHtml += "<td>"+value.svr_ip+"</td>";
					
		
					if(value.svr_nm =="VPNIP"){
						svrused = value.svr_used;
						gbInnerHtml += "<td>"+value.svr_vip+"</td>"
					
					}else {
						if(value.svr_vip == null || value.svr_vip == '' || value.svr_vip == 'undefined' || value.svr_vip == undefined){
							value.svr_vip ='';
						}else{
								viplist.push(value.svr_vip);
						}
							gbInnerHtml += "<td>"+value.svr_vip+"</td>";
					}
		
		
					if(value.svr_port != null ){
						if(value.svr_port !=''){
							gbInnerHtml += "<td>"+value.svr_port+"</td>";
						}else{
							gbInnerHtml += "<td>"+ "-" +"</td>";
						}
					}else{
						gbInnerHtml += "<td>"+ "-" +"</td>";
					}
		
					gbInnerHtml += "</tr>";
				});	 
			}else{ 
				gbInnerHtml += "<tr><td colspan='6'>등록된 정보가 없습니다. </td></tr>";
			}
			
			startPage = data.pagingVo.startPage;
			endPage = data.pagingVo.endPage; 
			totalPageSize = data.pagingVo.totalPageSize;
			currentPage = data.pagingVo.currentPage;
			totalRecordSize = data.pagingVo.totalRecordSize;
			
			var viewName='classMngrList';
			if(totalRecordSize > 0){
				$(".page_num").html(getPaging(startPage,endPage,totalPageSize,currentPage,'\''+viewName+'\''));
			}
			$('#pageGrideInSvrlstListTb').append(gbInnerHtml);
		}
		
		
		function allChk(obj){
			var chkObj = document.getElementsByName("RowCheck");
			var rowCnt = chkObj.length - 1;
			var check = obj.checked;
			if (check) {
				for (var i=0; i<=rowCnt; i++){
				 if(chkObj[i].type == "checkbox")
					 chkObj[i].checked = true; 
				}
			} else {
				for (var i=0; i<=rowCnt; i++) {
				 if(chkObj[i].type == "checkbox"){
					 chkObj[i].checked = false; 
				 }
				}
			}
		} 
		
		</script>
		


</body>
</html>
