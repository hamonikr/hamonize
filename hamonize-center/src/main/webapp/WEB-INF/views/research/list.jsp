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
a:hover{
color: #0056b3;
text-decoration: none; 
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
		setNav('사용자정보');
		$("#txtSearch").keydown(function(key) {
			if (key.keyCode == 13) {
				key.preventDefault();
				getUserList($("#listInfoCurrentPage").val());
			}
		});
		
	//트리 init
	$.fn.zTree.init($("#tree"), setting, zNodes); 
	
	$("#expandAllBtn").bind("click", {type:"expandAll"}, expandNode);
	$("#collapseAllBtn").bind("click", {type:"collapseAll"}, expandNode);
	getUserList($("#listInfoCurrentPage").val());
	

	$(".btn_type").on("click",function(){
		location.href="excelList?type="+$(this).attr('id')+"&org_seq="+$("#org_seq").val()+"&date_fr="+$("#date_fr").val()+"&date_to="+$("#date_to").val();
	});
	
	
	
});
	
	function getUserList(num){
		$('#pageGrideInSoliderListTb').empty();
		$('.page_num').empty();
		var keyWord = $("select[name=keyWord]").val();
		var txtSearch = $("input[name=txtSearch]").val();
		var org_seq = $('#org_seq').val();
		if(org_seq == "" ){
		org_seq = 1;
		}
		var url ='/user/eachList';
		$.post(url,{org_seq:org_seq,listInfoCurrentPage:num,keyWord:keyWord,txtSearch:txtSearch},
				function(result){
						var agrs = result.data;
						var paging = result.paging;
						console.log(agrs);
						var strHtml ="";
						if(agrs.length > 0){
						for(var i =0; i< agrs.length;i++){
							var no = paging.totalRecordSize -(i ) - ((paging.currentPage-1)*10);
							
							strHtml += "<tr>";
							strHtml += "<td>"+no+"</td>";
							strHtml += "<td>"+agrs[i].p_org_nm+"</td>";
							strHtml += "<td>"+agrs[i].org_nm+"</td>";
							strHtml += "<td>"+agrs[i].user_id+"</td>";
							strHtml += "<td>"+agrs[i].rank+"</td>";
							strHtml += "<td>"+agrs[i].user_name+"</td>";
							/* strHtml += "<td>"+agrs[i].narasarang_no+"</td>"; */
							strHtml += "<td>"+agrs[i].user_gunbun+"</td>";
							strHtml += "<td>"+agrs[i].insert_dt+"</td>";
							strHtml += "<td>"+agrs[i].discharge_dt+"</td>";
							strHtml += "</tr>";
							
							//var uuid = agrs[i].sgb_pc_uuid;
							/* strHtml += "<tr data-code='" + agrs[i].idx + "'>";
							strHtml += "<td class='mdl-data-table__cell--non-numeric'>"+no+"</td>";
							strHtml += "<td class='mdl-data-table__cell--non-numeric'><a href='#' onclick='userView("+agrs[i].idx+")'>"+agrs[i].user_id+"</a></td>";
							strHtml += "<td class='mdl-data-table__cell--non-numeric'>"+agrs[i].org_nm+"</td>";
							strHtml += "<td class='mdl-data-table__cell--non-numeric'>"+agrs[i].rank+"</td>";
							strHtml += "<td class='mdl-data-table__cell--non-numeric'>"+agrs[i].user_name+"</td>";
							strHtml += "<td class='mdl-data-table__cell--non-numeric'>"+agrs[i].narasarang_no+"</td>";
							strHtml += "<td class='mdl-data-table__cell--non-numeric'>"+agrs[i].user_gunbun+"</td>";  
							strHtml += "<td class='mdl-data-table__cell--non-numeric'>"+agrs[i].insert_dt+"<br class='changeLine'/> </td>";
							strHtml += "<td class='mdl-data-table__cell--non-numeric'>"+agrs[i].discharge_dt+"<br class='changeLine'/> </td>";
							strHtml += "</tr>"; */  
							}
						}else{
							strHtml += "<tr data-code=''><td colspan='10' style='text-align:center;'class='mdl-data-table__cell--non-numeric'>등록된 데이터가 없습니다.</td></tr>"
						}
						 var startPage = paging.startPage;
						 var endPage = paging.endPage; 
						 var totalPageSize = paging.totalPageSize;
						 var currentPage = paging.currentPage;
						 var totalRecordSize = paging.totalRecordSize; 
						 $('#count').html("검색결과: "+numberWithCommas(totalRecordSize)+"명");
						
						console.log(startPage);
						console.log(endPage);
						console.log(totalPageSize);
						console.log(currentPage);
						console.log(totalRecordSize);
					
						 var viewName = 'classMngrList';
						if(totalRecordSize > 0){
							$("#page_num").html(getPaging(startPage,endPage,totalPageSize,currentPage,'\''+viewName+'\''));
						}
						$("#pageGrideInSoliderListTb").append(strHtml);
					
						
				});
	}

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
		$('#pageGrideInSoliderListTb').empty();
		$('#page_num').empty();
		var zTree = $.fn.zTree.getZTreeObj("tree");
		var node = zTree.getNodeByParam('id', treeNode.pId);
		$('#org_seq').val(treeNode.id);
		$.post('/user/eachList',{org_seq:treeNode.id},
				function(result){
						var agrs = result.data;
						var paging = result.paging;
						console.log(agrs);
						var strHtml ="";
						if(agrs.length > 0){
						for(var i =0; i< agrs.length;i++){
							var no = paging.totalRecordSize -(i ) - ((paging.currentPage-1)*10);
							
							strHtml += "<tr>";
							strHtml += "<td>"+no+"</td>";
							strHtml += "<td>"+agrs[i].p_org_nm+"</td>";
							strHtml += "<td>"+agrs[i].org_nm+"</td>";
							strHtml += "<td>"+agrs[i].user_id+"</td>";
							strHtml += "<td>"+agrs[i].rank+"</td>";
							strHtml += "<td>"+agrs[i].user_name+"</td>";
							/* strHtml += "<td>"+agrs[i].narasarang_no+"</td>"; */
							strHtml += "<td>"+agrs[i].user_gunbun+"</td>";
							strHtml += "<td>"+agrs[i].insert_dt+"</td>";
							strHtml += "<td>"+agrs[i].discharge_dt+"</td>";
							strHtml += "</tr>";
							//var uuid = agrs[i].sgb_pc_uuid;
							/* strHtml += "<tr data-code='" + agrs[i].idx + "'>";
							strHtml += "<td class='mdl-data-table__cell--non-numeric'>"+no+"</td>";
							strHtml += "<td class='mdl-data-table__cell--non-numeric'><a href='#' onclick='userView("+agrs[i].idx+")'>"+agrs[i].user_id+"</a></td>";
							strHtml += "<td class='mdl-data-table__cell--non-numeric'>"+agrs[i].org_nm+"</td>";
							strHtml += "<td class='mdl-data-table__cell--non-numeric'>"+agrs[i].rank+"</td>";
							strHtml += "<td class='mdl-data-table__cell--non-numeric'>"+agrs[i].user_name+"</td>";
							strHtml += "<td class='mdl-data-table__cell--non-numeric'>"+agrs[i].narasarang_no+"</td>";
							strHtml += "<td class='mdl-data-table__cell--non-numeric'>"+agrs[i].user_gunbun+"</td>";  
							strHtml += "<td class='mdl-data-table__cell--non-numeric'>"+agrs[i].insert_dt+"<br class='changeLine'/> </td>";
							strHtml += "<td class='mdl-data-table__cell--non-numeric'>"+agrs[i].discharge_dt+"<br class='changeLine'/> </td>";
							strHtml += "</tr>";   */
							}
						}else{
							strHtml += "<tr data-code=''><td colspan='10' style='text-align:center;'class='mdl-data-table__cell--non-numeric'>등록된 데이터가 없습니다.</td></tr>"
						}
						var startPage = paging.startPage;
						 var endPage = paging.endPage; 
						 var totalPageSize = paging.totalPageSize;
						 var currentPage = paging.currentPage;
						 var totalRecordSize = paging.totalRecordSize; 
						 $('#count').html("검색결과: "+numberWithCommas(totalRecordSize)+"명");
						console.log(startPage);
						console.log(endPage);
						console.log(totalPageSize);
						console.log(currentPage);
						console.log(totalRecordSize);
						if(agrs.length == 0){
							$("#pagginationInList").empty();
						}else{
							var viewName = 'classMngrList';
							if(totalRecordSize > 0){
								$("#page_num").html(getPaging(startPage,endPage,totalPageSize,currentPage,'\''+viewName+'\''));
							}
						}
						$("#pageGrideInSoliderListTb").append(strHtml);
				});
			
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

