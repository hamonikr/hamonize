<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>

<script type="text/javascript" src="/js/common.js"></script>
<script type="text/javascript">

	$(document).ready(function(){
		setNav('공지사항');
		$("#btn_insert").click(function(){
			location.href="noticeInsert";
		});
		 $("#txtSearch").keydown(function(key) {
		if (key.keyCode == 13) {
			key.preventDefault();
			getList();
		}
		}); 

	getList();
		
	});
	
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
			case 'classMngrList' :  $("#mngeListInfoCurrentPage").val(page); getList(); break;
		default :
		}
	}

	function view(noti_seq){
		var $form = $('<form></form>').attr('action','/notice/noticeDetail.acnt').attr('method','POST');
		var $ipt = $('<input type="hidden" name="noti_seq" />').val(noti_seq);
		$form.append($ipt).appendTo('form').submit();
	}

	function getList(){
		var url ='/notice/notice.proc';
		var keyWord = $("select[name=keyWord]").val();
		var vData = 'mngeListInfoCurrentPage=' + $("#mngeListInfoCurrentPage").val() +"&keyWord="+ keyWord + "&txtSearch=" + $("#txtSearch").val();
		callAjax('POST', url, vData, mngrGetSuccess, getError, 'json');
	}

	//공지사항 리스트
	var mngrGetSuccess = function(data, status, xhr, groupId){
		var gbInnerHtml = "";
		var classGroupList = data.list;
		$('#pageGrideInMngrListTb').empty();
		if( data.list.length > 0 ){
			$.each(data.list, function(index, value) {
				var no = data.pagingVo.totalRecordSize -(index ) - ((data.pagingVo.currentPage-1)*10);
				
				gbInnerHtml += "<tr>";
				gbInnerHtml += "<td>"+no+"</td>";
				gbInnerHtml += "<td>"+value.noti_group+"</td>";
				gbInnerHtml += "<td>"+value.orgname+"</td>";
				gbInnerHtml += "<td>"+value.noti_rank+"</td>";
				gbInnerHtml += "<td class=\"t_left\"><a href=\"javascript:view("+value.noti_seq+")\">"+value.noti_title+"</a></td>";
				gbInnerHtml += "<td>"+value.first_date+"</td>";
				gbInnerHtml += "<td>"+value.hit+"</td>";
				gbInnerHtml += "<td></td>";
				gbInnerHtml += "</tr>";

			
			});	 
		}else{ 
			gbInnerHtml += "<tr><td colspan='8'>등록된 글이 없습니다. </td></tr>";
		}
		
		var startPage = data.pagingVo.startPage;
		var endPage = data.pagingVo.endPage; 
		var totalPageSize = data.pagingVo.totalPageSize;
		var currentPage = data.pagingVo.currentPage;
		var totalRecordSize = data.pagingVo.totalRecordSize;
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
            <div class="content_con">

                <!-- content list -->
                <div class="con_box">

                    <h2>공지사항</h2>
                    <ul class="location"> </ul>

                    <!-- 검색 -->
                    <form>
                    <div class="top_search">
                        <select id="keyWord" name="keyWord" title="" class="sel_type1">
                            <option value="0">전체</option>
                            <option value="1">글 제목</option>
                            <option value="2">글 내용</option>
                            <option value="3">부대명</option>
                        </select>
                        <label for="txtSearch"></label><input type="text" name="txtSearch" id="txtSearch" class="input_type1" />
                        <button type="button"  class="btn_type3" onclick="javascript:getList();">검색</button>
                        
                    </div><!-- //검색 -->
                    </form>
						<input type="hidden" id="mngeListInfoCurrentPage" name="mngeListInfoCurrentPage" value="1" >
                    <div class="board_list mT20">
                        <table>
                            <colgroup>
                                <col style="width:7%;" />
                                <col style="width:8%;" />
                                <col style="width:12%;" />
                                <col style="width:10%;" />
                                <col style="width:40%;" />
                                <col style="width:10%;" />
                                <col style="width:8%;" />
                                <col />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>번호</th>
                                    <th>등급</th>
                                    <th>부대</th>
                                    <th>계급</th>
                                    <th>제목</th>
                                    <th>작성일</th>
                                    <th>조회수</th>
                                    <th>첨부</th>
                                </tr>
                            </thead>
                            <tbody id="pageGrideInMngrListTb">
                            </tbody>
                        </table>
                    </div><!-- //List -->
                    <div class="right mT20">
                        <button type="button" class="btn_type2" id="btn_insert"> 공지등록</button>
                    </div>
                    <!-- page number -->
                    <div class="page_num" id="page_num">
                    </div>
                </div><!-- //con_box -->
            </div>
        </div><!-- //content -->
		<%@ include file="../template/footer.jsp" %>
</body>
</html>
