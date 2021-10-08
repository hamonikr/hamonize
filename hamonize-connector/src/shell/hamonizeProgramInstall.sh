#!/bin/bash

. /etc/hamonize/propertiesJob/propertiesInfo.hm

DATETIME=$(date +'%Y-%m-%d %H:%M:%S')
LOGFILE="/var/log/hamonize/propertiesJob/propertiesJob.log"

WORK_PATH=$(dirname $(realpath $0))
echo $WORK_PATH >>$LOGFILE

# Agent ]
echo "$DATETIME] 1. agent install ================ [start]" >>$LOGFILE
sudo apt-get install hamonize-agent -y >/dev/null
echo "$DATETIME] agent install === [end]" >>$LOGFILE
sudo systemctl stop hamonize-agent.service
# ===================================================================================

sleep 2
#==== process-mngr ================================
#
echo "$DATETIME] 3. process-mngr install ============ [start]" >>$LOGFILE
sudo dpkg -i $WORK_PATH/hamonize-process-mngr-1.0.3_amd64.deb >>$LOGFILE

echo "$DATETIME] process-mngr install === [END]" >>$LOGFILE
echo "$DATETIME ] $(sudo service hamonize-process-mngr status)" >>$LOGFILE

sleep 2

#==== usb protect =================================================
echo "$DATETIME ] 4. usb protect install ============== [start]" >>$LOGFILE
cd $WORK_PATH/usb-lockdown
sudo make install >>$LOGFILE

sudo /etc/init.d/udev restart >>$LOGFILE

sleep 2
sudo /etc/init.d/udev status >>$LOGFILE
dpkg -l udev >>$LOGFILE
echo "$DATETIME ] 3. usb protect install ============== [END]" >>$LOGFILE
echo "$DATETIME ] udev rules check :: $(ls /etc/udev/rules.d/)" >>$LOGFILE

# ===================================================================================

#==== user loginout chk =================================================
echo "$DATETIME ] 5. user loginout install ============== [start]" >>$LOGFILE
cp $WORK_PATH/hamonize-logout.service /etc/systemd/system/
cp $WORK_PATH/hamonize-login.service /etc/systemd/system/
cp $WORK_PATH/run-script-on-boot.sh /etc/hamonize/

systemctl daemon-reload >>$LOGFILE
systemctl enable hamonize-login >>$LOGFILE
systemctl enable hamonize-logout >>$LOGFILE

echo "$DATETIME ] 5. user loginout install ============== [end]" >>$LOGFILE

#== timeshift =================================================
if [ $(dpkg-query -W | grep timeshift | wc -l) = 0 ]; then
    echo "$DATETIME ] 6.  timeshift install ============== [start]" >>$LOGFILE
    sudo apt-get install timeshift -y >>$LOGFILE
    echo "$DATETIME ] 6. timeshift install ============== [end]" >>$LOGFILE
fi

#== telegraf =================================================
if [ $(dpkg-query -W | grep telegraf | wc -l) = 0 ]; then
    echo "$DATETIME ] 6.  telegraf install ============== [start]" >>$LOGFILE
    wget https://dl.influxdata.com/telegraf/releases/telegraf_1.20.0-1_amd64.deb >>$LOGFILE
    sudo dpkg -i telegraf_1.20.0-1_amd64.deb >>$LOGFILE

    echo "$DATETIME ] 6. telegraf install ============== [end]" >>$LOGFILE

    echo "$DATETIME ] 6-1.  telegraf Setting  ============== [start]" >>$LOGFILE
    mv /etc/telegraf/telegraf.conf /etc/telegraf/telegraf.conf_bak
    
    PCUUID=`cat /etc/hamonize/uuid`

    echo '[agent]
    interval = "10s"
    round_interval = true
    metric_batch_size = 1000
    metric_buffer_limit = 10000
    collection_jitter = "0s"
    flush_interval = "10s"
    flush_jitter = "0s"
    precision = ""
    debug = false
    quiet = false
    logfile = ""
    hostname = ""
    omit_hostname = false
    [[outputs.influxdb_v2]]	
    urls = ["http://'${INFLUX_URL}'"]
    token = "'${INFLUX_TOKEN}'"
    organization = "'${INFLUX_ORG}'"
    bucket = "'${INFLUX_BUCKET}'"
    [[inputs.cpu]]
    percpu = true
    totalcpu = true
    collect_cpu_time = false
    report_active = false
    [[inputs.disk]]
    ignore_fs = ["tmpfs", "devtmpfs", "devfs", "overlay", "aufs", "squashfs"]
    [[inputs.diskio]]
    [[inputs.mem]]
    [[inputs.net]]
    [[inputs.processes]]
    [[inputs.swap]]
    [[inputs.system]]
    [global_tags]
    uuid = "'+PCUUID+'"
    ' >>/etc/telegraf/telegraf.conf

    sudo service telegraf restart
    echo "$DATETIME ] 6-1.  telegraf Setting  ============== [end]" >>$LOGFILE
fi
 
sleep 2
#== hamonize-user  =================================================
if [ $(dpkg-query -W | grep hamonize-user | wc -l) = 0 ]; then
    echo "$DATETIME ] 8.  hamonize-user install ============== [start]" >>$LOGFILE
    sudo apt-get install -y hamonize-user >>$LOGFILE
    echo "$DATETIME ] 8.  hamonize-user install ============== [end]" >>$LOGFILE

    echo "$DATETIME ] 8.  hamonize-user set auth key  ============== [start]" >>$LOGFILE

    # public key down
    wget -O /etc/hamonize/hamonize_public_key.pem "$CENTERURL"/getAgent/getpublickey --content-disposition
    sudo hamonize-cli authkeys import hamonize/public /etc/hamonize/hamonize_public_key.pem

    # config file down 
    wget -O /etc/hamonize/hamonize.json "$CENTERURL"/getAgent/getconfigfile --content-disposition
    sudo hamonize-cli config import /etc/hamonize/hamonize.json

    sudo hamonize-cli service restart
    
fi
