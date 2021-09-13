# ![Hamonize](./img/halogo.png)

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

### :house: [Hamonize official homepage](https://hamonize.github.io/)

<img width="800" src="./img/hamonize.png">



<br>

## 📌 Table of Contents 
- [📦 Packages](#-packages)
- [😎 What is Hamonize?](#-what-is-hamonize)
- [🎨 Features](#-features)
- [🔗 Usecase](#-usecase)
- [🛠 Pull Request Steps](#-pull-request-steps)
- [👍 Contributing](#-contributing)
- [📜 License](#-license)

<br>

## 📦 Packages


| Name                                                                                | Description                         |
| ----------------------------------------------------------------------------------- | ----------------------------------- |
| [Hamonize-center](https://github.com/hamonikr/hamonize/tree/master/hamonize-center) | spring boot 기반의 java 웹 프로그램 |

| Name                                                                              | Description                              |
| --------------------------------------------------------------------------------- | ---------------------------------------- |
| [Hamonize-agent](https://github.com/hamonikr/hamonize/tree/master/hamonize-agent) | node+shell script 기반의 pc관리 프로그램 |

| Name                                                                              | Description                  |
| --------------------------------------------------------------------------------- | ---------------------------- |
| [Hamonize-admin](https://github.com/hamonikr/hamonize/tree/master/hamonize-admin) | c++ 기반의 원격관리 프로그램 |

| Name                                                                                      | Description                                 |
| ----------------------------------------------------------------------------------------- | ------------------------------------------- |
| [Hamonize-connector](https://github.com/hamonikr/hamonize/tree/master/hamonize-connector) | electron+shell 기반의 pc 초기 설정 프로그램 |


<br>

## 😎 What is Hamonize?

하모나이즈는 개방형 OS 및 윈도우 OS를 사용하는 원격지의 PC들을 통합관리 할 수 있는 솔루션입니다. <br>
하모나이즈 프로젝트는 크게 하모나이즈 센터, 하모나이즈 에이전트, 하모나이즈 어드민으로 이루어져 있습니다.

<br>

<img width="700" src="./img/Hamonize_architecture.png"> <br>


`하모나이즈 센터`는 크게 세가지의 기능을 갖고있습니다.  <br>
- 첫번째로 관리자가 원격지의 대상 PC들에게 백업및 복구, 프로그램 설치, 차단 등의 정책을 내리고 정책이 정상적으로 내려졌는지 수행결과를 볼 수 있습니다  
- 두번째로 원격지 PC들의 실시간 cpu, memory 등의 사용량을 한눈에 확인하고 자원을 관리할 수 있습니다.
- 세번째로 원격지의 PC에 원격 접속을 하여 문제가 생겼을 경우 즉각적이고 효율적으로 대응을 할 수 있습니다.

`하모나이즈 에이전트`는 별도의 화면 없이 하모나이즈 센터에서 내린 정책을 수행하고 수행결과를 보내는 역할을 합니다.

`하모나이즈 어드민`에서는 하모나이즈 센터에서 원격접속을 할 수 있도록 기능을 제공하고 별도로 하모나이즈 어드민 데스크탑 어플리케이션을 통해서도 연결된 원격지의 PC들의 원격제어, 세션관리,전원 관리 등의 기능을 할  수 있습니다.

<br>

📕 자세한 사용법을 알고싶으면 [사용자 매뉴얼](http://pms.invesume.com:8090/pages/viewpage.action?pageId=73339494)를 참고하세요 

<br>

## 🎨 Features
* 하모니카OS 뿐만아니라 다양한 개방형OS와 윈도우OS까지 지원
* 하모나이즈 서비스 구동을 위한 필요 서버들을 도커로 구성하여 제공 
* HMACSHA256 키 지정 hash 알고리즘으로 데이터를 암호화해 제공하여 안전한 보안성을 제공

<br>

## 🔗 Usecase

`하모나이즈` 솔루션은 국방부에서 사이버지식정보방에 설치되어 40만 국군장병이 PC를 사용하는데 적용되고 있는 솔루션입니다. (12,500대)

<br>
<img width="600" src="./img/hamonize_ex1.png"> <br>


<br>

## 🛠 Pull Request Steps
**Hamonize** 프로젝트에 기여하시려면 아래의 순서대로 개발한 후에 PR(Pull Request)을 보내주세요.

### Setup
먼저, 자신의 레파지토리로 `main` 브랜치에서 fork를 해주세요. 그다음에 로컬 컴퓨터 환경에 clone한 다음에 개발을 진행해주세요.

```
git clone git@github.com:{your-own-repo}/hamonize.git
```
`하모나이즈`는 여러개의 서브 프로젝트로 이루어진 솔루션입니다. 

각 프로젝트별 빌드 방법은 각 프로젝트 폴더안의 안내문(README.md)를 참고해주세요.

`hamonize` <br>
│ <br> 
├── [hamonize-admin](https://github.com/hamonikr/hamonize/tree/master/hamonize-admin) <br>
├── [hamonize-agent](https://github.com/hamonikr/hamonize/tree/master/hamonize-agent) <br>
├── [hamonize-center](https://github.com/hamonikr/hamonize/tree/master/hamonize-center) <br>
├── [hamonize-connector](https://github.com/hamonikr/hamonize/tree/master/hamonize-connector) <br>
├── [hamonize-noti-App](https://github.com/hamonikr/hamonize/tree/master/hamonize-noti-App) <br>
└── [hamonize-vpn](https://github.com/hamonikr/hamonize/tree/master/hamonize-vpn)

<br>


### Pull Request
PR을 생성하기 전에 error가 있는지 확인을 해주세요. error가 없다면 commit하고 push해주세요.
더 많은 정보를 원하시면 **Contributing** 문서들을 참고해주세요

<br>

## 👍 Contributing 
* [Code of Conduct](https://github.com/hamonikr/hamonize/blob/master/CODE_OF_CONDUCT.md)
* [Contributing Guideline](https://github.com/hamonikr/hamonize/blob/master/CONTRIBUTING.md)
* [Issue Guidelines](https://github.com/hamonikr/hamonize/blob/master/ISSUE_TEMPLATE.md)

* **Contributers** ✨
  
  
    하모나이즈 프로젝트에 참여해주신 멋진 분들입니다 

    <table>
      <tr>
        <td align="center"><a href="https://github.com/yeji0407"><img src="https://avatars.githubusercontent.com/u/55476302?v=4?s=100" width="100px;" alt=""/><br /><sub><b>yeji0407</b></sub></a><br /><a href="https://github.com/hamonikr/hamonize/commits?author=yeji0407" title="Code">💻</a></td>
        <td align="center"><a href="https://hamonikr.org"><img src="https://avatars.githubusercontent.com/u/405502?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Kevin Kim</b></sub></a><br /><a href="https://github.com/hamonikr/hamonize/commits?author=chaeya" title="Code">💻</a></td>
        <td align="center"><a href="https://github.com/jullee96"><img src="https://avatars.githubusercontent.com/u/66409676?v=4?s=100" width="100px;" alt=""/><br /><sub><b>julie lee</b></sub></a><br /><a href="https://github.com/hamonikr/hamonize/commits?author=jullee96" title="Code">💻</a></td>
        <td align="center"><a href="https://github.com/bdh1993"><img src="https://avatars.githubusercontent.com/u/58254473?v=4?s=100" width="100px;" alt=""/><br /><sub><b>JamesBae</b></sub></a><br /><a href="https://github.com/hamonikr/hamonize/commits?author=bdh1993" title="Code">💻</a></td>
        <td align="center"><a href="https://github.com/choonsik2"><img src="https://avatars.githubusercontent.com/u/62954933?v=4?s=100" width="100px;" alt=""/><br /><sub><b>choonsik</b></sub></a><br /><a href="https://github.com/hamonikr/hamonize/commits?author=choonsik2" title="Code">💻</a></td>
        <td align="center"><a href="https://github.com/gon1942"><img src="https://avatars.githubusercontent.com/u/31919227?v=4?s=100" width="100px;" alt=""/><br /><sub><b>ryan</b></sub></a><br /><a href="https://github.com/hamonikr/hamonize/commits?author=gon1942" title="Code">💻</a></td>
        <td align="center"><a href="https://github.com/bigeden"><img src="https://avatars.githubusercontent.com/u/51899018?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Eden</b></sub></a><br /><a href="https://github.com/hamonikr/hamonize/commits?author=bigeden" title="Code">💻</a></td>
      </tr>
    </table>

    이 프로젝트는 [모든 기여자](https://github.com/all-contributors/all-contributors)들의 
    의사를 존중하고 어떤 종류의 기여라도 환영합니다!

<br>

## 📜 License 

하모나이즈는 여러 하위 프로젝트로 구성된 솔루션입니다. 아래 표는 각 하위 프로젝트에 대한 라이선스를 보여줍니다. 
프로젝트별로 사용된 컴포넌트나 라이브러리들 대한 라이선스 공지를 보고 싶다면 각각의 디렉토리에서 NOTICE.md 파일에서 확인할 수 있습니다.

| project                                                                                         | License            | Dependencies License List                                                               |
| ----------------------------------------------------------------------------------------------- | ------------------ | --------------------------------------------------------------------------------------- |
| [hamonize-center](https://github.com/jullee96/hamonize/blob/master/hamonize-center/COPYING)     | Apache License 2.0 | [NOTICE](https://github.com/jullee96/hamonize/blob/master/hamonize-center/NOTICE.md)    |
| [hamonize-agent](https://github.com/jullee96/hamonize/blob/master/hamonize-agent/COPYING)       | Apache License 2.0 | [NOTICE](https://github.com/jullee96/hamonize/blob/master/hamonize-agent/NOTICE.md)     |
| [hamonize-admin](https://github.com/jullee96/hamonize/blob/master/hamonize-admin/COPYING)       | GPL 2.0             | [NOTICE](https://github.com/jullee96/hamonize/blob/master/hamonize-admin/NOTICE.md)     |
| [hamonize-connect](https://github.com/jullee96/hamonize/blob/master/hamonize-connector/COPYING) | Apache License 2.0 | [NOTICE](https://github.com/jullee96/hamonize/blob/master/hamonize-connector/NOTICE.md) |



<br>

## 📜 Governance 
이 프로젝트는 아래의 거버넌스 정책에 따라서 관리되고 있습니다.

* [Governance](https://github.com/hamonikr/hamonize/wiki/Governance)





