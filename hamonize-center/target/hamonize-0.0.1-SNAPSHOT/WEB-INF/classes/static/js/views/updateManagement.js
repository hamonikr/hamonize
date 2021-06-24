 /** 
  * Writing day : 2019.05.13
  * Modifying day : 2019.05.13
  * Writer : LukeHan(LukeHan1128@gmail.com)
  */

$(document).ready(function(){
	setNav('정책관리 > 업데이트관리');
	
	// 목록 생성
	create_program_list();
	
	// 그룹 클릭
	$('.groupLabel').on('click', function(){
		group_label_fnt(this);
	});
	
	// 검색
	$('#searchDiv').on('keydown', '#searchIpt', function(key) {
		if (key.keyCode == 13) {
			console.log(' -- #searchIpt Enter key down');
        }
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


/* 설정 목록 생성 */
function create_program_list(){
	var list = [];
	
	list.push({ name : '아파치', info : '웹 서버 엔진' });
	list.push({ name : '하모니아', info : '리얼타임 영상통화를 제공하는 어플리케이션.' });
	list.push({ name : 'GIMP', info : '리눅스용 이미지 편집 어플리케이션' });
	list.push({ name : 'Slack', info : '팀원들간의 협업을 지원하는 메신저' });
	list.push({ name : 'Vim', info : '커멘드 입력창에서 사용할 수 있는 입력기' });
	
	for(var i=0; i < list.length; ++i){
		create_program_set(list[i]['name'], list[i]['info']);
	}
}

/* 설정 목록 엘레멘트 생성 */
function create_program_set(name, info){
	var $secuList = $('#secuList');

	console.log(' -- name // info : ' + name + ' // ' + info);
	
	var programNode = '<div class="custom-control custom-switch">';
	programNode += '<input type="checkbox" class="custom-control-input" id="' + name + '">';
	programNode += '<label class="custom-control-label" for="' + name + '">';
	programNode += '<div class="nameDiv">' + name + '</div>';
	programNode += '<div class="infoDiv">' + info + '</div>';
	programNode += '</label>';
	programNode += '</div>';
	
	$secuList.append(programNode);
}