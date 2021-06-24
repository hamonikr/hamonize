 /** 
  * Writing day : 2019.05.15
  * Modifying day : 2019.05.15
  * Writer : LukeHan(LukeHan1128@gmail.com)
  */

$(document).ready(function(){
	setNav('공지사항 > 등록');
	
	// 등록 버튼
	$('#insertBtn').on('click', function(){
		insertNoticeFtn();
	});
	
	// 취소 버튼
	$('#cancelBtn').on('click', function(){
		if(confirm('작성중인 계시물이 있습니다.\n작성을 취소하시겠습니까?')) {
			location.href='/notice/notice';
		}
	});
});



/* 공지 삭제 */
function insertNoticeFtn(){
	// 등록 후 해당 게시물로 이동 - 혹은 목록으로
	location.href='/notice/notice';
}
