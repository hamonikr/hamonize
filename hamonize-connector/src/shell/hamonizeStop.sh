#!/bin/bash

ldapSettings() {


#  서비스 모듈 작동 중지
    # Ldap Install && Connection -----------------#
    service nscd stop >/dev/null
    

    #==== Hamonie-Usb protect -----------------#
    mv /etc/udev/rules.d/30-usb-lockdown.rules  /etc/udev/rules.d/30-usb-lockdown.rules_expiry

    #==== user loginout -----------------#
    # systemctl stop hamonize-logout
    # systemctl stop hamonize-login


    #==== telegraf Install -----------------#
    systemctl stop telegraf  > /dev/null

    #==== Hamonize-admin Install -----------------#
    hamonize-cli service stop  > /dev/null


    #==== hamonize-agent mngr -----------------#
    systemctl stop hamonize-agentmngr  > /dev/null

    #==== vpn stop -----------------#
    MACHIDTMP=`cat /etc/hamonize/uuid |head -1`
    CLIENT="hm-$MACHIDTMP"
    systemctl stop vpn-connecter.service  > /dev/null
    nmcli conn down $CLIENT > /dev/null

}    

Init-HamonizeProgram() {


    # #==== Hamonie-Agent Install -----------------#
    # retval=$(agentSettings)
    # if [ "$retval" == 0 ]; then
    #     echo >&1 "Y"
    # else
    #     echo >&2 "1942-AGENT"
    #     exit 0
    # fi
    # sleep 2


    
}


Init-HamonizeProgram