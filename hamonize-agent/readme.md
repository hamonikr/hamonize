# Hamonize-agent

### 데비안 패키징 방법
1) hamonize-agent/ 위치에서 
<br><b>dpkg-buildpackage -T clean</b>
<br><b>dpkg-buildpackage -b -us -uc -ui</b> 

<br></br>
### 소스 빌드방법
1) src/ 위치에서
<br><b>npm install</b>
    
2) 소스 빌드하기 
<br><b>npm run start</b> 

<br></br>
### 필수 디렉토리
- hamonize-agent 설치되는 위치 : /usr/share/hamonize-agent/
- log 파일 저장되는 위치 : /var/log/hamonize/agentJob
- hamonize-center와 연동되는 파일들 위치 : /etc/hamonize/

** .keep 파일은 빈 디렉토리 유지차 만든 파일 

<br></br>
### 로그확인
- agent 전체 로그 : tail -f /var/log/hamonize/agentJob/agentjob.log.{해당 date}
- 업데이트 정책 로그 : tail -f /var/log/hamonize/agentJob/updp.log


### apt 저장소 추가
```
wget -qO - http://106.254.251.74:28081/hamonize.pubkey.gpg | sudo apt-key add -

sudo add-apt-repository "deb [arch=amd64] http://106.254.251.74:28081 hamonize main"

```
