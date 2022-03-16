<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>
<%-- select2 --%>
<link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.9/css/select2.min.css" rel="stylesheet" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.9/js/select2.min.js"></script>

<%-- date picker --%>
<link rel="stylesheet" href="/bootstrap-datepicker/css/bootstrap.min.css"/>
<link rel="stylesheet" href="/bootstrap-datepicker/css/bootstrap-datepicker.css"/>
<script src="/bootstrap-datepicker/js/bootstrap-datepicker.js"></script>
<script src="/bootstrap-datepicker/js/bootstrap-datepicker.ko.min.js"></script>

<style>
a:link {
  color: green;
  background-color: transparent;
  text-decoration: none;
}
</style>


<script type="text/javascript">
 $(function() {	
		$('#user_id').change(function() { 
			$('#id_check').val('');
		});
	});
	
	var mailFilter = /^[_a-zA-Z0-9-\.]+@[\.a-zA-Z0-9-]+\.[a-zA-Z]+$/;
	var phoneFilter = /^(01[016789]{1}|02|0[3-9]{1}[0-9]{1})-?[0-9]{3,4}-?[0-9]{4}$/;
	var pwdFilter = /^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{6,25}$/;
	

	function vaildCheck()
	{
		if($('#user_id').val() == '')
		{
			alert('아이디는 필수 입력 입니다.');
			$('#user_id').focus();
			return true;
		}
		
		 if($('#id_check').val() == '')
		{
			alert('아이디 중복 체크를 확인해 주세요.');
			$('#idCheck').focus();
			return true;
		} 
		 
		 	if($('#user_sabun').val() == '')
		{
			alert('사번은 필수 입력 입니다.');
			$('#user_sabun').focus();
			return true;
		}
	

		
		if($('#user_name').val() == '')
		{
			alert('성명은 필수 입력 입니다.');
			$('#user_name').focus();
			return true;
		}
		
	}

	 function goIdCheck()
	{
		if($('#user_id').val() == '')
		{
			alert('아이디를 입력해 주세요.');
			$('#user_id').focus();
			return;
		}
		
		$.ajax({
			type:"POST",
			url: "<c:url value='idDuplCheck.do'/>",
			data :  $("#frm").serialize(),
			dataType : "json",
			success: function(data, textStatus, jqXHR){
				console.log(data)
			  if(data == 1)
			  {
				  alert("[ "+$('#user_id').val()+" ] 이미 중복된 아이디입니다.다시 확인해 하세요.");
				  $('#user_id').val('');
				  $('#user_id').focus();
				  return;
			  }
			  else
			  {
				  alert("사용 가능한 아이디 입니다.");
				  $('#id_check').val('S');
			  }
			  
			},
			error : function(jqXHR, textStatus, errorThrown) {
				alert("idCheckError : "+" "+ textStatus);
			}
		});	
	} 

	function goModify(){
		var gubun = $("#gubun option:checked").val();
		$('#gubun').val(gubun);
		

		var msg = "${result.user_name}(${result.user_id})님 정보를 수정하시겠습니까?";
	    if(!confirm(msg)){
	    	return false;
	    }
	    



		$.ajax({
			type:"POST",
			url: "/user/modify",
			data :  $("#frm").serialize(),
			dataType : "json",
			success: function(data, textStatus, jqXHR){
			   alert('성공적으로 수정 되었습니다.');
			   location.href = "/user/userList";
			},
			error : function(jqXHR, textStatus, errorThrown) {
				alert("수정시 에러 : "+" "+ textStatus);
			}
		});	
	}

</script>    
<body>

<%@ include file="../template/topMenu.jsp" %>

<jsp:useBean id="now" class="java.util.Date" />
<fmt:formatDate value="${now}" pattern="yyyy-MM-dd" var="today" />

<form id="frm" name="frm" action="" method="post">
<input type="hidden" id="id_check" name="id_check" />
<input type="hidden" id="sabun_check" name="sabun_check" />