function userView(idx){
	$.post('/user/userView',{idx:idx},
			function(result){
					var agrs = result;
					$("#org_nm").val($.trim(agrs.org_nm));
					$("#rank").val($.trim(agrs.rank));
					$("#user_name").val($.trim(agrs.user_name));
					$("#user_id").val($.trim(agrs.user_id));
					$("#narasarang_no").val($.trim(agrs.narasarang_no));
					$("#user_gunbun").val($.trim(agrs.user_gunbun));
					$("#insert_dt").val($.trim(agrs.insert_dt));
					$("#discharge_dt").val($.trim(agrs.discharge_dt));
					/* $('div.modal').modal({backdrop: 'static'});
					$('div.modal').modal(); */
					
					$('#element_to_pop_up').bPopup({
		                modalClose: false,
		                opacity: 0.6,
		                positionStyle: 'fixed' //'fixed' or 'absolute'
		            });
			});
}
 

//등록 처리결과(공통명 : 프로그램명Json )
function fnSave(){
	
	if($("#org_nm").val()==""){
		alert("부대명을 입력해주세요.");
		return false;
	}
	
	//var value = new MiyaValidator(document.forms["frm"]);
		
	//value.add("orgOrdr" , {required: true ,message: "부서순서를 입력하세요"});
	//value.add("orgNm"    , {required: true ,message: "부대명을 입력하세요"});
	//value.add("orgLinkYn", {required: true ,message: "부서링크를 선택해주세요"});
	
	/*  if($("input[name='orgLinkYn']:checked").val() == 'Y' && $("#orgLink").val() == '') {
		value.add("orgLink", {required: true ,message: "부서링크를 입력하세요"});	
	} */ 
	
	//value.add("link"     , {required: true, option:"engonly", message: "영문으로만 입력하셔야 합니다"});
	//var msg = "등록하시겠습니끼?";
    //if(!confirm(msg)){return;}
    /* $("input[name='jobSeq']").each(function(v,k){
    	console.log( v+" : "+k);
    });*/
    console.log($("#seq").val());
    console.log($("#p_seq").val());
    console.log($("#org_nm").val());
    /* $("#orgchtSeq").val($("#seq").val());
    if($("#chrgjobNm").val()!=null){
    	$("#chrgjob").val("y");
    } */
    $('form[name=frm]').append("<input type='hidden' name='type' value='save' />");        
    $('form[name=frm]').submit();
    alert("정상적으로 저장되었습니다.");
	/* var result = value.validate();
    if (!result) {
        //alert(value.getErrorMessage()); //디폴트 label 메세지
        //alert(value.getErrorMessage("{message}")); //동적 메세지
        value.getErrorElement().focus();
        return false;
    }else {		 
    	
        $('form[name=frm]').append("<input type='hidden' name='type' value='save' />");        
        $('form[name=frm]').submit(); 
    } */
    return false;
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
		case 'classMngrList' : $("#listInfoCurrentPage").val(page); getUserList(page); break;	//	공지사항
	default :
	}
}
;(function($) {
    $(function() {
        $('#orgname').bind('click', function(e) {
            e.preventDefault();
            $('#element_to_pop_up').bPopup({
                modalClose: false,
                opacity: 0.6,
                positionStyle: 'fixed' //'fixed' or 'absolute'
            });
        });
    });
})(jQuery);
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
		            <li>Home</li>
		            <li>Location</li>
		        </ul>
		        <h2 class="tree_head">사용자정보</h2>
		
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
              <label for="date_to"></label><input type="text" name="date_to" id="date_to" class="input_type1" value="${today}"/>
              <a href="#divCalendar" class="btn_cal" onclick="openCalendar(document.getElementById('date_to')); return false;"><img src="/images/datepicker-icon.png" style="width:37px; height:37px;" alt="달력버튼"/></a>
              <button type="button" class="btn_type" id="1"> 일평균 pc 가동수</button>
              <button type="button" class="btn_type" id="2"> 로그인 내역 PC 중복제거</button>
              <button type="button" class="btn_type" id="3"> 일간 평균 사용자 수</button>
              <button type="button" class="btn_type" id="4"> 중복제거 사용자 수</button>
              <button type="button" class="btn_type" id="5"> 월별 PC총 사용시간</button>
              <button type="button" class="btn_type" id="6"> 부문별 PC 대수</button>
              <button type="button" class="btn_type" id="7"> 일별 총 PC대수</button>
              <button type="button" class="btn_type" id="8"> 일별 총 사용자 수</button>
              <div id="count"></div>
            </li>
            <li>
               <!-- 검색 -->
              <div class="top_search">
              <select id="keyWord" name="keyWord" title="keyWord" class="sel_type1">
                  <option value="0">전체</option>
                  <option value="1">성명</option>
                  <option value="2">ID</option>
                  <option value="3">소속부문</option>
                  <option value="4">군번</option>
              </select>
              <label for="txtSearch"></label><input type="text" name="txtSearch" id="txtSearch" class="input_type1" />
              <button type="button" class="btn_type3" onclick="getUserList(1);"> 검색</button>
                </div><!-- //검색 -->
            </li>       
          </ul>
      
      		<input type="hidden" name="org_seq" id="org_seq" />
      			<div class="board_list mT20">
                    <table>
                        <colgroup>
                            <col style="width:7%;" />
                            <col style="width:25%;" />
                            <col style="width:10%;" />
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
                                <th>소속부문</th>
                                <th>부서번호</th>
                                <th>ID</th>
                                <th>직급</th>
                                <th>성명</th>
                                <th>사번</th>
                                <th>가입일</th>
                                <th>전역일</th>
                            </tr>
                        </thead>
                        <tbody id="pageGrideInSoliderListTb"></tbody>
                    </table>
                </div><!-- //List -->
                				
                <!-- page number -->
                <div class="page_num" id="page_num">
                </div>
            </div>
				</div>

    </div><!-- //content -->
    
    
	<%@ include file="../template/grid.jsp" %>
	<%@ include file="../template/footer.jsp" %>
	
	
</body>
</html>
	