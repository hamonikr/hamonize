 /** 
  * Writing day : 2019.05.15
  * Modifying day : 2019.05.15
  * Writer : LukeHan(LukeHan1128@gmail.com)
  */

$(document).ready(function(){
	setNav('고장신고 > 상세보기');
	
	// 에디터 설정
	$('iframe').addClass('iframe');
	
	// 수정 완료 버튼
	$('#updateDoneBtn').on('click', function(){
		updateNoticeFtn();
	});
	
	// 취소 버튼
	$('.cancelBtn').on('click', function(){
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
	
	// 답변작성 버튼
	$('#replyBtn').on('click', function(){
		replyFtn();
	});
	
	// 답변작성 완료 버튼
	$('#replyAddBtn').on('click', function(){
		replyAddFtn();
	});
	
	// 목록으로 버튼
	$('.dtqrtListBtn').on('click', function(){
		location.href='/dtqrt/dtqrtList';
	});

	
	
	
	var demoTxt = '';
	demoTxt += '<p>안녕하십니까. 육군 1사단 2대대 3중대 4소대 5생활관에서 복무중인 병장 김남길 입니다. </p>';
	demoTxt += '<p>다름이 아니라 이번에 도입된 피시방 관리 프로그램의 이름을 알고싶습니다.</p>';
	demoTxt += '<p>입대전 생업에 종사하기 위해 다양한 경험을 하였으나, </p>';
	demoTxt += '<p>이만큼 좋은 피시 관리 프로그램을 보지 못한것 같습니다</p>';
	demoTxt += '<p>제대후 해당 프로그램을 사용하여 개인 피시방 운영을 하고 싶은데 </p>';
	demoTxt += '<p>제작업체를 알고자 이렇게 부득이하게 연락을 드렸습니다.</p>';
	demoTxt += '<p>해당 프로그램과 업체명 연락처 등 등의 정보를 알려주시기 바랍니다.</p>';
	demoTxt += '<p>감사합니다.</p>';
	
	addContentFtn(
			'육군 1사단 2대대 3중대 4소대', 
			'병장', 
			'18-12345678', 
			'김남길',  
			'이 프로그램을 써 보고싶은데 이름이 무엇입니까?', 
			demoTxt,  
			'HamoniKR-ME', 
			'2019.05.08', 
			'완료', 
			110
	);
	
	/*
	soldierGroup
	soldierRank
	soldierNumber
	soldierName
	dtqrtTitle
	dtqrtContent
	dtqrtDevice
	dtqrtDate
	dtqrtStatus
	*/
});


/* 페이지 내용 설정 */
function addContentFtn(soldierGroup, soldierRank, soldierNumber, writer, 
		title, content, device, date, status, count){
	var statusList = ['처리중', '완료'];
	var statusBgLsit = ['dtqrtProcessing', 'dtqrtCompletion'];
	
	$('#soldierGroup').text(soldierGroup);
	$('#soldierRank').text(soldierRank);
	$('#soldierNumber').text(soldierNumber);
	$('#soldierName').text(writer);
	$('#contentTitle').val(title);
	$('#content').html(content);
	$('#contentDetail').val(content);
	$('#dtqrtDevice').text(device);
	$('#dtqrtDate').text(date);
	$('#dtqrtStatusReadonly').val(status);
	$('#dtqrtCount').text(count);
	
	for(var i=0;i<statusList.length;++i){
		if(statusList[i] == status) $('#dtqrtStatusReadonly').addClass(statusBgLsit[i]);
	}
}

/* 삭제 */
function deleteNoticeFtn(){
	if(confirm('게시물을 삭제합니다. 삭제하시겠습니까?')){
		alert('삭제 되었습니다.');
		location.href='/dtqrt/dtqrtList';
	}
}

/* 수정 버튼 */
function updateNoticeFtn(){
	// 수정 후 페이지 새로고침
	location.reload();
}

/* 내용 수정 가능 폼으로 변경 */
function changeUpdateFormFtn(){
	var dtqrtStatusValue = $('#dtqrtStatusReadonly').val();
	
	// 상단 설정
	$("#dtqrtStatus").val(dtqrtStatusValue).prop("selected", true);
	$('#dtqrtStatusReadonly').css('display', 'none');
	$('#dtqrtStatus').css('display', '');
	
	// 하단 버튼 설정
	$('#contentUpdateBtn').css('display', '');
	$('#contentFooter').css('display', 'none');
	
	// 입력기
	$('#updateForm .iframe').removeClass('iframe');
	
	// 입력값 설정
	$('#contentTitle').attr('disabled', false).removeClass('noticeDisabled').focus();
	$('#content').css('display', 'none');
//	$('#contentDetail').attr('disabled', false).removeClass('noticeDisabled').css('display', 'block');
}

/* 답변작성 가능 폼으로 변경 */
function replyFtn(){
	var dtqrtStatusValue = $('#dtqrtStatusReadonly').val();
	
	// 전체
	$('#replyForm').css('height','').css('height','');
	
	// 상단 설정
	$("#dtqrtStatusReply").val(dtqrtStatusValue).prop("selected", true);
	$('#dtqrtStatusReply').css('display', '');
	
	// 하단 버튼 설정
	$('#contentUpdateBtn').css('display', 'none');
	$('#contentFooter').css('display', 'none');
	
	// 입력기
	$('#replyForm .iframe').removeClass('iframe');
}

/* 답변작성 완료 버튼 */
function replyAddFtn(){
	alert('작성이 완료되었습니다.');
	location.reload();
};
