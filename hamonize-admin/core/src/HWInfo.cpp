#include "HWInfo.h"

#include <QDir>
#include <QFile>
#include <QNetworkInterface>
#include <QProcess>
#include <QCryptographicHash>

#include "VeyonCore.h"
#include "Filesystem.h"
#include "PlatformFilesystemFunctions.h"
#include "CryptoCore.h"

HWInfo::HWInfo( QObject* parent ) : QObject( parent )
{
    m_hostName = machineHostName();
//    m_lshwRawData = lshw();
}


HWInfo::~HWInfo()
{

}

void HWInfo::saveSignatureToFile()
{
    QString base;
    base = VeyonCore::platform().filesystemFunctions().globalAppDataPath();
    QString fileNameBase( QLatin1String( "signature" ) );

    vDebug() << "Hardware signature save start.";

    QString fileName( base + QDir::separator() + fileNameBase + QLatin1String(".key") );
    QFile file( fileName );

    if( !QFileInfo::exists( fileName) )
    {
        if(file.open( QIODevice::ReadWrite | QIODevice::Text ))
        {
//            vDebug() << "currentHWSignature:\n" << currentHWSignature();
//            vDebug() << "currentHWSignature().toStdString():\n" << currentHWSignature().toStdString();
//            vDebug() << "currentHWSignature().toStdString().c_str():\n" << currentHWSignature().toStdString().c_str();

            file.write( currentHWSignature().toStdString().c_str() );
            file.close();
            vDebug() << "Hardware signature saved.";
        }
        else
        {
            vCritical() << fileName << "is not open.";
        }
    }
    else {
        vDebug() << fileName << "is exists. ";
    }
}


bool HWInfo::isChanged()
{
    vDebug() << "orgin   HWSignature:\n" << originHWSignature();
    vDebug() << "current HWSignature:\n" << currentHWSignature();

    if ( originHWSignature() != currentHWSignature() )
    {

        QString fileName( QLatin1String("/usr/lib/hamonize/eqhw") );

        if( QFileInfo::exists( fileName ) )
        {
            QString command( QStringLiteral("bash -c \"/usr/lib/hamonize/eqhw\""));

            QProcess process;
            process.start(command);

            process.waitForFinished(-1); // will wait forever until finished

            vDebug() << "process.readAllStandardError() :" << process.readAllStandardError();
        }

        return true;
    }

    return false;
}


QString HWInfo::originHWSignature()
{
    vDebug() << "START.";

    saveSignatureToFile();

    QString originsignature;

    QString base;
    base = VeyonCore::platform().filesystemFunctions().globalAppDataPath();
    QString fileNameBase( QLatin1String( "signature" ) );

    QString fileName( base + QDir::separator() + fileNameBase + QLatin1String(".key") );
    QFile file( fileName );

    if( QFileInfo::exists( fileName ) )
    {
        if( file.open( QIODevice::ReadOnly | QIODevice::Text ) )
        {
            originsignature = QString::fromUtf8( file.readAll() );
            file.close();
            vDebug() << "System hardware initial signature read.";
        }
        else
        {
            vCritical() << fileName << "is not open for initial signature.";
        }
    }
    else {
        vDebug() << fileName << "is not exists during read initial signature. ";
    }

    vDebug() << "FINISH.";
    return originsignature;
}

QString HWInfo::currentHWSignature()
{

    QStringList hwinfoList;

    hwinfoList.clear();

    hwinfoList.append(getMachineId(Current));
    hwinfoList.append(getMainBoardSerial(Current));

    hwinfoList += getMemorySerial(Current);
    hwinfoList += getDiskSerial(Current);
    hwinfoList += getMacAddress(Current);

    vDebug() << "m_hwinfoList: " << hwinfoList;

//    QString::QString(const char*)’ is private
//    This is an issue with your Qt installation/version.
//    As of dcf3bdd Veyon itself does not contain any implicit
//    QString/ASCII casts any longer.
//    To workaround this issue you can edit CMakeLists.txt and
//    remove the -DQT_NO_CAST_FROM_ASCII and -DQT_NO_CAST_TO_ASCII defines.
//    QString plaintext = hwinfoList.join("");
    QString plaintext;

    for(auto str : qAsConst(hwinfoList))
    {
//        vDebug() << "str:" << str;
        plaintext.append(str);
    }

//    vDebug() << "plaintext: " << plaintext;

    QCryptographicHash hash(QCryptographicHash::RealSha3_512);
    hash.addData( plaintext.toLocal8Bit() );

    return hash.result().toBase64();

//    return VeyonCore::cryptoCore().encryptPassword( plaintext );
}

