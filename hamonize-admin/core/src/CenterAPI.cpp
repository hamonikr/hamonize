#include "CenterAPI.h"

#include "VeyonCore.h"
#include "PlatformCoreFunctions.h"
#include "PlatformUserFunctions.h"

CenterAPI::CenterAPI(QObject *parent) : QObject(parent),
    m_nam(new QNetworkAccessManager)
{

   connect( m_nam, SIGNAL( finished( QNetworkReply* ) ), SLOT( onPostAnswer( QNetworkReply* ) ) );

}


void CenterAPI::onPostAnswer(QNetworkReply* reply)
{

    qDebug() << reply;

    int code = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
    qDebug() << "Code:" << code;

    /* TODO : reply error exception 개발 필요
    switch(code){
        case 405:
            qDebug() << "Server "
        case 200:

        default:

    }
    */

}



/* inetLogTest.sh
 *
# !/bin/sh
USERID="userid01"
PCUUID="pcuuid01"
HOSTNAME=`hostname`
PCIP="192.168.0.185"
URL="http:://xxx.xxx.xxx/xxx.html"
REGDT=`date "+%Y-%m-%d %H:%M:%S"`
STATE="Illegal"

JSON="{\"inetval\":[{\"userid\":\"$USERID\",\"pcuuid\":\"$PCUUID\",\"hostname\":\"$HOSTNAME\",\"pcip\":\"$PCIP\",\"url\":\"$URL\",\"regdt\":\"$REGDT\",\"state\":\"$STATE\"}]}"
echo $JSON
curl -i -v -X POST -H "Content-Type:application/json"  http://192.168.0.54:8082/hmsvc/inetLog -d \"$JSON\"
*/


void CenterAPI::inetLog()
{

//    QNetworkRequest request(QUrl(QLatin1String("http://192.168.0.54:8082/hmsvc/inetLog")));
//    request.setHeader(QNetworkRequest::ContentTypeHeader, QLatin1String("application/json"));

    QString USERID = QStringLiteral("user01");
    QString PCUUID = QStringLiteral("pcuuid01");
    QString HOSTNAME = QStringLiteral("hostname01");
    QString PCIP = QStringLiteral("192.168.0.185");
    QString URL = QStringLiteral("http://sexy.girl.com");

    QDateTime now = QDateTime::currentDateTime();
    QString REPORTDT = now.toString(QStringLiteral("yyyy-MM-dd hh:mm:ss"));
    QString STATE = QStringLiteral("Illiegal");

    QJsonObject envelop;

    QJsonObject juserid;
    juserid["userid"] = USERID;

    QJsonObject jpcuuid;
    jpcuuid["pcuuid"] = PCUUID;

    QJsonObject jhostname;
    jhostname["hostname"] = HOSTNAME;

    QJsonObject jpcip;
    jpcip["pcip"] = PCIP;

    QJsonObject jurl;
    jurl["url"] = URL;

    QJsonObject jreportdt;
    jreportdt["reportdt"] = REPORTDT;

    QJsonObject jstate;
    jstate["state"] = STATE;

    QJsonArray jarr;
    jarr.append(juserid);
    jarr.append(jpcuuid);
    jarr.append(jhostname);
    jarr.append(jpcip);
    jarr.append(jurl);
    jarr.append(jreportdt);
    jarr.append(jstate);

    envelop["inetval"] = jarr;

    qDebug() << envelop;

    QUrl serverUrl = QUrl("http://192.168.0.54:8082/hmsvc/inetLog");

    QJsonDocument doc(envelop);
    QByteArray jsonData = doc.toJson();

    QNetworkRequest req(serverUrl);
    req.setHeader(QNetworkRequest::ContentTypeHeader,"application/json" );
    req.setHeader(QNetworkRequest::ContentLengthHeader,QByteArray::number(jsonData.size()));

    m_nam->post(req, jsonData);

}


