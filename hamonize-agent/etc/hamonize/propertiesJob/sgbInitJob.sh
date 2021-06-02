#!/bin/bash  

sleep 10
sudo dpkg --configure -a > /dev/null 2>&1


UUID=`c`

URL=`cat /etc/hamonize/propertiesJob/propertiesInfo.hm | grep CENTERURL | awk -F'=' '{print $2}'`
CENTERURL= "$URL/getAgent/sgbprt" 

DATA_JSON="{\
	\"events\" : [ {\
	\"uuid\": \"$UUID\"\
	} ]\
}"

RETDATA=`curl  -X  POST -H 'User-Agent: HamoniKR OS' -H 'Content-Type: application/json' -f -s -d "$DATA_JSON" $CENTERURL`

#=== agent & admin upgradle ====
sudo apt-get update > /dev/null 2>&1

CHK_AGENT=`apt list --upgradable 2>/dev/null | grep hamonize-agent | wc -l`
echo "agnet upgrade able is =="$CHK_AGENT >> $LOGFILE
if [ $CHK_AGENT -gt 0  ]; then
        sudo apt-get --only-upgrade install hamonize-agent -y >/dev/null 2>&1
fi

CHK_ADMIN=`apt list --upgradable 2>/dev/null | grep hamonize-admin | wc -l`
echo "admin upgrade able is =="$CHK_ADMIN >> $LOGFILE
if [ $CHK_ADMIN -gt 0  ]; then
        sudo apt-get --only-upgrade install hamonize-admin -y> /dev/null 2>&1
fi


