const electron = require('electron');
const {
	shell
} = require('electron');
const {
	app,
	BrowserWindow,
	globalShortcut
} = require("electron");
const {
	ipcMain
} = require('electron')
const path = require('path');
const fs = require('fs');
const request = require('request');
const unirest = require('unirest');

const si = require('systeminformation');
const osModule = require("os");
const sudo = require('sudo-prompt');
const options = {
	name: 'Hamonikr'
};

// require('events').EventEmitter.prototype._maxListeners = 100;
const electronLocalshortcut = require('electron-localshortcut');

const baseurl = "<Hamonize Center Url>";
const osType = require('os');

let mainWindow, settingWindow;
// require('events').EventEmitter.prototype._maxListeners = 100;
const electronLocalshortcut = require('electron-localshortcut');

const baseurl = "<Hamonize Center Url>";
const osType = require('os');

let mainWindow, settingWindow;



function createWindow() {

	mainWindow = new BrowserWindow({
		icon: 'icons/png/emb2.png',
		skipTaskbar: false,
		'width': 620,
		'height': 340,
		frame: true,
		alwaysOnTop: false,
		resizable: true,
		transparent: true,
		show: true,
		webPreferences: {
			defaultEncoding: 'utf8',
			defaultFontFamily: 'cursive',
			focusable: true,
			webviewTag: true,
			contextIsolation: false,
			nodeIntegration: true,
			nodeIntegrationInWorker: true,
			nodeIntegrationInSubFrames: true
		}
	});

	mainWindow.loadURL('file://' + __dirname + '/public/index.html');
	mainWindow.setMenu(null);
	mainWindow.setMenuBarVisibility(false);

	mainWindow.on('closed', function () {
		mainWindow = null;
	});

	mainWindow.webContents.on('did-finish-load', () => {
		mainWindow.show();
	});
	mainWindow.once('ready-to-show', () => {
		mainWindow.show()
	})


	electronLocalshortcut.register(mainWindow, 'F12', () => {
		// log.info('F12 is pressed')
		mainWindow.webContents.toggleDevTools()
	});

}

app.on('ready', () => {
	setTimeout(createWindow, 500);
	// createWindow();


});

app.on('window-all-closed', function () {
	if (process.platform !== 'darwin') {

		app.quit();
	}
});

app.on('activate', function () {
	if (mainWindow === null) {
		createWindow();
	}
});


ipcMain.on('shutdown', (event, path) => {
	console.log("main....shutdown");
	exec("gnome-session-quit --no-prompt", (error, stdout, stderr) => {
		if (error) {
			return;
		}
	});

});


//========================================================================
//== STEP 1. install_program_version_chkeck  =============================
//========================================================================

ipcMain.on('install_program_version_chkeck', (event) => {
	console.log(`STEP 1. install_program_version_chkeck`);
	install_program_version_chkeckAsync(event);

	// var isRoot = (process.getuid && process.getuid() === 0)
	// console.log("isRoot======111=======" + isRoot);

	// // if (!isRoot) {
	// // }
	// var env = process.env;
	// var home = env.HOME;
	// var user = env.LOGNAME || env.USER || env.LNAME || env.USERNAME;
	// if (process.platform === 'linux') {
	// 	home || (process.getuid() === 0 ? '/root' : (user ? '/home/' + user : null));
	// }

	// console.log("home==" + home);

});


