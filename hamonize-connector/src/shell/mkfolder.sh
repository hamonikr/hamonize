#!/bin/bash

#UUID 생성
if [ ! -d /etc/hamonize ]; then
        mkdir /etc/hamonize > /dev/null 2>&1
        touch /etc/hamonize/uuid >/dev/null 2>&1
fi


UUIDTMP=`sudo dmidecode -t 1|grep UUID | awk -F ':' '{print $2}' |awk -F'-' '{print $1$2$3}'`
MACHIDTMP=`cat /etc/machine-id`
MACHID=`cat /etc/machine-id`

cat /dev/null > /etc/hamonize/uuid
echo "${MACHID}" | tr -d ' ' >> /etc/hamonize/uuid

sudo touch /etc/uuid
cat /dev/null > /etc/uuid
sudo cat /etc/hamonize/uuid >> /etc/uuid

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
        touch var/log/hamonize/propertiesJob/propertiesJob.log >/dev/null 2>&1
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
