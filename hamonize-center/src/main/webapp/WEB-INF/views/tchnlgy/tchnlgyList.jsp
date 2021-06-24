<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>
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
<script type="text/javascript" src="/js/common.js"></script>
<script type="text/javascript">

$(document).ready(function() {
	setNav('장애처리');
	$("#btn_insert").click(function(){
		location.href="tchnlgyInsert";
	});
	 $("#txtSearch").keydown(function(key) {
		if (key.keyCode == 13) {
			key.preventDefault();
			getList();
		}
	});
	
	
	getList();

	$("#excelBtn").on("click",function(){
		//location.href="unAuthLogExcel?org_seq="+$("#org_seq").val();
		var keyWord = $("select[name=keyWord]").val();
		var txtSearch = $("#txtSearch").val();
		if(keyWord == "6"){
			if(txtSearch.indexOf("전화") != -1)
				txtSearch = "C"
			else
				txtSearch = "O"
		}
		location.href="tchnlgyExcel?date_fr="+$("#date_fr").val()+"&date_to="+$("#date_to").val()+"&txtSearch="+txtSearch+"&keyWord="+$("#keyWord").val();
	});

});

function view(seq,cPage){
	//console.log("asd");
	var $form = $('<form></form>').attr('action','/tchnlgy/tchnlgyDetail.acnt').attr('method','POST');
	var $ipt = $('<input type="hidden" name="seq" />').val(seq);
	var $cPage = $('#mngeListInfoCurrentPage').val(cPage);
	$form.append($cPage).appendTo('form');
	$form.append($ipt).appendTo('form').submit();
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
		case 'classMngrList' :  $("#mngeListInfoCurrentPage").val(page); getList(page); break;
	default :
	}
	//getList(page);
}

/* var getList = function(page) {
	  $.getJSON('/pushstate/page' + page, function(data) {
	    var list = $.map(data.list, function(l) {
	      return '<li><a href="/detail/' + l.id + '">' + l.title + '</a></li>'
	    }).join('');
	    $('#list').html(list);
	    $('#next').attr('href', '/pushstate/page' + (+page+1));
	    history.pushState({list: list, page: page}, 'Page '+ page, '/pushstate/page' + page);
	  });
	}; */

function getList(page){
	console.log("list hash"+location.hash);
	var url ='/tchnlgy/tchnlgyList.proc';
	var keyWord = $("select[name=keyWord]").val();
	var txtSearch = $("#txtSearch").val();
	var currentpage = $("#mngeListInfoCurrentPage").val();
	if(currentpage == "" || currentpage == null){
		currentpage = 1;
		}
	if(keyWord == "6"){
		if(txtSearch.indexOf("전화") != -1)
			txtSearch = "C"
		else
			txtSearch = "O"
	}
	$("#mngeListInfoCurrentPage").val(currentpage);
	var vData = 'mngeListInfoCurrentPage=' + currentpage +"&keyWord="+ keyWord + "&txtSearch=" + txtSearch;
	callAjax('GET', url, vData, tchnlgyGetSuccess, getError, 'json');
	
	/* $.ajax({
    url: url, // 클라이언트가 HTTP 요청을 보낼 서버의 URL 주소
    data: { mngeListInfoCurrentPage: currentpage,keyWord: keyWord, txtSearch: $("#txtSearch").val()},  // HTTP 요청과 함께 서버로 보낼 데이터
    method: "POST",   // HTTP 요청 메소드(GET, POST 등)
    dataType: "json" // 서버에서 보내줄 데이터의 타입
})
// HTTP 요청이 성공하면 요청한 데이터가 done() 메소드로 전달됨.
.done(function(data) {
	//window.location.hash = '#page' + data.pagingVo.currentPage;
	history.pushState({list: data.list, page: data.pagingVo.currentPage}, 'Page '+ data.pagingVo.currentPage, '/tchnlgy/tchnlgyList/page' + data.pagingVo.currentPage);
	//history.pushState(null, null, url + "?" + vData);
	var gbInnerHtml = "";
	var classGroupList = data.list;
	$('#pageGrideInMngrListTb').empty();
	if( data.list.length > 0 ){
		$.each(data.list, function(index, value) {
			var no = data.pagingVo.totalRecordSize -(index ) - ((data.pagingVo.currentPage-1)*10);
			var type = value.type;
			if(value.type_detail == "local")
				type += "(현장)";
			else if(value.type_detail == "remote")
				type += "(원격)";
			if(value.status == "답변완료")
				complete++;
			else if(value.status == "접수")
				receipt++;
			else if(value.status == "진행중")
				progress++;
			gbInnerHtml += "<tr id='"+no+"'>";
			gbInnerHtml += "<td>"+no+"</td>";
			gbInnerHtml += "<td>"+value.org_nm+"</td>";
			gbInnerHtml += "<td class=\"t_left\"><a href=\"javascript:view("+value.seq+","+data.pagingVo.currentPage+")\">"+value.title+"</a></td>";
			gbInnerHtml += "<td>"+value.user_name+"</td>";
			gbInnerHtml += "<td>"+value.insert_dt+"</td>";
			gbInnerHtml += "<td>"+type+"</td>";
			gbInnerHtml += "<td>"+value.status+"</td>";
			gbInnerHtml += "</tr>";
			
			/* gbInnerHtml += "<tr data-code='" + value.seq + "'>";
			gbInnerHtml += "<td class='mdl-data-table__cell--non-numeric'>"+no+"</td>";
			gbInnerHtml += "<td class='mdl-data-table__cell--non-numeric'>"+value.org_nm+"</td>";
			gbInnerHtml += "<td class='mdl-data-table__cell--non-numeric'>"+value.user_name+"</td>";
			gbInnerHtml += "<td class='mdl-data-table__cell--non-numeric'>"+value.title+"</td>";
			gbInnerHtml += "<td class='mdl-data-table__cell--non-numeric'>"+value.insert_dt+"</td>";
			gbInnerHtml += "<td class='mdl-data-table__cell--non-numeric'>"+value.type+"</td>";
			gbInnerHtml += "<td class='mdl-data-table__cell--non-numeric'>"+value.status+"</td>";
			gbInnerHtml += "</tr>"; 
		
		});	 
	}else{ 
		gbInnerHtml += "<tr><td colspan='7'>등록된 글이 없습니다. </td></tr>";
	}
	
	startPage = data.pagingVo.startPage;
	endPage = data.pagingVo.endPage; 
	totalPageSize = data.pagingVo.totalPageSize;
	currentPage = data.pagingVo.currentPage;
	totalRecordSize = data.pagingVo.totalRecordSize; 
	//searchView("classMngrList", currentPage);
	console.log(startPage,endPage,totalPageSize,currentPage,totalRecordSize);
	$('#count').html("총: "+numberWithCommas(totalRecordSize)+"건 | 접수: "+data.cVo.receipt+"건 | 답변완료: "+data.cVo.complete+"건 | 진행중: "+data.cVo.progress);
	$("#mngeListInfoCurrentPage").val(currentPage);
	var viewName='classMngrList';
	if(totalRecordSize > 0){
		$("#page_num").html(getPaging(startPage,endPage,totalPageSize,currentPage,'\''+viewName+'\''));
	}
	$('#pageGrideInMngrListTb').append(gbInnerHtml);
}) */
}

