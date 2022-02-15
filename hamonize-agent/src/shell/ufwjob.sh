#!/bin/sh

DIR="$(dirname $(readlink -f $0))"
LOGFILE="/var/log/hamonize/agentjob/ufwjob.log"
sudo touch $LOGFILE

. /etc/hamonize/propertiesJob/propertiesInfo.hm
IVSC="http://${CENTERURL}/act/firewallAct"
TENANT=$1

DATETIME=`date +'%Y-%m-%d %H:%M:%S'`
echo "==============================[$DATETIME]=========================" >> $LOGFILE

UFW_STATUS=`ufw status`

echo "ufw status ====$UFW_STATUS" >>$LOGFILE

echo "#============================================" >>$LOGFILE
echo "# 방화벽 포트 허용" >>$LOGFILE
echo "#============================================" >>$LOGFILE

UFW_ALLOW=`cat /etc/hamonize/firewall/firewallInfo.hm | jq '.INS' | sed -e "s/\"//g" `
echo "UFW ALLOW  file data=========$UFW_ALLOW" >>$LOGFILE

if [ "$UFW_ALLOW" != null ]
then
        echo "== allow port ==" >>$LOGFILE


	EC=0
	INSRET=""
	OLD_IFS=$IFS;
	IFS=,;
	for I in $UFW_ALLOW;
	do
		sudo ufw allow $I 

		#policy port check & send to center
		CHK_PORT=`ufw status 2>/dev/null  | grep -w $I | tail -1 | grep ALLOW | awk '{ print $1 }'`
		echo $CHK_PORT >>$LOGFILE
		
		sleep 1

		if [ "${CHK_PORT}" -eq "${I}" ]
		then
			echo "check allow port result is Y : " >> $LOGFILE
			RETPORT="Y"
		else 
			echo "check allow port result is N : " >>$LOGFILE
			RETPORT="N"
		fi

		UUID=`cat /etc/hamonize/uuid |head -1`
                DATETIME=`date +'%Y-%m-%d %H:%M:%S'`
                HOSTNAME=`hostname`

		ALLOW_JSON="{\
			\"events\" : [ {\
			\"datetime\":\"$DATETIME\",\
			\"uuid\":\"$UUID\",\
			\"hostname\": \"$HOSTNAME\",\
			\"status\": \"allow\",\
			\"status_yn\": \"$RETPORT\",\
			\"domain\": \"$TENANT\",\
                        \"retport\": \"$I\"\
                        
			} ]\
		}"
		echo $ALLOW_JSON >> $LOGFILE
		echo $IVSC >>$LOGFILE
		RETCURL=`curl  -X  POST -H 'User-Agent: HamoniKR OS' -H 'Content-Type: application/json' -f -s -d "$ALLOW_JSON" $IVSC`
		echo $RETCURL >> ${LOGFILE}

	done;
	IFS=$OLD_IFS
fi


#============================================
# 방화벽 포트 거부
#============================================

UFW_DENY=`cat /etc/hamonize/firewall/firewallInfo.hm | jq '.DEL' | sed -e "s/\"//g" `
echo "UFW DENY  file data=========$UFW_DENY" >>$LOGFILE

if [ "$UFW_DENY" != null ]
then
        echo "== deny  ==" >>$LOGFILE

        EC=0
        INSRET=""
        OLD_IFS=$IFS;
        IFS=,;
        for I in $UFW_DENY;
        do
                echo "deny==========$I" >>$LOGFILE
		sudo ufw deny $I

		#policy port check & send to center
                CHK_PORT=`ufw status 2>/dev/null  | grep -w $I | tail -1 | grep DENY | awk '{ print $1 }'`
                echo $CHK_PORT >>$LOGFILE

                sleep 1

                if [ "$CHK_PORT" -eq "$I" ]
                then
                        echo "check allow port result is Y : " >> $LOGFILE
                        RETPORT="Y"
                else
                        echo "check allow port result is N : " >>$LOGFILE
                        RETPORT="N"
                fi

                UUID=`cat /etc/hamonize/uuid |head -1`
                DATETIME=`date +'%Y-%m-%d %H:%M:%S'`
                HOSTNAME=`hostname`

                ALLOW_JSON="{\
                        \"events\" : [ {\
                        \"datetime\":\"$DATETIME\",\
                        \"uuid\":\"$UUID\",\
                        \"hostname\": \"$HOSTNAME\",\
                        \"status\": \"deny\",\
                        \"status_yn\": \"$RETPORT\",\
                        \"domain\": \"$TENANT\",\
                        \"retport\": \"$I\"\
                        } ]\
                }"
                echo $ALLOW_JSON >> $LOGFILE
                echo $IVSC >>$LOGFILE
                RETCURL=`curl  -X  POST -H 'User-Agent: HamoniKR OS' -H 'Content-Type: application/json' -f -s -d "$ALLOW_JSON" $IVSC`
                echo $RETCURL >> ${LOGFILE}


        done;
        IFS=$OLD_IFS
fi


ufw reload >>$LOGFILE
