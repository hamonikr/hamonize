<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>
<style>
.ui-autocomplete {
    max-height: 200px;
    overflow-y: auto;
    /* prevent horizontal scrollbar */
    overflow-x: hidden;
    /* add padding to account for vertical scrollbar */
    padding-right: 20px;
}
/* IE 6 doesn't support max-height
 * we use height instead, but this forces the menu to always be this tall
 */
* html .ui-autocomplete {
    height: 200px;
}
.ui-menu-item .ui-menu-item-wrapper:hover
{
    border: none !important;
    background-color: #7878FF;
}
.board_view tbody td li:after {
    content: "|";
    color: #ccc;
    padding-left: 40px;
    font-size: 13px;
    display:none;
}
</style>
<script type="text/javascript" src="/js/select2.js"></script>
 <script type="text/javascript">
 $(function() {	

		$('#user_id').change(function() { 
			$('#id_check').val('');
		});
		 $("#arr_org_seq").select2({
			width: 'resolve',
			//language: 'ko',
			placeholder: '사지방을 선택하세요.',
			minimumInputLength: 2
		});
		var org_seq = $('form[name=frm] input[name=org_seq]').val();
		var org_seqsp = org_seq.split(',');
		for(var i in org_seqsp){
		$("#arr_org_seq option").each(function(){
			if($(this).val() == org_seqsp[i]){
				$("#arr_org_seq").select2('val', org_seqsp);
			}
			 }); 
		}
		
		/* var availableTags = [
			<c:forEach items="${oList}" var="data" varStatus="status" >
			{value:"${data.org_nm}",key:"${data.seq}"},
			</c:forEach>
			 ];
			
		    $( "#org-name" ).autocomplete({
		      delay: 0,	
		      minLength: 2,
		      source: availableTags,
		      focus: function( event, ui ) {
		        $( "#org-name" ).val( ui.item.value );
		        return false;
		      },
		      select: function( event, ui ) {
		        $( "#org-name" ).val( ui.item.value );
		        $( "#arr_org_seq" ).val( ui.item.key );
		 
		        return false;
		      } 
			  }); */
	});
	var mailFilter = /^[_a-zA-Z0-9-\.]+@[\.a-zA-Z0-9-]+\.[a-zA-Z]+$/;
	var phoneFilter = /^(01[016789]{1}|02|0[3-9]{1}[0-9]{1})-?[0-9]{3,4}-?[0-9]{4}$/;
	var pwdFilter = /^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{8,25}$/;

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
			url: "<c:url value='managersave.do'/>",
			data :  $("#frm").serialize(),
			dataType : "json",
			success: function(data, textStatus, jqXHR){
				if(data > 10){
					alert('이미 사용중인 아이디 입니다. 아이디를 확인해 주시기 바랍니다.');
					$('#user_id').val('');
				    $('#user_id').focus();
					return false;
				}else{
			   alert('성공적으로 저장 되었습니다.');
			   location.href = "managerlist.do";
				}
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
		 if($('#arr_org_seq').val() == '')
		{
			alert('담당사지방이 선택되지 않았습니다. 셀렉트박스 목록에서 담당사지방을 클릭으로 선택해주세요.');
			$('#idCheck').focus();
			return true;
		} 
		
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
		
		 if(String($('#pass_wd').val()).search (pwdFilter) < 0)
		{
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
			url: "<c:url value='manageridDuplCheck.do'/>",
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
		if(vaildCheck()) return;
		console.log("valval==="+$("#arr_org_seq").val())
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
			url: "<c:url value='managermodify.do'/>",
			data :  $("#frm").serialize(),
			dataType : "json",
			success: function(data, textStatus, jqXHR){
			   alert('성공적으로 수정 되었습니다.');
			   location.href = "managerlist.do";
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
			url: "<c:url value='managerdelete.do'/>",
			data :  $("#frm").serialize(),
			dataType : "json",
			success: function(data, textStatus, jqXHR){
			   alert('성공적으로 삭제 되었습니다.');
			   location.href = "managerlist.do";
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
<input type="hidden" id="org_seq" name="org_seq" value="${result.arr_org_seq }"/>
<!-- <input type="hidden" id="user_id" name="user_id" />
<input type="hidden" id="page_no" name="page_no" /> -->
 <!-- content -->
    <div class="hamo_container">
        <div class="content_con">

            <!-- content list -->
            <div class="con_box">
              <h2>사지방 매니저 관리</h2>
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
                                <th>* ID</th>
                                <td colspan="3">
                                    <label for="" class="none"></label>
                                    <input type="text" name="user_id" id="user_id" value="${result.user_id}" class="input_type1 w50" <c:if test="${result.user_id ne null}">readonly</c:if>/>
                                    <c:if test="${result.user_id eq null}">
                                    <button type="button" class="btn_type1" onclick="goIdCheck()"> 중복아이디 검색</button>
                                    </c:if>
                                </td>
                            </tr>
                            <tr>
                                <th>* 담당 사지방</th>
                                <td colspan="3">
                                <%-- <input id="org-name" name="project2" id="searchbox" class="input_type1" placeholder="자동완성 기능입니다." value="${result.org_nm }"/>
										<input type="hidden" id="arr_org_seq" name="arr_org_seq" value="${result.arr_org_seq }"/> --%>
                                    <select multiple id="arr_org_seq" name="arr_org_seq" title="">
                                       <c:forEach var="vo" items="${oList}" varStatus="vs" >
											<option value="${vo.seq}">${vo.org_nm}</option>
									   </c:forEach>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <th>* 성명</th>
                                <td><label for="user_name" class="none"></label><input type="text" name="user_name" id="user_name" value="${result.user_name}" class="input_type1 w100" /></td>
                                <th>* 계급</th>
                                <td><label for="rank" class="none"></label><input type="text" name="rank" id="rank" value="${result.rank}" class="input_type1 w100" /></td>
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
                            <tr>
                                <th>* 군 전화번호</th>
                                <td><label for="tel_num" class="none"></label><input type="text" name="tel_num" id="tel_num" value="${result.tel_num}" class="input_type1 w100" /></td>
                                <th>* 휴대전화번호</th>
                                <td><label for="phone_num" class="none"></label><input type="text" name="phone_num" id="phone_num" value="${result.phone_num}" class="input_type1 w100" /></td>
                            <tr>

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
                    <button type="button" class="btn_type2" onclick="location.href='managerlist.do'"> 목록</button>
                </div>
            </div><!-- //con_box -->
        </div>
    </div><!-- //content -->
</form>

	<%@ include file="../template/footer.jsp" %>
</body>
</html>