<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>

 <script type="text/javascript">
 $(function() {	

		$('#user_id').change(function() { 
			$('#id_check').val('');
		});
	});
	var mailFilter = /^[_a-zA-Z0-9-\.]+@[\.a-zA-Z0-9-]+\.[a-zA-Z]+$/;
	var phoneFilter = /^(01[016789]{1}|02|0[3-9]{1}[0-9]{1})-?[0-9]{3,4}-?[0-9]{4}$/;
	var pwdFilter = /^[_a-zA-Z0-9!#$%&()*+\.:;<=>?@{|}~-]{4,}$/;

	/*  $(function() {
		if($("#abroad_code").val("")){
			$("#abroad_code").prepend("<option value=''>공관 선택</option>");
		}
	});  */
	function goSave(){
		
		if(vaildCheck()) return;
		var gubun = $("#gubun option:checked").val();
		$('#gubun').val(gubun);
		console.log($('#gubun').val());
		//alert($('#deptno option:selected').text());
		//$('form[name=frm] input[name=deptname]').val($('#deptno option:selected').text());
		
		var msg = "저장하시겠습니까?";
	    if(!confirm(msg)){
	    	return false;
	    }
	    
		$.ajax({
			type:"POST",
			url: "<c:url value='save.do'/>",
			data :  $("#frm").serialize(),
			dataType : "json",
			success: function(data, textStatus, jqXHR){
			   alert('성공적으로 저장 되었습니다.');
			   location.href = "list.do";
			},
			error : function(jqXHR, textStatus, errorThrown) {
				alert("저장시 에러 : "+" "+ textStatus);
			}
		});	
	}

	function vaildCheck()
	{
		if($('#user_id').val() == '')
		{
			alert('아이디는 필수 입력 입니다.');
			$('#user_id').focus();
			return true;
		}
		
		/* if($('#id_check').val() == '')
		{
			alert('아이디 중복 체크를 확인해 주세요.');
			$('#idCheck').focus();
			return true;
		} */
		
		if($('#gubun').val() == '')
		{
			alert('활성여부는 필수 입력 입니다.');
			$('#grade').focus();
			return true;
		}
		
		if($('#pass_wd').val() == '')
		{
			alert('비밀번호는 필수 입력 입니다.');
			$('#pass_wd').focus();
			return true;
		}
		
		if($('#pass_wd_cfm').val() == '')
		{
			alert('비밀번호 확인은 필수 입력 입니다.');
			$('#pass_wd_cfm').focus();
			return true;
		}
		
		if($('#pass_wd').val() != $('#pass_wd_cfm').val())
		{
			alert('비밀번호와 비밀번호 확인이 다릅니다.');
			$('#pass_wd_cfm').focus();
			return true;
		}
		
		/* if(String($('#pass_wd').val()).search (pwdFilter) < 0)
		{
			alert('비밀번호는 영숫자와 특수문자(!#$%&()*+-.:;<=>?@^_{|}~)를 조합하여 4자이상으로 입력하세요.');
			$('#pwd_no').val('');
			$('#pwd_no').focus();
			return true;
		} */
		
		/* if(String($('#pass_wd_cfm').val()).search (pwdFilter) < 0)
		{
			alert('비밀번호는 영숫자와 특수문자(!#$%&()*+-.:;<=>?@^_{|}~)를 조합하여 4자이상으로 입력하세요.');
			$('#pwd_no_cfm').val('');
			$('#pwd_no_cfm').focus();
			return true;
		} */
		
		if($('#user_name').val() == '')
		{
			alert('성명은 필수 입력 입니다.');
			$('#user_name').focus();
			return true;
		}
		
		/* if(String($('#phone_no').val()).search (phoneFilter) < 0)
		{
			alert('올바른 전화번호를 입력하세요.');
			$('#phone_no').val('');
			$('#phone_no').focus();
			return true;
		} */
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
		//alert($('#deptno option:selected').text());
		var gubun = $("#gubun option:checked").val();
		$('#gubun').val(gubun);
		
		/* if($('#user_id').val() != $('#old_user_id').val())
		{
			if($('#id_check').val() == '')
			{
				alert('아이디 중복 체크를 확인해 주세요.');
				$('#idCheck').focus();
				return true;
			}
		} */
		
		/* if($('#grade').val() == '')
		{
			alert('등급을 선택해 주세요.');
			$('#grade').focus();
			return;
		} */
		
		if($('#pass_wd').val() != $('#pass_wd_cfm').val())
		{
			alert('비밀번호와 비밀번호 확인이 다릅니다.');
			$('#pass_wd_cfm').focus();
			return true;
		}
		
		if($('#pass_wd').val() != '')
		{
			/* if(String($('#pass_wd').val()).search (pwdFilter) < 0)
			{
				alert('비밀번호는 영숫자와 특수문자(!#$%&()*+-.:;<=>?@^_{|}~)를 조합하여 4자이상으로 입력하세요.');
				$('#pass_wd').val('');
				$('#pass_wd').focus();
				return true;
			} */
		}
		
		if($('#pass_wd_cfm').val() != '')
		{
			/* if(String($('#pass_wd_cfm').val()).search (pwdFilter) < 0)
			{
				alert('비밀번호는 영숫자와 특수문자(!#$%&()*+-.:;<=>?@^_{|}~)를 조합하여 4자이상으로 입력하세요.');
				$('#pass_wd_cfm').val('');
				$('#pass_wd_cfm').focus();
				return true;
			} */
		}
		
		/* if(String($('#phone_no').val()).search (phoneFilter) < 0)
		{
			alert('올바른 전화번호를 입력하세요.');
			$('#phone_no').val('');
			$('#phone_no').focus();
			return;
		} */
		
		/* if(String($('#email').val()).search (mailFilter) < 0)
		{
			alert('올바른 메일주소를 입력하세요.');
			$('#email').val('');
			$('#email').focus();
			return;
		} */

		var msg = "${result.user_name}(${result.user_id})님 정보를 수정하시겠습니까?";
	    if(!confirm(msg)){
	    	return false;
	    }
	    
		$.ajax({
			type:"POST",
			url: "<c:url value='modify.do'/>",
			data :  $("#frm").serialize(),
			dataType : "json",
			success: function(data, textStatus, jqXHR){
			   alert('성공적으로 수정 되었습니다.');
			   location.href = "list.do";
			},
			error : function(jqXHR, textStatus, errorThrown) {
				alert("수정시 에러 : "+" "+ textStatus);
			}
		});	
	}
	
	function goDelete(){
		//$('#user_id').val(param);
		
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
</script>    
<body>

	<%@ include file="../template/topMenu.jsp" %>
	<%@ include file="../template/topNav.jsp" %>
	

<form id="frm" name="frm" action="" method="post">
<!-- <input type="hidden" id="user_id" name="user_id" />
<input type="hidden" id="page_no" name="page_no" /> -->
<table class="table table-striped">
  <colgroup>
			<col style="width:120px" />
			<col />
			<col style="width:120px" />
			<col />
		</colgroup>
  <tbody>
    <tr>
      <th scope="col">ID</th>
      <td colspan="3">
		<c:if test="${result.user_id ne null}">
			<input type="text" value="${result.user_id}" name="user_id" id="user_id"  class="text date2" maxlength="30" readonly/>
		</c:if>
		<c:if test="${result.user_id eq null}">
			<input type="text" value="${result.user_id}" name="user_id" id="user_id"  class="text date2" maxlength="30"/>
		</c:if>
		 <button type="button" onclick="goIdCheck()" class="btn">중복아이디 검색</button> 
	</td>
	</tr>
	<tr>
				<th><label for="grade"><span class="req">필수입력</span> 활성여부</label></th>
				<td colspan="3">
				<label for="gubunA"><input type="radio" value="A" name="gubun" id="gubunA" <c:if test="${result.gubun eq 'A' }">checked</c:if>/>활성 </label>
				<label for="gubunD"><input type="radio" value="D" name="gubun" id="gubunD" <c:if test="${result.gubun eq 'D' }">checked</c:if>/>비활성</label>
				</td>
			</tr>
			<tr>
				<th><label for="pass_wd"><span class="req">필수입력</span> 비밀번호</label></th>
				<td>
				    <input type="password" value="" name="pass_wd" id="pass_wd" maxlength="15" />
				</td>
				<th><label for="pass_wd_cfm"><span class="req">필수입력</span> 비밀번호 확인</label></th>
				<td>
				    <input type="password" value="" name="pass_wd_cfm" id="pass_wd_cfm" maxlength="15" />
				</td>
			</tr>
			<tr>
				<th><label for="user_name"><span class="req">필수입력</span> 성명</label></th>
				<td>
				    <input type="text" value="${result.user_name}" name="user_name" id="user_name" maxlength="20" />
				</td>
				<th><label for="dept_name"> 담당부서</label></th>
				<td>
				    <input type="text" value="${result.dept_name}" name="dept_name" id="dept_name" maxlength="20" />
			    </td>
			
			</tr>
  </tbody>
</table>
<div class="btn_area"> 
	<c:choose> 
		<c:when test="${result.user_id == null}"> 
			<button type="button" onclick="goSave()" class="btn act">등록</button>
		</c:when>
		<c:otherwise>
			<button type="button" onclick="goModify()" class="btn act">수정</button>
			<button type="button" onclick="goDelete()" class="btn act">삭제</button>
		</c:otherwise>
	</c:choose>
	<a href="<c:url value='list.do'/>" class="btn nav">목록</a>
</div>
</form>
</body>
</html>