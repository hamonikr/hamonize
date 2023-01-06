#!/bin/bash

StopHamonizeProgram() {

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
    # hamonize-agent none stop

    #==== VPN Connection
    MACHIDTMP=$(cat /etc/hamonize/uuid | head -1)
    CLIENT="hm-$MACHIDTMP"
    systemctl stop vpn-connecter.service >/dev/null
    nmcli conn down $CLIENT >/dev/null

    #==== Hamonie-Usb protect
    mv /etc/udev/rules.d/30-usb-lockdown.rules /etc/udev/rules.d/30-usb-lockdown.rules_expiry

    #==== 서비스 중지 체크 파일 생성.
    # 사용기간이 만료되면  상태값 'N'으로 hamonize.expiry 파일을 생성.
    touch /etc/hamonize/hamonize.expiry
    echo "N" >/etc/hamonize/hamonize.expiry

    touch /tmp/hamonize.stop
    echo "#----------------------------------#" >>/tmp/hamonize.stop
    echo "nscd status] Service Status -------" >>/tmp/hamonize.stop
    echo "" >>/tmp/hamonize.stop
    service nscd status >>/tmp/hamonize.stop

    echo "Telegraf status] Service Status -------" >>/tmp/hamonize.stop
    service status telegraf >>/tmp/hamonize.stop
    echo "" >>/tmp/hamonize.stop

    echo "Hamonize-Cli status] Service Status -------" >>/tmp/hamonize.stop
    hamonize-cli service status >>/tmp/hamonize.stop
    echo "" >>/tmp/hamonize.stop

    echo "Vpn status] Service Status -------" >>/tmp/hamonize.stop
    systemctl status vpn-connecter >>/tmp/hamonize.stop
    echo "" >>/tmp/hamonize.stop

    echo "Udev status] Service Status -------" >>/tmp/hamonize.stop
    ls /etc/udev/rules.d/ >>/tmp/hamonize.stop
    echo "" >>/tmp/hamonize.stop

    echo "Expiry Status File -------" >>/tmp/hamonize.stop
    cat /etc/hamonize/hamonize.expiry >>/tmp/hamonize.stop
}

StartHamonizeProgram() {

    rm -fr /tmp/hamonize.start && touch /tmp/hamonize.start

    #  서비스 모듈 재가동 #
    #  사용기간이 만료된 후 연장을 한경우. 상태값이 N -> Y로 변경
    hamonizeExpiry=$(cat /etc/hamonize/hamonize.expiry)
    echo "hamonizeExpiry===================$hamonizeExpiry"
    echo "hamonize Expiry File Status : ${hamonizeExpiry}" >>/tmp/hamonize.start

    if [ "$hamonizeExpiry" == "N" ]; then
        #==== user loginout
        # systemctl stop hamonize-logout
        # systemctl stop hamonize-login

        # Ldap
        service nscd restart >/dev/null

        #==== telegraf
        systemctl restart telegraf >/dev/null

        #==== Hamonize-admin
        hamonize-cli service restart >/dev/null

        #==== hamonize-agent mngr
        systemctl restart hamonize-agentmngr >/dev/null

        #==== VPN Connection
        MACHIDTMP=$(cat /etc/hamonize/uuid | head -1)
        CLIENT="hm-$MACHIDTMP"
        nmcli conn up $CLIENT >/dev/null
        systemctl restart vpn-connecter.service >/dev/null

        #==== Hamonie-Usb protect
        mv /etc/udev/rules.d/30-usb-lockdown.rules_expiry /etc/udev/rules.d/30-usb-lockdown.rules

        echo "Y" >/etc/hamonize/hamonize.expiry

        # ==== restart Status ==== #

        echo "#----------------------------------#" >>/tmp/hamonize.start
        echo "nscd status] Service Status -------" >>/tmp/hamonize.start
        echo "" >>/tmp/hamonize.start
        service nscd status >>/tmp/hamonize.start

        echo "Telegraf status] Service Status -------" >>/tmp/hamonize.start
        service status telegraf >>/tmp/hamonize.start
        echo "" >>/tmp/hamonize.start

        echo "Hamonize-Cli status] Service Status -------" >>/tmp/hamonize.start
        hamonize-cli service status >>/tmp/hamonize.start
        echo "" >>/tmp/hamonize.start

        echo "Vpn status] Service Status -------" >>/tmp/hamonize.start
        systemctl status vpn-connecter >>/tmp/hamonize.start
        echo "" >>/tmp/hamonize.start

        echo "Udev status] Service Status -------" >>/tmp/hamonize.start
        ls /etc/udev/rules.d/ >>/tmp/hamonize.start
        echo "" >>/tmp/hamonize.start

        echo "Expiry Status File -------" >>/tmp/hamonize.start
        echo "hamonize Expiry File Status : ${hamonizeExpiry}" >>/tmp/hamonize.start

    fi

}

NoneAddHamonize() {
    echo "E" >/etc/hamonize/hamonize.expiry
}

retval=$1
if [ $retval -eq 0 ]; then
    StopHamonizeProgram
elif [ $retval -eq 1 ]; then
    StartHamonizeProgram
else
    NoneAddHamonize
fi
