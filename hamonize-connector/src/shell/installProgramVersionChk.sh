#!bin/bash

DATETIME=`date +'%Y-%m-%d %H:%M:%S'`

LOGFILE="/var/log/hamonize/propertiesJob/propertiesJob.log"
cat  /dev/null > $LOGFILE 

#=== step 1. 프로그램 관리 설치를 위한 기본 프로그램 설치   install  ===================================
echo "$DATETIME ]-------->프로그램 관리 설치를 위한 기본 프로그램 설치 [START]" >> $LOGFILE


#=== install program version check ==========
echo "\n"
echo "\n"
echo "\n"
echo "$DATETIME ]-------->설치 프로그램 버전 확인 [START] " >> $LOGFILE

CHK_CONNECT=`apt list --upgradable 2>/dev/null | grep hamonize-connect-server | wc -l`
# CHK_CONNECT=`apt list --upgradable 2>/dev/null | grep top | wc -l`

echo "$DATETIME ]-------->connect upgrade able is =="$CHK_CONNECT >> $LOGFILE
if [ $CHK_CONNECT -gt 0  ]; then
        echo "$DATETIME ]-------->설치 프로그램 상위 버전으로 업그렐이드 설치 " >> $LOGFILE
        sudo apt-get --only-upgrade install hamonize-connect-server -y >> $LOGFILE
fi


