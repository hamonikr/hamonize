const electron = require("electron");
const { Tray, Menu } = require("electron");
const { shell } = require("electron");
const { app, BrowserWindow, globalShortcut } = require("electron");
const { ipcMain } = require("electron");
const path = require("path");
const lineReader = require("line-reader");
const unirest = require("unirest");
const sudo = require("sudo-prompt");
const options = {
	name: "Hamonikr",
	// ,icns: '/home/ryan/1.png', // (optional)
};
const si = require("systeminformation");
const md5 = require("md5");
const electronLocalshortcut = require("electron-localshortcut");
const axios = require("axios");
const baseurl = "http://192.168.0.240:8083";
// const baseurl = "<Hamonize Center Url>";
const winHamonize = require("./windowHamonize");
const fs = require("fs");
let   winFolderDir = "";
let mainWindow, settingWindow;


winHamonize.setbaseurl(baseurl);

function createWindow() {
	mainWindow = new BrowserWindow({
		icon: "icons/png/emb2.png",
		skipTaskbar: false,
		width: 620,
		height: 400,
		frame: true,
		alwaysOnTop: false,
		resizable: true,
		transparent: true,
		show: true,
		webPreferences: {
			defaultEncoding: "utf8",
			defaultFontFamily: "cursive",
			focusable: true,
			webviewTag: true,
			contextIsolation: false,
			nodeIntegration: true,
			nodeIntegrationInWorker: true,
			nodeIntegrationInSubFrames: true,
		},
	});

	mainWindow.loadURL("file://" + __dirname + "/public/index.html");
	mainWindow.setMenu(null);
	mainWindow.setMenuBarVisibility(false);

	mainWindow.on("closed", function () {
		mainWindow = null;
	});

	mainWindow.webContents.on("did-finish-load", () => {
		mainWindow.show();
	});
	mainWindow.once("ready-to-show", () => {
		mainWindow.show();
	});

	electronLocalshortcut.register(mainWindow, "F12", () => {
		console.log("F12 is pressed");
		mainWindow.webContents.toggleDevTools();
	});
}

const toggleWindow = () => {
	mainWindow.isVisible() ? mainWindow.hide() : showWindow();
};
const showWindow = () => {
	const position = getWindowPosition();
	mainWindow.setPosition(position.x, position.y, false);
	mainWindow.show();
};
const getWindowPosition = () => {
	const windowBounds = mainWindow.getBounds();
	const trayBounds = trayIcon.getBounds();
	const x = Math.round(
		trayBounds.x + trayBounds.width / 2 - windowBounds.width / 2
	);
	const y = Math.round(trayBounds.y + trayBounds.height + 4);
	return { x: x, y: y };
};
const createTray = () => {
	trayIcon = new Tray(__dirname + "/icons/icon16.png");
	// tray.setTitle('hello world');
	const trayMenuTemplate = [
		{
			label: "Hamonikr-finder",
			// enabled: false
			click: function () {
				toggleWindow();
			},
		},
		{
			label: "Settings",
			click: function () {
				log.info("Clicked on settings");
				settingWindow.show();
				log.info("Clicked on settings222");
			},
		},
		{
			label: "Help",
			click: function () {
				log.info("Clicked on Help");
			},
		},
		{
			label: "Quit",
			click: () => {
				app.quit();
			},
		},
	];

	let trayMenu = Menu.buildFromTemplate(trayMenuTemplate);
	trayIcon.setContextMenu(trayMenu);
};
let trayIcon = null;

app.on("ready", () => {
	// createTray();
	setTimeout(createWindow, 500);
});

app.on("window-all-closed", function () {
	if (process.platform !== "darwin") {
		app.quit();
	}
});

app.on("activate", function () {
	if (mainWindow === null) {
		createWindow();
	}
});

ipcMain.on("shutdown", (event, path) => {
	console.log("main....shutdown");
	exec("gnome-session-quit --no-prompt", (error, stdout, stderr) => {
		if (error) {
			log.info(`exec error: ${error}`);
			return;
		}
	});
});

// os check
var opsys = process.platform;
process.env.NODE_TLS_REJECT_UNAUTHORIZED = "0";

if (opsys == "darwin") {
	opsys = "MacOS";
} else if (opsys == "win32" || opsys == "win64") {
	opsys = "Window";
} else if (opsys == "linux") {
	opsys = "Linux";
}
console.log(opsys); // don't  linux it.

let ps = "";
if (opsys == "Window") {
	// const winshell = require('node-powershell');
	const winshell = require("node-powershell-await");
	ps = new winshell({ executionPolicy: "Bypass", noProfile: true });
}


function execShellCommand(cmd) {
	const exec = require("child_process").exec;
	return new Promise((resolve, reject) => {
		exec(cmd, (error, stdout, stderr) => {
			if (error) {
				console.warn(error);
			}
			resolve(stdout ? stdout : stderr);
		});
	});
}

