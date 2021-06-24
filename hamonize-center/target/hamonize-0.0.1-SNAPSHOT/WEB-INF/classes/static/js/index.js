 /** 
  * Writing day : 2019.04.18 
  * Modifying day : 2019.04.18 
  * Writer : LukeHan(LukeHan1128@gmail.com)
  */


/* header */
$(document).ready(function(){
	/**** css start ****/
	// 헤더
	$('.header ').hover(function(){
		$(this).children('.icon').css('color', 'black');
	}, function(){
		$(this).children('.icon').css('color', '');
	});
	
	// 메뉴
	$('.item').hover(function(){
		$(this).children('.submenu').show();
	}, function(){
		$(this).children('.submenu').hide();
	});
	/**** css end ****/
	
	/**** script start ****/
	// 헤더 - 메뉴
	$('.navbar .item').click(function(){
		var menu_item_link = $(this).children('.menu-title').children('a').attr('href');
		if(menu_item_link) location.href=menu_item_link;
	});
	/**** script end ****/
});


/* 네비 설정 */
function setNav(title){
	$('.component-header .title').text('HOME > ' + title);
	/* $('.component-slogan').text(info); */
}