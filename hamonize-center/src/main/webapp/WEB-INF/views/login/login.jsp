<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>CMS Login | 관리자</title>
<link rel="stylesheet" type="text/css" href="/css/sgb/common.css">
<link rel="stylesheet" type="text/css" href="/css/sgb/content.css">
<script type="text/javascript" src="/js/jquery-3.6.0.min.js"></script>
<script type="text/javascript">

	//로그인 처리
	function fn_signIn(){
		if($('#user_id').val() == ''){
			alert('아이디를 입력해 주세요.');
			$('#user_id').focus();
			return false;
		}else if($('#pass_wd').val() == ''){
			alert('비밀번호를 입력해 주세요.');
			$('#pass_wd').focus();
			return false;
		}
		 $.ajax({
			url: "insession.do",
			type:"POST",
			data :  $("#mainform").serialize(),
			dataType : "json",
			success: function(data, textStatus, jqXHR){
				console.log(data)
				if(data == "0"){
					alert('잘못된 로그인 정보입니다. 다시입력하세요.');
					$('#user_id').focus();
				}else if(data == "2"){
					alert('허용되지 않는 아이피입니다. 관리자에 문의하세요.');
					location.href = "";
				}else{
					location.href = "/main";
				}
			},
				error : function(jqXHR, textStatus, errorThrown) {
					alert("ID 혹은 비밀번호가 틀렸습니다.");
				}
			});		

	}
	
	$(document).ready(function(){
		
		$("#btnSave").on("click",function(){
			fn_signIn();
			
		});
		
	});
	
	</script>
</head>

<body>
<div class="login_wrap">
	<div class="hamologin">
		<h1><img alt="login image" src="/images/login_tit.png"></h1>
		<form id="mainform" name="mainform" action="" method="post" onsubmit="fn_signIn();return false;">
		<input type="hidden" name="user_ip" id="user_ip" class="input_type1" />
		<ul class="memberin">
			<li> <label for="">아이디</label><input type="text" name="user_id" id="user_id" class="input_type1" value=""  placeholder="ID" /></li>
			<li> <label for="">비밀번호</label><input type="password" name="pass_wd" id="pass_wd" class="input_type1" value="" placeholder="Password" /></li>
			<li> <button type="submit" class="btn_type2"> LOGIN </button></li>
		</ul> 
		</form>     
		<div style="width: 100%;">
			<table class="div-align">
				<tr>
					<td>
						<button class="btn-admin btn btn-outline-info" onClick="location.href='/manual/admin';"> 관리자 매뉴얼 바로가기</button>

					</td>
					<td>
						<button class="btn-admin btn btn-outline-success" onClick="location.href='/manual/user';"> 사용자 매뉴얼 바로가기</button>

					</td>
				</tr>
			</table>
		</div>

	</div>
</div>
	


<!-- <script src="/logintemplet/vendor/tilt/tilt.jquery.min.js"></script> -->

</body>
</html>