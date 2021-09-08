#!/bin/bash 

. /etc/hamonize/propertiesJob/propertiesInfo.hm

PCUUID=`cat /etc/hamonize/uuid`
VPNKEY=hm-${PCUUID}
VPNCNT=`nmcli con|grep ^${VPNKEY}.*vpn|awk '{print $2}' | wc -l`
PCHOSTNAME=`hostname`
LOGFILE="/var/log/hamonize/agentjob/updp.log"

DATETIME=`date +'%Y-%m-%d %H:%M:%S'`

echo "$DATETIME ] agent upgrade chk!!!" >> $LOGFILE


sudo apt-get update >/dev/null

INS_INSTALL_CHK=`dpkg --get-selections | grep hamonize-agent | awk '{print $1}' `
echo "$DATETIME ]::::hamonize-agents install chk is ==> $INS_INSTALL_CHK" >>$LOGFILE

if [ $INS_INSTALL_CHK = "hamonize-agent" ]; then
	echo "$DATETIME ] agent upgrade  Action!! " >>$LOGFILE
	sudo apt-get install hamonize-agent -y  >>$LOGFILE
fi

