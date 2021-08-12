# OpenVPN 서버 구축하기

1. 아래 명령어를 통해 openvpn-install.sh, openvpn-set.sh, Dockerfile 파일을 내려 받습니다.
```
 wget https://raw.githubusercontent.com/hamonikr/hamonize/master/hamonize-server/vpn/openvpn-install.sh && wget https://raw.githubusercontent.com/hamonikr/hamonize/master/hamonize-server/vpn/openvpn-set.sh && wget https://raw.githubusercontent.com/hamonikr/hamonize/master/hamonize-server/vpn/Dockerfile
```

2. 같은 경로에서 아래 명령어를 입력해 openvpn 서버 컨테이너를 생성 및 실행합니다.
```
 docker build -t hamonize_vpn . && docker run --name openvpn --privileged -d -p 1194:1194/udp -v openvpn-data:/etc/openvpn hamonize_vpn && docker exec -it openvpn sh /openvpn-set.sh
```
