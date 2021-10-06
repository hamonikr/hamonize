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
		setNav('사용자 정보');
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
							strHtml += "<td><input type='checkbox' name='chk' id='"+agrs[i].seq+"' class='form-control' value='"+agrs[i].seq+"'><label for='"+agrs[i].seq+"' class='dook'></label></td>";
							strHtml += "<td>"+no+"</td>";
							strHtml += "<td>"+agrs[i].p_org_nm+"</td>";
							strHtml += "<td>"+agrs[i].org_nm+"</td>";
							strHtml += "<td><a style='text-decoration: underline;' href='/user/view/"+agrs[i].seq+"''>"+agrs[i].user_id+"</a></td>";
							strHtml += "<td>"+agrs[i].rank+"</td>";
							strHtml += "<td>"+agrs[i].user_name+"</td>";
							strHtml += "<td>"+agrs[i].user_sabun+"</td>";
							strHtml += "<td>"+agrs[i].ins_date+"</td>";
							if(agrs[i].discharge_dt == null){
								strHtml += "<td> - </td>";
							}else{
								strHtml += "<td>"+agrs[i].discharge_dt+"</td>";
							}
							
							strHtml += "</tr>";				
							
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
							strHtml += "<td><input type='checkbox' name='chk' id="+agrs[i].seq+" class='form-control' value='"+agrs[i].seq+"'><label for="+agrs[i].seq+" class='dook'></label></td>";
							strHtml += "<td>"+no+"</td>";
							strHtml += "<td>"+agrs[i].p_org_nm+"</td>";
							strHtml += "<td>"+agrs[i].org_nm+"</td>";
							strHtml += "<td><a style='text-decoration: underline;' href='/user/view/"+agrs[i].seq+"''>"+agrs[i].user_id+"</a></td>";
							strHtml += "<td>"+agrs[i].rank+"</td>";
							strHtml += "<td>"+agrs[i].user_name+"</td>";
							strHtml += "<td>"+agrs[i].user_sabun+"</td>";
							strHtml += "<td>"+agrs[i].ins_date+"</td>";
							
							if(agrs[i].discharge_dt == null){
								strHtml += "<td> - </td>";
							}else{
								strHtml += "<td>"+agrs[i].discharge_dt+"</td>";
							}

							strHtml += "</tr>";
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

function userView(seq){
	$.post('/user/userView',{seq:seq},
			function(result){
					var agrs = result;
					$("#org_nm").val($.trim(agrs.org_nm));
					$("#rank").val($.trim(agrs.rank));
					$("#user_name").val($.trim(agrs.user_name));
					$("#user_id").val($.trim(agrs.user_id));
					$("#user_sabun").val($.trim(agrs.user_sabun));
					$("#insert_dt").val($.trim(agrs.insert_dt));
					$("#discharge_dt").val($.trim(agrs.discharge_dt));					
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
		alert("부서명을 입력해주세요.");
		return false;
	}
	
    console.log($("#seq").val());
    console.log($("#p_seq").val());
    console.log($("#org_nm").val());

	$('form[name=frm]').append("<input type='hidden' name='type' value='save' />");        
    $('form[name=frm]').submit();
    alert("정상적으로 저장되었습니다.");

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
		        <h2 class="tree_head">사용자 정보</h2>
		
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
			  <div id="count"></div>
            </li>
			<li>
				<div>
		            <button type="button" class="btn_type3" onclick="location.href='/user/userAdd'" id="userSave"> 사용자 추가</button>
					<button type="button" class="btn_type3" id="userDel" onclick="goDelete()"> 사용자 삭제</button>
				</div>
			</li>

            <li>
               <!-- 검색 -->
              <div class="top_search">
              <select id="keyWord" name="keyWord" title="keyWord" class="sel_type1">
                  <option value="0">전체</option>
                  <option value="1">이름</option>
                  <option value="2">ID</option>
                  <option value="3">소속팀</option>
                  <option value="4">사번</option>
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
                            <col style="width:5%;" />
                            <col style="width:5%;" />
                            <col style="width:15%;" />
                            <col style="width:15%;" />
                            <col style="width:10%;" />
                            <col style="width:10%;" />
                            <col style="width:10%;" />
                            <col style="width:10%;" />
                            <col style="width:10%;" />
                            <col />
                        </colgroup>
                        <thead>
                            <tr>
								<th>선택</th>
                                <th>번호</th>
                                <th>소속부서</th>
                                <th>소속팀</th>
                                <th>ID</th>
                                <th>직급</th>
                                <th>이름</th>
                                <th>사번</th>
                                <th>입사일</th>
                                <th>퇴사일</th>
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
    
    
	
	<%@ include file="../template/footer.jsp" %>
</body>

<script>
function goDelete(){
	console.log("--delete user func--");
	var chk = document.getElementsByName("chk");
	var chked = [];
	
	for(var i=0;i<chk.length;i++){
		if(chk[i].checked ==true){
			chked.push(chk[i].value);
		}		
	}

	if(chked.length==0){
		alert('삭제할 사용자를 선택해주세요');
	}else{
		console.log("chked.length : "+chked.length);
		
		$.ajax({
			url: '/user/delete',
			type: 'post',
			data: {
					seqs :chked
			},
			success: function(data){
				if(data==1){
					alert("사용자를 삭제하였습니다.. ");
					location.reload();
				}
				
			},
			error: function (request, status, error){
				alert("error!!");
				
			}
		});
	}
}	

</script>

</html>
	