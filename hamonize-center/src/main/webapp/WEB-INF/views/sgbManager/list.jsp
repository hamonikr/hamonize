<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>
<script type="text/javascript" src="/js/common.js"></script>
 <script type="text/javascript">
 $(function() {
	 
	 setNav('설정 > 부서 관리자 등록관리');
	   	$('#searchBtn').click(function(){ goSearch(); });
	 	var startPage = ${paging.startPage};
		var endPage = ${paging.endPage}; 
		var totalPageSize = ${paging.totalPageSize};
		var currentPage = ${paging.currentPage};
		var totalRecordSize = ${paging.totalRecordSize}; 
		
		console.log(startPage);
		console.log(endPage);
		console.log(totalPageSize);
		console.log(currentPage);
		console.log(totalRecordSize);
		
		var viewName='classMngrList';
		if(totalRecordSize > 0){
			$(".page_num").html(getPaging(startPage,endPage,totalPageSize,currentPage,'\''+viewName+'\''));
		}
	});

	function goSearch()
	{
		$('#frm').attr('action', '<c:url value="managerlist.do" />');
		$('#frm').submit();
	}

	function view(param1)
	{
		$('#user_id').val(param1);
		$('#frm').attr('action', '<c:url value="managerview.do" />');
		$('#frm').submit();
	}

	//로그인 삭제
	function goDelete(param){
		$('#user_id').val(param);
		
		var msg = "삭제하시겠습니까?";
	    if(!confirm(msg)){
	    	return false;
	    }	
		$.ajax({
			type:"POST",
			url: "<c:url value='managerdelete.do'/>",
			data :  $("#frm").serialize(),
			dataType : "json",
			success: function(data, textStatus, jqXHR){
			   alert('성공적으로 삭제 되었습니다.');
			   location.href = "list.do";
			},
			error : function(jqXHR, textStatus, errorThrown) {
				alert("삭제시 에러 : "+" "+ textStatus);
			}
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
			case 'classMngrList' : $("#currentPage").val(page); 
			console.log($("#currentPage").val())
			$('#frm').attr('action', '<c:url value="managerlist.do" />');
			$('#frm').submit();
             break;	
		default :
		}
	}
</script>    
<body>

	<%@ include file="../template/topMenu.jsp" %>
	<%@ include file="../template/topNav.jsp" %>
	

<form id="frm" name="frm" action="" method="post">
<input type="hidden" id="user_id" name="user_id" />
<input type="hidden" id="currentPage" name="currentPage" value="1"/>
<!-- content -->
        <div class="hamo_container">
            <div class="content_con">
                <!-- content list -->
                <div class="con_box">
                   <h2>부서 관리</h2>
                  <ul class="location">
                  </ul>
                
                    <!-- 검색 -->
                    <div class="top_search w100">
                        <select id="keyWord" name="keyWord" title="keyWord" class="sel_type1">
                            <option value="0">전체</option>
                            <option value="1" <c:if test="${keyWord eq '1' }">selected</c:if>>ID</option>
                            <option value="2" <c:if test="${keyWord eq '2' }">selected</c:if>>성명</option>
                        </select>
                        <label for="txtSearch"></label><input type="text" name="txtSearch" id="txtSearch" value="${txtSearch }" class="input_type1" />
                        <button type="button" class="btn_type3" id="searchBtn"> 검색</button>
                    </div><!-- //검색 -->

                    <div class="board_list mT20">
                        <table>
                            <colgroup>
                                <col style="width:10%;" />
                                <col style="width:15%;" />
                                <col style="width:20%;" />
                                <col style="width:20%;" />
                                <col />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>번호</th>
                                    <th>ID</th>
                                    <th>성명</th>
                                    <th>직급</th>
                                    <th>등록일</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="list" items="${aList}" varStatus="status">
								    <tr>
								      <th scope="row">${paging.totalRecordSize - ((paging.currentPage-1) * paging.recordSize + status.index)}</th>
								      <td><a href="javascript:view('${list.user_id}')">${list.user_id}</a></td>
								      <td>${list.user_name}</td>
								      <td>${list.rank}</td>
								      <fmt:parseDate var="dateString" value="${list.insert_dt}" pattern="yyyy-MM-dd HH:mm:ss" />
								      <td><fmt:formatDate value="${dateString}" pattern="yyyy-MM-dd" /></td>
								    </tr>
								</c:forEach>
                            </tbody>
                        </table>
                    </div><!-- //List -->
                    <div class="right mT20">
                        <button type="button" class="btn_type2" onclick="location.href='managerview.do'"> 관리자 등록</button>
                    </div>
                    <!-- page number -->
                    <div class="page_num">
                    </div>
                </div><!-- //con_box -->
            </div>
        </div><!-- //content -->
        </form>
		<%@ include file="../template/footer.jsp" %>
</body>
</html>
