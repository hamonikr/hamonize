<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!--  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css"> -->
 <style>
 #header_layer{
 width: 140px;
 height: 150px;
 background-color: #fff;
 display:none;
 /*float:left;*/
 position: absolute;
 top: 25px;
 left: 1700px;
 z-index: 1;
 }
 /* ul,li{
 list-style:none;
 margin:0;
 padding:0
 }
 .clear{clear:both}
 li.current{color:red} */
 </style>
 <script>
 $(document).ready(function(){
	 $("#adminBtn").on("click",function(){
		 $("#header_layer").empty();
		 var shtml;
		 shtml += "<ul>";
		 shtml += "<li style='text-align: center;'><a href='/login/logout.do' class='btn_logout'>로그아웃</a></li>";
		 shtml += "</ul>";
		 $("#header_layer").append(shtml);
		 if($("#header_layer").css("display") == "none")
			 $("#header_layer").show();
		 else
			 $("#header_layer").hide();
	 });
	 $("#settingBtn").on("click",function(){
		 $("#header_layer").empty();
		 var shtml;
		 shtml += "<ul>";
		 shtml += "<li style='text-align: center;'><a href='/admin/list.do' >관리자관리</a></li>";
		 shtml += "<li style='text-align: center;'><a href='/admin/managerlist.do' >사지방매니저관리</a></li>";
		 shtml += "<li style='text-align: center;'><a href='/gplcs/jsonInsertPc.do' >Json파일등록</a></li>";
		 /* shtml += "<li style='text-align: center;'><a href='/admin/serverlist.do' >사지방서버관리</a></li>"; */
		 shtml += "</ul>"; 
		 $("#header_layer").append(shtml);
		 if($("#header_layer").css("display") == "none")
			 $("#header_layer").show();
		 else
			 $("#header_layer").hide();
	 });
			
	 $.post("/pcMngr/requestCount",{org_seq:""},
					function(data){
		 		console.log(data)
				var shtml;
				 shtml += "<p>PC 하드웨어 변경요청이<a href='/pcMngr/pcMngrList?pc_change=R'><em>"+data+"건</em></a>이 있습니다.</p>";
				 $("#pcChange").append(shtml);

				
			});		

	  $("li").click(function(){
		 $("li").removeClass();
		 $(this).addClass("current");
	 }) 
 
 });
 function numberWithCommas(x) {
	    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}
 </script>
 <div class="hamo_header">
 <div class="admin_info">
            <ul class="admin_sinfo">
                <%-- <li><div class="dropdown">
                        <div class="notic">
                            <img src="/images/icon_setting.png" />
                            <span></span>
                        </div>
                        <div class="dropdown_content" >
                            <a href="/admin/list.do">관리자 관리</a>
                            <a href="/admin/managerlist.do">부서 관리</a>
                            <a href="/gplcs/ipManagement.do">사이트 인프라 관리</a>센터에서 서버인프라 관리하는 페이지
                            <a href="/research/research.do">통계</a>
                        </div>
                    </div>
                </li> --%>
                <li><a href="/login/logout.do"><img src="/images/icon_logout.png" alt="로그아웃" /></a></li>
            </ul>
        </div>

        <h1 class="logo"><a href="/main"><img src="/images/hlogo.png" /></a></h1>

        <div class="menubar">
            <ul>
                <%-- <li><a href="/notice/notice">공지사항</a></li> --%>
                <li><a href="/mntrng/pcControlList">모니터링</a></li>
                <li><a href="/org/orgManage">조직관리</a></li>
                <%-- <li><a href="/tchnlgy/tchnlgyList">장애처리</a></li> --%>
                <li><a href="/user/userList">사용자정보</a></li>
                <li><a href="/pcMngr/pcMngrList">PC정보</a>
                <%-- <ul>
                    <li><a href="/pcMngr/pcMngrList">PC정보</a></li>
                    <li><a href="/pcMngr/pcBlockList">PC접속관리</a></li>
                </ul> --%>
                </li>
                <li><a href="/gplcs/umanage">정책관리</a>
                    <ul>
                        <li><a href="/gplcs/umanage">업데이트관리</a></li>
                        <li><a href="/gplcs/pmanage">프로그램관리</a></li>
                        <li><a href="/gplcs/fmanage">방화벽관리</a></li>
                        <li><a href="/gplcs/dmanage">디바이스관리</a></li>
                        <%-- <li><a href="/gplcs/blockingNxssMngr">유해사이트 관리</a></li> --%>
                    </ul>
                </li>
                  <li><a href="/auditLog/updateCheckLog">정책 배포 결과</a>
 	              	<%-- <ul class="last">
                        <li><a href="/auditLog/pcUserLog">사용자 접속로그</a></li> 
                        <li><a href="/auditLog/iNetLog">인터넷 사용로그</a></li>
                        <li><a href="/auditLog/prcssBlockLog">프로세스 차단로그</a></li>
                        <li><a href="/auditLog/pcChangeLog">하드웨어 변경로그</a></li>
                        <li><a href="/auditLog/unAuthLog">비인가 디바이스로그</a></li>
                        <li><a href="/auditLog/updateCheckLog">정책 배포 결과</a></li>
                   </ul> --%>
                </li>
            </ul>
        </div>
    </div><!-- //header -->