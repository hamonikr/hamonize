<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>

    <!-- Fontfaces CSS-->
    <link href="css/font-face.css" rel="stylesheet" media="all">
    <link href="vendor/font-awesome-4.7/css/font-awesome.min.css" rel="stylesheet" media="all">
    <link href="vendor/font-awesome-5/css/fontawesome-all.min.css" rel="stylesheet" media="all">
    <link href="vendor/mdi-font/css/material-design-iconic-font.min.css" rel="stylesheet" media="all">

    <!-- Bootstrap CSS-->
    <link href="vendor/bootstrap-4.1/bootstrap.min.css" rel="stylesheet" media="all">

    <!-- Vendor CSS-->
    <link href="vendor/animsition/animsition.min.css" rel="stylesheet" media="all">
    <link href="vendor/bootstrap-progressbar/bootstrap-progressbar-3.3.4.min.css" rel="stylesheet" media="all">
    <link href="vendor/wow/animate.css" rel="stylesheet" media="all">
    <link href="vendor/css-hamburgers/hamburgers.min.css" rel="stylesheet" media="all">
    <link href="vendor/slick/slick.css" rel="stylesheet" media="all">
    <link href="vendor/select2/select2.min.css" rel="stylesheet" media="all">
    <link href="vendor/perfect-scrollbar/perfect-scrollbar.css" rel="stylesheet" media="all">

    <!-- Main CSS-->
	<link href="css/theme.css" rel="stylesheet" media="all">
	
	<style>
        .col-lg-3 {
            -ms-flex: 0 0 33%;
            flex: 0 0 33%;
            max-width: 33%;
        }
        .col-lg-9 {
            flex: 0 0 75%;
            max-width: 50%;
        }
        .menubar li ul {
            background: #3e3a39;
            display: none;
            height: auto;
            padding-bottom: 10px;
            margin: 0px;
            border-radius: 0 0 7px 7px;
            position: absolute;
            width: 160px;
            z-index: 200;
        }
        .hamo_header .logo {
            width: 210px;
            height: 50px;
            position: absolute;
            left: 40px;
            top: 60px;
        }
	</style>
