#!/bin/bash

#=== install program version check  ====
LOGFILE="/var/log/hamonize/propertiesJob/propertiesJob.log"


# echo "apt-get update program.." >> $LOGFILE
# sudo apt-get update >> $LOGFILE

# sleep 1

# VERSION_CHK_COUNT=`apt list --upgradable 2>/dev/null | grep hamonize-connect-server | wc -l`
VERSION_CHK_COUNT=`apt list --upgradable 1>/dev/null | grep hamonize-agent | wc -l`
echo "install program version check val is ::: $VERSION_CHK_COUNT" >>$LOGFILE


if [ $VERSION_CHK_COUNT -gt 0  ]; then
	echo "[ need upgrade install program..]" >> $LOGFILE
    # sudo apt-get --only-upgrade install hamonize-agent -y >/dev/null 2>&1
	echo "$VERSION_CHK_COUNT"
fi

