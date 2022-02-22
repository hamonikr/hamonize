#!/bin/bash  

(
RUID=$(who | awk 'FNR == 1 {print $1}')
RUSER_UID=$(id -u ${RUID})
DISPLAY=:0  sudo -u ${RUID} DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/${RUSER_UID}/bus" /usr/share/hamonize-agent/shell/hamonize-noti-1.0.0.AppImage --no-sandbox


) & {

UUID=`cat /etc/uuid |head -1`
DATETIME=`date +'%Y-%m-%d %H:%M:%S'`
HOSTNAME=`hostname`
BKDIR="/timeshift/snapshots"
centerUrl=`cat /etc/hamonize/propertiesJob/propertiesInfo.hm | grep CENTERURL | awk -F'=' '{print $2}'`

BK_RECOV_CENTERURL="http://${centerUrl}/act/stBackupRecoveryJob"
TENANT=$(cat /etc/hamonize/hamonize_tanent)
LOGFILE="/var/log/hamonize/agentjob/agentjob_backup_recovery.log"
# sudo touch $LOGFILE

DEVICE=`df | grep -w "/" | awk '{print $1}'`
# DIR_NAME="/tmp/backuptest";
BACKUP_NAME=`cat /etc/hamonize/recovery/recoveryInfo.hm`
# BACKUP_NAME="2021-07-13_16-01-42"


if [ ! -f "$LOGFILE" ]; then
	sudo touch $LOGFILE
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
echo "$DATETIME] logout==========================" >> ${LOGFILE}
sudo /etc/hamonize/run-script-on-boot.sh logout >> ${LOGFILE}

# RET_RECOV=`curl  -X  POST -H 'User-Agent: HamoniKR OS' -H 'Content-Type: application/json' -f -s -d "$BK_RECOV_JSON" $BK_START_CENTERURL`
# echo "---------------------->$RET_RECOV">>$LOGFILE

# ./hamonikrvdidemo-1.0.0.AppImage
echo "$DATETIME] backup recovery start==========================" >> ${LOGFILE}
BKLOG="$UUID|$DATETIME|$BKNAME|$HOSTNAME|$BKDIR|"

BK_JSON="{\
		\"events\" : [ {\
		\"datetime\":\"$DATETIME\",\
		\"uuid\":\"$UUID\",\
		\"hostname\": \"$HOSTNAME\",\
		\"action_status\": \"Y\",\
		\"name\": \"$BACKUP_NAME\",\
		\"domain\": \"$TENANT\",\
		\"result\": \"N\",\
		\"dir\": \"$BKDIR\"\
		} ]\
}"

echo ${BK_JSON} >> ${LOGFILE}

RETBAK=`curl  -X  POST -H 'User-Agent: HamoniKR OS' -H 'Content-Type: application/json' -f -s -d "$BK_JSON" $BK_RECOV_CENTERURL`
echo $RETBAK >> ${LOGFILE}



echo "$NOWDATE] backup end==========================" >> ${LOGFILE}
echo \n * | sudo sudo timeshift --restore --snapshot "$BACKUP_NAME" --target "$DEVICE" --skip-grub --yes >> ${LOGFILE}


# (
# 	echo \n * | sudo sudo timeshift --restore --snapshot "$BACKUP_NAME" --target "$DEVICE" --skip-grub --yes
# ) & {

# 	i="0"
# 	while (true)
# 	do
# 		proc=$(ps aux | grep -e "timeshift*" | head -1 | awk '{print $NF}')
# 		if [ "$proc" = "timeshift*" ]; then 
		    
# 			echo "end=====================" >> ${LOGFILE}
# 			echo "curl send data ==========+" >> ${LOGFILE}		   

# 			BKLOG="$UUID|$DATETIME|$BKNAME|$HOSTNAME|$BKDIR|"

# 			BK_JSON="{\
# 			       \"events\" : [ {\
# 			       \"datetime\":\"$DATETIME\",\
# 			       \"uuid\":\"$UUID\",\
# 			       \"name\": \"$BKNAME\",\
# 			       \"hostname\": \"$HOSTNAME\",\
# 			       \"dir\": \"$BKDIR\"\
# 			       } ]\
# 			}"

# 			echo ${BK_JSON} >> ${LOGFILE}

# 			RETBAK=`curl  -X  POST -H 'User-Agent: HamoniKR OS' -H 'Content-Type: application/json' -f -s -d "$BK_JSON" $BK_RECOV_CENTERURL`
# 			echo $RETBAK >> ${LOGFILE}



# 			echo "$NOWDATE] backup end==========================" >> ${LOGFILE}

# 			break;
	   
# 		fi
#                 done
# 		exit 
# } 

}