<body class="animsition">
	<%@ include file="../template/topMenu.jsp" %>
	
	
	<div class="page-wrapper">
		<!-- PAGE CONTAINER-->
		<div class="page-container">
            <!-- MAIN CONTENT-->
            <div class="main-content">
                <div class="section__content section__content--p30">
                    <div class="container-fluid">
                        <div class="row">
                            <div class="col-md-12">
                                <div class="overview-wrap">
                                </div>
                            </div>
                        </div>
                        <div class="row m-t-25" style="justify-content: space-between;">
                            <div class="col-sm-6 col-lg-3">
                                <div class="overview-item overview-item--c1">
                                    <div class="overview__inner">
                                        <div class="overview-box clearfix">
                                            <div class="icon">
												<i class="zmdi zmdi-desktop-windows"></i>
                                            </div>
                                            <div class="text">
                                                <h2>103</h2>
                                                <span>Total</span>
                                            </div>
                                        </div>
                                        <div class="overview-chart">
                                            <!-- <canvas id="widgetChart1"></canvas> -->
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-sm-6 col-lg-3">
                                <div class="overview-item overview-item--c2">
                                    <div class="overview__inner">
                                        <div class="overview-box clearfix">
                                            <div class="icon">
                                                <i class="zmdi zmdi-devices"></i>
                                            </div>
                                            <div class="text">
                                                <h2>8,688</h2>
                                                <span>On</span>
                                            </div>
                                        </div>
                                        <div class="overview-chart">
                                            <!-- <canvas id="widgetChart2"></canvas> -->
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-sm-6 col-lg-3">
                                <div class="overview-item overview-item--c3">
                                    <div class="overview__inner">
                                        <div class="overview-box clearfix">
                                            <div class="icon">
                                                <i class="zmdi zmdi-devices-off"></i>
                                            </div>
                                            <div class="text">
                                                <h2>1,086</h2>
                                                <span>Off</span>
                                            </div>
                                        </div>
                                        <div class="overview-chart">
                                            <!-- <canvas id="widgetChart3"></canvas> -->
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <h2 class="title-1 m-b-25">PC사용현황 <span id="topInfo"> </span></h2>
                        <iframe src="http://192.168.0.76:3000/d-solo/0acW0zWnz/new-dashboard-copy?orgId=1&refresh=10s&panelId=4" width="100%" height="350" frameborder="0"></iframe>
                       
                        <div class="row m-t-25" id="list">
                    </div>
                </div>
            </div>
			<!-- END MAIN CONTENT-->
		</div>
		<!-- END PAGE CONTENT-->
	</div><!-- //content -->
	
	
	
	
	
    <script type="text/javascript">
    function addZero(data){
        return (data<10) ? "0"+data : data;
    }
    $(document).ready(function(){
    $.post("/mntrng/pcPolicyList",{org_seq:1,type:'main'},
				function(data){
            var shtml = "";
            
			if( data.pcList.length > 0){
                console.log("data.length======"+data.pcList.length);
                shtml += "<div class=\"col-lg-9\">";
                shtml += "<h2 class=\"title-1 m-b-25\">업데이트 배포결과</h2>";
                shtml += "<div class=\"table-responsive table--no-card m-b-40\">";
                shtml += "<table class=\"table table-borderless table-striped table-earning\">";
                shtml += "<thead>";
                shtml += "<tr>";
                shtml += "<th>패키지</th>";
                shtml += "<th>버전</th>";
                shtml += "<th>구분</th>";
                shtml += "<th>전체</th>";
                shtml += "<th>완료</th>";
                shtml += "<th>미완료</th>";
                shtml += "</tr>";
                shtml += "</thead>";
                shtml += "<tbody>";
                    for(var i = 0;i < data.policyUpdtResult.length;i++){
					console.log(i);
					console.log(i+1);
					console.log(data.policyUpdtResult.length);
					console.log(data.policyUpdtResult[i].debname);
					var chk = 1;
					if((i+1) == data.policyUpdtResult.length){
						chk=0;
						}
					if(data.policyUpdtResult[i].debname != data.policyUpdtResult[i+chk].debname){
						var inset_dt = data.policyUpdtResult[i].ins_date;
						var date = new Date(inset_dt);
						date = date.getFullYear()+"-"+addZero(date.getMonth()+1)+"-"+addZero(date.getDate().toString());
						var noinstall = data.pcList.length - data.policyUpdtResult[i].count;
						shtml += "<tr>";
						shtml += "<td>"+data.policyUpdtResult[i].debname+"</td>";
						if(typeof data.policyUpdtResult[i].debver === "undefined")
							shtml += "<td>-</td>";
							else
						shtml += "<td>"+data.policyUpdtResult[i].debver+"</td>";
						shtml += "<td>"+data.policyUpdtResult[i].gubun+"</td>";
						shtml += "<td>"+data.pcList.length+"</td>";
						shtml += "<td>"+data.policyUpdtResult[i].count+"</td>";
						shtml += "<td>"+noinstall+"</td>";
						shtml += "</tr>";
						}else if((i+1) == data.policyUpdtResult.length){
							console.log("last");
							var inset_dt = data.policyUpdtResult[i].ins_date;
							var date = new Date(inset_dt);
							date = date.getFullYear()+"-"+addZero(date.getMonth()+1)+"-"+addZero(date.getDate().toString());
							var noinstall = data.pcList.length - data.policyUpdtResult[i].count;
							shtml += "<tr>";
							shtml += "<td>"+data.policyUpdtResult[i].debname+"</td>";
							shtml += "<td>"+data.policyUpdtResult[i].debver+"</td>";
							shtml += "<td>"+data.policyUpdtResult[i].gubun+"</td>";
							shtml += "<td>"+data.pcList.length+"</td>";
							shtml += "<td>"+data.policyUpdtResult[i].count+"</td>";
							shtml += "<td>"+noinstall+"</td>";
							shtml += "</tr>";
							}
					}

                shtml += "</tbody>";
                shtml += "</table>";
                shtml += "</div>";
                shtml += "</div>";


                shtml += "<div class=\"col-lg-9\">";
                shtml += "<h2 class=\"title-1 m-b-25\">프로그램 차단 배포결과</h2>"
                shtml += "<div class=\"table-responsive table--no-card m-b-40\">";
                shtml += "<table class=\"table table-borderless table-striped table-earning\">";
                shtml += "<thead>";
                shtml += "<tr>";
                shtml += "<th>패키지</th>";
                shtml += "<th>구분</th>";
                shtml += "<th>전체</th>";
                shtml += "<th>완료</th>";
                shtml += "<th>미완료</th>";
                shtml += "</tr>";
                shtml += "</thead>";
                shtml += "<tbody>";

                    for(var i = 0;i < data.policyProgrmResult.length;i++){
					console.log(i);
					console.log(i+1);
					//console.log(data.policyProgrmResult.length);
					//console.log(data.policyProgrmResult[i].progrmname);
					var chk = 1;
					if((i+1) == data.policyProgrmResult.length){
						chk=0;
						}
					if(data.policyProgrmResult[i].progrmname != data.policyProgrmResult[i+chk].progrmname){
						var inset_dt = data.policyProgrmResult[i].ins_date;
						var date = new Date(inset_dt);
						date = date.getFullYear()+"-"+addZero(date.getMonth()+1)+"-"+addZero(date.getDate().toString());
						var noinstall = data.pcList.length - data.policyProgrmResult[i].count;
						shtml += "<tr>";
						shtml += "<td>"+data.policyProgrmResult[i].progrmname+"</td>";
						shtml += "<td>"+data.policyProgrmResult[i].status_yn+"</td>";
						shtml += "<td>"+data.pcList.length+"</td>";
						shtml += "<td>"+data.policyProgrmResult[i].count+"</td>";
						shtml += "<td>"+noinstall+"</td>";
						shtml += "</tr>";
						}else if((i+1) == data.policyProgrmResult.length){
							console.log("last");
							var inset_dt = data.policyProgrmResult[i].ins_date;
							var date = new Date(inset_dt);
							date = date.getFullYear()+"-"+addZero(date.getMonth()+1)+"-"+addZero(date.getDate().toString());
							var noinstall = data.pcList.length - data.policyProgrmResult[i].count;
							shtml += "<tr>";
							shtml += "<td>"+data.policyProgrmResult[i].progrmname+"</td>";
							shtml += "<td>"+data.policyProgrmResult[i].status_yn+"</td>";
							shtml += "<td>"+data.pcList.length+"</td>";
							shtml += "<td>"+data.policyProgrmResult[i].count+"</td>";
							shtml += "<td>"+noinstall+"</td>";
							shtml += "</tr>";
							}
					}

                shtml += "</tbody>";
                shtml += "</table>";
                shtml += "</div>";
                shtml += "</div>";


                shtml += "<div class=\"col-lg-9\">";
                shtml += "<h2 class=\"title-1 m-b-25\">방화벽 정책 배포결과</h2>"
                shtml += "<div class=\"table-responsive table--no-card m-b-40\">";
                shtml += "<table class=\"table table-borderless table-striped table-earning\">";
                shtml += "<thead>";
                shtml += "<tr>";
                shtml += "<th>포트번호</th>";
                shtml += "<th>구분</th>";
                shtml += "<th>전체</th>";
                shtml += "<th>완료</th>";
                shtml += "<th>미완료</th>";
                shtml += "</tr>";
                shtml += "</thead>";
                shtml += "<tbody>";
                    for(var i = 0;i < data.policyFirewallResult.length;i++){
					console.log(i);
					console.log(i+1);
					//console.log(data.policyFirewallResult.length);
					//console.log(data.policyFirewallResult[i].Firewallname);
					var chk = 1;
					if((i+1) == data.policyFirewallResult.length){
						chk=0;
						}
					if(data.policyFirewallResult[i].retport != data.policyFirewallResult[i+chk].retport){
						var inset_dt = data.policyFirewallResult[i].ins_date;
						var date = new Date(inset_dt);
						date = date.getFullYear()+"-"+addZero(date.getMonth()+1)+"-"+addZero(date.getDate().toString());
						var noinstall = data.pcList.length - data.policyFirewallResult[i].count;
						shtml += "<tr>";
						shtml += "<td>"+data.policyFirewallResult[i].retport+"</td>";
						shtml += "<td>"+data.policyFirewallResult[i].status+"</td>";
						shtml += "<td>"+data.pcList.length+"</td>";
						shtml += "<td>"+data.policyFirewallResult[i].count+"</td>";
						shtml += "<td>"+noinstall+"</td>";
						shtml += "</tr>";
						}else if((i+1) == data.policyFirewallResult.length){
							console.log("last");
							var inset_dt = data.policyFirewallResult[i].ins_date;
							var date = new Date(inset_dt);
							date = date.getFullYear()+"-"+addZero(date.getMonth()+1)+"-"+addZero(date.getDate().toString());
							var noinstall = data.pcList.length - data.policyFirewallResult[i].count;
							shtml += "<tr>";
							shtml += "<td>"+data.policyFirewallResult[i].retport+"</td>";
							shtml += "<td>"+data.policyFirewallResult[i].status+"</td>";
							shtml += "<td>"+data.pcList.length+"</td>";
							shtml += "<td>"+data.policyFirewallResult[i].count+"</td>";
							shtml += "<td>"+noinstall+"</td>";
							shtml += "</tr>";
							}
					}

                shtml += "</tbody>";
                shtml += "</table>";
                shtml += "</div>";
                shtml += "</div>";         
                
                shtml += "<div class=\"col-lg-9\">";
                shtml += "<h2 class=\"title-1 m-b-25\">디바이스 정책 배포결과</h2>"
                shtml += "<div class=\"table-responsive table--no-card m-b-40\">";
                shtml += "<table class=\"table table-borderless table-striped table-earning\">";
                shtml += "<thead>";
                shtml += "<tr>";
                shtml += "<th>디바이스</th>";
                shtml += "<th>구분</th>";
                shtml += "<th>전체</th>";
                shtml += "<th>완료</th>";
                shtml += "<th>미완료</th>";
                shtml += "</tr>";
                shtml += "</thead>";
                shtml += "<tbody>";
                    for(var i = 0;i < data.policyDeviceResult.length;i++){
					console.log(i);
					console.log(i+1);
					//console.log(data.policyDeviceResult.length);
					//console.log(data.policyDeviceResult[i].progrmname);
					var chk = 1;
					if((i+1) == data.policyDeviceResult.length){
						chk=0;
						}
					if(data.policyDeviceResult[i].product != data.policyDeviceResult[i+chk].product){
						var inset_dt = data.policyDeviceResult[i].ins_date;
						var date = new Date(inset_dt);
						date = date.getFullYear()+"-"+addZero(date.getMonth()+1)+"-"+addZero(date.getDate().toString());
						var noinstall = data.pcList.length - data.policyDeviceResult[i].count;
						shtml += "<tr>";
						shtml += "<td>"+data.policyDeviceResult[i].product+"</td>";
						shtml += "<td>"+data.policyDeviceResult[i].status_yn+"</td>";
						shtml += "<td>"+data.pcList.length+"</td>";
						shtml += "<td>"+data.policyDeviceResult[i].count+"</td>";
						shtml += "<td>"+noinstall+"</td>";
						shtml += "</tr>";
						}else if((i+1) == data.policyDeviceResult.length){
							console.log("last");
							var inset_dt = data.policyDeviceResult[i].ins_date;
							var date = new Date(inset_dt);
							date = date.getFullYear()+"-"+addZero(date.getMonth()+1)+"-"+addZero(date.getDate().toString());
							var noinstall = data.pcList.length - data.policyDeviceResult[i].count;
							shtml += "<tr>";
							shtml += "<td>"+data.policyDeviceResult[i].product+"</td>";
							shtml += "<td>"+data.policyDeviceResult[i].status_yn+"</td>";
							shtml += "<td>"+data.pcList.length+"</td>";
							shtml += "<td>"+data.policyDeviceResult[i].count+"</td>";
							shtml += "<td>"+noinstall+"</td>";
							shtml += "</tr>";
							}
					}

                shtml += "</tbody>";
                shtml += "</table>";
                shtml += "</div>";
                shtml += "</div>";
                
                $("#list").append(shtml);
				
			}else{  
				gbInnerHtml += "<tr><td colspan='7' style='text-align:center;'>등록된 데이터가 없습니다. </td></tr>";
			}

		});

});
//pc카운트 비동기
var xmlhttp;

