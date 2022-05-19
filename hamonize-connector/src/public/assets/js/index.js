// const moment = require('moment');
const {
	ipcRenderer
} = require('electron');
const {
	BrowserWindow
} = require('electron')
const path = require('path');
const unirest = require('unirest');

$modal = $(".modal");

// # step 1. install file version check  ====================================
// 폴더 생성 및 프로그램 설치 진행에 필요한 jq, curl 등 설치
install_program_version_chkeck();
// hamonizeSystemBackup();


function install_program_version_chkeck() {
	$modal.show();
	popupOpen();
	$(".layerpop__container").text("프로그램 설치를 위한 버전 확인 중 입니다. 잠시만 기다려주세요.!!");

	ipcRenderer.send('install_program_version_chkeck');
}


ipcRenderer.on('install_program_version_chkeckResult', (event, isChkVal) => {

	console.log("isChkVal==2222222222222222222222=" + isChkVal);

	if (isChkVal == 'Y') {
		// 초기 폴더 생성후 관리 프로그램 설치에 필요한 툴 설치 완료.
		console.log("초기 폴더 생성후 관리 프로그램 설치에 필요한 툴 설치 완료.");
		$modal.hide();
		$("#loadingInfoText").text("");

	} else if (isChkVal == 'N001') {
		//fail make folder 
		fn_alert("프로그램 버전 확인중 오류가 발견되었습니다. 관리자에게 문의 바랍니다. \n Error Code :: [N001]");
		return false;
	} else if (isChkVal == 'N004') {
		// fail get Agent Server Info 
		fn_alert("프로그램 서버 정보 셋팅 오류. 관리자에게 문의 바랍니다. \n Error Code :: [N004]");
		return false;
	} else if (isChkVal == 'U999') {
		console.log("U999====")
		// 설치 프로그램 업데이트 필요..
		$modal.show();
		popupOpen();
		$(".layerpop__container").text("설치 프로그램의 버전이 낮아 업그레이드를 진행합니다.... 잠시만 기다려주세요.!!");
		ipcRenderer.send('install_program_update');
		return false;
	} else if (isChkVal == 'U001') {
		fn_alert("설치 프로그램 업그레이드가 \n 완료되었습니다. 재실행해 주세요..");
		$modal.show();
		$("#loadingInfoText").text("서버 관리 프로그램.. 업그레이드가 완료되었습니다. 재실행해 주세요..!!");
		return false;
	} else if (isChkVal == 'U002') {
		fn_alert("설치 프로그램 업그레이드 중 오류가 발생했습니다. \n 관리자에게 문의 바랍니다.\n Error Code :: [U002]");
		return false;
	} else if (isChkVal == "YDONE") {	//	 프로그램 설치 완료 후 재실행 했을경우 
		document.title = "𝓗𝓪𝓶𝓸𝓷𝓲𝔃𝓮";
		$modal.hide();
		$("#loadingInfoText").text("");

		$("#hmInstallIng").hide();

		$("#hmInstalled").show();
		$("#hmInstalledBody").show();


	} else if (isChkVal == "FREEDONE") {
		document.title = "𝓗𝓪𝓶𝓸𝓷𝓲𝔃𝓮";
		$modal.hide();
		$("#loadingInfoText").text("");

		$("#hmInstallIng").hide();
		$("#hmInstallIngBody").hide();

		$("#hmInstalled").show();
		$("#hmFreeDoneBody").show();
	}

});


// # step 2. autheky chekc ===================================
var doubleSubmitFlag = false;
const pcChkAuthBtn = document.getElementById('pcChkAuthBtn');
pcChkAuthBtn.addEventListener('click', function (event) {
	if (!doubleSubmitFlag) {

		let authkey_val = $("#authkey").val();

		if (authkey_val.length == 0) {
			doubleSubmitFlag = false;
			return false
		}

		ipcRenderer.send('getOrgAuth', authkey_val);

	} else {
		doubleSubmitFlag = true;
		return false;
	}

});

