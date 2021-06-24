 /** 
  * Writing day : 2019.05.13
  * Modifying day : 2019.05.13
  * Writer : LukeHan(LukeHan1128@gmail.com)
  */

$(document).ready(function(){
	setNav('PC정보');
	
	// 그룹 클릭
	$('.groupLabel').on('click', function(){
		group_label_fnt(this);
	});
	
	// 원격제어 버튼
	$('#remoteControllBtn').on('click', function(){
		// data-value 에 pc 정보를 넣을 예정
		console.log('remoteControllBtn data-value : ' + $(this).data('value'));
		$(this).data('value', Math.floor(Math.random() * 10) + 1);
	});
	
	// 페이지 로딩시 자동 클릭
	$('.groupLabel').eq(0).trigger('click');
});

/* 그룹 클릭 */
function group_label_fnt(doc){
	$('#contentTitle').text($(doc).text());
}
