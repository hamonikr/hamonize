<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>
<%@ include file="../template/left.jsp" %>

<script>


//메뉴 Tree onClick
function onClick(event, treeId, treeNode, clickFlag) {
	$('#pageGrideInPcMngrListTb').empty();
	$('.page_num').empty();

	var zTree = $.fn.zTree.getZTreeObj("tree");
	var node = zTree.getNodeByParam('id', treeNode.pId);
	
	
	$("#org_seq").val(treeNode.id);
	$.post("/pcMngr/pcMngrList.proc",{org_seq:treeNode.id,pcMngrListCurrentPage:$("#pcMngrListCurrentPage").val()},
		function(data){
			var gbInnerHtml = "";
			var classGroupList = data.list;
			vpn_used = data.svo.svr_used;
			console.log("svr_used"+vpn_used);

			if( data.list.length > 0 ){
				
				$.each(data.list, function(index, value) {
					var no = data.pagingVo.totalRecordSize -(index ) - ((data.pagingVo.currentPage-1)*10);
					

					gbInnerHtml += "<tr data-code='" + value.seq + "' data-guidcode='" + value.pc_guid + "'>";
					gbInnerHtml += "<td style='text-align:center;'>"+no+"</td>";
					gbInnerHtml += "<td>"+value.deptname+"</td>";
				
					if(value.pc_os == "H"){
						gbInnerHtml += "<td>"+hamonikrIcon+"</td>"; 
					}else if(value.pc_os == "W"){
						gbInnerHtml += "<td>"+windowIcon+"</td>"; 
					}else if(value.pc_os == "G"){
						gbInnerHtml += "<td>"+gooroomIcon+"</td>"; 
					}else if(value.pc_os == "D"){
						gbInnerHtml += "<td>"+debianIcon+"</td>"; 
					}else if(value.pc_os == "L"){
						gbInnerHtml += "<td>"+linuxmintIcon+"</td>"; 
					}else if(value.pc_os == "U"){
						gbInnerHtml += "<td>"+ubuntuIcon+"</td>"; 
					}else{
						gbInnerHtml += "<td>"+hamonikrIcon+"</td>"; 
					}
					value.pc_macaddress = value.pc_macaddress.replaceAll("\""," ");
					value.pc_macaddress	= value.pc_macaddress.toString();
					if(vpn_used ==1 ){
						gbInnerHtml += "<td><a href=\"#\" onclick=\"detail_popup('"+no+"','"+value.deptname+"','"+value.pc_os+"','"+value.pc_hostname+"','"+value.pc_ip+"','"+value.pc_vpnip+"','"+value.pc_macaddress+"','"+value.pc_disk+"','"+value.pc_cpu+"','"+value.pc_memory+"','"+value.rgstr_date.substr(0,value.rgstr_date.length-7)+"','"+value.seq+"','"+value.org_seq+"')\">"+value.pc_hostname+"</a></td>";
					}else{
						
						gbInnerHtml += "<td><a href=\"#\" onclick=\"detail_popup_novpn('"+no+"','"+value.deptname+"','"+value.pc_os+"','"+value.pc_hostname+"','"+value.pc_ip+"','"+value.pc_macaddress+"','"+value.pc_disk+"','"+value.pc_cpu+"','"+value.pc_memory+"','"+value.rgstr_date.substr(0,value.rgstr_date.length-7)+"','"+value.seq+"','"+value.org_seq+"')\">"+value.pc_hostname+"</a></td>";
					}

					gbInnerHtml += "<td>"+value.rgstr_date.substr(0,value.rgstr_date.length-7)+"</td>";
					gbInnerHtml += "</tr>";

				});	
			}else{  
				gbInnerHtml += "<tr><td colspan='11' style='text-align:center;'>등록된 데이터가 없습니다. </td></tr>";
			}
		
		startPage = data.pagingVo.startPage;
		endPage = data.pagingVo.endPage; 
		totalPageSize = data.pagingVo.totalPageSize;
		currentPage = data.pagingVo.currentPage;
		totalRecordSize = data.pagingVo.totalRecordSize;
		$('#count').html("검색결과: "+totalRecordSize+"대");
		// $('#count').html("검색결과: "+numberWithCommas(totalRecordSize)+"대");
		
		var viewName='classMngrList';
		if(totalRecordSize > 0){
			$("#page_num").html(getPaging(startPage,endPage,totalPageSize,currentPage,'\''+viewName+'\''));
		}else{
			$("#page_num").empty();
		}
		$('#pageGrideInPcMngrListTb').append(gbInnerHtml);
	});
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
function searchView(viewName, page){
	switch(viewName){
		case 'classMngrList' : $("#pcListInfoCurrentPage").val(page); getPcMngrList(); break;
	default :
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
							PC 목록
							<i class="fa fa-info-sign text-muted" data-toggle="tooltip" data-placement="bottom"
								data-title="ajax to load the data." data-original-title="" title=""></i>
						</header>
						<div class="table-responsive">
							<div id="DataTables_Table_0_wrapper" class="dataTables_wrapper" role="grid">
								<div class="row">
								
									<div class="col-sm-12"> 
										<form class="form-inline" role="form" style="float:right;">
											<select id="keyWord" name="keyWord" title="keyWord" class="form-control" >
												<option value="0">전체</option>
												<option value="2">부서이름</option>
												<option value="3">IP</option>
												<option value="4">Mac Address</option>
												<option value="5">PC 호스트 이름</option>
											</select>
											<div class="form-group">
												<label for="txtSearch"></label><input type="text" name="txtSearch" id="txtSearch" class="form-control" />
											<button type="button" class="fom-control" onclick="javascript:getPcMngrList();">  검색</button>
											</div>
										  </form>
										
											
											
											<input type="hidden" id="pcListInfoCurrentPage" name="pcListInfoCurrentPage" value="1" >
											<input type="hidden" id="org_seq" name="org_seq" value="">
									</div>
									
								</div>
								<table class="table table-striped m-b-none " id="DataTables_Table_0" aria-describedby="DataTables_Table_0_info">
									<thead>
										<tr role="row">
											<th width="20%">번호</th>
											<th width="25%" >부서이름</th>
											<th width="25%">OS</th>
											<th width="15%" >PC 호스트명</th>
											<th width="15%" >등록일</th>
										</tr>
									</thead>
									<tbody id="pageGrideInPcMngrListTb"></tbody>
								</table>
								<!-- page number -->
								<div class="page_num" id="page_num">          </div>
							</div>
						</div>
					</section>
				</section>
			</section>
		</aside>


	</section>
</section>

<script>


$(document).ready(function(){
		$("#txtSearch").keydown(function(key) {
			if (key.keyCode == 13) {
				key.preventDefault();
				getPcMngrList();
			}
		});
	//트리 init
	// $.fn.zTree.init($("#tree"), setting, zNodes); 
	
	// $("#expandAllBtn").bind("click", {type:"expandAll"}, expandNode);
	// $("#collapseAllBtn").bind("click", {type:"collapseAll"}, expandNode);
		
	getPcMngrList();
	
	$("#excelBtn").on("click",function(){
		location.href="pcMngrListExcel?org_seq="+$("#org_seq").val()+"&date_fr="+$("#date_fr").val()+"&date_to="+$("#date_to").val()+"&txtSearch="+$("#txtSearch").val()+"&keyWord="+$("#keyWord").val();
	});
	
	
	
});

function getPcMngrList(){
	var url ='/pcMngr/pcMngrList.proc';
	var pc_change = '${pc_change}';
	var keyWord = $("select[name=keyWord]").val();
	console.log(url +"=="+ pc_change +"=="+ keyWord);
	var vData = 'pcListInfoCurrentPage=' + $("#pcListInfoCurrentPage").val() +"&keyWord="+ keyWord + "&txtSearch=" + $("#txtSearch").val()+ "&org_seq=" + $("#org_seq").val()+ "&pc_change="+pc_change; 
	callAjax('POST', url, vData, userpcMngrGetSuccess, getError, 'json');

}
var userpcMngrGetSuccess = function(data, status, xhr, groupId){
	var gbInnerHtml = "";
	var classGroupList = data.list;
	$('#pageGrideInPcMngrListTb').empty();
	$('.page_num').empty();
	
	vpn_used = data.svo.svr_used;	
	console.log("svr_used : "+ vpn_used);

	if( data.list.length > 0 ){

		$.each(data.list, function(index, value) {
		
			var no = data.pagingVo.totalRecordSize -(index ) - ((data.pagingVo.currentPage-1)*10);
			
			gbInnerHtml += "<tr data-code='" + value.seq + "' data-guidcode='" + value.pc_guid + "'>";
			gbInnerHtml += "<td style='text-align:center;'>"+no+"</td>";
			gbInnerHtml += "<td>"+value.deptname+"</td>";
			
			if(value.pc_os == "H"){
				gbInnerHtml += "<td>"+hamonikrIcon+"</td>"; 
			}else if(value.pc_os == "W"){
				gbInnerHtml += "<td>"+windowIcon+"</td>"; 
			}else if(value.pc_os == "G"){
				gbInnerHtml += "<td>"+gooroomIcon+"</td>"; 
			}else if(value.pc_os == "D"){
				gbInnerHtml += "<td>"+debianIcon+"</td>"; 
			}else if(value.pc_os == "L"){
				gbInnerHtml += "<td>"+linuxmintIcon+"</td>"; 
			}else if(value.pc_os == "U"){
				gbInnerHtml += "<td>"+ubuntuIcon+"</td>"; 
			}else{
				gbInnerHtml += "<td>"+hamonikrIcon+"</td>"; 
			}
			
			value.pc_macaddress = value.pc_macaddress.replaceAll("\""," ");
			
			if(vpn_used ==1 ){
					gbInnerHtml += "<td><a href=\"#\" onclick=\"detail_popup('"+no+"','"+value.deptname+"','"+value.pc_os+"','"+value.pc_hostname+"','"+value.pc_ip+"','"+value.pc_vpnip+"','"+value.pc_macaddress+"','"+value.pc_disk+"','"+value.pc_cpu+"','"+value.pc_memory+"','"+value.rgstr_date.substr(0,value.rgstr_date.length-7)+"','"+value.seq+"','"+value.org_seq+"')\">"+value.pc_hostname+"</a></td>";
			}else{
				gbInnerHtml += "<td><a href=\"#\" onclick=\"detail_popup_novpn('"+no+"','"+value.deptname+"','"+value.pc_os+"','"+value.pc_hostname+"','"+value.pc_ip+"','"+value.pc_macaddress+"','"+value.pc_disk+"','"+value.pc_cpu+"','"+value.pc_memory+"','"+value.rgstr_date.substr(0,value.rgstr_date.length-7)+"','"+value.seq+"','"+value.org_seq+"')\">"+value.pc_hostname+"</a></td>";
			}
			
			gbInnerHtml += "<td>"+value.rgstr_date.substr(0,value.rgstr_date.length-7)+"</td>";
			gbInnerHtml += "</tr>";
		
		});	
	}else{  
		gbInnerHtml += "<tr><td colspan='11' style='text-align:center;'>등록된 데이터가 없습니다. </td></tr>";
	}
	
	startPage = data.pagingVo.startPage;
	endPage = data.pagingVo.endPage; 
	totalPageSize = data.pagingVo.totalPageSize;
	currentPage = data.pagingVo.currentPage;
	totalRecordSize = data.pagingVo.totalRecordSize;
	$('#count').html("검색결과: "+totalRecordSize+"대");
	// $('#count').html("검색결과: "+numberWithCommas(totalRecordSize)+"대");
	
	var viewName='classMngrList';
	if(totalRecordSize > 0){
		$("#page_num").html(getPaging(startPage,endPage,totalPageSize,currentPage,'\''+viewName+'\''));
	}
	$('#pageGrideInPcMngrListTb').append(gbInnerHtml);
	
}

</script>

<%@ include file="../template/footer.jsp" %>