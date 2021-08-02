const path = require("path");
const request = require('request');
const fetch = require('node-fetch');
const fs = require('fs')

var log = require('./logger');
var http = require('http');
const Poller = require('./Poller');

var filePath="/etc/hamonize/agent/";
var fileName="agentJob.txt";
var schedule = require('node-schedule'); 
var uuidVal=getUUID();
FnMkdir();

var centerUrl=getCenterInfo();


function myFunc(arg) {

	sysInfo();
  
	loginInfoAction();
	
	var backupData = backupFileData();
	log.info("myFuncBackupData---_" + backupData);
	if( backupData != "" ){
		// console.log(schedule.scheduledJobs);
        // var chkCronJob = JSON.stringify(schedule.scheduledJobs);
		var chkCronJob = schedule.scheduledJobs;
		// console.log("chkCronJob============================+"+ chkCronJob.cronbackup);
        // obj = JSON.parse(chkCronJob);

        // if( typeof chkCronJob.cronbackup  == 'undefined' ){
                schedule.cancelJob('cobj.cronbackuponbackup');
                fnBackupJob(backupData);
                log.info("//==Cron Backup Job status is : "+ schedule.scheduledJobs);
        // }else{
        //         log.info("//==dont cron backup job");
        // }
	}
} 


// setTimeout(myFunc, 6000, 'funky');
function hamonizeVersion() {

	var exec = require('child_process').exec;
	exec('sudo sh /usr/share/hamonize-agent/shell/hamonizeVersionChk.sh  ', function (err, stdout, stderr) {
			log.info('//=====hamonizeVersion  : ' + stdout);
	});
	

} 


// Set 1s timeout between polls
// note: this is previous request + processing time + timeout	
// let poller = new Poller(10000); 
let poller = new Poller(60000); 
//let poller = new Poller(600000); 

// Wait till the timeout sent our event to the EventEmitter
poller.onPoll(() => {
    log.info("//====agent polling start====")
	
	getProgrmDataCall( uuidVal ); // o
	getDeviceDataCall( uuidVal ); //  Call 비인가 디바이스 정책 
	getUpdtDataCall( uuidVal );	// o
	getRecoveryDataCall( uuidVal );
	getFirewallDataCall( uuidVal ); // o
	ipStatusCheck();
	hamonizeVersion();
	getBackupDataCall(uuidVal );

	sendToCenter_unauth();	// 비인가 디바이스 로그 전송 	

	poller.poll(); // Go for the next poll
});

// Initial start
poller.poll();

var readline = require('readline');



//========================================================================
//== ip status check  Job=============================================================
//========================================================================
function ipStatusCheck(){
	var ping = require('ping');
	var ip = require("ip");
	var ipAliveStatus = false;
	var hosts = ['google.com'];

	hosts.forEach(function(host){
		ping.sys.probe(host, function(isAlive){
			var msg = isAlive ? 'host ' + host + ' is alive' : 'host ' + host + ' is dead';
			console.log("ping checck ==="+ msg);
			ipAliveStatus = isAlive;
			console.log("ipAliveStatus====="+ipAliveStatus);

			if( !ipAliveStatus ){
			var exec = require('child_process').exec;
			exec('sudo sh /usr/share/hamonize-agent/shell/route_add_default_gw.sh  ', function (err, stdout, stderr) {
				log.info('//===== route add default gw stdout: ' + stdout);
				log.info('//=====route add default gw stderr: ' + stderr);

				if (err !== null) {
					log.info('//== ipAliveStatus error: ' + err);
				}
			});
		}

		});
	});
}


//========================================================================
//== Firewall Job=============================================================
//========================================================================-
function getFirewallDataCall(uuid){
//	Firewall 정책 정보 조회 
	var setUrl = "http://"+centerUrl+"/getAgent/firewall?name="+uuid;
	// log.info("fire===="+ setUrl);
	http.get(setUrl, (res) => {
		// log.info('//==statusCode is :', res.statusCode);

		res.on('data', (data) => {
				log.info("//== Firewall data is : " + data);
				if( data != 'nodata'  ){

					var updtFirewallObj = JSON.parse(data); 
					log.info("//====================================");
					log.info("//==FirewallObj Data is : "+ JSON.stringify(updtFirewallObj));
					log.info("//====================================");
			
					var fileDir = "/etc/hamonize/firewall/firewallInfo.hm";
					let content = JSON.stringify(updtFirewallObj);
					fs.writeFile(fileDir, content, (err) => {
						if(err){
							log.info("//== getFirewallDataCall() error  "+ err.message)
						}
						fnFirewallJob(content);
					});
				}
		});
	}).on('error', (e) => {log.info(e);});
}
function fnFirewallJob(retData){

	log.info("==== fnFirewallJob ====");

	var exec = require('child_process').exec;
	exec('sudo sh /usr/share/hamonize-agent/shell/ufwjob.sh  ', function (err, stdout, stderr) {
		log.info('//=====backup cycle all day of week stdout: ' + stdout);
		log.info('//=====backup cycle all day of week stderr: ' + stderr);

		if (err !== null) {
			log.info('//== backup_gubun week error: ' + err);
		}
	});
}

