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

.monitor_list {height:600px; overflow:scroll; padding:20px 20px 30px 20px; width: 90%; overflow-x: hidden;}
caption {text-indent: 0; height: 30px; font-size: 16px; overflow: inherit;}
.result_detail {margin-top: 20px; width: 100%}
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
			<c:if test="${data.level eq '0' or data.level eq '1'}">
			,open:true
			</c:if>},
		</c:forEach>				
	];
	
	$(document).ready(function(){
		setNav('로그감사 > 정책배포결과');
		$("#result_tab").css("display","none");
	//트리 init
	$.fn.zTree.init($("#tree"), setting, zNodes); 
	
	$("#expandAllBtn").bind("click", {type:"expandAll"}, expandNode);
	$("#collapseAllBtn").bind("click", {type:"collapseAll"}, expandNode);
		
	getList();
	//등록버튼
	//$("#btnSave").click(fnSave);
	$("#excelBtn").on("click",function(){
		//location.href="iNetLogExcel?org_seq="+$("#org_seq").val();
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

function detail(uuid){
	$(".result_detail").remove();
	$(".content_bapo").remove();
	 $.post("detailPolicy.proc",{pc_uuid:uuid},
			function(data){
		 console.log("data.program.length11======"+data.program.length);
		//if( data.udpt.length > 0){
			var shtml = "";
			console.log("data.udpt.length======"+data.udpt.length);
			shtml += "<div class=\"content_bapo\">";
			shtml += "<h4>업데이트 배포결과</h4>";
			shtml += "<div class=\"board_list_3\">";
			shtml += "<table>";
			shtml += "<colgroup>";
			shtml += "<col style=\"width:30%;\" /><col style=\"width:30%;\" /><col style=\"width:10%;\" /><col style=\"width:10%;\" /><col />";
			shtml += "</colgroup>";
			shtml += "<thead><tr>";
			shtml += "<th>패키지</th>";
			shtml += "<th>버전</th>";
			shtml += "<th>구분</th>";
			shtml += "<th>상태</th>";
			shtml += "<th>적용일</th>";
			shtml += "</tr></thead>";
			shtml += "<tbody>";
			$.each(data.udpt, function(index, value) {
				var inset_dt = value.insert_dt;
				var date = new Date(inset_dt);
				date = date.getFullYear()+"-"+addZero(date.getMonth()+1)+"-"+addZero(date.getDate().toString());
				shtml += "<tr>";
				shtml += "<td class=\"t_left\">"+value.debname+"</td>";
				shtml += "<td>"+value.debver+"</td>";
				shtml += "<td>"+value.gubun+"</td>";
				if(value.state == "1")
					shtml += "<td>완료</td>";
				else
					shtml += "<td>미완료</td>";
				shtml += "<td>"+date+"</td>";
				shtml += "</tr>";
			});	
			shtml += "</tbody>";
			shtml += "</table>";
			shtml += "</div>";

			
			console.log("data.program.length======"+data.program.length);
			console.log("data======"+data);
			shtml += "<h4>프로그램 차단 배포 결과</h4>";
			shtml += "<div class=\"board_list_3\">";
			shtml += "<table>";
			shtml += "<colgroup>";
			shtml += "<col style=\"width:50%;\" /><col style=\"width:30%;\" /><col />";
			shtml += "</colgroup>";
			shtml += "<thead><tr>";
			shtml += "<th>패키지</th>";
			shtml += "<th>적용여부</th>";
			shtml += "<th>적용일</th>";
			shtml += "</tr></thead>";
			shtml += "<tbody>";
			$.each(data.program, function(index, value) {
				var inset_dt = value.ins_date;
				var date = new Date(inset_dt);
				date = date.getFullYear()+"-"+addZero(date.getMonth()+1)+"-"+addZero(date.getDate().toString());
				shtml += "<tr>";
				shtml += "<td>"+value.progrmname+"</td>";
				if(value.status_yn == "Y")
					shtml += "<td>차단</td>";
				else
					shtml += "<td>허용</td>";
					shtml += "<td>"+date+"</td>";
					shtml += "</tr>";
			});	
			shtml += "</tbody>";
			shtml += "</table>";
			shtml += "</div>";
			
				
			
			console.log("data.firewall.length======"+data.firewall.length);
			console.log("data======"+data);
			shtml += "<h4>방화벽 정책 배포 결과</h4>";
			shtml += "<div class=\"board_list_3\">";
			shtml += "<table>";
			shtml += "<colgroup>";
			shtml += "<col style=\"width:30%;\" /><col style=\"width:20%;\" /><col style=\"width:30%;\" /><col />";
			shtml += "</colgroup>";
			shtml += "<thead><tr>";
			shtml += "<th>포트번호</th>";
			shtml += "<th>상태</th>";
			shtml += "<th>적용여부</th>";
			shtml += "<th>적용일</th>";
			shtml += "</tr></thead>";
			shtml += "<tbody>";
			$.each(data.firewall, function(index, value) {
				var inset_dt = value.ins_date;
				var date = new Date(inset_dt);
				date = date.getFullYear()+"-"+addZero(date.getMonth()+1)+"-"+addZero(date.getDate().toString());
				shtml += "<tr>";
				shtml += "<td>"+value.retport+"</td>";
				shtml += "<td>"+value.status+"</td>";
				if(value.status_yn == "Y")
					shtml += "<td>완료</td>";
				else
					shtml += "<td>미완료</td>";
					shtml += "<td>"+date+"</td>";
					shtml += "</tr>";
			});	
			shtml += "</tbody>";
			shtml += "</table>";
			shtml += "</div>";
	
			console.log("data.device.length======"+data.device.length);
			console.log("data======"+data);
			shtml += "<h4>디바이스 허용 배포 결과</h4>";
			shtml += "<div class=\"board_list_3\">";
			shtml += "<table>";
			shtml += "<colgroup>";
			shtml += "<col style=\"width:50%;\" /><col style=\"width:30%;\" /><col />";
			shtml += "</colgroup>";
			shtml += "<thead><tr>";
			shtml += "<th>디바이스</th>";
			shtml += "<th>적용여부</th>";
			shtml += "<th>적용일</th>";
			shtml += "</tr></thead>";
			shtml += "<tbody>";
			$.each(data.device, function(index, value) {
				var inset_dt = value.ins_date;
				var date = new Date(inset_dt);
				date = date.getFullYear()+"-"+addZero(date.getMonth()+1)+"-"+addZero(date.getDate().toString());
				shtml += "<tr>";
				shtml += "<td>"+value.product+"("+value.vendorcode+":"+value.productcode+")</td>";
				if(value.status_yn == "Y")
					shtml += "<td>허용</td>";
				else
					shtml += "<td>차단</td>";
					shtml += "<td>"+date+"</td>";
					shtml += "</tr>";
			});	
			shtml += "</tbody>";
			shtml += "</table>";
			shtml += "</div>";

			console.log("data======"+data);
			// shtml += "<h4>유해사이트 차단 배포 결과</h4>";
			// shtml += "<div class=\"board_list_3\">";
			// shtml += "<table>";
			// shtml += "<colgroup>";
			// shtml += "<col style=\"width:50%;\" /><col style=\"width:30%;\" /><col />";
			// shtml += "</colgroup>";
			// shtml += "<thead><tr>";
			// shtml += "<th>구분</th>";
			// shtml += "<th>적용여부</th>";
			// shtml += "<th>적용일</th>";
			// shtml += "</tr></thead>";
			// shtml += "<tbody>";
			// $.each(data.nxss, function(index, value) {
			// 	var inset_dt = value.ins_date;
			// 	var date = new Date(inset_dt);
			// 	date = date.getFullYear()+"-"+addZero(date.getMonth()+1)+"-"+addZero(date.getDate().toString());
			// 	shtml += "<tr>";
	
			// 	if(value.file_gubun == "fording")
			// 		shtml += "<td>이동사이트 및 알람 메세지</td>";
			// 	else if(value.file_gubun == "filelist")
			// 		shtml += "<td>유해사이트 목록</td>";
					
			// 		shtml += "<td>적용</td>";
			// 		shtml += "<td>"+date+"</td>";
			// 		shtml += "</tr>";
			// });	
			shtml += "</tbody>";
			shtml += "</table>";
			shtml += "</div>";
			shtml += "</div>";
				
		$(".right_box_r").append(shtml);
	}); 

}
function addZero(data){
    return (data<10) ? "0"+data : data;
}
//메뉴 Tree onClick
function onClick(event, treeId, treeNode, clickFlag) {
		$(".monitor_list").remove();
		$("#list_info").empty();
		$(".info").empty();
		$(".result_detail").remove();
		$(".content_bapo").remove();
		$(".veiwcheck").css("display","block");

		var cnt = 0;
		var zTree = $.fn.zTree.getZTreeObj("tree");
		var node = zTree.getNodeByParam('id', treeNode.pId);
		$("#org_seq").val(treeNode.id);
		$.post("/mntrng/pcPolicyList",{org_seq:treeNode.id},
				function(data){
			var shtml = "";
			var shtml_r = "";
			if( data.pcList.length > 0){
				console.log("data.length======"+data.pcList.length);
				shtml += "<ul class='monitor_list'>";
				$.each(data.pcList, function(index, value) {
					 if(value.pc_status == "true"){
						cnt++;
					console.log("pc_status--> "+value.pc_status);
					shtml += "<li class='on'><a href='#' onclick=\"detail('"+value.pc_uuid+"')\">"+value.pc_hostname+"</a></li>";
						} else
					shtml += "<li><a href='#' onclick=\"detail('"+value.pc_uuid+"')\">"+value.pc_hostname+"</a></li>";
					 
				});	
				shtml_r += "<div class=\"content_bapo\">";
				shtml_r += "<h4>업데이트 배포결과</h4>";
				shtml_r += "<div class=\"board_list_3\">";
				shtml_r += "<table>";
				shtml_r += "<colgroup>";
				shtml_r += "<col style=\"width:30%;\" /><col style=\"width:30%;\" /><col style=\"width:10%;\" /><col style=\"width:10%;\" /><col style=\"width:10%;\" /><col />";
				shtml_r += "</colgroup>";
				shtml_r += "<thead><tr>";
				shtml_r += "<th>패키지</th>";
				shtml_r += "<th>버전</th>";
				shtml_r += "<th>구분</th>";
				shtml_r += "<th>전체PC</th>";
				shtml_r += "<th>완료</th>";
				shtml_r += "<th>미완료</th>";
				shtml_r += "</tr></thead>";
				shtml_r += "<tbody>";
				for(var i = 0;i < data.policyResult.length;i++){
					console.log(i);
					console.log(i+1);
					console.log(data.policyResult.length);
					console.log(data.policyResult[i].debname);
					var chk = 1;
					if((i+1) == data.policyResult.length){
						chk=0;
						}
					if(data.policyResult[i].debname != data.policyResult[i+chk].debname){
						var inset_dt = data.policyResult[i].ins_date;
						var date = new Date(inset_dt);
						date = date.getFullYear()+"-"+addZero(date.getMonth()+1)+"-"+addZero(date.getDate().toString());
						var noinstall = data.pcList.length - data.policyResult[i].count;
						shtml_r += "<tr>";
						shtml_r += "<td>"+data.policyResult[i].debname+"</td>";
						if(typeof data.policyResult[i].debver === "undefined")
							shtml_r += "<td>-</td>";
							else
						shtml_r += "<td>"+data.policyResult[i].debver+"</td>";
						shtml_r += "<td>"+data.policyResult[i].gubun+"</td>";
						shtml_r += "<td>"+data.pcList.length+"</td>";
						shtml_r += "<td>"+data.policyResult[i].count+"</td>";
						shtml_r += "<td>"+noinstall+"</td>";
						shtml_r += "</tr>";
						}else if((i+1) == data.policyResult.length){
							console.log("last");
							var inset_dt = data.policyResult[i].ins_date;
							var date = new Date(inset_dt);
							date = date.getFullYear()+"-"+addZero(date.getMonth()+1)+"-"+addZero(date.getDate().toString());
							var noinstall = data.pcList.length - data.policyResult[i].count;
							shtml_r += "<tr>";
							shtml_r += "<td>"+data.policyResult[i].debname+"</td>";
							shtml_r += "<td>"+data.policyResult[i].debver+"</td>";
							shtml_r += "<td>"+data.policyResult[i].gubun+"</td>";
							shtml_r += "<td>"+data.pcList.length+"</td>";
							shtml_r += "<td>"+data.policyResult[i].count+"</td>";
							shtml_r += "<td>"+noinstall+"</td>";
							shtml_r += "</tr>";
							}
					}
				
				shtml_r += "</tbody>";
				shtml_r += "</table>";
				shtml_r += "</div>";
					$(".right_box_l").append(shtml);
					$(".right_box_r").append(shtml_r);
				
			}else{  
				gbInnerHtml += "<tr><td colspan='7' style='text-align:center;'>등록된 데이터가 없습니다. </td></tr>";
			}

			console.log("cnt===="+cnt)
		});
		
			
	}
	
function getList(){
	var url ='/mntrng/pcList.do';
	
	var keyWord = $("select[name=keyWord]").val();
	console.log("keyWord===="+keyWord)

	var vData = "org_seq=2"; 
	callAjax('POST', url, vData, iNetLogGetSuccess, getError, 'json');
}

var iNetLogGetSuccess = function(data, status, xhr, groupId){
	console.log("ss");
	var cnt = 0;
	var gbInnerHtml = "";
	$('#pageGrideInListTb').empty();
	$("#pagginationInList").empty();
	console.log(data);
	console.log('${on}');
	console.log('${off}');
	if( data.length > 0 ){
		$.each(data, function(index, value) {
			if(value.pc_status == "true"){
				cnt++;
			console.log(value.pc_status)
				}

			$(".cyberinfo li").each(function (i,v){
				if(i==0){
					$(this).html("<span>패키지명</span>hamonize-process-block<br/>hamonize-system-init<br/>hamonize-process-mngr<br/>chromium-browser-l10n");
					$(this).css("color","#333");
				}
				if(i==1)
					$(this).html("<span>전체</span>"+data.length+"대<br/>"+data.length+"대<br/>"+data.length+"대<br/>"+data.length+"대");
				 if(i==2)
					 $(this).html("<span>설치</span>"+cnt+"대<br/>"+cnt+"대<br/>"+cnt+"대<br/>"+cnt+"대");
				if(i==3)
					$(this).html("<span>미설치</span>"+(data.length-cnt)+"대<br/>"+(data.length-cnt)+"대<br/>"+(data.length-cnt)+"대<br/>"+(data.length-cnt)+"대");
				
				
			});
            
		
		});	
		console.log("cnt===="+cnt)
	}else{  
		gbInnerHtml += "<tr><td colspan='7' style='text-align:center;'>등록된 데이터가 없습니다. </td></tr>";
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
            <h2 class="tree_head">정책 배포 결과</h2>

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
            <div class="right_box_l" style="float: left; width: 40%;">
            <h3>PC리스트</h3>
            <ul class="veiwcheck" style="margin-right:50px; display:none">
                    <li>
                        <font class="on">●</font>ON
                    </li>
                    <li>
                        <font class="off">○</font>OFF
                    </li>
                </ul>
            <div class="info">부대 또는 사지방을 선택해주세요.</div>
            </div>
            <div class="right_box_r" style="float: left; width: 60%;">
            <h3>정책 배포 결과</h3>
               <div class="info"> 부대 또는 사지방을 선택해주세요.</div>
            </div>
            </div>

        </div>
    </div><!-- //content -->
	
	
	<%@ include file="../template/grid.jsp" %>
	<%@ include file="../template/footer.jsp" %>
	
	
</body>
</html>