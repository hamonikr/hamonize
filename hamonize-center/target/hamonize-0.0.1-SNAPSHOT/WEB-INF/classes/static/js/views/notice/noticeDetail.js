 /** 
  * Writing day : 2019.05.15
  * Modifying day : 2019.05.15
  * Writer : LukeHan(LukeHan1128@gmail.com)
  */

$(document).ready(function(){
	setNav('공지사항 > 상세보기');
	
	// 수정 완료 버튼
	$('#updateDoneBtn').on('click', function(){
		updateNoticeFtn();
	});
	
	// 취소 버튼
	$('#cancelBtn').on('click', function(){
		location.reload();
	});
	
	// 수정 버튼
	$('#updateBtn').on('click', function(){
		changeUpdateFormFtn();
	});
	
	// 삭제 버튼
	$('#deleteBtn').on('click', function(){
		deleteNoticeFtn();
	});
	
	// 목록으로 버튼
	$('#noticeListBtn').on('click', function(){
		location.href='/notice/notice';
	});

	
	
	
	var demoTxt = '';
	demoTxt += '<p>육군특전사 천마부대, 불발탄 확인·방제 작업 </p>';
	demoTxt += '<p><img src="http://www.mnd.go.kr/media/newspaper/tmplat/upload/20190508/thumb1/2019050301000087500003111.jpg" alt="육군특수전사령부 천마부대가 ‘미래드론 교육원’의 협조를 기반으로 정찰용 드론을 활용해 총 3360㎡ 규모의 불발탄 위험 지역에 대한 항공정찰 및 제초제 살포 작업을 하고 있다.  부대 제공" class="txc-image" id="2019050301000087500003111" ondblclick="parent.DemaEdit.photoEditorOpen(\'2019050301000087500003111\')"> </p>';
	demoTxt += '<p>“위험한 곳, 이제 드론이 간다!” </p>';
	demoTxt += '<p>육군특수전사령부 천마부대가 고폭탄 불발탄 지역에 ‘드론’을 투입해 안전한 봄철 화재 예방 활동을 펼쳐 눈길을 끈다. </p>';
	demoTxt += '<p>천마부대는 7일 “전북 소재 ‘미래드론 교육원’의 협조를 바탕으로 정찰용 드론을 활용해 폭발물 처리 전문가 이외에는 접근이 금지된 고폭탄 불발탄 지역의 불발탄 확인 및 방제 작업을 안전하게 마쳤다”고 밝혔다. </p>';
	demoTxt += '<p>부대는 총 3360㎡ 규모의 불발탄 위험 지역에 대한 드론 항공정찰 및 제초제 살포 작업을 통해 화재 예방 효과와 함께 불발탄 조기 식별 능력까지 확보하는 성과를 거뒀다. 이는 드론이 유사시 작전 상황에서뿐만 아니라, 평시 안전관리 등 각종 부대 활동에도 유용하게 활용될 수 있음을 보여준다. </p>';
	demoTxt += '<p>천마부대는 지난 2월 ‘미래드론 교육원’과 체결한 업무협약을 바탕으로 드론 전문가를 양성하고 있다. 지금까지 총 12명의 부대원이 드론 조종사 자격증을 취득한 상태다. </p>';
	demoTxt += '<p>부대는 세계 최정예 대체불가 특전사 양성을 위해 앞으로 드론 전문가 양성 및 활용 분야 확장에 더욱 힘쓸 방침이다. 김상윤 기자 </p>';
	demoTxt += '<p>김상윤 기자 < < ksy0609@dema.mil.kr ></p>';
	demoTxt += '<p>< 저작권자 ⓒ 국방일보, 무단전재 및 재배포 금지 ></p>';
	
	addContentFtn(
			'‘드론’으로… 봄철 화재 예방', 
			demoTxt, 
			'관리자', 
			'2019.05.08', 
			110
	);
});


/* 페이지 내용 설정 */
function addContentFtn(title, content, writer, date, count){
	$('#contentTitle').val(title);
	$('#content').html(content);
	$('#contentDetail').val(content);
	$('#contentWriter').text(writer);
	$('#contentDate').text(date);
	$('#contentCount').text(count);
}

/* 공지 삭제 */
function deleteNoticeFnt(){
	if(confirm('게시물을 삭제합니다. 삭제하시겠습니까?')){
		alert('삭제 되었습니다.');
		location.href='/notice/notice';
	}
}

/* 수정 완료 버튼 */
function updateNoticeFtn(){
	// 수정 후 페이지 새로고침
	location.reload();
}

/* 내용 수정 가능 폼으로 변경 */
function changeUpdateFormFtn(){
	// 하단 버튼 설정
	$('#contentUpdateBtn').css('display', '');
	$('#contentFooter').css('display', 'none');
	
	// 입력값 설정
	$('#contentTitle').attr('disabled', false).removeClass('noticeDisabled').focus();
	$('#content').css('display', 'none');
	$('#contentDetail').attr('disabled', false).removeClass('noticeDisabled').css('display', 'block');
}
