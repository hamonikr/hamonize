#pragma once

#include <QObject>
#include <QWidget>
#include <QtDBus/QDBusConnection>
#include <QtDBus/QDBusAbstractAdaptor>
#include <QString>

class QDBusConnection;

class DeskerSessionControl : public QObject
{
    Q_OBJECT
    Q_CLASSINFO("D-Bus Interface", "org.hamonikr.IDesker")

public:
    explicit DeskerSessionControl(QObject *parent = nullptr);
    virtual ~DeskerSessionControl() override;

    void setUserInfo( const QString id, const QString name );

public slots:
    QString guestLogon();
    void guestLogout();

signals:

    void deskerSessionLogon(QString id, QString name);
    void deskerSessionLogoout();

private:
     QString m_guestUserID;
     QString m_guestUserName;
};
