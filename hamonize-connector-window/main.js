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
const baseurl = "http://192.168.0.225:8080";
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



function testAsync2Proc() {
	return new Promise(function (resolve, reject) {

		var StringPsData = "";

		StringPsData = "wget https://dl.influxdata.com/telegraf/releases/telegraf-1.20.0~rc0_windows_amd64.zip -UseBasicParsing -O '" + winFolderDir + "telegraf.zip" + "' \r\n";
		// StringPsData += "\r\n unzip telegraf-1.20.0~rc0_windows_amd64.zip";
		StringPsData += "Expand-Archive " + winFolderDir + "telegraf.zip -DestinationPath 'C:\\Program Files\\HamonizeUtill\\telegraf\\' \r\n";
		StringPsData += "cd 'C:\\Program Files\\HamonizeUtill\\telegraf\\' \r\n";
		StringPsData += "mv 'C:\\Program Files\\HamonizeUtill\\telegraf\\telegraf-1.20.0\\telegraf.*' . \r\n";
		StringPsData += "del 'C:\\Program Files\\HamonizeUtill\\telegraf\\telegraf-1.20.0\\' \r\n";
		StringPsData += "mv  'C:\\Program Files\\HamonizeUtill\\telegraf\\telegraf.conf' 'C:\\Program Files\\HamonizeUtill\\telegraf\\telegraf.conf_bak' \r\n";

		//  create telegraf conf file 
		StringPsData += "New-Item -Name telegraf.conf -Value '" + winHamonize.fn_telegrafConfFile(winHamonize.getInfluxUrl(), winHamonize.getInfluxBucket(), winHamonize.getInfluxOrg(), winHamonize.getInfluxToken()) + "' \r\n";

		StringPsData += "Start-Sleep -s 2 \r\n";
		// telegraf install & service install 
		StringPsData += "  & 'C:\\Program Files\\HamonizeUtill\\telegraf\\telegraf.exe' --service install --service-name telegrafsvc03 --config 'C:\\Program Files\\HamonizeUtill\\telegraf\\telegraf.conf'   \r\n";
		StringPsData += 'net start telegrafsvc03 \r\n';

		StringPsData += '#######################[ TELEGRAF END ]################# \r\n';

		// Window logon & logoff 
		StringPsData += "cd 'C:\\Program Files\\HamonizeUtill\\' \r\n";
		StringPsData += "mkdir 'C:\\Program Files\\HamonizeUtill\\Settings\\' \r\n";
		StringPsData += "mkdir 'C:\\Program Files\\HamonizeUtill\\Settings\\log' \r\n";
		StringPsData += "mkdir 'C:\\ProgramData\\HamonizeUtill\\OSLogOnOffLog' \r\n";

		StringPsData += "cd 'C:\\Program Files\\HamonizeUtill\\Settings\\' \r\n";
		StringPsData += "New-Item -Name hamonizeWinOSLogDataFile.ps1 -Value '" + winHamonize.fn_ps_logon(winHamonize.getCenterUrl()) + "' \r\n";
		StringPsData += "New-Item -Name hamonizeWinOSLogDataFile_OFF.ps1 -Value '" + winHamonize.fn_ps_logoff(winHamonize.getCenterUrl()) + "' \r\n";

		// GOP scripts settings
		StringPsData += '$date = (Get-Date -format "yyyyMMddHHmmss") \r\n';
		StringPsData += "mv C:\\Windows\\System32\\GroupPolicy\\User\\Scripts\\psscripts.ini  C:\\Windows\\System32\\GroupPolicy\\User\\Scripts\\psscripts_bak_$date.ini\r\n";

		StringPsData += "cd 'C:\\Windows\\System32\\GroupPolicy\\User\\Scripts\\' \r\n";
		StringPsData += 'New-Item -Name psscripts.ini -Value "' + winHamonize.fn_windowGOPFile() + '" \r\n';

		StringPsData += "wget http://192.168.0.117:3000/getClientsDownload/winovpn -UseBasicParsing -O 'C:\\Program Files\\openvpn\\config\\winkey.ovpn'" + " \r\n";

		StringPsData += 'Write-Output "testAsync2Proc" \r\n'

		// console.log("StringPsData===" + StringPsData);

		let fileDir = winFolderDir + "tps1.ps1";
		fs.writeFile(fileDir, StringPsData, (err) => {
			if (err) {
				return reject("N");
			} else {
				return resolve("Y");
			}
		});
	});
}


