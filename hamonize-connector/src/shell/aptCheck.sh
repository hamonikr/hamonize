#!/bin/bash

. /etc/hamonize/propertiesJob/propertiesInfo.hm

#=== hamonize apt repository check ====
LOGFILE="/var/log/hamonize/propertiesJob/propertiesJob.log"
APT_CHK_COUNT=`find /etc/apt/sources.list.d  -name hamonize.list | wc -l`

if [ ${APT_CHK_COUNT} = 0 ];
then
	echo "[hamonize apt is not repository....]" > $LOGFILE
echo $APTURL
	touch /etc/apt/sources.list.d/hamonize.list
	echo "deb http://$APTURL hamonize main" | sudo tee -a /etc/apt/sources.list.d/hamonize.list
	echo "deb-src http://$APTURL hamonize main" | sudo tee -a /etc/apt/sources.list.d/hamonize.list
	wget -qO - http://$APTURL/hamonize.pubkey.gpg | sudo apt-key add -

	sudo apt-get update -y > $LOGFILE

fi
 