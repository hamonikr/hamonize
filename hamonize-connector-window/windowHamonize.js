const axios = require('axios')
const https = require('https');
const fs = require('fs');


let ps = "";
let winFolderDir = "";
let CenterUrl, InfluxUrl, InfluxBucket, InfluxOrg, InfluxToken, VpnUrl, vpn_used = "";
let winUUID = "";
let gopBaseUrl = "";

exports.setVpn_userd = function (val) {
    console.log("val====================++" + val);
    vpn_used = val;
}
exports.getVpn_used = function () {
    return vpn_used;
}

exports.getCenterUrl = function () {
    return CenterUrl;
}
exports.getInfluxUrl = function () {
    return InfluxUrl;
}
exports.getInfluxBucket = function () {
    return InfluxBucket;
}
exports.getInfluxOrg = function () {
    return InfluxOrg;
}
exports.getInfluxToken = function () {
    return InfluxToken;
}
exports.getVpnUrl = function () {
    return VpnUrl;
}


// Variable install program 
let programInstallFileData = "\r\n";
let installExe = "";
let installProgName = "";

// mkdir hamonize folder 
exports.fn_mk_base_folder = function (winFolderDir) {
    return new Promise(function (resolve, reject) {

        let data = "mkdir -p 'C:\\ProgramData\\Hamonize-connect-utils\\Settings\\' -ErrorAction SilentlyContinue \r\n";
        data += "mkdir 'C:\\ProgramData\\Hamonize-connect-utils\\Settings\\log' -ErrorAction SilentlyContinue \r\n";
        data += "mkdir 'C:\\ProgramData\\Hamonize-connect-utils\\OSLogOnOffLog' -ErrorAction SilentlyContinue \r\n";

        fileDir = winFolderDir + "mkBaseHamonize.ps1";
        console.log("fileDir==============================" + fileDir);
        fs.writeFile(fileDir, data, (err) => {
            if (err) {
                return reject("N");
            } else {
                return resolve("Y");
            }
        });
    });
}
// Hamonize Install Program  Settings
exports.fn_install_Program_settings_step = function (winFolderDir, vpnused) {

    return new Promise(function (resolve, reject) {
        let setUrl = "https://api.github.com/repos/hamonikr/hamonize/releases/latest";
        axios.get(setUrl)
            .then(function (response) {
                // handle success
                console.log(response.data.tag_name);
                var objData = JSON.parse(JSON.stringify(response.data.assets));

                for (var i = 0; i < objData.length; i++) {
                    const objDataMatch = objData[i].browser_download_url.match(/hamonize-user.*.exe/);

                    if (objDataMatch != null) {

                        if (vpnused != '0') {
                            installProgName += "'openvpn-install.msi', 'hamonize-user.exe'";
                            installExe += "'https://swupdate.openvpn.org/community/releases/OpenVPN-2.5.3-I601-amd64.msi','" + objData[i].browser_download_url + "'";
                        } else {
                            installProgName += "'hamonize-user.exe'";
                            installExe += "'" + objData[i].browser_download_url + "'";
                        }

                    }
                }

            })
            .catch(function (error) {
                // handle error
                console.log(error);
            })
            .then(function () {
                programInstallFileData += '$log_path_file = "$env:temp\\installlog.log" \r\n';
                programInstallFileData += '$machine_name = Invoke-Command -ScriptBlock {hostname}  \r\n';
                programInstallFileData += '$date = (Get-Date -format "yyyy-MM-dd") \r\n';
                programInstallFileData += '$msi = @(' + installExe + ') \r\n';
                programInstallFileData += '$progmnm = @(' + installProgName + ') \r\n';
                programInstallFileData += 'For ($i=0; $i -lt $msi.Length; $i++) { \r\n';
                programInstallFileData += '[string]$LocalInstaller = $progmnm[$i] \r\n';

                // programInstallFileData += 'Write-Output $msi[$i] \r\n';
                // programInstallFileData += 'Write-Output  $env:temp\\$LocalInstaller \r\n';
                // programInstallFileData += 'Write-Output $LocalInstaller.indexof(".exe") \r\n';

                programInstallFileData += '[string]$InstallerURL = $msi[$i] \r\n';
                programInstallFileData += 'Invoke-RestMethod $InstallerURL -OutFile $env:temp\\$LocalInstaller \r\n';
                // programInstallFileData += 'Write-Output $LocalInstaller.indexof(".exe") \r\n';
                programInstallFileData += 'if( $LocalInstaller.indexof(".exe") -lt 0 ){ \r\n';
                programInstallFileData += '	Start-Process -FilePath "$env:systemroot\\system32\\msiexec.exe" -ArgumentList "/i `"$env:temp\\$LocalInstaller`" /qn /passive /log $log_path_file " -Wait \r\n';
                programInstallFileData += '}else{ \r\n';
                programInstallFileData += '	Start-Process $env:temp\\$LocalInstaller -ArgumentList  /S  \r\n';
                // programInstallFileData += '	Start-Process $env:temp\\$LocalInstaller -ArgumentList  /S  \r\n';
                programInstallFileData += '} \r\n';
                programInstallFileData += 'Start-Sleep 5 \r\n';
                programInstallFileData += '} \r\n';


                // programInstallFile += "cd '$env:systemroot\\' \r\n";
                // programInstallFile += "New-Item -Name programInstallFile.ps1 -Value '" + programInstallFileData + "' \r\n";


                programInstallFileData += "\r\n";


                programInstallFileData += "# Hamonize-Admin key & config Settings \r\n";
                programInstallFileData += ' wget ' + gopBaseUrl + '/getAgent/getpublickey -UseBasicParsing -O  C:\\ProgramData\\Hamonize-connect-utils\\Settings\\hamonize_public_key.pem \r\n';
                programInstallFileData += ' & \'c:program files\\hamonize\\hamonize-cli.exe\' authkeys import  C:\\ProgramData\\Hamonize-connect-utils\\Settings\\hamonize_public_key.pem  \r\n';
                programInstallFileData += ' wget ' + gopBaseUrl + '/getAgent/getconfigfile -UseBasicParsing -O  C:\\ProgramData\\Hamonize-connect-utils\\Settings\\hamonize.json \r\n';
                programInstallFileData += ' & \'c:program files\\hamonize\\hamonize-cli.exe\' config import  C:\\ProgramData\\Hamonize-connect-utils\\Settings\\hamonize.json  \r\n';
                programInstallFileData += ' & \'c:program files\\hamonize\\hamonize-cli.exe\' service restart  \r\n';


                // programInstallFileData += settingsHamonize() ;

                programInstallFileData += "\r\n";
                programInstallFileData += 'Write-Output "ENDINSTALL"';

                fileDir = winFolderDir + "programInstallFile.ps1";
                console.log("fileDir==============================" + fileDir);
                fs.writeFile(fileDir, programInstallFileData, (err) => {
                    if (err) {
                        return reject("N");
                    } else {
                        return resolve("Y");
                    }
                });

            });
    });
}