const install_program_version_chkeckAsync = async (event) => {
	try {

		// #step 1. 기본 폴더 및 파일 생성 및 기본 프로그램 설치
		let initJobResult = await initHamonizeJob();
		console.log("STEP 1. install_program_version_chkeck Result :: " + initJobResult);

		if (initJobResult == 'Y') {

			let setServerInfoResult = await setServerInfo();
			console.log("setServerInfoResult============" + setServerInfoResult);

			// pcInfoUpdate(); // vpn 연결후 pc 정보 업데이트

			if (setServerInfoResult == 'Y') {
				console.log("########### install  program version check ###################");
				// event.sender.send('install_program_ReadyProcResult', 'Y');

				// apt repository chk & add ....
				let aptRepositoryChkResult = await aptRepositoryChkProc();
				console.log("aptRepositoryChkResult=============================>" + aptRepositoryChkResult);


				// #step 2. 설치 프로그램 버전 체크
				let installProgramVersionResult = await install_program_version_chkeckProc();
				console.log("설치 프로그램 버전 체크 Result===============>>>>>>>>>>>>>>>>>" + installProgramVersionResult);

				if (installProgramVersionResult > 0) { // 설치 프로그램 업데이트 필요..
					event.sender.send('install_program_version_chkeckResult', 'U999');

				} else { // 설치 프로그램 최신버전
					event.sender.send('install_program_version_chkeckResult', 'Y');
				}


			} else {
				// fail get Agent Server Info 
				event.sender.send('install_program_ReadyProcResult', 'N004');
				// event.sender.send('install_program_ReadyProcResult', 'N003');
			}



		} else {
			// fail make folder 
			event.sender.send('install_program_version_chkeckResult', 'N001');
		}


	} catch (err) {
		console.log("install_program_version_chkeckProc---" + err);
		return Object.assign(err);
	}
}



//========================================================================
//== STEP 2. install_program_Ready  ======================================
//========================================================================

ipcMain.on('install_program_Ready', (event) => {
	mainWindow.setSize(620, 540);
	var vpn_used;
	// todo : check vpn cli or gui 셋팅
		unirest.get(baseurl + '/hmsvc/isVpnUsed')
		.header('content-type', 'application/json')
		.end(function (response) {
			var json = response.body;
			console.log("vpn_used return json data===" + json);					
			var obj = eval('(' + json + ')');
			
			console.log(obj[0]["vpn_used"]);
			vpn_used = obj[0]["vpn_used"];

			if(vpn_used == 1){
				console.log("vpn install..");
				install_program_ReadyAsync(event);
			}else if(vpn_used == 0){
				console.log("vpn bypass..");
				event.sender.send('install_program_ReadyProcResult', 'Y');
			}
		});

	});


const install_program_ReadyAsync = async (event) => {
	try {

		// #step . vpn create & conn
		await vpnCreate();

		// let vpnCreateResultVal = await vpnCreateChk();
		// console.log("222222222vpnCreateResultVal========================++" + vpnCreateResultVal);

		// if (vpnCreateResultVal != 'Y') {
		// 	// fail vpn create 
		// 	event.sender.send('install_program_ReadyProcResult', 'N002');
		// }


		let vpnCreateResult = await vpnCreateChk();
		console.log("vpnCreateResult========================++" + vpnCreateResult);

		if (vpnCreateResult == 'Y') {

			console.log("###########get Agent Info ###################");

			// #step . 에이전트에서 사용하는 정보 셋팅aaa
			// let getAgentPcInfoResult = await getAgentPcInfo();
			// console.log("getAgentPcInfo============" + getAgentPcInfoResult);

			pcInfoUpdate(); // vpn 연결후 pc 정보 업데이트

			// if (getAgentPcInfoResult == 'Y') {
			// 	console.log("########### install  program version check ###################");
			event.sender.send('install_program_ReadyProcResult', 'Y');
			// } else {
			// 	// fail get Agent Server Info 
			// 	event.sender.send('install_program_ReadyProcResult', 'N003');
			// }

		} else {
			// fail vpn create 
			event.sender.send('install_program_ReadyProcResult', 'N002');
		}

	} catch (err) {
		console.log("install_program_ReadyAsync---" + err);
		return Object.assign(err);
	}
}



//========================================================================
//== STEP 3. program install   ===========================================
//========================================================================

ipcMain.on('hamonizeProgramInstall', (event) => {
	hamonizeProgramInstallAsync(event);
});


