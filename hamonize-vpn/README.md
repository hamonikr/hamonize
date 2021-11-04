# OpenVPN 서버 구축하기

[OpenVPN](https://github.com/OpenVPN) 서버는 하모나이즈 시스템에서 각각의 서버와 클라이언트들이 통신하기위해 사용되는 가상사설망입니다. 
<br><br>


1. ./openvpn/config/client.conf 파일 수정

   {your-own-vpn-server-ip} 를 자신의 VPN 서버 IP 로 설정해주세요

    ```
    ...

    remote {your-own-vpn-server-ip} 1194

    ...
    ```


2. 아래 명령어를 통해 VPN 서버를 실행합니다.
    ```
    docker-compose up
    ```

3. 아래 링크에서 VPN 서버를 모니터링 할 수 있습니다.

    ```
    http://{your-own-vpn-server-ip}:3000
    ```
<br>

# VPN 연결하기
아래 방법을 통해 하모나이즈 서버군을 VPN에 연결합니다.

1. 클라이언트 생성하기

   아래 링크를 통해 클라이언트를 생성할 수 있습니다.

   {key-name} 은 생성할 클라이언트 키 파일의 이름으로 대체합니다.

    ```
    http://{your-own-vpn-server-ip}:3000/getclients/hmon_vpn_vpn/{key-name}
    ```

2. 클라이언트 키파일 다운로드

   아래 명령어를 통해 생성한 클라이언트의 키파일을 다운로드 합니다.

    ```
    wget -O {key-name}.ovpn http://{your-own-vpn-server-ip}:3000/getclientsdownload/{key-name}
    ```

3. VPN 연결

   VPN에 연결하고자 하는 서버에서 아래 명령을 수행합니다.

    ```
    nmcli connection import type openvpn file {key-name}.ovpn
    
    nmcli connection up {key-name}
    ```
