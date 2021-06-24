 /** 
  * Writing day : 2019.05.13
  * Modifying day : 2019.05.13
  * Writer : LukeHan(LukeHan1128@gmail.com)
  */

$(document).ready(function(){
	setNav('PC관리');
	
	// 그룹 클릭
	$('.groupLabel').on('click', function(){
		group_label_fnt(this);
	});
	
	// 잠금(true)/해제(false) 버튼
	$('#grid').on('click', '.lockBtn', function(){
		var msg = '';
		
		/* 알림이 뜨는게 if 문 확인보다 빠름..
		if($(this).attr('data-value')) {
			confirm('잠금을 설정 하시겠습니까?');
		}else{
			confirm('잠금을 해제 하시겠습니까?');
		}*/
	});
	
	// 페이지 로딩시 자동 클릭
	$('.groupLabel').eq(0).trigger('click');
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