const hamonizeProgramInstallAsync = async (event) => {
	try {
		let mkfolderResult = await hamonizeProgramInstallProc();
		console.log("hamonizeProgramInstallProc==" + mkfolderResult);
		event.sender.send('hamonizeProgramInstallResult', mkfolderResult);
	} catch (err) {
		console.log("hamonizeProgramInstallProc---" + err);
		return Object.assign(err);
	}
}

function hamonizeProgramInstallProc() {
	return new Promise(function (resolve, reject) {

		console.log("====hamonizeProgramInstallProc==");
		var aptRepositoryChkJobShell = "sh " + __dirname + "/shell/hamonizeProgramInstall.sh";

		sudo.exec(aptRepositoryChkJobShell, options,
			function (error, stdout, stderr) {
				if (error) {
					console.log("error is " + error);
					return resolve("N");
				} else {
					console.log('stdout: ' + stdout);
					console.log('stderr: ' + stderr);
					resolve("Y");
				}
			}
		);
	});
}

//========================================================================
//== STEP 4. Backup  =====================================================
//========================================================================

ipcMain.on('hamonizeSystemBackup', (event) => {
	hamonizeSystemBackupAsync(event);
});


const hamonizeSystemBackupAsync = async (event) => {
	try {
		console.log("hamonizeSystemBackup============START");
		let backupResult = await hamonizeSystemBackupAsyncProc();
		console.log("hamonizeSystemBackupAsyncProc==" + backupResult);
		event.sender.send('hamonizeSystemBackupResult', backupResult);
	} catch (err) {
		console.log("hamonizeSystemBackupAsync---" + err);
		return Object.assign(err);
	}
}

function hamonizeSystemBackupAsyncProc() {
	return new Promise(function (resolve, reject) {

		console.log("====__dirname===" + __dirname);
		var aptRepositoryChkJobShell = "sh " + __dirname + "/shell/hamonizeBackup.sh";

		sudo.exec(aptRepositoryChkJobShell, options,
			function (error, stdout, stderr) {
				if (error) {
					console.log("error is " + error);
					return resolve("N");
				} else {
					console.log('stdout: ' + stdout);
					console.log('stderr: ' + stderr);
					resolve("Y");
				}
			}
		);
	});
}




// =================================================================================




//== get Agent Server Info   ===========================================
function setServerInfo() {
	return new Promise(function (resolve, reject) {

		console.log("====get Agent Server Info");
		var getAgentInfo = "bash " + __dirname + "/shell/setServerInfo.sh";

		sudo.exec(getAgentInfo, options,
			function (error, stdout, stderr) {
				if (error) {
					console.log("error is " + error);
					return resolve("N");
				} else {
					console.log('setServerInfo   tdout: ' + stdout);
					console.log('setServerInfo   stderr: ' + stderr);

					if (stdout.indexOf('skir')) {
						resolve('Y');
					} else {
						resolve('N');
					}

				}
			}
		);
	});
}


//== init Shell Job  ===========================================
function initHamonizeJob() {
	return new Promise(function (resolve, reject) {
		var initJobShell = "sh " + __dirname + "/shell/initHamonizeInstall.sh";
		sudo.exec(initJobShell, options,
			function (error, stdout, stderr) {
				if (error) {
					console.log("error is " + error);
					return resolve("N");
				} else {
					console.log('stdout: ' + stdout);
					console.log('stderr: ' + stderr);
					// resolve(stdout);
					resolve('Y');
				}
			}
		);
	});
}



//== install_program_version_upgrade  ===========================================
function install_program_version_chkeckProc() {
	return new Promise(function (resolve, reject) {

		var versionChk = "sh " + __dirname + "/shell/initVersionChk.sh";
		// var versionChk =  "apt list --upgradable 2>/dev/null | grep hamonize-connect | wc -l";
		sudo.exec(versionChk, options,
			function (error, stdout, stderr) {
				if (error) {
					return reject("N");
				} else {
					console.log('install_program_version_chkeckProc---stdout: ' + stdout);
					console.log('install_program_version_chkeckProc---stderr: ' + stderr);
					resolve(stdout);
				}
			}
		);
	});
}



