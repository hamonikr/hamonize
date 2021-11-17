#!/usr/bin/env bash

#사용안함
SPLIT_GUBUN=`cat /etc/hamonize/security/security.hm | awk -F'=' '{print $1}'`
SPLIT_DATA=`cat /etc/hamonize/security/security.hm | awk -F'=' '{print $2}'`

BASE_DATA="FTP"

echo "Y" | ufw reset
#ufw disable
#ufw allow 5900


OLD_IFS=$IFS;
IFS=,;
for I in $SPLIT_DATA;
do


        if [ "$I" == "USB" ]; then chmod 700 /media
        else    chmod 755 /media
        fi


        if [ "$I" == "FTP" ]; then ufw deny 21
        else ufw allow 21
        fi

        if [ "$I" == "SSH" ]; then ufw deny 22
        else ufw allow 22
        fi

        if [ "$I" == "HTTP" ]; then ufw deny 80
        else ufw allow 80
        fi

        if [ "$I" == "HTTPS" ]; then ufw deny 443
        else ufw allow 443
        fi

        if [ "$I" == "POP3" ]; then ufw deny 110
        else ufw allow 110
        fi

        if [ "$I" == "IMAP" ]; then ufw deny 143
        else ufw allow 143
        fi

        if [ "$I" == "MYSQL" ]; then ufw deny 3306
        else ufw allow 3306
        fi




done;
IFS=$OLD_IFS

sudo ufw disable
sudo ufw status
sudo iptables -F