//========================================================================
//== Recovery Job=============================================================
//========================================================================
function getRecoveryDataCall(uuid){

//	Recovery 정책 정보 조회
	uuid = '2c6777e5d8a349fb92a14e65ad961447';
	var setUrl = "http://"+centerUrl+"/getAgent/recov?name="+uuid;
	log.info("getRecoveryDataCall==="+ setUrl);
	http.get(setUrl, (res) => {
		res.on('data', (data) => {
				log.info("//===11111111111111111111111111===getRecoveryDataCall= Recovery data is : " + data);
				log.info("updtRecovObj===================+++++"+ JSON.stringify(data));
				// if(  !data  && data != "nodata" ){

					
				if(  data != "nodata" && data != "{}"){
					// if( updtRecovObj.NAME != "undefined" ) {
						
					var updtRecovObj = JSON.parse(data);
				
					log.info("//====================================");
					log.info("//==RecovObj Data is : "+ JSON.stringify(updtRecovObj));
					log.info("//==RecovObj.PATH Data is : "+ JSON.stringify(updtRecovObj.PATH));
					log.info("//==RecovObj.NAME Data is : "+ JSON.stringify(updtRecovObj.NAME));
					log.info("//====================================");
						

					var fileDir = "/etc/hamonize/recovery/recoveryInfo.hm";
					let content = updtRecovObj.NAME;
					fs.writeFile(fileDir, content, (err) => {
						if(err){
							log.info("//== getRecoveryDataCall() error  "+ err.message)
						}
						// fnRecovJob(content);
					});
				} else {
					log.info("//================getRecoveryDataCall not working ===================")
					log.info("//===================================================================")	
				}

				
		});
	}).on('error', (e) => {log.info(e);});
}
function fnRecovJob(retData){

	log.info("==== fnRecovJob ====");

	var exec = require('child_process').exec;
	exec('sudo sh /usr/share/hamonize-agent/shell/backupJob_recovery.sh  ', function (err, stdout, stderr) {
		log.info('//=====backup cycle all day of week stdout: ' + stdout);
		log.info('//=====backup cycle all day of week stderr: ' + stderr);

		if (err !== null) {
			log.info('//== backup_gubun week error: ' + err);
		}
	});
}

//========================================================================
//== Updt Job=============================================================
//========================================================================
function getUpdtDataCall(uuid){
//	Updt 정책 정보 조회
	
	var setUrl = "http://"+centerUrl+"/getAgent/updt?name="+uuid;
	log.info("Updt Job >> getUpdtDataCall----->"+setUrl)
	http.get(setUrl, (res) => {
		res.on('data', (data) => {
				log.info("//== Updt data is : " + data);
				if( data != 'nodata'  ){
					var fileDir = "/etc/hamonize/updt/updtInfo.hm";
					let content = data;
					fs.writeFile(fileDir, content, (err) => {
						if(err){
							log.info("//== getUpdtDataCall() error  "+ err.message)
						}
						fnUpdtJob(content);
					});

				} else{
					log.info('getUpdtDataCall did not working')
				}
		});
	}).on('error', (e) => {log.info(e);});
}
function fnUpdtJob(retData){

	log.info("==== fnUpdtJob ====" + retData);

	var updtDataObj = JSON.parse(retData);
	log.info("//====================================");
	log.info("//==updtDataObj Data is : "+ JSON.stringify(updtDataObj));
	log.info("//==updtDataObj.Ins Data is : "+ JSON.stringify(updtDataObj.INS));
	log.info("//==updtDataObj.ups Data is : "+ JSON.stringify(updtDataObj.UPS));
	log.info("//====================================");

	//정책정보 파일로 저장
	outputData = updtFileData();
	log.info("//===outputData == "+ outputData);

	var exec = require('child_process').exec;
        exec(" sudo sh /usr/share/hamonize-agent/shell/updtjob.sh" , function (err, stdout, stderr) {
	          log.info( '업데이트 정책  stdout: ' + stdout);
              log.info( '업데이트 정책 stderr: ' + stderr);

              if (err !== null) {
                      log.info(' 업데이트 정책  error: ' + err);
              }
        });

}



