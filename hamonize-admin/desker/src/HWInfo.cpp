#include "HWInfo.h"

#include <QDir>
#include <QFile>
#include <QNetworkInterface>
#include <QProcess>

#include "VeyonCore.h"
#include "Filesystem.h"
#include "PlatformFilesystemFunctions.h"
#include "CryptoCore.h"

HWInfo::HWInfo( QObject* parent ) : QObject( parent )
{
    m_hostName = machineHostName();
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
    if (originHWSignature() != currentHWSignature())
    {
        return true;
    }

    return false;
}


QString HWInfo::originHWSignature()
{

    saveSignatureToFile();

    QString originsignature;

    QString base;
    base = VeyonCore::platform().filesystemFunctions().globalAppDataPath();
    QString fileNameBase( QLatin1String( "signature" ) );

    vDebug() << "Hardware signature save start.";

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

    return originsignature;
}

QString HWInfo::currentHWSignature()
{

    QStringList hwinfoList;

    hwinfoList.clear();

    hwinfoList.append(getMachineId(Current));
    hwinfoList.append(getMainBoardSerial(Current));

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
        vDebug() << "str:" << str;
        plaintext.append(str);
    }

    vDebug() << "plaintext: " << plaintext;

    return VeyonCore::cryptoCore().encryptPassword( plaintext );
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

        QString stderr = QString::fromLocal8Bit( process.readAllStandardError() );

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

    QString stderr = QString::fromLocal8Bit( process.readAllStandardError() );

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

    machineID = serial.split("IdentifyingNumber").last();
    qDebug() << "list :" << serial;

    qDebug() << "process.readAllStandardError() :" << process.readAllStandardError();

    QString stderr = QString::fromLocal8Bit( process.readAllStandardError() );

    return serial;


#else

    return getMachineId(moment);

#endif
}



QStringList HWInfo::getCPUSerial(int moment)
{
    QStringList cpuserial;
#ifdef WIN32

    // wmic cpu get serialnumber
#else
    QString command( QStringLiteral("bash -c \"/usr/sbin/dmidecode -t 4|/bin/grep 'Serial Number'|/usr/bin/awk -F': ' '{print $2}'\""));

    QProcess process;
    process.start(command);

    process.waitForFinished(-1); // will wait forever until finished

    cpuserial.append(
                QString::fromLatin1( process.readAllStandardOutput().data() )
                .remove( QRegExp(QStringLiteral("[\n\t\r]") ) )
                );

    vDebug() << "process.readAllStandardError() :" << process.readAllStandardError();

    QString stderr = QString::fromLocal8Bit( process.readAllStandardError() );

#endif
    return cpuserial;
}

QStringList HWInfo::getMemorySerial(int moment)
{
    QStringList memoryserial;
#ifdef WIN32

    // wmic cpu get serialnumber

//c:\>wmic memorychip get serialnumber
//SerialNumber
//91AB9A10
//9EBD9A10
    ;
#else
;

#endif
    return memoryserial;
}

QStringList HWInfo::getMacAddress(int moment)
{
    QStringList macaddress;

    foreach(QNetworkInterface netInterface, QNetworkInterface::allInterfaces())
    {
        // Return only the first non-loopback MAC Address
        if ( !( netInterface.flags() & QNetworkInterface::IsLoopBack ) )
            macaddress.append( netInterface.hardwareAddress() );
    }
    return macaddress;
}

QStringList HWInfo::getDiskSerial(int moment)
{
    QStringList diskserial;
#ifdef WIN32
//c:\>wmic diskdrive get serialnumber
//SerialNumber
//FR3AG13032430BC13S

    QString command( QLatin1String("wmic diskdrive get serialnumber" ) );


#else
    QString command( QStringLiteral( "bash -c \"/sbin/hdparm -I /dev/sda | grep 'Serial Number'|/usr/bin/awk -F': ' '{print $2}'\"" ) );

    QProcess process;
    process.start(command);

    process.waitForFinished(-1); // will wait forever until finished

    diskserial.append( QString::fromLatin1( process.readAllStandardOutput().data() )
            .remove( QRegExp( QStringLiteral( "[\n\t\r ]" ) ) ) );

    vDebug() << "process.readAllStandardError() :" << process.readAllStandardError();

    QString stderr = QString::fromLocal8Bit( process.readAllStandardError() );

#endif
    return diskserial;

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

    qDebug() << "Result: \n\n" << data;
    qDebug() << "process.readAllStandardError() :" << process.readAllStandardError();

    QString stderr = QString::fromLocal8Bit( process.readAllStandardError() );

    doc = QJsonDocument::fromJson( data.toUtf8() );

#endif
    return doc;
}
