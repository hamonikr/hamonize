/*
 * MainWindow.cpp - implementation of MainWindow class
 *
 * Copyright (c) 2004-2019 Tobias Junghans <tobydox@veyon.io>
 *
 * This file is part of Veyon - https://veyon.io
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public
 * License along with this program (see COPYING); if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 *
 */

#include "DeskerWidget.h"
#include "deskeradaptor.h"

#include "Calc.h"

#include "PlatformCoreFunctions.h"
#include "PlatformInputDeviceFunctions.h"
#include "PlatformUserFunctions.h"

#include <QtDBus/QDBusConnection>
#include <QCloseEvent>
#include <QKeyEvent>

#include <QApplication>
#include <QDesktopWidget>
#include <QPainter>
#include <QString>


DeskerWidget::DeskerWidget( QObject* parent ) //:
//    QWidget( parent, Qt::X11BypassWindowManagerHint ),
//    m_background( background ),
//    m_mode( mode )
{
    lock( BackgroundPixmap,
          QPixmap( QStringLiteral(":/screenlock/locked-screen-background.png" ) ) );

    qDebug() << __PRETTY_FUNCTION__;
    new IDeskerAdaptor(this);
    QDBusConnection dbus = QDBusConnection::sessionBus();
    dbus.registerObject(QStringLiteral("/org/hamonikr/ODesker"), this);
    dbus.registerService(QStringLiteral("org.hamonikr.SDesker"));

    m_guestLoginName = QStringLiteral("dbus-test");  // 2019.06.10 hihoon PC방 Guest 로그인 시 사용자 로그인 App용 사용자 ID/NAME 세션관리 클래스 내부 변수 추가
    m_guestFullName = QStringLiteral("DBUS사용자");

}


DeskerWidget::~DeskerWidget()
{
    VeyonCore::platform().inputDeviceFunctions().enableInputDevices();
    VeyonCore::platform().coreFunctions().setSystemUiState( true );

    QGuiApplication::restoreOverrideCursor();
}


void DeskerWidget::paintEvent( QPaintEvent* event )
{
    Q_UNUSED(event);

    QPainter p( this );
    switch( m_mode )
    {
    case DesktopVisible:
        p.drawPixmap( 0, 0, m_background );
        break;

    case BackgroundPixmap:
        p.fillRect( rect(), QColor( 64, 64, 64 ) );
        p.drawPixmap( ( width() - m_background.width() ) / 2,
                      ( height() - m_background.height() ) / 2,
                      m_background );
        break;

    default:
        break;
    }
}


void DeskerWidget::lock( Mode mode, const QPixmap& background, QWidget* parent ) //:

{
    VeyonCore::platform().coreFunctions().setSystemUiState( false );
    VeyonCore::platform().inputDeviceFunctions().disableInputDevices();

    if( mode == DesktopVisible )
    {
        m_background = QPixmap::grabWindow( qApp->desktop()->winId() );
    }

    setWindowTitle( QString() );
    showFullScreen();
    move( 0, 0 );
    setFixedSize( qApp->desktop()->size() );
    VeyonCore::platform().coreFunctions().raiseWindow( this );
    setFocusPolicy( Qt::StrongFocus );
    setFocus();
    grabMouse();
    grabKeyboard();
    setCursor( Qt::BlankCursor );
    QGuiApplication::setOverrideCursor( Qt::BlankCursor );

    QCursor::setPos( mapToGlobal( QPoint( 0, 0 ) ) );
}



QStringList DeskerWidget::getGuestUserInfo()
{
    m_userLoginName = VeyonCore::platform().userFunctions().currentUser();
    QStringList guestUserInfo = {m_userFullName, QString()};

    emit newGuest(guestUserInfo);

    return guestUserInfo;
}