// const https = require('https');
// const { json } = require('express');

// let programInstallFileData = "\r\n";
// let installExe = "'https://swupdate.openvpn.org/community/releases/OpenVPN-2.5.3-I601-amd64.msi'";
// let installProgName = "'openvpn-install.msi'";


// // curl --silent https://api.github.com/repos/hamonikr/hamonize/releases/latest | jq -r .tag_name
// function setInstallProgm(winFolderDir) {
// 	return new Promise(function (resolve, reject) {
// 		let setUrl = "https://api.github.com/repos/hamonikr/hamonize/releases/latest";


// 		axios.get(setUrl)
// 			.then(function (response) {
// 				// handle success
// 				console.log(response.data.tag_name);
// 				var objData = JSON.parse(JSON.stringify(response.data.assets));

// 				for (var i = 0; i < objData.length; i++) {
// 					const objDataMatch = objData[i].browser_download_url.match(/hamonize-admin.*.exe/);

// 					if (objDataMatch != null) {
// 						installExe += ",'" + objData[i].browser_download_url + "'";
// 						installProgName += ", 'hamonize-admin.exe'";
// 					}
// 				}

// 			})
// 			.catch(function (error) {
// 				// handle error
// 				console.log(error);
// 			})
// 			.then(function () {

// 				programInstallFileData += '$log_path_file = "C:\\Users\\rnd\\test\\installlog.log" \r\n';
// 				programInstallFileData += '$machine_name = Invoke-Command -ScriptBlock {hostname}  \r\n';
// 				programInstallFileData += '$date = (Get-Date -format "yyyy-MM-dd") \r\n';
// 				programInstallFileData += '$msi = @(' + installExe + ') \r\n';
// 				programInstallFileData += '$progmnm = ' + installProgName + ' \r\n';
// 				programInstallFileData += 'For ($i=0; $i -lt $msi.Length; $i++) { \r\n';
// 				programInstallFileData += '[string]$LocalInstaller = $progmnm[$i] \r\n';

// 				// programInstallFileData += 'Write-Output $msi[$i] \r\n';
// 				// programInstallFileData += 'Write-Output  $env:temp\\$LocalInstaller \r\n';
// 				// programInstallFileData += 'Write-Output $LocalInstaller.indexof(".exe") \r\n';

// 				programInstallFileData += '[string]$InstallerURL = $msi[$i] \r\n';
// 				programInstallFileData += 'Invoke-RestMethod $InstallerURL -OutFile $env:temp\\$LocalInstaller \r\n';
// 				// programInstallFileData += 'Write-Output $LocalInstaller.indexof(".exe") \r\n';
// 				programInstallFileData += 'if( $LocalInstaller.indexof(".exe") -lt 0 ){ \r\n';
// 				programInstallFileData += '	Start-Process -FilePath "$env:systemroot\\system32\\msiexec.exe" -ArgumentList "/i `"$env:temp\\$LocalInstaller`" /qn /passive /log $log_path_file " -Wait \r\n';
// 				programInstallFileData += '}else{ \r\n';
// 				programInstallFileData += '	Start-Process $env:temp\\$LocalInstaller -ArgumentList  /S  \r\n';
// 				programInstallFileData += '} \r\n';
// 				programInstallFileData += 'Start-Sleep 5 \r\n';
// 				programInstallFileData += '} \r\n';


