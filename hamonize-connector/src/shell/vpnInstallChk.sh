#!/bin/bash

DATETIME=`date +'%Y-%m-%d %H:%M:%S'`
INFOHM="/etc/hamonize/propertiesJob/propertiesInfo.hm"
CENTERURLINFO=`cat $INFOHM | grep CENTERURL | awk -F '=' '{print $2}'`
CENTERURL="http://$CENTERURLINFO/hmsvc/setVpnUpdate"

Log_output="/var/log/hamonize/vpnlog/vpnlog.hm"


if [ `nmcli c | grep "hm-*" | awk '{print $4}'` = '--' ];
then
		vpn="FAIL"
else
		vpn="SUCCESS"
fi

echo "$DATETIME]  vpn isSuccess => $vpn"  >> $Log_output

VPNIPADDR=`ifconfig | awk '/inet .*destination/'|awk '{print $2}'`
echo "$DATETIME]  vpn ip addr is ==$VPNIPADDR" >>$Log_output

RETBAK=`curl  -X  POST -H 'User-Agent: HamoniKR OS' -H 'Content-Type: application/json' -f -s -d "$BK_JSON" $CENTERURL`
echo $RETBAK >> $Log_output


echo $vpn
