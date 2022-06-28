#!/bin/bash

shut_time=$(date --date='10 minutes' +"%T")

logfile='/var/log/hamonize/osInitJob.log'
touch $logfile

cat /dev/null >$logfile

#notify-send -t 600000 "INFO:
#OS 초기화를 시작합니다.
#초기화 진행 후 자동 종료됩니다.
#Shutting down in 10 minutes (scheduled for $shut_time)."

DEVICE=$(df -T | grep 'ext*' | awk '{print $1}')
BACKUP_NAME=$(timeshift --list | grep -e "init backup" | awk -F ' ' '{print $3}' | head -n 1)

echo $(/bin/systemctl list-jobs) >>$logfile

sleep 4

if [ $(cat /var/log/hamonize/osInitJob.log | egrep 'reboot.target start' | wc -l) -ne 0 ]; then
    echo "user os reboot." >>$logfile
else
    echo "not reboot" >>$logfile
    sudo sed -i.bak "s@reboot -f@echo '__'@" /usr/bin/timeshift
    sleep 1
    echo \n * | sudo sudo timeshift --restore --snapshot "$BACKUP_NAME" --target "$DEVICE" --skip-grub --yes
fi