// 				// programInstallFile += "cd '$env:systemroot\\' \r\n";
// 				// programInstallFile += "New-Item -Name programInstallFile.ps1 -Value '" + programInstallFileData + "' \r\n";


// 				programInstallFileData += "\r\n";
// 				// programInstallFileData += settingsHamonize() ;

// 				programInstallFileData += "\r\n";
// 				programInstallFileData += 'Write-Output "ENDINSTALL"';

// 				fileDir = winFolderDir + "programInstallFile.ps1";
// 				fs.writeFile(fileDir, programInstallFileData, (err) => {
// 					if (err) {
// 						return reject("N");
// 					} else {
// 						return resolve("Y");
// 					}
// 				});

// 			});
// 	});
// }




// let telegrafConfFile = "\r\n";
// telegrafConfFile += '[agent] \r\n';
// telegrafConfFile += 'interval = "10s" \r\n';
// telegrafConfFile += 'round_interval = true \r\n';
// telegrafConfFile += 'metric_batch_size = 1000 \r\n';
// telegrafConfFile += 'metric_buffer_limit = 10000 \r\n';
// telegrafConfFile += 'collection_jitter = "0s" \r\n';
// telegrafConfFile += 'flush_interval = "10s" \r\n';
// telegrafConfFile += 'flush_jitter = "0s" \r\n';
// telegrafConfFile += 'precision = "" \r\n';
// telegrafConfFile += 'debug = false \r\n';
// telegrafConfFile += 'quiet = false \r\n';
// telegrafConfFile += 'logfile = "" \r\n';
// telegrafConfFile += 'hostname = "" \r\n';
// telegrafConfFile += 'omit_hostname = false \r\n';
// telegrafConfFile += '[[outputs.influxdb_v2]]	 \r\n';
// telegrafConfFile += 'urls = ["http://192.168.0.76:8086"] \r\n';
// telegrafConfFile += 'token = "My6cY9v6NnqciitpZpHhFOBFxiNu93maRqKhdajgcXPy8zyh7ESZjlNolsOfZ7mniFR_Iprxh7LxeM8uO_uYvA==" \r\n';
// telegrafConfFile += 'organization = "hamonize" \r\n';
// telegrafConfFile += 'bucket = "invesume" \r\n';
// telegrafConfFile += '[[inputs.cpu]] \r\n';
// telegrafConfFile += 'percpu = true \r\n';
// telegrafConfFile += 'totalcpu = true \r\n';
// telegrafConfFile += 'collect_cpu_time = false \r\n';
// telegrafConfFile += 'report_active = false \r\n';
// telegrafConfFile += '[[inputs.disk]] \r\n';
// telegrafConfFile += 'ignore_fs = ["tmpfs", "devtmpfs", "devfs", "overlay", "aufs", "squashfs"] \r\n';
// telegrafConfFile += '[[inputs.diskio]] \r\n';
// telegrafConfFile += '[[inputs.mem]] \r\n';
// telegrafConfFile += '[[inputs.net]] \r\n';
// telegrafConfFile += '[[inputs.processes]] \r\n';
// telegrafConfFile += '[[inputs.swap]] \r\n';
// telegrafConfFile += '[[inputs.system]] \r\n';
// telegrafConfFile += '[global_tags] \r\n';
// telegrafConfFile += 'uuid = "telegrafsvc03" \r\n';