if(window.XMLHttpRequest){
	xmlhttp = new XMLHttpRequest();
} else {
	xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
}

xmlhttp.onreadystatechange = function(){
	if(xmlhttp.readyState == 4 && xmlhttp.status == 200){
		 var data = JSON.parse(xmlhttp.responseText);
		 var text = document.getElementsByClassName("text");
		 text[0].children[0].innerText=data.pcList.length;
		 text[1].children[0].innerText=data.on;
		 text[2].children[0].innerText=data.off;
	}else{
		console.log("fail");
	}
}
xmlhttp.open("POST","pcList.do",true);
xmlhttp.send();
	</script>
	
	<%@ include file="../template/footer.jsp" %>
	<!-- Jquery JS-->
    <script src="vendor/jquery-3.2.1.min.js"></script>
    <!-- Bootstrap JS-->
    <script src="vendor/bootstrap-4.1/popper.min.js"></script>
    <script src="vendor/bootstrap-4.1/bootstrap.min.js"></script>
    <!-- Vendor JS       -->
    <script src="vendor/slick/slick.min.js">
    </script>
    <script src="vendor/wow/wow.min.js"></script>
    <script src="vendor/animsition/animsition.min.js"></script>
    <script src="vendor/bootstrap-progressbar/bootstrap-progressbar.min.js">
    </script>
    <script src="vendor/counter-up/jquery.waypoints.min.js"></script>
    <script src="vendor/counter-up/jquery.counterup.min.js">
    </script>
    <script src="vendor/circle-progress/circle-progress.min.js"></script>
    <script src="vendor/perfect-scrollbar/perfect-scrollbar.js"></script>
    <script src="vendor/chartjs/Chart.bundle.min.js"></script>
    <script src="vendor/select2/select2.min.js">
    </script>

    <!-- Main JS-->
    <script src="js/main.js"></script>
</body>