void CenterAPI::hwChangedLog(HWInfo* hwinfo)
{

//hw_path="/etc/hamonize/hwchk"


//SERVER_API="http://10.4.0.2:8082/hmsvc/eqhw"

//DATETIME=`date +'%Y-%m-%d %H:%M:%S'`
    QDateTime now = QDateTime::currentDateTime();
    QString REPORTDT = now.toString(QStringLiteral("yyyy-MM-dd hh:mm:ss"));

//#UUID=`sudo dmidecode -t 1|grep UUID | awk -F ':' '{print $2}'`
//UUID=`cat /etc/hamonize/uuid |head -1`

//CPUID=`dmidecode -t 4|grep ID`
//CPUINFO=`cat /proc/cpuinfo | grep "model name" | head -1 | cut  -d" " -f3- | sed "s/^ *//g"`
//#HDDID=`hdparm -I /dev/sda | grep 'Serial\ Number' |awk -F ':' '{print $2}'`
//IPADDR=`ifconfig | awk '/inet .*broadcast/'|awk '{print $2}'`
//MACADDR=`ifconfig | awk '/ether/'|awk '{print $2}'`
//HOSTNAME=`hostname`
//MEMORY=`awk '{ printf "%.2f", $2/1024/1024 ; exit}' /proc/meminfo`
//HDDTMP=`fdisk -l | head -1 | awk '{print $2}'| awk -F':' '{print $1}'`
//HDDID=`hdparm -I $HDDTMP  | grep 'Serial\ Number' |awk -F ':' '{print $2}'`
//HDDINFO=`hdparm -I $HDDTMP  | grep 'Model\ Number' |awk -F ':' '{print $2}'`
//USER_HOME=`ls /tmp |grep guest*`
//USERID=`cat /tmp/$USER_HOME/.huserinfo | head -1 | awk -F '=' '{print $1}'`

}

//#!/bin/bash

//hw_path="/etc/hamonize/hwchk"
//SERVER_API="http://10.4.0.2:8082/hmsvc/eqhw"
//DATETIME=`date +'%Y-%m-%d %H:%M:%S'`
//#UUID=`sudo dmidecode -t 1|grep UUID | awk -F ':' '{print $2}'`
//UUID=`cat /etc/hamonize/uuid |head -1`
//CPUID=`dmidecode -t 4|grep ID`
//CPUINFO=`cat /proc/cpuinfo | grep "model name" | head -1 | cut  -d" " -f3- | sed "s/^ *//g"`
//#HDDID=`hdparm -I /dev/sda | grep 'Serial\ Number' |awk -F ':' '{print $2}'`
//IPADDR=`ifconfig | awk '/inet .*broadcast/'|awk '{print $2}'`
//MACADDR=`ifconfig | awk '/ether/'|awk '{print $2}'`
//HOSTNAME=`hostname`
//MEMORY=`awk '{ printf "%.2f", $2/1024/1024 ; exit}' /proc/meminfo`
//HDDTMP=`fdisk -l | head -1 | awk '{print $2}'| awk -F':' '{print $1}'`
//HDDID=`hdparm -I $HDDTMP  | grep 'Serial\ Number' |awk -F ':' '{print $2}'`
//HDDINFO=`hdparm -I $HDDTMP  | grep 'Model\ Number' |awk -F ':' '{print $2}'`
//USER_HOME=`ls /tmp |grep guest*`
//USERID=`cat /tmp/$USER_HOME/.huserinfo | head -1 | awk -F '=' '{print $1}'`


//inxi -c0 -SGNM >> ${hw_path}/sgbpc_hw_chk
//diff_val=`diff -q ${hw_path}/sgbpc_hw_base ${hw_path}/sgbpc_hw_chk` >> /var/log/hamonize/sgbpc_hw_chk/sgbpc_hw_chk.log


//if [ -z "$diff_val" ]
//then
//	rm -fr ${hw_path}/sgbpc_hw_chk

//else
//	#LOG="$UUID|$DATETIME|$CPUID|$CPUINFO|$HDDID|$HDDINFO|$MACADDR|$IPADDR|$HOSTNAME|$MEMORY|$SGBNAME"
//
/*
    LOG_JSON="{\
            \"events\" : [ {\
            \"datetime\":\"$DATETIME\",\
            \"uuid\":\"$UUID\",\
            \"cpuid\": \"$CPUID\",\
            \"cpuinfo\": \"$CPUINFO\",\
            \"hddid\": \"$HDDID\",\
            \"hddinfo\": \"$HDDINFO\",\
            \"macaddr\": \"$MACADDR\",\
            \"ipaddr\": \"$IPADDR\",\
            \"hostname\": \"$HOSTNAME\",\
            \"memory\": \"$MEMORY\",\
            \"sgbname\": \"$SGBNAME\",\
            \"user\": \"$USERID\"\
            } ]\
    }"
*/

//	#RETVAL=`curl  -X  POST -H 'User-Agent: HamoniKR OS' -H 'Content-Type: application/json' -f -s -d "$LOG_JSON" $SERVER_API`
//	RETVAL=`curl  -X  POST  -H 'Content-Type: application/json' -f -s -d "$LOG_JSON" $SERVER_API`

//	dateval=`date +"%Y-%m-%d-%T"`
//	mv ${hw_path}/sgbpc_hw_chk ${hw_path}/sgb_pc_hw_chk_${dateval}



//fi