QString HWInfo::getMachineId(int moment)
{
#ifdef WIN32
    // wmic csproduct get identifyingnumber
    //   IdentifyingNumber
    //   9S716K212224ZH3000026

        QString command( QStringLiteral("wmic csproduct get identifyingnumber"));

        QProcess process;
        process.start(command);

        process.waitForFinished(-1); // will wait forever until finished

        QString machineID = QString::fromLatin1( process.readAllStandardOutput().data() )
                .remove(QRegExp(QStringLiteral("[\n\t\r ]")));

        machineID = machineID.split("IdentifyingNumber").last();
        qDebug() << "list :" << machineID;

        qDebug() << "process.readAllStandardError() :" << process.readAllStandardError();

//        QString stderr = QString::fromLocal8Bit( process.readAllStandardError() );

        return machineID;

#else
    QString machineID;

    QFile file( QStringLiteral("/etc/machine-id") );

    if( file.exists() && file.open(QIODevice::ReadOnly | QIODevice::Text) ) {

        QTextStream in(&file);

        machineID = in.readLine();

        return machineID;
    }

    return machineID;
#endif
}


QString HWInfo::getMainBoardSerial(int moment)
{
#ifdef WIN32
//wmic baseboard get serialnumber
//    SerialNumber
//    BSS-0123456789

    QString command( QStringLiteral("wmic baseboard get serialnumber"));

    QProcess process;
    process.start(command);

    process.waitForFinished(-1); // will wait forever until finished

    QString mainboardserial = QString::fromLatin1( process.readAllStandardOutput().data() )
            .remove(QRegExp(QStringLiteral("[\n\t\r ]")));

    mainboardserial = mainboardserial.split("SerialNumber").last();
    qDebug() << "list :" << mainboardserial;

    qDebug() << "process.readAllStandardError() :" << process.readAllStandardError();

//    QString stderr = QString::fromLocal8Bit( process.readAllStandardError() );

    return mainboardserial;


#else
    QString command( QStringLiteral("bash -c \"/usr/sbin/dmidecode -t 2|/bin/grep 'Serial Number'|/usr/bin/awk -F': ' '{print $2}'\""));

    QProcess process;
    process.start(command);

    process.waitForFinished(-1); // will wait forever until finished

    QString mainboardserial = QString::fromLatin1( process.readAllStandardOutput().data() )
            .remove(QRegExp(QStringLiteral("[\n\t\r]")));

    vDebug() << "process.readAllStandardError() :" << process.readAllStandardError();

    QString stderr = QString::fromLocal8Bit( process.readAllStandardError() );

    return mainboardserial;
#endif
}

QString HWInfo::getMainBoardInfo(int moment)
{
#ifdef WIN32
//wmic baseboard get product
//    Product
//    MS-16K2

    QString command( QStringLiteral("wmic baseboard get product"));

    QProcess process;
    process.start(command);

    process.waitForFinished(-1); // will wait forever until finished

    QString mainboardproduct = QString::fromLatin1( process.readAllStandardOutput().data() )
            .remove(QRegExp(QStringLiteral("[\n\t\r ]")));

    mainboardproduct = mainboardproduct.split("SerialNumber").last();
    qDebug() << "list :" << mainboardproduct;

    qDebug() << "process.readAllStandardError() :" << process.readAllStandardError();

//    QString stderr = QString::fromLocal8Bit( process.readAllStandardError() );

    return mainboardproduct;


#else
    QString command( QStringLiteral("bash -c \"/usr/sbin/dmidecode -t 2|/bin/grep 'Product Name'|/usr/bin/awk -F': ' '{print $2}'\""));

    QProcess process;
    process.start(command);

    process.waitForFinished(-1); // will wait forever until finished

    QString mainboardproduct = QString::fromLatin1( process.readAllStandardOutput().data() )
            .remove(QRegExp(QStringLiteral("[\n\t\r]")));

    vDebug() << "process.readAllStandardError() :" << process.readAllStandardError();

    QString stderr = QString::fromLocal8Bit( process.readAllStandardError() );

    return mainboardproduct;
#endif
}


