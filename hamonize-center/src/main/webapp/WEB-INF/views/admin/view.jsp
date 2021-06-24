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
	var pwdFilter = /^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{8,25}$/;
	

	/*  $(function() {
		if($("#abroad_code").val("")){
			$("#abroad_code").prepend("<option value=''>공관 선택</option>");
		}
	});  */
	function goSave(){
		
		if(vaildCheck()) return false;
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
		
		 if($('#id_check').val() == '')
		{
			alert('아이디 중복 체크를 확인해 주세요.');
			$('#idCheck').focus();
			return true;
		} 
		 
		if($(':radio[name="gubun"]:checked').length < 1)
		{
			alert('활성여부는 필수 입력 입니다.');
			$('#gubun').focus();
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
		console.log("chkpasswd==="+$('#pass_wd').val().search(pwdFilter));
		 if(String($('#pass_wd').val()).search (pwdFilter) < 0)
		{
			 console.log("chkpasswd==="+$('#pass_wd').val().search (pwdFilter));
			alert('비밀번호는 영숫자와 특수문자(!#$%&()*+-.:;<=>?@^_{|}~)를 조합하여 8자이상으로 입력하세요.');
			$('#pwd_no').val('');
			$('#pwd_no').focus();
			return true;
		} 
		
		 if(String($('#pass_wd_cfm').val()).search (pwdFilter) < 0)
		{
			alert('비밀번호는 영숫자와 특수문자(!#$%&()*+-.:;<=>?@^_{|}~)를 조합하여 8자이상으로 입력하세요.');
			$('#pwd_no_cfm').val('');
			$('#pwd_no_cfm').focus();
			return true;
		} 
		
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
		if($('#pass_wd').val() == '')
		{
			alert('비밀번호는 필수 입력 입니다. 다시 입력해주시기 바랍니다.');
			$('#pass_wd').focus();
			return true;
		}
		
		if($('#pass_wd_cfm').val() == '')
		{
			alert('비밀번호 확인은 필수 입력 입니다. 다시 입력해주시기 바랍니다.');
			$('#pass_wd_cfm').focus();
			return true;
		}
		
		if($('#pass_wd').val() != $('#pass_wd_cfm').val())
		{
			alert('비밀번호와 비밀번호 확인이 다릅니다.');
			$('#pass_wd_cfm').focus();
			return true;
		}
		console.log("passwd==="+$('#pass_wd').val())
		if($('#pass_wd').val() != '')
		{
			 if(String($('#pass_wd').val()).search (pwdFilter) < 0)
			{
				alert('비밀번호는 영숫자와 특수문자(!#$%&()*+-.:;<=>?@^_{|}~)를 조합하여 8자이상으로 입력하세요.');
				$('#pass_wd').val('');
				$('#pass_wd').focus();
				return true;
			} 
		}
		
		if($('#pass_wd_cfm').val() != '')
		{
			 if(String($('#pass_wd_cfm').val()).search (pwdFilter) < 0)
			{
				alert('비밀번호는 영숫자와 특수문자(!#$%&()*+-.:;<=>?@^_{|}~)를 조합하여 8자이상으로 입력하세요.');
				$('#pass_wd_cfm').val('');
				$('#pass_wd_cfm').focus();
				return true;
			} 
		}
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
<input type="hidden" id="id_check" name="id_check" />
<!-- content -->
    <div class="hamo_container">
        <div class="content_con">

            
            <!-- content list -->
            <div class="con_box">
              <h2>관리자 등록관리</h2>
              <ul class="location">
                  <li>Home</li>
                  <li>Location</li>
              </ul>

                <div class="board_view mT20">
                    <table>
                        <colgroup>
                            <col style="width:15%;" />
                            <col style="width:35%;" />
                            <col style="width:15%;" />
                            <col style="width:35%;" />
                            <col />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th>ID</th>
                                <td colspan="3">
                                    <label for="user_id" class="none"></label>
                                    <input type="text" name="user_id" id="user_id" value="${result.user_id}" class="input_type1 w50" <c:if test="${result.user_id ne null}">readonly</c:if>/>
                                    <c:if test="${result.user_id eq null}"><button type="button" class="btn_type1" onclick="goIdCheck()"> 중복아이디 검색</button></c:if>
                                </td>
                            </tr>
                            <tr>
                                <th>* 활성여부</th>
                                <td colspan="3">
                                    <input type="radio" name="gubun" id="gubunA" value="A" <c:if test="${result.gubun eq 'A' }">checked</c:if> /><label for="gubunA" class="pR20">활성</label>
                                    <input type="radio" name="gubun" id="gubunD" value="D" <c:if test="${result.gubun eq 'D' }">checked</c:if> /><label for="gubunD">비활성</label>
                                </td>
                            </tr>
                            <tr>
                                <th>* 성명</th>
                                <td><label for="user_name" class="none"></label><input type="text" name="user_name" id="user_name" value="${result.user_name}" class="input_type1 w100" /></td>
                                <th>* 담당부서</th>
                                <td><label for="dept_name" class="none"></label><input type="text" name="dept_name" id="dept_name" value="${result.dept_name}" class="input_type1 w100" /></td>
                            <tr>
                            <tr>
                                <th>* 비밀번호</th>
                                <td colspan="3">
                                    <label for="pass_wd" class="none"></label><input type="password" name="pass_wd" id="pass_wd" class="input_type1" />
                                    ※ 비밀번호는 영문, 숫자, 특수문자 조합 8자리 이상
                                </td>
                            </tr>
                            <tr>
                                <th>* 비밀번호 확인</th>
                                <td colspan="3">
                                    <label for="pass_wd_cfm" class="none"></label><input type="password" name="pass_wd_cfm" id="pass_wd_cfm" class="input_type1" />
                                </td>
                            </tr>

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
                    <button type="button" class="btn_type2" onclick="goDelete()"> 삭제</button>
                    </c:otherwise>
                    </c:choose>
                    <button type="button" class="btn_type2" onclick="location.href='list.do'"> 목록</button>
                </div>
            </div><!-- //con_box -->
        </div>
    </div><!-- //content -->
    </form>


<%@ include file="../template/footer.jsp" %>

</body>
</html>