//========================================================================
//== Nxss Job=============================================================
//========================================================================
function getNxssDataCall(uuid){

//	Nxss 정책 정보 조회
	var setUrl = "http://"+centerUrl+"/getAgent/nxss?name="+uuid;
	console.log("Nxss Job : "+setUrl)
	http.get(setUrl, (res) => {
		let data = '';
		res.on('data', (chunk) => { data += chunk; });
		res.on('end', () => {
				log.info("//== Nxss data is : " + data);
				if( data != 'nodata'  ){
					fnNxssJob(data);
				}
		});
	}).on('error', (e) => {log.info(e);});
}
function sendNxssResultToCenter(fileDate, gubun){

	log.info("fileDate------------" + fileDate+"=="+ gubun);
        var os = require("os");
        var hostname = os.hostname();

        request.post('http://'+centerUrl+'/act/nxssAct', {
                json: {
                        events: [{hostname:hostname, uuid:uuidVal, file_gubun:gubun, fileDate:fileDate}]
                }
        }, (error, res, body) => {
                if (error) {
                        console.error(error)
                        return
                }
                console.log(`statusCode: ${res.statusCode}`)
                console.log(body)
        })

}

function fnNxssJob(retData){

	log.info("==== fnNxssJob ====");
	var nxssDataObj = JSON.stringify(retData);
	log.info("//==nxssDataObj.nxssList Data is : "+ JSON.stringify(nxssDataObj.nxssList)+"\n");
	log.info("//==nxssDataObj.nxssList Data count is : "+ JSON.stringify(nxssDataObj.nxssListCnt));

	log.info("//==nxssDataObj.fording Data is : "+ JSON.stringify(nxssDataObj.fording));
	log.info("//==nxssDataObj.message Data is : "+ JSON.stringify(nxssDataObj.message));
	log.info("//====================================");

	if( typeof nxssDataObj.nxssList  != 'undefined'  ){
		var nxssData = nxssDataObj.nxssList;
		var arrNxssData = nxssData.split(","); 
		var nxssDataCnt = nxssDataObj.nxssListCnt;

		var fileDir = "/etc/hamonize/siteblock/illegalUrls.ini";
		let content = arrNxssData[0];

		// 새로운 값이 들어오면 illegalUrls에 추가
		fs.writeFile(fileDir, content, (err) => {
			if(err){
				log.info("//== nxssData Fn () error  "+ err.message)
			}
		});
		

		var exec = require('child_process').exec;
		const execSiteblockFileDate = function(cb){
			exec("ls -al /etc/hamonize/siteblock/illegalUrls.ini  | awk '{print $6$7\"_\"$8}'", (err, stdout, stderr) => {
    				if (err) {
      					console.error(`exec error: ${err}`);
      					return cb(err);
    				}
    				cb(null, {stdout,stderr});
  			});

		};
		execSiteblockFileDate(function(err, {stdout,stderr}) {
			sendNxssResultToCenter(stdout,"filelist");
		});

	}

	if( typeof nxssDataObj.fording  != 'undefined'  ){

		var nxssData = nxssDataObj.fording;
		var nxssM = nxssDataObj.message;
		var arrNxssData = nxssData.split(","); 
		var fileDir = "/etc/hamonize/siteblock/siteblock.ini";
		let content = "";
		content += "[SiteBlock]\n";
		content += "enable=true\n";
		content += "warningmsg="+nxssM+"\n";
		content += "warningurl="+arrNxssData[0]+"";

		console.log("======= content =======" + content + "\n")
		fs.writeFile(fileDir, content, (err) => {
			if(err){
				log.info("//== nxssData Fn () error  "+ err.message)
			}
		});

		var exec = require('child_process').exec;
                const execSiteblockFileDate = function(cb){
	                    exec("ls -al /etc/hamonize/siteblock/siteblock.ini  | awk '{print $6$7\"_\"$8}'", (err, stdout, stderr) => {
                                if (err) {
                                        console.error(`exec error: ${err}`);
                                        return cb(err);
                                }
                                cb(null, {stdout,stderr});
                        });

                };
                execSiteblockFileDate(function(err, {stdout,stderr}) {
                        sendNxssResultToCenter(stdout,"fording");
                });

	}
    

}

//========================================================================
//== Device Job=============================================================
//========================================================================
function getDeviceDataCall(uuid){
//	device 정책 정보 조회
	log.info("--- getDeviceDataCall start----");
	var setUrl = "http://"+centerUrl+"/getAgent/device?name="+uuid;
	log.info("--- getDeviceDataCall : setUrl ----" + setUrl);

	http.get(setUrl, (res) => {
		log.info('//==res is :', res);
		log.info('//==res data is :', res.data);

		res.on('data', (data) => {
				log.info("//== device data is : " + data);
				
				if( data != 'nodata'){
					var fileDir = "/etc/hamonize/security/device.hm";
					let content = data;
					const fs = require('fs')

					fs.writeFile(fileDir, content, (err) => {
						log.info("//== writeFile working === "+data);
						if(err){
							log.info("//== getDeviceDataCall() error  "+ err.message)
						}
						fnDeviceJob(content);
					});
				} else{
					// 변경된 디바이스 정책이 없는 경우 device.hm 파일 수정 x 
					log.info("//== writeFile didn't working === "+data);	
				}
		});
	}).on('error', (e) => {log.info(e);});
}




