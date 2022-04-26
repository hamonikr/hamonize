<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="./template/head.jsp" %>
<%@ include file="./template/left.jsp" %>



<section class="scrollable">
	<section class="hbox stretch">
		<!-- body left Start  -->


		<!-- body right -->
		<aside class="bg-white ">
			<section class="vbox">
				<section class="scrollable">
					
					
					
					<div class="wrapper" id="capture">
						<section class="panel panel-default ">
							<footer class="panel-footer bg-light lter">
								<button class="btn btn-info pull-right btn-sm" id="menual-download">bbbbbbbb</button>
								<button class="btn btn-info pull-right btn-sm" id="savePdfBtn">aaaaaaaaa</button>
								
								<ul class="nav nav-pills nav-sm">
									<li><a href="#"><i class="fa fa-camera text-muted"></i>사용자메뉴얼</a></li>
								</ul>
							</footer>
						</section>
							
						<section class="panel panel-default pdf_page">
							<h4 class="font-thin padder">Hamonize 사용법 </h4>
							<ul class="list-group">
								<li class="list-group-item">
									<p>모니터링 </p>
									<small class="block text-muted">조직 내 PC의 하드웨어 정보, IP주소 등 세부 정보와 실시간 사용 정보를 확인하는 모니터링 서비스</small>
									<small class="block text-muted">조직 내 PC에 접속해 원격으로 제어, 관리하는 원격제어 서비스</small>
									<img src="/img/error1.png" width="500px;"><br>
									<img src="/img/error1.png" width="500px;"><br>
									<img src="/img/hamonize_img.png" width="500px;" height="500px"><br>
									<img src="/img/error1.png" width="500px;"><br>
									<img src="/img/error1.png" width="500px;"><br>
								</li>
							</ul>
							1
						</section>
						
					
						
						<section class="panel panel-default pdf_page">
							<h4 class="font-thin padder">Hamonize 사용법 </h4>
							<ul class="list-group">
								<li class="list-group-item">
									<p>모니터링 </p>
									<small class="block text-muted">조직 내 PC의 하드웨어 정보, IP주소 등 세부 정보와 실시간 사용 정보를 확인하는 모니터링 서비스</small>
									<small class="block text-muted">조직 내 PC에 접속해 원격으로 제어, 관리하는 원격제어 서비스</small>
									<img src="/img/error2.png" width="500px;">
								</li>
							</ul>
							2
						</section>
						<section class="panel panel-default pdf_page">
							<h4 class="font-thin padder">Hamonize 사용법 </h4>
							<ul class="list-group">
								<li class="list-group-item">
									<p>모니터링 </p>
									<small class="block text-muted">조직 내 PC의 하드웨어 정보, IP주소 등 세부 정보와 실시간 사용 정보를 확인하는 모니터링 서비스</small>
									<small class="block text-muted">조직 내 PC에 접속해 원격으로 제어, 관리하는 원격제어 서비스</small>
									<img src="/img/hamonize_img.png" width="500px;" height="500px">
								</li>
							</ul>
							3
						</section>
					
						
					</div>
				</section>
			</section>
		</aside>

 
	</section>
</section>

 <script src="https://html2canvas.hertzen.com/dist/html2canvas.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/es6-promise/4.1.1/es6-promise.auto.js"></script>
<script src="https://html2canvas.hertzen.com/dist/html2canvas.min.js"></script>
<!-- <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/1.3.4/jspdf.min.js"></script> -->

<!-- <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script> -->
<!-- <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/0.4.1/html2canvas.js"></script> -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/1.0.272/jspdf.debug.js"></script>
<script language = "javascript">
 
// const doc = new jsPDF({
//   orientation: "landscape",
// //   orientation: "portrait",
//   format: "a4"
// //   format: [4, 2]
// });
 
// doc.addHTML(document.body,function() {
//     doc.save('html.pdf');
// });
 $('#savePdfBtn').click(function() { html2canvas($('#capture')[0]).then(function(canvas) { // 캔버스를 이미지로 변환 
	 let imgData = canvas.toDataURL('image/png'); let margin = 10; // 출력 페이지 여백설정 
	 let imgWidth = 410 - (10 * 2); // 이미지 가로 길이(mm) A4 기준
	 let pageHeight = imgWidth * 1.414; // 출력 페이지 세로 길이 계산 A4 기준
	 let imgHeight = canvas.height * imgWidth / canvas.width; 
	 let heightLeft = imgHeight; let doc = new jsPDF('p', 'mm'); 
	 let position = margin; // 첫 페이지 출력
	 doc.addImage(imgData, 'PNG', margin, position, imgWidth, imgHeight); 
	 heightLeft -= pageHeight; // 한 페이지 이상일 경우 루프 돌면서 출력 
	 while (heightLeft >= 20) { position = heightLeft - imgHeight; doc.addImage(imgData, 'PNG', 0, position, imgWidth, imgHeight); doc.addPage(); heightLeft -= pageHeight; } // 파일 저장
	 doc.save('sample.pdf'); }); 
 });