var receipt = 0;
var complete = 0;
var progress = 0;
//기술지원 리스트
var tchnlgyGetSuccess = function(data, status, xhr, groupId){
	var gbInnerHtml = "";
	var classGroupList = data.list;
	$('#pageGrideInMngrListTb').empty();
	if( data.list.length > 0 ){
		$.each(data.list, function(index, value) {
			var no = data.pagingVo.totalRecordSize -(index ) - ((data.pagingVo.currentPage-1)*10);
			var type = value.type;
			if(value.type_detail == "local")
				type += "(현장)";
			else if(value.type_detail == "remote")
				type += "(원격)";
			if(value.status == "답변완료")
				complete++;
			else if(value.status == "접수")
				receipt++;
			else if(value.status == "진행중")
				progress++;
			
			gbInnerHtml += "<tr>";	
			gbInnerHtml += "<td>"+value.seq+"</td>";
			if(value.state == "C")
				gbInnerHtml += "<td>전화접수</td>";
			else
				gbInnerHtml += "<td>온라인접수</td>";
			gbInnerHtml += "<td>"+value.org_nm+"</td>";
			gbInnerHtml += "<td class=\"t_left\"><a href=\"javascript:view("+value.seq+","+data.pagingVo.currentPage+")\">"+value.title+"</a></td>";
			gbInnerHtml += "<td>"+value.user_name+"</td>";
			gbInnerHtml += "<td>"+value.insert_dt+"</td>";
			gbInnerHtml += "<td>"+type+"</td>";
			gbInnerHtml += "<td>"+value.status+"</td>";
			gbInnerHtml += "</tr>";
			
			/* gbInnerHtml += "<tr data-code='" + value.seq + "'>";
			gbInnerHtml += "<td class='mdl-data-table__cell--non-numeric'>"+no+"</td>";
			gbInnerHtml += "<td class='mdl-data-table__cell--non-numeric'>"+value.org_nm+"</td>";
			gbInnerHtml += "<td class='mdl-data-table__cell--non-numeric'>"+value.user_name+"</td>";
			gbInnerHtml += "<td class='mdl-data-table__cell--non-numeric'>"+value.title+"</td>";
			gbInnerHtml += "<td class='mdl-data-table__cell--non-numeric'>"+value.insert_dt+"</td>";
			gbInnerHtml += "<td class='mdl-data-table__cell--non-numeric'>"+value.type+"</td>";
			gbInnerHtml += "<td class='mdl-data-table__cell--non-numeric'>"+value.status+"</td>";
			gbInnerHtml += "</tr>"; */
		
		});	 
	}else{ 
		gbInnerHtml += "<tr><td colspan='7'>등록된 글이 없습니다. </td></tr>";
	}
	
	startPage = data.pagingVo.startPage;
	endPage = data.pagingVo.endPage; 
	totalPageSize = data.pagingVo.totalPageSize;
	currentPage = data.pagingVo.currentPage;
	totalRecordSize = data.pagingVo.totalRecordSize; 
	//searchView("classMngrList", currentPage);
	console.log(startPage,endPage,totalPageSize,currentPage,totalRecordSize);
	$('#count').html("총등록 : "+numberWithCommas(totalRecordSize)+"건 | 진행중: "+(parseInt(data.cVo.progress)+parseInt(data.cVo.receipt)) + "건 | 답변완료: "+data.cVo.complete+"건");
	//$("#mngeListInfoCurrentPage").val(currentPage);
	//history.pushState({list: data.list, page: data.pagingVo.currentPage},'', '/tchnlgy/tchnlgyList/page' + data.pagingVo.currentPage);
	var viewName='classMngrList';
	if(totalRecordSize > 0){
		$("#page_num").html(getPaging(startPage,endPage,totalPageSize,currentPage,'\''+viewName+'\''));
	}
	$('#pageGrideInMngrListTb').append(gbInnerHtml);
} 
</script>
<body>
	<%@ include file="../template/topMenu.jsp" %>
	<%@ include file="../template/topNav.jsp" %>
	
	<div class="hamo_container">
            <div class="content_con" >
					
	<!-- content list -->
                <div class="con_box">
                  <h2>장애처리</h2>
                  <ul class="location"></ul>

                <ul class="search_area">
                  <li>
                    <label for="date_fr"></label><input type="text" name="date_fr" id="date_fr" class="input_type1" value="${today}"/>
                    <a href="#divCalendar" class="btn_cal" onclick="openCalendar(document.getElementById('date_fr')); return false;"><img src="/images/datepicker-icon.png" style="width:37px; height:37px;" alt="달력버튼"/></a>
                     ~
                    <label for="date_to"></label><input type="text" name="date_to" id="date_to" class="input_type1" />
                    <a href="#divCalendar" class="btn_cal" onclick="openCalendar(document.getElementById('date_to')); return false;"><img src="/images/datepicker-icon.png" style="width:37px; height:37px;" alt="달력버튼"/></a>
                    <button type="button" class="btn_type3" id="excelBtn"> 엑셀다운로드</button>
                  </li>
                  <li>
                    <!-- 검색 -->
                    <form id="bform" name="bform">
                    <div class="top_search">
                        <select id="keyWord" name="keyWord" title="keyWord" class="sel_type1">
                            <option value="0">전체</option>
								<option value="1">사지방</option>
								<option value="2">이름</option>
								<option value="3">종류</option>
								<option value="4">상태</option>
								<option value="5">이슈번호</option>
								<option value="6">접수구분</option>
                        </select>
                        <label for="txtSearch"></label><input type="text" name="txtSearch" id="txtSearch" class="input_type1" />
                       <button type="button" class="btn_type3" onclick="javascript:getList();"> 검색</button>
                       <!-- <input type="button" class="btn_type3" onclick="javascript:getList();" value="검색" /> -->
                    </div><!-- //검색 -->
                  </li>       
                </ul>
                    
                    <div id="count" style="margin-top: 10px;"></div>
				<input type="hidden" name="mngeListInfoCurrentPage" id="mngeListInfoCurrentPage" value=""/>
                    <div class="board_list mT20">
                        <table>
                            <colgroup>
                                <col style="width:7%;" />
                                <col style="width:8%;" />
                                <col style="width:8%;" />
                                <col style="width:32%;" />
                                <col style="width:12%;" />
                                <col style="width:10%;" />
                                <col style="width:10%;" />
                                <col />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>이슈번호</th>
                                    <th>구분</th>
                                    <th>사지방</th>
                                    <th>제목</th>
                                    <th>이름</th>
                                    <th>등록일</th>
                                    <th>종류</th>
                                    <th>상태</th>
                                </tr>
                            </thead>
                            <tbody id="pageGrideInMngrListTb"></tbody>
                        </table>
                    </div><!-- //List -->
                    <div class="right mT20">
                        <button type="button" class="btn_type2" id="btn_insert">등록</button>
                    </div>
                    <!-- page number -->
                    <div class="page_num" id="page_num">
                    </div>
                    </form>
                </div><!-- //con_box -->
            </div>
        </div><!-- //content -->

		<%@ include file="../template/footer.jsp" %>
</body>
</html>