QString HWInfo::getBIOSSerial(int moment)
{
#ifdef WIN32
    // wmic bios get serialnumber : wmic csproduct get identifyingnumber 동일결과임
//    SerialNumber
//    9S716K212224ZH3000026

    QString command( QStringLiteral("wmic bios get serialnumber"));

    QProcess process;
    process.start(command);

    process.waitForFinished(-1); // will wait forever until finished

    QString serial = QString::fromLatin1( process.readAllStandardOutput().data() )
            .remove(QRegExp(QStringLiteral("[\n\t\r ]")));

    serial = serial.split("SerialNumber").last();
    qDebug() << "list :" << serial;

    qDebug() << "process.readAllStandardError() :" << process.readAllStandardError();

//    QString stderr = QString::fromLocal8Bit( process.readAllStandardError() );

    return serial;


#else

    return getMachineId(moment);

#endif
}


QString HWInfo::getBIOSInfo(int moment)
{
#ifdef WIN32
// wmic bios get manufacturer
//    Manufacturer
//    American Megatrends Inc.

    QString command( QStringLiteral("wmic bios get manufacturer"));

    QProcess process;
    process.start(command);

    process.waitForFinished(-1); // will wait forever until finished

    QString manufacturer = QString::fromLatin1( process.readAllStandardOutput().data() )
            .remove(QRegExp(QStringLiteral("[\n\t\r ]")));

    manufacturer = manufacturer.split("SerialNumber").last();
    qDebug() << "list :" << manufacturer;

    qDebug() << "process.readAllStandardError() :" << process.readAllStandardError();

//    QString stderr = QString::fromLocal8Bit( process.readAllStandardError() );

    return manufacturer;


#else

    QString biosvendor;

    QString command( QStringLiteral("bash -c \"/usr/sbin/dmidecode -t 0|/bin/grep 'Vendor'|/usr/bin/awk -F': ' '{print $2}'\""));

    QProcess process;
    process.start(command);

    process.waitForFinished(-1); // will wait forever until finished

    biosvendor =  QString::fromLatin1( process.readAllStandardOutput().data() )
                .remove( QRegExp(QStringLiteral("[\n\t\r]") ) );

    vDebug() << "process.readAllStandardError() :" << process.readAllStandardError();

    QString stderr = QString::fromLocal8Bit( process.readAllStandardError() );

    return biosvendor;

#endif
}


QStringList HWInfo::getCPUSerial(int moment)
{
    QStringList cpuserialList;
#ifdef WIN32

// wmic cpu get serialnumber

    QString command( QStringLiteral("wmic cpu get serialnumber"));

    QProcess process;
    process.start(command);

    process.waitForFinished(-1); // will wait forever until finished

    QString cpuserial =  QString::fromLatin1( process.readAllStandardOutput().data() )
                .remove(QRegExp(QStringLiteral("[\n\t\r ]")));

    cpuserial = cpuserial.split("SerialNumber").last();

    cpuserialList.append((cpuserial));

    qDebug() << "list :" << cpuserialList;

    qDebug() << "process.readAllStandardError() :" << process.readAllStandardError();

//    QString stderr = QString::fromLocal8Bit( process.readAllStandardError() );

#else
    QString command( QStringLiteral("bash -c \"/usr/sbin/dmidecode -t 4|/bin/grep 'ID:'|/usr/bin/awk -F': ' '{print $2}'\""));

    QProcess process;
    process.start(command);

    process.waitForFinished(-1); // will wait forever until finished

    cpuserialList.append(
                QString::fromLatin1( process.readAllStandardOutput().data() )
                .remove( QRegExp(QStringLiteral("[\n\t\r]") ) )
                );

    vDebug() << "process.readAllStandardError() :" << process.readAllStandardError();

    QString stderr = QString::fromLocal8Bit( process.readAllStandardError() );

#endif
    return cpuserialList;
}



