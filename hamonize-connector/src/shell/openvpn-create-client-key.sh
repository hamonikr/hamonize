#!/bin/bash
# 
# 2021.07.02
# INVESUME youngeun lee

USER=`users`
path="/home/${USER}"
PROTOCOL="udp"
IP="106.254.251.74"
PORT="21194"


ovpnpath="./4-ivs-server/openvpn"
client="pc-client111111"


# 입력값을 사용하는 경우 아래 주석 제거 및 위의 client 변수 주석처리
#read -p "Client name: " -e client


# 폴더 확인
if [ ! -d $path ]; then
	mkdir $path
fi


# openvpn 폴더 복사
cp -r $ovpnpath $path

# client-common.txt 파일 생성
echo "client
dev tun
proto $PROTOCOL
sndbuf 0
rcvbuf 0
remote $IP $PORT
resolv-retry infinite
nobind
persist-key
persist-tun
remote-cert-tls server
auth SHA512
cipher AES-256-CBC
#setenv opt block-outside-dns
key-direction 1
verb 3" > $path/openvpn/client-common.txt

# easyrsa 코드가 상대경로로 인식
cd $path/openvpn/easy-rsa/

# client serial crt key req 파일 생성 및 index.txt에 정보 등록
EASYRSA_CERT_EXPIRE=3650 ./easyrsa build-client-full $client nopass


# ovpn 파일 생성
cp $path/openvpn/client-common.txt ~/$client.ovpn
echo "<ca>" >> ~/$client.ovpn
cat $path/openvpn/easy-rsa/pki/ca.crt >> ~/$client.ovpn
echo "</ca>" >> ~/$client.ovpn
echo "<cert>" >> ~/$client.ovpn
sed -ne '/BEGIN CERTIFICATE/,$ p' $path/openvpn/easy-rsa/pki/issued/$client.crt >> ~/$client.ovpn
echo "</cert>" >> ~/$client.ovpn
echo "<key>" >> ~/$client.ovpn
cat $path/openvpn/easy-rsa/pki/private/$client.key >> ~/$client.ovpn
echo "</key>" >> ~/$client.ovpn
echo "<tls-auth>" >> ~/$client.ovpn
sed -ne '/BEGIN OpenVPN Static key/,$ p' $path/openvpn/ta.key >> ~/$client.ovpn
echo "</tls-auth>" >> ~/$client.ovpn


# 복사한 openvpn 디렉토리 삭제
rm -r $path/openvpn


# ovpn import
nmcli connection import type openvpn file ~/$client.ovpn

# connection vpn server
nmcli connection up $client

