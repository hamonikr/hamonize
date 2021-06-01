#ifndef CENTERCORE_H
#define CENTERCORE_H

#include <QObject>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QJsonObject>

class CenterCore : public QObject
{
    Q_OBJECT
public:
    explicit CenterCore(QObject *parent = nullptr);

signals:

public slots:
};

#endif // CENTERCORE_H
