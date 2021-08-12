# Hamonize OpenVPN Server
# build and run by 'docker build -t hamonize_vpn . && docker run --name openvpn --privileged -d -p 1194:1194/udp -v openvpn-data:/etc/openvpn hamonize_vpn && docker exec -it openvpn sh /openvpn-set.sh'
FROM hamonikr/server:2.0
LABEL email="root@hamonikr.org"

COPY ./openvpn-install.sh /openvpn-install.sh
COPY ./openvpn-set.sh /openvpn-set.sh

RUN apt update && apt install -y iproute2 expect\
     && cd /dev && mkdir net && mknod net/tun c 10 200 && chmod 0666 net/tun && cd ..
