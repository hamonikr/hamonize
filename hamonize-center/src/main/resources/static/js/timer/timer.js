	 var str_secs =""; 
	 
	 var str_mins =""; 

	 var mins=30;  // 분 초기화 
	 var secs=0;  // 초 초기화 
		

	 // 타이머 스크립트 
	 function timer_script(){ 
			secs = secs - 1; 
			
			if(secs < 0){
				secs=59;
				mins--;
			}

			str_secs = secs.toString(); 
			str_mins = mins.toString(); 

			
			
			/*if (mins ==0 && secs == 59)
			{	
				window.open("/js/cms/timer/logout_pop.html","content",'width=490, height=293, menubar=no, scrollbars=no,status=no,resizable=no,top=200,left=450');
			}*/
			if(secs < 10){str_secs = "0" + secs;}
			if(mins < 10){str_mins = "0" + mins;}			
			
			$("#min").html(str_mins);
			$("#second").html(str_secs);

			if (mins ==0 && secs == 0)
			{
				location.reload();         // 현재페이지 새로고침.
				location.href="/login/logout.do";	
				
				return;
			}

			setTimeout("timer_script()",1000);
		}


	function onExtend(){
		//로그인 연장 버튼를 클릭할경우!
		mins=30;  // 분 초기화 
		secs=0;   // 초 초기화 
		$("#min").html("30");
		$("#second").html("00");
		//location.reload();

	

	}

	function onPopupExtend(){
		//팝업창에서 연장을 할경우
		mins=30;  // 분 초기화 
		secs=0;   // 초 초기화 
		$("#min").html("30");
		$("#second").html("00"); 
		//location.reload();
		
	}

	// 페이지가 로드 된후 함수 실행 
	setTimeout("timer_script()",1000); 