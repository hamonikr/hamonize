#!/bin/bash  


UUID=`cat /etc/hamonize/uuid |head -1`
DATETIME=`date +'%Y-%m-%d %H:%M:%S'`
HOSTNAME=`hostname`
BKDIR="/timeshift/snapshots"
centerUrl=`cat /etc/hamonize/propertiesJob/propertiesInfo.hm | grep CENTERURL | awk -F'=' '{print $2}'`
BKCENTERURL="https://${centerUrl}/backup/setBackupJob"
LOGFILE="/var/log/hamonize/agentjob/agentjob_backup.log"

# sudo touch $LOGFILE 
sudo cat /dev/null > $LOGFILE
DEVICE=`df | grep -w "/" | awk '{print $1}'`
DIR_NAME="/tmp/backuptest";
BKGUBUN="B"

 
if [ ! -f "$FILE" ]; then
	sudo touch $LOGFILE
fi

# if [ ! -d $DIR_NAME ]; then 
# 	mkdir ${DIR_NAME} 
# 	touch ${LOGFILE} 
# fi 



echo "$DATETIME] backup start==========================" >> ${LOGFILE}
(
	# sed -i "s/exclude\" \: \[/exclude\" \: \[\n    \"\/rescue\/**\"/g" /etc/timeshift.json
	sudo timeshift --snapshot-device "$DEVICE" --scripted --create --comments "backup"  >> ${LOGFILE}

) && {

	i="0"
	while (true)
	do
		proc=$(ps aux | grep -e "timeshift*" | head -1 | awk '{print $NF}')
		if [ "$proc" = "timeshift*" ]; then 
		    
			echo "end=====================" >> ${LOGFILE}
			echo "curl send data ==========+" >> ${LOGFILE}		   

			#BKNAME=`cat ./agentjob_backup.log |grep 'Tagged*' | awk '{print $3}' | awk -F "'" '{print $2}'`
			BKNAME=`cat $LOGFILE |grep 'Tagged*' | awk '{print $3}' | awk -F "'" '{print $2}'`
			BKLOG="$UUID|$DATETIME|$BKNAME|$HOSTNAME|$BKDIR|$BKGUBUN"

			BK_JSON="{\
			       \"events\" : [ {\
			       \"datetime\":\"$DATETIME\",\
			       \"uuid\":\"$UUID\",\
			       \"name\": \"$BKNAME\",\
			       \"hostname\": \"$HOSTNAME\",\
			       \"dir\": \"$BKDIR\"\
			       \"gubun\": \"$BKGUBUN\"\
			       } ]\
			}"

			echo ${BK_JSON} >> ${LOGFILE}
			echo ${BKCENTERURL} >> ${LOGFILE} 
			RETBAK=`curl  -X  POST -H 'User-Agent: HamoniKR OS' -H 'Content-Type: application/json' -f -s -d "$BK_JSON" $BKCENTERURL`
			echo $RETBAK >> ${LOGFILE}



			echo "$NOWDATE] backup end==========================" >> ${LOGFILE}
			
           
            
			break;
	   
		fi
                done
		exit 
        } 







