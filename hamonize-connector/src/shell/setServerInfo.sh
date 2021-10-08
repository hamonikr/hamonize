#!bin/bash

DATETIME=$(date +'%Y-%m-%d %H:%M:%S')
LOGFILE="/var/log/hamonize/propertiesJob/propertiesJob.log"
FILEPATH="/etc/hamonize/propertiesJob/propertiesInfo.hm"
FILEPATH_TMP="/etc/hamonize/propertiesJob/chkpropertiesInfo.hm"

cat /dev/null >$LOGFILE

UUID=$(cat /etc/hamonize/uuid)
INFOHM="/etc/hamonize/propertiesJob/propertiesInfo.hm"
CENTERURLINFO=$(cat $INFOHM | grep CENTERURL | awk -F '=' '{print $2}')

# 초기 필수 정보......
# vpn 연결후  센터 url을 통해 서버정보 get
# CENTERURL="http://<Hamonize Center Url>/hmsvc/commInfoData"
CENTERURL="http://192.168.0.210:8080/hmsvc/commInfoData"

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
echo "$RETDATA" #>>$LOGFILE

WRITE_DATA=""
FILEPATH_DATA=$(cat ${FILEPATH})
FILEPATH_BOOL=false
if [ -z "$FILEPATH_DATA" ]; then
        FILEPATH_BOOL=true
fi


JQINS=$(echo ${RETDATA} | jq '.pcdata')
echo $JQINS
JQCNT=$(echo ${RETDATA} | jq '.pcdata' | jq length)

echo "$DATETIME ]-------->center return val is :: " $JQCNT #>>$LOGFILE

SET=$(seq 0 $(expr $JQCNT - 1))
echo $SET
for i in $SET; do

        TMP_ORGNM=$(echo ${RETDATA} | jq '.pcdata | .['$i'].svrname' | sed -e "s/\"//g")
        TMP_PCIP=$(echo ${RETDATA} | jq '.pcdata | .['$i'].pcip' | sed -e "s/\"//g")

        WRITE_DATA="$TMP_ORGNM=$TMP_PCIP"

        if [ $FILEPATH_BOOL = "true" ]; then
                echo $WRITE_DATA >>$FILEPATH
        else
                echo $WRITE_DATA >>$FILEPATH_TMP
        fi

done

if [ $FILEPATH_BOOL = "false" ]; then
        DIFF_VAL=$(diff -q $FILEPATH $FILEPATH_TMP)

        if [ -z "$DIFF_VAL" ]; then
                rm -fr $FILEPATH_TMP
        else
                rm -fr $FILEPATH
                mv $FILEPATH_TMP $FILEPATH
        fi
fi

echo "$DATETIME ]-------->agent에서 사용하는 rest 서버 정보 저장 [END] " >>$LOGFILE

CENTERURL=$(cat $FILEPATH | grep CENTERURL | awk -F '=' '{print $2}')

echo $CENTERURL
