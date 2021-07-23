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
.detail_search input{width:200px;}
</style>
<script type="text/javascript">
//<![CDATA[
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
			/* check: {
				enable: true
			}, */
			edit: {
				drag: {
					/* autoExpandTrigger: true,
					prev: dropPrev,
					inner: dropInner,
					next: dropNext */
				}, 
				enable: true,
				showRemoveBtn: false,
				showRenameBtn: false
			},
			callback: {
				//beforeDrag: beforeDrag,
				//beforeDrop: beforeDrop,
				//beforeDragOpen: beforeDragOpen,
				//onDrag: onDrag,
				//onDrop: onDrop,
				//onExpand: onExpand,
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
		setNav('로그감사 > 인터넷사용로그');
	//트리 init
	$.fn.zTree.init($("#tree"), setting, zNodes); 
	
	$("#expandAllBtn").bind("click", {type:"expandAll"}, expandNode);
	$("#collapseAllBtn").bind("click", {type:"collapseAll"}, expandNode);
		
	getList();
	//등록버튼
	//$("#btnSave").click(fnSave);
	$("#excelBtn").on("click",function(){
		//location.href="iNetLogExcel?org_seq="+$("#org_seq").val();
		location.href="iNetLogExcel?org_seq="+$("#org_seq").val()+"&date_fr="+$("#date_fr").val()+"&date_to="+$("#date_to").val()+"&txtSearch="+$("#txtSearch").val()+"&keyWord="+$("#keyWord").val()+ "&prcssname=" + $("#prcssname").val()+ "&txtSearch0=" + $("#txtSearch0").val() + "&txtSearch1=" + $("#txtSearch1").val()+ "&txtSearch2=" + $("#txtSearch2").val()+ "&txtSearch3=" + $("#txtSearch3").val()+ "&txtSearch4=" + $("#txtSearch4").val()+ "&txtSearch5=" + $("#txtSearch5").val();
	});
	$("#txtSearch").keydown(function(key) {
		if (key.keyCode == 13) {
			key.preventDefault();
			getList();
		}
	});
	
	$("#btn_deTail").on("click",function(){
		$(".top_search").css("display","none");
		$(".detail_search").css("display","block");
		$("#txtSearch").val("");
		$("#prcssname").val("1");
		})
	$("#btn_normal").on("click",function(){
		$(".top_search").css("display","block");
		$(".detail_search").css("display","none");
		$("#txtSearch0").val("0");
		$("#txtSearch1").val("");
		$("#txtSearch2").val("");
		$("#txtSearch3").val("");
		$("#txtSearch4").val("");
		$("#txtSearch5").val("0");
		$("#prcssname").val("");
		})
	/* $(".sel_type1").change(function(){
		var html = "";
		html += "<div class=\"top_search mT20_d\">";
		html += "<select id=\"keyWord\" name=\"keyWord\" title=\"keyWord\" class=\"sel_type1\" onchange=\"searchTxt();\">";
		html += "<option value=\"0\">전체</option>";
		html += "<option value=\"1\">이름</option>";
		html += "<option value=\"2\">아이디</option>";
		html += "<option value=\"3\">HOSTNAME</option>";
		html += "<option value=\"4\">인터넷URL</option>";
		html += "<option value=\"5\">계급</option>";
		html += "</select>";
		html += "</div>";
		$(".top_search").append(html);
	}); */
	
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
		var zTree = $.fn.zTree.getZTreeObj("tree");
		var node = zTree.getNodeByParam('id', treeNode.pId);
		$("#org_seq").val(treeNode.id);
		$.post("iNetLogList.proc",{org_seq:treeNode.id,currentPage:$("#currentPage").val(),date_fr:$("#date_fr").val(),date_to:$("#date_to").val()},
				function(data){
			var gbInnerHtml = "";
			
			if( data.list.length > 0){
				
				$.each(data.list, function(index, value) {
					var no = data.pagingVo.totalRecordSize -(index ) - ((data.pagingVo.currentPage-1)*10);

					gbInnerHtml += "<tr data-code='' data-guidcode=''>";
					gbInnerHtml += "<td style='text-align:center;'>"+no+"</td>";
					gbInnerHtml += "<td>"+value.pc_ip+"</td>";
					gbInnerHtml += "<td>"+value.cnnc_url+"</td>";
					/* gbInnerHtml += "<td>"+value.pc_uuid+"</td>";  */
					gbInnerHtml += "<td>"+value.hostname+"</td>";
					gbInnerHtml += "<td>"+value.state+"</td>";
					if(value.insert_dt != "" && value.insert_dt != null)
						gbInnerHtml += "<td>"+value.insert_dt+"</td>";
					else
						gbInnerHtml += "<td>"+value.reg_dt+"</td>";
					gbInnerHtml += "<td>"+value.user_id+"</td>"; 
					gbInnerHtml += "<td>"+value.user_name+"</td>"; 
					gbInnerHtml += "<td>"+value.rank+"</td>"; 
					gbInnerHtml += "</tr>";
				
				});	
			}else{  
				gbInnerHtml += "<tr><td colspan='10' style='text-align:center;'>등록된 데이터가 없습니다. </td></tr>";
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
	var url ='/auditLog/iNetLogList.proc';
	
	var keyWord = $("select[name=keyWord]").val();
	console.log("keyWord===="+keyWord)
	var vData = 'currentPage=' + $("#currentPage").val()+"&keyWord="+ keyWord + "&prcssname=" + $("#prcssname").val()+"&date_fr="+$("#date_fr").val()+"&date_to="+$("#date_to").val()+ "&txtSearch=" + $("#txtSearch").val()+ "&org_seq=" + $("#org_seq").val() + "&txtSearch0=" + $("#txtSearch0").val() + "&txtSearch1=" + $("#txtSearch1").val()+ "&txtSearch2=" + $("#txtSearch2").val()+ "&txtSearch3=" + $("#txtSearch3").val()+ "&txtSearch4=" + $("#txtSearch4").val()+ "&txtSearch5=" + $("#txtSearch5").val(); 
	callAjax('POST', url, vData, iNetLogGetSuccess, getError, 'json');
}
var iNetLogGetSuccess = function(data, status, xhr, groupId){
	console.log("ss");
	var gbInnerHtml = "";
	$(".page_num").empty();
	$('#pageGrideInListTb').empty();
	$("#pagginationInList").empty();
	
	if( data.list.length > 0 ){
		$.each(data.list, function(index, value) {
			var no = data.pagingVo.totalRecordSize -(index ) - ((data.pagingVo.currentPage-1)*10);

			gbInnerHtml += "<tr data-code='' data-guidcode=''>";
			gbInnerHtml += "<td style='text-align:center;'>"+no+"</td>";
			gbInnerHtml += "<td>"+value.pc_ip+"</td>";
			gbInnerHtml += "<td>"+value.cnnc_url+"</td>";
			/* gbInnerHtml += "<td>"+value.pc_uuid+"</td>"; */ 
			gbInnerHtml += "<td>"+value.hostname+"</td>";
			gbInnerHtml += "<td>"+value.state+"</td>"; 
			if(value.insert_dt != "" && value.insert_dt != null)
				gbInnerHtml += "<td>"+value.insert_dt+"</td>";
			else
				gbInnerHtml += "<td>"+value.reg_dt+"</td>";
			gbInnerHtml += "<td>"+value.user_id+"</td>"; 
			gbInnerHtml += "<td>"+value.user_name+"</td>"; 
			gbInnerHtml += "<td>"+value.rank+"</td>"; 
			gbInnerHtml += "</tr>";
		
		});	
	}else{  
		gbInnerHtml += "<tr><td colspan='10' style='text-align:center;'>등록된 데이터가 없습니다. </td></tr>";
	}
	
	var startPage = data.pagingVo.startPage;
	var endPage = data.pagingVo.endPage; 
	var totalPageSize = data.pagingVo.totalPageSize;
	var currentPage = data.pagingVo.currentPage;
	var totalRecordSize = data.pagingVo.totalRecordSize;
	$('#count').html("검색결과: "+numberWithCommas(totalRecordSize)+"건");
	console.log(startPage);
	console.log(endPage);
	console.log(totalPageSize);
	console.log(currentPage);
	console.log(totalRecordSize);
	
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
//]]>
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
            <h2 class="tree_head">인터넷 사용로그</h2>

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

                <h3>인터넷 사용로그</h3>
                <ul class="search_area">
                  <li>
                   <label for="date_fr"></label><input type="text" name="date_fr" id="date_fr" class="input_type1" value="${auditLogVo.date_fr }"/>
                    <a href="#divCalendar" class="btn_cal" onclick="openCalendar(document.getElementById('date_fr')); return false;"><img src="/images/datepicker-icon.png" style="width:37px; height:37px;" alt="달력버튼"/></a>
                     ~
                    <label for="date_to"></label><input type="text" name="date_to" id="date_to" class="input_type1" value="${auditLogVo.date_to }"/>
                    <a href="#divCalendar" class="btn_cal" onclick="openCalendar(document.getElementById('date_to')); return false;"><img src="/images/datepicker-icon.png" style="width:37px; height:37px;" alt="달력버튼"/></a>
                    <button type="button" class="btn_type3" id="excelBtn"> 엑셀다운로드</button>
                    <div id="count"></div>
                  </li>
                  <li>
                   <div class="top_search">
                    <select id="keyWord" name="keyWord" title="keyWord" class="sel_type1" >
                     <option value="0">전체</option>
						<option value="1">이름</option>
						<option value="2">아이디</option>
						<option value="3">PC관리번호</option>
						<option value="4">인터넷URL</option>
						<option value="5">계급</option>
                    </select>
                    <label for="txtSearch"></label><input type="text" name="txtSearch" id="txtSearch" class="input_type1" />
                    <button type="button" class="btn_type3" onclick="getList();"> 검색</button>
                    <button type="button" class="btn_type3" id="btn_deTail"> 상세검색</button>
                    </div>
                  </li>
                </ul>
              
               
					<input type="hidden" id="currentPage" name="currentPage" value="1">
					<input type="hidden" id="org_seq" name="org_seq" value="">
					<div class="detail_search" style="display:none;float:left;">
					
					  <select id="txtSearch0" name="txtSearch0" title="txtSearch0" class="sel_type1" >
						<option value="0">전체</option>
                     <option value="1" <c:if test="${auditLogVo.txtSearch0 eq 1}">selected</c:if>>인터넷접속</option>
						<option value="2" <c:if test="${auditLogVo.txtSearch0 eq 2}">selected</c:if>>유해사이트접속</option>
                    </select>
                    <label for="txtSearch1"></label><input type="text" name="txtSearch1" id="txtSearch1" class="input_type1" placeholder="이름" value="${auditLogVo.txtSearch1 }" />
                    <label for="txtSearch2"></label><input type="text" name="txtSearch2" id="txtSearch2" class="input_type1" placeholder="아이디" value="${auditLogVo.txtSearch2 }" />
                    <label for="txtSearch3"></label><input type="text" name="txtSearch3" id="txtSearch3" class="input_type1" placeholder="PC관리번호" value="${auditLogVo.txtSearch3 }" />
                    <label for="txtSearch4"></label><input type="text" name="txtSearch4" id="txtSearch4" class="input_type1" placeholder="인터넷URL" value="${auditLogVo.txtSearch4 }" />
                    <select id="txtSearch5" name="txtSearch5" title="txtSearch5" class="sel_type1">
						<option value="0">전체</option>
                     <option value="001">이병</option>
						<option value="002">일병</option>
						<option value="003">상병</option>
						<option value="004">병장</option>
                    </select>
                    <button type="button" class="btn_type3" onclick="getList();"> 검색</button>
                    <button type="button" class="btn_type3" id="btn_normal"> 일반검색</button>
                    <input type="hidden" name="prcssname" id="prcssname" value="${auditLogVo.prcssname }"  />
                </div><!-- //검색 -->
                <div class="board_list mT20">
                    <table>
                        <colgroup>
                            <col style="width:7%;" />
                            <col style="width:10%;" />
                            <col style="width:23%;" />
                            <!-- <col style="width:10%;" /> -->
                            <col style="width:10%;" />
                            <col style="width:10%;" />
                            <col style="width:10%;" />
                            <col style="width:10%;" />
                            <col style="width:10%;" />
                            <col />
                        </colgroup>
                        <thead>
                            <tr>
                                <th>번호</th>
                                <th>사용자IP</th>
                                <th>인터넷URL</th>
                                <!-- <th>PC UUID</th> -->
                                <th>PC관리번호</th>
                                <th>상태</th>
                                <th>시간</th>
                                <th>아이디</th>
                                <th>이름</th>
                                <th>계급</th>
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
	<%@ include file="../template/footer.jsp" %>
	
	
</body>
</html>