#!/bin/bash

sgbUrl=`cat /etc/hamonize/propertiesJob/propertiesInfo.hm | grep CENTERURL | awk -F'=' '{print $2}'`
CENTERURL="http://${sgbUrl}/act/progrmAct"
PCUUID=`cat /etc/hamonize/uuid`
LOGFILE="/var/log/hamonize/agentjob/progrmjobPolicyAct.log"
touch $LOGFILE

UUID=`cat /etc/hamonize/uuid |head -1`
DATETIME=`date +'%Y-%m-%d %H:%M:%S'`
HOSTNAME=`hostname`

# PROGM_INS=`cat /etc/hamonize/progrm/progrm.hm | /usr/share/hamonize-agent/jq '.INS' | sed -e "s/\"//g" ` 
PROGM_INS=`cat /etc/hamonize/progrm/progrm.hm | jq '.INS' | sed -e "s/\"//g" ` 
echo "$DATETIME]::::ins program total  data=========$PROGM_INS" >>$LOGFILE

if [ "$PROGM_INS" != null ] 
then

EC=0
INSRET=""
OLD_IFS=$IFS;
IFS=,;
for I in $PROGM_INS;
do

        sudo ps aux | grep $I | awk {'print $2'} | xargs kill -9 >>$LOGFILE
	sleep 1
	
	DO_WHEREISPROGRM=`whereis $I`
        echo "$DATETIME]::::  program access unpossible--> whereis progrm === $DO_WHEREISPROGRM" >>$LOGFILE

        DO_FILE_PATH=`echo $DO_WHEREISPROGRM | awk '{print $2}'`
        echo "$DATETIME]::::  program access unpossible--> do program is ===>$DO_FILE_PATH" >>$LOGFILE


       	sudo chmod 644 $DO_FILE_PATH


        INSRET=$INSRET"{\"progrmname\":\"${I}\",\"status_yn\":\"Y\",\"status\":\"ins\",\"datetime\":\"$DATETIME\",\"hostname\":\"$HOSTNAME\",\"uuid\":\"$UUID\"}"

        if [ "$EC" -eq "$#" ]; then
                INSRET=$INSRET","
        fi

        EC=`expr "$EC" + 1`

done;
fi



# PROGM_INS=`cat /etc/hamonize/progrm/progrm.hm | /usr/share/hamonize-agent/jq '.DEL' | sed -e "s/\"//g" `
PROGM_INS=`cat /etc/hamonize/progrm/progrm.hm | jq '.DEL' | sed -e "s/\"//g" `
echo "$DATETIME]::::del program total  data=========$PROGM_INS" >>$LOGFILE

if [ "$PROGM_INS" != null ]
then

EC=0
DELRET=""
OLD_IFS=$IFS;
IFS=,;
for I in $PROGM_INS;
do


        echo "$DATETIME]:::: program access possible->program name is ===> $I" >>$LOGFILE


	DO_WHEREISPROGRM=`whereis $I`
        echo "$DATETIME]:::: program access possible->whereis progrm === $DO_WHEREISPROGRM" >>$LOGFILE

       	DO_FILE_PATH=`echo $DO_WHEREISPROGRM | awk '{print $2}'`
        echo "$DATETIME]:::: program access possible->do program is ===>$DO_FILE_PATH" >>$LOGFILE

       	sudo chmod 755 $DO_FILE_PATH


        INSRET=$INSRET"{\"progrmname\":\"${I}\",\"status_yn\":\"N\",\"status\":\"del\",\"datetime\":\"$DATETIME\",\"hostname\":\"$HOSTNAME\",\"uuid\":\"$UUID\"}"

        if [ "$EC" -eq "$#" ]; then
                INSRET=$INSRET","
        fi

        EC=`expr "$EC" + 1`


done;
fi




echo "\n\n\n\n$DATETIME]::::################## program json data ############################" >>$LOGFILE

RESULT_JSON="{\
       \"insresert\":[$INSRET],\
       \"delresert\": [$DELRET],\
       \"uuid\": \"$PCUUID\"\
}"


echo $RESULT_JSON >>$LOGFILE

echo $CENTERURL
RETUPDT=`curl  -X  POST -H 'User-Agent: HamoniKR OS' -H 'Content-Type: application/json' -f -s -d "$RESULT_JSON" $CENTERURL`

echo $RETUPDT >> ${LOGFILE}


 