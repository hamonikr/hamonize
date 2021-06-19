# HAMONIZE

![GitHub
License](https://img.shields.io/github/license/hamonikr/hamonize)
![GitHub repo
size](https://img.shields.io/github/repo-size/hamonikr/hamonize)

![GitHub
contributors](https://img.shields.io/github/contributors/hamonikr/hamonize)
![GitHub
stars](https://img.shields.io/github/stars/hamonikr/hamonize?style=social)
![GitHub
forks](https://img.shields.io/github/forks/hamonikr/hamonize?style=social)
![GitHub
issues](https://img.shields.io/github/issues/hamonikr/hamonize?style=social)

## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://github.com/yeji0407"><img src="https://avatars.githubusercontent.com/u/55476302?v=4?s=100" width="100px;" alt=""/><br /><sub><b>yeji0407</b></sub></a><br /><a href="https://github.com/hamonikr/hamonize/commits?author=yeji0407" title="Code">💻</a></td>
    <td align="center"><a href="https://hamonikr.org"><img src="https://avatars.githubusercontent.com/u/405502?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Kevin Kim</b></sub></a><br /><a href="https://github.com/hamonikr/hamonize/commits?author=chaeya" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/jullee96"><img src="https://avatars.githubusercontent.com/u/66409676?v=4?s=100" width="100px;" alt=""/><br /><sub><b>julie lee</b></sub></a><br /><a href="https://github.com/hamonikr/hamonize/commits?author=jullee96" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/bdh1993"><img src="https://avatars.githubusercontent.com/u/58254473?v=4?s=100" width="100px;" alt=""/><br /><sub><b>JamesBae</b></sub></a><br /><a href="https://github.com/hamonikr/hamonize/commits?author=bdh1993" title="Code">💻</a></td>
  </tr>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!


## 개요
하모나이즈는 하모니카PC를 사용하는 조직에서 전사적 관리를 필요로 하는 경우를 지원하기 위한 솔루션입니다.

조직 내 전체 하모니카 사용자에 대한 자산 관리, 보안 관리, 사용자 관리, 활동 감사, 원격 제어 등을 수행할 수 있습니다.

하모나이즈는 인텔 AMT 기술을 이용하여 현장의 방문없이 원격에서 운영체제의 재설치가 가능하며, PC가 꺼진 상태에서도 원격접속 기능을 제공합니다.

모든 데이터는 AES-256-CBC(256Bit) 블록모드 암호화 알고리즘으로 암호화된 데이터를 Split Tunneling 로 제공하여 안전한 보안성을 제공합니다.

## 주요기능
### CENTER 
 자산관리, 사용자관리, 모니터링, 보안관리, 백업 및 복구, 로그감사, 매체제어, 통계 및 보고서, 업데이트 관리, 프로그램 관리
### ADMIN
 하드웨어 감사, 원격파일전송, 세션잠금 관리, 원격전원관리, 모니터링, 스크린 브로드캐스팅, 원격프로그램 실행, 원격화면캡쳐, 실시간 메시지 전송, 디렉토리서비스 연동, 바이오스 제어, 원격운영체제 설치, 원격 시리얼 콘솔, 원격데스크톱, 스케쥴 부팅
### AGENT
하드웨어 변경 감사, 사용자 로그전송, 주요 프로그램 보호, 보안정책 구현, 매체제어 관리

### 아키텍처

![architecture](./img/Hamonize_architecture.png)

## 라이선스
* [hamonize-agent 라이선스 문서](https://github.com/hamonikr/hamonize/blob/master/hamonize-agent/NOTICE.md)

* [hamonize-admin 라이선스 문서](https://github.com/hamonikr/hamonize/blob/master/hamonize-admin/COPYING)