// let hamonizeWinOSLogDataPSFile = "\r\n";
// // hamonizeWinOSLogDataPSFile += ' cd "C:\\Program Files\\OpenVPN\\bin\\" \r\n';
// hamonizeWinOSLogDataPSFile += '& C:\\Program Files\\OpenVPN\\bin\\openvpn-gui.exe --connect winkey \r\n';
// hamonizeWinOSLogDataPSFile += '$ErrorActionPreference = "SilentlyContinue" \r\n';
// hamonizeWinOSLogDataPSFile += '$centerurl="http://192.168.0.225:8080/act/loginout";';
// hamonizeWinOSLogDataPSFile += '$strName = $env:username \r\n';
// hamonizeWinOSLogDataPSFile += '$strComputerName = $env:ComputerName \r\n';
// hamonizeWinOSLogDataPSFile += '$strTime = Get-Date -Format "HH:mm:ss" \r\n';
// hamonizeWinOSLogDataPSFile += '$strDate = Get-Date -format "yyyy-MM-dd" \r\n';
// hamonizeWinOSLogDataPSFile += '$strFile = Get-Date -format "yyyy-MM" \r\n';
// hamonizeWinOSLogDataPSFile += '$strFileName = "C:\\ProgramData\\HamonizeUtill\\OSLogOnOffLog\\" \r\n';
// hamonizeWinOSLogDataPSFile += '$strFileName += [string]$strFile + ".txt" \r\n';
// hamonizeWinOSLogDataPSFile += '$strDate + "," + $strTime + "," + $strName + "," + $strComputerName + "," + "Status :"  | Out-File $strFileName -append -Encoding ASCII \r\n';
// hamonizeWinOSLogDataPSFile += '\r\n';
// hamonizeWinOSLogDataPSFile += '$datajson = @" \r\n'
// hamonizeWinOSLogDataPSFile += '{ \r\n'
// hamonizeWinOSLogDataPSFile += '"events":[{ \r\n'
// hamonizeWinOSLogDataPSFile += '"uuid":"uuid", \r\n'
// hamonizeWinOSLogDataPSFile += '"gubun":"LOGIN", \r\n'
// hamonizeWinOSLogDataPSFile += '"datetime":"$strDate $strTime" \r\n'
// hamonizeWinOSLogDataPSFile += '}] \r\n'
// hamonizeWinOSLogDataPSFile += '} \r\n'
// hamonizeWinOSLogDataPSFile += '"@ \r\n'
// hamonizeWinOSLogDataPSFile += 'curl $centerurl -contenttype "application/json" -method post -Body $datajson \r\n'


// let hamonizeWinOSLogDataPSFile_OFF = "\r\n";
// hamonizeWinOSLogDataPSFile_OFF += '$ErrorActionPreference = "SilentlyContinue" \r\n';
// hamonizeWinOSLogDataPSFile_OFF += '$centerurl="http://192.168.0.225:8080/act/loginout";';
// hamonizeWinOSLogDataPSFile_OFF += '$strName = $env:username \r\n';
// hamonizeWinOSLogDataPSFile_OFF += '$strComputerName = $env:ComputerName \r\n';
// hamonizeWinOSLogDataPSFile_OFF += '$strTime = Get-Date -Format "HH:mm:ss" \r\n';
// hamonizeWinOSLogDataPSFile_OFF += '$strDate = Get-Date -format "yyyy-MM-dd" \r\n';
// hamonizeWinOSLogDataPSFile_OFF += '$strFile = Get-Date -format "yyyy-MM" \r\n';
// hamonizeWinOSLogDataPSFile_OFF += '$strFileName = "C:\\ProgramData\\HamonizeUtill\\OSLogOnOffLog\\" \r\n';
// hamonizeWinOSLogDataPSFile_OFF += '$strFileName += [string]$strFile + ".txt" \r\n';
// hamonizeWinOSLogDataPSFile_OFF += '$strDate + "," + $strTime + "," + $strName + "," + $strComputerName + "," + "Status :"  | Out-File $strFileName -append -Encoding ASCII \r\n';
// hamonizeWinOSLogDataPSFile_OFF += '\r\n';
// hamonizeWinOSLogDataPSFile_OFF += '$datajson = @" \r\n'
// hamonizeWinOSLogDataPSFile_OFF += '{ \r\n'
// hamonizeWinOSLogDataPSFile_OFF += '"events":[{ \r\n'
// hamonizeWinOSLogDataPSFile_OFF += '"uuid":"uuid", \r\n'
// hamonizeWinOSLogDataPSFile_OFF += '"gubun":"LOGOUT", \r\n'
// hamonizeWinOSLogDataPSFile_OFF += '"datetime":"$strDate $strTime" \r\n'
// hamonizeWinOSLogDataPSFile_OFF += '}] \r\n'
// hamonizeWinOSLogDataPSFile_OFF += '} \r\n'
// hamonizeWinOSLogDataPSFile_OFF += '"@ \r\n'
// hamonizeWinOSLogDataPSFile_OFF += 'curl $centerurl -contenttype "application/json" -method post -Body $datajson \r\n'