//== vpn create  Shell Job  ===========================================
function vpnCreate() {
	return new Promise(function (resolve, reject) {
		var initJobShell = "/bin/bash " + __dirname + "/shell/vpnInstall.sh";
		sudo.exec(initJobShell, options,
			function (error, stdout, stderr) {
				if (error) {
					console.log("error is " + error);
					return resolve("N");
				} else {
					// console.log('stdout: ' + stdout);
					console.log('stderr vpn,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,: ' + stderr);
					// resolve(stdout);


					// if( stdout == 'SUCCESS'){
					resolve('Y');
					// }else{
					// 	resolve('N');
					// }
				}
			}
		);
	});
}

//== vpn create  Shell Job  ===========================================
function vpnCreateChk() {
	return new Promise(function (resolve, reject) {
		var initJobShell = "/bin/bash " + __dirname + "/shell/vpnInstallChk.sh";
		sudo.exec(initJobShell, options,
			function (error, stdout, stderr) {
				if (error) {
					console.log("error is " + error);
					return resolve("N");
				} else {
					// console.log('stdout: ' + stdout);
					console.log('stderr vpn, chk,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,: ' + stderr);
					console.log('stdout vpn, chk,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,: ' + stdout + "--" + stdout.indexOf('SUCCESS'));
					// resolve(stdout);


					resolve('Y');
				}
			}
		);
	});
}

//== install program update   ===========================================
ipcMain.on('install_program_update', (event) => {
	install_program_updateAsync(event);
});


const install_program_updateAsync = async (event) => {
	try {
		let install_program_updateProcResult = await install_program_lastversion_installProc();

		if (install_program_updateProcResult == 'Y') {
			event.sender.send('install_program_version_chkeckResult', 'U001');
		} else {
			event.sender.send('install_program_version_chkeckResult', 'U002');
		}
	} catch (err) {
		console.log("install_program_updateAsync---" + err);
		return Object.assign(err);
	}
}


function install_program_lastversion_installProc() {
	return new Promise(function (resolve, reject) {
		var installJobShell = " sudo apt-get --only-upgrade install hamonize-connect-server -y ";
		sudo.exec(installJobShell, options,
			function (error, stdout, stderr) {
				if (error) {
					console.log("error is " + error);
					return resolve("N");
				} else {
					console.log('stdout: ' + stdout);
					console.log('stderr: ' + stderr);
					// resolve(stdout);
					resolve('Y');
				}
			}
		);
	});

}





//== install_program_version_upgrade  ===========================================

ipcMain.on('install_program_upgrade', (event) => {
	install_program_upgradeAsync(event);
});

const install_program_upgradeAsync = async (event) => {
	try {
		let chkVal = await install_program_upgradeProc();
		console.log("install_program_upgradeProc==" + chkVal);
		event.sender.send('install_program_upgradeProcResult', chkVal);

	} catch (err) {
		console.log("install_program_upgradeProc---" + err);
		return Object.assign(err);
	}
}

function install_program_upgradeProc() {
	return new Promise(function (resolve, reject) {

		var upgradeInstallProgram = "sudo apt-get --only-upgrade install hamonize-connect -y";

		sudo.exec(upgradeInstallProgram, options,
			function (error, stdout, stderr) {
				if (error) {
					console.log("error is " + error);
					return resolve("N");
				} else {
					console.log('stdout: ' + stdout);
					console.log('stderr: ' + stderr);
					resolve(stdout);
				}
			}
		);
	});
}


//================= pc info ==================================

// == pc 정보 체크===
ipcMain.on('pcInfoChk', (event, groupname, sabun, username) => {
	mainWindow.setSize(620, 340);
	sysInfo(event, groupname, sabun, username);

});



function execShellCommand(cmd) {
	const exec = require('child_process').exec;
	return new Promise((resolve, reject) => {
		exec(cmd, (error, stdout, stderr) => {
			if (error) {
				console.warn(error);
			}
			resolve(stdout ? stdout : stderr);
		});
	});
}

