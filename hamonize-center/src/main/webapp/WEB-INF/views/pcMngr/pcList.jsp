<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>

<style>

/* 레이어 달력 */
#divCalendar {position:absolute; width:180px; padding:8px 10px; border:2px solid #999; font-size:11px; background-color:#fff; z-index:999;}
#divCalendar * {margin:0; padding:0; font-size:11px !important;}
#divCalendar caption {height:0; font-size:0; line-height:0; overflow:hidden;}
#divCalendar table {table-layout:auto; width:100%; text-align:center; border:0px solid #000; color:#000;}
#divCalendar table, #divCalendar table a {font-size:13px; line-height:20px;}
#divCalendar #tableCalendarTitle td, #divCalendar #tableCalendarTitle td a, #divCalendar #tableMonthTitle td a, #tableYearTitle td {font-weight:600; font-size:13px !important;}
#divCalendar #tableYear a {font-size:12px !important;}
#divCalendar table th {border:0px solid #f8720f; height:auto; background:none; padding:0 !important; margin:0; color:#595959; text-align:center; line-height:20px;}
#divCalendar table td {padding:0 !important; margin:0; height:auto; text-align:center; border:0px solid #000; line-height:1;}
#divCalendar table td a {display:block; color:#595959; text-decoration:none;}
#divCalendar table td a.today {color:#fff !important; background-color:#437dca; font-weight:600; border:1px solid #2059a5; border-radius:2px;}
#divCalendar #tableCalendar th:first-child, #divCalendar #tableCalendar td:first-child a {color:#cf2121;}
#divCalendar #tableCalendar th:last-child, #divCalendar #tableCalendar td:last-child a {color:#0072cf;}
#divCalendar .btn_cal_close {position:absolute; top:-2px; right:-19px; text-align:right;}
#divCalendar .btn_cal_close a {display:block; background:url(/images/ico_delete.gif) no-repeat; text-indent:100%; white-space:nowrap; overflow:hidden;}
#divCalendar .btn_cal_close, #divCalendar .btn_cal_close a {width:17px; height:16px;}
</style>


<link rel="stylesheet" type="text/css" href="/css/ztree/zTreeStyle.css" />
<script type="text/javascript" src="/js/ztree/jquery.ztree.core.js"></script>
<script type="text/javascript" src="/js/ztree/jquery.ztree.exedit.js"></script>
<script type="text/javascript" src="/js/ztree/jquery.ztree.excheck.js"></script>

<style>
a{
color: white;
}
a:hover{
color: #0056b3;
text-decoration: none; 
}
#layer_area{
 width: 1200px;
 height: 700px;
 background-color: #fff;
 display:none;
 z-index: 1;
 position: fixed;
left: 50%;
top: 50%;

-webkit-transform: translate(-50%, -50%);
-ms-transform: translate(-50%, -50%);
-moz-transform: translate(-50%, -50%);
-o-transform: translate(-50%, -50%);
transform: translate(-50%, -50%);


.close {
		position:absolute;
		right:5px;
		top:5px;
		padding:5px;
		display:inline-block;
		cursor:pointer;
		}
 }
