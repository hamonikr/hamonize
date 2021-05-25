#!/bin/bash


DATETIME=`date +'%Y-%m-%d %H:%M:%S'`
sgbUrl=`cat /etc/hamonize/propertiesJob/propertiesInfo.hm | grep CENTERURL | awk -F'=' '{print $2}'`
CENTERURL="http://${sgbUrl}/hmsvc/version"

AgentVersion=`apt version hamonize-agent`
# echo "agent version====$AgentVersion"

# AgentState=`systemctl status hamonize-agent | grep Active | awk '{print $2}'`
AgentState=`systemctl show -p SubState --value hamonize-agent`

pcUuid=`cat /etc/hamonize/uuid`

AGENTGETINFO="{\"versionchk\":[{\"debname\":\"hamonize-agent\",\"debver\":\"${AgentVersion}\",\"state\":\"$AgentState\",\"uuid\":\"$pcUuid\"}]}"
echo "hamonize-agent version data json === $AGENTGETINFO "

RETBAK=`curl  -X  POST -H 'User-Agent: HamoniKR OS' -H 'Content-Type: application/json' -f -s -d "$AGENTGETINFO" $CENTERURL`

