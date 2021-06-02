# hamonize-admin

![hamonize-admin](https://img.shields.io/badge/hamonikr-v4.2.67-blue)
![license](https://img.shields.io/badge/license-GPLv2-green.svg)


## Hamonize-admin?

하모나이즈 어드민은 사지방 PC들을 관리하기 위한 원격 지원 및 모니터링을 할 수 있는 솔루션입니다.

## License

Copyright (c) 2004-2021 Invesume Inc / Tobias Junghans / Veyon Solutions

See the file COPYING for the GNU GENERAL PUBLIC LICENSE.

## Usage




## BUILD

### First, Download source

먼저 깃 저장소를 복제하고 모든 서브모듈을 가져와야 합니다.

```
git clone --recursive https://github.com/hamonikr/hamonize.git
cd hamonize/hamonize-admin

or

git clone https://github.com/hamonikr/hamonize.git
cd hamonize
git submodule init
git submodule update
```


### Installing dependencies

데비안 기반의 빌드 환경에 필요한 의존성입니다:
- Build tools: g++ make cmake
- Qt5: qtbase5-dev qtbase5-dev-tools qttools5-dev qttools5-dev-tools
- X11: xorg-dev libxtst-dev
- libjpeg: libjpeg-dev provided by libjpeg-turbo8-dev or libjpeg62-turbo-dev
- zlib: zlib1g-dev
- OpenSSL: libssl-dev
- PAM: libpam0g-dev
- procps: libprocps-dev
- LZO: liblzo2-dev
- QCA: libqca2-dev or libqca-qt5-2-dev
- LDAP: libldap2-dev
- SASL: libsasl2-dev

root 에서 실행해주세요
```
apt install g++ make cmake qtbase5-dev qtbase5-dev-tools qttools5-dev qttools5-dev-tools libqca-qt5-2-plugins xorg-dev libxtst-dev libjpeg-dev zlib1g-dev libssl-dev libpam0g-dev libprocps-dev liblzo2-dev libqca-qt5-2-dev libldap2-dev libsasl2-dev
```

### Configuring and building sources for Linux

다음 커맨드에 따라 실행해주세요
```
mkdir build
cd build
cmake ..
make -j4
```

참고: 제공된 cmake 방식 대신 데비안(.deb) 패키지를 생성하려면 다음을 사용해야 합니다.
```
cmake -DCMAKE_INSTALL_PREFIX=/usr ..
```
/usr/local이 아닌 /usr에 패키지 파일을 설치합니다.

일부 요구 사항이 충족되지 않으면 CMAKE에서 이를 알려고주고 계속하기 전에 누락된 소프트웨어를 설치해야 합니다.

이제 현재 시스템에 따라 패키지를 생성할 수 있습니다.

패키지를 생성하기 위해서는 다음을 실행해주세요.
```
fakeroot make package
```

그러면 hamonize_x.y.z_amd64.deb 패키지를 얻을 수 있습니다.

패키지를 설치하기 위해서는 다음을 실행해주세요.
```
sudo dpkg -i hamonize_x.y.z_amd64.deb
```

데몬을 다시 실행해 주세요.
```
sudo systemctl daemon-reload
```

또는 빌드된 바이너리를 직접 설치할 수 있습니다.(권장하지 않습니다.)
바이너리로 설치하려면 다음을 실행해주세요.
```
make install
```

### Debugging

참고: 제공된 cmake 명령 대신 이 소프트웨어를 개발하기 위한 디버깅 모드를 구축하려면 다음을 사용해야 합니다.  
디버깅 모드를 구축합니다.
```
cmake -DCMAKE_BUILD_TYPE=Debug <path and other arguments>
```

## More information

* https://github.com/hamonikr/hamonize
* https://hamonikr.org
* https://veyon.io/