exports.fn_install_Program_settings_step_telegraf = function (winFolderDir, winUUID) {
    return new Promise(function (resolve, reject) {

        var StringPsData = "";

        let telegrafConfFile = "\r\n";
        telegrafConfFile += '[agent] \r\n';
        telegrafConfFile += 'interval = "10s" \r\n';
        telegrafConfFile += 'round_interval = true \r\n';
        telegrafConfFile += 'metric_batch_size = 1000 \r\n';
        telegrafConfFile += 'metric_buffer_limit = 10000 \r\n';
        telegrafConfFile += 'collection_jitter = "0s" \r\n';
        telegrafConfFile += 'flush_interval = "10s" \r\n';
        telegrafConfFile += 'flush_jitter = "0s" \r\n';
        telegrafConfFile += 'precision = "" \r\n';
        telegrafConfFile += 'debug = false \r\n';
        telegrafConfFile += 'quiet = false \r\n';
        telegrafConfFile += 'logfile = "" \r\n';
        telegrafConfFile += 'hostname = "" \r\n';
        telegrafConfFile += 'omit_hostname = false \r\n';
        telegrafConfFile += '[[outputs.influxdb_v2]]	 \r\n';
        telegrafConfFile += 'urls = ["http://' + InfluxUrl + '"] \r\n';
        telegrafConfFile += 'token = "' + InfluxToken + '" \r\n';
        telegrafConfFile += 'organization = "' + InfluxOrg + '" \r\n';
        telegrafConfFile += 'bucket = "' + InfluxBucket + '" \r\n';
        telegrafConfFile += '[[inputs.cpu]] \r\n';
        telegrafConfFile += 'percpu = true \r\n';
        telegrafConfFile += 'totalcpu = true \r\n';
        telegrafConfFile += 'collect_cpu_time = false \r\n';
        telegrafConfFile += 'report_active = false \r\n';
        telegrafConfFile += '[[inputs.disk]] \r\n';
        telegrafConfFile += 'ignore_fs = ["tmpfs", "devtmpfs", "devfs", "overlay", "aufs", "squashfs"] \r\n';
        telegrafConfFile += '[[inputs.diskio]] \r\n';
        telegrafConfFile += '[[inputs.mem]] \r\n';
        telegrafConfFile += '[[inputs.net]] \r\n';
        telegrafConfFile += '[[inputs.processes]] \r\n';
        telegrafConfFile += '[[inputs.swap]] \r\n';
        telegrafConfFile += '[[inputs.system]] \r\n';
        telegrafConfFile += '[global_tags] \r\n';
        telegrafConfFile += 'uuid = "' + winUUID + '" \r\n';

        StringPsData = "wget https://dl.influxdata.com/telegraf/releases/telegraf-1.20.0~rc0_windows_amd64.zip -UseBasicParsing -O '" + winFolderDir + "telegraf.zip" + "' \r\n";
        // StringPsData += "\r\n unzip telegraf-1.20.0~rc0_windows_amd64.zip";
        StringPsData += "Expand-Archive " + winFolderDir + "telegraf.zip -DestinationPath 'C:\\ProgramData\\Hamonize-connect-utils\\telegraf\\' \r\n";
        StringPsData += "cd 'C:\\ProgramData\\Hamonize-connect-utils\\telegraf\\' \r\n";
        StringPsData += "mv 'C:\\ProgramData\\Hamonize-connect-utils\\telegraf\\telegraf-1.20.0\\telegraf.*' . \r\n";
        StringPsData += "del 'C:\\ProgramData\\Hamonize-connect-utils\\telegraf\\telegraf-1.20.0\\' \r\n";
        StringPsData += "mv  'C:\\ProgramData\\Hamonize-connect-utils\\telegraf\\telegraf.conf' 'C:\\ProgramData\\Hamonize-connect-utils\\telegraf\\telegraf.conf_bak' \r\n";

        //  create telegraf conf file 
        StringPsData += "New-Item -Name telegraf.conf -Value '" + telegrafConfFile + "' \r\n";

        StringPsData += "Start-Sleep -s 2 \r\n";
        // telegraf install & service install 
        StringPsData += "  & 'C:\\ProgramData\\Hamonize-connect-utils\\telegraf\\telegraf.exe' --service install --service-name telegrafsvc03 --config 'C:\\ProgramData\\Hamonize-connect-utils\\telegraf\\telegraf.conf'   \r\n";
        StringPsData += 'net start telegrafsvc03 \r\n';

        StringPsData += '#######################[ TELEGRAF END ]################# \r\n';


        let fileDir = winFolderDir + "telegraf.ps1";
        fs.writeFile(fileDir, StringPsData, (err) => {
            if (err) {
                return reject("N");
            } else {
                return resolve("Y");
            }
        });
    });
}



