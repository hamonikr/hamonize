 /** 
  * Writing day : 2019.05.13
  * Modifying day : 2019.05.13
  * Writer : LukeHan(LukeHan1128@gmail.com)
  */

$(document).ready(function(){
	setNav('백업 및 복구 > 최근 백업본 복원');
	
	// 그룹 클릭
	$('.groupLabel').on('click', function(){
		group_label_fnt(this);
	});
	
	// 복원하기 버튼
	$('#grid').on('click', '.recoveryBtn', function(){
		console.log(" -- $('#grid').on('click', '.recoveryBtn', function(){ .. }");
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

