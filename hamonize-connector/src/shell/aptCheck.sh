#!/bin/bash

#=== hamonize server apt repository check ====
LOGFILE="/var/log/hamonize/propertiesJob/propertiesJob.log"
APT_CHK_COUNT=`find /etc/apt/sources.list.d  -name hamonize.list | wc -l`

if [ ${APT_CHK_COUNT} = 0 ];
then
	echo "[hamonize apt is not repository....]" > $LOGFILE

	APTURL="106.254.251.74:28081"
	touch /etc/apt/sources.list.d/hamonize.list
	echo "deb http://$APTURL hamonize main" | sudo tee -a /etc/apt/sources.list.d/hamonize.list
	echo "deb-src http://$APTURL hamonize main" | sudo tee -a /etc/apt/sources.list.d/hamonize.list
	wget -qO - http://106.254.251.74:28081/hamonize.pubkey.gpg | sudo apt-key add -

	sudo apt-get update -y > $LOGFILE

fi
 