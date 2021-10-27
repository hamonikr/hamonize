#!/usr/bin/env bash

centerUrl=`cat /etc/hamonize/propertiesJob/propertiesInfo.hm | grep CENTERURL | awk -F'=' '{print $2}'`
CENTERURL="http://${centerUrl}/hmsvc/updtpolicy"
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


        INS_CHK_CNT=`dpkg --get-selections | grep $I | grep -v "[[:graph:]]$I\|$I[[:graph:]]" | wc -l`
        echo "install chk wc -l is ==> $INS_CHK_CNT" >>$LOGFILE

        INS_WHEREISPROGRM=`whereis $I`
        echo "whereis progrm === $INS_WHEREISPROGRM" >>$LOGFILE

        INS_FILE_PATH=`echo $INS_WHEREISPROGRM | awk '{print $2}'`
        echo "ins_awk is ===>$INS_FILE_PATH" >>$LOGFILE

        INS_PKG_VER=`apt-cache policy $I | grep -E '설치|Installed' | awk '{print $2}'`
 

        INSRET=$INSRET"{\"debname\":\"${I}\",\"debver\":\"${INS_PKG_VER}\",\"state\":\"$INS_CHK_CNT\",\"path\":\"$INS_FILE_PATH\"}"

        if [ "$EC" -eq "$#" ]; then
                INSRET=$INSRET","
        fi

        EC=`expr "$EC" + 1`



done;
IFS=$OLD_IFS



echo "===insert result data is ===>$INSRET" >>$LOGFILE

echo "################## updt json data ############################" >>$LOGFILE

UPDT_INSTALL_JSON="{\
        \"insresert\":[$INSRET],\
        \"updtresert\": [],\
        \"delresert\": [],\
        \"uuid\": \"$PCUUID\"\
}"


echo "UPDT_INSTALL_JSON >>> $UPDT_INSTALL_JSON" >> $LOGFILE

RETUPDT=`curl  -X  POST -H 'User-Agent: HamoniKR OS' -H 'Content-Type: application/json' -f -s -d "$UPDT_INSTALL_JSON" $CENTERURL`

fi



echo "" >>$LOGFILE
echo "" >>$LOGFILE
echo "" >>$LOGFILE


echo "################## updt deb upgrade ############################" >>$LOGFILE

UPDT_UPDT=`cat /etc/hamonize/updt/updtInfo.hm | jq '.UPGRADE' | sed -e "s/\"//g" `

echo "upgrade file total data=========$UPDT_UPDT" >>$LOGFILE

if [ "$UPDT_UPDT" != null ]; then
        echo "data update  ==" >>$LOGFILE
UC=0
UPSRET=""
OLD_IFUPS=$IFUPS;
IFS=,;

