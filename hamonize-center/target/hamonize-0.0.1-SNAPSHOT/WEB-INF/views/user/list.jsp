<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>

 <script type="text/javascript">
 $(function() {
	 
	 setNav('설정 > 관리자등록관리');
	   	//$('#search').click(function(){ goSearch(); });
	    
	});

	function goSearch()
	{
		$('#frm').attr('action', '<c:url value="list.do" />');
		$('#frm').submit();
	}

	function view(param1)
	{
		$('#user_id').val(param1);
		$('#frm').attr('action', '<c:url value="view.do" />');
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
			url: "<c:url value='delete.do'/>",
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

	function pageNavigation(pageNo)
	{
		$('#page_no').val(pageNo);
		$('#frm').attr('action', '<c:url value="list.do" />');
		$('#frm').submit();
	}
</script>    
<body>

	<%@ include file="../template/topMenu.jsp" %>
	<%@ include file="../template/topNav.jsp" %>
	

<form id="frm" name="frm" action="" method="post">
<input type="hidden" id="user_id" name="user_id" />
<input type="hidden" id="page_no" name="page_no" />
<p id="contentTitle">유저등록관리</p>
<table class="table table-striped">
  <thead>
    <tr>
      <th scope="col">번호</th>
      <th scope="col">소속부대</th>
      <th scope="col">계급</th>
      <th scope="col">성명</th>
      <th scope="col">나라사랑카드</th>
      <th scope="col">담당부서</th>
      <th scope="col">등록일</th>
    </tr>
  </thead>
  <tbody>
  <c:forEach var="list" items="${aList}" varStatus="status">
    <tr> 
      <th scope="row">1</th>
      <td><a href="javascript:view('${list.user_id}')">${list.user_id}</a></td>
      <td>${list.user_name}</td>
      <td>${list.dept_name}</td>
      <td><fmt:formatDate value="${list.insert_dt}" pattern="YYYY-MM-dd" /></td>
    </tr>
     </c:forEach>
  </tbody>
</table>
<div class="btn_area">
	<a href="<c:url value='view.do'/>" class="btn act">관리자등록</a>
</div>
</form>
</body>
</html>