</style>
<script type="text/javascript">
	var setting = {
			view: {
				selectedMulti: false
			},
			data: {
				simpleData: {
					enable: true
				}
			},
			edit: {
				enable: true,
				showRemoveBtn: false,
				showRenameBtn: false
			},
			callback: {
				beforeClick: beforeClick,
				onClick: onClick
			}
		};
	var zNodes =[
		<c:forEach items="${oList}" var="data" varStatus="status" >
		{ id:"${data.seq}", pId:"${data.p_seq}",
			<c:if test="${data.section ne 'S'}">
			name:"${data.org_nm}",
			icon:"/images/icon_tree1.png"
				</c:if>
			<c:if test="${data.section eq 'S'}">
			name:"${data.org_nm}",
			icon:"/images/icon_tree2.png"
			</c:if>
			,od:"${data.org_ordr}"
			<c:if test="${data.level eq '0' or data.level eq '1' or data.level eq '2'}">
			,open:true
			</c:if>},
		</c:forEach>				
	];
	
	$(document).ready(function(){
		setNav('PC정보 > PC정보');
		$("#txtSearch").keydown(function(key) {
			if (key.keyCode == 13) {
				key.preventDefault();
				getPcMngrList();
			}
		});
	//트리 init
	$.fn.zTree.init($("#tree"), setting, zNodes); 
	
	$("#expandAllBtn").bind("click", {type:"expandAll"}, expandNode);
	$("#collapseAllBtn").bind("click", {type:"collapseAll"}, expandNode);
		
	getPcMngrList();
	
	$("#excelBtn").on("click",function(){
		location.href="pcMngrListExcel?org_seq="+$("#org_seq").val()+"&date_fr="+$("#date_fr").val()+"&date_to="+$("#date_to").val()+"&txtSearch="+$("#txtSearch").val()+"&keyWord="+$("#keyWord").val();
	});
	
	
	
});

 
 var log, className = "dark", curDragNodes, autoExpandNode;
	function setTrigger() {
		var zTree = $.fn.zTree.getZTreeObj("tree");
		zTree.setting.edit.drag.autoExpandTrigger = $("#callbackTrigger").attr("checked");
	}
	function beforeClick(treeId, treeNode, clickFlag) {
		className = (className === "dark" ? "":"dark");
		return (treeNode.click != false);
	}

//메뉴펼침, 닫힘
function expandNode(e) {
	var zTree = $.fn.zTree.getZTreeObj("tree"),
	type = e.data.type,
	nodes = zTree.getSelectedNodes();
	if (type == "expandAll") {
		zTree.expandAll(true);
	} else if (type == "collapseAll") {
		zTree.expandAll(false);
	} 
}


//OS 아이콘
var windowIcon = "<img src='/images/icon_w.png' style='width:22px; height:22px;'>";
var hamonikrIcon = "<img src='/images/icon_h.png' style='width:22px; height:22px;'>";
var gooroomIcon = "<img src='/images/icon_g.png' style='width:22px; height:22px;'>";
var linuxmintIcon = "<img src='/images/icon_lm.png' style='width:22px; height:22px;'>";
var debianIcon = "<img src='/images/icon_d.png' style='width:22px; height:22px;'>";
var ubuntuIcon = "<img src='/images/icon_u.png' style='width:22px; height:22px;'>";

var vpn_used;

//메뉴 Tree onClick
function onClick(event, treeId, treeNode, clickFlag) {
		$('#pageGrideInPcMngrListTb').empty();
		$('.page_num').empty();
	
		var zTree = $.fn.zTree.getZTreeObj("tree");
		var node = zTree.getNodeByParam('id', treeNode.pId);
		
		
		$("#org_seq").val(treeNode.id);
		$.post("pcMngrList.proc",{org_seq:treeNode.id,pcMngrListCurrentPage:$("#pcMngrListCurrentPage").val()},
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
							gbInnerHtml += "<td><a href=\"#\" onclick=\"detail_popup('"+no+"','"+value.deptname+"','"+value.pc_os+"','"+value.pc_hostname+"','"+value.pc_ip+"','"+value.pc_vpnip+"','"+value.pc_macaddress+"','"+value.pc_disk+"','"+value.pc_cpu+"','"+value.pc_memory+"','"+value.first_date.substr(0,value.first_date.length-7)+"','"+value.seq+"','"+value.org_seq+"')\">"+value.pc_hostname+"</a></td>";
						}else{
							
							gbInnerHtml += "<td><a href=\"#\" onclick=\"detail_popup_novpn('"+no+"','"+value.deptname+"','"+value.pc_os+"','"+value.pc_hostname+"','"+value.pc_ip+"','"+value.pc_macaddress+"','"+value.pc_disk+"','"+value.pc_cpu+"','"+value.pc_memory+"','"+value.first_date.substr(0,value.first_date.length-7)+"','"+value.seq+"','"+value.org_seq+"')\">"+value.pc_hostname+"</a></td>";
						}

						gbInnerHtml += "<td>"+value.first_date.substr(0,value.first_date.length-7)+"</td>";
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
			$('#count').html("검색결과: "+numberWithCommas(totalRecordSize)+"대");
			
			var viewName='classMngrList';
			if(totalRecordSize > 0){
				$("#page_num").html(getPaging(startPage,endPage,totalPageSize,currentPage,'\''+viewName+'\''));
			}else{
				$("#page_num").empty();
			}
			$('#pageGrideInPcMngrListTb').append(gbInnerHtml);
			
		});
			
	}

