#!/bin/bash  


UUID=`cat /etc/uuid |head -1`
DATETIME=`date +'%Y-%m-%d %H:%M:%S'`
HOSTNAME=`hostname`
BKDIR="/timeshift/snapshots"
centerUrl=`cat /etc/hamonize/propertiesJob/propertiesInfo.hm | grep CENTERURL | awk -F'=' '{print $2}'`
BK_END_CENTERURL="http://${centerUrl}/backup/setEndBackupRecoveryJob"
BK_START_CENTERURL="http://${centerUrl}/backup/setStartBackupRecoveryJob"
LOGFILE="/var/log/hamonize/agentjob/agentjob_backup_recovery.log"
sudo touch $LOGFILE

DEVICE="/dev/sda4"
DIR_NAME="/tmp/backuptest";
BACKUP_NAME=`cat /etc/hamonize/recovery/recoveryInfo.hm`

if [ ! -d $DIR_NAME ]; then 
	mkdir ${DIR_NAME} 
	touch ${LOGFILE} 
fi


BK_RECOV_JSON="{\
	\"events\" : [ {\
	\"datetime\":\"$DATETIME\",\
	\"uuid\":\"$UUID\",\
	\"hostname\": \"$HOSTNAME\",\
	\"status\": \"Y\"\
	} ]\
}"

echo ${BK_RECOV_JSON} >> ${LOGFILE}

RET_RECOV=`curl  -X  POST -H 'User-Agent: HamoniKR OS' -H 'Content-Type: application/json' -f -s -d "$BK_RECOV_JSON" $BK_START_CENTERURL`

echo "---------------------->$RET_RECOV">>$LOGFILE


echo "$DATETIME] backup recovery start==========================" >> ${LOGFILE}
(
	echo \n * | sudo sudo timeshift --restore --snapshot "$BACKUP_NAME" --target "$DEVICE" --skip-grub --yes
) & {

	i="0"
	while (true)
	do
		proc=$(ps aux | grep -e "timeshift*" | head -1 | awk '{print $NF}')
		if [ "$proc" = "timeshift*" ]; then 
		    
			echo "end=====================" >> ${LOGFILE}
			echo "curl send data ==========+" >> ${LOGFILE}		   

			BKLOG="$UUID|$DATETIME|$BKNAME|$HOSTNAME|$BKDIR|"

			BK_JSON="{\
			       \"events\" : [ {\
			       \"datetime\":\"$DATETIME\",\
			       \"uuid\":\"$UUID\",\
			       \"name\": \"$BKNAME\",\
			       \"hostname\": \"$HOSTNAME\",\
			       \"dir\": \"$BKDIR\"\
			       } ]\
			}"

			echo ${BK_JSON} >> ${LOGFILE}

			RETBAK=`curl  -X  POST -H 'User-Agent: HamoniKR OS' -H 'Content-Type: application/json' -f -s -d "$BK_JSON" $BK_END_CENTERURL`
			echo $RETBAK >> ${LOGFILE}



			echo "$NOWDATE] backup end==========================" >> ${LOGFILE}

			break;
	   
		fi
                done
		exit 
} 







