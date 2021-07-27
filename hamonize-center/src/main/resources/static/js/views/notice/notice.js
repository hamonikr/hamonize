 /** 
  * Writing day : 2019.05.13
  * Modifying day : 2019.05.13
  * Writer : LukeHan(LukeHan1128@gmail.com)
  */

$(document).ready(function(){
	setNav('공지사항');
	
	// 상세보기 버튼
	$('#grid').on('click', '.tui-grid-rside-area .tui-grid-cell-content', function(){
		var idx = $(this).children('input[name=idx]').val();
		var form = $('<form></form>');
		
		form.attr('action', '/notice/noticeDetail');
		form.attr('method', 'post');
		form.append('<input type="hidden" name="solderId" value="' + idx + '">');
		form.appendTo('body');
		form.submit();
	});
	
	// 등록 버튼
	$('.insertBtn').on('click', function(){
		location.href='/notice/noticeInsert';
	});
	
	// 전체공지 버튼
	$('.totalNtcBtn').on('click', function(){
		console.log('전체공지 버튼');
	});
	
	// 상시공지 버튼
	$('.permanentNtcBtn').on('click', function(){
		console.log('상시공지 버튼');
	});
	
	// 특별공지 버튼
	$('.specialNtcBtn').on('click', function(){
		console.log('특별공지 버튼');
	});
	
	// 부서별 목록 생성
	$('#selectGroup').on('change', function(){
		console.log('부서별 목록 생성 - 선택옵션 : ' + $(this).val());
	});
	
	// 직급별 목록 생성
	$('#SelectRank').on('change', function(){
		console.log('직급별 목록 생성 - 선택옵션 : ' + $(this).val());
	});
	
	
	// 페이지 로딩시 부서별선택 목록 생성
	for(i=1; i<21 ;++i){
		addSelectOption(false, $('#selectGroup'), i+'대대', i+'대대');
	}
	
	// 페이지 로딩시 직급별 선택 목록 생성
	var rankList = ['간부','사병','이등병','상병','병장'];
	for(i=0; i<rankList.length ;++i){
		addSelectOption(false, $('#SelectRank'), rankList[i], rankList[i]);
	}
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

/* 부서별/직급별 목록 생성 */
function addSelectOption(empty, selectElem, optinName, optinValue){
	var val = $(selectElem).val();
	var createOption = '';
	
	if(empty) {
		$(selectElem).empty();
		
		if(val == 'selectGroup') createOption = '<option value="' + val + '">부서별</option>';
		if(val == 'SelectRank') createOption = '<option value="' + val + '">직급별</option>';
		
		$(selectElem).append($(createOption));
	}
	createOption = '<option value="' + optinValue + '">' + optinName + '</option>';
	$(selectElem).append($(createOption));
}
