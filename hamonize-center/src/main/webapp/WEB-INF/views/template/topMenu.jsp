<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
 <style>
 #header_layer{
	width: 140px;
	height: 150px;
	background-color: #fff;
	display:none;
	position: absolute;
	top: 25px;
	left: 1700px;
	z-index: 1;
 }
 .admin{
	 cursor:pointer;  
 }
 </style>
 <script>

 function numberWithCommas(x) {
	    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}

function getToday(){
	var today = new Date();

	var year = today.getFullYear();
	var month = ('0' + (today.getMonth() + 1)).slice(-2);
	var day = ('0' + today.getDate()).slice(-2);

	var dateString = year+"/"+month+"/"+day;
	return dateString;
}

function getMonthAgoday(){
	var today = new Date();

	var year = today.getFullYear();
	var month = ('0' + (today.getMonth())).slice(-2);
	var day = ('0' + today.getDate()).slice(-2);

	var dateString = year+"/"+month+"/"+day;
	
	return dateString;
}
    
 </script>
 <div class="hamo_header">
 		 <div class="admin_info">
            <ul class="admin_sinfo">
				<li><div class="dropdown">
					<div class="admin">
						<a href="/admin/serverlist"><img alt="설정" src="/images/icon_setting.png" /></a>
					</div>
					<div class="dropdown_content" >
						<a href="/admin/serverlist">환경 설정</a>
						<a href="/admin/list">관리자 정보 목록</a>
					</div>
				</div></li>
                <li><a href="/login/logout"><img src="/images/icon_logout.png" alt="로그아웃" /></a></li>
            </ul>
        </div>

        <h1 class="logo"><a href="/main"><img alt="하모나이즈 로고" src="/images/hlogo.png" /></a></h1>

        <div class="menubar">
            <ul>
                <li><a href="/mntrng/pcControlList">모니터링</a></li>
                <li><a href="/org/orgManage">조직관리</a></li>
                <li><a href="/pcMngr/pcMngrList">PC정보</a></li>
                <li><a href="/gplcs/umanage">정책관리</a>
                    <ul>
                        <li><a href="/gplcs/umanage">업데이트관리</a></li>
                        <li><a href="/gplcs/pmanage">프로그램관리</a></li>
                        <li><a href="/gplcs/fmanage">방화벽관리</a></li>
                        <li><a href="/gplcs/dmanage">디바이스관리</a></li>
                    </ul>
                </li>

                <li><a href="/backupRecovery/backupC">백업관리</a>
                    <ul class="last">
                        <li><a href="/backupRecovery/backupC">백업주기 설정</a></li> 
                        <li><a href="/backupRecovery/backupR">복구관리</a></li>
                    </ul>
                </li>

                <li><a href="/auditLog/updateCheckLog">로그감사</a>
                <ul class="last">
                    <li><a href="/auditLog/pcUserLog">사용자 접속로그</a></li> 
                    <li><a href="/auditLog/prcssBlockLog">프로세스 차단로그</a></li>
                    <li><a href="/auditLog/pcChangeLog">하드웨어 변경로그</a></li>
                    <li><a href="/auditLog/unAuthLog">비인가 디바이스로그</a></li>
                    <li><a href="/auditLog/updateCheckLog">정책 배포 결과</a></li>
                </ul>
                </li>
            </ul>
        </div>
    </div><!-- //header -->