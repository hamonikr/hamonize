# Hamonize-agent
## Hamonize-agent?
![license](https://img.shields.io/badge/Apache-License2.0-green.svg)

하모나이즈 에이전트는 개별 pc에 설치되어 하모나이즈 센터에서 배포된 정책을 수행하는 에이전트 프로그램입니다

<br>

### 데비안 패키징 방법

hamonize-agent/ 위치에서 
```
dpkg-buildpackage -T clean
dpkg-buildpackage -b -us -uc -ui 
```
<br>

### 소스 빌드하기
1) src/ 위치에서 
   ```
    npm install
    ```   

2)  실행하기
    ```
    npm run start 
    ```

<br>


### 필수 디렉토리
- hamonize-agent 설치되는 위치 : /usr/share/hamonize-agent/
- log 파일들 위치 : /var/log/hamonize/agentJob
- hamonize-center와 연동시  필요한 파일들의 위치 : /etc/hamonize/

<br>

### 로그확인
- agent 로그 
  ```
  tail -f /var/log/hamonize/agentJob/agentjob.log.{해당 date}
   ```



<br></br>
### 참여하기
 
* #### :sparkles: [issues](https://github.com/hamonikr/hamonize/issues?q=is%3Aissue+milestone%3A%22%EA%B0%9C%EB%B0%A9%ED%98%95OS%EB%B0%8F+%EC%9C%88%EB%8F%84%EC%9A%B0%EA%B8%B0%EB%B0%98%EC%9D%98+Hamonize-Agent%22+)

  
*  Code Style
   * Hamonize-Agent는 NodeJS + Shell Script 사용
    - Linux Coding Style은 해당 [여기]( https://www.kernel.org/doc/html/latest/process/coding-style.html) 를 참조하시기 바랍니다.  
    - Node.Js 는 Prettier Module를 사용
    - 사용방법 :  
      1. npm i -D prettier 
      2. Package.json에 아래 내용 추가 <br><br>
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
