const electron = require('electron');
const {
	Tray,
	Menu
} = require('electron');
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
const timestamp = require('time-stamp');
const path = require('path');
const watch = require('node-watch');
const lineReader = require('line-reader');
const fs = require('fs');
const windowStateKeeper = require('electron-window-state');
const request = require('request');
const open = require('open');
const unirest = require('unirest');
const CHILD_PADDING = 100;
// const log = require('./logger');

const si = require('systeminformation');
const osModule = require("os");
const sudo = require('sudo-prompt');
const options = {
	name: 'Hamonikr'
};


const electronLocalshortcut = require('electron-localshortcut');

const baseurl = "<Hamonize Center Url>";


const osType = require('os');
const dirPath = osType.homedir() + '/.config/support/feedback';

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



const toggleWindow = () => {
	mainWindow.isVisible() ? mainWindow.hide() : showWindow();
}
const showWindow = () => {
	const position = getWindowPosition();
	mainWindow.setPosition(position.x, position.y, false);
	mainWindow.show();
}
const getWindowPosition = () => {
	const windowBounds = mainWindow.getBounds();
	const trayBounds = trayIcon.getBounds();

	// Center window horizontally below the tray icon
	const x = Math.round(trayBounds.x + (trayBounds.width / 2) - (windowBounds.width / 2))
	// Position window 4 pixels vertically below the tray icon
	const y = Math.round(trayBounds.y + trayBounds.height + 4)
	return {
		x: x,
		y: y
	}
}
const createTray = () => {
	trayIcon = new Tray(__dirname + '/icons/icon16.png');
	//tray.setTitle('hello world');
	const trayMenuTemplate = [{
			label: 'Hamonikr-finder',
			//enabled: false
			click: function () {
				toggleWindow();
			}
		},
		{
			label: 'Settings',
			click: function () {
				settingWindow.show();
			}
		},
		{
			label: 'Help',
			click: function () {}
		},
		{
			label: 'Quit',
			click: () => {
				app.quit();
			}
		}
	]

	let trayMenu = Menu.buildFromTemplate(trayMenuTemplate)
	trayIcon.setContextMenu(trayMenu)
}
let trayIcon = null;

app.on('ready', () => {
	// createTray();
	// setTimeout(createWindow, 500);
	createWindow();


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
	getOrgData(event);

	// 	const process = require('process'); 
	// 	// Check whether the method exists or not 
	// 	if (process.getuid) { 
	// 	console.log("The numerical user identity "
	// 				+ "of the Node.js process: "
	// 				+ process.getuid()); 
	// 	} 
	// 	var isRoot = (process.getuid && process.getuid() === 0)
	// 	console.log("isRoot======111======="+isRoot);

	// 	// if (!isRoot) {
	// 	// }
	// 	var env = process.env;
	//    	var home = env.HOME;
	//    	var user = env.LOGNAME || env.USER || env.LNAME || env.USERNAME;
	// 	if (process.platform === 'linux') {
	// 		home || (process.getuid() === 0 ? '/root' : (user ? '/home/' + user : null));
	// 	}

	// 	console.log("home==" + home);

});


const install_program_version_chkeckAsync = async (event) => {
	try {
		// #step 1. 기본 폴더 및 파일 생성 및 기본 프로그램 설치
		let initJobResult = await initHamonizeJob();
		console.log("111111111111initJobResult============" + initJobResult);


		await vpnCreate();
		let vpnCreateResultVal = await vpnCreateChk();
		console.log("222222222vpnCreateResultVal========================++" + vpnCreateResultVal);

		if (vpnCreateResultVal != 'Y') {
			// fail vpn create 
			event.sender.send('install_program_ReadyProcResult', 'N002');
		}


		if (initJobResult == 'Y') {


			//apt repository chk....update.skir.kr 허용 여부 체크
			let mkfolderResult = await aptRepositoryChkProc();
			console.log("aptRepositoryChkProc==" + mkfolderResult);



			// #step 2. 설치 프로그램 버전 체크
			let installProgramVersionResult = await install_program_version_chkeckProc();
			console.log("333333333333333333install_program_version_chkeckProc===============" + installProgramVersionResult);

			if (installProgramVersionResult > 0) { // 설치 프로그램 업데이트 필요..
				event.sender.send('install_program_version_chkeckResult', 'U999');

			} else { // 설치 프로그램 최신버전
				event.sender.send('install_program_version_chkeckResult', 'Y');
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
	install_program_ReadyAsync(event);
});


const install_program_ReadyAsync = async (event) => {
	try {

		// #step . vpn create & conn
		// await vpnCreate();
		let vpnCreateResult = await vpnCreateChk();
		console.log("vpnCreateResult========================++" + vpnCreateResult);

		if (vpnCreateResult == 'Y') {

			console.log("###########get Agent Info ###################");

			// #step . 에이전트에서 사용하는 정보 셋팅
			// let getAgentPcInfoResult = 'Y'; //await getAgentPcInfo();
			let getAgentPcInfoResult = await getAgentPcInfo();
			console.log("getAgentPcInfo============" + getAgentPcInfoResult);

			pcInfoUpdate(); // vpn 연결후 pc 정보 업데이트

			if (getAgentPcInfoResult == 'Y') {
				console.log("########### install  program version check ###################");
				event.sender.send('install_program_ReadyProcResult', 'Y');
			} else {
				// fail get Agent Server Info 
				event.sender.send('install_program_ReadyProcResult', 'N003');
			}

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

		console.log("====__dirname===" + __dirname);
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
function getAgentPcInfo() {
	return new Promise(function (resolve, reject) {

		console.log("====__dirname===" + __dirname);
		var getAgentInfo = "sh " + __dirname + "/shell/getAgentPcInfo.sh";

		sudo.exec(getAgentInfo, options,
			function (error, stdout, stderr) {
				if (error) {
					console.log("error is " + error);
					return resolve("N");
				} else {
					console.log('sgetAgentPcInfo   tdout: ' + stdout);
					console.log('getAgentPcInfo   stderr: ' + stderr);

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
					console.log("error is " + error);
					return resolve("N");
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
		var initJobShell = "sh " + __dirname + "/shell/vpnInstall.sh";
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
		var initJobShell = "sh " + __dirname + "/shell/vpnInstallChk.sh";
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
	let vpnInfoData = vpnchk();

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
			// log.info("//== sysInfo hw check() error  "+ err.message)
		}
	});

	var unirest = require('unirest');

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

	// const getHostname = execShellCommand('hostname');


	var unirest = require('unirest');
	// unirest.post(baseurl+'/hmsvr/setVpnUpdate')

	unirest.post(baseurl + '/hmsvr/setVpnUpdate')
		// unirest.post('http://192.168.0.210:8080/hmsvr/setVpnUpdate')

		.header('content-type', 'application/json')
		.send({
			events: [{
				// datetiem: '',
				uuid: 's-' + machindid,
				vpnipaddr: vpnipaddr
				// hostname: hostnameInSerer

			}]
		})
		.end(function (response) {
			console.log("response.body===" + response.body);

			// event.sender.send('serverInfoChkProc', response.body );
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


const getOrgData = async (event) => {
	var unirest = require('unirest');
	console.log("조직정보======================");
	unirest.post(baseurl + '/hmsvc/getOrgData')
		.header('content-type', 'application/json')
		.send({
			events: [{
				baseInfo: "baseInfo"
			}]
		})
		.end(function (response) {
			console.log("조직정보===1===getOrgData.body===" + JSON.stringify(response.body));
			event.sender.send('getOrgDataResult', response.body);
		});
}