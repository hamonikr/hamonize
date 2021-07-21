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
    <!-- <div class="hamo_container">
        <div class="main_box"> -->
		<!-- PAGE CONTAINER-->
		<div class="page-container">
            <!-- MAIN CONTENT-->
            <div class="main-content">
                <div class="section__content section__content--p30">
                    <div class="container-fluid">
                        <div class="row">
                            <div class="col-md-12">
                                <div class="overview-wrap">
                                    <!-- <h2 class="title-1">PC사용현황</h2> -->
                                    <!-- <button class="au-btn au-btn-icon au-btn--blue">
                                        <i class="zmdi zmdi-plus"></i>add item</button> -->
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
                            <!-- <div class="col-sm-6 col-lg-3">
                                <div class="overview-item overview-item--c4">
                                    <div class="overview__inner">
                                        <div class="overview-box clearfix">
                                            <div class="icon">
                                                <i class="zmdi zmdi-money"></i>
                                            </div>
                                            <div class="text">
                                                <h2>$8,386</h2>
                                                <span>total earnings</span>
                                            </div>
                                        </div>
                                        <div class="overview-chart">
                                            <canvas id="widgetChart4"></canvas>
                                        </div>
                                    </div>
                                </div>
                            </div> -->
                        </div>
                        <h2 class="title-1 m-b-25">PC사용현황</h2>
                        <iframe src="http://192.168.0.76:3000/d-solo/0acW0zWnz/new-dashboard-copy?orgId=1&var-host=1f9535d4a69640d5bd6c840537ecba3ddd&refresh=10s&from=1626815553983&to=1626837153983&panelId=4" width="100%" height="350" frameborder="0"></iframe>
                        <!-- <div class="row">
                            <div class="col-lg-6">
                                <div class="au-card recent-report">
                                    <div class="au-card-inner">
                                        <h3 class="title-2">월별 설치 현황</h3>
                                        <div class="chart-info">
                                            <div class="chart-info__left">
                                                <div class="chart-note">
                                                    <span class="dot dot--blue"></span>
                                                    <span>products</span>
                                                </div>
                                                <div class="chart-note mr-0">
                                                    <span class="dot dot--green"></span>
                                                    <span>services</span>
                                                </div>
                                            </div>
                                            <div class="chart-info__right">
                                                <div class="chart-statis">
                                                    <span class="index incre">
                                                        <i class="zmdi zmdi-long-arrow-up"></i>25%</span>
                                                    <span class="label">products</span>
                                                </div>
                                                <div class="chart-statis mr-0">
                                                    <span class="index decre">
                                                        <i class="zmdi zmdi-long-arrow-down"></i>10%</span>
                                                    <span class="label">services</span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="recent-report__chart">
                                            <canvas id="recent-rep-chart"></canvas>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-6">
                                <div class="au-card chart-percent-card">
                                    <div class="au-card-inner">
                                        <h3 class="title-2 tm-b-5">char by %</h3>
                                        <div class="row no-gutters">
                                            <div class="col-xl-6">
                                                <div class="chart-note-wrap">
                                                    <div class="chart-note mr-0 d-block">
                                                        <span class="dot dot--blue"></span>
                                                        <span>products</span>
                                                    </div>
                                                    <div class="chart-note mr-0 d-block">
                                                        <span class="dot dot--red"></span>
                                                        <span>services</span>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-xl-6">
                                                <div class="percent-chart">
                                                    <canvas id="percent-chart"></canvas>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div> -->
                        <div class="row m-t-25" id="list">
                            <!-- <div class="col-lg-9"></div> -->
                            <!-- <div class="col-lg-3">
                                <h2 class="title-1 m-b-25">Top PC 사용량</h2>
                                <div class="au-card au-card--bg-blue au-card-top-countries m-b-40">
                                    <div class="au-card-inner">
                                        <div class="table-responsive">
                                            <table class="table table-top-countries">
                                                <tbody>
                                                    <tr>
                                                        <td>United States</td>
                                                        <td class="text-right">$119,366.96</td>
                                                    </tr>
                                                    <tr>
                                                        <td>Australia</td>
                                                        <td class="text-right">$70,261.65</td>
                                                    </tr>
                                                    <tr>
                                                        <td>United Kingdom</td>
                                                        <td class="text-right">$46,399.22</td>
                                                    </tr>
                                                    <tr>
                                                        <td>Turkey</td>
                                                        <td class="text-right">$35,364.90</td>
                                                    </tr>
                                                    <tr>
                                                        <td>Germany</td>
                                                        <td class="text-right">$20,366.96</td>
                                                    </tr>
                                                    <tr>
                                                        <td>France</td>
                                                        <td class="text-right">$10,366.96</td>
                                                    </tr>
                                                    <tr>
                                                        <td>Australia</td>
                                                        <td class="text-right">$5,366.96</td>
                                                    </tr>
                                                    <tr>
                                                        <td>Italy</td>
                                                        <td class="text-right">$1639.32</td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div> -->
                        <!-- <div class="row">
                            <div class="col-lg-6">
                                <div class="au-card au-card--no-shadow au-card--no-pad m-b-40">
                                    <div class="au-card-title" style="background-image:url('images/bg-title-01.jpg');">
                                        <div class="bg-overlay bg-overlay--blue"></div>
                                        <h3>
                                            <i class="zmdi zmdi-account-calendar"></i>26 April, 2018</h3>
                                        <button class="au-btn-plus">
                                            <i class="zmdi zmdi-plus"></i>
                                        </button>
                                    </div>
                                    <div class="au-task js-list-load">
                                        <div class="au-task__title">
                                            <p>Tasks for John Doe</p>
                                        </div>
                                        <div class="au-task-list js-scrollbar3">
                                            <div class="au-task__item au-task__item--danger">
                                                <div class="au-task__item-inner">
                                                    <h5 class="task">
                                                        <a href="#">Meeting about plan for Admin Template 2018</a>
                                                    </h5>
                                                    <span class="time">10:00 AM</span>
                                                </div>
                                            </div>
                                            <div class="au-task__item au-task__item--warning">
                                                <div class="au-task__item-inner">
                                                    <h5 class="task">
                                                        <a href="#">Create new task for Dashboard</a>
                                                    </h5>
                                                    <span class="time">11:00 AM</span>
                                                </div>
                                            </div>
                                            <div class="au-task__item au-task__item--primary">
                                                <div class="au-task__item-inner">
                                                    <h5 class="task">
                                                        <a href="#">Meeting about plan for Admin Template 2018</a>
                                                    </h5>
                                                    <span class="time">02:00 PM</span>
                                                </div>
                                            </div>
                                            <div class="au-task__item au-task__item--success">
                                                <div class="au-task__item-inner">
                                                    <h5 class="task">
                                                        <a href="#">Create new task for Dashboard</a>
                                                    </h5>
                                                    <span class="time">03:30 PM</span>
                                                </div>
                                            </div>
                                            <div class="au-task__item au-task__item--danger js-load-item">
                                                <div class="au-task__item-inner">
                                                    <h5 class="task">
                                                        <a href="#">Meeting about plan for Admin Template 2018</a>
                                                    </h5>
                                                    <span class="time">10:00 AM</span>
                                                </div>
                                            </div>
                                            <div class="au-task__item au-task__item--warning js-load-item">
                                                <div class="au-task__item-inner">
                                                    <h5 class="task">
                                                        <a href="#">Create new task for Dashboard</a>
                                                    </h5>
                                                    <span class="time">11:00 AM</span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="au-task__footer">
                                            <button class="au-btn au-btn-load js-load-btn">load more</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-6">
                                <div class="au-card au-card--no-shadow au-card--no-pad m-b-40">
                                    <div class="au-card-title" style="background-image:url('images/bg-title-02.jpg');">
                                        <div class="bg-overlay bg-overlay--blue"></div>
                                        <h3>
                                            <i class="zmdi zmdi-comment-text"></i>New Messages</h3>
                                        <button class="au-btn-plus">
                                            <i class="zmdi zmdi-plus"></i>
                                        </button>
                                    </div>
                                    <div class="au-inbox-wrap js-inbox-wrap">
                                        <div class="au-message js-list-load">
                                            <div class="au-message__noti">
                                                <p>You Have
                                                    <span>2</span>

                                                    new messages
                                                </p>
                                            </div>
                                            <div class="au-message-list">
                                                <div class="au-message__item unread">
                                                    <div class="au-message__item-inner">
                                                        <div class="au-message__item-text">
                                                            <div class="avatar-wrap">
                                                                <div class="avatar">
                                                                    <img src="images/icon/avatar-02.jpg" alt="John Smith">
                                                                </div>
                                                            </div>
                                                            <div class="text">
                                                                <h5 class="name">John Smith</h5>
                                                                <p>Have sent a photo</p>
                                                            </div>
                                                        </div>
                                                        <div class="au-message__item-time">
                                                            <span>12 Min ago</span>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="au-message__item unread">
                                                    <div class="au-message__item-inner">
                                                        <div class="au-message__item-text">
                                                            <div class="avatar-wrap online">
                                                                <div class="avatar">
                                                                    <img src="images/icon/avatar-03.jpg" alt="Nicholas Martinez">
                                                                </div>
                                                            </div>
                                                            <div class="text">
                                                                <h5 class="name">Nicholas Martinez</h5>
                                                                <p>You are now connected on message</p>
                                                            </div>
                                                        </div>
                                                        <div class="au-message__item-time">
                                                            <span>11:00 PM</span>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="au-message__item">
                                                    <div class="au-message__item-inner">
                                                        <div class="au-message__item-text">
                                                            <div class="avatar-wrap online">
                                                                <div class="avatar">
                                                                    <img src="images/icon/avatar-04.jpg" alt="Michelle Sims">
                                                                </div>
                                                            </div>
                                                            <div class="text">
                                                                <h5 class="name">Michelle Sims</h5>
                                                                <p>Lorem ipsum dolor sit amet</p>
                                                            </div>
                                                        </div>
                                                        <div class="au-message__item-time">
                                                            <span>Yesterday</span>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="au-message__item">
                                                    <div class="au-message__item-inner">
                                                        <div class="au-message__item-text">
                                                            <div class="avatar-wrap">
                                                                <div class="avatar">
                                                                    <img src="images/icon/avatar-05.jpg" alt="Michelle Sims">
                                                                </div>
                                                            </div>
                                                            <div class="text">
                                                                <h5 class="name">Michelle Sims</h5>
                                                                <p>Purus feugiat finibus</p>
                                                            </div>
                                                        </div>
                                                        <div class="au-message__item-time">
                                                            <span>Sunday</span>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="au-message__item js-load-item">
                                                    <div class="au-message__item-inner">
                                                        <div class="au-message__item-text">
                                                            <div class="avatar-wrap online">
                                                                <div class="avatar">
                                                                    <img src="images/icon/avatar-04.jpg" alt="Michelle Sims">
                                                                </div>
                                                            </div>
                                                            <div class="text">
                                                                <h5 class="name">Michelle Sims</h5>
                                                                <p>Lorem ipsum dolor sit amet</p>
                                                            </div>
                                                        </div>
                                                        <div class="au-message__item-time">
                                                            <span>Yesterday</span>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="au-message__item js-load-item">
                                                    <div class="au-message__item-inner">
                                                        <div class="au-message__item-text">
                                                            <div class="avatar-wrap">
                                                                <div class="avatar">
                                                                    <img src="images/icon/avatar-05.jpg" alt="Michelle Sims">
                                                                </div>
                                                            </div>
                                                            <div class="text">
                                                                <h5 class="name">Michelle Sims</h5>
                                                                <p>Purus feugiat finibus</p>
                                                            </div>
                                                        </div>
                                                        <div class="au-message__item-time">
                                                            <span>Sunday</span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="au-message__footer">
                                                <button class="au-btn au-btn-load js-load-btn">load more</button>
                                            </div>
                                        </div>
                                        <div class="au-chat">
                                            <div class="au-chat__title">
                                                <div class="au-chat-info">
                                                    <div class="avatar-wrap online">
                                                        <div class="avatar avatar--small">
                                                            <img src="images/icon/avatar-02.jpg" alt="John Smith">
                                                        </div>
                                                    </div>
                                                    <span class="nick">
                                                        <a href="#">John Smith</a>
                                                    </span>
                                                </div>
                                            </div>
                                            <div class="au-chat__content">
                                                <div class="recei-mess-wrap">
                                                    <span class="mess-time">12 Min ago</span>
                                                    <div class="recei-mess__inner">
                                                        <div class="avatar avatar--tiny">
                                                            <img src="images/icon/avatar-02.jpg" alt="John Smith">
                                                        </div>
                                                        <div class="recei-mess-list">
                                                            <div class="recei-mess">Lorem ipsum dolor sit amet, consectetur adipiscing elit non iaculis</div>
                                                            <div class="recei-mess">Donec tempor, sapien ac viverra</div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="send-mess-wrap">
                                                    <span class="mess-time">30 Sec ago</span>
                                                    <div class="send-mess__inner">
                                                        <div class="send-mess-list">
                                                            <div class="send-mess">Lorem ipsum dolor sit amet, consectetur adipiscing elit non iaculis</div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="au-chat-textfield">
                                                <form class="au-form-icon">
                                                    <input class="au-input au-input--full au-input--h65" type="text" placeholder="Type a message">
                                                    <button class="au-input-icon">
                                                        <i class="zmdi zmdi-camera"></i>
                                                    </button>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div> -->
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

                
                // shtml += "";
                // shtml += "";
                // shtml += "";
                // shtml += "";
                // shtml += "";
                // shtml += "";
                // shtml += "";
                // shtml += "";
                // shtml += "";
                // shtml += "";
                // shtml += "";
                // shtml += "";
                // shtml += "";
                // shtml += "";
                // shtml += "";
                // shtml += "";

				//프로그램 차단 배포 결과

				// shtml_r += "<h4>프로그램 차단 배포 결과</h4>";
				// shtml_r += "<div class=\"board_list_3\">";
				// shtml_r += "<table>";
				// shtml_r += "<colgroup>";
				// shtml_r += "<col style=\"width:30%;\" /><col style=\"width:30%;\" /><col style=\"width:10%;\" /><col style=\"width:10%;\" /><col />";
				// shtml_r += "</colgroup>";
				// shtml_r += "<thead><tr>";
				// shtml_r += "<th>패키지</th>";
				// shtml_r += "<th>적용여부</th>";
				// shtml_r += "<th>전체PC</th>";
				// shtml_r += "<th>완료</th>";
				// shtml_r += "<th>미완료</th>";
				// shtml_r += "</tr></thead>";
				// shtml_r += "<tbody>";
				// for(var i = 0;i < data.policyProgrmResult.length;i++){
				// 	console.log(i);
				// 	console.log(i+1);
				// 	//console.log(data.policyProgrmResult.length);
				// 	//console.log(data.policyProgrmResult[i].progrmname);
				// 	var chk = 1;
				// 	if((i+1) == data.policyProgrmResult.length){
				// 		chk=0;
				// 		}
				// 	if(data.policyProgrmResult[i].progrmname != data.policyProgrmResult[i+chk].progrmname){
				// 		var inset_dt = data.policyProgrmResult[i].ins_date;
				// 		var date = new Date(inset_dt);
				// 		date = date.getFullYear()+"-"+addZero(date.getMonth()+1)+"-"+addZero(date.getDate().toString());
				// 		var noinstall = data.pcList.length - data.policyProgrmResult[i].count;
				// 		shtml_r += "<tr>";
				// 		shtml_r += "<td>"+data.policyProgrmResult[i].progrmname+"</td>";
				// 		shtml_r += "<td>"+data.policyProgrmResult[i].status_yn+"</td>";
				// 		shtml_r += "<td>"+data.pcList.length+"</td>";
				// 		shtml_r += "<td>"+data.policyProgrmResult[i].count+"</td>";
				// 		shtml_r += "<td>"+noinstall+"</td>";
				// 		shtml_r += "</tr>";
				// 		}else if((i+1) == data.policyProgrmResult.length){
				// 			console.log("last");
				// 			var inset_dt = data.policyProgrmResult[i].ins_date;
				// 			var date = new Date(inset_dt);
				// 			date = date.getFullYear()+"-"+addZero(date.getMonth()+1)+"-"+addZero(date.getDate().toString());
				// 			var noinstall = data.pcList.length - data.policyProgrmResult[i].count;
				// 			shtml_r += "<tr>";
				// 			shtml_r += "<td>"+data.policyProgrmResult[i].progrmname+"</td>";
				// 			shtml_r += "<td>"+data.policyProgrmResult[i].status_yn+"</td>";
				// 			shtml_r += "<td>"+data.pcList.length+"</td>";
				// 			shtml_r += "<td>"+data.policyProgrmResult[i].count+"</td>";
				// 			shtml_r += "<td>"+noinstall+"</td>";
				// 			shtml_r += "</tr>";
				// 			}
				// 	}
				
				// shtml_r += "</tbody>";
				// shtml_r += "</table>";
				// shtml_r += "</div>";
				// shtml_r += "</div>";
                //$(".col-lg-9").append(shtml);
                $("#list").append(shtml);
				
			}else{  
				gbInnerHtml += "<tr><td colspan='7' style='text-align:center;'>등록된 데이터가 없습니다. </td></tr>";
			}

			// console.log("cnt===="+cnt)
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
	<!-- <script>
			$(document).ready(function(){
				var offset = 0;
				$(".tooltip").css("display","none");
				$.post("inetLogCount.do",{dataType:'json',offset:offset},
						function(data){
					var conList = data.conList;
					var illList = data.illList;
					console.log(data.conList);
					for(var i = 0; i < conList.length;i++){
						console.log("con"+conList[i].cnnc_url +":::"+conList[i].count);
						console.log("ill"+illList[i].cnnc_url +":::"+illList[i].count);
						$(".con").eq(i).html(conList[i].cnnc_url+"<span><a href=\"/auditLog/iNetLog?prcssname=1&txtSearch0=1&txtSearch4="+conList[i].cnnc_url+"\">"+numberWithCommas(conList[i].count)+"건</a>("+conList[i].per+"%)</span>");
						$(".fadeInLeft").eq(i).css("width",conList[i].per+"%");
						$(".ill").eq(i).html(illList[i].cnnc_url+"<span><a href=\"/auditLog/iNetLog?prcssname=1&txtSearch0=2&txtSearch4="+illList[i].cnnc_url+"\">"+numberWithCommas(illList[i].count)+"건</a>("+illList[i].per+"%)</span>");
						$("#hamain_right1 .fadeInLeft").eq(i).css("width",illList[i].per+"%");
					}
				});
				$("#btnMore").on("click",function(){
					offset += 5;
					 $.post("inetLogCount.do",{dataType:'json',offset:offset},
							function(data){
						var conList = data.conList;
						var illList = data.illList;
						for(var i = 0; i < conList.length;i++){
							var chtml = "";
							var ihtml = "";

							chtml += "<li class=\"more\">";
							chtml += "<div class=\"sname con\">"+conList[i].cnnc_url;
							chtml += "<span><a href=\"/auditLog/iNetLog?prcssname=1&txtSearch0=1&txtSearch4="+conList[i].cnnc_url+"\">"+numberWithCommas(conList[i].count)+"건</a>("+conList[i].per+"%)</span>";
							chtml += "<div class=\"sbar\">";
							chtml += "<div class=\"present wow fadeInLeft\" data-wow-delay=\"0.5s\" style=\"width:"+conList[i].per+"%\"></div>";
							chtml += "</div>";

							ihtml += "<li class=\"more\">";
							ihtml += "<div class=\"sname ill\">"+illList[i].cnnc_url;
							ihtml += "<span><a href=\"/auditLog/iNetLog?prcssname=1&txtSearch0=2&txtSearch4="+illList[i].cnnc_url+"\">"+numberWithCommas(illList[i].count)+"건</a>("+illList[i].per+"%)</span>";
							ihtml += "<div class=\"sbar\">";
							ihtml += "<div class=\"present wow fadeInLeft\" data-wow-delay=\"0.5s\" style=\"width:"+illList[i].per+"%\"></div>";
							ihtml += "</div>";
							
							$("#hamain_left1 .siteinfo").append(chtml);
							$("#hamain_right1 .siteinfo").append(ihtml);
						}
					}); 
				})
					$("#btnClose").on("click",function(){
						$(".more").remove();
						offset = 0;
						})
   
		$.post("sidoCount.do",{dataType:'json'},
				function(data){
			$(".tooltip").css("display","block");
			var SU = 0,BS = 0,DG = 0,IC = 0,GJ = 0,DJ = 0,US = 0,GG = 0,
			GW = 0,NC = 0,SC = 0,NJ = 0,SJ = 0,NG = 0,SG = 0,JJ = 0,SE = 0;
			var sum = 0;
			var SU1 = 0,BS1 = 0,DG1 = 0,IC1 = 0,GJ1 = 0,DJ1 = 0,US1 = 0,GG1 = 0,
			GW1 = 0,NC1 = 0,SC1 = 0,NJ1 = 0,SJ1 = 0,NG1 = 0,SG1 = 0,JJ1 = 0,SE1 = 0;
			var SU2 = 0,BS2 = 0,DG2 = 0,IC2 = 0,GJ2 = 0,DJ2 = 0,US2 = 0,GG2 = 0,
			GW2 = 0,NC2 = 0,SC2 = 0,NJ2 = 0,SJ2 = 0,NG2 = 0,SG2 = 0,JJ2 = 0,SE2 = 0;
			var sum1 = 0;
			var agrs = data.sidoCount;
			for(var i = 0; i < agrs.length;i++){

					if(agrs[i].sido == '서울'){
						SU = agrs[i].pc_cnt;
						SU1 = agrs[i].t_sum;
					}else if(agrs[i].sido == '부산'){
						BS = agrs[i].pc_cnt;
						BS1 = agrs[i].t_sum;
					}else if(agrs[i].sido == '대구'){
						DG = agrs[i].pc_cnt;
						DG1 = agrs[i].t_sum;
					}else if(agrs[i].sido == '인천'){
						IC = agrs[i].pc_cnt;
						IC1 = agrs[i].t_sum;
					}else if(agrs[i].sido == '광주'){
						GJ = agrs[i].pc_cnt;
						GJ1 = agrs[i].t_sum;
					}else if(agrs[i].sido == '대전'){
						DJ = agrs[i].pc_cnt;
						DJ1 = agrs[i].t_sum;
					}else if(agrs[i].sido == '울산'){
						US = agrs[i].pc_cnt;
						US1 = agrs[i].t_sum;
					}else if(agrs[i].sido == '경기'){
						GG = agrs[i].pc_cnt;
						GG1 = agrs[i].t_sum;
					}else if(agrs[i].sido == '강원'){
						GW = agrs[i].pc_cnt;
						GW1 = agrs[i].t_sum;
					}else if(agrs[i].sido == '충북'){
						NC = agrs[i].pc_cnt;
						NC1 = agrs[i].t_sum;
					}else if(agrs[i].sido == '충남'){
						SC = agrs[i].pc_cnt;
						SC1 = agrs[i].t_sum;
					}else if(agrs[i].sido == '전북'){
						NJ = agrs[i].pc_cnt;
						NJ1 = agrs[i].t_sum;
					}else if(agrs[i].sido == '전남'){
						SJ = agrs[i].pc_cnt;
						SJ1 = agrs[i].t_sum;
					}else if(agrs[i].sido == '경북'){
						NG = agrs[i].pc_cnt;
						NG1 = agrs[i].t_sum;
					}else if(agrs[i].sido == '경남'){
						SG = agrs[i].pc_cnt;
						SG1 = agrs[i].t_sum;
					}else if(agrs[i].sido == '제주'){
						JJ = agrs[i].pc_cnt;
						JJ1 = agrs[i].t_sum;
					}else if(agrs[i].sido == '세종'){
						SE = agrs[i].pc_cnt;
						SE1 = agrs[i].t_sum;
					}
			}
		sum = SU+BS+DG+IC+GJ+DJ+US+GG+GW+NC+SC+NJ+SJ+NG+SG+JJ+SE;
		sum1 = SU1+BS1+DG1+IC1+GJ1+DJ1+US1+GG1+GW1+NC1+SC1+NJ1+SJ1+NG1+SG1+JJ1+SE1;
		var total=sum;
		var on = data.useList.length;
		var off = (total - on);
		var wCount = data.wCount;
		var hCount = data.hCount;
		var tot = wCount+total;
		var totper = Math.floor((wCount/25000)*100)+Math.floor((total/25000)*100);


		$(".cyberinfo li").each(function (i,v){
			if(i==0){
				$(this).html("<span>구분</span><img src=\"/images/icon_total.png\" width=\"25\" height=\"25\">&nbsp;&nbsp;합계<br/><img src=\"/images/icon_w.png\" width=\"25\" height=\"25\">&nbsp;&nbsp;상용<br/><img src=\"/images/icon_h.png\" width=\"25\" height=\"25\">&nbsp;&nbsp;개방");
				$(this).css("color","#333");
			}
			if(i==1)
				$(this).html("<span>합계</span>"+numberWithCommas(tot)+"("+totper+"%)<br/>"+numberWithCommas(wCount)+"("+Math.floor((wCount/25000)*100)+"%)<br/>"+numberWithCommas(total)+"("+Math.floor((total/25000)*100)+"%)");
			if(i==2)
				$(this).html("<span>사용 현황</span>"+numberWithCommas(on)+"("+Math.floor((on/25000)*100)+"%)<br/>-<br/>"+numberWithCommas(on)+"("+Math.floor((on/25000)*100)+"%)");
			if(i==3)
				$(this).html("<span>미사용 현황</span>"+numberWithCommas(off)+"("+Math.floor((off/25000)*100)+"%)<br/>-<br/>"+numberWithCommas(off)+"("+Math.floor((off/25000)*100)+"%)");
			
		});
		var agrs2 = data.useList;
		 //var count = on;
	     var features = new Array(agrs2.length);

			for(var i = 0; i < agrs2.length;i++){
			
			if( agrs2[i].xpoint == null || agrs2[i].xpoint == "" || typeof agrs2[i].xpoint == "undefined"){
				console.log("aaaaaaaaaaaaaaaaaaaaa=================++++"+ JSON.stringify(agrs2[i]));
				
			}
			var x = parseFloat(agrs2[i].xpoint);
			var y = parseFloat(agrs2[i].ypoint);

			var coordinates = [x,y];

			features[i] = new ol.Feature(new ol.geom.Point(ol.proj.transform(coordinates, 'EPSG:4326', 'EPSG:3857')));

			if(agrs2[i].sido == '서울'){
				SU2++;
			}else if(agrs2[i].sido == '부산'){
				BS2++;
			}else if(agrs2[i].sido == '대구'){
				DG2++;
			}else if(agrs2[i].sido == '인천'){
				IC2++;
			}else if(agrs2[i].sido == '광주'){
				GJ2++;
			}else if(agrs2[i].sido == '대전'){
				DJ2++;
			}else if(agrs2[i].sido == '울산'){
				US2++;
			}else if(agrs2[i].sido == '경기'){
				GG2++;
			}else if(agrs2[i].sido == '강원'){
				GW2++;
			}else if(agrs2[i].sido == '충북'){
				NC2++;
			}else if(agrs2[i].sido == '충남'){
				SC2++;
			}else if(agrs2[i].sido == '전북'){
				NJ2++;
			}else if(agrs2[i].sido == '전남'){
				SJ2++;
			}else if(agrs2[i].sido == '경북'){
				NG2++;
			}else if(agrs2[i].sido == '경남'){
				SG2++;
			}else if(agrs2[i].sido == '제주'){
				JJ2++;
			}else if(agrs2[i].sido == '세종'){
				SE2++;
			}
	}


			$("#tooltip").html("<img src=\"/images/icon_h4.png\" width=\"14\" height=\"14\"> "+SU2+" / "+SU);
			$("#tooltip2").html("<img src=\"/images/icon_h4.png\" width=\"14\" height=\"14\"> "+BS2+" / "+BS);
			$("#tooltip3").html("<img src=\"/images/icon_h4.png\" width=\"14\" height=\"14\"> "+DG2+" / "+DG);
			$("#tooltip4").html("<img src=\"/images/icon_h4.png\" width=\"14\" height=\"14\"> "+IC2+" / "+IC);
			$("#tooltip5").html("<img src=\"/images/icon_h4.png\" width=\"14\" height=\"14\"> "+GJ2+" / "+GJ);
			$("#tooltip6").html("<img src=\"/images/icon_h4.png\" width=\"14\" height=\"14\"> "+DJ2+" / "+DJ);
			$("#tooltip7").html("<img src=\"/images/icon_h4.png\" width=\"14\" height=\"14\"> "+US2+" / "+US);
			$("#tooltip8").html("<img src=\"/images/icon_h4.png\" width=\"14\" height=\"14\"> "+GG2+" / "+GG);
			$("#tooltip9").html("<img src=\"/images/icon_h4.png\" width=\"14\" height=\"14\"> "+GW2+" / "+GW);
			$("#tooltip10").html("<img src=\"/images/icon_h4.png\" width=\"14\" height=\"14\"> "+NC2+" / "+NC);
			$("#tooltip11").html("<img src=\"/images/icon_h4.png\" width=\"14\" height=\"14\"> "+SC2+" / "+SC);
			$("#tooltip12").html("<img src=\"/images/icon_h4.png\" width=\"14\" height=\"14\"> "+NJ2+" / "+NJ);
			$("#tooltip13").html("<img src=\"/images/icon_h4.png\" width=\"14\" height=\"14\"> "+SJ2+" / "+SJ);
			$("#tooltip14").html("<img src=\"/images/icon_h4.png\" width=\"14\" height=\"14\"> "+NG2+" / "+NG);
			$("#tooltip15").html("<img src=\"/images/icon_h4.png\" width=\"14\" height=\"14\"> "+SG2+" / "+SG);
			$("#tooltip16").html("<img src=\"/images/icon_h4.png\" width=\"14\" height=\"14\"> "+JJ2+" / "+JJ);
			$("#tooltip17").html("<img src=\"/images/icon_h4.png\" width=\"14\" height=\"14\"> "+SE2+" / "+SE);

		// define tile layer
	    var vworldTile = new ol.layer.Tile({
	        title : 'VWorld Gray Map',
	        visible : true,
	        type : 'base',
	        source : new ol.source.XYZ({
	            url : 'http://xdworld.vworld.kr:8080/2d/Base/201802/{z}/{x}/{y}.png',
	            attributions: [
	                new ol.Attribution({ 
	                    html: ['&copy; <a href="http://map.vworld.kr">V-World Map</a>'] 
	                })
	            ]
	        })
	    });
	    
	     //var distance = document.getElementById('distance');
	     
	      var source = new ol.source.Vector({
	       features: features
	     }); 

	     var clusterSource = new ol.source.Cluster({
	       //distance: parseInt(distance.value, 10),
	       source: source
	     });

	     var styleCache = {};
	     var canvas = document.createElement('canvas');
	     canvas.width = 80;
	     canvas.height = 30;
	     var ctx = canvas.getContext('2d');
	     ctx.fillStyle = 'rgba(0, 0, 0, 0.6)';
	     ctx.fillRect(0, 0, canvas.width, canvas.height);;
	     var clusters = new ol.layer.Vector({
	       source: clusterSource,
	       style: function(feature) {
	         var size = feature.get('features').length;
	         var style = styleCache[size];
	         if (!style) {
	           style = [new ol.style.Style({
						image: new ol.style.Icon({
						img: canvas,
						imgSize: [90, 20]
			           }), 

	             text: new ol.style.Text({
	               text: size.toString()+" / "+parseInt((size.toString()*100)/14),
	               scale: 1.5,
	               fill: new ol.style.Fill({
	                 color: '#fff'
	               })
	             })
	           })
	           ];
	           styleCache[size] = style;
	         }
	         return style;
	       }
	     });
	     var styleCache2 = {};
	     var clusters2 = new ol.layer.Vector({
		       source: clusterSource,
		       style: function(feature) {
		         var size = feature.get('features').length;
		         var style = styleCache2[size];
		         if (!style) {
		           style = [new ol.style.Style({
							image: new ol.style.Icon({
								anchor: [3, 0.5],
				        	    scale: 0.3,
	            				anchorXUnits: 'fraction',
	            				anchorYUnits: 'fraction',
			        	   		src:'/images/icon_h4.png'
				           }), 
		           })
		           ];
		           styleCache2[size] = style;
		         }
		         return style;
		       }
		     });

	      var raster = new ol.layer.Tile({
	       source: new ol.source.OSM()
	     }); 
	      var stamenTile = new ol.layer.Tile({
              title : 'Stamen Watercolor',
              visible : false,
              type : 'base',
              source: new ol.source.Stamen({
                  layer: 'watercolor'
              })
          });

	      var overlay = new ol.Overlay({
              element: document.getElementById('overlay'),
              positioning: 'bottom-center'
            });

           var popup = new ol.Overlay({
               element: document.getElementById('tooltip')
             });
           var popup2 = new ol.Overlay({
               element: document.getElementById('tooltip2')
             });
           var popup3 = new ol.Overlay({
               element: document.getElementById('tooltip3')
             });
           var popup4 = new ol.Overlay({
               element: document.getElementById('tooltip4')
             });
           var popup5 = new ol.Overlay({
               element: document.getElementById('tooltip5')
             });
           var popup6 = new ol.Overlay({
               element: document.getElementById('tooltip6')
             });
           var popup7 = new ol.Overlay({
               element: document.getElementById('tooltip7')
             });
           var popup8 = new ol.Overlay({
               element: document.getElementById('tooltip8')
             });
           var popup9 = new ol.Overlay({
               element: document.getElementById('tooltip9')
             });
           var popup10 = new ol.Overlay({
               element: document.getElementById('tooltip10')
             });
           var popup11 = new ol.Overlay({
               element: document.getElementById('tooltip11')
             });
           var popup12 = new ol.Overlay({
               element: document.getElementById('tooltip12')
             });
           var popup13 = new ol.Overlay({
               element: document.getElementById('tooltip13')
             });
           var popup14 = new ol.Overlay({
               element: document.getElementById('tooltip14')
             });
           var popup15 = new ol.Overlay({
               element: document.getElementById('tooltip15')
             });
           var popup16 = new ol.Overlay({
               element: document.getElementById('tooltip16')
             });
           var popup17 = new ol.Overlay({
               element: document.getElementById('tooltip17')
             });

           var ol3_sprint_location = ol.proj.transform([126.77, 37.99], 'EPSG:4326', 'EPSG:3857'); //서울
           var ol3_sprint_location2 = ol.proj.transform([129.00, 35.06], 'EPSG:4326', 'EPSG:3857'); //부산
           var ol3_sprint_location3 = ol.proj.transform([128.33, 36.18], 'EPSG:4326', 'EPSG:3857'); //대구
           var ol3_sprint_location4 = ol.proj.transform([125.70, 37.84], 'EPSG:4326', 'EPSG:3857'); //인천
           var ol3_sprint_location5 = ol.proj.transform([126.63, 35.54], 'EPSG:4326', 'EPSG:3857'); //광주
           var ol3_sprint_location6 = ol.proj.transform([127.38, 36.72], 'EPSG:4326', 'EPSG:3857'); //대전
           var ol3_sprint_location7 = ol.proj.transform([129.05, 35.92], 'EPSG:4326', 'EPSG:3857'); //울산
           var ol3_sprint_location8 = ol.proj.transform([126.11, 37.12], 'EPSG:4326', 'EPSG:3857'); //경기
           var ol3_sprint_location9 = ol.proj.transform([127.98, 38.15], 'EPSG:4326', 'EPSG:3857'); //강원
           var ol3_sprint_location10 = ol.proj.transform([127.83, 37.30], 'EPSG:4326', 'EPSG:3857'); //충북
           var ol3_sprint_location11 = ol.proj.transform([125.78, 36.36], 'EPSG:4326', 'EPSG:3857'); //충남
           var ol3_sprint_location12 = ol.proj.transform([126.96, 36.12], 'EPSG:4326', 'EPSG:3857'); //전북
           var ol3_sprint_location13 = ol.proj.transform([126.54, 34.78], 'EPSG:4326', 'EPSG:3857'); //전남
           var ol3_sprint_location14 = ol.proj.transform([128.75, 36.76], 'EPSG:4326', 'EPSG:3857'); //경북
           var ol3_sprint_location15 = ol.proj.transform([127.81, 35.20], 'EPSG:4326', 'EPSG:3857'); //경남
           var ol3_sprint_location16 = ol.proj.transform([126.23, 33.78], 'EPSG:4326', 'EPSG:3857'); //제주
           var ol3_sprint_location17 = ol.proj.transform([126.15, 36.81], 'EPSG:4326', 'EPSG:3857'); //세종
	     
	        // set map
	        var map = new ol.Map({
	            controls : [
	                new ol.control.Attribution({
	                    collapsible: true
	                }), 
	                new ol.control.Zoom(), 
	                new ol.control.FullScreen(),
	                new ol.control.MousePosition({
	                    projection: 'EPSG:4326',
	                    coordinateFormat: ol.coordinate.createStringXY(2)
	                }),
	                new ol.control.ZoomToExtent({
	                    extent: [12878110, 3779046, 15395028, 5381166]
	                }),
	                new ol.control.ScaleLine(),
	                new ol.control.LayerSwitcher()
	            ],
	            layers : [
	                new ol.layer.Group({
	                    title : 'Base Maps',
	                    layers : [
	                    	//raster,
	                    	vworldTile,
	                        //clusters,
	                        stamenTile
	                    ]
	                  }),
	                new ol.layer.Group({
	                    title: 'Tiled WMS',
	                    layers: [
	                    ]
	                })
	            ],
	            target : 'map',
	            renderer: 'canvas',
	            interactions : ol.interaction.defaults({
	            	shiftDragZoom : false,
	                mouseWheelZoom:true,
	                doubleClickZoom:false
	            }),
	            view : new ol.View({
	                projection: 'EPSG:3857',
	                center : new ol.geom.Point([128, 36]).transform('EPSG:4326', 'EPSG:3857').getCoordinates(),
	                zoom : 7
	            })
	        });

	         map.addOverlay(popup);
            popup.setPosition(ol3_sprint_location);
            map.addOverlay(popup2);
            popup2.setPosition(ol3_sprint_location2);
            map.addOverlay(popup3);
            popup3.setPosition(ol3_sprint_location3);
            map.addOverlay(popup4);
            popup4.setPosition(ol3_sprint_location4);
            map.addOverlay(popup5);
            popup5.setPosition(ol3_sprint_location5);
            map.addOverlay(popup6);
            popup6.setPosition(ol3_sprint_location6);
            map.addOverlay(popup7);
            popup7.setPosition(ol3_sprint_location7);
            map.addOverlay(popup8);
            popup8.setPosition(ol3_sprint_location8);
            map.addOverlay(popup9);
            popup9.setPosition(ol3_sprint_location9);
            map.addOverlay(popup10);
            popup10.setPosition(ol3_sprint_location10);
            map.addOverlay(popup11);
            popup11.setPosition(ol3_sprint_location11);
            map.addOverlay(popup12);
            popup12.setPosition(ol3_sprint_location12);
            map.addOverlay(popup13);
            popup13.setPosition(ol3_sprint_location13);
            map.addOverlay(popup14);
            popup14.setPosition(ol3_sprint_location14);
            map.addOverlay(popup15);
            popup15.setPosition(ol3_sprint_location15);
            map.addOverlay(popup16);
            popup16.setPosition(ol3_sprint_location16);
            map.addOverlay(popup17);
            popup17.setPosition(ol3_sprint_location17);

	        var currZoom = map.getView().getZoom();
	        map.on('moveend', function(e) {
	          var newZoom = map.getView().getZoom();
	          if (currZoom != newZoom) {
	            console.log('zoom end, new zoom: ' + newZoom);
	            currZoom = newZoom;
	            if(newZoom <= 7){
	            	map.addOverlay(popup);
	                popup.setPosition(ol3_sprint_location);
	                map.addOverlay(popup2);
	                popup2.setPosition(ol3_sprint_location2);
	                map.addOverlay(popup3);
	                popup3.setPosition(ol3_sprint_location3);
	                map.addOverlay(popup4);
	                popup4.setPosition(ol3_sprint_location4);
	                map.addOverlay(popup5);
	                popup5.setPosition(ol3_sprint_location5);
	                map.addOverlay(popup6);
	                popup6.setPosition(ol3_sprint_location6);
	                map.addOverlay(popup7);
	                popup7.setPosition(ol3_sprint_location7);
	                map.addOverlay(popup8);
	                popup8.setPosition(ol3_sprint_location8);
	                map.addOverlay(popup9);
	                popup9.setPosition(ol3_sprint_location9);
	                map.addOverlay(popup10);
	                popup10.setPosition(ol3_sprint_location10);
	                map.addOverlay(popup11);
	                popup11.setPosition(ol3_sprint_location11);
	                map.addOverlay(popup12);
	                popup12.setPosition(ol3_sprint_location12);
	                map.addOverlay(popup13);
	                popup13.setPosition(ol3_sprint_location13);
	                map.addOverlay(popup14);
	                popup14.setPosition(ol3_sprint_location14);
	                map.addOverlay(popup15);
	                popup15.setPosition(ol3_sprint_location15);
	                map.addOverlay(popup16);
	                popup16.setPosition(ol3_sprint_location16);
	                map.addOverlay(popup17);
	                popup17.setPosition(ol3_sprint_location17);
	                map.removeLayer(clusters);
	                map.removeLayer(clusters2);
		            }else{
		            	map.removeOverlay(popup);
						map.removeOverlay(popup2);
						map.removeOverlay(popup3);
						map.removeOverlay(popup4);
						map.removeOverlay(popup5);
						map.removeOverlay(popup6);
						map.removeOverlay(popup7);
						map.removeOverlay(popup8);
						map.removeOverlay(popup9);
						map.removeOverlay(popup10);
						map.removeOverlay(popup11);
						map.removeOverlay(popup12);
						map.removeOverlay(popup13);
						map.removeOverlay(popup14);
						map.removeOverlay(popup15);
						map.removeOverlay(popup16);
						map.removeOverlay(popup17);
						map.removeLayer(clusters);
						map.addLayer(clusters);
						map.removeLayer(clusters2);
						map.addLayer(clusters2);

			            }
	          }
	        });


		var append = "";
		var progress = parseInt(data.tchnlgyCount.receipt)+parseInt(data.tchnlgyCount.progress);
		append += "<tr>";
		append += "<td style='text-align: center'><font class='purple'>"+data.tchnlgyCount.tbl_cnt+"</font></td>";
		append += "<td style='text-align: center'><font class='purple'>"+progress+"</font></td>";
		append += "<td style='text-align: center'><font class='purple'>"+data.tchnlgyCount.complete+"</font></td>";
		append += "</tr>";
		append += "";
		$("#tchnlgyCountBody").append(append);
		$("#tchnlgyCount td").each(function(i,v){
			if(i==1)
				$(this).children().eq(1).html("<font class='purple'>"+data.tchnlgyCount.tbl_cnt+"</font>");
			if(i==2)
				$(this).children().eq(1).html("<font class='purple'>"+data.tchnlgyCount.receipt+"</font> / "+BS);
			if(i==3)
				$(this).children().eq(1).html("<font class='purple'>"+data.tchnlgyCount.complete+"</font> / "+DG);
			if(i==4)
				$(this).children().eq(1).html("<font class='purple'>"+data.tchnlgyCount.progress+"</font> / "+IC);

		});
		$("#sido1 tr").each(function(i,v){
			if(i==1)
				$(this).children().eq(1).html("<font class='purple'>"+SU2+"</font> / "+SU);
			if(i==2)
				$(this).children().eq(1).html("<font class='purple'>"+BS2+"</font> / "+BS);
			if(i==3)
				$(this).children().eq(1).html("<font class='purple'>"+DG2+"</font> / "+DG);
			if(i==4)
				$(this).children().eq(1).html("<font class='purple'>"+IC2+"</font> / "+IC);
			if(i==5)
				$(this).children().eq(1).html("<font class='purple'>"+GJ2+"</font> / "+GJ);
			if(i==6)
				$(this).children().eq(1).html("<font class='purple'>"+DJ2+"</font> / "+DJ);
			if(i==7)
				$(this).children().eq(1).html("<font class='purple'>"+US2+"</font> / "+US);
			
		});
		$("#sido2 tr").each(function(i,v){
			if(i==1)
				$(this).children().eq(1).html("<font class='purple'>"+GG2+"</font> / "+GG);
			if(i==2)
				$(this).children().eq(1).html("<font class='purple'>"+GW2+"</font> / "+GW);
			if(i==3)
				$(this).children().eq(1).html("<font class='purple'>"+NC2+"</font> / "+NC);
			if(i==4)
				$(this).children().eq(1).html("<font class='purple'>"+SC2+"</font> / "+SC);
			if(i==5)
				$(this).children().eq(1).html("<font class='purple'>"+NJ2+"</font> / "+NJ);
			if(i==6)
				$(this).children().eq(1).html("<font class='purple'>"+SJ2+"</font> / "+SJ);
			if(i==7)
				$(this).children().eq(1).html("<font class='purple'>"+NG2+"</font> / "+NG);
			if(i==8)
				$(this).children().eq(1).html("<font class='purple'>"+SG2+"</font> / "+SG);
			if(i==9)
				$(this).children().eq(1).html("<font class='purple'>"+JJ2+"</font> / "+JJ);
			if(i==10)
				$(this).children().eq(1).html("<font class='purple'>"+SE2+"</font> / "+SE);
			
		});
	});
});
			
	function startInterval(seconds, callback) { 
		callback(); 
	return setInterval(callback, seconds * 1000);
	}

</script> -->

	
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
