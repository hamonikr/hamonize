#!/bin/bash

centerUrl=`cat /etc/hamonize/propertiesJob/propertiesInfo.hm | grep CENTERURL | awk -F'=' '{print $2}'`

CENTERURL="http://${centerUrl}/act/progrmAct"
DATETIME=`date +'%Y-%m-%d %H:%M:%S'`
HOSTNAME=`hostname`
UUID=`cat /etc/hamonize/uuid`
LOGFILE="/var/log/hamonize/agentjob/progrmjob.log"
touch $LOGFILE


echo "################### Progrm block ###########################"

UPDT_INS=`cat /etc/hamonize/progrm/progrm.hm | jq '.INS' | sed -e "s/\"//g" ` 
echo "block program name =========> $UPDT_INS" >>$LOGFILE

if [ "$UPDT_INS" != null ] 
then
        echo "program access unpossible ==" >>$LOGFILE

EC=0
INSRET=""
OLD_IFS=$IFS;
IFS=,;
for I in $UPDT_INS; 
do


        echo "program  name is ===> $I" >>$LOGFILE
	

	sudo ps aux | grep $I | awk {'print $2'} | xargs kill -9 >>$LOGFILE
	sleep 1
	
	DO_WHEREISPROGRM=`whereis $I`
        echo "whereis progrm === $DO_WHEREISPROGRM" >>$LOGFILE

        DO_FILE_PATH=`echo $DO_WHEREISPROGRM | awk '{print $2}'`
        echo "do program is ===>$DO_FILE_PATH" >>$LOGFILE


       	sudo chmod 644 $DO_FILE_PATH

      	PROGRM_CHMOD=`ls -al "$DO_FILE_PATH" | awk '{print $1}'`
       	echo "PROGRM_CHMOD===> $PROGRM_CHMOD" >>$LOGFILE


        INSRET=$INSRET"{\"uuid\":\"${UUID}\",\"hostname\":\"${HOSTNAME}\",\"status\":\"ins\",\"status_yn\":\"Y\",\"progrmname\":\"${I}\",\"datetime\":\"${DATETIME}\"}"

        if [ "$EC" -eq "$#" ]; then
                INSRET=$INSRET","
        fi

        EC=`expr "$EC" + 1`



done;
fi




echo "================================================================="
echo "################### progrm allow ###########################"

UPDT_INS=`cat /etc/hamonize/progrm/progrm.hm | jq '.DEL' | sed -e "s/\"//g" `
echo "install file total  data=========$UPDT_INS" >>$LOGFILE

if [ "$UPDT_INS" != null ]
then
        echo "program access possible ==" >>$LOGFILE

EC=0
DELRET=""
OLD_IFS=$IFS;
IFS=,;
for I in $UPDT_INS;
do


        echo "program name is ===> $I" >>$LOGFILE


	DO_WHEREISPROGRM=`whereis $I`
        echo "whereis progrm === $DO_WHEREISPROGRM" >>$LOGFILE

       	DO_FILE_PATH=`echo $DO_WHEREISPROGRM | awk '{print $2}'`
        echo "do program is ===>$DO_FILE_PATH" >>$LOGFILE

       	sudo chmod 755 $DO_FILE_PATH
       
       	PROGRM_CHMOD=`ls -al "$DO_FILE_PATH" | awk '{print $1}'`
       	echo "PROGRM_CHMOD===$PROGRM_CHMOD"



        DELRET=$DELRET"{\"uuid\":\"${UUID}\",\"hostname\":\"${HOSTNAME}\",\"status\":\"del\",\"status_yn\":\"N\",\"progrmname\":\"${I}\",\"datetime\":\"${DATETIME}\"}"

        if [ "$EC" -eq "$#" ]; then
                DELRET=$DELRET","
        fi

        EC=`expr "$EC" + 1`



done;
fi




echo "################## updt json data ############################"

PROGRM_JSON="{\
       \"insresert\":[$INSRET],\
       \"delresert\": [$DELRET],\
       \"uuid\": \"$PCUUID\"\
}"


echo $PROGRM_JSON >>$LOGFILE

RETUPDT=`curl  -X  POST -H 'User-Agent: HamoniKR OS' -H 'Content-Type: application/json' -f -s -d "$PROGRM_JSON" $CENTERURL`

echo $RETUPDT >> ${LOGFILE}