exports.fn_install_Program_settings_step_GOP = function (winFolderDir, vpnusedYn, winUUID) {
    return new Promise(function (resolve, reject) {


        let hamonizeWinOSLogDataPSFile = "\r\n";


        hamonizeWinOSLogDataPSFile += '$ErrorActionPreference = "SilentlyContinue" \r\n';
        hamonizeWinOSLogDataPSFile += '$centerurl="' + gopBaseUrl + '/act/loginout"; \r\n';
        hamonizeWinOSLogDataPSFile += '$strName = $env:username \r\n';
        hamonizeWinOSLogDataPSFile += '$strComputerName = $env:ComputerName \r\n';
        hamonizeWinOSLogDataPSFile += '$strTime = Get-Date -Format "HH:mm:ss" \r\n';
        hamonizeWinOSLogDataPSFile += '$strDate = Get-Date -format "yyyy-MM-dd" \r\n';
        hamonizeWinOSLogDataPSFile += '$strFile = Get-Date -format "yyyy-MM" \r\n';
        hamonizeWinOSLogDataPSFile += '$strFileName = "C:\\ProgramData\\Hamonize-connect-utils\\OSLogOnOffLog\\" \r\n';
        hamonizeWinOSLogDataPSFile += '$strFileName += [string]$strFile + ".txt" \r\n';

        if (vpnusedYn == 1) {
            hamonizeWinOSLogDataPSFile += 'cd  "C:\\Program Files\\OpenVPN\\bin" \r\n';
            hamonizeWinOSLogDataPSFile += './openvpn-gui.exe --connect hamonize-winkey \r\n';

            hamonizeWinOSLogDataPSFile += ' \r\n';
            hamonizeWinOSLogDataPSFile += ' \r\n';
        }

        hamonizeWinOSLogDataPSFile += '$strDate + "," + $strTime + "," + $strName + "," + $strComputerName + "," + "Status :LOGIN"  | Out-File $strFileName -append -Encoding ASCII \r\n';
        hamonizeWinOSLogDataPSFile += '\r\n';
        hamonizeWinOSLogDataPSFile += '$datajson = @" \r\n'
        hamonizeWinOSLogDataPSFile += '{ \r\n'
        hamonizeWinOSLogDataPSFile += '"events":[{ \r\n'
        hamonizeWinOSLogDataPSFile += '"uuid":"' + winUUID + '", \r\n'
        hamonizeWinOSLogDataPSFile += '"gubun":"LOGIN", \r\n'
        hamonizeWinOSLogDataPSFile += '"datetime":"$strDate $strTime" \r\n'
        hamonizeWinOSLogDataPSFile += '}] \r\n'
        hamonizeWinOSLogDataPSFile += '} \r\n'
        hamonizeWinOSLogDataPSFile += '"@ \r\n'
        hamonizeWinOSLogDataPSFile += 'curl $centerurl -contenttype "application/json" -method post -Body $datajson \r\n'



        if (vpnusedYn == 1) {
            hamonizeWinOSLogDataPSFile += ' \r\n';
            hamonizeWinOSLogDataPSFile += '$ipdatajson = @" \r\n';
            hamonizeWinOSLogDataPSFile += '{ \r\n';
            hamonizeWinOSLogDataPSFile += '"events":[{ \r\n';
            hamonizeWinOSLogDataPSFile += '"datetime":"$strDate $strTime" , \r\n';
            hamonizeWinOSLogDataPSFile += '"macaddr":"macaddr", \r\n';
            hamonizeWinOSLogDataPSFile += '"ipaddr": "$(ipconfig | where {$_ -match \'IPv4.+\s(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\' } | out-null; $Matches[1])", \r\n';
            hamonizeWinOSLogDataPSFile += '"vpnipaddr":"$(ipconfig | where {$_ -match \'IPv4.+\s(\d{1,2}\.\d{1,3}\.\d{1,3}\.\d{1,3})\' } | out-null; $Matches[1])", \r\n';
            hamonizeWinOSLogDataPSFile += '"hostname":"$env:computername", \r\n';
            hamonizeWinOSLogDataPSFile += '"CPUID":"cpuid", \r\n';
            hamonizeWinOSLogDataPSFile += '"pcuuid":"' + winUUID + '", \r\n';
            hamonizeWinOSLogDataPSFile += '"action":"VPNIPCHNGE" \r\n';
            hamonizeWinOSLogDataPSFile += '}] \r\n';
            hamonizeWinOSLogDataPSFile += '} \r\n';
            hamonizeWinOSLogDataPSFile += '"@ \r\n';

            hamonizeWinOSLogDataPSFile += 'curl '+gopBaseUrl+'/hmsvc/pcInfoChange -contenttype "application/json" -method post -Body $ipdatajson \r\n';



        }



        let hamonizeWinOSLogDataPSFile_OFF = "\r\n";
        hamonizeWinOSLogDataPSFile_OFF += '$centerurl="' + gopBaseUrl + '/act/loginout";';
        hamonizeWinOSLogDataPSFile_OFF += '$strName = $env:username \r\n';
        hamonizeWinOSLogDataPSFile_OFF += '$strComputerName = $env:ComputerName \r\n';
        hamonizeWinOSLogDataPSFile_OFF += '$strTime = Get-Date -Format "HH:mm:ss" \r\n';
        hamonizeWinOSLogDataPSFile_OFF += '$strDate = Get-Date -format "yyyy-MM-dd" \r\n';
        hamonizeWinOSLogDataPSFile_OFF += '$strFile = Get-Date -format "yyyy-MM" \r\n';
        hamonizeWinOSLogDataPSFile_OFF += '$strFileName = "C:\\ProgramData\\Hamonize-connect-utils\\OSLogOnOffLog\\" \r\n';
        hamonizeWinOSLogDataPSFile_OFF += '$strFileName += [string]$strFile + ".txt" \r\n';
        hamonizeWinOSLogDataPSFile_OFF += '$strDate + "," + $strTime + "," + $strName + "," + $strComputerName + "," + "Status :LOGOUT"  | Out-File $strFileName -append -Encoding ASCII \r\n';
        hamonizeWinOSLogDataPSFile_OFF += '\r\n';
        hamonizeWinOSLogDataPSFile_OFF += '$datajson = @" \r\n'
        hamonizeWinOSLogDataPSFile_OFF += '{ \r\n'
        hamonizeWinOSLogDataPSFile_OFF += '"events":[{ \r\n'
        hamonizeWinOSLogDataPSFile_OFF += '"uuid":"' + winUUID + '", \r\n'
        hamonizeWinOSLogDataPSFile_OFF += '"gubun":"LOGOUT", \r\n'
        hamonizeWinOSLogDataPSFile_OFF += '"datetime":"$strDate $strTime" \r\n'
        hamonizeWinOSLogDataPSFile_OFF += '}] \r\n'
        hamonizeWinOSLogDataPSFile_OFF += '} \r\n'
        hamonizeWinOSLogDataPSFile_OFF += '"@ \r\n'
        hamonizeWinOSLogDataPSFile_OFF += 'curl $centerurl -contenttype "application/json" -method post -Body $datajson \r\n'

        let hamonizeWinOSGOPScirptFile = "\r\n";
        hamonizeWinOSGOPScirptFile += "[ScriptsConfig] \r\n";
        hamonizeWinOSGOPScirptFile += "StartExecutePSFirst=true \r\n";
        hamonizeWinOSGOPScirptFile += "EndExecutePSFirst=true \r\n";
        hamonizeWinOSGOPScirptFile += "[Logon] \r\n";
        hamonizeWinOSGOPScirptFile += "0CmdLine=C:\\ProgramData\\Hamonize-connect-utils\\Settings\\hamonizeWinOSLogDataFile.ps1 \r\n";
        hamonizeWinOSGOPScirptFile += "0Parameters='Logon' \r\n";
        hamonizeWinOSGOPScirptFile += "[Logoff] \r\n";
        hamonizeWinOSGOPScirptFile += "0CmdLine=C:\\ProgramData\\Hamonize-connect-utils\\Settings\\hamonizeWinOSLogDataFile_OFF.ps1 \r\n";
        hamonizeWinOSGOPScirptFile += "0Parameters='Logoff' \r\n";


        let StringPsData = "";
        StringPsData += "cd 'C:\\ProgramData\\Hamonize-connect-utils\\Settings\\' \r\n";
        StringPsData += "New-Item -Name hamonizeWinOSLogDataFile.ps1 -Value '" + hamonizeWinOSLogDataPSFile + "' \r\n";
        StringPsData += "New-Item -Name hamonizeWinOSLogDataFile_OFF.ps1 -Value '" + hamonizeWinOSLogDataPSFile_OFF + "' \r\n";

        // GOP scripts settings
        StringPsData += '$date = (Get-Date -format "yyyyMMddHHmmss") \r\n';
        StringPsData += "mv C:\\Windows\\System32\\GroupPolicy\\User\\Scripts\\psscripts.ini  C:\\Windows\\System32\\GroupPolicy\\User\\Scripts\\psscripts_bak_$date.ini\r\n";

        StringPsData += "cd 'C:\\Windows\\System32\\GroupPolicy\\User\\Scripts\\' \r\n";
        StringPsData += 'New-Item -Name psscripts.ini -Value "' + hamonizeWinOSGOPScirptFile + '" \r\n';

        if (vpnusedYn == 1) {
            StringPsData += "wget http://" + VpnUrl + ":3000/getClientsDownload/winovpn -UseBasicParsing -O 'C:\\Program Files\\openvpn\\config\\hamonize-winkey.ovpn'" + " \r\n";
        }



        StringPsData += '# paths \r\n'
        StringPsData += '$GpRoot = "${env:SystemRoot}\\System32\\GroupPolicy" \r\n'

        StringPsData += '# bumping machine/user script versions in gpt.ini \r\n'
        StringPsData += '$GpIni = Join-Path $GpRoot "gpt.ini" \r\n'
        StringPsData += '$MachineGpExtensions = "" \r\n'
        StringPsData += '$UserGpExtensions = \'{42B5FAAE-6536-11D2-AE5A-0000F87571E3}{40B66650-4972-11D1-A7CA-0000F87571E3}\' \r\n'

        StringPsData += '$contents = Get-Content $GpIni -ErrorAction SilentlyContinue \r\n'
        StringPsData += '$newVersion = 65537  \r\n'

        StringPsData += '$versionMatchInfo = $contents | Select-String -Pattern \'Version=(.+)\' \r\n'
        StringPsData += 'if ($versionMatchInfo.Matches.Groups -and $versionMatchInfo.Matches.Groups[1].Success) { \r\n'
        StringPsData += '$newVersion += [int]::Parse($versionMatchInfo.Matches.Groups[1].Value) \r\n'
        StringPsData += '} \r\n'

        StringPsData += '( \r\n'
        StringPsData += '"[General]", \r\n'
        StringPsData += '"gPCMachineExtensionNames=", \r\n'
        StringPsData += '"Version=$newVersion", \r\n'
        StringPsData += '"gPCUserExtensionNames=[$UserGpExtensions]" \r\n'
        StringPsData += ') | Out-File -FilePath $GpIni -Encoding ascii  \r\n'

        StringPsData += '# generating registry keys \r\n'
        StringPsData += 'gpupdate \r\n'

        StringPsData += 'Write-Output "testAsync2Proc" \r\n'

        // console.log("StringPsData===" + StringPsData);

        let fileDir = winFolderDir + "gop.ps1";
        fs.writeFile(fileDir, StringPsData, (err) => {
            if (err) {
                return reject("N");
            } else {
                return resolve("Y");
            }
        });
    });
}



