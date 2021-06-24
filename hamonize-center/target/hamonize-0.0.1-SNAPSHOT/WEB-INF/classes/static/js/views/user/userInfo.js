 /** 
  * Writing day : 2019.05.15
  * Modifying day : 2019.05.15
  * Writer : LukeHan(LukeHan1128@gmail.com)
  */

$(document).ready(function(){
	setNav('사용자관리 > 상세보기');
	
	// 그룹 클릭
	$('.groupLabel').on('click', function(){
		group_label_fnt(this);
	});
	
	
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
		deleteUserFtn();
	});
	
	// 목록으로 버튼
	$('#listBtn').on('click', function(){
		location.href='/user/management';
	});
	
	addContentFtn(
		'김남길', 
		'18-12345678', 
		'이등병', 
		'kimnam', 
		'사용자', 
		'2019-04-26 11:53:40', 
		'2019-04-26 13:32:50', 
		'2021-04-26'
	);
});


/* 그룹 클릭 */
function group_label_fnt(doc){
	var $updoc = $(doc);
	var roop_ck = 1;
	var txt = '';
	
	while(roop_ck == 1){
		$updoc = $($updoc).parent().parent().parent().prev().children('.groupLabel');
		roop_ck = $updoc.length;
		
		if(roop_ck == 1){
			txt = $updoc.text() + ' > ' + txt;
		}
	}
	console.log(' -- txt : ' + txt);
	$('#contentTitle').text(txt + $(doc).text());
}

/* 내용 설정 */
function addContentFtn(name, number, rank, id, kind, ist_dt, udt_dt, discharge_dt){
	$('#soldierName').val(name);
	$('#soldierNumber').val(number);
	$('#solderRank').val(rank);
	$('#solderId').val(id);
	$('#kind').val(kind);
	$('#ist_dt').val(ist_dt);
	$('#udt_dt').val(udt_dt);
	$('#discharge_dt').val(discharge_dt);
}

/* 삭제 */
function deleteUserFtn(){
	if(confirm('사용자를 삭제합니다. 삭제하시겠습니까?')){
		alert('삭제 되었습니다.');
		location.href='/user/management';
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
	
	$('#soldierName').attr('disabled', false).removeClass('userDisabled').focus();
	$('#soldierNumber').attr('disabled', false).removeClass('userDisabled');
	$('#solderRank').attr('disabled', false).removeClass('userDisabled');
	$('#solderId').attr('disabled', false).removeClass('userDisabled');
	$('#discharge_dt').attr('disabled', false).removeClass('userDisabled');
}
