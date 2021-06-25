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
var uuidVal=getUUID()
FnMkdir();

var centerUrl=getCenterInfo();


function myFunc(arg) {
	var backupData = backupFileData();
	log.info("myFuncBackupData---_" + backupData);
	if( backupData != "" ){

        var chkCronJob = JSON.stringify(schedule.scheduledJobs);
        obj = JSON.parse(chkCronJob);

        if( typeof obj.cronbackup  == 'undefined' ){
                schedule.cancelJob('cobj.cronbackuponbackup');
                fnBackupJob(backupData);
                log.info("//==Cron Backup Job status is : "+ JSON.stringify(schedule.scheduledJobs));
        }else{
                log.info("//==dont cron backup job");
        }
	}
} 


function hamonizeVersion() {

	var exec = require('child_process').exec;
	exec('sudo sh /usr/share/hamonize-agent/shell/hamonizeVersionChk.sh  ', function (err, stdout, stderr) {
			log.info('//=====hamonizeVersion  : ' + stdout);
	});
	

} 


// Set 1s timeout between polls
// note: this is previous request + processing time + timeout
let poller = new Poller(10000); 
//let poller = new Poller(600000); 

// Wait till the timeout sent our event to the EventEmitter
poller.onPoll(() => {
    log.info("//====agent polling start====")
	
	getProgrmDataCall( uuidVal ); // o
	getDeviceDataCall( uuidVal ); // o 
	getNxssDataCall( uuidVal ); // 0
	getUpdtDataCall( uuidVal );	// o
	getRecoveryDataCall( uuidVal );
	getFirewallDataCall( uuidVal ); // o
	ipStatusCheck();
	hamonizeVersion();
	
	poller.poll(); // Go for the next poll
});

// Initial start
poller.poll();

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
	var setUrl = "http://"+centerUrl+"/getAgent/recov?name="+uuid;
	http.get(setUrl, (res) => {
		res.on('data', (data) => {
				log.info("//== Recovery data is : " + data);
				//fnRecovJob(data);
				if( data != 'nodata'  ){

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
						fnRecovJob(content);
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

function sendToCenter_result(product, vendorCode, prodcutCode, statusyn){

	var os = require("os");
	var hostname = os.hostname();
	log.info("hostname : "+hostname);

	log.info("centerUrl : "+centerUrl);

	var events = "[{hostname:"+hostname+",uuid:"+uuidVal+", procudt:"+product+", vendorCode:"+vendorCode+", productCode:"+prodcutCode+", statusyn:"+statusyn+"}]";
	
	request.post('http://'+centerUrl+'/act/deviceAct', {
		json: {
			events: [{hostname:hostname,uuid:uuidVal, procut:product, vendorCode:vendorCode, productCode:prodcutCode, statusyn:statusyn}]	
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

async function fnDeviceJob(retData){
	log.info("==== backup ====");

	var deviceDataObj = JSON.parse(retData);
	log.info("//====================================");
	log.info("//==deviceDataObj Data is : "+ JSON.stringify(deviceDataObj));
	log.info("//==deviceDataObj.INS Data is : "+ JSON.stringify(deviceDataObj.INS));
	log.info("//==deviceDataObj.DEL Data is : "+ JSON.stringify(deviceDataObj.DEL));
	log.info("//====================================");

	var os = new os_func();
	os.execCommand("sudo /usr/local/bin/center-lockdown").then(res=> {
				log.info("====centor-lockdown load --- > success\n");
			}).catch(err=> {
				log.info("====centor-lockdown load --- > fail\n");
			})
	
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
	exec('sudo sh /usr/share/hamonize-agent/shell/progrmjob.sh  ', function (err, stdout, stderr) {
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

function fnBackupJob(retData){
	log.info("==== backup ===="+ retData);

//	 데이터 sample
// 주별	//{"backup":[{"cycle_time":"21:30","cycle_option":"mon,tue","Bac_gubun":"D"}]}
// 일		//{"backup":[{"cycle_time":"21:30","cycle_option":"","Bac_gubun":"E"}]}
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

//	주별
	if( backup_gubun == 'D' ){
		schedule.cancelJob('cronbackup');
		const scheduler = schedule.scheduleJob('cronbackup', '01 '+minutes+' '+hours+' * * '+backup_cycle, 
//		const scheduler = schedule.scheduleJob('cronbackup', '* */'+minutes+' * *  *', 
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
//	일별
	if( backup_gubun == 'E' ){
		schedule.cancelJob('cronbackup');
		const scheduler = schedule.scheduleJob('cronbackup', '01 '+minutes+' '+hours+' * * *', function(){ 
			log.info('//=====backup cycle all day : ' + hours+"/"+ minutes +"=="+ backup_cycle); 
			var exec = require('child_process').exec;
			exec(' sudo sh /usr/share/hamonize-agent/shell/backupJob.sh  ', function (err, stdout, stderr) {
				log.info('//=====backup cycle all daystdout: ' + stdout);
				log.info('//=====backup cycle all daystderr: ' + stderr);

				if (err !== null) {
					log.info('//=====backup cycle all dayerror: ' + err);
				}
			});
		});
	}
	
//	월별
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
			console.log("1---" + array[i]);
			var centerData = array[i].split("=");
			console.log("h1===" + centerData[0]);
			console.log("h2===" + centerData[1]);
			retval = centerData[1];
		}else{
			console.log("2---" + array[i]);
		}
	} 
	return retval;
}


function getUUID(){
	var text = fs.readFileSync('/etc/hamonize/uuid', 'utf8');
	log.info("//== pc uuid is : " + text);
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
					" sudo mkdir /etc/hamonize/recovery/ && sudo  touch /etc/hamonize/recovery/recoveryInfo.hm ", 
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
