#!/usr/bin/env bash

. /etc/hamonize/propertiesJob/propertiesInfo.hm

DATETIME=`date +'%Y-%m-%d %H:%M:%S'`
UUID=`cat /etc/uuid`
LOGFILE="/var/log/hamonize/agentjob/loginout.log"
sudo touch $LOGFILE

GUBUN=""
CENTERURL="http://${CENTERURL}/act/loginout"

case $1 in
        login)
        GUBUN="LOGIN"
        ;;

        logout)
        GUBUN="LOGOUT"
        ;;
esac


LOGININFO_JSON="{\
       \"events\" : [ {\
       \"datetime\":\"$DATETIME\",\
       \"uuid\":\"$UUID\",\
       \"gubun\": \"$GUBUN\"\
       } ]\
}"


RET=`curl  -X  POST -H 'User-Agent: HamoniKR OS' -H 'Content-Type: application/json' -f -s -d "$LOGININFO_JSON" $CENTERURL`
echo $LOGININFO_JSON >> $LOGFILE

echo $RET >> $LOGFILE