for I in $UPDT_UPDT;
do      
        NAME=$(echo $I | cut -f 1 -d '_' )
        echo "update file name is ===> $NAME" >>$LOGFILE 
        VERSION=$(echo $I | cut -f 2 -d '_' )
        echo "update file version is ===> $VERSION" >>$LOGFILE 

        INSTALLED_VER=`apt-cache policy $NAME | grep -E '설치|Installed' | awk '{print $2}'`
        echo "If this package is already installed... ====>$INSTALLED_VER" >>$LOGFILE 

        if [ -z $INSTALLED_VER ]; then
                echo "This package is not installed, so istalling now..  ====>" >>$LOGFILE
                sudo apt install $NAME -y >>$LOGFILE
                
                # 설치되어있으면 해당 패키지 업그레이드
                # 같으면 1 다르면 0
        else
                echo "Package version already installed.. $INSTALLED_VER" >>$LOGFILE
                while [ `expr $INSTALLED_VER \!= $VERSION` = 1 ] 
                do
                        if [ `expr $INSTALLED_VER \< $VERSION` = 1 ]; then
                                echo "The new version is bigger...===> $VERSION" >>$LOGFILE
                                sudo apt-get update > /dev/null       
                                sleep 1

                                echo "dpkg --get-selections | grep $NAME" >> $LOGFILE
                                UPS_REAL_FILE_NM=`dpkg --get-selections | grep $NAME | awk '{print $1}'`
                                echo "update file real name is ====>$UPS_REAL_FILE_NM" >>$LOGFILE 
                                
                                if [ "$UPS_REAL_FILE_NM" != "" ]; then
                                        echo "UPS_REAL_FILE_NM" >>$LOGFILE
                                        sudo apt-get --only-upgrade install $UPS_REAL_FILE_NM -y >>$LOGFILE
                                
                                else
                                        echo "NAME" >>$LOGFILE
                                        sudo apt-get install $NAME -y >>$LOGFILE
                                        sleep 1
                                fi

                                INSTALLED_VER=`apt-cache policy $NAME | grep -E '설치|Installed' | awk '{print $2}'`

                                if [ `expr $INSTALLED_VER \= $VERSION` = 1 ]; then
                                        break        
                                fi                         
                
                        else
                                echo "The already installed version is bigger, so don't update it ===> $INSTALLED_VER" >>$LOGFILE
                        fi

                done;
                
        fi

        INSTALLED_VER=`apt-cache policy $NAME | grep -E '설치|Installed' | awk '{print $2}'`

        echo "It's the same as the new version and the installed version ===> $INSTALLED_VER" >> $LOGFILE        
        # if [ `expr $INSTALLED_VER \= $VERSION` = 1 ]; then
        #         echo "It's the same as the new version and the installed version ===> $INSTALLED_VER" >> $LOGFILE                                       
        # fi

        UPS_CHK_CNT=`dpkg --get-selections | grep $NAME | grep -v "[[:graph:]]$NAME\|$NAME[[:graph:]]" | wc -l `
        echo "wc -l is ===>$UPS_CHK_CNT"

        UPS_WHEREISPROGRM=`whereis $NAME`
        echo "whereis progrm === $UPS_WHEREISPROGRM" >>$LOGFILE

        UPS_FILE_PATH=`echo $UPS_WHEREISPROGRM | awk '{print $2}'`
        echo "ins_awk is ===>$UPS_FILE_PATH" >>$LOGFILE

        UPSRET=$UPSRET"{\"debname\":\"${NAME}\",\"debver\":\"${INSTALLED_VER}\",\"state\":\"$UPS_CHK_CNT\",\"path\":\"$UPS_FILE_PATH\"}"
                        
        if [ "$UC" -eq "$#" ]; then
                UPSRET=$UPSRET","
        fi

        UC=`expr "$UC" + 1`

done;
IFS=$OLD_IFUPS

echo "===upgrade result data is ===>$UPSRET" >>$LOGFILE

echo "################## updt json data ############################" >>$LOGFILE

UPDT_UPGRADE_JSON="{\
        \"insresert\":[],\
        \"updtresert\": [$UPSRET],\
        \"delresert\": [],\
        \"uuid\": \"$PCUUID\"\
}"

echo "UPDT_UPGRADE_JSON >>> $UPDT_UPGRADE_JSON" >> $LOGFILE
RETUPDT=`curl  -X  POST -H 'User-Agent: HamoniKR OS' -H 'Content-Type: application/json' -f -s -d "$UPDT_UPGRADE_JSON" $CENTERURL`

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


        DEL_CHK_CNT=`dpkg --get-selections | grep $I | grep -v "[[:graph:]]$I\|$I[[:graph:]]" | wc -l`
        echo "del chk wc -l is ==> $DEL_CHK_CNT" >>$LOGFILE

        DEL_PKG_VER=`apt-cache policy $NAME | grep -E '설치|Installed' | awk '{print $2}'`


        DELRET=$DELRET"{\"debname\":\"${I}\",\"debver\":\"${DEL_PKG_VER}\",\"state\":\"$DEL_CHK_CNT\",\"path\":\"\"}"

        if [ "$EC" -eq "$#" ]; then
                DELRET=$DELRET","
        fi

        EC=`expr "$EC" + 1`
done;
IFS=$OLD_IFS

echo "===delete result data is ===>$DELRET" >>$LOGFILE


echo "################## updt json data ############################" >>$LOGFILE

UPDT_DELETE_JSON="{\
        \"insresert\":[],\
        \"updtresert\": [],\
        \"delresert\": [$DELRET],\
        \"uuid\": \"$PCUUID\"\
}"

echo "UPDT_DELETE_JSON >>> $UPDT_DELETE_JSON" >> $LOGFILE

RETUPDT=`curl  -X  POST -H 'User-Agent: HamoniKR OS' -H 'Content-Type: application/json' -f -s -d "$UPDT_DELETE_JSON" $CENTERURL`


fi


echo "RETUPDT agent to hamonize center result---->  $RETUPDT" >> ${LOGFILE}