const sysInfo = async (event, groupname, sabun, username, tenant) => {
	let retData = {};
	const pcHostname = await execShellCommand("hostname");
	const cpu = await si.cpu(); // CPU Info
	let cpuinfo = ` ${cpu.manufacturer} ${cpu.brand} ${cpu.speed}GHz`;
	cpuinfo += ` ${cpu.cores} (${cpu.physicalCores} Physical)`;

	let cpuinfoMd5 = ` ${cpu.manufacturer} ${cpu.brand}`;
	cpuinfoMd5 += ` ${cpu.cores} (${cpu.physicalCores} Physical)`;

	const disk = (await si.diskLayout())[0]; // Disk Info
	const size = Math.round(disk.size / 1024 / 1024 / 1024);
	let diskInfo = ` ${disk.vendor} ${disk.name} ${size}GB ${disk.type} (${disk.interfaceType})`;
	let diskSerialNum = disk.serialNum;

	const os = await si.osInfo(); // OS Info
	let osinfo = ` ${os.distro} ${os.release} ${os.codename} (${os.platform})`;

	let osinfoKernel = ` ${os.kernel} ${os.arch}`;

	const ram = await si.mem(); // RAM Info
	const totalRam = Math.round(ram.total / 1024 / 1024 / 1024);
	let raminfo = ` ${totalRam}GB`;

	const ipinfo = require("ip"); // get os ip address
	const pcuuid = await si.uuid(); // get os mac address

	const macs = pcuuid.macs;

	const machineIdSync = require("node-machine-id").machineIdSync;
	let machindid = machineIdSync({ original: true });

	winHamonize.winUUID = machindid;

	let vpnipaddr = "";
	let vpnInfoData = vpnchk();

	if (vpnInfoData.length == 0) {
		vpnipaddr = "no vpn";
	} else {
		vpnipaddr = vpnInfoData;
	}

	var unirest = require("unirest");
	unirest
		.post(baseurl + "/hmsvc/setPcInfo")
		.header("content-type", "application/json")
		.send({
			events: [
				{
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
					username: username.trim(),
					domain: tenant.trim(),
				},
			],
		})
		.end(function (response) {
			console.log("sysInfo.body===" + JSON.stringify(response));
			console.log("sysInfo.body===" + response.body);
			event.sender.send("pcInfoChkProc", response.body);
		});
};

