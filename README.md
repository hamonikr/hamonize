

![GitHubLicense](https://img.shields.io/github/license/hamonikr/hamonize)
![GitHub reposize](https://img.shields.io/github/repo-size/hamonikr/hamonize)
![GitHubcontributors](https://img.shields.io/github/contributors/hamonikr/hamonize)
![GitHubstars](https://img.shields.io/github/stars/hamonikr/hamonize?style=social)
![GitHubforks](https://img.shields.io/github/forks/hamonikr/hamonize?style=social)
![GitHubissues](https://img.shields.io/github/issues/hamonikr/hamonize?style=social)
![GitHubwatch](https://img.shields.io/github/watchers/hamonikr/hamonize?style=social)


![GitHubbuild](https://img.shields.io/github/workflow/status/hamonikr/hamonize/Hamonize%20CI)
![GitHubpr](https://img.shields.io/github/issues-pr/hamonikr/hamonize)
![GitHubprclosed](https://img.shields.io/github/issues-pr-closed/hamonikr/hamonize)
![GitHubcommit](https://img.shields.io/github/commit-activity/m/hamonikr/hamonize)
![GitHubDownload](https://img.shields.io/github/downloads/hamonikr/hamonize/total)
![GitHubRelease](https://img.shields.io/github/v/release/hamonikr/hamonize)
![GitHubLastCommit](https://img.shields.io/github/last-commit/hamonikr/hamonize)

  
# ![Hamonize](./img/halogo.png)

<img width="800" src="./img/hamonize.png">

<br>

## 😎 What is Hamonize?

하모나이즈는 개방형 OS 및 윈도우 OS를 사용하는 원격지의 PC들을 통합관리 할 수 있는 솔루션입니다. <br>
하모나이즈 프로젝트는 (1) 하모나이즈 센터  (2) 하모나이즈 에이전트  (3) 하모나이즈 어드민  (4) 하모나이즈 커넥터 등으로 구성되어 있습니다.

<br>

<img width="700" src="./img/Hamonize_architecture.png"> <br>


`하모나이즈 센터`는 크게 세가지의 기능을 갖고 있습니다.  <br>
- 첫번째로 관리자가 원격지의 대상 PC들에게 백업및 복구  프로그램 설치  차단 등의 정책을 내리고 정책이 정상적으로 내려졌는지 수행결과를 볼 수 있습니다.  
- 두번째로 원격지 PC들의 실시간 CPU  memory 등의 사용량을 한눈에 확인하고 자원을 관리할 수 있습니다.
- 세번째로 원격지의 PC에 원격 접속을 하여 문제가 생겼을 경우 즉각적이고 효율적으로 대응을 할 수 있습니다.

`하모나이즈 에이전트`는 별도의 화면 없이 하모나이즈 센터에서 내린 정책을 수행하고 수행결과를 보내는 역할을 합니다.

`하모나이즈 어드민`에서는 하모나이즈 센터에서 원격접속을 할 수 있도록 기능을 제공하고 별도로 하모나이즈 어드민 데스크탑 어플리케이션을 통해서도 연결된 원격지의 PC들의 원격제어  세션관리 전원 관리 등의 기능을 할 수 있습니다.

<br>

📕 자세한 사용법을 알고싶으면 [사용자 매뉴얼](http://pms.invesume.com:8090/pages/viewpage.action?pageId=73339494)를 참고하세요. 

<br>

## 📌 Hamonize 신뢰성

하모나이즈는 외부 공인시험 인증기관을 통해 GS인증 1등급의 소프트웨어 품질인증을 받은 기술로<br>사용자가 신뢰할 수 있는 소프트웨어 품질을 제공합니다.<br><br> [Hamonize official homepage](https://hamonize.github.io/)|  <img src="https://github.com/hamonikr/hamonize/blob/master/img/hamonize_gs.png?raw=true" width="200">
|:---|:---:


## 📌 Hamonize Program OS 지원


| OS 구분             | Description                                                                                  |
| ------------------- | -------------------------------------------------------------------------------------------- |
| HamoniKR OS 4.0 Jin | Hamonize (Connector 프로그램  Agent 프로그램  원격관리프로그램  Usb관리  프로세스관리 ) 가능 |
| Linux Mint 20.2     | Hamonize (Connector 프로그램  Agent 프로그램  원격관리프로그램  Usb관리  프로세스관리 ) 가능 |
| Debian bullseye     | Hamonize (Connector 프로그램  Agent 프로그램  원격관리프로그램  Usb관리  프로세스관리 ) 가능 |
| Ubuntu 20.04        | Hamonize (Connector 프로그램  Agent 프로그램  원격관리프로그램  Usb관리  프로세스관리 ) 가능 |
| Gooroom 2.4         | Hamonize (Connector 프로그램  Agent 프로그램  원격관리프로그램  Usb관리  프로세스관리 ) 가능 |
| Window 10           | Hamonize (Connector 프로그램  원격관리프로그램) 가능                                         |

<br>

## 📌 Hamonize 사용(설치) 방법
> Hamonize Server 구축 방법은 
> Wiki의 [ Hamonize 설치 안내 페이지](https://github.com/hamonikr/hamonize/wiki/%ED%99%98%EA%B2%BD-%EA%B5%AC%EC%B6%95%EA%B3%BC-%EB%B9%8C%EB%93%9C-%EB%B0%8F-%EC%84%A4%EC%B9%98-%EB%B0%A9%EB%B2%95#%EC%84%9C%EB%B2%84-%EA%B5%AC%EC%B6%95)를 참고하시기 바랍니다.

> **Hamonize Manager (관리자 PC)**
> + Hamonize-Center (Web Console)에 접속하여 원격관리대상 PC의 정보 및 정책관리  원격관리를 할 수있습니다. 
> + Hamonize-Admin (원격관리프로그램)으로 원격관리 대상 PC의 원격제어를 할 수 있습니다.
> 1. Download : Hamonize-Admin(원격관리프로그램) [github release](https://github.com/hamonikr/hamonize/releases)에서 OS 환경에 맞는 프로그램을 다운로드 받습니다.
> 2. Install : 다운로드 받은 경로에서 다음 명령어를 실행합니다. `sudo apt install -y hamonize-admin*.deb`
> 3. Config : Hamonize-Admin(원격관리프로그램) 환경 설정 방법은 [해당 링크](https://github.com/hamonikr/hamonize/wiki/%EC%82%AC%EC%9A%A9-%EB%A7%A4%EB%89%B4%EC%96%BC#%ED%95%98%EB%AA%A8%EB%82%98%EC%9D%B4%EC%A6%88-%EC%96%B4%EB%93%9C%EB%AF%BC-%EC%84%A4%EC%A0%95-%EB%B0%A9%EB%B2%95)를 참조하세요.
> 
>   
> **Hamonize Client (원격 관리대상 PC)**
> 1. Download : OS 환경에 맞는 프로그램을 다운로드받습니다.  [Hamonize-Connect Program Download](https://github.com/hamonikr/hamonize/releases)
> 2. Install : 다운로드 받은 경로에서 다음 명령어를 실행합니다. `sudo dpkg -i Hamonize-Connector.deb`
> 3. Run : `Command or Win key > Hamonize Connector `

<br>

## 🎨 Features
* 하모니카OS 뿐만아니라 다양한 개방형OS와 윈도우OS까지 지원
* 하모나이즈 서비스 구동을 위한 필요 서버들을 도커로 구성하여 제공 
* HMACSHA256 키 지정 hash 알고리즘으로 데이터를 암호화해 제공하여 안전한 보안성을 제공

<br>

## 📌 Table of Contents 

- [📦 Packages](#-packages)
- [😎 What is Hamonize?](#-what-is-hamonize)
- [🎨 Features](#-features)
- [🔗 Usecase](#-usecase)
- [🛠 Pull Request Steps](#-pull-request-steps)
- [👍 Contributing](https://github.com/hamonikr/hamonize/blob/master/CONTRIBUTING.md)


- [📜 License](#-license)

<br>

## 📦 Packages


| Name                                                                                | Description                         |
| ----------------------------------------------------------------------------------- | ----------------------------------- |
| [Hamonize-center](https://github.com/hamonikr/hamonize/tree/master/hamonize-center) | Spring boot 기반의 Java 웹 프로그램 |

| Name                                                                              | Description                              |
| --------------------------------------------------------------------------------- | ---------------------------------------- |
| [Hamonize-agent](https://github.com/hamonikr/hamonize/tree/master/hamonize-agent) | Node와 Shell script 기반의 PC관리 프로그램 |

| Name                                                                              | Description                  |
| --------------------------------------------------------------------------------- | ---------------------------- |
| [Hamonize-admin](https://github.com/hamonikr/hamonize/tree/master/hamonize-admin) | C++ 기반의 원격관리 프로그램 |

| Name                                                                                      | Description                                 |
| ----------------------------------------------------------------------------------------- | ------------------------------------------- |
| [Hamonize-connector](https://github.com/hamonikr/hamonize/tree/master/hamonize-connector) | Electron과 Shell script기반의 PC 초기 설정 프로그램 |


<br>


## 🔗 Usecase

`하모나이즈` 솔루션은 국방부에서 사이버지식정보방에 설치되어 40만 국군장병이 PC를 사용하는데 적용되고 있는 솔루션입니다. (12 500대)

<br>
<img width="600" src="./img/hamonize_ex1.png"> <br>


<br>

## 🛠 Pull Request Steps
**Hamonize** 프로젝트에 기여하시려면 아래의 순서대로 개발한 후에 PR(Pull Request)을 보내주세요.

### Setup
먼저  자신의 레파지토리로 `main` 브랜치에서 fork를 해주세요. 그다음에 로컬 컴퓨터 환경에 clone한 다음에 개발을 진행해주세요.

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



* [Code of Conduct](https://github.com/hamonikr/hamonize/blob/master/CODE_OF_CONDUCT.md)
* [Contributing Guideline](https://github.com/hamonikr/hamonize/blob/master/CONTRIBUTING.md)
* [Issue Guidelines](https://github.com/hamonikr/hamonize/blob/master/ISSUE_TEMPLATE.md)
* [Commit Message Template](https://github.com/hamonikr/hamonize/blob/dev/.gitmessage.txt) <br>
  
  ```
  Commit Message 사용법. 
    1. 아래의 방법으로  Commit Message Templeate 설정을 합니다 
    [전역설정] git config --global commit.template <.gitmessage.txt 경로>
    [레포마다다르게 설정] git config commit.template <.gitmessage.txt 경로>
  
    2. 설정이 완료된 후 git commit template 사용방법은 
    git init 
    git add .
    git commit  >> Commit Message Template으로 지정한 형식으로 파일이 열리며 type  body  footer에 맞게 작성하시면됩니다.
    git push 
  ```

<br>

## 📜 License 

하모나이즈는 여러 하위 프로젝트로 구성된 솔루션입니다. 아래 표는 각 하위 프로젝트에 대한 라이선스를 보여줍니다. 
프로젝트별로 사용된 컴포넌트나 라이브러리들 대한 라이선스 공지를 보고 싶다면 각각의 디렉토리에서 NOTICE.md 파일에서 확인할 수 있습니다.

| project                                                                                         | License            | Dependencies License List                                                               |
| ----------------------------------------------------------------------------------------------- | ------------------ | --------------------------------------------------------------------------------------- |
| [hamonize-center](https://github.com/jullee96/hamonize/blob/master/hamonize-center/COPYING)     | Apache License 2.0 | [NOTICE](https://github.com/jullee96/hamonize/blob/master/hamonize-center/NOTICE.md)    |
| [hamonize-agent](https://github.com/jullee96/hamonize/blob/master/hamonize-agent/COPYING)       | Apache License 2.0 | [NOTICE](https://github.com/jullee96/hamonize/blob/master/hamonize-agent/NOTICE.md)     |
| [hamonize-admin](https://github.com/jullee96/hamonize/blob/master/hamonize-admin/COPYING)       | GPL 2.0            | [NOTICE](https://github.com/jullee96/hamonize/blob/master/hamonize-admin/NOTICE.md)     |
| [hamonize-connect](https://github.com/jullee96/hamonize/blob/master/hamonize-connector/COPYING) | Apache License 2.0 | [NOTICE](https://github.com/jullee96/hamonize/blob/master/hamonize-connector/NOTICE.md) |



<br>

## 📜 Governance 
이 프로젝트는 아래의 거버넌스 정책에 따라서 관리되고 있습니다.

* [Governance](https://github.com/hamonikr/hamonize/wiki/Governance)

  



이 프로젝트는 [모든 기여자](https://github.com/all-contributors/all-contributors)들의 의사를 존중하고 어떤 종류의 기여라도 환영합니다!

### Contributors

<table>
<tr>
    <td align="center" style="word-wrap: break-word; width: 150.0; height: 150.0">
        <a href=https://github.com/jullee96>
            <img src=https://avatars.githubusercontent.com/u/66409676?v=4 width="100;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px" alt=julie lee/>
            <br />
            <sub style="font-size:100px"><b>julie lee</b></sub>
        </a>
    </td>
    <td align="center" style="word-wrap: break-word; width: 150.0; height: 150.0">
        <a href=https://github.com/yeji0407>
            <img src=https://avatars.githubusercontent.com/u/55476302?v=4 width="100;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px" alt=yeji0407/>
            <br />
            <sub style="font-size:100px"><b>yeji0407</b></sub>
        </a>
    </td>
    <td align="center" style="word-wrap: break-word; width: 150.0; height: 150.0">
        <a href=https://github.com/gon1942>
            <img src=https://avatars.githubusercontent.com/u/31919227?v=4 width="100;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px" alt=Ryan-K/>
            <br />
            <sub style="font-size:100px"><b>Ryan-K</b></sub>
        </a>
    </td>
    <td align="center" style="word-wrap: break-word; width: 150.0; height: 150.0">
        <a href=https://github.com/igothere>
            <img src=https://avatars.githubusercontent.com/u/51899018?v=4 width="100;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px" alt=Eden/>
            <br />
            <sub style="font-size:100px"><b>Eden</b></sub>
        </a>
    </td>
    <td align="center" style="word-wrap: break-word; width: 150.0; height: 150.0">
        <a href=https://github.com/chaeya>
            <img src=https://avatars.githubusercontent.com/u/405502?v=4 width="100;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px" alt=Kevin Kim/>
            <br />
            <sub style="font-size:100px"><b>Kevin Kim</b></sub>
        </a>
    </td>
    <td align="center" style="word-wrap: break-word; width: 150.0; height: 150.0">
        <a href=https://github.com/1942kg>
            <img src=https://avatars.githubusercontent.com/u/24218451?v=4 width="100;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px" alt=1942kg/>
            <br />
            <sub style="font-size:100px"><b>1942kg</b></sub>
        </a>
    </td>
    <td align="center" style="word-wrap: break-word; width: 150.0; height: 150.0">
        <a href=https://github.com/leemgs>
            <img src=https://avatars.githubusercontent.com/u/82404?v=4 width="100;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px" alt=Geunsik Lim/>
            <br />
            <sub style="font-size:100px"><b>Geunsik Lim</b></sub>
        </a>
    </td>
    <td align="center" style="word-wrap: break-word; width: 150.0; height: 150.0">
        <a href=https://github.com/pichecker>
            <img src=https://avatars.githubusercontent.com/u/93516744?v=4 width="100;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px" alt=pichecker/>
            <br />
            <sub style="font-size:100px"><b>pichecker</b></sub>
        </a>
    </td>
</tr>
<tr>
    <td align="center" style="word-wrap: break-word; width: 150.0; height: 150.0">
        <a href=https://github.com/suyun1017>
            <img src=https://avatars.githubusercontent.com/u/93955272?v=4 width="100;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px" alt=suyun1017/>
            <br />
            <sub style="font-size:100px"><b>suyun1017</b></sub>
        </a>
    </td>
    <td align="center" style="word-wrap: break-word; width: 150.0; height: 150.0">
        <a href=https://github.com/leerosep>
            <img src=https://avatars.githubusercontent.com/u/93893152?v=4 width="100;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px" alt=rosep/>
            <br />
            <sub style="font-size:100px"><b>rosep</b></sub>
        </a>
    </td>
    <td align="center" style="word-wrap: break-word; width: 150.0; height: 150.0">
        <a href=https://github.com/khs7516>
            <img src=https://avatars.githubusercontent.com/u/35002528?v=4 width="100;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px" alt=khs7516/>
            <br />
            <sub style="font-size:100px"><b>khs7516</b></sub>
        </a>
    </td>
    <td align="center" style="word-wrap: break-word; width: 150.0; height: 150.0">
        <a href=https://github.com/yeji980407>
            <img src=https://avatars.githubusercontent.com/u/84702382?v=4 width="100;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px" alt=yeji980407/>
            <br />
            <sub style="font-size:100px"><b>yeji980407</b></sub>
        </a>
    </td>
    <td align="center" style="word-wrap: break-word; width: 150.0; height: 150.0">
        <a href=https://github.com/bdh1993>
            <img src=https://avatars.githubusercontent.com/u/58254473?v=4 width="100;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px" alt=JamesBae/>
            <br />
            <sub style="font-size:100px"><b>JamesBae</b></sub>
        </a>
    </td>
    <td align="center" style="word-wrap: break-word; width: 150.0; height: 150.0">
        <a href=https://github.com/hjoon0510>
            <img src=https://avatars.githubusercontent.com/u/34376749?v=4 width="100;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px" alt=Lim Hyunjoon/>
            <br />
            <sub style="font-size:100px"><b>Lim Hyunjoon</b></sub>
        </a>
    </td>
    <td align="center" style="word-wrap: break-word; width: 150.0; height: 150.0">
        <a href=https://github.com/choonsik2>
            <img src=https://avatars.githubusercontent.com/u/62954933?v=4 width="100;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px" alt=choonsik/>
            <br />
            <sub style="font-size:100px"><b>choonsik</b></sub>
        </a>
    </td>
    <td align="center" style="word-wrap: break-word; width: 150.0; height: 150.0">
        <a href=https://github.com/bigmoment>
            <img src=https://avatars.githubusercontent.com/u/25470869?v=4 width="100;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px" alt=saam3/>
            <br />
            <sub style="font-size:100px"><b>saam3</b></sub>
        </a>
    </td>
</tr>
</table>


<br>

## :arrow_forward: 영상으로 보는 하모나이즈 

### 소개영상

<a href="https://www.youtube.com/watch?v=N2zPF77NNec" target="_blank">
 <img src="https://img.youtube.com/vi/N2zPF77NNec/0.jpg" alt="Watch the video" width="" height="" border="10" />
</a>

<br><br>

### 실행방법

#### 하모나이즈 센터 및 기타 서버들

<a href="https://www.youtube.com/watch?v=bohd6Jjwmm4" target="_blank">
 <img src="https://img.youtube.com/vi/bohd6Jjwmm4/0.jpg" alt="Watch the video" width="" height="" border="10" />
</a>



#### 하모나이즈 커넥터 및 하모나이즈 에이전트

<a href="https://www.youtube.com/watch?v=YwDurh6wQz0" target="_blank">
 <img src="https://img.youtube.com/vi/YwDurh6wQz0/0.jpg" alt="Watch the video" width="" height="" border="10" />

