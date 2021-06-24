 /** 
  * Writing day : 2019.05.13
  * Modifying day : 2019.05.13
  * Writer : LukeHan(LukeHan1128@gmail.com)
  */

$(document).ready(function(){
	setNav('로그감사 > 사용자 접속 현황');
	
	// 그룹 클릭
	$('.groupLabel').on('click', function(){
		group_label_fnt(this);
	});
	
	// 페이지 로딩시 자동 클릭
	$('.groupLabel').eq(0).trigger('click');
});

/* 그룹 클릭 */
function group_label_fnt(doc){
	$('#contentTitle').text($(doc).text());
}