function execSetHostname(svrpcnum) {
	return new Promise((resolve, reject) => {
		sudo.exec("hostnamectl set-hostname " + svrpcnum, options,
			function (error, stdout, stderr) {
				if (error) {
					console.log("hostnamectl set-hostname error is " + error);
				} else {
					console.log('hostnamectl set-hostname stdout: ' + stdout);
					console.log('hostnamectl set-hostname stderr: ' + stderr);
					resolve(stdout);
				}
			}
		);
	});
}

function getPublicIp() {
	return new Promise((resolve, reject) => {
		sudo.exec("curl -4 icanhazip.com ", options,
			function (error, stdout, stderr) {
				if (error) {
					console.log("getPublicIp error is " + error);
				} else {
					console.log('getPublicIp stdout: ' + stdout);
					console.log('getPublicIp stderr: ' + stderr);
					resolve(stdout);
				}
			}
		);
	});
}


// 부대번호 svrgroupnum, 서버번호 svrpcnum

const sysInfo = async (event, groupname, sabun, username) => {
	let retData = {}
	const pcHostname = await execShellCommand('hostname');
	const cpu = await si.cpu(); // CPU Info
	let cpuinfo = ` ${cpu.manufacturer} ${cpu.brand} ${cpu.speed}GHz`;
	cpuinfo += ` ${cpu.cores} (${cpu.physicalCores} Physical)`;

	let cpuinfoMd5 = ` ${cpu.manufacturer} ${cpu.brand}`;
	cpuinfoMd5 += ` ${cpu.cores} (${cpu.physicalCores} Physical)`;

	const disk = (await si.diskLayout())[0]; // Disk Info
	const size = Math.round(disk.size / 1024 / 1024 / 1024);
	let diskInfo = ` ${disk.vendor} ${disk.name} ${size}GB ${disk.type} (${disk.interfaceType})`;
	let diskSerialNum = disk.serialNum;

	const os = await si.osInfo(); //OS Info
	let osinfo = ` ${os.distro} ${os.release} ${os.codename} (${os.platform})`;

	let osinfoKernel = ` ${os.kernel} ${os.arch}`;

	const ram = await si.mem(); // RAM Info
	const totalRam = Math.round(ram.total / 1024 / 1024 / 1024);
	let raminfo = ` ${totalRam}GB`;

	const ipinfo = require("ip"); //	get os ip address
	const pcuuid = (await si.uuid()); //	 get os mac address 

	const macs = pcuuid.macs;


	const machineIdSync = require('node-machine-id').machineIdSync;
	let machindid = machineIdSync({
		original: true
	});

	let vpnipaddr = '';
	let vpnInfoData = ''; // vpnchk();

	if (vpnInfoData.length == 0) {
		vpnipaddr = 'no vpn';
	} else {
		vpnipaddr = vpnInfoData;
	}


	var md5 = require('md5');
	let hwinfoMD5 = cpuinfoMd5 + diskInfo + diskSerialNum + osinfoKernel + raminfo + machindid;
	let hwData = md5(hwinfoMD5);

	let fileDir = "/etc/hamonize/hwinfo/hwinfo.hm";
	fs.writeFile(fileDir, hwData, (err) => {
		if (err) {
			// log.info("//== sysInfo hw check create file error  "+ err.message)
		}
	});


	console.log("machindid == " + machindid);
	console.log("cpuinfo == " + cpuinfo);
	console.log("diskSerialNum == " + diskSerialNum);
	console.log("diskInfo == " + diskInfo);
	console.log("macs == " + macs[0]);
	console.log("ipinfo.address() == " + ipinfo.address());
	console.log("vpnipaddr == " + vpnipaddr);
	console.log("pcHostname == " + pcHostname);
	console.log("osinfo == " + osinfo);
	console.log("raminfo == " + raminfo);
	console.log("groupname == " + groupname);
	console.log("username == " + username);


	console.log("등록 버튼 클릭시 center url >> " + baseurl + '/hmsvc/setPcInfo');
	unirest.post(baseurl + '/hmsvc/setPcInfo')
		.header('content-type', 'application/json')
		.send({
			events: [{
				uuid: machindid,
				cpuid: cpuinfo.trim(),
				hddid: diskSerialNum.trim(),
				hddinfo: diskInfo.trim(),
				macaddr: macs[0],
				ipaddr: ipinfo.address().trim(),
				vpnipaddr: vpnipaddr.trim(),
				hostname: pcHostname.trim(),
				pcos: osinfo.trim(),
				memory: raminfo.trim(),
				deptname: groupname.trim(),
				sabun: sabun.trim(),
				username: username.trim()

			}]
		})
		.end(function (response) {
			console.log("aaaresponse.body===" + JSON.stringify(response));
			console.log("\nbbbresponse.body===" + response.body);
			event.sender.send('pcInfoChkProc', response.body);
		});

}


