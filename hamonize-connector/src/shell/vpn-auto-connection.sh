#!/bin/bash 

. /etc/hamonize/propertiesJob/propertiesInfo.hm

PCUUID=`cat /etc/hamonize/uuid`
VPNKEY=hm-${PCUUID}
VPNCNT=`nmcli con|grep ^${VPNKEY}.*vpn|awk '{print $2}' | wc -l`
PCHOSTNAME=`hostname`
LOGFILE=/tmp/auto-vpn.log
LOGGING="true"

function hmnlog {

	if [ "${LOGGING}" = "true" ]; then
		DATETIME=`date +'%Y-%m-%d %H:%M:%S.%3N'`
		RETVAL=`echo "$1"|sed "s/^/$DATETIME /g"`
		echo "$RETVAL" >> ${LOGFILE}
	fi
}

function sendInfo {

        #변경된 vpnip 정보 업데이트
        SERVER_API="http://$CENTERURL/hmsvc/pcInfoChange"

        DATETIME=`date +'%Y-%m-%d %H:%M:%S'`
        NETDEV_UUID=`nmcli con show --active |grep ethernet | gawk '{n=split($0,a," ");print a[n-2]}'`
        IPADDR=`nmcli con show --active ${NETDEV_UUID}|grep IP4.ADDRESS|gawk '{n=split($2,a,"/"); print a[1]}'`
        GWADDR=`ip route|grep ^default|awk '{print $3}'`
        MACADDR=`ifconfig | awk '/ether/'|awk '{print $2}'`
        ACTION='VPNIPCHANGE'
        CPUID=`dmidecode -t 4|grep ID`

        if [ "$VPNIPADDR" != "" ]; then
                LOG_JSON="{
                        \"events\" : [ {\
                        \"datetime\":\"${DATETIME}\",\
                        \"macaddr\": \"${MACADDR}\",\
                        \"ipaddr\": \"${IPADDR}\",\
                        \"vpnipaddr\": \"${VPNIPADDR}\",\
                        \"hostname\": \"${PCHOSTNAME}\",\
                        \"CPUID\": \"${CPUID}\",\
                        \"pcuuid\": \"${PCUUID}\",\
                        \"action\": \"${ACTION}\"\
                        } ]\
                }"

                hmnlog "curl -X POST -H 'User-Agent: HamoniKR OS' -H 'Content-Type: application/json' -f -s -d \"${LOG_JSON}\" ${SERVER_API}"
                RETVAL=`curl -X POST -H 'User-Agent: HamoniKR OS' -H 'Content-Type: application/json' -f -s -d "$LOG_JSON" $SERVER_API`
                hmnlog "$RETVAL"
        fi

}

# 1st if : VPN 연결이 1개 이상일 경우, VPN연결이 되지 않은 연결 NAME을 삭제한다.
if [ "${VPNCNT}" -gt "1" ]; then 

	hmnlog "1st if start"
	
	for VPN_UUID in `nmcli con|grep ^${VPNKEY}.*vpn.*--|awk '{print $2}'`
	do
		hmnlog "1st for"
		hmnlog "`sudo nmcli conn delete $VPN_UUID`"
	done	

	hmnlog "1st if finish"
else
	hmnlog "1st if not execute"
fi


# 2nd if : VPN 연결 NAME 이 없는 경우, 연결 NAME을 등록 한다.
if [ ${VPNCNT} -lt "1" ]; then 

	hmnlog "2nd if start"

	hmnlog "sudo nmcli con import type openvpn file /etc/hamonize/ovpnclient/*.ovpn"
	hmnlog "`sudo nmcli con import type openvpn file /etc/hamonize/ovpnclient/*.ovpn`"
        hmnlog "`nmcli connection modify $VPNKEY ipv4.never-default true`"

	hmnlog "2nd if finish"
else
	hmnlog "2nd if not execute"
fi

# 3rd if : VPN 연결 NAME 은 있으나 VPN 연결이 비활성화 상태일 때, VPN 연결을 활성화 한다.
if [ `nmcli con | grep ^$VPNKEY | awk '{print $4}'` = '--' ]; then
	
	hmnlog "3rd if start"

    hmnlog "`nmcli con up ${VPNKEY}`"

	VPNIPADDR=`nmcli con show --active ${VPNKEY} |grep IP4.ADDRESS|awk '{print $2}'|awk -F'/' '{print $1}'`
	hmnlog "3rd if finish"

	sendInfo

else
	hmnlog "3rd if not execute"
fi