async function fnDeviceJob(retData){
	log.info("==== backup ====");

	var deviceDataObj = JSON.parse(retData);
	// var deviceDataObj = JSON.parse('{"INS":"aaaa-1234:qwer"}');
	// var deviceDataObj = JSON.parse('{"INS":"USB-046d:c534,aaaa-1234:qwer"}');
	
	// log.info("//====================================");
	// log.info("//==deviceDataObj Data is : "+ JSON.stringify(deviceDataObj));
	// log.info("//==deviceDataObj.INS Data is : "+ JSON.stringify(deviceDataObj.INS));
	// log.info("//==deviceDataObj.DEL Data is : "+ JSON.stringify(deviceDataObj.DEL));
	// log.info("//====================================");

	var os = new os_func();
	os.execCommand("sudo /usr/local/bin/center-lockdown").then(res=> {
		log.info("====centor-lockdown load --- > success\n");
		fnDeviceJob_result(deviceDataObj,'Y')
		
	}).catch(err=> {
		log.info("====centor-lockdown load --- > fail\n");
		fnDeviceJob_result(deviceDataObj,'N')
	})
	
}


// 비인가 디바이스 정책 배포 결과 전송
function fnDeviceJob_result(deviceDataObj, statusyn){
	// product, vendorCode, prodcutCode, statusyn){

	var os = require("os");
	var hostname = os.hostname();
	var deviceInsData = "";
	if( typeof deviceDataObj.INS  != 'undefined'  ){
		deviceInsData = deviceDataObj.INS;
	}else if( typeof deviceDataObj.DEL  != 'undefined'  ){
		deviceInsData = deviceDataObj.DEL;
	}

	let devicePolicyResult = "";
	var arrSetData = new Array(); 

	var arrDeviceInsData = deviceInsData.split(","); 
	for( var a in arrDeviceInsData){
		var product = arrDeviceInsData[a].split(",")[0].split("-")[0];
		var vendorCode = arrDeviceInsData[a].split(",")[0].split("-")[1].split(":")[0];
		var prodcutCode = arrDeviceInsData[a].split(",")[0].split("-")[1].split(":")[1];

		console.log("arrDeviceInsData=====++"+ arrDeviceInsData);
		console.log("product=====++"+ product);
		console.log("vendorCode=====++"+ vendorCode);
		console.log("prodcutCode=====++"+ prodcutCode);
		console.log("uuidVal=====++"+ uuidVal);
		

		var setData = new Object(); 
		setData.hostname = hostname;
		setData.uuidVal = uuidVal.trim();
		setData.product = product;
		setData.productCode = prodcutCode;
		setData.vendorCode = vendorCode;
		setData.statusyn = statusyn;
		
		arrSetData.push(setData);

	}

	
	let eventsData = {
		events : arrSetData
	};
	
	console.log("arrPointHistory==="+JSON.stringify(eventsData));

	
	request.post('http://'+centerUrl+'/act/deviceAct', {
		json: {
			events : arrSetData
	  	}
	}, (error, res, body) => {
		if (error) {
			console.error(error)
	    		return
		}
	  	console.log(`statusCode: ${res.statusCode}`)
	  	console.log(body)
	})

}


