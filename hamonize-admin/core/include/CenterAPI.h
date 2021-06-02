#ifndef CENTERAPI_H
#define CENTERAPI_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonObject>

#include "HWInfo.h"

class CenterAPI : public QObject
{
    Q_OBJECT
public:
    explicit CenterAPI(QObject *parent = nullptr);
    void inetLog();
    void hwChangedLog(HWInfo* hwinfo);

signals:

public slots:
    void onPostAnswer(QNetworkReply* reply);

private:
    QNetworkAccessManager *m_nam;
};

#endif // CENTERCORE_H