function pcInfoUpdate() {
	let vpnipaddr = '';
	let vpnInfoData = vpnchk();
	if (vpnInfoData.length == 0) {
		vpnipaddr = 'no vpn';
	} else {
		vpnipaddr = vpnInfoData;
	}


	const machineIdSync = require('node-machine-id').machineIdSync;
	let machindid = machineIdSync({
		original: true
	});

	unirest.post(baseurl + '/hmsvr/setVpnUpdate')
		.header('content-type', 'application/json')
		.send({
			events: [{
				uuid: machindid,
				vpnipaddr: vpnipaddr
			}]
		})
		.end(function (response) {
			console.log("response.body===" + response.body);
		});
}

function vpnchk() {
	var os = require('os');
	var ifaces = os.networkInterfaces();
	var retVal = '';

	Object.keys(ifaces).forEach(function (ifname) {
		var alias = 0;
		var tmpIfname = "";
		ifaces[ifname].forEach(function (iface) {
			if (iface.internal !== false) {
				// if ('IPv4' !== iface.family || iface.internal !== false) {
				console.log('not conn');
				tmpIfname = 'ERROR-1944';
				//return;
			}
			if (alias >= 1) {
				console.log("alias >= 1  : " + ifname + ':' + alias, iface.address);
			} else {
				// console.log("this interface has only one ipv4 adress is :" + ifname, iface.address);
				if (ifname == 'tun0') {
					// tmpIfname = ifname;	
					tmpIfname = iface.address;
				}
			}
			++alias;
		});
		retVal = tmpIfname;
	});
	return retVal;

}


//========================================================================
//== aptRepositoryChk  ===========================================
//========================================================================

ipcMain.on('aptRepositoryChk', (event) => {
	aptRepositoryChkAsync(event);
});


const aptRepositoryChkAsync = async (event) => {
	try {
		let mkfolderResult = await aptRepositoryChkProc();
		console.log("aptRepositoryChkProc==" + mkfolderResult);
		event.sender.send('aptRepositoryChkProcResult', mkfolderResult);
	} catch (err) {
		console.log("aptRepositoryChkAsync---" + err);
		return Object.assign(err);
	}
}

function aptRepositoryChkProc() {
	return new Promise(function (resolve, reject) {

		console.log("====__dirname===" + __dirname);
		var aptRepositoryChkJobShell = "sh " + __dirname + "/shell/aptCheck.sh";

		sudo.exec(aptRepositoryChkJobShell, options,
			function (error, stdout, stderr) {
				if (error) {
					console.log("error is " + error);
					return resolve("N");
				} else {
					console.log('stdout: ' + stdout);
					console.log('stderr: ' + stderr);
					resolve("Y");
				}
			}
		);
	});
}


// 조직정보 
ipcMain.on('getOrgData', (event) => {
	unirest.get(baseurl + '/hmsvc/getOrgData')
		.header('content-type', 'application/json')
		.send({
			events: [{
				baseInfo: "baseInfo"
			}]
		})
		.end(function (response) {
			event.sender.send('getOrgDataResult', response.body);
		});
});