QStringList HWInfo::getCPUInfo(int moment)
{
    QStringList cpuinfoList;
#ifdef WIN32

// wmic cpu get serialnumber

    QString command( QStringLiteral("wmic cpu get name"));

    QProcess process;
    process.start(command);

    process.waitForFinished(-1); // will wait forever until finished

    QString cpuinfo = QString::fromLatin1( process.readAllStandardOutput().data() )
            .remove(QRegExp(QStringLiteral("[\n\t\r ]" ) ) );

    cpuinfo = cpuinfo.split("Name").last();

    cpuinfoList.append(cpuinfo);

    qDebug() << "list :" << cpuinfo;

    qDebug() << "process.readAllStandardError() :" << process.readAllStandardError();

//    QString stderr = QString::fromLocal8Bit( process.readAllStandardError() );

#else
    QString command( QStringLiteral("bash -c \"/usr/sbin/dmidecode -t 4|/bin/grep 'Version:'|/usr/bin/awk -F': ' '{print $2}'\""));

    QProcess process;
    process.start(command);

    process.waitForFinished(-1); // will wait forever until finished

    cpuinfoList.append(
                QString::fromLatin1( process.readAllStandardOutput().data() )
                .remove( QRegExp(QStringLiteral("[\n\t\r]") ) )
                );

    vDebug() << "process.readAllStandardError() :" << process.readAllStandardError();

    QString stderr = QString::fromLocal8Bit( process.readAllStandardError() );

#endif
    return cpuinfoList;
}



QStringList HWInfo::getMemorySerial(int moment)
{
    QStringList memorySerials;
#ifdef WIN32

    // wmic cpu get serialnumber

//c:\>wmic memorychip get serialnumber
//SerialNumber
//91AB9A10
//9EBD9A10
    ;
#else

    QString command( QStringLiteral("bash -c \"/usr/sbin/dmidecode -t memory|/bin/grep 'Serial Number:'|/usr/bin/awk -F': ' '{print $2}'\""));

    QProcess process;
    process.start(command);

    process.waitForFinished(-1); // will wait forever until finished

    memorySerials.append(
                QString::fromLatin1( process.readAllStandardOutput().data() )
                .remove( QRegExp(QStringLiteral("[\n\t\r]") ) )
                );

    vDebug() << "process.readAllStandardError() :" << process.readAllStandardError();

    QString stderr = QString::fromLocal8Bit( process.readAllStandardError() );




#endif
    return memorySerials;
}

QStringList HWInfo::getMacAddress(int moment)
{
    Q_UNUSED(moment)

    QStringList macaddressList;

#ifdef WIN32

    QStringList strList;
    QProcess process;

    QString command( QLatin1String("wmic nic get macaddress, pnpdeviceid" ) );

    process.start(command);
    process.waitForFinished(-1); // will wait forever until finished

    QString rawData = QString::fromLatin1( process.readAllStandardOutput().data() );
    rawData = rawData.replace( QRegExp( QStringLiteral( "[\t ]+" ) ), QLatin1String("|"));

    strList = rawData.split( QRegExp( QStringLiteral( "[\r\n]+" ) ) );

    qDebug() << strList.length();

    for ( const auto& line : qAsConst(strList))
    {

        if(line.contains( QRegExp ( QLatin1String( "\\|PCI" ))))
        {
            vDebug() << line;
            macaddressList.append( line.split("|").first() );
        }

    }


#else

    foreach(QNetworkInterface netInterface, QNetworkInterface::allInterfaces())
    {
        // Return only the first non-loopback MAC Address
        if ( !( netInterface.flags() & QNetworkInterface::IsLoopBack ) )
            macaddressList.append( netInterface.hardwareAddress() );
    }

#endif

    return macaddressList;
}

