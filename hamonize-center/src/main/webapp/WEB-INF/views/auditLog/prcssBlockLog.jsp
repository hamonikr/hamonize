<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>
<link rel="stylesheet" type="text/css" href="/css/ztree/zTreeStyle.css" />
<script type="text/javascript" src="/js/ztree/jquery.ztree.core.js"></script>
<script type="text/javascript" src="/js/ztree/jquery.ztree.exedit.js"></script>
<script type="text/javascript" src="/js/ztree/jquery.ztree.excheck.js"></script>
<script type="text/javascript" src="/js/common.js"></script>

<style>
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
<script type="text/javascript">
//zTree 셋팅
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
				drag: {
				}, 
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
			name:"[B]"+"${data.org_nm}",
			icon:"/images/icon_tree2.png"
			</c:if>
			,od:"${data.org_ordr}"
			<c:if test="${data.level eq '0' or data.level eq '1' or data.level eq '2'}">
			,open:true
			</c:if>},
		</c:forEach>				
	];
	
	$(document).ready(function(){
		setNav('로그감사 > 프로세스차단로그');
	//트리 init
	$.fn.zTree.init($("#tree"), setting, zNodes); 
	
	$("#expandAllBtn").bind("click", {type:"expandAll"}, expandNode);
	$("#collapseAllBtn").bind("click", {type:"collapseAll"}, expandNode);
		
	getList();
	//등록버튼
	$("#excelBtn").on("click",function(){
		location.href="prcssBlockLogExcel?org_seq="+$("#org_seq").val()+"&date_fr="+$("#date_fr").val()+"&date_to="+$("#date_to").val()+"&txtSearch="+$("#txtSearch").val()+"&keyWord="+$("#keyWord").val();
	});
	$("#txtSearch").keydown(function(key) {
		if (key.keyCode == 13) {
			key.preventDefault();
			getList();
		}
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
		$(".page_num").empty();
		$('#pageGrideInListTb').empty();
		$("#pagginationInList").empty();
		$("#txtSearch").val("");
		$("#keyWord").val("0");
		$("#currentPage").val(1);
		if($("#date_fr").val()==""){
			$("#date_fr").val(getMonthAgoday());
			$("#date_to").val(getToday());
		}
		var zTree = $.fn.zTree.getZTreeObj("tree");
		var node = zTree.getNodeByParam('id', treeNode.pId);
		$("#org_seq").val(treeNode.id);
		$.post("prcssBlockLogList.proc",{org_seq:treeNode.id,currentPage:$("#currentPage").val(),date_fr:$("#date_fr").val(),date_to:$("#date_to").val()},
				function(data){
			var gbInnerHtml = "";
			
			if( data.list.length > 0){
				
				$.each(data.list, function(index, value) {
					var no = data.pagingVo.totalRecordSize -(index ) - ((data.pagingVo.currentPage-1)*10);

					gbInnerHtml += "<tr data-code='' data-guidcode=''>";
					gbInnerHtml += "<td style='text-align:center;'>"+no+"</td>";
					gbInnerHtml += "<td>"+value.org_nm+"</td>";
					gbInnerHtml += "<td>"+value.prcssname+"</td>";
					gbInnerHtml += "<td>"+value.hostname+"</td>"; 
					gbInnerHtml += "<td>"+value.ipaddress+"</td>"; 
					gbInnerHtml += "<td>"+value.insert_dt+"</td>"; 
					gbInnerHtml += "</tr>";
				
				});	
			}else{  
				gbInnerHtml += "<tr><td colspan='7' style='text-align:center;'>등록된 데이터가 없습니다. </td></tr>";
			}
			var startPage = data.pagingVo.startPage;
			var endPage = data.pagingVo.endPage; 
			var totalPageSize = data.pagingVo.totalPageSize;
			var currentPage = data.pagingVo.currentPage;
			var totalRecordSize = data.pagingVo.totalRecordSize;
			$('#count').html("검색결과: "+numberWithCommas(totalRecordSize)+"건");
			var viewName='classMngrList';
			if(totalRecordSize > 0){
				$(".page_num").html(getPaging(startPage,endPage,totalPageSize,currentPage,'\''+viewName+'\''));
			}else{
				$("#pagginationInList").empty();
			}
			$('#pageGrideInListTb').append(gbInnerHtml);
			
		});
		
			
	}
function getList(){
	var url ='/auditLog/prcssBlockLogList.proc';
	if($("#date_fr").val()==""){
		$("#date_fr").val(getMonthAgoday());
		$("#date_to").val(getToday());
	}
	var keyWord = $("select[name=keyWord]").val();
	var vData = 'currentPage=' + $("#currentPage").val() +"&keyWord="+ keyWord + "&txtSearch=" + $("#txtSearch").val()+ "&org_seq=" + $("#org_seq").val() +"&date_fr="+$("#date_fr").val()+"&date_to="+$("#date_to").val(); 
	callAjax('POST', url, vData, iNetLogGetSuccess, getError, 'json');
}
var iNetLogGetSuccess = function(data, status, xhr, groupId){
	var gbInnerHtml = "";
	$('#pageGrideInListTb').empty();
	$("#pagginationInList").empty();
	$(".page_num").empty();

	if( data.list.length > 0 ){
		$.each(data.list, function(index, value) {
			var no = data.pagingVo.totalRecordSize -(index ) - ((data.pagingVo.currentPage-1)*10);

			gbInnerHtml += "<tr data-code='' data-guidcode=''>";
			gbInnerHtml += "<td style='text-align:center;'>"+no+"</td>";
			gbInnerHtml += "<td>"+value.org_nm+"</td>";
			gbInnerHtml += "<td>"+value.prcssname+"</td>";
			gbInnerHtml += "<td>"+value.hostname+"</td>"; 
			gbInnerHtml += "<td>"+value.ipaddress+"</td>"; 
			gbInnerHtml += "<td>"+value.insert_dt+"</td>"; 
			gbInnerHtml += "</tr>";
		
		});	
	}else{  
		gbInnerHtml += "<tr><td colspan='7' style='text-align:center;'>등록된 데이터가 없습니다. </td></tr>";
	}
	
	var startPage = data.pagingVo.startPage;
	var endPage = data.pagingVo.endPage; 
	var totalPageSize = data.pagingVo.totalPageSize;
	var currentPage = data.pagingVo.currentPage;
	var totalRecordSize = data.pagingVo.totalRecordSize;
	$('#count').html("검색결과: "+numberWithCommas(totalRecordSize)+"건");
	
	var viewName='classMngrList';
	if(totalRecordSize > 0){
		$(".page_num").html(getPaging(startPage,endPage,totalPageSize,currentPage,'\''+viewName+'\''));
	}
	$('#pageGrideInListTb').append(gbInnerHtml);
	
}
		
function setCheck() {
	var zTree = $.fn.zTree.getZTreeObj("tree"),
	py = $("#py").attr("checked")? "p":"",
	sy = $("#sy").attr("checked")? "s":"",
	pn = $("#pn").attr("checked")? "p":"",
	sn = $("#sn").attr("checked")? "s":"",
	type = { "Y":py + sy, "N":pn + sn};
	zTree.setting.check.chkboxType = type;
	showCode('setting.check.chkboxType = { "Y" : "' + type.Y + '", "N" : "' + type.N + '" };');
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
		case 'classMngrList' : $("#currentPage").val(page);getList(); break;
	default :
	}
}
</script>

<body>
	<%@ include file="../template/topMenu.jsp" %>
	<%@ include file="../template/topNav.jsp" %>
	<jsp:useBean id="now" class="java.util.Date" />
	<fmt:formatDate value="${now}" pattern="yyyy/MM/dd" var="today" />
	<!-- width 100% 컨텐츠 other 추가 -->
    <div class="hamo_container other">

        <!-- 좌측 트리 -->
        <div class="con_left">
        <div class="left_box">
            <ul class="location">
            </ul>
            <h2 class="tree_head">프로세스 차단 로그</h2>

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

                <h3>프로세스 차단 로그</h3>
                
                <ul class="search_area">
                  <li>
                    <label for="date_fr"></label><input type="text" name="date_fr" id="date_fr" class="input_type1" value="${auditLogVo.date_fr }"/>
                    <a href="#divCalendar" class="btn_cal" onclick="openCalendar(document.getElementById('date_fr')); return false;"><img src="/images/datepicker-icon.png" style="width:37px; height:37px;" alt="달력버튼"/></a>
                     ~
                    <label for="date_to"></label><input type="text" name="date_to" id="date_to" class="input_type1" value="${auditLogVo.date_to }"/>
                    <a href="#divCalendar" class="btn_cal" onclick="openCalendar(document.getElementById('date_to')); return false;"><img src="/images/datepicker-icon.png" style="width:37px; height:37px;" alt="달력버튼"/></a>
                      <div id="count"></div>
                  </li>
                  <li>
                    <div class="top_search">
                      <select id="keyWord" name="keyWord" title="keyWord" class="sel_type1">
						  <option value="1">PC호스트이름</option>
                          <option value="2">프로그램명</option>
                      </select>
                      <label for="txtSearch"></label><input type="text" name="txtSearch" id="txtSearch" class="input_type1" />
                      <button type="button" class="btn_type3" onclick="getList();"> 검색</button>
                    </div>
                  </li>
                </ul>
                
               
				<input type="hidden" id="currentPage" name="currentPage" value="1">
				<input type="hidden" id="org_seq" name="org_seq" value="">
                <div class="board_list mT20">
                    <table>
                        <colgroup>
                            <col style="width:7%;" />
                            <col style="width:15%;" />
                            <col style="width:20%;" />
                            <col style="width:23%;" />
                            <col style="width:10%;" />
                            <col />
                        </colgroup>
                        <thead>
                            <tr>
                                <th>번호</th>
                                <th>부서명</th>
                                <th>프로그램명</th>
                                <th>PC호스트이름</th>
                                <th>VPNIP</th>
                                <th>차단시간</th>
                            </tr>
                        </thead>
                        <tbody id=pageGrideInListTb>
                        </tbody>
                    </table>
                </div><!-- //List -->

                <!-- page number -->
                <div class="page_num">
                </div>


            </div>

        </div>
    </div><!-- //content -->
	
	
	<%@ include file="../template/grid.jsp" %>
	<%@ include file="../template/footer.jsp" %>
	
	
</body>
</html>