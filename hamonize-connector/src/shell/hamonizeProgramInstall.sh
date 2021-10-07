#!/bin/bash

. /etc/hamonize/propertiesJob/propertiesInfo.hm

DATETIME=$(date +'%Y-%m-%d %H:%M:%S')
# program install  ===========
LOGFILE="/var/log/hamonize/propertiesJob/propertiesJob.log"

WORK_PATH=$(dirname $(realpath $0))
echo $WORK_PATH >>$LOGFILE

# Agent ]
echo "$DATETIME] 1. agent install ================ [start]" >>$LOGFILE
# sudo dpkg -i  $WORK_PATH/hamonize-agent_1.0.1_amd64.deb  >> $LOGFILE
sudo apt-get install hamonize-agent -y >/dev/null
echo "$DATETIME] agent install === [end]" >>$LOGFILE
# echo "$DATETIME ]agent status `sudo systemctl status hamonize-agent`" >> $LOGFILE
sudo systemctl stop hamonize-agent.service
# ===================================================================================

# collect]
# echo "$DATETIME ] 2-1. collectd install ================= [start]" >>$LOGFILE
# sudo apt-get install collectd -y >>$LOGFILE
# echo "$DATETIME ] collectd install === [end]" >>$LOGFILE
# echo "$DATETIME ] $(sudo service collectd status)" >>$LOGFILE
# # echo "$DATETIME ] collectd  install status `dpkg -l collectd`" >> $LOGFILE

# ===================================================================================

# sleep 2

# # collectd setting ========================================================
# echo "$DATETIME ] 2-2. collectd setting ================= [start]" >>$LOGFILE
# INFOHM="/etc/hamonize/propertiesJob/propertiesInfo.hm"
# COLLECTDIP=$(cat $INFOHM | grep COLLECTDIP | awk -F '=' '{print $2}')
# sudo mv /etc/collectd/collectd.conf /etc/collectd/collectd.conf_bak
# sudo cp $WORK_PATH/collectd.conf /etc/collectd/
# sudo sed -i "s/changeip/$COLLECTDIP/" /etc/collectd/collectd.conf

# sudo /etc/init.d/collectd restart >/dev/null
# sleep 2

# echo "$DATETIME ] $(sudo service collectd status)" >>$LOGFILE

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

# systemctl enable hamonize-login >>$LOGFILE
# systemctl start hamonize-logout >>$LOGFILE
# systemctl start hamonize-login >>$LOGFILE
# /etc/hamonize/run-script-on-boot.sh login
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
    sudo apt-get install -y hamonize-user #>>$LOGFILE
    echo "$DATETIME ] 8.  hamonize-user install ============== [end]" >>$LOGFILE

    echo "$DATETIME ] 8.  hamonize-user set auth key  ============== [start]" >>$LOGFILE

    # public key down
    wget -O /etc/hamonize/ttkey_public_key.pem "$CENTERURL"/getAgent/getpublickey --content-disposition
    sudo hamonize-cli authkeys import ttkey/public /etc/hamonize/ttkey_public_key.pem

    # config file down 
    wget -O /etc/hamonize/hamonize.json "$CENTERURL"/getAgent/getconfigfile --content-disposition
    sudo hamonize-cli config import /etc/hamonize/hamonize.json

    sudo hamonize-cli service restart
    
fi

# sleep 2

# agent auto upgrade service]
# cp $WORK_PATH/vpn-agent.service /lib/systemd/system/
# cp $WORK_PATH/vpn-auto-agent.sh /etc/hamonize/

# systemctl daemon-reload >>$LOGFILE
# systemctl enable vpn-agent >>$LOGFILE
# systemctl start vpn-agent >>$LOGFILE

# ===================================================================================

# START] package info upload =========================
# PACK_FOLDER="/tmp"
# INFOHM="/etc/hamonize/propertiesJob/propertiesInfo.hm"
# CENTERURL=`cat $INFOHM | grep CENTERURL | awk -F '=' '{print $2}'`
# echo "CENTERURL===>$CENTERURL"
# PACKAGECENTERURL="http://$CENTERURL/hmsvc/getPackageInfo"

# PCUUID=`cat /etc/hamonize/uuid`

# echo "=====installed_packages.json remove ====================" >> $LOGFILE
# rm -fr /tmp/installed_packages.json
# rm -fr /tmp/packagelist.json
# sleep 1

# echo "=====installed_packages.json create ====================">> $LOGFILE
# echo "===work path ===$WORK_PATH" >> $LOGFILE

# touch /tmp/installed_packages.json
# touch /tmp/packagelist.json

# echo  {\"events\": [ > /tmp/installed_packages.json
# dpkg-query -W -f '{"pcuuid":"pcuuidval","name":"${binary:Package}","version":"${Version}","short_description":"${Depends}","status":"${db:Status-Status}"}, \n'  | tr -d ' ' >> /tmp/installed_packages.json
# echo ] }>> /tmp/installed_packages.json
# echo "PCUUID====$PCUUID" >> $LOGFILE
# echo "=====installed_packages.json uuid update ====================">> $LOGFILE
# sed "s/pcuuidval/${PCUUID}/" /tmp/installed_packages.json  > /tmp/packagelist.json
# PACKAGE_JSON=`cat /tmp/packagelist.json `
# echo "PACKAGE_JSON===$PACKAGE_JSON" >> $LOGFILE
# RET=`curl  -X  POST -H 'User-Agent: HamoniKR OS' -H 'Content-Type: application/json ' -s -d @/tmp/packagelist.json $PACKAGECENTERURL`

# rm -fr  /tmp/installed_packages.json
# rm -fr /tmp/packagelist.json

# END] package info upload =========================

echo "RETRETRET==============+$RET" >>$LOGFILE
echo $RET >>$LOGFILE