function getPcMngrList(){
	var url ='/pcMngr/pcMngrList.proc';
	var pc_change = '${pc_change}';
	var keyWord = $("select[name=keyWord]").val();
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
					gbInnerHtml += "<td><a href=\"#\" onclick=\"detail_popup('"+no+"','"+value.deptname+"','"+value.pc_os+"','"+value.pc_hostname+"','"+value.pc_ip+"','"+value.pc_vpnip+"','"+value.pc_macaddress+"','"+value.pc_disk+"','"+value.pc_cpu+"','"+value.pc_memory+"','"+value.first_date.substr(0,value.first_date.length-7)+"','"+value.seq+"','"+value.org_seq+"')\">"+value.pc_hostname+"</a></td>";
			}else{
				gbInnerHtml += "<td><a href=\"#\" onclick=\"detail_popup_novpn('"+no+"','"+value.deptname+"','"+value.pc_os+"','"+value.pc_hostname+"','"+value.pc_ip+"','"+value.pc_macaddress+"','"+value.pc_disk+"','"+value.pc_cpu+"','"+value.pc_memory+"','"+value.first_date.substr(0,value.first_date.length-7)+"','"+value.seq+"','"+value.org_seq+"')\">"+value.pc_hostname+"</a></td>";
			}
			
			gbInnerHtml += "<td>"+value.first_date.substr(0,value.first_date.length-7)+"</td>";
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
	$('#count').html("검색결과: "+numberWithCommas(totalRecordSize)+"대");
	
	var viewName='classMngrList';
	if(totalRecordSize > 0){
		$("#page_num").html(getPaging(startPage,endPage,totalPageSize,currentPage,'\''+viewName+'\''));
	}
	$('#pageGrideInPcMngrListTb').append(gbInnerHtml);
	
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
		case 'classMngrList' : $("#pcListInfoCurrentPage").val(page);getPcMngrList(); break;
	default :
	}
}
//]]>
</script>