</script>



<script language = "javascript">

	
		  $("#menual-download").click(function() { // pdf저장 button id
		    // setTImeout을 하는 이유는 html2canvas를 불러오는게 너무 빨라서 앞의 js가 먹혀도 반영되지 않은 것처럼 보임
		    // 따라서 0.1 초 지연 발생 시킴
		      setTimeout(function() {
		        createPdf();
		      }, 100);
		  });

		var renderedImg = new Array;

		var contWidth = 400, // 너비(mm) (a4에 맞춤)
		    padding = 5; //상하좌우 여백(mm)

		function createPdf() { //이미지를 pdf로 만들기

		  var lists = document.querySelectorAll(".pdf_page"),
		      deferreds = [],
		      doc = new jsPDF("p", "mm", "a4"),
		      listsLeng = lists.length;
	
		  for (var i = 0; i < listsLeng; i++) { // pdf_page 적용된 태그 개수만큼 이미지 생성
		    var deferred = $.Deferred();
		    deferreds.push(deferred.promise());
		    generateCanvas(i, doc, deferred, lists[i]);
		  }

		  $.when.apply($, deferreds).then(function () { // 이미지 렌더링이 끝난 후
		    var sorted = renderedImg.sort(function(a,b){return a.num < b.num ? -1 : 1;}), // 순서대로 정렬
		        curHeight = padding, //위 여백 (이미지가 들어가기 시작할 y축)
		        sortedLeng = sorted.length;
		    for (var i = 0; i < sortedLeng; i++) {
		      var sortedHeight = sorted[i].height, //이미지 높이
		          sortedImage = sorted[i].image; //이미지
					console.log(curHeight +"=="+ sortedHeight +"=="+ padding +"------------_"+ (curHeight + sortedHeight) + "=====+"+ (297 - padding * 2) );
		   		
		          
// 		          if( (curHeight + sortedHeight) > 150 ){ // a4 높이에 맞게 남은 공간이 이미지높이보다 작을 경우 페이지 추가
		     if( curHeight + sortedHeight > 297 - padding * 2 ){ // a4 높이에 맞게 남은 공간이 이미지높이보다 작을 경우 페이지 추가
		    	  
		    	  console.log("===1111==========" + i);
		        doc.addPage(); // 페이지를 추가함
		        curHeight = padding; // 이미지가 들어갈 y축을 초기 여백값으로 초기화
		        console.log("curHeight=="+ curHeight);
		        console.log("contWidth=="+ contWidth);
		        console.log("sortedHeight=="+ sortedHeight);
// 		        console.log("sortedImage=="+ sortedImage);
		       
		        doc.addImage(sortedImage, 'png', padding , curHeight, contWidth, sortedHeight); //이미지 넣기
		        curHeight += sortedHeight; // y축 = 여백 + 새로 들어간 이미지 높이
		   
		      } else { // 페이지에 남은 공간보다 이미지가 작으면 페이지 추가하지 않음
		    	  console.log("=====22222222222========" + i);
		        doc.addImage(sortedImage, 'png', padding , curHeight, contWidth, sortedHeight); //이미지 넣기
		        curHeight += sortedHeight; // y축 = 기존y축 + 새로들어간 이미지 높이
		      }
		          console.log("curHeigsssssssssssssssssssssssht=="+ curHeight);
// 		      doc.addImage(sortedImage, 'png', padding , curHeight, contWidth, sortedHeight); //이미지 넣기
// 		        curHeight += sortedHeight; // y축 = 기존y축 + 새로들어간 이미지 높이
		    }
		    doc.save('resultReport.pdf'); //pdf 저장

		    curHeight = padding; //y축 초기화
		    renderedImg = new Array; //이미지 배열 초기화
		  });
		}

		function generateCanvas(i, doc, deferred, curList){ //페이지를 이미지로 만들기
		  var pdfWidth = $(curList).outerWidth() * 0.2645, //px -> mm로 변환
		      pdfHeight = $(curList).outerHeight() * 0.2645,
		      heightCalc = contWidth * pdfHeight / pdfWidth; //비율에 맞게 높이 조절
		  html2canvas( curList ).then(
		    function (canvas) {
		      var img = canvas.toDataURL('image/png', 1.0); //이미지 형식 지정
		      renderedImg.push({num:i, image:img, height:heightCalc}); //renderedImg 배열에 이미지 데이터 저장(뒤죽박죽 방지)     
		      deferred.resolve(); //결과 보내기
		    }
		  );
		}
		
</script>



