 /** 
  * Writing day : 2019.05.13
  * Modifying day : 2019.05.13
  * Writer : LukeHan(LukeHan1128@gmail.com)
  */

$(document).ready(function(){
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
	
	list.push(
		/* 개발 */
		'Qt 5 Assistant',
		'Qt 5 Designer',
		'Qt 5 Linguist',
		
		/* 교육 */
		'Veyon Configurator',
		'Veyon Master',
		
		/* 그래픽 */
		'그누 이미지 처리 프로그램',
		'심플 스캔',
		'픽스',
		
		/* 보조프로그램 */
		'ClamTk',
		'fcitx-qimpanel-configtool',
		'hamonia',
		'Vim',
		'Redshift',
		'USB 이미지 라이터',
		'USB 포맷 장치',
		'가상 키보드',
		'계산기',
		'글꼴',
		'디스크',
		'문서 뷰어',
		'문자표',
		'스크린샷',
		'암호 및 키',
		'압축 관리자',
		'이미지 보기',
		'텍스트 편집기',
		'톰보이 쪽지',
		
		/* 보편적 접근성 */
		'온보드',
		
		/* 오피스 */
		'LibreOffice',
		'LibreOffice Base',
		'LibreOffice Calc',
		'LibreOffice Drow',
		'LibreOffice Impress',
		'LibreOffice Math',
		'LibreOffice Writer',
		'달력(그놈달력)',
		
		/* 음악과 비디오 */
		'Kdenlive(미디어편집도구)',
		'VLC 미디어 플레이어',
		'리듬박스',
		'미디어 플레이어',
		
		/* 인터넷 */
		'Firefox 웹 브라우저',
		'Mozilla Thunderbird',
		
		/* 관리 */
		'Fcitx',
		'Timeshift',
		'기록',
		'드라이버 매니저',
		'디스크 사용량 분석',
		'로그인 창',
		'민트 리포트',
		'백업 도구',
		'사용자와 그룹',
		'소프트워에 매니저',
		'스프트웨어 소스',
		'시냅틱 패키지 관리자',
		'시스템 감시',
		'업데이트 매니저',
		'전원 통계',
		'터미널',
		'프린터',
		
		/* 기본설정 */
		'Fcitx 설정',
		'IBus 환경설정',
		'Qt5 Settings',
		'그래픽 태블릿',
		'글꼴',
		'기본 애플리케이션',
		'날짜 & 시간',
		'네트워크',
		'네트워크 연결',
		'데스크릿',
		'디스크',
		'디스플레이',
		'마우스와 터치패드',
		'바탕화면',
		'방화벽 설정',
		'배경화면',
		'블루투스',
		'사용자 정보',
		'색깔',
		'소리',
		'시스템 설정',
		'시스템 정보',
		'시작 애플리케이션',
		'알림',
		'애플릿',
		'언어',
		'온라인 계정',
		'온보드 설정',
		'일반',
		'입력기 - 언어설정 입력기',
		'입력기 - uim 환경설정',
		'작업공간',
		'전원 관리',
		'창',
		'창 타일링',
		'키보드',
		'테마',
		'패널',
		'편리한 기능',
		'프라이버시',
		'핫코너',
		'화면 보호기',
		'확장 프로그램',
		'환영합니다',
		'효과'
	);
	
	/*
	console.log(' -- list ' + list);
	//*/
	
	for(var i=0; i < list.length; ++i){
		create_program_set(list[i]);
	}
}

/* 설정 목록 엘레멘트 생성 */
function create_program_set(name){
	var $secuList = $('#secuList');

	var programNode = '<div class="custom-control custom-switch">';
	programNode += '<input type="checkbox" class="custom-control-input" id="' + name + '">';
	programNode += '<label class="custom-control-label" for="' + name + '">' + name + '</label>';
	programNode += '</div>';
	
	$secuList.append(programNode);
}