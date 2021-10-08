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
const path = require('path');
const lineReader = require('line-reader');

const unirest = require('unirest');

const sudo = require('sudo-prompt');
const options = {
	name: 'Hamonikr'
	//   ,icns: '/home/ryan/1.png', // (optional) 
};
const si = require('systeminformation');
const md5 = require('md5');
const electronLocalshortcut = require('electron-localshortcut');
const axios = require('axios')
const baseurl = "http://192.168.0.76:8080";
// const baseurl = "<Hamonize Center Url>";
const winHamonize = require('./windowHamonize');
const fs = require('fs');


// const db = require("./database/db");
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
		console.log('F12 is pressed')
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
				log.info("Clicked on settings");
				settingWindow.show();
				log.info("Clicked on settings222");
			}
		},
		{
			label: 'Help',
			click: function () {
				log.info("Clicked on Help")
			}
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
	setTimeout(createWindow, 500)


});

app.on('window-all-closed', function () {
	if (process.platform !== 'darwin') {
		mainWindow.setSize(500, 70);
		app.quit();
	}
});

app.on('activate', function () {
	log.info("activate===" + mainWindow);
	if (mainWindow === null) {
		createWindow();
	}
});


ipcMain.on('shutdown', (event, path) => {
	console.log("main....shutdown");
	exec("gnome-session-quit --no-prompt", (error, stdout, stderr) => {
		if (error) {
			log.info(`exec error: ${error}`);
			return;
		}
	});

});


// const si = require('systeminformation');
// const osModule = require("os");

// os check
var opsys = process.platform;
if (opsys == "darwin") {
	opsys = "MacOS";
} else if (opsys == "win32" || opsys == "win64") {
	opsys = "Window";
} else if (opsys == "linux") {
	opsys = "Linux";
}
console.log(opsys) // I don't know what linux is.

let ps = "";
if (opsys == 'Window') {

	// const winshell = require('node-powershell');
	const winshell = require('node-powershell-await');
	ps = new winshell({
		executionPolicy: 'Bypass',
		noProfile: true
	});

}
var winFolderDir = "";



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

	winHamonize.winUUID = machindid;

	let vpnipaddr = '';
	let vpnInfoData = vpnchk();

	if (vpnInfoData.length == 0) {
		vpnipaddr = 'no vpn';
	} else {
		vpnipaddr = vpnInfoData;
	}


	var unirest = require('unirest');
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
				pcos: opsys.trim(),
				// pcos: osinfo.trim(),

				memory: raminfo.trim(),
				deptname: groupname.trim(),
				sabun: sabun.trim(),
				username: username.trim()

			}]
		})
		.end(function (response) {
			// console.log("sysInfo.body===" + JSON.stringify(response));
			// console.log("sysInfo.body===" + response.body);
			event.sender.send('pcInfoChkProc', response.body);
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
				// console.log('not conn');
				tmpIfname = 'not conn'; //'ERROR-1944';
				//return;
			}
			if (alias >= 1) {
				// console.log("alias >= 1  : " + ifname + ':' + alias, iface.address);
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
//== STEP 1. install_program_version_chkeck  =============================
//========================================================================

ipcMain.on('hamonize_org_settings', (event) => {
	console.log(`STEP 1. hamonize_org_settings`);
	winHamonize.hamonizeServerInfo(baseurl, event);
});

//========================================================================
//== STEP 2. add Client Pc Data Save on Center============================
//========================================================================
ipcMain.on('pcInfoChk', (event, groupname, sabun, username) => {
	mainWindow.setSize(620, 340);
	sysInfo(event, groupname, sabun, username);
	// console.log("CenterUrl===" + winHamonize.fn_telegrafConfFile());

});


//========================================================================
//== STEP 3. install_program_Ready  ======================================
//========================================================================

ipcMain.on('install_program_Ready', (event) => {
	mainWindow.setSize(620, 540);

	axios.get(baseurl + '/hmsvc/isVpnUsed', '', {
		headers: {
			"Content-Type": `application/json`
		}
	}).then((res) => {
		console.log("res.data======" + JSON.stringify(res.data));
		console.log("===============vvvvvvvvvvvvvvvvvv=========================+" + res.data[0]["vpn_used"]);
		winHamonize.setVpn_userd(res.data[0]["vpn_used"]);
	}).catch((error) => {
		console.log(error);
	}).then(() => {
		console.log("vpn_used============+" + winHamonize.getVpn_used());
		makePsFile(event);
	})

});


// 설치에 필요한 폴더및 프로그램  ps1 파일 생성
const makePsFile = async (event) => {

	// const userHomeDir = await execShellCommand('echo %userprofile%');
	// winFolderDir = userHomeDir.trim() + "\\Downloads\\";
	const userHomeDir = await execShellCommand('echo %temp%');
	winFolderDir = userHomeDir.trim() + "\\";


	//	기본폴더 생성
	let mkResult = await winHamonize.fn_mk_base_folder(winFolderDir);
	console.log("mkResult================" + mkResult);
	// 외부 인스톨 파일 설치
	let setInstallProgm_result = await winHamonize.fn_install_Program_settings_step(winFolderDir, winHamonize.getVpn_used());
	console.log("setInstallProgm============+" + setInstallProgm_result);

	// telegraf 설치 및 설정 
	let telegrafFile_result = await winHamonize.fn_install_Program_settings_step_telegraf(winFolderDir, winHamonize.winUUID);
	console.log("telegrafFile_result===========++" + telegrafFile_result);

	// GOP Settings
	let gopFile_result = await winHamonize.fn_install_Program_settings_step_GOP(winFolderDir, winHamonize.getVpn_used(), winHamonize.winUUID);
	console.log("gopFile_result=====" + gopFile_result);


	event.sender.send('install_program_ReadyProcResult', 'Y');
}



//========================================================================
//== STEP 4. program install   ===========================================
//========================================================================

ipcMain.on('hamonizeProgramInstall', (event) => {
	console.log("STEP 4. program install");
	installHamonize(event);
});


// window script run
const installHamonize = async (event) => {
	try {
		let tmpps = "";

		// mkBaseHamonize.ps1
		console.log("=== mk file & folder === START]");
		tmpps = winFolderDir + "mkBaseHamonize.ps1";
		ps.asyncAddCommand("powershell.exe -ExecutionPolicy Bypass -File " + tmpps);
		await ps.asyncInvoke();
		console.log("=== mk file & folder === END]");


		// programInstallFile.ps1
		console.log("=== programInstallFile === START]");
		tmpps = winFolderDir + "programInstallFile.ps1";
		ps.asyncAddCommand("powershell.exe -ExecutionPolicy Bypass -File " + tmpps);
		await ps.asyncInvoke();
		console.log("=== programInstallFile === END]");

		// telegraf.ps1
		console.log("=== telegraf === START]");
		tmpps = winFolderDir + "telegraf.ps1";
		ps.asyncAddCommand("powershell.exe -ExecutionPolicy Bypass -File " + tmpps);
		await ps.asyncInvoke();
		console.log("=== telegraf === END]");

		// gop.ps1
		console.log("=== GOP === START]");
		tmpps = winFolderDir + "gop.ps1";
		ps.asyncAddCommand("powershell.exe -ExecutionPolicy Bypass -File " + tmpps);
		await ps.asyncInvoke();
		console.log("=== GOP === END]");


		console.log("Step4. Install End ");

		event.sender.send('hamonizeProgramInstallResult', 'Y');


	} catch (err) {
		console.log("Step4 Error :: " + err);
		return Object.assign(err);
	}
}