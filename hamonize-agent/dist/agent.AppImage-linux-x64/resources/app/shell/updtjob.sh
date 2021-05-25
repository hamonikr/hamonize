#!/bin/bash

sgbUrl=`cat /etc/hamonize/propertiesJob/propertiesInfo.hm | grep CENTERURL | awk -F'=' '{print $2}'`
CENTERURL="http://${sgbUrl}/hmsvc/updtpolicy"
#CENTERURL="http://192.168.0.54:8082/hmsvc/updtpolicy"
PCUUID=`cat /etc/hamonize/uuid`
LOGFILE="/var/log/hamonize/agentjob/updp.log"
touch $LOGFILE



echo "################### updt deb install ###########################" >>$LOGFILE

UPDT_INS=`cat /etc/hamonize/updt/updtInfo.hm | jq '.INSERT' | sed -e "s/\"//g" ` 
echo "install file total  data=========$UPDT_INS"  >>$LOGFILE

if [ "$UPDT_INS" != null ] 
then
	echo "data insert ==" >>$LOGFILE

EC=0
INSRET=""
OLD_IFS=$IFS;
IFS=,;
for I in $UPDT_INS;
do
	

        echo "install deb name is ===> $I" >>$LOGFILE

	sudo apt-get update >>$LOGFILE
 	sleep 1

	sudo apt-get install $I -y >>$LOGFILE
        sleep 1
	
        INS_INSTALL_CHK=`dpkg --get-selections | grep $I`
        echo "install chk is ==> $INS_INSTALL_CHK" >>$LOGFILE


        INS_CHK_CNT=`dpkg --get-selections | grep $I | wc -l`
        echo "install chk wc -l is ==> $INS_CHK_CNT" >>$LOGFILE

        INS_WHEREISPROGRM=`whereis $I`
        echo "whereis progrm === $INS_WHEREISPROGRM" >>$LOGFILE

        INS_FILE_PATH=`echo $INS_WHEREISPROGRM | awk '{print $2}'`
        echo "ins_awk is ===>$INS_FILE_PATH" >>$LOGFILE

        INS_PKG_VER=`apt version $I`

        


        INSRET=$INSRET"{\"debname\":\"${I}\",\"debver\":\"${INS_PKG_VER}\",\"state\":\"$INS_CHK_CNT\",\"path\":\"$INS_FILE_PATH\"}"

        if [ "$EC" -eq "$#" ]; then
                INSRET=$INSRET","
        fi

        EC=`expr "$EC" + 1`



done;
IFS=$OLD_IFS


fi


echo "===insert result data is ===>$INSRET" >>$LOGFILE

echo "" >>$LOGFILE
echo "" >>$LOGFILE
echo "" >>$LOGFILE
echo "################## updt deb upgrade ############################" >>$LOGFILE

UPDT_UPDT=`cat /etc/hamonize/updt/updtInfo.hm | jq '.UPGRADE' | sed -e "s/\"//g" `
echo "upgrade file total data=========$UPDT_UPDT" >>$LOGFILE

if [ "$UPDT_UPDT" != null ]
then
        echo "data update  ==" >>$LOGFILE
UC=0
UPSRET=""
OLD_IFUPS=$IFUPS;
IFS=,;
for I in $UPDT_UPDT;
do

        echo "update file name is ===> $I" >>$LOGFILE
	
	sudo apt-get update > /dev/null 
	sleep 1

        echo "dpkg --get-selections | grep $I " >> $LOGFILE
        UPS_REAL_FILE_NM=`dpkg --get-selections | grep $I | awk '{print $1}'`
        echo "update file real name is ====>$UPS_REAL_FILE_NM" >>$LOGFILE 
        
        if [ "$UPS_REAL_FILE_NM" != "" ]; then
                sudo apt-get --only-upgrade install $UPS_REAL_FILE_NM -y >>$LOGFILE
        else
                sudo apt-get install $I -y >>$LOGFILE
                sleep 1
        fi

        UPS_CHK_CNT=`dpkg --get-selections | grep $I | wc -l`
        #echo "wc -l is ===>$UPS_CHK_CNT"
        #echo "upgrade chk wc -l is ==> $UPS_CHK_CNT" >>$LOGFILE


        UPS_WHEREISPROGRM=`whereis $I`
        echo "whereis progrm === $UPS_WHEREISPROGRM" >>$LOGFILE

        UPS_FILE_PATH=`echo $UPS_WHEREISPROGRM | awk '{print $2}'`
        echo "ins_awk is ===>$UPS_FILE_PATH" >>$LOGFILE

        UPS_PKG_VER=`apt version $I`


        UPSRET=$UPSRET"{\"debname\":\"${I}\",\"debver\":\"${UPS_PKG_VER}\",\"state\":\"$UPS_CHK_CNT\",\"path\":\"$UPS_FILE_PATH\"}"

        if [ "$UC" -eq "$#" ]; then
                UPSRET=$UPSRET","
        fi
        UC=`expr "$UC" + 1`



done;
IFS=$OLD_IFUPS

echo "===upgrade result data is ===>$UPSRET" >>$LOGFILE


fi



echo "" >>$LOGFILE
echo "" >>$LOGFILE
echo "" >>$LOGFILE
echo "################## updt deb del  ############################" >>$LOGFILE



UPDT_DEL=`cat /etc/hamonize/updt/updtInfo.hm | jq '.DEL' | sed -e "s/\"//g" `
echo "delete file total  data=========$UPDT_DEL"  >>$LOGFILE



if [ "$UPDT_DEL" != null ]
then
        echo " data delete ==$UPDT_DEL===" >>$LOGFILE
EC=0
DELRET=""
OLD_IFS=$IFS;
IFS=,;
for I in $UPDT_DEL;
do


        echo "delete deb name is ===> $I" >>$LOGFILE

        sudo apt-get purge $I -y >>$LOGFILE
        sleep 1


        DEL_CHK_CNT=`dpkg --get-selections | grep $I | wc -l`
        echo "del chk wc -l is ==> $DEL_CHK_CNT" >>$LOGFILE

        DEL_PKG_VER=`apt version $I`


        DELRET=$DELRET"{\"debname\":\"${I}\",\"debver\":\"${DEL_PKG_VER}\",\"state\":\"$DEL_CHK_CNT\",\"path\":\"\"}"

        if [ "$EC" -eq "$#" ]; then
                DELRET=$DELRET","
        fi

        EC=`expr "$EC" + 1`
done;
IFS=$OLD_IFS

echo "===delete result data is ===>$DELRET" >>$LOGFILE


fi



echo "################## updt json data ############################" >>$LOGFILE

UPDT_JSON="{\
       \"insresert\":[$INSRET],\
       \"updtresert\": [$UPSRET],\
       \"delresert\": [$DELRET],\
       \"uuid\": \"$PCUUID\"\
}"


echo $UPDT_JSON >>$LOGFILE


RETUPDT=`curl  -X  POST -H 'User-Agent: HamoniKR OS' -H 'Content-Type: application/json' -f -s -d "$UPDT_JSON" $CENTERURL`


#echo="curl  -X  POST -H 'User-Agent: HamoniKR OS' -H 'Content-Type: application/json' -f -s -d "$UPDT_JSON" $CENTERURL"

echo $RETUPDT >> ${LOGFILE}