<!-- content -->
    <div class="hamo_container">
        <div class="content_con">

            
            <!-- content list -->
            <div class="con_box">
              <h2>사용자 등록</h2>
              <ul class="location">
                  <li>Home</li>
                  <li>사용자 등록</li>
              </ul>

                <div class="board_view mT20">
                    <table>
                        <colgroup>
                            <col style="width:30%;" />
                            <col style="width:70%;" />
                            <col />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th>* ID</th>
                                <td colspan="3">
                                    <label for="user_id" class="none"></label>
                                    <input type="text" name="user_id" id="user_id" value="${result.user_id}" class="input_type1 w50" <c:if test="${result.user_id ne null}">readonly</c:if> />
                                    <c:if test="${result.user_id eq null}"><button type="button" class="btn_type1" onclick="goIdCheck()"> 아이디 중복확인 </button></c:if>
                                </td>
                            </tr>
                            <tr>
								<c:if test="${result.gubun != null}" >
								<th>* 활성여부</th>
								<td colspan="3">
									<input type="radio" name="gubun" id="gubunA" value="A" <c:if test="${result.gubun eq 'A' }">checked</c:if> /><label for="gubunA" class="pR20">활성</label>
									<input type="radio" name="gubun" id="gubunD" value="D" <c:if test="${result.gubun eq 'D' }">checked</c:if> /><label for="gubunD" class="pR20">휴직</label>
									<input type="radio" name="gubun" id="gubunR" value="R" <c:if test="${result.gubun eq 'R' }">checked</c:if> /><label for="gubunR">퇴사</label>
								</td>
								</c:if>
                            </tr>
                            <tr>
                                <th>* 성명</th>
                                <td><label for="user_name" class="none"></label><input type="text" name="user_name" id="user_name" value="${result.user_name}" class="input_type1 w100" /></td>
                            </tr>
							<tr>
								<th>* 팀</th>
								<td colspan="3">
									<label for="org_seq" class="none"></label>
									<input type="hidden" id="seq" name="seq" value="${result.seq}"/>
									<select id="org_seq" name="org_seq" class="js-example-placeholder-single js-states form-control" style="width:50%;margin-left:5px">
										<c:if test="${result.org_nm != null}">
											<option value="${result.org_seq}">${result.org_nm}</option>
										</c:if>
										<c:if test="${result.org_nm ==null}">
											<option value=""></option>
										</c:if>
											<c:forEach var="list" items="${olist}"> 
												<option value="${list.seq}">${list.org_nm}</option>
											 </c:forEach>
									</select>
								</td>
							</tr>
							<tr>
								<th>* 사번</th>
								<c:if test="${result.org_nm != null}">
									<td><label for="sabun" class="none"></label><input type="text" name="user_sabun" id="user_sabun" value="${result.user_sabun}" readonly class="input_type1 w100" /></td>
								</c:if>
								<c:if test="${result.org_nm == null}">
									<td><label for="sabun" class="none"></label><input type="text" name="user_sabun" id="user_sabun" value="" class="input_type1 w100" /></td>
								</c:if>		
							</tr>
							<tr>
								<th>* 직급</th>
								<td>
								<label for="rank" class="none"></label>
								<select class="form-control" name="rank" id="rank" w100>
									<c:if test="${result.rank == null}">
										<option value="" disabled selected hidden>직급을 선택해주세요</option>
										<option value="002">사원</option>
										<option value="003">대리</option>
										<option value="004">과장</option>
										<option value="005">부장</option>
										<option value="100">관리자</option>
									</c:if>	 
									<c:if test="${result.rank != null}">
										<c:if test="${result.rank == '사원'}">
											<option value="002"  selected hidden>${result.rank}</option>
										</c:if>	
										<c:if test="${result.rank == '대리'}">
											<option value="003"  selected hidden>${result.rank}</option>
										</c:if>
										<c:if test="${result.rank == '과장'}">
											<option value="004"  selected hidden>${result.rank}</option>
										</c:if>
										<c:if test="${result.rank == '부장'}">
											<option value="005"  selected hidden>${result.rank}</option>
										</c:if>
										<c:if test="${result.rank == '관리자'}">
											<option value="100"  selected hidden>${result.rank}</option>
										</c:if>
										<option value="002">사원</option>
										<option value="003">대리</option>
										<option value="004">과장</option>
										<option value="005">부장</option>
										<option value="100">관리자</option>
									</c:if>	
								</select>
								</td>
							</tr>
							<tr>
								<th> 이메일 </th>
								<td><label for="rank" class="none"></label><input type="email" name="email" id="email" value="${result.email}" class="input_type1 w100" /></td>
							</tr>
							
							<tr>
								<th> 휴대번호 </th>
								<td><label for="rank" class="none"></label><input type="tel" name="tel" id="tel" value="${result.tel}" class="input_type1 w100"/></td>
							</tr>
                            <tr>
								<th>* 입사일</th>

								<td>
									<div class="input-group date">
										<input type="text" name="ins_date" id="datePicker" data-date-format="YYYY-MM--DD" class="form-control" value="${today}"/>	
									</div>
								
								</td>

							</tr>
                            
							<input type="hidden" name="pass_wd" id="pass_wd" value="hamonize)*" class="input_type1  w100" />
							<input type="hidden" name="pass_wd_cfm" id="pass_wd_cfm" value="hamonize)*"  class="input_type1 w100" />

                            
                        </tbody>
                    </table>
                </div><!-- //List -->
                <div class="t_center mT20">
                <c:choose> 
					<c:when test="${result.user_id == null}"> 
                    <button type="button" class="btn_type2" onclick="goSave()"> 등록</button>
                    </c:when>
                    <c:otherwise>
                    <button type="button" class="btn_type2" onclick="goModify()"> 수정</button>
                    </c:otherwise>
                    </c:choose>
                    <button type="button" class="btn_type2" onclick="location.href='/user/userList'"> 목록</button>
                </div>
            </div><!-- //con_box -->
        </div>
    </div><!-- //content -->
    </form>

<%@ include file="../template/footer.jsp" %>

</body>

<script>


function goSave(){

	if(vaildCheck()) {		
	} else{
		document.frm.action = "/user/userSave";
		document.frm.submit();
		return false;
	}
}

$(function() {		

	var gubun = $('input[name="gubun"]:checked').val();

	$("select").change(function(){
        var org_seq = $(this).children("option:selected").val();
    });


	$('#org_seq').select2({
		"language":{
			"noResults": function(){
				return "검색 결과가 없습니다.";
			}
		},
		placeholder: "팀을 선택해주세요.",
		allowClear: true 		
	});	

	$('#datePicker').datepicker({
		format: "yyyy-mm-dd",
		language : "ko",
		templates : {
			leftArrow: '&laquo;',
			rightArrow: '&raquo;'
		}, 
		showWeekDays : true ,
		todayHighlight : true ,	
		toggleActive : true,
		autoclose : true,	
		weekStart : 1
	});

});
</script>
</html>