// Get Hamonize base Info 
exports.hamonizeServerInfo = function (baseurl, event) {
    return new Promise(function (resolve, reject) {
        let setUrl = "http://" + baseurl + "/hmsvc/commInfoData";
        const machineIdSync = require('node-machine-id').machineIdSync;
        let WinMachindid = machineIdSync({
            original: true
        });

        axios({
            method: 'get',
            url: baseurl + '/hmsvc/commInfoData',
            data: {
                events: [{
                    uuid: WinMachindid
                }]
            }
        }).then((response) => {
            // console.log(response.data);

            var objData = JSON.parse(JSON.stringify(response.data.pcdata));
            console.log("objData===" + JSON.stringify(objData));

            for (var i = 0; i < objData.length; i++) {

                if (objData[i].svrname.match(/CENTERURL/)) {
                    CenterUrl = objData[i].pcip;
                } else if (objData[i].svrname.match(/INFLUX_BUCKET/)) {
                    InfluxBucket = objData[i].pcip;
                } else if (objData[i].svrname.match(/INFLUX_ORG/)) {
                    InfluxOrg = objData[i].pcip;
                } else if (objData[i].svrname.match(/INFLUX_TOKEN/)) {
                    InfluxToken = objData[i].pcip;
                } else if (objData[i].svrname.match(/INFLUX/)) {
                    InfluxUrl = objData[i].pcip;
                } else if (objData[i].svrname.match(/VPNIP/)) {
                    VpnUrl = objData[i].pcip;
                }
            }
            gopBaseUrl = baseurl;


            console.log("CenterUrl===" + CenterUrl);
            console.log("InfluxUrl===" + InfluxUrl);
            console.log("InfluxBucket===" + InfluxBucket);
            console.log("InfluxOrg===" + InfluxOrg);
            console.log("InfluxToken===" + InfluxToken);

            getOrgData(event, baseurl);


        }, (error) => {
            console.log(error);
        });

    });
}


const getOrgData = async (event, baseurl) => {
    var unirest = require('unirest');
    console.log("조직정보======================" + baseurl);
    axios({
        method: 'get',
        url: baseurl + '/hmsvc/getOrgData',
        data: {
            events: [{
                baseInfo: "baseInfo"
            }]
        }
    }).then((response) => {


        // console.log(response.data);
        event.sender.send('getOrgDataResult', response.data);

    }, (error) => {
        console.log(error);
    });


}