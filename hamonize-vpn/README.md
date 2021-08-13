# OpenVPN 서버 구축하기

vpn서버는 하모나이즈 시스템에서 각각의 서버와 클라이언트들이 통신하는데 사용되는 가상사설망입니다. 
<br><br>


1. ./openvpn/config/client.conf 파일 수정
    ```
    client.conf 파일의 "remote 192.168.0.146 1194" 에 "192.168.0.146" 을 VPN 서버 IP 로 수정합니다.
    ```
<br>

2. 아래 명령어를 통해 vpn 서버를 실행합니다.
    ```
    docker-compose up
    ```