QStringList HWInfo::getDiskSerial(int moment)
{
    QStringList diskserialList;
    QProcess process;

#ifdef WIN32
//c:\>wmic diskdrive get serialnumber
//    SerialNumber
//    0008_0D02_001A_99BE.
//    S3YDNWAK100332W

    QString command( QLatin1String("wmic diskdrive get serialnumber" ) );

    process.start(command);
    process.waitForFinished(-1); // will wait forever until finished

    QString rawData = QString::fromLatin1( process.readAllStandardOutput().data() );
    rawData = rawData.replace( QRegExp( QStringLiteral( "SerialNumber[\r\n\t \\.]+" ) ), "" );

    diskserialList.append(
                rawData.split( QRegExp( QStringLiteral( "[\r\n\t \\.]+" ) ) )
                );


#else

    QString command( QStringLiteral( "bash -c \"for i in `fdisk -l |grep '^Disk /'|awk -F' ' '{print $2}'|sed 's/://'`;do hdparm -I $i |grep 'Serial Number:'|sed 's/\\s*//'|awk -F': ' '{print $2}'|sed 's/ *//'; done\"" )  );

    process.start(command);

    process.waitForFinished(-1); // will wait forever until finished

    diskserialList.append( QString::fromLatin1( process.readAllStandardOutput().data() )
            .remove( QRegExp( QStringLiteral( "[\r\n\t ]" ) ) ) );

#endif

    vDebug() << "process.readAllStandardError() :" << process.readAllStandardError();

//    QString stderr = QString::fromLocal8Bit( process.readAllStandardError() );

    return diskserialList;

}

QStringList HWInfo::getDisks(int moment)
{
    QStringList diskList;
    QProcess process;

#ifdef WIN32
//c:\>wmic diskdrive get serialnumber
//    SerialNumber
//    0008_0D02_001A_99BE.
//    S3YDNWAK100332W

    QString command( QLatin1String("wmic diskdrive get serialnumber" ) );

    process.start(command);
    process.waitForFinished(-1); // will wait forever until finished

    QString rawData = QString::fromLatin1( process.readAllStandardOutput().data() );
    rawData = rawData.replace( QRegExp( QStringLiteral( "SerialNumber[\r\n\t \\.]+" ) ), "" );

    diskserialList.append(
                rawData.split( QRegExp( QStringLiteral( "[\r\n\t \\.]+" ) ) )
                );


#else

// hamonikr@hmkme:~/workspace/sgb-util/data-systeminfo$ sudo fdisk -l |grep "^Disk /"|awk -F' ' '{print $2}'
// /dev/sda:
// /dev/sdb:

    QString command( QStringLiteral( "bash -c \"/sbin/fdisk -l | grep '^Disk /'|/usr/bin/awk -F' ' '{print $2}'\"" ) );

    process.start(command);
    process.waitForFinished(-1); // will wait forever until finished

    QString rawData = QString::fromLatin1( process.readAllStandardOutput().data() );
    rawData = rawData.replace( QRegExp( QStringLiteral( "[\t :]+" ) ), "" );

    diskList.append(
                rawData.split( QRegExp( QStringLiteral( "[\r\n]+" ) ) )
                );

#endif

    vDebug() << "process.readAllStandardError() :" << process.readAllStandardError();

//    QString stderr = QString::fromLocal8Bit( process.readAllStandardError() );

    return diskList;

}

QJsonDocument HWInfo::lshw()
{
    QJsonDocument doc;

#ifdef WIN32

    // wmic cpu get serialnumber
#else

    QString command( QStringLiteral( "lshw -json -quiet" ) );

    QProcess process;
    process.start( command );

    process.waitForFinished(-1); // will wait forever until finished

    QString data = QString::fromLatin1( process.readAllStandardOutput().data() );

//    qDebug() << "Result: \n\n" << data;
//    qDebug() << "process.readAllStandardError() :" << process.readAllStandardError();

    QString stderr = QString::fromLocal8Bit( process.readAllStandardError() );

    doc = QJsonDocument::fromJson( data.toUtf8() );

#endif
    return doc;
}