<body>
	<%@ include file="../template/topMenu.jsp" %>
	<%@ include file="../template/topNav.jsp" %>
	<jsp:useBean id="now" class="java.util.Date" />
	<fmt:formatDate value="${now}" pattern="yyyy/MM/dd" var="today" />
	<div class="hamo_container other">
		
		 <!-- 좌측 트리 -->
		<div class="con_left">
	    <div class="left_box">
	        <ul class="location">
	            <li>Home</li>
	            <li>Location</li>
	        </ul>
	        <h2 class="tree_head">PC 정보</h2>
	
	        <ul class="view_action">
                    <li id="expandAllBtn">전체열기 </li>
                    <li id="collapseAllBtn">전체닫기</li>
			</ul>

		<!-- 트리 리스트 -->
        <div class="tree_list">
						<ul id="tree" class="ztree"></ul>
        </div>
	    </div>
		</div>
		
		<!-- 우측 리스트 -->
		<div class="con_right">
        <div class="right_box">
        
        <ul class="search_area">
          <li>
           <!-- 검색 -->
	        <div class="top_search">
	            <select id="keyWord" name="keyWord" title="keyWord" class="sel_type1">
	                <option value="0">전체</option>
	                <option value="2">부서이름</option>
	                <option value="3">IP</option>
	                <option value="4">Mac Address</option>
	                <option value="5">PC 호스트 이름</option>
	            </select>
	            <label for="txtSearch"></label><input type="text" name="txtSearch" id="txtSearch" class="input_type1" />
	            <button type="button" class="btn_type3" onclick="javascript:getPcMngrList();">  검색</button>
	        </div>
			<!-- //검색 -->
          </li>
        </ul>    
			
            <input type="hidden" id="pcListInfoCurrentPage" name="pcListInfoCurrentPage" value="1" >
            <input type="hidden" id="org_seq" name="org_seq" value="">
            <div style="margin-top:10px;">
            <div id="pwd" style="float:left; width:70%;font-size: 15px;"></div>
            <div id="count" style="float:left; width:30%;font-size: 15px;"></div>
            </div>
					<!-- List -->
	        <div class="board_list mT20">
	            <table>
	                <colgroup>
	                   <col style="width:10%;" />
	                   <col style="width:10%;" />
	                   <col style="width:10%;" />
	                   <col style="width:15%;" />
	                   <col style="width:15%;" />
	                   <col />
	                </colgroup>
	                <thead>
	                   <tr>
	                       <th>번호</th>
	                       <th>부서이름</th>
	                       <th>OS</th>
	                       <th>PC 호스트 이름</th>
	                       <th>설치일</th>
	                   </tr>
	                </thead>
	                <tbody id="pageGrideInPcMngrListTb"></tbody>
	            </table>
	        </div>
	        <!-- //List -->
		        	
	        <!-- page number -->
          <div class="page_num" id="page_num">
          </div>
		    </div>
		</div>
	</div>

	<!-- 레이어 팝업 -->
	<div id="popup" class="popa" style="display:none">
		<h3>PC 상세정보</h3>
		<div class="board_view mT20">
			<table>
				<colgroup>
					<col style="width:15%"/>
					<col style="width:35%"/>
					<col style="width:15%"/>
					<col style="width:35%"/>
				</colgroup>
				<tbody>
					<tr>
						<th>번호</th>
						<td colspan="3"><span id="detail_no"></span></td>
					</tr>

					<tr>
						<th>부서이름</th>
						<td colspan="3"><span id="detail_name"></span>
							&nbsp;&nbsp;&nbsp;&nbsp;<button -type="button" onclick="open_move(); return false;">부서이동</button>
							&nbsp;&nbsp;&nbsp;&nbsp;<select name="team" id="team" style="width: 200px; display:none;">
							</select>
							<button type="button" name="moveteam" id="moveteam" onclick="move_team(); return false;" style="width: 100px; display:none;">확인</button>
							<input type="hidden" id="seq" />
							<input type="hidden" id="old_org_seq" />
						</td>
					</tr>
					<tr>
						<th>OS</th>
						<td colspan="3"><span id="detail_pc_os"></span></td>
					</tr>
					<tr>
						<th>PC 호스트 이름</th>
						<td colspan="3"><span id="detail_hostname"></span></td>
					</tr>
					<tr>
						<th>IP</th>
						<td colspan="3"><span id="detail_pc_ip"></span></td>
					</tr>
					<tr id="detail_vpnip"></tr>
					<tr>
						<th>Mac Address</th>
						<td colspan="3"><span id="detail_macaddress"></span></td>
					</tr>
					<tr>
						<th>HDD</th>
						<td colspan="3"><span id="detail_pc_disk"></span></td>
					</tr>
					<tr>
						<th>CPU</th>
						<td colspan="3"><span id="detail_cpu"></span></td>
					</tr>
					<tr>
						<th>Memory</th>
						<td colspan="3"><span id="detail_memory"></span></td>
					</tr>
					<tr>
						<th>설치일</th>
						<td colspan="3"><span id="detail_first_date"></span></td>
					</tr>
				</tbody>
			</table>
			<div style="text-align: center;">
				<button type="button" class="btn_type1" onclick="delete_pc(); return false;">삭제</button>
			</div>
		</div>
		<a href="#" onclick="hide_layer();" class="pop_close">닫기</a>
	</div>
	<div id="bg_fix" style="display:none;"></div>
	
	<!-- 레이어 팝업용 자바스크립트 -->
	<script type="text/javascript">
		function detail_popup(no,name,pc_os,hostname,pc_ip,pc_vpnip,macaddress,pc_disk,cpu,memory,first_date,seq,old_org_seq) {
			console.log("detail_popup >> ");
		
			if(pc_os == "H"){
				pc_os = hamonikrIcon; 
			}else if(pc_os == "W"){
				pc_os = windowIcon; 
			}else if(pc_os == "L"){
				pc_os = linuxmintIcon; 
			}else if(pc_os == "D"){
				pc_os = debianIcon; 
			}else if(pc_os == "U"){
				pc_os = ubuntuIcon; 
			}else if(pc_os == "G"){
				pc_os = gooroomIcon; 
			}else{
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
			$("#detail_first_date").html(first_date);
			$("#seq").val(seq);
			$("#old_org_seq").val(old_org_seq);
			
			console.log("vpn_used >> "+vpn_used);
			if(vpn_used != 0 && pc_vpnip != "no vpn"){
				innerHtml += "<th>VPN IP</th>";
				innerHtml += "<td colspan='3'><span id='vpnip_val'></span></td>";
				$('#detail_vpnip').append(innerHtml);
				$("#vpnip_val").text(pc_vpnip);
			}
			
			$('#popup').show();
			$("#bg_fix").show();
		};
		
		function detail_popup_novpn(no,name,pc_os,hostname,pc_ip,macaddress,pc_disk,cpu,memory,first_date,seq,old_org_seq) {
			console.log("detail_popup_novpn >> ");
			
			if(pc_os == "H"){
				pc_os = hamonikrIcon; 
			}else if(pc_os == "W"){
				pc_os = windowIcon; 
			}else if(pc_os == "L"){
				pc_os = linuxmintIcon; 
			}else if(pc_os == "D"){
				pc_os = debianIcon; 
			}else if(pc_os == "U"){
				pc_os = ubuntuIcon; 
			}else if(pc_os == "G"){
				pc_os = gooroomIcon; 
			}else{
			 	pc_os = ""; 
			}
			
			var innerHtml = "";
			$("#detail_no").html(no);
			$("#detail_pc_os").html(pc_os);
			$("#detail_hostname").html(hostname);
			$("#detail_name").html(name);
			$("#detail_pc_ip").html(pc_ip);
			$("#detail_macaddress").html(macaddress.toString());
			$("#detail_pc_disk").html(pc_disk);
			$("#detail_cpu").html(cpu);
			$("#detail_memory").html(memory);
			$("#detail_first_date").html(first_date);
			$("#seq").val(seq);
			$("#old_org_seq").val(old_org_seq);
			
			
			$('#popup').show();
			$("#bg_fix").show();
		};
		
		function hide_layer() {
			$('#popup').hide();
			$("#bg_fix").hide();
			$("#detail_vpnip").empty();
		};

		function open_move() {
			if($('#team').css("display") == "none"){
				$.ajax({
					url: '/pcMngr/teamList',
					type: 'post',
					success: function(data){
						for(var x = 0; x < data.length; x++){
							var option = document.createElement("option");
							option.innerText = data[x].org_nm;
							option.value = data[x].seq;
							$('#team').append(option);
						}
					},
					error: function (request, status, error){
						alert("error!!");
						
					}
				});
				$('#team').show();
				$('#moveteam').show();
			}else{
				$('#team').html("");
				$('#team').hide();
				$('#moveteam').hide();
		}
		}


		function move_team() {
			if(confirm("부서를 이동할 경우 기존 부서에서 내린 정책이 포함된 \n일반 백업본은 모두 삭제됩니다. \n부서를 이동하시겠습니까?")){
				$.ajax({
					url: '/pcMngr/moveTeam',
					type: 'post',
					data:{seq:$('#seq').val(),org_seq:$('#team option:selected').val(),old_org_seq:$('#old_org_seq').val(),pc_hostname:$("#detail_hostname").text()},
					success: function(data){
						if(data == 1){
							alert("완료되었습니다.");
							location.reload();
						}
					},
					error: function (request, status, error){
						alert("실패하였습니다.");
						
					}
				});
		
			}
		
		}

		function delete_pc(){
			if(confirm("해당 PC를 삭제하시겠습니까?")){
					$.ajax({
					url: '/pcMngr/deletePc',
					type: 'post',
					data:{seq:$('#seq').val(),old_org_seq:$('#old_org_seq').val(),pc_hostname:$("#detail_hostname").text()},
					success: function(data){
						if(data == 1){
							alert("완료되었습니다.");
							location.reload();
						}
					},
					error: function (request, status, error){
						alert("실패하였습니다.");
						
					}
				});

			}
		}
	</script>
	<%@ include file="../template/footer.jsp" %>
	
	
</body>
</html>
