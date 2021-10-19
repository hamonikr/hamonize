<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../template/head.jsp" %>
 
<!-- Fontfaces CSS-->
<link href="/css/font-face.css" rel="stylesheet" media="all">
<link href="/vendor/font-awesome-4.7/css/font-awesome.min.css" rel="stylesheet" media="all">
<link href="/vendor/font-awesome-5/css/fontawesome-all.min.css" rel="stylesheet" media="all">
<link href="/vendor/mdi-font/css/material-design-iconic-font.min.css" rel="stylesheet" media="all">
<link href="/vendor/chartjs/Chart.bundle.min.js" rel="stylesheet" media="all">

<!-- Bootstrap CSS-->
<link href="/vendor/bootstrap-4.1/bootstrap.min.css" rel="stylesheet" media="all">


<!-- Main CSS-->
<link href="https://coderthemes.com/hyper/saas/assets/css/app.min.css" rel="stylesheet" type="text/css" id="light-style" />

<link rel="stylesheet" type="text/css" href="/css/sgb/common.css">
<link rel="stylesheet" type="text/css" href="/css/sgb/content.css">
 
     
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
        ol, ul {
			    padding-left: 0rem;
			}
	</style>
<body class="animsition">
	<%@ include file="../template/topMenu.jsp" %>
	
	
                        
     <div class="row">
       <div class="col-xl-3 col-lg-4">
           <div class="card tilebox-one">
               <div class="card-body">
                   <em class="zmdi zmdi-desktop-windows float-end"></em>
                   <h6 class="text-uppercase mt-0">Total Computers</h6>
                   <h2 class="my-2" id="totalComputers"></h2>
               </div> <!-- end card-body-->
           </div>
           <!--end card-->

           <div class="card tilebox-one">
               <div class="card-body">
                   <em class="zmdi zmdi-devices float-end"></em>
                   <h6 class="text-uppercase mt-0">Active Computers</h6>
                   <h2 class="my-2" id="onComputers"></h2>
               </div> <!-- end card-body-->
           </div>
           <!--end card-->
           
           <div class="card tilebox-one">
               <div class="card-body">
                   <em class="zmdi zmdi-devices-off float-end"></em>
                   <h6 class="text-uppercase mt-0">Off Computers</h6>
                   <h2 class="my-2" id="offComputers"></h2>
               </div> <!-- end card-body-->
           </div>
           <!--end card-->

       </div> <!-- end col -->

       <div class="col-xl-9 col-lg-8">
           <div class="card card-h-100">
               <div class="card-body">
                   <div class="alert alert-warning alert-dismissible fade show mb-3" role="alert">
                       	PC 사용현황 
                   </div>
						<iframe title="Main monitoring" src="http://${svo.svr_ip}:${svo.svr_port}/d-solo/nprv87G7z/hamonize-main2?orgId=1&refresh=10s&panelId=2" width="100%" height="350" frameborder="0" ></iframe>
                </div> <!-- end card-body-->
           </div> <!-- end card-->
       </div>
       
		<div class="row" id="list">
     		

      <!-- end col-->

 		</div>
                               
   </div>
   
	
	
	
    <script type="text/javascript">
    function addZero(data){
        return (data<10) ? "0"+data : data;
    }
    $(document).ready(function(){
    $.post("/mntrng/pcPolicyList",{org_seq:1,type:'main'},
				function(data){
            var shtml = "";
            
			if( data.pcList.length > 0){
                
                
                	shtml += "<div class='col-xl-6 col-lg-6'>";
					shtml += "<div class='card' style='height: 300px;'>";
                	shtml += "<div class='card-body'>";
                	shtml += "<h4 class='header-title mt-1 mb-3'>업데이트 배포결과</h4>";

                	shtml += "<div class='table-responsive'>";
                	shtml += "<table class='table table-sm table-centered mb-0 font-14'>";
                	shtml += "<thead class='table-light'>";
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
						console.log("data.policyUpdtResult[i].count : "+data.policyUpdtResult[i].count)
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
					shtml += "</div>";
					shtml += "</div>";

					
                
                shtml += "<div class='col-xl-6 col-lg-6'>";
				shtml += "<div class='card' style='height: 300px;'>";
            	shtml += "<div class='card-body'>";
            	shtml += "<h4 class='header-title mt-1 mb-3'>프로그램 차단  배포결과</h4>";

            	shtml += "<div class='table-responsive'>";
            	shtml += "<table class='table table-sm table-centered mb-0 font-14'>";
            	shtml += "<thead class='table-light'>";
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
					shtml += "</div>";
					shtml += "</div>";
                
                
                shtml += "<div class='col-xl-6 col-lg-6'>";
				shtml += "<div class='card'  style='height: 300px;'>";
            	shtml += "<div class='card-body'>";
            	shtml += "<h4 class='header-title mt-1 mb-3'>방화벽 정책  배포결과</h4>";

            	shtml += "<div class='table-responsive'>";
            	shtml += "<table class='table table-sm table-centered mb-0 font-14'>";
            	shtml += "<thead class='table-light'>";
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
					shtml += "</div>";
					shtml += "</div>";   
                

                shtml += "<div class='col-xl-6 col-lg-6'>";
				shtml += "<div class='card' style='height: 300px;'>";
            	shtml += "<div class='card-body'>";
            	shtml += "<h4 class='header-title mt-1 mb-3'>디바이스 정책  배포결과</h4>";

            	shtml += "<div class='table-responsive'>";
            	shtml += "<table class='table table-sm table-centered mb-0 font-14'>";
            	shtml += "<thead class='table-light'>";
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
					shtml += "</div>";
					shtml += "</div>";   
                
                $("#list").append(shtml);
				
			}else{  
				shtml += "<tr><td colspan='7' style='text-align:center;'>등록된 데이터가 없습니다. </td></tr>";
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
		$("#totalComputers").text(data.pcList.length); 
		$("#onComputers").text(data.on);
		$("#offComputers").text(data.off);		 
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
