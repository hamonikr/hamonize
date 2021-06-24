 /** 
  * Writing day : 2019.05.13
  * Modifying day : 2019.05.13
  * Writer : LukeHan(LukeHan1128@gmail.com)
  */

$(document).ready(function(){
	var pageName = '기술지원';
	setNav(pageName);
	$('#contentTitle').text(pageName);
	
	
	// 등록 버튼
	$('.insertBtn').on('click', function(){
		location.href='/dtqrt/dtqrtInsertList';
	});
	
	
	// 상세보기 버튼
	$('#grid').on('click', '.tui-grid-rside-area .tui-grid-cell-content', function(){
		var idx = $(this).children('input[name=idx]').val();
		var form = $('<form></form>');
		
		form.attr('action', '/dtqrt/dtqrtDetail');
		form.attr('method', 'post');
		form.append('<input type="hidden" name="dtqrtIdx" value="' + idx + '">');
		form.appendTo('body');
		form.submit();
	});
	
	// 찾기 버튼
	/*$('#searchBtn').on('click', function(){
		var $ipt = $('#searchIpt');
		var value = $ipt.val().trim();
		
		if(value == '' || 1 > value.length){
			$ipt.focus();
			return;
		}
		console.log('찾기 버튼 - searchIpt : ' + value);
	});*/
});