function vpnchk() {
	var os = require("os");
	var ifaces = os.networkInterfaces();
	var retVal = "";

	Object.keys(ifaces).forEach(function (ifname) {
		var alias = 0;
		var tmpIfname = "";
		ifaces[ifname].forEach(function (iface) {
			if (iface.internal !== false) {
				// if ('IPv4' !== iface.family || iface.internal !== false) {
				// console.log('not conn');
				tmpIfname = "not conn";
				// 'ERROR-1944';
				// return;
			}
			if (alias >= 1) {
				// console.log("alias >= 1  : " + ifname + ':' + alias, iface.address);
			} else {
				// console.log("this interface has only one ipv4 adress is :" + ifname, iface.address);
				if (ifname == "tun0") {
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

// ========================================================================
// == STEP 1. install_program_version_chkeck  =============================
// ========================================================================

ipcMain.on("hamonize_org_settings", (event) => {
	console.log(`STEP 1. hamonize_org_settings`);
	// const request = require('request');
	// request.get('https://console.hamonize.com/hmsvc/commInfoData', function(error, response, body){
	// console.log(response);
	// console.log(body);
	// console.log(error);
	// });

	winHamonize.hamonizeServerInfo(baseurl, event);
});

ipcMain.on("getAuth", async (event, authkeyVal) => {
	let userHomeDirWindow = await execShellCommand("echo %temp%");
	let windowFolderDirTmp = userHomeDirWindow.trim() + "\\";

	if (opsys == "Linux") {
		windowFolderDirTmp = "/tmp/";
	}

	winHamonize.getAuthProc(baseurl, authkeyVal, windowFolderDirTmp, event);
});

// getOrgData(event, baseurl, retData);

ipcMain.on("getOrgData", (event, tenantNm) => {
	winHamonize.getOrgData(tenantNm, event);
});

// ========================================================================
// == STEP 2. add Client Pc Data Save on Center============================
// ========================================================================
ipcMain.on("pcInfoChk", (event, groupname, sabun, username, tenantNm) => {
	mainWindow.setSize(620, 400);
	sysInfo(event, groupname, sabun, username, tenantNm);
	// console.log("CenterUrl===" + winHamonize.fn_telegrafConfFile());
});

// ========================================================================
// == STEP 3. install_program_Ready  ======================================
// ========================================================================

ipcMain.on("install_program_Ready", (event, tenantNm) => {
	mainWindow.setSize(620, 400);
	var vpn_used;

	unirest
		.get(baseurl + "/hmsvc/isVpnUsed")
		.header("content-type", "application/json")
		.send({
			events: [
				{
					domain: tenantNm.trim(),
				},
			],
		})
		.end(function (response) {
			var json = response.body;
			vpn_used = response.body[0]["vpn_used"];

			winHamonize.setVpn_userd(vpn_used);
			makePsFile(event, tenantNm);
		});
});

// 설치에 필요한 폴더및 프로그램  ps1 파일 생성
const makePsFile = async (event, tenantNm) => {

	console.log("install  needs make file folder =============");
	console.log("\n\n\n\n")
	// const userHomeDir = await execShellCommand('echo %userprofile%');
	// winFolderDir = userHomeDir.trim() + "\\Downloads\\";
	const userHomeDir = await execShellCommand("echo %temp%");
	console.log("userHomeDir========="+userHomeDir);
	console.log("\n\n\n\n")

	winFolderDir = userHomeDir.trim() + "\\";
	console.log("winFolder Dir is ==="+ winFolderDir);
	console.log("\n\n\n\n")

	// 기본폴더 생성
	let mkResult = await winHamonize.fn_mk_base_folder(winFolderDir);
	console.log("mkResult================" + mkResult);
	console.log("\n\n\n\n")
	
	console.log("tenantNm================" + tenantNm);
	console.log("\n\n\n\n")

	
	// H-User(Remote Tool) Run Script File
	let fn_mk_HUser_RunResult = await winHamonize.fn_mk_HUser_Run(
		winFolderDir,
		tenantNm
	);
	console.log("fn_mk_HUser_RunResult================" + fn_mk_HUser_RunResult);

	// 외부 인스톨 파일 설치
	let setInstallProgm_result =
		await winHamonize.fn_install_Program_settings_step(
			winFolderDir,
			winHamonize.getVpn_used()
		);
	console.log("setInstallProgm============+" + setInstallProgm_result);

	// telegraf 설치 및 설정
	let telegrafFile_result =
		await winHamonize.fn_install_Program_settings_step_telegraf(
			winFolderDir,
			winHamonize.winUUID,
			tenantNm
		);
	console.log("telegrafFile_result===========++" + telegrafFile_result);

	// GOP Settings
	let gopFile_result = await winHamonize.fn_install_Program_settings_step_GOP(
		winFolderDir,
		winHamonize.getVpn_used(),
		winHamonize.winUUID
	);
	console.log("gopFile_result=====" + gopFile_result);

	// Vpn Connection
	let vpnSettings_result = await winHamonize.fn_VpnConnection(
		winFolderDir,
		winHamonize.getVpn_used(),
		winHamonize.winUUID
	);
	console.log("vpnSettings_result================" + vpnSettings_result);


	// UFW in Window
	// netsh advfirewall firewall add rule name="h-admin" dir=in action=allow protocal=TCP localport=11100,11200,11300,11400

	
	event.sender.send("install_program_ReadyProcResult", "Y");
};

// ========================================================================
// == STEP 4. program install   ===========================================
// ========================================================================

ipcMain.on("hamonizeProgramInstall", (event) => {
	console.log("STEP 4. program install #############################################################");
	installHamonize(event);
});

// window script run
const installHamonize = async (event) => {
	try {
		let tmpps = "";

		// 기본폴더 생성] mkBaseHamonize.ps1
		console.log("winFolderDir=========++" + winFolderDir);
		console.log("========================== mk file & folder === START]");
		tmpps = winFolderDir + "mkBaseHamonize.ps1";
		ps.asyncAddCommand("powershell.exe -ExecutionPolicy Bypass -File " + tmpps);
		await ps.asyncInvoke();
		console.log("========================== mk file & folder === END]");

		// 외부 인스톨 파일 설치 (openvpn, hamonize-user)] programInstallFile.ps1
		console.log("========================== programInstallFile === START]");
		tmpps = winFolderDir + "programInstallFile.ps1";
		ps.asyncAddCommand("powershell.exe -ExecutionPolicy Bypass -File " + tmpps);
		await ps.asyncInvoke();
		console.log("========================== programInstallFile === END]");

		// telegraf.ps1
		console.log("========================== telegraf === START]");
		tmpps = winFolderDir + "telegraf.ps1";
		ps.asyncAddCommand("powershell.exe -ExecutionPolicy Bypass -File " + tmpps);
		await ps.asyncInvoke();
		console.log("========================== telegraf === END]");

		// gop.ps1
		console.log("========================== GOP === START]");
		tmpps = winFolderDir + "gop.ps1";
		ps.asyncAddCommand("powershell.exe -ExecutionPolicy Bypass -File " + tmpps);
		await ps.asyncInvoke();
		console.log("========================== GOP === END]");

		// vpn config
		console.log("========================== VPN Config === START]");
		tmpps = winFolderDir + "HvpnConnections.ps1";
		ps.asyncAddCommand("powershell.exe -ExecutionPolicy Bypass -File " + tmpps);
		///////////////////// await ps.asyncInvoke();
		console.log("========================== VPN Config === END]");

		// Remote Tool Config Settings] H-User(Romote Tool)run .ps1
		console.log("========================== H-User(Romote Tool)run === START]");
		console.log("작업중");
		tmpps = winFolderDir + "HUserRun.ps1";
		ps.asyncAddCommand("powershell.exe -ExecutionPolicy Bypass -File " + tmpps);
		// await ps.asyncInvoke();

		console.log("=== H-User(Romote Tool)run === END]");

		console.log("Step4. Install End ");

		event.sender.send("hamonizeProgramInstallResult", "Y");
	} catch (err) {
		console.log("Step4 Error :: " + err);
		return Object.assign(err);
	}
};
