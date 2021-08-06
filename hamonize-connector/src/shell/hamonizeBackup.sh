#!/bin/bash


#==== backup timeShift ==============================================

DEVICE=`df -T|grep 'ext*' | awk '{print $1}'`
Log_backup="/var/log/hamonize/adcon/backuplog.log"
INFOHM="/etc/hamonize/propertiesJob/propertiesInfo.hm"
CENTERURL=`cat $INFOHM | grep CENTERURL | awk -F '=' '{print $2}'`
DATETIME=`date +'%Y-%m-%d %H:%M:%S'`
UUID=`cat /etc/hamonize/uuid |head -1`
HOSTNAME=`hostname`

cat  /dev/null > $Log_backup 

echo "DEVICE === > $DEVICE"
echo "CENTERURL==========>$CENTERURL" >>$Log_backup

# rescue 폴더 백업 제외 설정
# sed -i "s/exclude\" \: \[/exclude\" \: \[\n    \"\/rescue\/**\",/g" /etc/timeshift.json
# sed -i "s/exclude\" \: \[/exclude\" \: \[\n    /g" /etc/timeshift.json

echo `cat /etc/timeshift.json` >>$Log_backup

(

echo "start==========" >>$Log_backup
echo "start==device========$DEVICE" >>$Log_backup

        sudo timeshift --snapshot-device "$DEVICE" --scripted --create --comments "init backup" >>$Log_backup
        
        BKNAME=`cat $Log_backup |grep 'Tagged*' | awk '{print $3}' | awk -F "'" '{print $2}'`
        BKUUID=`cat /etc/hamonize/uuid |head -1`
        BKDIR="/timeshift/snapshots"
        BKCENTERURL="http://$CENTERURL/backup/setBackupJob"

    
        BK_JSON="{\
                \"events\" : [ {\
                \"datetime\":\"$DATETIME\",\
                \"uuid\":\"$UUID\",\
                \"name\": \"$BKNAME\",\
                \"hostname\": \"$HOSTNAME\",\
                \"gubun\": \"A\",\
                \"dir\": \"$BKDIR\"\
                } ]\
        }"


        echo "BK_JSON====$BK_JSON" >>$Log_backup
        echo "BK_JSON BKCENTERURL ====$BKCENTERURL" >>$Log_backup
        RETBAK=`curl  -X  POST -H 'User-Agent: HamoniKR OS' -H 'Content-Type: application/json' -f -s -d "$BK_JSON" $BKCENTERURL`
        echo $RETBAK >> $Log_backup


) & {

        i="0"
        while (true)
        do
            proc=$(ps aux | grep -e "timeshift*" | head -1 | awk '{print $NF}')
            if [ "$proc" = "timeshift*" ]; then break; fi
            sleep 1
            echo "backup count :: $i"
            i=$(expr $i + 1)
        done
        echo 100
        sleep 2
} 
