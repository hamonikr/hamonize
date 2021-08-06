# Hamonize-Connector

Hamonize-Connector는 원격지에서 다수의 PC를 관리하는데 필요한 기능들을 설치해주는 프로그램입니다. 


<br></br>
###  Usage

##### 1. Hamonize-Center API Url 정보 수정.

Hamonize-Connector는 
Hamonize-Center에서 등록된 원격지 컴퓨터들의 정보를 받아오기위해 Hamonize-Center 서버 API통신을 하고있습니다. 

```
main.js의 baseurl 정보와 ./shell/getAgentPcInfo.sh의 CenterUrl정보를 수정합니다. 

* main.js
const baseurl = "<Hamonize Center Url>";

* getAgentPcInfo.sh
CENTERURL="http://<Hamonize Center Url>/hmsvc/commInfoData"
```
<br>

##### 2. Vpn Client 
Hamonize는 원격지의 컴퓨터 접근을위해 Vpn Ip를 이욯하고 있습니다. 

```
cd Hamonize-connector/shell
vi ./vpnInstall.sh 파일 수정

 - SERVER1="<VPN Server IP>"
 - SERVERPORT="<VPN Server Port>"
    
```

##### 3. Hamonize-Connetor는 원격지의 컴퓨터를 관리하는데 필요한 실행 프로그램들을 일괄적으로 프로그램을 설치합니다. 

```

- 디바이스 관리를 위한 Udev 
- Vpn 통신을 위한 OpenVPN 
- 원격지 컴퓨터의 모니터링 도구 Collectd 
- 원격지 접속을 내역을 위한 서비스
- 프로그램 허용및 차단을 위한 Hamonize-Process-Mngr.service
- 원격지 컴퓨터 관리를 위한 Hamonize-Agent 

```


<br>

### Install 
```
git clone 
cd ./hamonize-connector
npm start 
```


### Build
```
dpkg-buildpackage -T clean

dpkg-buildpackage -b -us -uc -ui

```

    
