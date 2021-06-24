 /** 
  * Writing day : 2019.05.13
  * Modifying day : 2019.05.13
  * Writer : LukeHan(LukeHan1128@gmail.com)
  */

$(document).ready(function(){
	setNav('정책관리 > 보안관리');
	
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
	
	list.push({ name : '알 수 없는 장치', info : '읽기/쓰기 가능한 미등록 장치' });
	list.push({ name : 'USB 저장 장치', info : 'USB 저장 장치 (USB 플래시 드라이브, U3 드라이브, ExpressCard, 생체인식 USB 저장 장치 등)' });
	list.push({ name : 'CD/DVD RW 드라이브', info : '내장형 CD/DVD RW' });
	list.push({ name : '내장형 카드 리더기', info : '내장형 카드 리더기 (SD 카드, 메모리 카드, 소형 플래시 등)' });
	list.push({ name : '로컬 프린터', info : '컴퓨터에 직접 연결된 로컬 프린터' });
	list.push({ name : 'MTP', info : '미디어 전송 프로토콜 (윈도우 휴대기기)' });
	list.push({ name : '디지털 카메라', info : 'PTP (휴대폰 사진 읽기)' });
	list.push({ name : '스마트폰 (USB Sync)', info : '스마트폰 (USB로 연결된 스마트폰)' });
	list.push({ name : '스마트폰 (Windows CE)', info : '스마트폰 (Windows CE 기기)' });
	list.push({ name : '스마트폰 (Symbian)', info : '스마트폰 (노키아 N 시리즈)' });
	list.push({ name : '웹캠(Webcam)', info : '웹 카메라' });
	list.push({ name : 'iPhone', info : 'iPhone' });
	list.push({ name : 'iPad', info : 'iPad' });
	list.push({ name : 'iPod', info : 'iPod' });
	
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