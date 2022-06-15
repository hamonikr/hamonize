#!/bin/bash

sleep 10

DATETIME=$(date +'%Y-%m-%d %H:%M:%S')
LOGFILE="/var/log/hamonize/propertiesJob/hamonizeReboot.log"
FILEPATH="/etc/hamonize/propertiesJob/propertiesInfo.hm"
FILEPATH_TMP="/etc/hamonize/propertiesJob/chkpropertiesInfo.hm"

if [ ! -d $LOGFILE ]; then
        touch $LOGFILE
fi

cat /dev/null >$LOGFILE

echo "$DATETIME] resboot==========START" >>$LOGFILE

UUID=$(cat /etc/hamonize/uuid)

# 초기 필수 정보......
CENTERURL="CHANGE_CENTERURL/hmsvc/commInfoData"
# CENTERURL="$1/hmsvc/commInfoData"

DATA_JSON="{\
        \"events\" : [ {\
        \"uuid\": \"$UUID\"\
        } ]\
}"

sleep 3
echo "set pc info url===$CENTERURL" >>$LOGFILE
echo "set pc info data $DATA_JSON" >>$LOGFILE

RETDATA=$(curl -X GET -H 'User-Agent: HamoniKR OS' -H 'Content-Type: application/json' -f -s -d "$DATA_JSON" $CENTERURL)

echo "$DATETIME ]--------> get data ::: " >>$LOGFILE
echo "$RETDATA" >>$LOGFILE

setHamonizeServer() {
        WRITE_DATA=""
        FILEPATH_DATA=$(cat ${FILEPATH})
        FILEPATH_BOOL=false

        if [ -z "$FILEPATH_DATA" ]; then
                echo "no file"
                touch $FILEPATH
                FILEPATH_BOOL=true
        fi

        if [ -z "$FILEPATH_TMP" ]; then
                touch $FILEPATH_TMP
        else
                cat /dev/null >$FILEPATH_TMP
        fi

        JQINS=$(echo ${RETDATA} | jq '.pcdata')
        JQCNT=$(echo ${RETDATA} | jq '.pcdata' | jq length)

        SET=$(seq 0 $(expr $JQCNT - 1))

        for i in $SET; do

                TMP_ORGNM=$(echo ${RETDATA} | jq '.pcdata | .['$i'].svrname' | sed -e "s/\"//g")
                TMP_PCIP=$(echo ${RETDATA} | jq '.pcdata | .['$i'].pcip' | sed -e "s/\"//g")

                WRITE_DATA="$TMP_ORGNM=$TMP_PCIP"
                echo $WRITE_DATA >>$FILEPATH_TMP

        done

        #        if [ $FILEPATH_BOOL = "false" ]; then
        DIFF_VAL=$(diff -q $FILEPATH $FILEPATH_TMP)

        if [ -z "$DIFF_VAL" ]; then
                rm -fr $FILEPATH_TMP
        else
                rm -fr $FILEPATH
                mv $FILEPATH_TMP $FILEPATH
        fi
        #        fi

        echo "$DATETIME ]-------->agent에서 사용하는 rest 서버 정보 저장 [END] " >>$LOGFILE
}

if [ "" == "$RETDATA" ]; then
        sleep 10
        setHamonizeServer
else
        setHamonizeServer
fi

#=== agent & pcmngr upgradle ====
sudo apt-get update >/dev/null 2>&1

# Hamonize Agent Application =====================================================#
CHK_AGNET_INSTALLED=$(dpkg-query -W | grep hamonize-agent | wc -l)
echo "agent install checked is =="$CHK_AGNET_INSTALLED >>$LOGFILE
if [ $CHK_AGNET_INSTALLED = 0 ]; then
        sudo apt-get install hamonize-agent -y >>$LOGFILE
fi

CHK_AGENT=$(apt list --upgradable 2>/dev/null | grep hamonize-agent | wc -l)
echo "agent upgrade able is =="$CHK_AGENT >>$LOGFILE
if [ $CHK_AGENT -gt 0 ]; then
        sudo apt-get --only-upgrade install hamonize-agent -y >/dev/null 2>&1
fi

# Hamonize Admin Application =====================================================#
CHK_ADMIN_INSTALLED=$(dpkg-query -W | grep hamonize-admin | wc -l)
echo "hamonize-admin install checked is =="$CHK_ADMIN_INSTALLED >>$LOGFILE
if [ $CHK_ADMIN_INSTALLED = 0 ]; then
        sudo apt-get install hamonize-admin -y >>$LOGFILE
fi

CHK_ADMIN=$(apt list --upgradable 2>/dev/null | grep hamonize-admin | wc -l)
echo "hamonize-admin upgrade able is =="$CHK_ADMIN >>$LOGFILE
if [ $CHK_ADMIN -gt 0 ]; then
        sudo apt-get --only-upgrade install hamonize-admin -y >/dev/null 2>&1
fi

# Hamonize Help Application =====================================================#
CHK_HAMONIZE_HELP_INSTALLED=$(dpkg-query -W | grep hamonize-help | wc -l)
echo "hamonize-help install checked is =="$CHK_HAMONIZE_HELP_INSTALLED >>$LOGFILE
if [ $CHK_ADMIN_INSTALLED = 0 ]; then
        sudo apt-get install hamonize-help -y >>$LOGFILE
fi

CHK_HAMONIZE_HELP=$(apt list --upgradable 2>/dev/null | grep hamonize-help | wc -l)
echo "hamonize-help upgrade able is =="$CHK_HAMONIZE_HELP >>$LOGFILE
if [ $CHK_HAMONIZE_HELP -gt 0 ]; then
        sudo apt-get --only-upgrade install hamonize-help -y >/dev/null 2>&1
fi



echo "$DATETIME] hamonize-user && admin 필수 포트 allow 11100==========END" >>$LOGFILE
sudo ufw allow 11100 >>$LOGFILE
sudo ufw allow 11400 >>$LOGFILE
sudo ufw allow 22 >>$LOGFILE
sudo ufw allow 2202 >>$LOGFILE

sudo systemctl restart hamonize-agent



echo "$DATETIME] resboot==========END" >>$LOGFILE
exit 0