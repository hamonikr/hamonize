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
		setNav('PC정보 > PC접속관리');
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
	//등록버튼
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
//메뉴 Tree onClick
function onClick(event, treeId, treeNode, clickFlag) {
		$('#pageGrideInPcMngrListTb').empty();
		$('.page_num').empty();
	
		var zTree = $.fn.zTree.getZTreeObj("tree");
		var node = zTree.getNodeByParam('id', treeNode.pId);
		$("#org_seq").val(treeNode.id);
		$.post("pcBlockList.proc",{org_seq:treeNode.id,pcMngrListCurrentPage:$("#pcMngrListCurrentPage").val()},
				function(data){
			var gbInnerHtml = "";
			var classGroupList = data.list;
			console.log(data.list)
			if( data.list.length > 0 ){
				$.each(data.list, function(index, value) {
					var no = data.pagingVo.totalRecordSize -(index ) - ((data.pagingVo.currentPage-1)*10);

					gbInnerHtml += "<tr data-code='" + value.seq + "' data-status='" + value.status + "'>";
					gbInnerHtml += "<td><input type='checkbox' name='' id="+no+" class='form-control' value='"+value.status+"' onclick='getCheckboxValue(event)'><label for="+no+" class='dook'></label></td>";
					if(value.status == 'N')
						gbInnerHtml += "<td>비활성</td>";
					else
						gbInnerHtml += "<td>활성</td>";
					gbInnerHtml += "<td style='text-align:center;'>"+no+"</td>";
					gbInnerHtml += "<td>"+value.deptsido+"</td>";
					gbInnerHtml += "<td>"+value.deptname+"</td>";
					if(value.pc_os == "H"){
						 gbInnerHtml += "<td>개방</td>"; 
					 }else if(value.pc_os == "W"){
						 gbInnerHtml += "<td>상용</td>"; 
					 }else{
						 gbInnerHtml += "<td></td>"; 
					 }

					gbInnerHtml += "<td><a href='#' onclick=\"javascript:show_layer('"+value.pc_change+"'," +value.seq+")\">"+value.pc_hostname+"</a></td>";
					gbInnerHtml += "<td>"+value.pc_ip+"</td>";
					gbInnerHtml += "<td>"+value.pc_macaddress+"</td>"; 				
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
			console.log(startPage);
			console.log(endPage);
			console.log(totalPageSize);
			console.log(currentPage);
			console.log(totalRecordSize);
			
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
	var url ='/pcMngr/pcBlockList.proc';
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
	
	
	if( data.list.length > 0 ){
		$.each(data.list, function(index, value) {
			var no = data.pagingVo.totalRecordSize -(index ) - ((data.pagingVo.currentPage-1)*10);
			
			console.log(value.status);
			gbInnerHtml += "<tr data-code='" + value.seq + "' data-status='" + value.status + "'>";
			gbInnerHtml += "<td><input type='checkbox' name='chk' id="+no+" class='form-control' value='"+value.status+"'><label for="+no+" class='dook'></label></td>";
			
			if(value.status == 'N'){
				gbInnerHtml += "<td>비활성</td>";
				$("input[name=chk]").prop("checked");
				console.log("16979=="+$("#16979").val());
			}else
				gbInnerHtml += "<td>활성</td>";
				gbInnerHtml += "<td style='text-align:center;'>"+no+"</td>";
				gbInnerHtml += "<td>"+value.deptsido+"</td>";
				gbInnerHtml += "<td>"+value.deptname+"</td>";
		
				if(value.pc_os == "H"){
					gbInnerHtml += "<td>개방</td>"; 
				}else if(value.pc_os == "W"){
					gbInnerHtml += "<td>상용</td>"; 
				}else{
					gbInnerHtml += "<td></td>"; 
				}

			gbInnerHtml += "<td>"+value.pc_hostname+"</td>";
			gbInnerHtml += "<td>"+value.pc_ip+"</td>";
			gbInnerHtml += "<td>"+value.pc_macaddress+"</td>"; 
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
	console.log(startPage);
	console.log(endPage);
	console.log(totalPageSize);
	console.log(currentPage);
	console.log(totalRecordSize);
	
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


function updateBlockList(){
	var iptArrCheck = $('.form-control:checked');
	var iptArr = $('.form-control');
	var blockArr = [];
	var unBlockArr = [];
	// 검증
	$.each(iptArr, function(idx, ipt){
		console.log("checked==="+$(ipt).prop("checked"));
		if($(ipt).prop("checked")){
			blockArr.push($(ipt).parent().parent().attr('data-code'));
		}else{
			unBlockArr.push($(ipt).parent().parent().attr('data-code'));
		}
	});
	
	function ftn(data, status, xhr, groupId){
		alert("정상적으로 변경되었습니다.");
		location.reload();
	}
	
	// 전송
	var url = '/pcMngr/updateBlock.proc';
	var vData = "updateBlockList=" + blockArr+"&updateUnblockList=" + unBlockArr;
	callAjax('POST', url, vData, ftn, getError, 'json');
}

</script>

<body>
	<%@ include file="../template/topMenu.jsp" %>
	
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
	        <h2 class="tree_head">PC 접속관리</h2>
	
	        <ul class="view_action">
	            <li><input type="radio" name="1" id="expandAllBtn"><label for="expandAllBtn">전체열기</label> </li>
	            <li><input type="radio" name="1" id="collapseAllBtn"><label for="collapseAllBtn">전체닫기</label> </li>
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
             <label for="date_fr"></label><input type="text" name="date_fr" id="date_fr" class="input_type1" value="${today}"/>
                <a href="#divCalendar" class="btn_cal" onclick="openCalendar(document.getElementById('date_fr')); return false;"><img src="/images/datepicker-icon.png" style="width:37px; height:37px;" alt="달력버튼"/></a>
                 ~
                <label for="date_to"></label><input type="text" name="date_to" id="date_to" class="input_type1" />
                <a href="#divCalendar" class="btn_cal" onclick="openCalendar(document.getElementById('date_to')); return false;"><img src="/images/datepicker-icon.png" style="width:37px; height:37px;" alt="달력버튼"/></a>
                <div id="count"></div>
            </li>
            <li>
              <!-- 검색 -->
              <div class="top_search">
	            <select id="keyWord" name="keyWord" title="keyWord" class="sel_type1">
	                <option value="0">전체</option>
	                <option value="1">지역</option>
	                <option value="2">부서이름</option>
	                <option value="3">IP</option>
	                <option value="4">Mac Address</option>
	                <option value="5">PC관리번호</option>
	            </select>
	            <label for="txtSearch"></label><input type="text" name="txtSearch" id="txtSearch" class="input_type1" />
	            <button type="button" class="btn_type3" onclick="javascript:getPcMngrList();">  검색</button>
	        </div>
            </li>
          </ul>  

			<input type="hidden" id="pcListInfoCurrentPage" name="pcListInfoCurrentPage" value="1" >
			<input type="hidden" id="org_seq" name="org_seq" value="">
			<p>
				* 체크 후 저장 :  비활성 / 체크 해제 후 저장  : 활성
			</p>
			<!-- List -->
	        <div class="board_list mT20">
	            <table>
	                <colgroup>
	               	 <col style="width:5%;" />
	               	 <col style="width:5%;" />
	                   <col style="width:8%;" />
	                   <col style="width:10%;" />
	                   <col style="width:13%;" />
	                   <col style="width:10%;" />
	                   <col style="width:18%;" />
	                   <col style="width:18%;" />
	                   <col />
	                </colgroup>
	                <thead>
	                   <tr>
	                   	  <th>선택</th>
	                   	  <th>활성여부</th>
	                       <th>번호</th>
	                       <th>지역</th>
	                       <th>부서이름</th>
	                       <th>OS</th>
	                       <th>PC관리번호</th>
	                       <th>IP</th>
	                       <th>Mac Address</th>
	                   </tr>
	                </thead>
	                <tbody id="pageGrideInPcMngrListTb"></tbody>
	            </table>
	        </div>
	        <!-- //List -->
		        	 <div class="right mT20">
                    <button type="button" class="btn_type3 insertBtn" onclick="updateBlockList()">저장</button>
                </div>
	        <!-- page number -->
          <div class="page_num" id="page_num">
          </div>
		    </div>
		</div>
	</div>
	
	
	<%@ include file="../template/footer.jsp" %>
	
</body>

</html>
