#include <QDebug>

#include "DeskerSessionControl.h"
#include "deskeradaptor.h"

DeskerSessionControl::DeskerSessionControl(QObject *parent)
    : QObject(parent)
{
    qDebug() << __PRETTY_FUNCTION__;
    new IDeskerAdaptor(this);
    QDBusConnection dbus = QDBusConnection::systemBus();

    bool retO = dbus.registerObject( QStringLiteral("/org/hamonikr/ODesker"), this );
    bool retS = dbus.registerService( QStringLiteral("org.hamonikr.SDesker") );

    if ( retO )
    {
        qDebug() << "D-Bus registerObject Error!" << dbus.name();
    }

    if( retS )
    {
        qDebug() << "D-Bus registerService Error!" << dbus.baseService();
    }

}

void DeskerSessionControl::setUserInfo(const QString id, const QString name)
{

    m_guestUserID = id;
    m_guestUserName = name;
}

DeskerSessionControl::~DeskerSessionControl() {}


//public slots:
//double Calc::multiply(double factor0, double factor1)
//{
//    qDebug() << __PRETTY_FUNCTION__ << factor0 << factor1;
//    double product = factor0 * factor1;
//    emit newProduct(product); //signals:
//    return product;
//}


//public slots:
//double Calc::divide(double dividend, double divisor)
//{
//    qDebug() << __PRETTY_FUNCTION__ << dividend << divisor;
//    double quotient = dividend / divisor;
//    emit newQuotient(quotient); //signals:
//    return quotient;
//}


//public slots:
QString DeskerSessionControl::guestLogon()
{
    emit deskerSessionLogon(m_guestUserID, m_guestUserName); //signals:
    return m_guestUserID;
}


//public slots:
void DeskerSessionControl::guestLogout()
{
    emit deskerSessionLogoout(); //signals:
//    return m_guestUserID;
}
