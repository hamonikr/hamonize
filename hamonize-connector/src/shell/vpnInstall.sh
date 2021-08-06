#!/bin/bash
if [ ! -d /var/log/hamonize/ ]; then
    mkdir /var/log/hamonize/ >/dev/null 2>&1
fi

if [ ! -d /var/log/hamonize/vpnlog ]; then
    mkdir /var/log/hamonize/vpnlog >/dev/null 2>&1
    touch /var/log/hamonize/vpnlog.hm 
fi

WORK_PATH=$(dirname $(realpath $0))
echo $WORK_PATH



DATETIME=`date +'%Y-%m-%d %H:%M:%S'`
MACHIDTMP=`cat /etc/hamonize/uuid |head -1`
Log_output="/var/log/hamonize/vpnlog/vpnlog.hm"
touch $Log_output
cat  /dev/null > $Log_output 


vpnwork(){
	#//===========================
	# VPN Value
	VPNSCRIPTPATH="/etc/hamonize"
	VPNSCRIPT=$VPNSCRIPTPATH"/vpn-auto-connection.sh"
	VPNPATH="/tmp/penclient"
	PROTOCOL="udp"
	SERVER1="<VPN Server IP>"
	SERVERPORT="<VPN Server Port>"

	OVPNTARPATH="./gcloudvpn/openvpn.tar"
	OVPNPATH="./gcloudvpn/openvpn"
	CLIENT="nclt-$MACHIDTMP"
	VPNIP=""

	#device info make Json
	SERVER_API=$HIZCENTERURL
	DATETIME=`date +'%Y-%m-%d %H:%M:%S'`
	UUID=`cat /etc/hamonize/uuid |head -1`
	CPUID=`dmidecode -t 4|grep ID`
	CPUINFO=`cat /proc/cpuinfo | grep "model name" | head -1 | cut  -d" " -f3- | sed "s/^ *//g"`
	IPADDR=`ifconfig | awk '/inet .*broadcast/'|awk '{print $2}'`
	MACADDR=`ifconfig | awk '/ether/'|awk '{print $2}'`
	HOSTNAME=`hostname`
	MEMORY=`awk '{ printf "%.2f", $2/1024/1024 ; exit}' /proc/meminfo`
	HDDTMP=`fdisk -l | head -1 | awk '{print $2}'| awk -F':' '{print $1}'`
	HDDID=`hdparm -I $HDDTMP  | grep 'Serial\ Number' |awk -F ':' '{print $2}'`
	HDDINFO=`hdparm -I $HDDTMP  | grep 'Model\ Number' |awk -F ':' '{print $2}'`

	#### vpn key create & connection ####
	
	
	# 입력값을 사용하는 경우 아래 주석 제거 및 위의 CLIENT 변수 주석처리
	#read -p "Client name: " -e CLIENT
	
	
	# 폴더 확인
	if [ ! -d $VPNPATH ]; then
	        mkdir $VPNPATH
	fi
	
	
	# openvpn 폴더 복사
	sudo tar xvf ${WORK_PATH}/${OVPNTARPATH} -C $VPNPATH  >> $Log_output
	echo "aaaaaaaa================$VPNPATH"
	echo "bvbbbbbbbbbbb================$OVPNPATH"
	
	echo "$(pwd)/vpn-connecter.service"
	sudo cp $WORK_PATH/vpn-connecter.service  /tmp
	sudo cp $WORK_PATH/vpn-auto-connection.sh  /tmp


	sleep 1

	# client-common.txt 파일 생성
	echo "client
	dev tun
	proto $PROTOCOL
	ndbuf 393216
	rcvbuf 393216
	remote $SERVER1 $SERVERPORT
	remote-random
	resolv-retry infinite
	nobind
	user nobody
	group nogroup
	persist-key
	persist-tun
	remote-cert-tls server
	# cipher AES-256-CBC
	cipher AES-128-CBC
	auth SHA512
	key-direction 1
	verb 3" > $VPNPATH/openvpn/client-common.txt
	
	echo "$DATETIME] open vpn client-commont.txt create file" >> $Log_output

	# easyrsa 코드가 상대경로로 인식
	cd $VPNPATH/openvpn/easy-rsa/
	
	# client serial crt key req 파일 생성 및 index.txt에 정보 등록
	EASYRSA_CERT_EXPIRE=3650 ./easyrsa build-client-full $CLIENT nopass > /dev/null 2>&1

	if [ ! -d /etc/hamonize/ovpnclient ]; then
		sudo mkdir /etc/hamonize/ovpnclient
	fi


	# ovpn 파일 생성
	cp $VPNPATH/openvpn/client-common.txt /etc/hamonize/ovpnclient/$CLIENT.ovpn
	echo "<ca>" >> /etc/hamonize/ovpnclient/$CLIENT.ovpn
	cat $VPNPATH/openvpn/easy-rsa/pki/ca.crt >> /etc/hamonize/ovpnclient/$CLIENT.ovpn
	echo "</ca>" >> /etc/hamonize/ovpnclient/$CLIENT.ovpn
	echo "<cert>" >> /etc/hamonize/ovpnclient/$CLIENT.ovpn
	sed -ne '/BEGIN CERTIFICATE/,$ p' $VPNPATH/openvpn/easy-rsa/pki/issued/$CLIENT.crt >> /etc/hamonize/ovpnclient/$CLIENT.ovpn
	echo "</cert>" >> /etc/hamonize/ovpnclient/$CLIENT.ovpn
	echo "<key>" >> /etc/hamonize/ovpnclient/$CLIENT.ovpn
	cat $VPNPATH/openvpn/easy-rsa/pki/private/$CLIENT.key >> /etc/hamonize/ovpnclient/$CLIENT.ovpn
	echo "</key>" >> /etc/hamonize/ovpnclient/$CLIENT.ovpn
	echo "<tls-auth>" >> /etc/hamonize/ovpnclient/$CLIENT.ovpn
	sed -ne '/BEGIN OpenVPN Static key/,$ p' $VPNPATH/openvpn/ta.key >> /etc/hamonize/ovpnclient/$CLIENT.ovpn
	echo "</tls-auth>" >> /etc/hamonize/ovpnclient/$CLIENT.ovpn
	
	# 복사한 openvpn 디렉토리 삭제
	cd /
	rm -r $VPNPATH/openvpn
	cd $WORKPATH
	

	# ovpn import
	nmcli connection import type openvpn file /etc/hamonize/ovpnclient/$CLIENT.ovpn >>$Log_output  
	
	echo "$DATETIME]  nmcil import vpn key">>$Log_output

	# network setting
	nmcli connection modify $CLIENT ipv4.never-default true >>$Log_output 

	# connection vpn server
	nmcli connection up $CLIENT >>$Log_output 
	

	# vpn auto connection
	echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

	cp /tmp/vpn-connecter.service /lib/systemd/system/
	cp /tmp/vpn-auto-connection.sh $VPNSCRIPTPATH
	
	sed -i "s|vpn-client-key|$VPNSCRIPT|" /lib/systemd/system/vpn-connecter.service
	sed -i "s|vpn-client-key|$CLIENT|" $VPNSCRIPTPATH/vpn-auto-connection.sh

	systemctl daemon-reload >>$Log_output 
	systemctl enable vpn-connecter >>$Log_output 
	systemctl start vpn-connecter >>$Log_output

	echo "$DATETIME]  end vpn con" >> $Log_output
	route -n >>$Log_output	


	if [ `nmcli c | grep "nclt*" | awk '{print $4}'` = '--' ];
	then
			vpn="FAIL"
	else
			vpn="SUCCESS"
	fi

	echo "$DATETIME]  vpn isSuccess => $vpn"  >> $Log_output
	
	VPNIPADDR=`ifconfig | awk '/inet .*destination/'|awk '{print $2}'`
	echo "$DATETIME]  vpn ip addr is ==$VPNIPADDR" >>$Log_output

	echo $vpn

}




vpn_create(){

	vpnclientchk=$(ls /etc/hamonize/ovpnclient/ | grep -c nclt*) >> $Log_output
	echo "---$vpnclientchk" >>$Log_output

	if [ "$vpnclientchk" -eq 1 ]; then
        	echo "file exit" >>$Log_output

		vpnkeynm=`ls /etc/hamonize/ovpnclient | grep nclt* | awk -F'.' '{print $1}'`
		nmcli con down $vpnkeynm >>$Log_output
        nmcli con delete $vpnkeynm >> $Log_output
		vpnwork
	
	else
        	echo "file not exitst" >>$Log_output
		vpnwork
	fi


}


vpn_create
