#!bin/bash

DATETIME=`date +'%Y-%m-%d %H:%M:%S'`

LOGFILE="/var/log/hamonize/propertiesJob/propertiesJob.log"
DIR_LOG_FORDER="/var/log/hamonize/propertiesJob/"
DIR_FILEPATH_FORDER="/etc/hamonize/propertiesJob"
FILEPATH="/etc/hamonize/propertiesJob/propertiesInfo.hm"
FILEPATH_TMP="/etc/hamonize/propertiesJob/chkpropertiesInfo.hm"
HWFILE="/etc/hamonize/hwinfo/hwinfo.hm"
# cat  /dev/null > $LOGFILE


# STEP 2. 프로그램 관리 설치를 위한 기본 프로그램 설치    ===================================
#

echo "$DATETIME ] ===============Init HamonizeInstall Start (hamonize base file & folder Create)==================" >> $LOGFILE
echo "$DATETIME ]-------->프로그램 관리 설치를 위한 기본 프로그램 설치 [START]" >> $LOGFILE


# REQUIRED_PKG="make"
# PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
# echo Checking for $REQUIRED_PKG: $PKG_OK
# if [ "" = "$PKG_OK" ]; then
#     echo "$DATETIME ]-------->No $REQUIRED_PKG. Setting up $REQUIRED_PKG. \n" >> $LOGFILE
#     sudo apt-get --yes install $REQUIRED_PKG >> $LOGFILE
# fi

# sleep 1
# echo "$DATETIME ]-------->curl install status \n `dpkg -l make`" >> $LOGFILE



# REQUIRED_PKG="curl"
# PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
# echo Checking for $REQUIRED_PKG: $PKG_OK
# if [ "" = "$PKG_OK" ]; then
#     echo "$DATETIME ]-------->No $REQUIRED_PKG. Setting up $REQUIRED_PKG. \n" >> $LOGFILE
#     sudo apt-get --yes install $REQUIRED_PKG >> $LOGFILE
# fi

# sleep 1
# echo "$DATETIME ]-------->curl install status \n `dpkg -l curl`" >> $LOGFILE



# REQUIRED_PKG="jq"
# PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
# echo Checking for $REQUIRED_PKG: $PKG_OK
# if [ "" = "$PKG_OK" ]; then
#     echo "$DATETIME ]-------->No $REQUIRED_PKG. Setting up $REQUIRED_PKG.">> $LOGFILE
#     sudo apt-get --yes install $REQUIRED_PKG >> $LOGFILE
# fi

# sleep 1
# echo "$DATETIME ]-------->jq install status \n `dpkg -l jq`">> $LOGFILE



# REQUIRED_PKG="openssh-server"
# PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
# echo Checking for $REQUIRED_PKG: $PKG_OK
# if [ "" = "$PKG_OK" ]; then
#     echo "$DATETIME ]-------->No $REQUIRED_PKG. Setting up $REQUIRED_PKG.">> $LOGFILE
#     # sudo apt-get --yes install $REQUIRED_PKG >> $LOGFILE
#     DEBIAN_FRONTEND=noninteractive apt-get --yes install $REQUIRED_PKG >> $LOGFILE
# fi



# STEP1. Base File & Folder Creaete ====================================

#UUID 생성
if [ ! -d /etc/hamonize ]; then
    mkdir /etc/hamonize > /dev/null 2>&1
    touch /etc/hamonize/uuid >/dev/null 2>&1
fi

echo "[initHamonizeInstall Start] =============================" >> $LOGFILE


UUIDTMP=`sudo dmidecode -t 1|grep UUID | awk -F ':' '{print $2}' |awk -F'-' '{print $1$2$3}'`
MACHIDTMP=`cat /etc/machine-id`
MACHID=`cat /etc/machine-id`

cat /dev/null > /etc/hamonize/uuid
echo "${MACHID}" | tr -d ' ' >> /etc/hamonize/uuid

sudo touch /etc/uuid
cat /dev/null > /etc/uuid
sudo cat /etc/hamonize/uuid >> /etc/uuid

if [ ! -d /etc/hamonize/hwinfo ]; then
    mkdir /etc/hamonize/hwinfo && touch $HWFILE >/dev/null 2>&1
fi


if [ ! -d /etc/hamonize/propertiesJob ]; then
    mkdir /etc/hamonize/propertiesJob >/dev/null 2>&1
    touch /etc/hamonize/propertiesJob/propertiesInfo.hm
    touch /etc/hamonize/propertiesJob/chkpropertiesInfo.hm
fi


if [ ! -d /etc/hamonize/backup ]; then
    mkdir /etc/hamonize/backup >/dev/null 2>&1
    touch /etc/hamonize/backup/backupInfo.hm
fi


if [ ! -d /var/log/hamonize/ ]; then
    mkdir /var/log/hamonize/ >/dev/null 2>&1
    
    mkdir /var/log/hamonize/pc_hw_chk/ >/dev/null 2>&1
    touch /var/log/hamonize/pc_hw_chk/pc_hw_chk.log >/dev/null 2>&1
    
    mkdir /var/log/hamonize/propertiesJob >/dev/null 2>&1
    touch /var/log/hamonize/propertiesJob/propertiesJob.log >/dev/null 2>&1

    touch /var/log/hamonize/propertiesJob/hamonize-connector_error.log >/dev/null 2>&1
fi


Log_folder="/var/log/hamonize/adcon/"
Log_output_sgm="/var/log/hamonize/adcon/sgm.log"
Log_output="/var/log/hamonize/adcon/output.log"
Log_curlinstall="/var/log/hamonize/adcon/curlinstall.log"
Log_backup="/var/log/hamonize/adcon/backuplog.log"


mkdir $Log_folder >/dev/null 2>&1
touch $Log_output_sgm >/dev/null 2>&1
touch $Log_output >/dev/null 2>&1
touch $Log_curlinstall >/dev/null 2>&1
touch $Log_backup >/dev/null 2>&1


mkdir /var/log/hamonize/agentjob
touch /var/log/hamonize/agentjob/updp.log
