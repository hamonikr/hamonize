#!/bin/bash

Stop-HamonizeProgram() {

    #  서비스 모듈 중지 #


    #==== user loginout
    # systemctl stop hamonize-logout
    # systemctl stop hamonize-login

    # Ldap Install && Connection 
    service nscd stop >/dev/null

    #==== telegraf Install 
    systemctl stop telegraf >/dev/null

    #==== Hamonize-admin Install
    hamonize-cli service stop >/dev/null

    #==== hamonize-agent mngr
    systemctl stop hamonize-agentmngr >/dev/null

    #==== VPN Connection
    MACHIDTMP=$(cat /etc/hamonize/uuid | head -1)
    CLIENT="hm-$MACHIDTMP"
    systemctl stop vpn-connecter.service >/dev/null
    nmcli conn down $CLIENT >/dev/null

    #==== Hamonie-Usb protect
    mv /etc/udev/rules.d/30-usb-lockdown.rules /etc/udev/rules.d/30-usb-lockdown.rules_expiry


    #==== 서비스 중지 체크 파일 생성.
    touch /etc/hamonize/hamonize.expiry
}

Start-HamonizeProgram() {

    #  서비스 모듈 재가동 #
    if [ -f /tmp/debconf-ldap-preseed.txt ]; then
    fi


    #==== user loginout
    # systemctl stop hamonize-logout
    # systemctl stop hamonize-login

    # Ldap Install && Connection 
    service nscd restart >/dev/null

    #==== telegraf Install 
    systemctl restart telegraf >/dev/null

    #==== Hamonize-admin Install
    hamonize-cli service restart >/dev/null

    #==== hamonize-agent mngr
    systemctl restart hamonize-agentmngr >/dev/null

    #==== VPN Connection 
    MACHIDTMP=$(cat /etc/hamonize/uuid | head -1)
    CLIENT="hm-$MACHIDTMP"
    systemctl restart vpn-connecter.service >/dev/null
    nmcli conn down $CLIENT >/dev/null

    #==== Hamonie-Usb protect
    mv /etc/udev/rules.d/30-usb-lockdown.rules /etc/udev/rules.d/30-usb-lockdown.rules_expiry

}

retval=$1
if [ "$retval" == 0 ]; then
    Stop-HamonizeProgram
else
    Start-HamonizeProgram
fi
