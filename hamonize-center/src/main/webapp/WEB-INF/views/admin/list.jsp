<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>
<%@ include file="../template/topMenu.jsp" %>
<script type="text/javascript" src="/js/common.js"></script>

<script type="text/javascript">
	$(function() {
		setNav('설정 > 관리자 등록 관리');
		var startPage = ${paging.startPage};
		var endPage = ${paging.endPage}; 
		var totalPageSize = ${paging.totalPageSize};
		var currentPage = ${paging.currentPage};
		var totalRecordSize = ${paging.totalRecordSize}; 
   
		var viewName='classMngrList';
		if(totalRecordSize > 0){
			$(".page_num").html(getPaging(startPage,endPage,totalPageSize,currentPage,'\''+viewName+'\''));
		}
	});
   
	  
	function view(param1){
		$('#user_id').val(param1);
		$('#frm').attr('action', '<c:url value="view" />');
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
			   url: "<c:url value='delete'/>",
			   data :  $("#frm").serialize(),
			   dataType : "json",
			   success: function(data, textStatus, jqXHR){
				  alert('성공적으로 삭제 되었습니다.');
				  location.href = "list";
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
			   case 'classMngrList' : $("#adminListInfoCurrentPage").val(page); 
			   console.log($("#adminListInfoCurrentPage").val())
			   $('#frm').attr('action', '<c:url value="list" />');
			   $('#frm').submit();
				break;	
		   default :
		   }
	   }
</script>  

<body>
<div class="hamo_container other">
	<div class="content_con">
		<div class="con_box">
			<h2>관리자 정보 목록</h2>

		<form id="frm" name="frm" method="post">
		<input type="hidden" id="user_id" name="user_id" />
		<input type="hidden" id="adminListInfoCurrentPage" name="adminListInfoCurrentPage" value="1"/>

			<div class="board_list mT20">
				<table>
					<colgroup>
						<col style="width:10%;" />
						<col style="width:15%;" />
						<col style="width:20%;" />
						<col />
					</colgroup>
					<thead>
						<tr>
							<th>번호</th>
							<th>ID</th>
							<th>성명</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="list" items="${aList}" varStatus="status">
							<tr>
								<td scope="row">${paging.totalRecordSize - ((paging.currentPage-1) * paging.recordSize + status.index)}</td>
								<td><a style="color: steelblue;" href="javascript:view('${list.user_id}')">${list.user_id}</a></td>
								<td>${list.user_name}</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div><!-- //List -->
		</div><!-- //con_box -->
		</form>
	</div>
</div><!-- //content -->

<%@ include file="../template/footer.jsp" %>
  
</body>
</html>
