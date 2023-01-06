#!/bin/bash

. /etc/hamonize/propertiesJob/propertiesInfo.hm

CENTER_BASE_URL="$1"
DOMAININFO="$2"
HOME_USERID="$3"

DATETIME=$(date +'%Y-%m-%d %H:%M:%S')
LOGFILE="/var/log/hamonize/propertiesJob/propertiesJob.log"

WORK_PATH=$(dirname $(realpath $0))

retval=-1

deviceSettings() {
    retval=-1
    echo "$DATETIME ] 4. usb protect install ============== [start]" >>$LOGFILE
    cd $WORK_PATH/usb-lockdown
    sudo make install >>$LOGFILE
    
    sudo /etc/init.d/udev restart >>$LOGFILE
    
    sleep 2
    sudo /etc/init.d/udev status >>$LOGFILE
    
    if [ -f /etc/udev/rules.d/30-usb-lockdown.rules ]; then
        retval=0
        
        echo "$DATETIME ] 3. usb protect install ============== [END]" >>$LOGFILE
        echo "$DATETIME ] udev rules check :: $(ls /etc/udev/rules.d/)" >>$LOGFILE
        
    else
        retval=1
        
        echo "$DATETIME ] 3. usb protect install Fail  " >>$LOGFILE
        
        echo "##################################################################" >>$LOGFILE
        echo "####### ERROR] Udev Settings Fail (error-code: 1942-USB)  ####### " >>$LOGFILE
        echo "##################################################################" >>$LOGFILE
        echo "" >>$LOGFILE
        
        echo "#----------------------------------------------------------------#" >>$LOGFILE
        echo "#- Chechk Point 1. Install Package [udev] Check ------------------------#" >>$LOGFILE
        dpkg -l udev >>$LOGFILE
        echo "" >>$LOGFILE
        
        echo "#- Chechk Point 2. Udev Ruls File Check  ------------------------#" >>$LOGFILE
        echo "$(ls /etc/udev/rules.d/)" >>$LOGFILE
        echo "" >>$LOGFILE
        
    fi
    
    return $retval
}

osLoginoutSettings() {
    retval=-1
    echo "$DATETIME ] 5. user loginout install ============== [start]" >>$LOGFILE
    cp $WORK_PATH/hamonize-logout.service /etc/systemd/system/
    cp $WORK_PATH/hamonize-login.service /etc/systemd/system/
    cp $WORK_PATH/run-script-on-boot.sh /etc/hamonize/
    
    systemctl daemon-reload >>$LOGFILE
    systemctl enable hamonize-login >>$LOGFILE
    systemctl enable hamonize-logout >>$LOGFILE
    
    echo "$DATETIME ] 5. user loginout install ============== [end]" >>$LOGFILE
    
    # if [ $(systemctl list-units --type=service --no-pager | grep -e "hamonize-log*" | wc -l) = 2 ]; then
    if [ $(systemctl list-unit-files --type=service | egrep "hamonize-log*" | wc -l) = 2 ]; then
        retval=0
    else
        retval=1
        
        echo "##################################################################" >>$LOGFILE
        echo "####### ERROR] Hamonize-loginout Settings Fail (error-code: 1942-OSLOGINOUT)  ####### " >>$LOGFILE
        echo "##################################################################" >>$LOGFILE
        echo "" >>$LOGFILE
        
        echo "#----------------------------------------------------------------#" >>$LOGFILE
        echo "#- Chechk Point 1. login Service Status -------------------------#" >>$LOGFILE
        service hamonize-login status >>$LOGFILE
        echo "" >>$LOGFILE
        
        echo "#----------------------------------------------------------------#" >>$LOGFILE
        echo "#- Chechk Point 2. logout Service Status ------------------------#" >>$LOGFILE
        service hamonize-logout status >>$LOGFILE
        echo "" >>$LOGFILE
        
        echo "#----------------------------------------------------------------#" >>$LOGFILE
        echo "#- Chechk Point 3. login Service  -------------------------------#" >>$LOGFILE
        systemctl list-units --all --type=service --no-pager | grep -e hamonize-login >>$LOGFILE
        echo "" >>$LOGFILE
        
        echo "#----------------------------------------------------------------#" >>$LOGFILE
        echo "#- Chechk Point 4. logout Service  ------------------------------#" >>$LOGFILE
        systemctl list-units --all --type=service --no-pager | grep -e hamonize-logout >>$LOGFILE
        echo "" >>$LOGFILE
        
    fi
    return $retval
    
}

hamonizeServerSettings() {
    IPADDR_SPLIT=($(echo $CENTER_BASE_URL | tr "/" "\n"))
    sudo cp -r $WORK_PATH/hamonizeInitJob.sh /etc/hamonize/propertiesJob
    sudo sed -i "s/CHANGE_CENTERURL/https:\/\/${IPADDR_SPLIT[1]}/" /etc/hamonize/propertiesJob/hamonizeInitJob.sh
    # sudo sed -i '/@reboot/d' /etc/crontab
    
    chkCronTab=$(cat /etc/crontab | grep -e "hamonizeInitJob" | wc -l)
    if [ "0" == "$chkCronTab" ]; then
        sudo sed -i '$s/$/\n\@reboot root sleep 60 \&\& \/etc\/hamonize\/propertiesJob\/hamonizeInitJob.sh/g' /etc/crontab
    fi
    
}

