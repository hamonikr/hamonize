<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>CMS Login | 관리자</title>
<link rel="stylesheet" type="text/css" href="/css/sgb/common.css">
<link rel="stylesheet" type="text/css" href="/css/sgb/content.css">

<script type="text/javascript" src="/js/jquery-1.10.1.min.js"></script>
<script type="text/javascript" src="/js/rsa/rsa.js"></script>
<script type="text/javascript" src="/js/rsa/jsbn.js"></script>
<script type="text/javascript" src="/js/rsa/prng4.js"></script>
<script type="text/javascript" src="/js/rsa/rng.js"></script>
	
<script type="text/javascript">

	function loginRSA(pw){
		// rsa 암호화	
		var rsa = new RSAKey();
		rsa.setPublic($('#RSAModulus').val(),$('#RSAExponent').val());
			
		return rsa.encrypt(pw);
	}
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
		//패스워드 암호화
		if($('#pass_wd').val() != ''){
			$('#pass_wd').val(loginRSA($('#pass_wd').val()));
		}

		 $.ajax({
			url: "insession",
			type:"POST",
			data :  $("#mainform").serialize(),
			dataType : "json",
			success: function(data, textStatus, jqXHR){
				console.log(data)
				if(data == "0"){
					alert('잘못된 로그인 정보입니다. 다시입력하세요.\n5번이상 실패시 해당계정은 잠금 처리 됩니다.');
					$('#user_id').focus();
					$('#pass_wd').val("");

				}else if(data == "2"){
					alert('허용되지 않는 아이피입니다. 관리자에 문의하세요.');
					$('#pass_wd').val("");
					location.href = "";
				}else if(data == "3"){
					alert('비활성화된 계정입니다. 관리자에 문의하세요.');
					$('#pass_wd').val("");
					location.href = "";
				}else if(data == "5"){
					alert('잘못된 로그인 정보로 5회 이상 로그인 실패하여 계정이 잠겼습니다. 관리자에 문의하세요.');
					$('#pass_wd').val("");
					location.href = "";
				}else{
					location.href = "/main";
				}
			},
				error : function(jqXHR, textStatus, errorThrown) {
					alert("ID 혹은 비밀번호가 틀렸습니다.");
					$('#pass_wd').val("");
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
	<form name="form_chk" id="form_chk" method="post">
		<input type="hidden" id="RSAModulus" name="RSAModulus" value="${publicKeyModulus}" />
		<input type="hidden" id="RSAExponent" name="RSAExponent" value="${publicKeyExponent}" />
	</form>
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
			
		</div>
	</div>

</body>
</html>
