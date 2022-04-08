#!/bin/bash

. /etc/hamonize/propertiesJob/propertiesInfo.hm

CENTER_BASE_URL="$1"
DOMAININFO="$2"

DATETIME=$(date +'%Y-%m-%d %H:%M:%S')
LOGFILE="/var/log/hamonize/propertiesJob/propertiesJob.log"

WORK_PATH=$(dirname $(realpath $0))
echo $WORK_PATH >>$LOGFILE

# Ldap 사용시 셋팅
LDAPInfo=$(curl -s "$CENTER_BASE_URL/hmsvc/getTenantRemoteConfig?gubun=ldapyn&domain=$DOMAININFO")
Ldap_used=$(echo $LDAPInfo | awk -F ":" '{print $1}')
Ldap_ip=$(echo $LDAPInfo | awk -F ":" '{print $2}')

if [ $Ldap_used -eq "Y" ]; then
    echo "Ldap use && Ldap setting" >>$LOGFILE

    echo -e " \
    ldap-auth-config ldap-auth-config/dbrootlogin boolean true
    ldap-auth-config ldap-auth-config/pam_password select md5
    ldap-auth-config ldap-auth-config/move-to-debconf boolean true
    ldap-auth-config ldap-auth-config/ldapns/ldap-server string ldap://$Ldap_ip
    ldap-auth-config ldap-auth-config/ldapns/base-dn string ou=$DOMAININFO,dc=hamonize,dc=com
    ldap-auth-config ldap-auth-config/rootbinddn    string    cn=admin,dc=hamonize,dc=com
    ldap-auth-config ldap-auth-config/rootbindpw    password admin
    ldap-auth-config ldap-auth-config/override boolean true
    ldap-auth-config ldap-auth-config/ldapns/ldap_version select 3
    ldap-auth-config ldap-auth-config/dblogin boolean false \
    " | debconf-set-selections

    # if [ -f /tmp/debconf-ldap-preseed.txt ]; then

    # cat /tmp/debconf-ldap-preseed.txt | debconf-set-selections
    DEBIAN_FRONTEND=noninteractive aptitude install -y -q ldap-auth-client nscd

    ## Add /etc/pam.d/common-session
    sed -i '$ i\session required pam_mkhomedir.so skel=/etc/skel umask=0022\' /etc/pam.d/common-session

    ## update /etc/pam.d/common-passwd
    sed -i 's/use_authtok//g' /etc/pam.d/common-passwd

    ## nsswitch.conf
    mv /etc/nsswitch.conf /etc/nsswitch.conf_bak
    echo -e "\
        passwd:         files systemd ldap
        group:          files systemd ldap
        shadow:         files ldap
        gshadow:        files

        hosts:          files mdns4_minimal [NOTFOUND=return] dns myhostname
        networks:       files

        protocols:      db files
        services:       db files
        ethers:         db files
        rpc:            db files

        netgroup:       nis
        " >/etc/nsswitch.conf

    ## sudo settings
    sudo su <<EOF
export SUDO_FORCE_REMOVE=yes
apt-get install sudo-ldap -y
export SUDO_FORCE_REMOVE=no
EOF

    echo "sudoers:            files ldap" >>    /etc/nsswitch.conf
    echo "SUDOERS_BASE    ou=SUDOers,ou=$DOMAININFO,dc=hamonize,dc=com" >> /etc/ldap.conf
    sudo ln -s /etc/ldap.conf /etc/sudo-ldap.conf

    DEBIAN_FRONTEND=noninteractive pam-auth-update
    systemctl restart nscd


    # else
    #     echo -e "Where the debconf-ldap-preseed.txt ??\n"
    # fi

fi

sleep 2

# Agent ] =================================================
echo "$DATETIME] 1. agent install ================ [start]" >>$LOGFILE
# sudo apt-get install hamonize-agent -y >/dev/null

sudo dpkg -i $WORK_PATH/temp_cloud_dpkg/hamonize-agent_1.1.1_amd64.deb >>$LOGFILE

