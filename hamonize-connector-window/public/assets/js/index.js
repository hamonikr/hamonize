const {
	ipcRenderer
} = require('electron');
const {
	BrowserWindow
} = require('electron');
const path = require('path');
const unirest = require('unirest');

$modal = $(".modal");

// # step 1. 조직정보 셋팅  ====================================
hamonize_org_settings();

function hamonize_org_settings() {
	$modal.show();
	popupOpen();
	$(".layerpop__container").text("Hamonize Loading....!!");

	ipcRenderer.send('hamonize_org_settings');
}

// result org info == 
ipcRenderer.on('getOrgDataResult', (event, orgData) => {
	var option = "";
	$('#groupName').empty();
	$.each(orgData, function (key, value) {
		console.log('key:' + key + ', seq:' + value.seq + ',orgnm:' + value.orgnm);

		option += "<option>" + value.orgnm + "</option>";

	});
	$('#groupName').append(option);
	$modal.hide();
});


// # step 2. 피시정보등록 ====================================
// 
var doubleSubmitFlag = false;
const pcChkBtn = document.getElementById('pcChkBtn');
pcChkBtn.addEventListener('click', function (event) {
	$modal.show();
	if (!doubleSubmitFlag) {

		let groupname = $("#groupName option:selected").val(); //$("#groupName").val(); //부서번호

		if (typeof groupname == "undefined") {
			doubleSubmitFlag = false;
			return false
		}
		let sabun = "sabun"; //$("#sabun").val(); //사번
		let username = "username"; //$("#username").val(); // 사용자 이름

		ipcRenderer.send('pcInfoChk', groupname, sabun, username);
		doubleSubmitFlag = true;
	} else {
		doubleSubmitFlag = true;
		return false;
	}

});

function nextStap() {

	$modal.hide();
	$("#loadingInfoText").text("");

	$("#initLayer").removeClass("active");
	$("#initLayerBody").removeClass("active");

	$("#procLayer").addClass("active");
	$("#procLayerBody").hide();
	$("#procLayerBody").show();

	initLayer

	install_program_Ready();
};

ipcRenderer.on('pcInfoChkProc', (event, isChkBool) => {
	console.log("pcInfoChkProc===" + isChkBool);

	if (isChkBool == true) {
		console.log("true");
		$modal.show();
		popupOpen();
		$('.layerpop').css("left", (($(window).width() - $('.layerpop').outerWidth()) / 1.5) + $(window).scrollLeft());
		$(".layerpop__container").text("정보 체크중입니다......!!");

		window.setTimeout(nextStap, 5000);

	} else {
		console.log("false");
		doubleSubmitFlag = false;
		fn_alert("유효하지 않는 정보입니다. 확인 후 등록해 주시기바랍니다.\n 지속적으로 문제가 발생할경우 시스템 관리자에게 문의바랍니다.");
	}

});




// # step 3. program Ready start] hamonize-tool install ====================================/
// 
function install_program_Ready() {
	$("#stepA").addClass("br animate");
	ipcRenderer.send('install_program_Ready');
}

ipcRenderer.on('install_program_ReadyProcResult', (event, mkfolderResult) => {
	console.log("install_program_ReadyProcResult===" + mkfolderResult);

	if (mkfolderResult == 'Y') {
		console.log("true");

		// 초기 폴더 생성후 관리 프로그램 설치에 필요한 툴 설치 완료.
		// ipcRenderer.send('install_program_upgrade');
		console.log("초기 폴더 생성후 관리 프로그램 설치에 필요한 툴 설치 완료.");

		$("#stepA").removeClass("br animate");
		$("#stepB").addClass("br animate");
		$("#infoStepA").text("완료");
		hamonizeProgramInstall();



	} else if (isChkVal == 'N002') {
		//fail vpn create 
		fn_alert("프로그램 버전 확인중 오류가 발견되었습니다. 관리자에게 문의 바랍니다. Error Code :: [N002]");

	} else if (isChkVal == 'N003') {
		// fail get Agent Server Info 
		fn_alert("프로그램 버전 확인중 오류가 발견되었습니다. 관리자에게 문의 바랍니다. Error Code :: [N003]");
	} else {
		console.log("false");
		fn_alert("프로그램 설치 환경 셋팅에 실패했습니다. \n 재실행 후 지속적으로 문제가 발생할경우 관리자에게 문의바랍니다.Error Code :: [N4001]");
	}

});





// ======== step 4. PC 관리 프로그램 설치... =========================================/
// #  collectd client install =====================================/
//
function hamonizeProgramInstall() {
	ipcRenderer.send('hamonizeProgramInstall');
}

ipcRenderer.on('hamonizeProgramInstallResult', (event, mkfolderResult) => {
	console.log("hamonizeProgramInstallResult===" + mkfolderResult);

	if (mkfolderResult == 'Y') {
		console.log("pc 관리 프로그램 설치 및 셋팅 완료");
		$("#stepB").removeClass("br animate");
		// $("#stepC").addClass("br animate");
		$("#infoStepB").text("완료");
		// hamonizeSystemBackup(); 
		$("#procLayerBody").hide();
		$("#EndBody").show();
	} else {
		console.log("false");
		fn_alert("프로그램 설치 중 오류가 발생했습니다. \n  관리자에게 문의바랍니다.");
	}

});


// ======== step 5. 백업... =========================================/
// # use timeshift tooll 
function hamonizeSystemBackup() {
	ipcRenderer.send('hamonizeSystemBackup');
}

ipcRenderer.on('hamonizeSystemBackupResult', (event, backupResult) => {
	console.log("hamonizeSystemBackupResult===" + backupResult);

	if (backupResult == 'Y') {
		console.log("true");
		$("#stepC").removeClass("br animate");

		$("#initLayerBody").hide();
		$("#procLayerBody").hide();
		$("#infoStepC").text("완료");
		$("#EndBody").show();

	} else {
		console.log("false");
		fn_alert("백업중 오류가 발생했습니다. 관리자에게 문의 바랍니다.");
	}

});








// 프로그램 업데이트 완료시....
ipcRenderer.on('install_program_upgradeProcResult', (event, isChkVal) => {
	console.log("install_program_upgradeProcResult===" + isChkVal);
});


// # step 4. apt repository check ==========사용안함===========================/
//
function aptRepositoryChk() {
	$("#stepA").removeClass("br animate");
	$("#stepB").addClass("br animate");
	ipcRenderer.send('aptRepositoryChk');
}
ipcRenderer.on('aptRepositoryChkProcResult', (event, mkfolderResult) => {
	console.log("aptRepositoryChkProcResult===" + mkfolderResult);

	if (mkfolderResult == 'Y') {
		console.log("true");
		hamonizeProgramInstall();
	} else {
		console.log("false");
		fn_alert("프로그램 설치 환경 셋팅에 실패했습니다. \n 재실행 후 지속적으로 문제가 발생할경우 관리자에게 문의바랍니다.");
	}

});


// # step 8. backup

// # setp 9. hamonikr  rescue backup

// 로그파일 첨부 버튼 클릭
// const aaaBtn = document.getElementById('aaa');
// aaaBtn.addEventListener('click',function(event){
// 	ipcRenderer.send('aaa');
// });  




function fn_alert(arg) {
	const Dialogs = require('dialogs');
	const dialogs = Dialogs()

	dialogs.alert(arg, () => {
		$(".banner-text").css({
			"z-index": "1000000000"
		});
	});
}