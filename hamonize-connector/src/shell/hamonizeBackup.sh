#!/bin/bash


#==== backup timeShift ==============================================

DEVICE=`df -T|grep 'ext*' | awk '{print $1}'`
Log_backup="/var/log/hamonize/adcon/backuplog.log"
INFOHM="/etc/hamonize/propertiesJob/propertiesInfo.hm"
CENTERURL=`cat $INFOHM | grep CENTERURL | awk -F '=' '{print $2}'`
DATETIME=`date +'%Y-%m-%d %H:%M:%S'`
UUID=`cat /etc/hamonize/uuid |head -1`
HOSTNAME=`hostname`
TENANT=$(cat /etc/hamonize/hamonize_tanent)

cat  /dev/null > $Log_backup 

echo "DEVICE === > $DEVICE"

# create file timeshift.json
# timeshift --check # result : /etc/timeshift/timeshift.json

# get timeshift uuid


# timeshift --check
FILEPATH=""
if [ -f "/etc/timeshift/timeshift.json" ]; then
    echo "case 1 --- file exist"
    mv /etc/timeshift/timeshift.json  /etc/timeshift/timeshift.json_back
elif [ -f "/etc/timeshift.json" ]; then
    echo "case 2---file exist "
    mv /etc/timeshift.json  /etc/timeshift.json_back
else
    echo "file not exist"
fi

TIMESHIFT_UUID=`timeshift --list | grep UUID | awk -F ':' '{print $2}' | sed 's/ //g'`
echo $TIMESHIFT_UUID >>$Log_backup


if [ -f "/etc/timeshift/timeshift.json" ]; then
    FILEPATH="/etc/timeshift/timeshift.json"
elif [ -f "/etc/timeshift.json" ]; then
    FILEPATH="/etc/timeshift.json"
fi


echo $FILEPATH >>$Log_backup

# # setting 1. timeshift backup_device_uuid
sed -i "s/backup_device_uuid\" \: \"\"/backup_device_uuid\" \: \"${TIMESHIFT_UUID}\"/g" $FILEPATH

# # # setting 2.
sed -i "s/\"true\"/\"false\"/g" $FILEPATH
sed -i "s/do_first_run\" \: \"true\"/do_first_run\" \: \"first\"/g" $FILEPATH


# # # backup directory  설정
# # # backup directory  설정
USERID=$1
echo $USERID >> $Log_backup

sed -i "s/exclude\" \: \[/exclude\" \: \[\n \"+ \/home\/$USERID\/**\" /g" $FILEPATH
sed -i "s/exclude\" \: \[/exclude\" \: \[\n \"+ \/root\/**\", /g" $FILEPATH

echo `cat $FILEPATH` >>$Log_backup

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
                \"domain\": \"$TENANT\",\
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


echo "backup End Timeshift Config File restore==== " >> $Log_backup
if [ -f "/etc/timeshift/timeshift.json" ]; then
    rm -fr /etc/timeshift/timeshift.json
    mv /etc/timeshift/timeshift.json_back  /etc/timeshift/timeshift.json
elif [ -f "/etc/timeshift.json" ]; then
    rm -fr /etc/timeshift.json
    mv /etc/timeshift.json_back  /etc/timeshift.json
fi
