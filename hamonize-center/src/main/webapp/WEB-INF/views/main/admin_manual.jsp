<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp"%>

<!-- Fontfaces CSS-->
<link href="/css/font-face.css" rel="stylesheet" media="all">
<link href="/vendor/font-awesome-4.7/css/font-awesome.min.css" rel="stylesheet" media="all">
<link href="/vendor/font-awesome-5/css/fontawesome-all.min.css" rel="stylesheet" media="all">
<link href="/vendor/mdi-font/css/material-design-iconic-font.min.css" rel="stylesheet" media="all">
<link href="/vendor/chartjs/Chart.bundle.min.js" rel="stylesheet" media="all">

<!-- Bootstrap CSS-->
<link href="/vendor/bootstrap-4.1/bootstrap.min.css" rel="stylesheet" media="all">

<!-- Vendor CSS-->
<!-- <link href="/vendor/animsition/animsition.min.css" rel="stylesheet" media="all"> -->
<!-- <link href="/vendor/bootstrap-progressbar/bootstrap-progressbar-3.3.4.min.css" rel="stylesheet" media="all"> -->
<!-- <link href="/vendor/wow/animate.css" rel="stylesheet" media="all"> -->
<!-- <link href="/vendor/css-hamburgers/hamburgers.min.css" rel="stylesheet" media="all"> -->
<!-- <link href="/vendor/slick/slick.css" rel="stylesheet" media="all"> -->
<!-- <link href="/vendor/select2/select2.min.css" rel="stylesheet" media="all"> -->
<!-- <link href="/vendor/perfect-scrollbar/perfect-scrollbar.css" rel="stylesheet" media="all"> -->

<!-- Main CSS-->
<!-- <link href="/css/theme.css" rel="stylesheet" media="all"> -->
<!-- <link href="https://coderthemes.com/hyper/saas/assets/css/app.min.css" rel="stylesheet" type="text/css" id="light-style" /> -->

<link rel="stylesheet" type="text/css" href="/css/sgb/common.css">
<link rel="stylesheet" type="text/css" href="/css/sgb/content.css">

<style>
/* .col-lg-3 { */
/* 	-ms-flex: 0 0 33%; */
/* 	flex: 0 0 33%; */
/* 	max-width: 33%; */
/* } */

/* .col-lg-9 { */
/* 	flex: 0 0 75%; */
/* 	max-width: 50%; */
/* } */

/* ol, ul { */
/* 	padding-left: 0rem; */
}
</style>
<body class="animsition">
<%-- 	<%@ include file="../template/topMenu.jsp"%> --%>
<div class="hamo_header">
	<div class="admin_info">
	</div>
	
	<h1 class="logo"><a href="/main"><img alt="하모나이즈 로고" src="/images/hlogo.png" /></a></h1>

        <div class="menubar">
        <ul>
                <li></li>
            </ul>
        </div>
</div>



	<div class="row">
		<div class="col-xl-3 col-lg-4">
			<div class="card tilebox-one">
				<div class="card-body">
					<em class="zmdi zmdi-desktop-windows float-end"></em>
					<h4 class="text-uppercase mt-0">중앙관리서비스</h4>
					<h3 class="my-2" style='cursor: pointer;' id="hcentermanual">Hamonize-Center 사용법 </h3>
				</div>
				<!-- end card-body-->
			</div>
			<!--end card-->

			<div class="card tilebox-one">
				<div class="card-body">
					<em class="zmdi zmdi-devices float-end"></em>
					<h4 class="text-uppercase mt-0">원격관리툴</h4>
					<h3 class="my-2" style='cursor: pointer;' id="hdaminmanual">Hamonize-Admin 사용법</h3>
				</div>
				<!-- end card-body-->
			</div>
			<!--end card-->

			<div class="card tilebox-one">
				<div class="card-body">
					<em class="zmdi zmdi-devices-off float-end"></em>
					<h6 class="text-uppercase mt-0">원격관리툴</h6>
					<h3 class="my-2" style='cursor: pointer;' id="toolAdminInstall"> Hamonize-Admin 설치 방법</h3>
					<h3 class="my-2" style='cursor: pointer;' id="toolAdminDownload"> Hamonize-Admin Download</h3>
				</div>
				<!-- end card-body-->
			</div>
			<!--end card-->

		</div>
		<!-- end col -->

		<div class="col-xl-9 col-lg-8">
			<div class="card card-h-100">
				<div class="card-body">
					<div class="alert alert-warning alert-dismissible fade show mb-3" role="alert">Hamonize-Manual </div>
 					<embed src="/img/hamonize_manual.pdf" type="application/pdf" width='100%' height='1200px' id="pdfView"/>
				</div>
				<!-- end card-body-->
			</div>
			<!-- end card-->
		</div>

		<div class="row" id="list">

			<!-- end col-->

		</div>

	</div>

${ip}


<script>

$(document).ready(function(){
	
	$("#hcentermanual").on("click",function(){
		$("#pdfView").attr("src","/img/hamonize_manual.pdf");
	});
	
	$("#hdaminmanual").on("click",function(){
		$("#pdfView").attr("src","/img/hamonize-admin.pdf");
	});

	$("#toolAdminInstall").on("click",function(){
		$("#pdfView").attr("src","/img/hamonize-admin.pdf");
	});

	$("#toolAdminDownload").on("click",function(){
		location.href ="http://${ip}:${port}/pool/main/h/hamonize-admin/hamonize-admin_1.0.0_amd64.deb";
	});
	
});

</script>

</body>
