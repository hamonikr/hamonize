#!/bin/bash

. /etc/hamonize/propertiesJob/propertiesInfo.hm


if [ ! -d /var/log/hamonize/ ]; then
    mkdir /var/log/hamonize/ >/dev/null 2>&1
fi

if [ ! -d /var/log/hamonize/vpnlog ]; then
    mkdir /var/log/hamonize/vpnlog >/dev/null 2>&1
    touch /var/log/hamonize/vpnlog.hm 
fi

if [ ! -d /etc/hamonize/ovpnclient ]; then
 	sudo mkdir /etc/hamonize/ovpnclient
fi

WORK_PATH=$(dirname $(realpath $0))
echo $WORK_PATH


DATETIME=`date +'%Y-%m-%d %H:%M:%S'`
MACHIDTMP=`cat /etc/hamonize/uuid |head -1`
CLIENT="hm-$MACHIDTMP"
Log_output="/var/log/hamonize/vpnlog/vpnlog.hm"
touch $Log_output
cat  /dev/null > $Log_output 
INFOHM="/etc/hamonize/propertiesJob/propertiesInfo.hm"
VPNIP=`cat $INFOHM | grep VPNIP | awk -F '=' '{print $2}'`

vpnwork(){
	
	#//===========================
	# VPN Value
	VPNSCRIPTPATH="/etc/hamonize"
	VPNSCRIPT=$VPNSCRIPTPATH"/vpn-auto-connection.sh"

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

	## vpn key 생성
	VPN_KEY_CREATE=`curl http://$VPNIP/getClients/hmon_vpn_vpn/$CLIENT`
	RET_VPNKEY=$VPN_KEY_CREATE | grep -o "SUCCESS" | wc -l

	wget_key=$( wget -O "/etc/hamonize/ovpnclient/$CLIENT.ovpn" --server-response -c "http://$VPNIP/getClientsDownload/$CLIENT" 2>&1 )
  	exit_status=$?
  	wget_status=$( awk '/HTTP\//{ print $2 }' <<< $wget_key | tail -n 1 )
  	# echo $wget_status
	  
	if test "$wget_status" != "200"; then
		echo  "ERROR-1994 --- $wget_status"
		exit 1
	else 
		echo "bbbbbbb--- $wget_status"

		# openvpn import
		nmcli connection import type openvpn file /etc/hamonize/ovpnclient/$CLIENT.ovpn #>>$Log_output  
		
		echo "$DATETIME]  nmcil import vpn key" #>>$Log_output

		# network setting
		nmcli connection modify $CLIENT ipv4.never-default true # >>$Log_output 

		# connection vpn server
		nmcli connection up $CLIENT #>>$Log_output 
		

		# vpn auto connection
		echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

		cp $WORK_PATH/vpn-connecter.service /lib/systemd/system/
		cp $WORK_PATH/vpn-auto-connection.sh $VPNSCRIPTPATH
		
		sed -i "s|vpn-client-key|$VPNSCRIPT|" /lib/systemd/system/vpn-connecter.service
		sed -i "s|vpn-client-key|$CLIENT|" $VPNSCRIPTPATH/vpn-auto-connection.sh

		systemctl daemon-reload >>$Log_output 
		systemctl enable vpn-connecter >>$Log_output 
		systemctl start vpn-connecter >>$Log_output

		echo "$DATETIME]  end vpn con" >> $Log_output
		route -n >>$Log_output	


		if [ `nmcli c | grep "hm-*" | awk '{print $4}'` = '--' ];
		then
				vpn="FAIL"
		else
			vpn="SUCCESS"
		fi

		echo "$DATETIME]  vpn isSuccess => $vpn"  >> $Log_output
		
		VPNIPADDR=`ifconfig | awk '/inet .*destination/'|awk '{print $2}'`
		echo "$DATETIME]  vpn ip addr is ==$VPNIPADDR" >>$Log_output

		echo $vpn

		exit 0
	fi

}


vpn_create(){
	vpnclientchk=$(ls /etc/hamonize/ovpnclient/ | grep -c hm-*) >> $Log_output
	echo "---$vpnclientchk" >>$Log_output

	if [ "$vpnclientchk" -eq 1 ]; then
        	echo "file exit" >>$Log_output

		vpnkeynm=`ls /etc/hamonize/ovpnclient | grep hm-* | awk -F'.' '{print $1}'`
		nmcli con down $vpnkeynm >>$Log_output
        nmcli con delete $vpnkeynm >> $Log_output
		vpnwork
	
	else
        echo "file not exitst" >>$Log_output
		vpnwork
	fi

}


vpn_create
