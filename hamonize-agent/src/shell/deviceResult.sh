#!/bin/bash


DIR="$(dirname $(readlink -f $0))"
echo  $DIR

LOGFILE="/var/log/hamonize/agentjob/devicejob.log"
sudo touch $LOGFILE

. /etc/hamonize/propertiesJob/propertiesInfo.hm
IVSC="http://${CENTERURL}/act/deviceAct"


DATETIME=`date +'%Y-%m-%d %H:%M:%S'`
echo "==============================[$DATETIME]=========================" >> $LOGFILE

echo "# device " >>$LOGFILE
echo "#============================================" >>$LOGFILE


UUID=`cat /etc/hamonize/uuid |head -1`
HOSTNAME=`hostname`

ALLOW_JSON="{\
        \"events\" : [ {\
        \"datetime\":\"$DATETIME\",\
        \"uuid\":\"$UUID\",\
        \"hostname\": \"$HOSTNAME\"\
        } ]\
}"
echo $ALLOW_JSON >> $LOGFILE
echo $IVSC >>$LOGFILE
RETCURL=`curl  -X  POST -H 'User-Agent: HamoniKR OS' -H 'Content-Type: application/json' -f -s -d "$ALLOW_JSON" $IVSC`
echo $RETCURL >> ${LOGFILE}