function sendToCenter_unauth(){

	log.info("--- sendToCenter_unauth start----");

	if (fs.existsSync('/etc/hamonize/usblog/usb-unauth.hm')){
		var events_str = fs.readFileSync('/etc/hamonize/usblog/usb-unauth.hm', 'utf8');
		
		events_str = events_str.replace(/'/g,'\"');
		events_str = events_str.replace(/\n/g,',').slice(0,-1);
		
		var data = '{"events": [ '+events_str+' ]}';
		console.log("data==== : "+ data);
		var events = JSON.parse(data);


		request.post('http://'+centerUrl+'/hmsvc/unauth', {
			json: events
		}, (error, res, body) => {
			if (error) {
				console.error(error);
					return
			}
		  	console.log(`statusCode: ${res.statusCode}`);
		  	console.log(body);
		})
		fs.unlinkSync('/etc/hamonize/usblog/usb-unauth.hm');
	}
	
}


async function usbUnauthProc(filename){	
	
	const usbUnauthProcVal = await aWaitGetUsbLogFile(filename);
	let eventsData = {
		events : [
			usbUnauthProcVal
		]
	};

	console.log(eventsData);
	
	request.post('http://'+centerUrl+'/hmsvc/unauth', {
		json: {
			eventsData
	  	}
	}, (error, res, body) => {

		console.log("res---"+ JSON.stringify(res));
		console.log(body)
		if (error) {
			console.error(error)
	    		return
		}
	  	console.log(`statusCode: ${res.statusCode}`)
	  	
	})

}

function aWaitGetUsbLogFile(filename) {
	const exec = require('child_process').exec;
	return new Promise((resolve, reject) => {
		let usbLogData = "";
		const lineReader = require('line-reader');
		lineReader.eachLine(filename, (line, last) => {
			
			if( !last){
				usbLogData += line + ",";
			}else {
				usbLogData += line;
				resolve(usbLogData);
			}

		});
	});
}


function sendUsbUnauth(){
	var filename = '/etc/hamonize/usblog/usb-unauth.hm';
	usbUnauthProc(filename);
}


//========================================================================
//== Progrm Job=============================================================
//========================================================================

function getProgrmDataCall(uuid){

//	progrm 정책 정보 조회
	var setUrl = "http://"+centerUrl+"/getAgent/progrm?name="+uuid;
	http.get(setUrl, (res) => {
		res.on('data', (data) => {
				log.info("//== progrm data is : " + data);
				if( data != 'nodata'  ){
					var fileDir = "/etc/hamonize/progrm/progrm.hm";
					let content = data;
					fs.writeFile(fileDir, content, (err) => {
						if(err){
							log.info("//== getProgrmDataCall() error  "+ err.message)
						}
						fnProgrmJob(content);
					});
				}
		});
	}).on('error', (e) => {log.info(e);});
}
function fnProgrmJob(retData){

	var progrmDataObj = JSON.parse(retData);
	log.info("//====================================");
	log.info("//==progrmDataObj Data is : "+ JSON.stringify(progrmDataObj));
	log.info("//==progrmDataObj.INS Data is : "+ JSON.stringify(progrmDataObj.INS));
	log.info("//==progrmDataObj.DEL Data is : "+ JSON.stringify(progrmDataObj.DEL));
	log.info("//====================================");

	var exec = require('child_process').exec;
	// exec('sudo sh /usr/share/hamonize-agent/shell/progrmjob.sh  ', function (err, stdout, stderr) {
	exec('sudo sh /usr/share/hamonize-agent/shell/tmpprogrmjob.sh  ', function (err, stdout, stderr) {
		log.info('//=====progrm  stdout: ' + stdout);
		log.info('//=====progrm stderr: ' + stderr);

		if (err !== null) {
			log.info('//== progrm error: ' + err);
		}
	});


}





//========================================================================
//== Backup Job=============================================================
//========================================================================

function getBackupDataCall(uuid){

	log.info("backup-----action");
//	백업 정책 정보 조회
	var setUrl = "http://"+centerUrl+"/getAgent/backup?name="+uuid;
	http.get(setUrl, (res) => {
		res.on('data', (data) => {
				log.info("//== Backup data is : " + data);
				if( data != 'nodata'  ){
					var fileDir = "/etc/hamonize/backup/backupInfo.hm";
					let content = data;
					fs.writeFile(fileDir, content, (err) => {
						if(err){
							log.info("//== getBackupDataCall() error  "+ err.message)
						}
						fnBackupJob(content);
					});
				}
		});
	}).on('error', (e) => {log.info(e);});
}
// fnBackupJob('a');
function fnBackupJob(retData){
	log.info("==== backup ========================= data ::: "+ retData);

//	 데이터 sample
// 주별	//{"backup":[{"cycle_time":"21:30","cycle_option":"mon,tue","Bac_gubun":"D"}]}
// 일		
// retData='{"backup":[{"cycle_time":"01:30","cycle_option":"","Bac_gubun":"E"}]}';
// 월		//{"backup":[{"cycle_time":"21:30","cycle_option":"2019\/06\/12","Bac_gubun":"M"}]} 

	if( retData == "nodata"){
		return false;
	}
	var backupDataObj = JSON.parse(retData);
	var backup_time = backupDataObj.backup[0].cycle_time;	// 시간
	var backup_cycle = backupDataObj.backup[0].cycle_option;	// 주기
	var backup_gubun = backupDataObj.backup[0].Bac_gubun;

	log.info("//===backup_time is " + backup_time);
	log.info("//===backup_cycle is " + backup_cycle);
	log.info("//===backup_gubun is " + backup_gubun);
	var hours=0,minutes=0;

	hours = backup_time.split(":")[0];
	minutes = backup_time.split(":")[1];

	log.info("//===hours is " + hours + "//===minutes is " + minutes+"//backup_gubun==="+ backup_gubun);


//	node crontab
//[Seconds: 0-59], [Minutes: 0-59], [Hours: 0-23], 
//[Day of Month: 1-31], [Months: 0-11 (Jan-Dec)], [Day of Week: 0-6 (Sun-Sat)]

// //	주별
	if( backup_gubun == 'D' ){
		schedule.cancelJob('cronbackup');
		const scheduler = schedule.scheduleJob('cronbackup', '01 '+minutes+' '+hours+' * * '+backup_cycle, 
		function(){ 
			log.info('//=====backup cycle all day of week : ' + hours+"/"+ minutes +"=="+ backup_cycle ); 
			var exec = require('child_process').exec;
			exec('sudo sh /usr/share/hamonize-agent/shell/backupJob.sh  ', function (err, stdout, stderr) {
				log.info('//=====backup cycle all day of week stdout: ' + stdout);
				log.info('//=====backup cycle all day of week stderr: ' + stderr);

				if (err !== null) {
					log.info('//== backup_gubun week error: ' + err);
				}
			});
		});
	}
// //	일별
if( backup_gubun == 'E' ){
	schedule.cancelJob('cronbackup');
	log.info("backup_gubun=1111111111111111========+"+backup_gubun);
	// const scheduler = schedule.scheduleJob('cronbackup', '01 '+minutes+' '+hours+' * * *', function(){ 
	// 	console.log("일별 백업 스케쥴");
	// });
	// const scheduler = schedule.scheduleJob('cronbackup', '01 '+minutes+' '+hours+' * * *', function(){ 
	
	const scheduler = schedule.scheduleJob('cronbackup', '01 '+minutes+' * * * *', function(){ 
		log.info('//=====backup cycle all day : ' + hours+"/"+ minutes +"=="+ backup_cycle); 
		var exec = require('child_process').exec;
		
		exec(' sudo sh /usr/share/hamonize-agent/shell/backupJob.sh  ', function (err, stdout, stderr) {
			// exec(' sudo sh /home/ryan/works_job/2021/rnd/rnd_gs/agent/src/shell/backupJob.sh  ', function (err, stdout, stderr) {

			log.info('//=====backup cycle all daystdout: ' + stdout);
			log.info('//=====backup cycle all daystderr: ' + stderr);

			if (err !== null) {
				log.info('//=====backup cycle all dayerror: ' + err);
			}
		});
	});
}
	
// //	월별
	if( backup_gubun == 'M' ){
		var month = backup_cycle.split("/")[1];
		var day = backup_cycle.split("/")[2];
		log.info(Date.now()+ "//====month is : " + month +", day : " + day);
		schedule.cancelJob('cronbackup');
		
		const scheduler = schedule.scheduleJob('cronbackup', '01 '+minutes+' '+hours+' '+day+' '+month+'  *', 
		
		function(){ 
			log.info('//=====backup cycle all month : ' + hours+"/"+ minutes +"//====month is : " + month +", day : " + day); 
			var exec = require('child_process').exec;
			exec('sudo sh /usr/share/hamonize-agent/shell/backupJob.sh  ', function (err, stdout, stderr) {
				log.info('//=====backup cycle all monthstdout: ' + stdout);
				log.info('//=====backup cycle all monthstderr: ' + stderr);

				if (err !== null) {
					log.info('//=====backup cycle all montherror: ' + err);
				}
			});
		});
	}

}


function backupFileData(){
	var output = "";
	var stats = fs.statSync("/etc/hamonize/backup/backupInfo.hm");
	log.info("//==backupFileData stats is "+ stats.isFile());
	

	if( stats.isFile()  ){
		var text = fs.readFileSync('/etc/hamonize/backup/backupInfo.hm', 'utf8');
		log.info("//==backupInfo file dat : " + text);
		output = text;
	}
	return output;
}


function updtFileData(){
	var output = "";
	var stats = fs.statSync("/etc/hamonize/updt/updtInfo.hm");
	log.info("//==updtFileData stats is "+ stats.isFile());
	

	if( stats.isFile()  ){
		var text = fs.readFileSync('/etc/hamonize/updt/updtInfo.hm', 'utf8');
		log.info("//==updtInfo file dat : " + text);
		output = text;
	}
	return output;
}


//========================================================================
//== Common Job=============================================================
//========================================================================


function getCenterInfo(){
	var retval = "";
       	var array = fs.readFileSync('/etc/hamonize/propertiesJob/propertiesInfo.hm').toString().split("\n");
	for(i in array) {
		if( array[i].indexOf("CENTERURL") != -1   ){
			var centerData = array[i].split("=");
			retval = centerData[1];
		// }else{
			// console.log("2---" + array[i]);
		}
	} 
	return retval;
}


function getUUID(){
	var text = fs.readFileSync('/etc/hamonize/uuid', 'utf8');
	log.info("//== pc uuid is : " + text);
	return text;
}

function getHwpInfo(filename){
	var text = fs.readFileSync('/etc/hamonize/hwinfo/' + filename, 'utf8');
	log.info("//== pc hw ifon is : " + text);
	return text;
}


function FnMkdir(){
	FnProgrmMkdir();
	FnSiteBlockMkdir();
	FnBackupMkdir();
	FnUpdtMkdir();
	FnSecurityMkdir();
	FnFirewallMkdir();
	FnRecoveryMkdir();
	FnHwInfoMkdir();
}



function FnHwInfoMkdir(){

	log.info("FnHwInfoMkdir----");
	try{
		 fs.lstatSync("/etc/hamonize/hwinfo").isDirectory();
	}catch(e){
	   // Handle error
	   if(e.code == 'ENOENT'){
		   log.info("//==mkdir directory");

			var exec = require('child_process').exec;
			exec(" sudo mkdir /etc/hamonize/hwinfo/ && sudo touch /etc/hamonize/hwinfo/hwinfo.hm ", 
				function (err, stdout, stderr) {
					log.info('//==stdout: ' + stdout);
					log.info('//==stderr: ' + stderr);
					if (err !== null) {
						log.info('//== mkdir error: ' + err);
					}
			});
	   }
	}
}


function FnProgrmMkdir(){

	log.info("FnProgrmMkdir----");
	try{
		 fs.lstatSync("/etc/hamonize/progrm").isDirectory();
	}catch(e){
	   // Handle error
	   if(e.code == 'ENOENT'){
		   log.info("//==mkdir directory");

			var exec = require('child_process').exec;
			exec(" sudo mkdir /etc/hamonize/progrm/ && sudo touch /etc/hamonize/progrm/progrm.hm ", 
				function (err, stdout, stderr) {
					log.info('//==stdout: ' + stdout);
					log.info('//==stderr: ' + stderr);
					if (err !== null) {
						log.info('//== mkdir error: ' + err);
					}
			});
	   }
	}
}


function FnSiteBlockMkdir(){

	log.info("FnSiteBlockMkdir----");
	try{
		 fs.lstatSync("/etc/hamonize/siteblock").isDirectory();
	}catch(e){
	   // Handle error
	   if(e.code == 'ENOENT'){
		   log.info("//==mkdir directory");

			var exec = require('child_process').exec;
			exec(" " + 
					" sudo mkdir /etc/hamonize/siteblock/ && sudo touch /etc/hamonize/siteblock/siteblock.ini && sudo touch /etc/hamonize/siteblock/illegalUrls.ini ", 
				function (err, stdout, stderr) {
					log.info('//==stdout: ' + stdout);
					log.info('//==stderr: ' + stderr);
					if (err !== null) {
						log.info('//== mkdir error: ' + err);
					}
			});
	   }
	}
}

function FnBackupMkdir(){

	log.info("FnBackupMkdir----");
	try{
		 fs.lstatSync("/etc/hamonize/backup").isDirectory();
	}catch(e){
	   // Handle error
	   if(e.code == 'ENOENT'){
		   log.info("//==mkdir directory");

			var exec = require('child_process').exec;
			exec(" " + 
					" sudo mkdir /etc/hamonize/backup/ && sudo touch /etc/hamonize/backup/backupInfo.hm ", 
				function (err, stdout, stderr) {
					log.info('//==stdout: ' + stdout);
					log.info('//==stderr: ' + stderr);
					if (err !== null) {
						log.info('//== mkdir error: ' + err);
					}
			});
	   }
	}
}

function FnUpdtMkdir(){

	log.info("FnUpdtMkdir----");
	try{
		 fs.lstatSync("/etc/hamonize/updt").isDirectory();
	}catch(e){
	   // Handle error
	   if(e.code == 'ENOENT'){
		   log.info("//==mkdir directory");

			var exec = require('child_process').exec;
			exec(" " + 
					" sudo mkdir /etc/hamonize/updt/ && sudo  touch /etc/hamonize/updt/updtInfo.hm ", 
				function (err, stdout, stderr) {
					log.info('//==stdout: ' + stdout);
					log.info('//==stderr: ' + stderr);
					if (err !== null) {
						log.info('//== mkdir error: ' + err);
					}
			});
	   }
	}
}

function FnSecurityMkdir(){

	log.info("FnSecurityMkdir----");
	try{
		 fs.lstatSync("/etc/hamonize/security").isDirectory();
	}catch(e){
	   // Handle error
	   if(e.code == 'ENOENT'){
		   log.info("//==mkdir directory");

			var exec = require('child_process').exec;
			exec(" " + 
					" sudo mkdir /etc/hamonize/security/ && sudo  touch /etc/hamonize/security/device.hm ", 
				function (err, stdout, stderr) {
					log.info('//==stdout: ' + stdout);
					log.info('//==stderr: ' + stderr);
					if (err !== null) {
						log.info('//== mkdir error: ' + err);
					}
			});
	   }
	}
}

function FnFirewallMkdir(){

	log.info("FnFirewallMkdir----");
	try{
		 fs.lstatSync("/etc/hamonize/firewall").isDirectory();
	}catch(e){
	   // Handle error
	   if(e.code == 'ENOENT'){
		   log.info("//==mkdir directory");

			var exec = require('child_process').exec;
			exec(" " + 
					" sudo mkdir /etc/hamonize/firewall/ && sudo  touch /etc/hamonize/firewall/firewallInfo.hm", 
				function (err, stdout, stderr) {
					log.info('//==stdout: ' + stdout);
					log.info('//==stderr: ' + stderr);
					if (err !== null) {
						log.info('//== mkdir error: ' + err);
					}
			});
	   }
	}
}


function FnRecoveryMkdir(){

	log.info("FnRecoveryMkdir----");
	try{
		 fs.lstatSync("/etc/hamonize/recovery").isDirectory();
	}catch(e){
	   // Handle error
	   if(e.code == 'ENOENT'){
		   log.info("//==mkdir directory");

			var exec = require('child_process').exec;
			exec(" " + 
					" sudo mkdir /etc/hamonize/recovery/ && sudo  touch /etc/hamonize/recovery/recoveryInfo.hm  && touch /var/log/hamonize/agentjob/agentjob_backup_recovery.log", 
				function (err, stdout, stderr) {
					log.info('//==stdout: ' + stdout);
					log.info('//==stderr: ' + stderr);
					if (err !== null) {
						log.info('//== mkdir error: ' + err);
					}
			});
	   }
	}
}



function execShellCommand(cmd) {
	const exec = require('child_process').exec;
	return new Promise((resolve, reject) => {
	 exec(cmd, (error, stdout, stderr) => {
	  if (error) {
	   console.warn(error);
	  }
	  resolve(stdout? stdout : stderr);
	 });
	});
}



function os_func() {
    this.execCommand = function (cmd) {
        return new Promise((resolve, reject)=> {
	var exec = require('child_process').exec;
           exec(cmd, (error, stdout, stderr) => {
             if (error) {
                reject(error);
                return;
            }
            resolve(stdout)
           });
       })
   }
}


// HW chk =====================================
const sysInfo = async() => {
	let retData = {}
	log.info("sysInfo.... ");

//		await execSetHostname(pcnum)

const si = require('systeminformation');

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

	const ipinfo = require("ip");		//	get os ip address
	const pcuuid = (await si.uuid()); 	//	 get os mac address 

	const machineIdSync = require('node-machine-id').machineIdSync;
	let machindid = machineIdSync({original: true});


	const pcHostname = await execShellCommand('hostname');
	const cpuid = await execShellCommand('dmidecode -t 4|grep ID');
	const usernm = await execShellCommand('users');
	
	let md5 = require('md5');
	// var hwinfoMD5 = cpuinfoMd5.replace(/\s/g, "") + diskInfo.replace(/\s/g, "") + diskSerialNum.replace(/\s/g, "") 
	// 	+ osinfoKernel.replace(/\s/g, "") + raminfo.replace(/\s/g, "") + machindid.replace(/\s/g, "");
	
	let hwinfoMD5 = cpuinfoMd5 + diskInfo + diskSerialNum + osinfoKernel + raminfo + machindid;
	// console.log("==="+hwinfoMD5+"----")

	
	let hwData = md5(hwinfoMD5);

	const base_hwinfo = getHwpInfo("hwinfo.hm");
	
	let isSendYn = false;
	if( hwData.trim() == base_hwinfo.trim() ){
		console.log("eq========" +hwData +"=="+ base_hwinfo);
		isSendYn = false;
	}else{
		isSendYn = true;
		let fileDir = "/etc/hamonize/hwinfo/hwinfo.hm";
		fs.writeFile(fileDir, hwData, (err) => {
			if(err){
				log.info("//== sysInfo hw check() error  "+ err.message)
			}
		});
		console.log("not eq========"+hwData+"==="+base_hwinfo);
	}


	if(isSendYn){

		var unirest = require('unirest');
		unirest.post('http://'+centerUrl+'/hmsvc/eqhw')
		.header('content-type', 'application/json')
		.send( {
			events:[{
				datetime: 'datetime',
				hostname: pcHostname,
				memory: raminfo,
				cpuid: cpuid,
				hddinfo: diskInfo,
				hddid: diskSerialNum,
				ipaddr: ipinfo.address(),
				uuid: machindid,
				user: usernm,
				macaddr: pcuuid.macs,
				cpuinfo: cpuinfo
			}]
		} )
		.end(function (response) {
			// console.log("response.body==="+JSON.stringify(response));
			console.log("\nbbbresponse.body==="+response.body);
		});
	}


  }


  const loginInfoAction = async() => {
	log.info("=========login=======================");
	var moment = require('moment'); 
	require('moment-timezone'); 
	moment.tz.setDefault("Asia/Seoul"); 
	var date = moment().format('YYYY-MM-DD HH:mm:ss'); 

	const machineIdSync = require('node-machine-id').machineIdSync;
	let machindid = machineIdSync({original: true});

	var unirest = require('unirest');
	unirest.post('http://'+centerUrl+'/act/loginout')
	.header('content-type', 'application/json')
	.send( {
		events:[{
			datetime: date,
			uuid: machindid,
			// user: usernm,
			gubun: 'LOGIN'
		}]
	} )
	.end(function (response) {
		// console.log("response.body==="+JSON.stringify(response));
		console.log("\loginInfoAction      .body==="+response.body);
	});
  }
  

  
  