// let hamonizeWinOSGOPScirptFile = "\r\n";
// hamonizeWinOSGOPScirptFile += "[ScriptsConfig] \r\n";
// hamonizeWinOSGOPScirptFile += "StartExecutePSFirst=true \r\n";
// hamonizeWinOSGOPScirptFile += "EndExecutePSFirst=true \r\n";
// hamonizeWinOSGOPScirptFile += "[Logoff] \r\n";
// hamonizeWinOSGOPScirptFile += "0CmdLine=C:\\Program Files\\HamonizeUtill\\Settings\\hamonizeWinOSLogDataFile_OFF.ps1 \r\n";
// hamonizeWinOSGOPScirptFile += "0Parameters='Logoff' \r\n";
// hamonizeWinOSGOPScirptFile += "[Logon] \r\n";
// hamonizeWinOSGOPScirptFile += "0CmdLine=C:\\Program Files\\HamonizeUtill\\Settings\\hamonizeWinOSLogDataFile.ps1 \r\n";
// hamonizeWinOSGOPScirptFile += "0Parameters='Logon' \r\n";



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


	// var md5 = require('md5');
	// let hwinfoMD5 = cpuinfoMd5 + diskInfo + diskSerialNum + osinfoKernel + raminfo + machindid;
	// let hwData = md5(hwinfoMD5);

	// let fileDir = "/etc/hamonize/hwinfo/hwinfo.hm";
	// fs.writeFile(fileDir, hwData, (err) => {
	// 	if (err) {
	// 		// log.info("//== sysInfo hw check() error  "+ err.message)
	// 	}
	// });

	console.log("machindid---" + machindid);
	console.log("cpuinfo.trim()---" + cpuinfo.trim());
	console.log("diskSerialNum.trim()---" + diskSerialNum.trim());
	console.log("diskInfo.trim()---" + diskInfo.trim());
	console.log("macs[0]---" + macs[0]);
	console.log("ipinfo.address().trim()---" + ipinfo.address().trim());
	console.log("vpnipaddr.trim()---" + vpnipaddr.trim());
	console.log("pcHostname.trim()---" + pcHostname.trim());
	console.log("osinfo.trim()---" + osinfo.trim());
	console.log("raminfo.trim(),---" + raminfo.trim(), );
	console.log("groupname.trim()---" + groupname.trim());
	console.log("sabun---" + sabun);
	console.log("username---" + username);
	console.log("pcuuid---" + pcuuid);

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



// todo --list 
/*
	chk telegraf folder & filre 
	get telegraf token 
	get organizaion uuid & seq
	set make service name ( use organizaion uuid & seq )
*/



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
		console.log("res.data======"  +JSON.stringify(res.data));
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
	let telegrafFile_result = await winHamonize.fn_install_Program_settings_step_telegraf(winFolderDir);
	console.log("telegrafFile_result===========++" + telegrafFile_result);

	// GOP Settings
	let gopFile_result = await winHamonize.fn_install_Program_settings_step_GOP(winFolderDir,winHamonize.getVpn_used(), winHamonize.winUUID);
	console.log("gopFile_result=====" + gopFile_result);

	// await testAsync2Proc();

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
const installHamonize = async () => {
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



	} catch (err) {
		console.log("Step4 Error :: " + err);
		return Object.assign(err);
	}
}