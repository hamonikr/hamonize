#ifndef HWINFO_H
#define HWINFO_H

#include <QObject>
#include <QJsonObject>
#include <QJsonDocument>

class HWInfo : public QSysInfo, QObject
{

public:
    HWInfo(QObject *parent = nullptr);
    ~HWInfo();

    bool isChanged();
    QString originHWSignature();
    QString currentHWSignature();

    enum {
        Origin = 0,
        Current = 1,
    };

    /* Hardware Info */
    QString getMachineId(int moment);
    QString getMainBoardSerial(int moment);
    QString getBIOSSerial(int moment);
    QStringList getCPUSerial(int moment);
    QStringList getMemorySerial(int moment);
    QStringList getMacAddress(int moment);
    QStringList getDiskSerial(int moment);

    /* Network Info */
    QString getHostname(int moment);
    QStringList getIP(int moment);

    void saveSignatureToFile();

    /* List hardware */
    QJsonDocument lshw();

signals:

public slots:

private:

    QString m_hostName;
    QString m_orginMachinId;
    QString m_orginBoardId;
    QStringList m_orginMacAddress;
    QStringList m_orginDiskId;

    QString m_currentMachinId;
    QString m_currentBoardId;
    QStringList m_currentMacAddress;
    QStringList m_currentDiskId;

    QStringList m_hwinfoList;
};

#endif // HWINFO_H
