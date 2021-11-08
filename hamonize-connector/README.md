# Hamonize-Connector


### Hamonize-Connector?

하모나이즈 커넥터는 원격지에서 다수의 PC를 관리하는데 필요한 기능들을 설치해주는 프로그램입니다


<br>

### 사용법

<img width="500" src="../img/connector_main.png">
<br>

 자세한 내용은 [사용자 매뉴얼](http://team.hamonikr.org:18090/pages/viewpage.action?pageId=18415777) 을 참고하세요
 
 <br>

###  Usage

#### 1. Hamonize-Center API Url 정보 수정.

Hamonize-Connector는 
Hamonize-Center에서 등록된 원격지 컴퓨터들의 정보를 받아오기위해 Hamonize-Center 서버 API통신을 하고있습니다. 

```
main.js의 baseurl 정보와 ./shell/setServerInfo.sh의 CenterUrl정보를 수정합니다. 

* main.js
const baseurl = "<Hamonize Center Url>";

* setServerInfo.sh
CENTERURL="http://<Hamonize Center Url>/hmsvc/commInfoData"
```
<br>

#### 2. Vpn Client 
Hamonize는 원격지의 컴퓨터 접근을위해 Vpn Ip를 이용하고 있습니다. 

```
cd Hamonize-connector/shell
vi ./vpnInstall.sh 파일 수정

 - SERVER1="<VPN Server IP>"
 - SERVERPORT="<VPN Server Port>"
    
```

#### 3. Hamonize-Connetor는 원격지의 컴퓨터를 관리하는데 필요한 실행 프로그램들을 일괄적으로 프로그램을 설치합니다. 

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

src/ 위치에서 
```
git clone 
cd ./hamonize-connector

npm install
npm start 
```


### Build
hamonize-connector/ 위치에서
```
dpkg-buildpackage -T clean

dpkg-buildpackage -b -us -uc -ui

```


### 참여하기
* #### :sparkles: [issues](https://github.com/hamonikr/hamonize/issues)

*  Code Style
   * Hamonize-Connector는 Electron + Shell Script 사용
    - Linux Coding Style은 해당 [여기](https://www.kernel.org/doc/html/latest/process/coding-style.html) 를 참조하시기 바랍니다.
    - electronjs는 Prettier Module를 사용
    - 사용방법 :  
      1. npm i -D prettier 
      2. Package.json에 추가 아래의 내용추가 <br><br>
      ```
      {
          ...
          "scripts": {
              "prettier": "prettier --write '**/*.{ts,js,css,html}'"
          }
          ...
      }
      ```
      3. npm run prettier

    
