 /** 
  * Writing day : 2019.05.09
  * Modifying day : 2019.05.09
  * Writer : LukeHan(LukeHan1128@gmail.com)
  */

$(document).ready(function(){
	setNav('모니터링');
	
	// 그룹 클릭
	$('.groupLabel').on('click', function(){
		group_label_fnt(this);
	});
	
	/*
	$('#pc_list').on('click', '.pc_controll_btn', function(){
		alert('1');
	});
	
	$('#pc_list').on('click', '.pc_info_btn', function(){
		alert('2');
	});
	//*/
	
	$('#pc_list').on('click', '.pc_info_div', function(){
		pc_info_fnt(this);
	});
	
	
	/* demo data */
	var pcCnt = 1000;
	for(i=0;i<pcCnt;++i){
		var result = Math.floor(Math.random() * 5) + 1;
		var pc = 'pc'+(i+1);
		
		if(result == 3 || result == 4 || result == 5) create_pc_info_node(pc, pc, null);	// 정상
		if(result == 2) create_pc_info_node(pc, pc, 'off');	// 전원 OFF
		if(result == 1) create_pc_info_node(pc, pc, 'err');	// 장애 발생
	}
	
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


/* 상세 페이지 이동 */
function pc_info_fnt(node){
	var $code = $(node).attr('data-code');
    var form = $('<form></form>');
    
    if(!$code){
    	alert('PC 정보를 확인할 수 없습니다.');
    	return;
    }
    
	form.attr('action', '/mntgr/pcinfo');
	form.attr('method', 'post');
	
	var code_ipt = $("<input type='hidden' value='" + $code + "' name='code'>");
	
	form.append(code_ipt);
	form.appendTo('body');
	form.submit();	
}

/* Pc 정보 div 생성 */
function create_pc_info_node(code, name, status){
	var $pc_list = $('#pc_list');
	var internalNode = '<div data-code="' + code + '" class="pc_info_div';
	
	/* background color */
	if(status == 'off') internalNode += ' pc_info_off">';
	else if(status == 'err') internalNode += ' pc_info_err">';
	else internalNode += '"';
	
	/* name */
	internalNode += '<span>' + name + '</span><br/>';
	
	/* connection status */
	/*
	if(status == 'off') internalNode += '<span>연결 : X</span>';
	else internalNode += '<span>연결 : O</span>';
	internalNode += '<br/>';
	//*/

	/* err status */
	/*
	if(status == 'err') internalNode += '<span>상태 : 장애</span>';
	else internalNode += '<span>상태 : 정상</span>';
	internalNode += '<br/>';
	//*/
	
	/* controll button */
	/*
	internalNode += '<input type="button" value="원격제어" class="btn pc_controll_btn">';
	internalNode += '<input type="button" value="상세보기" class="btn pc_info_btn">';
	//*/
	
	/* end */
	internalNode += '</div>';
	
	$pc_list.append(internalNode);
}