echo "$DATETIME] agent install === [end]" >>$LOGFILE
sudo systemctl stop hamonize-agent.service
# ===================================================================================

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
    wget -P /tmp https://dl.influxdata.com/telegraf/releases/telegraf_1.20.0-1_amd64.deb >>$LOGFILE
    sudo dpkg -i /tmp/telegraf_1.20.0-1_amd64.deb >>$LOGFILE

    echo "$DATETIME ] 6. telegraf install ============== [end]" >>$LOGFILE

    echo "$DATETIME ] 6-1.  telegraf Setting  ============== [start]" >>$LOGFILE
    mv /etc/telegraf/telegraf.conf /etc/telegraf/telegraf.conf_bak

    PCUUID=$(cat /etc/hamonize/uuid)

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
    uuid = "'${PCUUID}'" 
    domain = "'${DOMAININFO}'"
    ' >>/etc/telegraf/telegraf.conf

    sudo service telegraf restart
    echo "$DATETIME ] 6-1.  telegraf Setting  ============== [end]" >>$LOGFILE
fi

sleep 2
#== hamonize-user  =================================================
if [ $(dpkg-query -W | grep hamonize-user | wc -l) = 0 ]; then
    echo "$DATETIME ] 8.  hamonize-user install ============== [start]" >>$LOGFILE

    # TENANT=$(cat /etc/hamonize/hamonize_tanent)
    mkdir -p /etc/hamonize/keys

    TENANT_CONFIG=$(curl -s "$CENTER_BASE_URL/hmsvc/getTenantRemoteConfig?gubun=config&domain=$DOMAININFO")
    echo -e ${TENANT_CONFIG} | jq >/etc/hamonize/hamonize.json

    TENANT_PRIKEY=$(curl -s "$CENTER_BASE_URL/hmsvc/getTenantRemoteConfig?gubun=prikey&domain=$DOMAININFO")

    echo -e "-----BEGIN PRIVATE KEY-----\n" ${TENANT_PRIKEY} "\n-----END PRIVATE KEY-----" >/etc/hamonize/keys/private/hamonize_private_key.pem

    TENANT_PUBKEY=$(curl -s "$CENTER_BASE_URL/hmsvc/getTenantRemoteConfig?gubun=pubkey&domain=$DOMAININFO")
    echo -e "-----BEGIN PUBLIC KEY-----\n" ${TENANT_PUBKEY} "\n-----END PUBLIC KEY-----" >/etc/hamonize/keys/public/hamonize_public_key.pem

    # Check hamonize-user.deb file in hamonize apt repository
    # CHK_HAMONIZE_REMOTE=$(apt list 2>/dev/null | grep hamonize-user | wc -l)
    # echo "chk Hamonize apt repository ====${CHK_HAMONIZE_REMOTE}" >>$LOGFILE

    #  Case  OpenOS  (Download by Git repository )
    # if [ $CHK_HAMONIZE_REMOTE = 0 ]; then

    # dependany install
    apt-get install libqca-qt5-2-plugins -y
    apt-get install libfakekey0 -y
    apt-get install libqca-qt5-2 -y

    OSGUBUN=$(lsb_release -i | awk -F : '{print $2}' | tr [:lower:] [:upper:] | tr -d '\t')
    if [ "${OSGUBUN}" = "HAMONIKR" ] || [ "${OSGUBUN}" = "LINUXMINT" ] || [ "${OSGUBUN}" = "UBUNTU" ]; then
        JSONDATA=$(curl -s https://api.github.com/repos/hamonikr/hamonize/releases/latest | jq '.assets[] | select(.browser_download_url |test("^.*hamonize-user.*amd.*deb$")) .browser_download_url')
        JSONDATA=${JSONDATA#\"}
        JSONDATA=${JSONDATA%\"}
        wget -P /tmp ${JSONDATA} >>$LOGFILE
        sudo dpkg -i /tmp/hamonize-user*.deb >>$LOGFILE
        # sudo apt-get install -y hamonize-user >>$LOGFILE
    elif [ "${OSGUBUN}" = "DEBIAN" ]; then
        JSONDATA=$(curl -s https://api.github.com/repos/hamonikr/hamonize/releases/latest | jq -r '.assets[] | select(.browser_download_url |test("^.*hamonize-user.*debian.*deb$")) .browser_download_url')
        JSONDATA=${JSONDATA#\"}
        JSONDATA=${JSONDATA%\"}
        wget -P /tmp ${JSONDATA#\"} >>$LOGFILE
        sudo dpkg -i /tmp/hamonize-user*.deb >>$LOGFILE
    elif [ "${OSGUBUN}" = "GOOROOM" ]; then
        JSONDATA=$(curl -s https://api.github.com/repos/hamonikr/hamonize/releases/latest | jq -r '.assets[] | select(.browser_download_url |test("^.*hamonize-user.*gooroom.*deb$")) .browser_download_url')
        JSONDATA=${JSONDATA#\"}
        JSONDATA=${JSONDATA%\"}
        wget -P /tmp ${JSONDATA#\"} >>$LOGFILE
        sudo dpkg -i /tmp/hamonize-user*.deb >>$LOGFILE

    # Download APT Repository
    else
        sudo apt-get install -y hamonize-user >>$LOGFILE
    fi

    echo "$DATETIME ] 8.  hamonize-user install ============== [end]" >>$LOGFILE
    sleep 1

    # echo "$DATETIME ] 8.  hamonize-user set auth key  ============== [start]" >>$LOGFILE
    # hamonize-user&admin Keys Check -----------------------------#
    HAMONIZE_AUTH_KEY_COUNT=$(hamonize-cli authkeys list | wc -l)
    if [ $(ls /etc/hamonize/keys | wc -l) ] >1; then
        echo "#### hamonize-user & admin keys exist ####"
        for i in $(hamonize-cli authkeys list); do
            echo "delete keys ===>"$i
            hamonize-cli authkeys delete $i
        done
    fi

    # # admin settings ------------------------------------------------------------------------------------#
    # hamonize-cli authkeys import hamonize-key/public /etc/hamonize/keys/public/hamonize_public_key.pem
    # hamonize-cli authkeys import hamonize-key/private /etc/hamonize/keys/private/hamonize_private_key.pem

    # HOME_USER=$1
    # hamonize-cli authkeys setaccessgroup hamonize-key/public $HOME_USER
    # hamonize-cli authkeys setaccessgroup hamonize-key/private $HOME_USER
    # hamonize-cli config import /etc/hamonize/hamonize.json

    # hamonize-cli service restart

    # user settings (일반사용자는 public key만 필요함) ------------------------------------------------#
    hamonize-cli authkeys import hamonize-key/public /etc/hamonize/keys/public/hamonize_public_key.pem

    HOME_USER=$1
    hamonize-cli authkeys setaccessgroup hamonize-key/public $HOME_USER
    hamonize-cli config import /etc/hamonize/hamonize.json

    hamonize-cli service restart
fi

sleep 2
##==== 서버 정보 저장(domain,ip etc)===================================
##==== crontab reboot으로 부팅시마다 서버 정보를 파일로 저장한다.==============
IPADDR_SPLIT=($(echo $CENTER_BASE_URL | tr "/" "\n"))
sudo cp -r $WORK_PATH/hamonizeInitJob.sh /etc/hamonize/propertiesJob

sudo sed -i "s/CHANGE_CENTERURL/http:\/\/${IPADDR_SPLIT[1]}/" /etc/hamonize/propertiesJob/hamonizeInitJob.sh

sudo sed -i '/@reboot/d' /etc/crontab
sudo sed -i '$s/$/\n\@reboot root  \/etc\/hamonize\/propertiesJob\/hamonizeInitJob.sh/g' /etc/crontab