hamonizeHelpSettings() {
    
    echo "$DATETIME] 1. Hamonize Help Application Install ================ [start]" >>$LOGFILE
    sudo apt-get install hamonize-help -y >/dev/null
    
    PKG_OK=$(dpkg-query -W --showformat='${Status}\n' hamonize-help | grep "install ok installed")
    if [ "" = "$PKG_OK" ]; then
        
        echo "$DATETIME] Hamonize Help Application Install Fail > Error Check LogFile Location is /tmp/hm_help.error===" >>$LOGFILE
        
        echo "##################################################################" >>$LOGFILE
        echo "####### ERROR] HAMONIZE_HELP Settings Fail (error-code: 1942-HAMONIZE_HELP)  ####### " >>$LOGFILE
        echo "##################################################################" >>$LOGFILE
        echo "" >>$LOGFILE
        
        echo "# Hamonize-Admin Exception Another Case ------------------------------#" >>$LOGFILE
        echo "result -> [$(dpkg -l hamonize-help)]" >>$LOGFILE
        echo "" >>$LOGFILE
        return 1
    else
        echo "$DATETIME] Hamonize Help Application Install === [end]" >>$LOGFILE
        return 0
    fi
    
}

remoteToolSettings() {
    retval=-1
    #== Hamonize Remote Tool  =================================================
    # if [ $(dpkg-query -W | grep hamonize-admin | wc -l) = 0 ]; then
    echo "$DATETIME ] 8.  Hamonize Remote Tool install ============== [start]" >>$LOGFILE
    
    # TENANT=$(cat /etc/hamonize/hamonize_tanent)
    mkdir -p /etc/hamonize/keys/public
    mkdir -p /etc/hamonize/keys/private
    
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
    apt-get install libqca-qt5-2-plugins -y >>$LOGFILE
    apt-get install libfakekey0 -y >>$LOGFILE
    apt-get install libqca-qt5-2 -y >>$LOGFILE
    apt-get install -y libldap-2.4-2 libssl1.1 >>$LOGFILE
    apt-get install -y libqt5dbus5 libqt5gui5 libqt5network5 libqt5widgets5 libssl1.1 >>$LOGFILE
    
    wget -P /tmp https://pkg.hamonikr.org/pool/main/q/qtbase-abi-5-12-8/qtbase-abi-5-12-8_1.0_all.deb >>$LOGFILE
    dpkg -i /tmp/qtbase*.deb >>$LOGFILE
    
    OSGUBUN=$(lsb_release -i | awk -F : '{print $2}' | tr [:lower:] [:upper:] | tr -d '\t')
    if [ "${OSGUBUN}" = "HAMONIKR" ] || [ "${OSGUBUN}" = "LINUXMINT" ] || [ "${OSGUBUN}" = "UBUNTU" ]; then
        JSONDATA=$(curl -s https://api.github.com/repos/hamonikr/hamonize/releases/latest | jq '.assets[] | select(.browser_download_url |test("^.*hamonize-admin.*amd.*deb$")) .browser_download_url')
        # JSONDATA=$(curl -s https://api.github.com/repos/hamonikr/hamonize/releases/latest | jq '.assets[] | select(.browser_download_url |test("^.*hamonize-user.*amd.*deb$")) .browser_download_url')
        JSONDATA=${JSONDATA#\"}
        JSONDATA=${JSONDATA%\"}
        wget -P /tmp ${JSONDATA} >>$LOGFILE
        sudo dpkg -i /tmp/hamonize-admin*.deb >>$LOGFILE
        # sudo dpkg -i /tmp/hamonize-user*.deb >>$LOGFILE
        # sudo apt-get install -y hamonize-user >>$LOGFILE
        elif [ "${OSGUBUN}" = "DEBIAN" ]; then
        JSONDATA=$(curl -s https://api.github.com/repos/hamonikr/hamonize/releases/latest | jq -r '.assets[] | select(.browser_download_url |test("^.*hamonize-admin.*debian.*deb$")) .browser_download_url')
        # JSONDATA=$(curl -s https://api.github.com/repos/hamonikr/hamonize/releases/latest | jq -r '.assets[] | select(.browser_download_url |test("^.*hamonize-user.*debian.*deb$")) .browser_download_url')
        JSONDATA=${JSONDATA#\"}
        JSONDATA=${JSONDATA%\"}
        wget -P /tmp ${JSONDATA#\"} >>$LOGFILE
        sudo dpkg -i /tmp/hamonize-admin*.deb >>$LOGFILE
        # sudo dpkg -i /tmp/hamonize-user*.deb >>$LOGFILE
        elif [ "${OSGUBUN}" = "GOOROOM" ]; then
        JSONDATA=$(curl -s https://api.github.com/repos/hamonikr/hamonize/releases/latest | jq -r '.assets[] | select(.browser_download_url |test("^.*hamonize-admin.*gooroom.*deb$")) .browser_download_url')
        # JSONDATA=$(curl -s https://api.github.com/repos/hamonikr/hamonize/releases/latest | jq -r '.assets[] | select(.browser_download_url |test("^.*hamonize-user.*gooroom.*deb$")) .browser_download_url')
        JSONDATA=${JSONDATA#\"}
        JSONDATA=${JSONDATA%\"}
        wget -P /tmp ${JSONDATA#\"} >>$LOGFILE
        sudo dpkg -i /tmp/hamonize-admin*.deb >>$LOGFILE
        # sudo dpkg -i /tmp/hamonize-user*.deb >>$LOGFILE
        
        # Download APT Repository
    else
        sudo apt-get install -y hamonize-admin >>$LOGFILE
        # sudo apt-get install -y hamonize-user >>$LOGFILE
    fi
    
    echo "$DATETIME ] 8.  Hamonize Remote Tool install ============== [end]" >>$LOGFILE
    sleep 1
    
    # echo "$DATETIME ] 8.  hamonize-user set auth key  ============== [start]" >>$LOGFILE
    # hamonize-user&admin Keys Check -----------------------------#
    HAMONIZE_AUTH_KEY_COUNT=$(hamonize-cli authkeys list | wc -l)
    if [ $(ls /etc/hamonize/keys | wc -l) ] >1; then
        for i in $(hamonize-cli authkeys list); do
            hamonize-cli authkeys delete $i >>$LOGFILE
        done
    fi
    
    # # admin settings ------------------------------------------------------------------------------------#
    hamonize-cli authkeys import hamonize-key/public /etc/hamonize/keys/public/hamonize_public_key.pem >>$LOGFILE
    hamonize-cli authkeys import hamonize-key/private /etc/hamonize/keys/private/hamonize_private_key.pem >>$LOGFILE
    
    HOME_USER=$HOME_USERID
    
    hamonize-cli authkeys setaccessgroup hamonize-key/public $HOME_USER >>$LOGFILE
    hamonize-cli authkeys setaccessgroup hamonize-key/private $HOME_USER >>$LOGFILE
    hamonize-cli config import /etc/hamonize/hamonize.json >>$LOGFILE
    
    hamonize-cli service restart >>$LOGFILE
    
    rm -fr /usr/share/applications/hamonize-master.desktop
    rm -fr /usr/share/applications/hamonize-configurator.desktop
    
    # user settings (일반사용자는 public key만 필요함) ------------------------------------------------#
    # hamonize-cli authkeys import hamonize-key/public /etc/hamonize/keys/public/hamonize_public_key.pem
    
    # HOME_USER=$1
    # hamonize-cli authkeys setaccessgroup hamonize-key/public $HOME_USER
    # hamonize-cli config import /etc/hamonize/hamonize.json
    
    # hamonize-cli service restart
    # fi
    
    # if [ $(dpkg-query -W | grep hamonize-admin | wc -l) -ne 1 ]; then
    #     return 1
    # fi
    # if [ $(hamonize-cli authkeys list | wc -l) -lt 1 ]; then
    #     return 2
    # fi
    
    # xdg session type check
    OSGUBUN=$(lsb_release -i | awk -F : '{print $2}' | tr [:lower:] [:upper:] | tr -d '\t')
    if [ "${OSGUBUN}" = "UBUNTU" ]; then
        sudo sed -i '/daemon]/aWaylandEnable=false' /etc/gdm3/custom.conf
        sudo sed -i '/daemon]/aDefaultSession=gnome-xorg.desktop' /etc/gdm3/custom.conf
    fi
    
    PKG_OK=$(dpkg-query -W --showformat='${Status}\n' hamonize-admin | grep "install ok installed")
    if [ "" = "$PKG_OK" ]; then
        
        echo "##################################################################" >>$LOGFILE
        echo "####### ERROR] HAMONIZE_ADMIN-TOOL Settings Fail (error-code: 1942-HAMONIZE_ADMIN-TOOL)  ####### " >>$LOGFILE
        echo "##################################################################" >>$LOGFILE
        echo "" >>$LOGFILE
        
        echo "#----------------------------------------------------------------#" >>$LOGFILE
        echo "#- Chechk Point 1. Install Package [HAMONIZE_ADMIN] Check ------------------------#" >>$LOGFILE
        echo "result -> [$(dpkg -l hamonize-admin)]" >>$LOGFILE
        echo "" >>$LOGFILE
        
        echo "#----------------------------------------------------------------#" >>$LOGFILE
        echo "#- Chechk Point 2. Install deb file Check ------------------------#" >>$LOGFILE
        echo "result -> [$(ls /tmp/hamonize-admin*.deb)]" >>$LOGFILE
        echo "" >>$LOGFILE
        
        return 3
        
        elif [ $(hamonize-cli authkeys list | wc -l) -lt 1 ]; then
        
        echo "##################################################################" >>$LOGFILE
        echo "####### ERROR] HAMONIZE_ADMIN-TOOL Settings Fail (error-code: 1942-HAMONIZE_ADMIN-KEY)  ####### " >>$LOGFILE
        echo "##################################################################" >>$LOGFILE
        echo "" >>$LOGFILE
        
        echo "#----------------------------------------------------------------#" >>$LOGFILE
        echo "#- Chechk Point 1. Install Package [HAMONIZE_ADMIN] Check ------------------------#" >>$LOGFILE
        echo "result -> [$(hamonize-cli authkeys list)] , key conut is [$(hamonize-cli authkeys list | wc -l)]" >>$LOGFILE
        echo "" >>$LOGFILE
        
        return 2
    else
        return 0
    fi
    
}

ldapSettings() {
    retval=-1
    # Ldap 사용시 셋팅
    
    LDAPInfo=$(curl -s "$CENTER_BASE_URL/hmsvc/getTenantRemoteConfig?gubun=ldapyn&domain=$DOMAININFO")
    Ldap_used=$(echo $LDAPInfo | awk -F ":" '{print $1}')
    Ldap_ip=$(echo $LDAPInfo | awk -F ":" '{print $2}')
    
    if [ "$Ldap_used" == "Y" ]; then
        echo "$DATETIME ] 8.  Hamonize Ldap Settings &install ============== [start]" >>$LOGFILE
        
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
        DEBIAN_FRONTEND=noninteractive apt install -y -q ldap-auth-client nscd >/dev/null
        # DEBIAN_FRONTEND=noninteractive aptitude install -y -q ldap-auth-client nscd >/dev/null
        
        ## Add /etc/pam.d/common-session
        
        # sed -i '/session required pam_mkhomedir.so /d' /etc/pam.d/common-session  // 중복 설치한경우 ...
        # sed -i '$ i\session required pam_mkhomedir.so skel=/etc/skel umask=0022\' /etc/pam.d/common-session   ldap 사용자 홈폴더 생성
        if [ $(grep -rn 'session required pam_mkhomedir.so' /etc/pam.d/common-session | wc -l) = 0 ]; then
            sed -i '$ i\session required pam_mkhomedir.so skel=/etc/skel umask=0022\' /etc/pam.d/common-session
        fi
        
        ## update /etc/pam.d/common-passwd
        sed -i 's/use_authtok//g' /etc/pam.d/common-password
        
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
apt-get install sudo-ldap -y > /dev/null
export SUDO_FORCE_REMOVE=no
EOF
        
        echo "sudoers:            files ldap" >>/etc/nsswitch.conf
        
        if [ $(grep -rn 'SUDOERS_BASE    ou=SUDOers' /etc/ldap.conf | wc -l) = 0 ]; then
            echo "SUDOERS_BASE    ou=SUDOers,ou=$DOMAININFO,dc=hamonize,dc=com" >>/etc/ldap.conf
        fi
        
        if [ -f /etc/sudo-ldap.conf ]; then
            rm -fr /etc/sudo-ldap.conf
        fi
        sudo ln -s /etc/ldap.conf /etc/sudo-ldap.conf
        
        DEBIAN_FRONTEND=noninteractive pam-auth-update >/dev/null 2>&1
        systemctl restart nscd >/dev/null 2>&1
        
        # else
        #     echo -e "Where the debconf-ldap-preseed.txt ??\n"
        # fi
        
    fi
    
    sleep 2
    
    PKG_OK=$(dpkg-query -W --showformat='${Status}\n' ldap-auth-client | grep "install ok installed")
    
    if [ "" = "$PKG_OK" ]; then
        echo "$DATETIME ] 8.  Hamonize Ldap Settings &install ============== [Fail-install error]" >>$LOGFILE
        retval=1
    else
        strBase_ChkFile="/etc/ldap.conf"
        strTarget_ChkFile=$(readlink -f /etc/sudo-ldap.conf)
        
        if [ "$strBase_ChkFile" == "$strTarget_ChkFile" ]; then
            retval=0
            echo "$DATETIME ] 8.  Hamonize Ldap Settings &install ============== [END]" >>$LOGFILE
        else
            echo "$DATETIME ] 8.  Hamonize Ldap Settings &install ============== [Fail-etc]" >>$LOGFILE
            retval=2
        fi
        
    fi
    
    if [ 0 != "$retval" ]; then
        echo "$DATETIME ] 8.  Hamonize Ldap Settings &install ============== [FAIL, $retval ]  >  Error Check LogFile Location is /tmp/hm_ldap.error" >>$LOGFILE
        
        echo "##################################################################" >>$LOGFILE
        echo "####### ERROR] Ldap Settings Fail (error-code: 1942-ldap)  ####### " >>$LOGFILE
        echo "##################################################################" >>$LOGFILE
        echo "" >>$LOGFILE
        
        echo "#----------------------------------------------------------------#" >>$LOGFILE
        echo "#- Chechk Point 1. Install Check ------------------------#" >>$LOGFILE
        echo "#- Chechk Point 1-1. Package [ldap-auth-client]  ------------------------#" >>$LOGFILE
        echo "result -> [$(dpkg -l ldap-auth-client)]" >>$LOGFILE
        echo "" >>$LOGFILE
        
        echo "#- Check Point 1-2. Package [nscd] ------------------------#" >>$LOGFILE
        echo "result -> [$(dpkg -l nscd)]" >>$LOGFILE
        echo "" >>$LOGFILE
        
        echo "#- Check Porint 1-3. Package [sudo-ldap] ------------------------#" >>$LOGFILE
        echo "result -> [$(dpkg -l sudo-ldap)]" >>$LOGFILE
        echo "" >>$LOGFILE
        
        echo "#- Check Porint 2. Ldap Settings File  Check ------------------------#" >>$LOGFILE
        echo "#- Check Porint 2-1. sudo-ldap conf file ------------------------#" >>$LOGFILE
        echo "result -> [$(ls -al /etc/sudo-ldap.conf)]" >>$LOGFILE
        echo "" >>$LOGFILE
        
        echo "#- Check Porint 2-2. ldap conf file  ------------------------# " >>$LOGFILE
        echo "result -> [$(grep -v "^#" /etc/ldap.conf | sed '/^$/d')]" >>$LOGFILE
        echo "" >>$LOGFILE
        
        echo "#- Check Porint 2-3. common-passwd file  ------------------------#" >>$LOGFILE
        echo "result -> [$(grep -v "^#" /etc/pam.d/common-password | sed '/^$/d')]" >>$LOGFILE
        echo "" >>$LOGFILE
        
        echo "#- Check Porint 2-3. common-session file ------------------------# " >>$LOGFILE
        echo "result -> [$(grep -v "^#" /etc/pam.d/common-session | sed '/^$/d')]" >>$LOGFILE
        echo "" >>$LOGFILE
        
        echo "#- Check Porint 2-3. nsswitch.conf file ------------------------# " >>$LOGFILE
        echo "result -> [$(grep -v "^#" /etc/nsswitch.conf | sed '/^$/d')]" >>$LOGFILE
        echo "" >>$LOGFILE
        
        echo "#- Check Porint 3. nscd Service Status ------------------------# " >>$LOGFILE
        echo "result -> [$(service nscd status)]" >>$LOGFILE
        echo "" >>$LOGFILE
        
        echo "#- Check Porint 4. ldap sudo Policy ------------------------#" >>$LOGFILE
        echo "result -> [$(sudo -l -U hamonize)]" >>$LOGFILE
        echo "" >>$LOGFILE
    fi
    return $retval
}

agentSettings() {
    retval=-1
    echo "$DATETIME] 1. agent install ================ [start]" >>$LOGFILE
    sudo apt-get install hamonize-agent -y >/dev/null
    
    # ===================================================================================
    
    PKG_OK=$(dpkg-query -W --showformat='${Status}\n' hamonize-agent | grep "install ok installed")
    if [ "" = "$PKG_OK" ]; then
        retval=1
        echo "$DATETIME] agent install Fail >  Error Check LogFile Location is /tmp/hm_agent.error " >>$LOGFILE
        
        echo "##################################################################" >>$LOGFILE
        echo "####### ERROR] Agent Settings Fail (error-code: 1942-AGENT)  ####### " >>$LOGFILE
        echo "##################################################################" >>$LOGFILE
        echo "" >>$LOGFILE
        echo "#----------------------------------------------------------------#" >>$LOGFILE
        echo "#- Chechk Point 1. Install Package [Agent] Check   ------------------------#" >>$LOGFILE
        echo "result -> $(dpkg -l hamonize-agent)" >>$LOGFILE
        echo "#Command Line]  dpkg-query -W --showformat='${Status}\n' hamonize-agent Result ::  [$(dpkg-query -W --showformat='${Status}\n' hamonize-agent)]" >>$LOGFILE
        echo "#Command Line]  dpkg-query -W  hamonize-agent Result :: [$(dpkg-query -W hamonize-agent)]" >>$LOGFILE
        echo "#Command Line]  apt list --installed hamonize-agent Result :: [$(apt list --installed hamonize-agent)]" >>$LOGFILE
        echo "" >>$LOGFILE
        
        echo "#- Chechk Point 2. hamonize-agent service  ------------------------#" >>$LOGFILE
        echo "result -> $(service hamonize-agent status)" >>$LOGFILE
        echo "" >>$LOGFILE
        
        echo "#- Chechk Point 3. hamonize-agentmngr service  ------------------------#" >>$LOGFILE
        echo "result -> $(service hamonize-agentmngr status)" >>$LOGFILE
        echo "" >>$LOGFILE
        
        echo "#-Check Point 4. systemctl list-units --------------------------------#" >>$LOGFILE
        echo "result -> $(systemctl list-units --all --type=service --no-pager | grep -e hamonize-agent)" >>$LOGFILE
        
    else
        
        sudo systemctl stop hamonize-agent
        echo "$DATETIME] agent install Success" >>$LOGFILE
        retval=0
    fi
    
    return $retval
    
}

#== timeshift =================================================
timeshiftSettings() {
    
    retval=-1
    echo "$DATETIME ] 6.  timeshift install ============== [start]" >>$LOGFILE
    sudo apt-get install timeshift -y >/dev/null
    PKG_OK=$(dpkg-query -W --showformat='${Status}\n' timeshift | grep "install ok installed")
    
    if [ "" = "$PKG_OK" ]; then
        sudo apt-get install timeshift -y >/dev/null
    fi
    
    PKG_OK=$(dpkg-query -W --showformat='${Status}\n' timeshift | grep "install ok installed")
    if [ "" = "$PKG_OK" ]; then
        retval=1
        echo "$DATETIME] timeshift install Fail >  Error Check LogFile Location is /tmp/hm_timeshift.error " >>$LOGFILE
        
        echo "##################################################################" >>$LOGFILE
        echo "####### ERROR] Timeshift Settings Fail (error-code: 1942-Timeshift)  ####### " >>$LOGFILE
        echo "##################################################################" >>$LOGFILE
        echo "" >>$LOGFILE
        
        echo "#----------------------------------------------------------------#" >>$LOGFILE
        echo "#- Chechk Point 1. Install Package [Timeshift] Check ------------------------#" >>$LOGFILE
        dpkg -l timeshift >>$LOGFILE
        echo "" >>$LOGFILE
    else
        retval=0
        echo "$DATETIME] timeshift install Success" >>$LOGFILE
    fi
    
    return $retval
    
}

#== telegraf =================================================
telegrafSettings() {
    retval=-1
    
    echo "$DATETIME ] 6.  telegraf install ============== [start]" >>$LOGFILE
    #  1. 설치
    wget -P /tmp https://dl.influxdata.com/telegraf/releases/telegraf_1.20.0-1_amd64.deb >>$LOGFILE
    sudo dpkg -i /tmp/telegraf_1.20.0-1_amd64.deb >>$LOGFILE
    
    echo "$DATETIME ] 6. telegraf install ============== [end]" >>$LOGFILE
    
    # 2. 서비스 중지
    sudo service telegraf stop
    
    # 3. 설정
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
    ' >/etc/telegraf/telegraf.conf
    
    PKG_OK=$(dpkg-query -W --showformat='${Status}\n' telegraf | grep "install ok installed")
    
    if [ "" = "$PKG_OK" ]; then
        
        echo "$DATETIME ] 6-1.  telegraf Setting  Fail ============== [end]" >>$LOGFILE
        echo "##################################################################" >>$LOGFILE
        echo "####### ERROR] Telegraf Fail (error-code: 1942-Telegraf)  ####### " >>$LOGFILE
        echo "##################################################################" >>$LOGFILE
        echo "" >>$LOGFILE
        
        echo "#----------------------------------------------------------------#" >>$LOGFILE
        echo "#- Chechk Point 1. Install Package [Telegraf] Check ------------------------#" >>$LOGFILE
        dpkg -l telegraf >>$LOGFILE
        echo "" >>$LOGFILE
        
        echo "#- Chechk Point 2. Install deb file Check  ------------------------#" >>$LOGFILE
        ls /tmp/telegraf*.deb >>$LOGFILE
        echo "" >>$LOGFILE
        
        retval=1
        
    else
        if [ ! -f /etc/telegraf/telegraf.conf ]; then
            
            echo "$DATETIME ] 6-1.  telegraf Setting  Fail ============== [end]" >>$LOGFILE
            echo "##################################################################" >>$LOGFILE
            echo "####### ERROR] Telegraf Fail (error-code: 1942-Telegraf)  ####### " >>$LOGFILE
            echo "##################################################################" >>$LOGFILE
            
            echo "#- Chechk Point 3. Telgraf Conf File  ------------------------#" >>$LOGFILE
            grep -v "^#" /etc/telegraf/telegraf.conf | sed '/^$/d' >>$LOGFILE
            echo "" >>$LOGFILE
            
            retval=1
        else
            echo "$DATETIME ] 6-1.  telegraf Setting Success============== [end]" >>$LOGFILE
            retval=0
        fi
        
    fi
    
    return $retval
    
}

hamonieTenantAptUrl() {
    # tenantApt="$APTURL $DOMAININFO main"
    # echo "Tenant Apt url :: $tenantApt" >>$LOGFILE
    
    chkAptList=$(cat /etc/apt/sources.list.d/hamonize.list | egrep -v '^[[:space:]]*(#.*)?$' | tr -d ' ')
    if [[ "$chkAptList" != *"$DOMAININFO"* ]]; then
        echo "deb [arch=amd64] http://$APTURL $DOMAININFO main" | sudo tee -a /etc/apt/sources.list.d/hamonize.list
        sudo apt-get update -y >>$LOGFILE
    fi
    
    # if [ $(grep -rn "$tenantApt" /etc/apt/sources.list.d/hamonize.list | wc -l) == 0 ]; then
    #     echo "deb [arch=amd64] http://$APTURL $DOMAININFO main" | sudo tee -a /etc/apt/sources.list.d/hamonize.list
    #     sudo apt-get update -y >>$LOGFILE
    # fi
    
    cat /etc/apt/sources.list.d/hamonize.list >>$LOGFILE
    
}

Init_program_package_chk() {
    retval=""
    retPackage=""
    
    for i in curl jq make openssh-server net-tools xrdp; do
        RE_PKG_CHK=$(dpkg-query -W --showformat='${Status}\n' $i | grep "install ok installed")
        
        if [ "" = "$RE_PKG_CHK" ]; then
            retPackage="$i $retPackage"
            retval="false"
            
        else
            retval="true"
        fi
    done
    
    strSize=${#retPackage}
    if [ $strSize != 0 ]; then
        echo "#---------------------------------------------" >>$LOGFILE
        echo "Hamonize Need Package Check Boolean : False" >>$LOGFILE
        echo "#---------------------------------------------" >>$LOGFILE
        
        echo "Need Install Package List : [ $retPackage ] " >>$LOGFILE
        for i in $retPackage; do
            apt-get install -y $i >/dev/null
            
            sleep 1
            echo "####==== Install Result ==== $i ] $(dpkg-query -W --showformat='${Status}\n' $i) ####" >>$LOGFILE
            
        done
        
    fi
    
    # Openssh-server Port Settings
    
    echo "#-Settings  XRDP--------------------------------------------#" >>$LOGFILE
    useXrdpPort=$(grep '^port=' /etc/xrdp/xrdp.ini  | awk -F'=' '{print $2}')
    for ai in $useXrdpPort; do
        chkXrdpPort=$(netstat -an | grep "LISTEN " | grep ":$ai" | wc -l)
        if [ $chkXrdpPort == 1 ]; then
            sed -i 's/port=3389/port=3389,1234/g' /etc/xrdp/xrdp.ini
            sudo ufw allow from any to any port 3389
            sudo ufw allow from any to any port 1234
            sudo ufw reload
        fi
    done
    
    if [ 0 -ne $(netstat -an | grep -w ":22" | wc -l) ]; then
        if [ 0 -eq $(cat /etc/ssh/sshd_config | grep -i ^\port | wc -l) ]; then
            sudo sh -c 'echo "Port 22" >> /etc/ssh/sshd_config'
        fi
    fi
    
    if [ 0 -eq $(netstat -an | grep -w ":2202" | wc -l) ]; then
        sudo sh -c 'echo "Port 2202" >> /etc/ssh/sshd_config'
    fi
    
    # sudo sh -c 'echo "Port 22" >> /etc/ssh/sshd_config'
    
    sudo ufw allow 2202
    sudo ufw allow ssh
    sudo systemctl restart sshd
    sudo systemctl restart ssh
    
    echo "# Ufw Status-----------------------------------------------#" >> $LOGFILE
    echo $(ufw status) >> $LOGFILE
}

Install-HamonizeProgram() {
    
    Param_Install_Used="{\
        \"events\" : [ {\
                \"domain\": \"$DOMAININFO\"\
        } ]\
    }"
    
    ProgramInstallUsed=$(curl -X POST -H 'User-Agent: HamoniKR OS' -H 'Content-Type: application/json' -f -s -d "$Param_Install_Used" "$CENTER_BASE_URL/hmsvc/getTenantOption")
    VPN_USED_YN=$(echo ${ProgramInstallUsed} | jq '. | .tenant_vpn_used' | sed -e "s/\"//g")
    REMOTE_USED_YN=$(echo ${ProgramInstallUsed} | jq '. | .remote_tool_vpn_yn' | sed -e "s/\"//g")
    LDAP_USED_YN=$(echo ${ProgramInstallUsed} | jq '. | .use_ldap_user_yn' | sed -e "s/\"//g")
    PCINIT_USED_YN=$(echo ${ProgramInstallUsed} | jq '. | .pc_init_yn' | sed -e "s/\"//g")
    UDEV_USED_YN=$(echo ${ProgramInstallUsed} | jq '. | .udev_yn' | sed -e "s/\"//g")
    AUTOLOGIN_USED_YN=$(echo ${ProgramInstallUsed} | jq '. | .auto_login_yn' | sed -e "s/\"//g")
    
    echo "################ Program Used Status ################" >>$LOGFILE
    echo "REMOTE Tool Used YN [ $REMOTE_USED_YN ]" >>$LOGFILE
    echo "LDAP Used YN [  > $LDAP_USED_YN ]" >>$LOGFILE
    echo "UDEV Used YN [  > $UDEV_USED_YN ]" >>$LOGFILE
    echo "OS Init Used YN [  > $PCINIT_USED_YN ]" >>$LOGFILE
    echo "OS AutoLogin Used YN [  > $AUTOLOGIN_USED_YN ]" >>$LOGFILE
    echo "" >>$LOGFILE
    
    #==== os init job -------------------------#
    if [ "$PCINIT_USED_YN" == "Y" ]; then
        cp $WORK_PATH/osInitJob.service /etc/systemd/system/
        cp $WORK_PATH/osInitJob.sh /etc/hamonize/
        
        systemctl daemon-reload >>$LOGFILE
        systemctl enable osInitJob >>$LOGFILE
        
    fi
    #==== auto login -------------------------#
    if [ "$AUTOLOGIN_USED_YN" == "Y" ]; then
        LoginUserid=$(awk -F'[/:]' '{if ($3 == 1000 && $3 != 65534) print $1}' /etc/passwd)
        displayManager=$(ps -aef | grep sbin\/lightdm | grep -v grep | wc -l)
        if [ 1 -eq $displayManager ]; then
            echo "display Manager lightdm Used" >>$LOGFILE
            echo -e "[SeatDefaults]" >>/etc/lightdm/lightdm.conf.d/12-autologin.conf
            echo -e "autologin-user=$LoginUserid" >>/etc/lightdm/lightdm.conf.d/12-autologin.conf
            echo -e "autologin-user-timeout=10" >>/etc/lightdm/lightdm.conf.d/12-autologin.conf
            echo -e "user-session=ubuntu" >>/etc/lightdm/lightdm.conf.d/12-autologin.conf
        fi
        
        displayManager=$(ps -aef | grep sbin\/gdm | grep -v grep | wc -l)
        if [ 1 -eq $displayManager ]; then
            echo "display Manager gdm3 Used" >>$LOGFILE
            sudo sed -i '/daemon]/aAutomaticLoginEnable=true' /etc/gdm3/custom.conf
            sudo sed -i '/AutomaticLoginEnable=true/aAutomaticLogin='$LoginUserid /etc/gdm3/custom.conf
        fi
        
        OSGUBUN=$(lsb_release -i | awk -F : '{print $2}' | tr [:lower:] [:upper:] | tr -d '\t')
        if [ "${OSGUBUN}" = "HAMONIKR" ]; then
            
            su $LoginUserid /bin/bash -c 'XDG_RUNTIME_DIR=/run/user/1000 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus gsettings set org.cinnamon.desktop.session idle-delay 0'
            su $LoginUserid /bin/bash -c 'XDG_RUNTIME_DIR=/run/user/1000 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus gsettings set org.cinnamon.desktop.screensaver lock-enabled false'
            su $LoginUserid /bin/bash -c 'XDG_RUNTIME_DIR=/run/user/1000 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus gsettings set org.cinnamon.settings-daemon.plugins.power lock-on-suspend false'
            
        fi
    fi
    
    #==== Hamonie-Usb protect -----------------#
    if [ "$UDEV_USED_YN" == "Y" ]; then
        deviceSettings
        retval=$?
        if [ "$retval" == 0 ]; then
            echo >&1 "Y"
        else
            echo >&2 "1942USB"
            exit 0
        fi
    fi
    
    # Ldap Install && Settings -----------------#
    if [ "$LDAP_USED_YN" == "Y" ]; then
        ldapSettings
        retval=$?
        
        if [ "$retval" == 0 ]; then
            echo >&1 "Y"
        else
            echo >&2 "1942-LDAP"
            exit 0
        fi
    fi
    
    #==== timeshift Install -----------------#
    
    timeshiftSettings
    retval=$?
    if [ "$retval" == 0 ]; then
        echo >&1 "Y"
    else
        echo >&2 "1942-TIMESHIFT"
        exit 0
    fi
    
    #==== Hamonize-help Install -----------------#
    hamonizeHelpSettings
    ret_hamonizeHelpSettings=$?
    if [ "$ret_hamonizeHelpSettings" == 0 ]; then
        echo >&1 "Y"
    else
        echo >&2 "$ret_hamonizeHelpSettings---1942-HAMONIZE_HELP"
        exit
    fi
    
    #==== Hamonie-Agent Install -----------------#
    agentSettings
    retval=$?
    echo $retval
    if [ "$retval" == 0 ]; then
        echo >&1 "Y"
    else
        echo >&2 "1942-AGENT"
        exit
    fi
    
    #==== OS loginout -----------------#
    osLoginoutSettings
    retval_osLoginoutSettings=$?
    if [ "$retval_osLoginoutSettings" == 0 ]; then
        echo >&1 "Y"
        # echo >&1 "Hamonize osLoginout Service Install-Y :: "
    else
        echo >&2 "1942-OSLOGINOUT"
        exit 0
    fi
    
    #==== telegraf Install -----------------#
    telegrafSettings
    retval=$?
    if [ "$retval" == 0 ]; then
        echo >&1 "Y"
    else
        echo >&2 "$retval---1942-TELEGRAF"
        exit 0
    fi
    
    #==== Hamonize-admin Install -----------------#
    
    if [ "$REMOTE_USED_YN" == "Y" ]; then
        
        remoteToolSettings
        retval=$?
        
        if [ "$retval" == 0 ]; then
            echo >&1 "Y"
            # echo >&1 "remoteToolSettings :: " >>$LOGFILE
            elif [ "$retval" == 3 ]; then
            echo >&2 "$retval---1942-HAMONIZE_ADMIN-TOOL"
            exit 0
            elif [ "$retval" == 2 ]; then
            echo >&2 "$retval---1942-HAMONIZE_ADMIN-KEYS"
            exit 0
        else
            echo >&2 "$retval---1942-HAMONIZE_ADMIN-ETC"
            echo "##################################################################" >>$LOGFILE
            echo "####### ERROR] HAMONIZE_ADMIN-TOOL Settings Fail (error-code: 1942-HAMONIZE_ADMIN-ETC)  ####### " >>$LOGFILE
            echo "##################################################################" >>$LOGFILE
            echo "" >>$LOGFILE
            
            echo "# Hamonize-Admin Exception Another Case ------------------------------#" >>$LOGFILE
            echo "# cf. /var/log/hamonize/propertiesJob/propertiesJob.log ------------------------------#" >>$LOGFILE
            
            exit 0
        fi
    fi
    
}

# 필수 프로그램 체크 및 설치
Init_program_package_chk
sleep 1

# # 하모나이즈 모듈 설치
Install-HamonizeProgram
sleep 1

# # 필수 프로그램 스케쥴링 설정
hamonizeServerSettings
sleep 1

# #  Add Tenant Apt
hamonieTenantAptUrl