// # step 2. 부서번호 체크 ====================================
const pcChkBtn = document.getElementById('pcChkBtn');
pcChkBtn.addEventListener('click', function (event) {
	if (!doubleSubmitFlag) {
		$("#selectOrg").val($("#groupName option:selected").val());
		nextStap();
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

	hamonizeVpnInstall();
};



// # step 3. program Ready ] vpn install  ====================================/
function hamonizeVpnInstall() {
	$("#stepA").addClass("br animate");
	ipcRenderer.send('hamonizeVpnInstall', $("#domain").val());
}
ipcRenderer.on('hamonizeVpnInstall_Result', (event, result) => {
	console.log("hamonizeVpnInstall_Result===" + result);
	if (result == 'Y') {
		setPcinfo();
	} else if (result == 'N002') {
		fn_alert("하모나이즈 환경 셋팅 중 오류가 발견되었습니다. 관리자에게 문의 바랍니다. Error Code :: [N002]");
	} else {
		fn_alert("하모나이즈 환경 셋팅 중 오류가 발견되었습니다. \n 재실행 후 지속적으로 문제가 발생할경우 관리자에게 문의바랍니다.Error Code :: [N4001]");
	}
});


function setPcinfo() {
	let groupname = $("#selectOrg").val();

	if (typeof groupname == "undefined") {
		doubleSubmitFlag = false;
		return false;
	}
	let sabun = "sabun";
	let username = "username";

	ipcRenderer.send('pcInfoChk', groupname, sabun, username, $("#domain").val());

}

ipcRenderer.on('pcInfoChkProc', (event, isChkBool) => {
	if (isChkBool == true) {
		$("#stepA").removeClass("br animate");
		$("#stepB").addClass("br animate");
		$("#infoStepA").text("완료");
		hamonizeProgramInstall();
	} else {
		doubleSubmitFlag = false;
		fn_alert("유효하지 않는 정보입니다. 확인 후 등록해 주시기바랍니다.\n 지속적으로 문제가 발생할경우 관리자에게 문의바랍니다.");
	}

});


// ======== step 4. PC 관리 프로그램 설치... =========================================/
function hamonizeProgramInstall() {
	ipcRenderer.send('hamonizeProgramInstall', 'eden123');
	// ipcRenderer.send('hamonizeProgramInstall', $("#domain").val());
}

ipcRenderer.on('hamonizeProgramInstall_Result', (event, mkfolderResult) => {
	console.log("hamonizeProgramInstall_Result===" + mkfolderResult);

	if (mkfolderResult == 'Y') {
		console.log("pc 관리 프로그램 설치 및 셋팅 완료");
		$("#stepB").removeClass("br animate");
		$("#stepC").addClass("br animate");
		$("#infoStepB").text("완료");
		hamonizeSystemBackup();
	} else {
		console.log("false");
		fn_alert("프로그램 설치 중 오류가 발생했습니다. \n  관리자에게 문의바랍니다. Error Code :: [N005]");
	}

});


// ======== step 5. 백업... =========================================/
// # use timeshift tooll 
function hamonizeSystemBackup() {
	ipcRenderer.send('hamonizeSystemBackup');
}

ipcRenderer.on('hamonizeSystemBackup_Result', (event, backupResult) => {
	console.log("hamonizeSystemBackup_Result===" + backupResult);

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

}); // # step 4. apt repository check ==========사용안함===========================/


// # step 8. backup

// # setp 9. hamonikr  rescue backup

// 로그파일 첨부 버튼 클릭
// const aaaBtn = document.getElementById('aaa');
// aaaBtn.addEventListener('click',function(event){
// 	ipcRenderer.send('aaa');
// });  


// 프로그램 업데이트 완료시....
ipcRenderer.on('install_program_upgradeProcResult', (event, isChkVal) => {
	console.log("install_program_upgradeProcResult===" + isChkVal);
});

//	alert 
function fn_alert(arg) {
	const Dialogs = require('dialogs');
	const dialogs = Dialogs()

	dialogs.alert(arg, () => {
		$(".banner-text").css({
			"z-index": "1000000000"
		});
	});
}



// 인증결과 
ipcRenderer.on('getAuthResult', (event, authResult) => {
	// 조직정보
	if (authResult == 'N') {
		fn_alert("Hamonize 인증키 오류입니다. 다시 확인하신후 입력해 주시기바랍니다.");
	} else {
		$(".layerpop__container").text("인증이 완료되었습니다. 조직정보를 불러오는 중입니다.  잠시만 기다려주세요.!!");
		$("#domain").val(authResult);
		ipcRenderer.send('getOrgData', authResult);
	}
});

// 조직정보 
ipcRenderer.on('getOrgDataResult', (event, orgData) => {
	if ($("#tmpFreeDateDone").val().trim() == 'FREEDONE') {
		extensionContract();
	} else {

		var option = "";
		$("#orglayer").show();
		$("#authkeylayer").hide();
		$('#groupName').empty();

		var chkCnt = 0;
		$.each(orgData, function (key, value) {
			option += "<option>" + value.orgnm + "</option>";
			chkCnt++;
		});
		if (chkCnt == 0) {
			$("#orglayer").hide();
			$("#authkeylayer").show();
			fn_alert("등록된 조직정보가 없습니다. 조직을 등록후 사용해주세요.");
			// }else{
			// 	$(".layerpop__container").text("pc가 포함된 조지을 선택하신 후 등록버튼을 클릭해주세요.!!");
		}
		$('#groupName').append(option);

	}
});





// 기간 만료 후 재인증하는 경우....----------------------------------------#
// UI 재인증 셋팅 -1
const hamonizeAuthChkBtn = document.getElementById('hamonizeAuthChkBtn');
hamonizeAuthChkBtn.addEventListener('click', function (event) {
	document.title = "𝓗𝓪𝓶𝓸𝓷𝓲𝔃𝓮";
	$modal.hide();
	$("#loadingInfoText").text("");

	$("#hmInstallIng").show();
	$("#hmInstallIngBody").show();

	$("#hmInstalled").hide();
	$("#hmFreeDoneBody").hide();


	$("#tmpFreeDateDone").val("FREEDONE");
});


// UI 재인증 셋팅-2
function extensionContract(){
	$modal.hide();
	$("#loadingInfoText").text("");
	$("#initLayer").removeClass("active");
	$("#initLayerBody").removeClass("active");
	$("#procLayer").addClass("active");
	$("#procLayerBody").hide();
	$("#procLayerBody").show();

	initLayer

	$("#infoStepA").text("체크전");
	$("#infoStepB").text("체크전");
	$("#infoStepC").text("체크전");
} 
// ========== UI 재인증 셋팅 완료 ----------------------------#

// 프로그램 체크 시작.
// 1. vpn 체크.
// 2. Ldap
// 3. Usb protect
// 4. Hamonie-Agent
// 5. user loginout
// 6. timeshift
// 7. telegraf 
// 8. Hamonize-admin
// 9. Hamonize-help

function hamonizeVpnInstall() {
	$("#stepA").addClass("br animate");
	ipcRenderer.send('hamonizeVpnInstall', $("#domain").val());
}


ipcRenderer.on('pcInfoChkProc', (event, isChkBool) => {
	if (isChkBool == true) {
		$("#stepA").removeClass("br animate");
		$("#stepB").addClass("br animate");
		$("#infoStepA").text("완료");
		hamonizeProgramInstall();
	} else {
		doubleSubmitFlag = false;
		fn_alert("유효하지 않는 정보입니다. 확인 후 등록해 주시기바랍니다.\n 지속적으로 문제가 발생할경우 관리자에게 문의바랍니다.");
	}

});
