[Unit]
Description=Run my custom task at shutdown only
DefaultDependencies=no
Conflicts=reboot.target
Before=poweroff.target halt.target shutdown.target
Requires=poweroff.target

[Service]
Type=oneshot
ExecStart=/home/aa/tmp.sh start
RemainAfterExit=yes

[Install]
WantedBy=shutdown.target


#!/bin/bash
# Run script with systemd at shutdown only

case $1 in
        start)
        systemctl list-jobs >> /home/aa/file
echo "000000000000000000000" >> /home/aa/file
        systemctl list-jobs | egrep -q 'reboot.target.*start' && echo "starting reboot" >> /home/aa/file
echo "111111111111111" >> /home/aa/file
        systemctl list-jobs | egrep -q 'shutdown.target.*start' && echo "starting shutdown" >> /home/aa/file
echo "22222222222222222222222222" >> /home/aa/file
        ;;

        stop)
echo "sssssssssssssssssstop" >> /home/aa/file
        systemctl list-jobs | egrep -q 'reboot.target.*start' || echo "stopping"  >> /home/aa/file
        ;;

esac





#!/bin/bash

shut_time=$(date --date='10 minutes' +"%T")

touch /home/ggg/ttt
cat /dev/null > /home/ggg/ttt
notify-send -t 600000 "INFO:
OS 초기화를 시작합니다.
초기화 진행 후 자동 종료됩니다.
Shutting down in 10 minutes (scheduled for $shut_time)."




DEVICE=`df -T|grep 'ext*' | awk '{print $1}'`
BACKUP_NAME=`timeshift --list | grep -e "init backup" | awk -F ' ' '{print $3}' | head -n 1`
#echo $DEVICE
#echo $BACKUP_NAME

echo $(/bin/systemctl list-jobs) >>  /home/ggg/ttt
#reboot.target start

sleep 4
if [ $( cat /home/ggg/ttt | egrep 'reboot.target start' | wc -l) -ne 0 ]; then
        echo "aaaaaabbbbbbbbbbbbbbbbbbbbbbbbbbbbb" >> /home/ggg/ttt
        echo "재부팅합니다." >> /home/ggg/ttt
        echo $DEVICE >>  /home/ggg/ttt
else
        echo "aaaaaaaaaaa222222222222222222222222aaaaaaaaaaaaaaA" >> /home/ggg/ttt
        echo \n * | sudo sudo timeshift --restore --snapshot "$BACKUP_NAME" --target "$DEVICE" --skip-grub --yes
fi


[Unit]
Description=Pre-Shutdown Processes
DefaultDependencies=no
Before=shutdown.target reboot.target halt.target
# This works because it is installed in the target and will be
#   executed before the target state is entered
# Also consider kexec.target

[Service]
Type=oneshot
ExecStart=/home/ggg/test.sh

[Install]
WantedBy=halt.target reboot.target shutdown.target
