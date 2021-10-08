#!/bin/bash

DATETIME=`date +'%Y-%m-%d %H:%M:%S'`
Log_output="/var/log/hamonize/vpnlog/vpnlog.hm"


if [ `nmcli c | grep "hm-*" | awk '{print $4}'` = '--' ];
then
		vpn="FAIL"
else
		vpn="SUCCESS"
fi

echo "$DATETIME]  vpn isSuccess => $vpn"  >> $Log_output
echo "$DATETIME]  vpn ip addr is ==$VPNIPADDR" >>$Log_output
echo $RETBAK >> $Log_output


echo $vpn
