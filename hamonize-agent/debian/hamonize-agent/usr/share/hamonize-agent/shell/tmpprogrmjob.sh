#!/bin/bash

centerUrl=`cat /etc/hamonize/propertiesJob/propertiesInfo.hm | grep CENTERURL | awk -F'=' '{print $2}'`
CENTERURL="http://${centerUrl}/act/progrmAct"
PCUUID=`cat /etc/hamonize/uuid`
LOGFILE="/var/log/hamonize/agentjob/progrmjobPolicyAct.log"
touch $LOGFILE

UUID=`cat /etc/hamonize/uuid |head -1`
DATETIME=`date +'%Y-%m-%d %H:%M:%S'`
HOSTNAME=`hostname`

PROGM_INS=`cat /etc/hamonize/progrm/progrm.hm | jq '.INS' | sed -e "s/\"//g" ` 
echo "ins program total  data=========$PROGM_INS" >>$LOGFILE

if [ "$PROGM_INS" != null ] 
then

EC=0
INSRET=""
OLD_IFS=$IFS;
IFS=,;
for I in $PROGM_INS;
do

        INSRET=$INSRET"{\"progrmname\":\"${I}\",\"status_yn\":\"Y\",\"status\":\"ins\",\"datetime\":\"$DATETIME\",\"hostname\":\"$HOSTNAME\",\"uuid\":\"$UUID\"}"

        if [ "$EC" -eq "$#" ]; then
                INSRET=$INSRET","
        fi

        EC=`expr "$EC" + 1`

done;
fi



PROGM_INS=`cat /etc/hamonize/progrm/progrm.hm | jq '.DEL' | sed -e "s/\"//g" `
echo "del program total  data=========$PROGM_INS" >>$LOGFILE

if [ "$PROGM_INS" != null ]
then

EC=0
DELRET=""
OLD_IFS=$IFS;
IFS=,;
for I in $PROGM_INS;
do


        INSRET=$INSRET"{\"progrmname\":\"${I}\",\"status_yn\":\"Y\",\"status\":\"del\",\"datetime\":\"$DATETIME\",\"hostname\":\"$HOSTNAME\",\"uuid\":\"$UUID\"}"

        if [ "$EC" -eq "$#" ]; then
                INSRET=$INSRET","
        fi

        EC=`expr "$EC" + 1`


done;
fi




echo "################## program json data ############################" >>$LOGFILE

RESULT_JSON="{\
       \"insresert\":[$INSRET],\
       \"delresert\": [$DELRET],\
       \"uuid\": \"$PCUUID\"\
}"


echo $RESULT_JSON >>$LOGFILE


RETUPDT=`curl  -X  POST -H 'User-Agent: HamoniKR OS' -H 'Content-Type: application/json' -f -s -d "$RESULT_JSON" $CENTERURL`

echo $RETUPDT >> ${LOGFILE}

