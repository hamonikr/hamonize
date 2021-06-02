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

#include "PlatformCoreFunctions.h"
#include "PlatformInputDeviceFunctions.h"
#include "PlatformUserFunctions.h"
#include "LockWidget.h"

#include <QtDBus/QDBusConnection>
#include <QCloseEvent>
#include <QKeyEvent>

#include <QApplication>
#include <QDesktopWidget>
#include <QPainter>
#include <QString>
#include <QProcess>


DeskerWidget::DeskerWidget( QObject* parent ) :
//    QWidget( parent, Qt::X11BypassWindowManagerHint ),
//    m_background( background ),
//    m_mode( mode ),
    m_hwinfo( new HWInfo( parent ) ),
    m_lockWidget( nullptr ),
#ifndef WIN32
//    m_webview( new QWebEngineView(this) ),
#endif
    m_geometry()
{

    int h = 100; int d =60;

    m_btnLogin = new QPushButton(tr("test"), this);
    m_btnLogin->setGeometry(QRect(QPoint(100,h), QSize(100,50)));

    QPushButton *btnExit = new QPushButton(tr("Exit"), this);
    btnExit->setGeometry(QRect(QPoint(100,h+d), QSize(100,50)));

    QPushButton *btnSave = new QPushButton(tr("Save"), this);
    btnSave->setGeometry(QRect(QPoint(100,h+d*2), QSize(100,50)));

    QPushButton *btnIndex = new QPushButton(tr("index.html"), this);
    btnIndex->setGeometry(QRect(QPoint(100,h+d*3), QSize(100,50)));

    QPushButton *btnNotice = new QPushButton(tr("notice page"), this);
    btnNotice->setGeometry(QRect(QPoint(100,h+d*4), QSize(100,50)));

    QPushButton *btnLogin = new QPushButton(tr("login page"), this);
    btnLogin->setGeometry(QRect(QPoint(100,h+d*5), QSize(100,50)));

    QPushButton *btnReload = new QPushButton(tr("Reload"), this);
    btnReload->setGeometry(QRect(QPoint(100,h+d*6), QSize(100,50)));

#ifndef WIN32
//    QWebEngineView *m_webview = new QWebEngineView(this);
//    m_webview->setUrl(QUrl(QStringLiteral("file:///home/hamonikr/workspace/veyon-last/hamonize/server/resources/index.html")));
//    m_webview->setGeometry(QRect(QPoint(220,h),QSize(1920,1080)));
//    m_webview->settings()->setAttribute(QWebSettings::DeveloperExtrasEnabled, true);
#endif
    m_geometry = geometry();

//    showFullScreen();
//    move( 0, 0 );
//    setFixedSize( qApp->desktop()->size() );
    VeyonCore::platform().coreFunctions().raiseWindow( this );
    setFocusPolicy( Qt::StrongFocus );
    setFocus();

//    saveTest();

//    m_dbusHandler = new DeskerSessionControl(parent);

    connect( m_btnLogin, SIGNAL (released()), this, SLOT ( handleButtonLogin() ) );
    connect( btnExit, SIGNAL (released()), this, SLOT ( handleButtonExit() ) );

    connect( btnSave, SIGNAL (released()), this, SLOT ( saveTest() ) );
    connect( btnIndex, SIGNAL (released()), this, SLOT ( indexTest() ) );
    connect( btnNotice, SIGNAL (released()), this, SLOT ( noticeTest() ) );
    connect( btnLogin, SIGNAL (released()), this, SLOT ( loginTest() ) );
    connect( btnReload, SIGNAL (released()), this, SLOT ( reload() ) );

    m_guestLoginName = QStringLiteral("dbus-test");  // 2019.06.10 hihoon PC방 Guest 로그인 시 사용자 로그인 App용 사용자 ID/NAME 세션관리 클래스 내부 변수 추가
    m_guestFullName = QStringLiteral("DBUS사용자");


    vDebug() << "HostName :" << m_hwinfo->machineHostName();
    vDebug() << "MachineID :" << m_hwinfo->getMachineId(HWInfo::Origin);
    vDebug() << "MainBoardSerial :" << m_hwinfo->getMainBoardSerial(HWInfo::Origin);
    vDebug() << "MacAddress :" << m_hwinfo->getMacAddress(HWInfo::Origin);

}


DeskerWidget::~DeskerWidget()
{
    delete m_lockWidget;
}

void DeskerWidget::saveTest()
{
    vDebug() << "start.";

    m_hwinfo->saveSignatureToFile();
}

void DeskerWidget::handleButtonLogin()
{
    iTmp += 1;
    m_guestLoginName = QStringLiteral("test%1").arg(iTmp);
    m_guestFullName = QStringLiteral("테스트%1").arg(iTmp);

    m_btnLogin->setText(m_guestLoginName);



//    m_dbusHandler->setUserInfo(m_guestLoginName, m_guestFullName );

//    emit m_dbusHandler->deskerSessionLogon(m_guestLoginName, m_guestFullName);

}

void DeskerWidget::handleButtonExit()
{
    setGeometry(m_geometry);
}


void DeskerWidget::reload()
{
#ifndef WIN32
//    m_webview->reload();
#endif
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

void DeskerWidget::indexTest()
{

//    VeyonCore::platform().coreFunctions().disableScreenSaver();

//    Qt::WindowFlags flags = Qt::X11BypassWindowManagerHint;
//    QWidget::setWindowFlags(flags);


//    lock( BackgroundPixmap,
//              QPixmap( QStringLiteral(":/screenlock/locked-screen-background.png" ) ) );
#ifndef WIN32
//    m_webview->setUrl(QUrl(QStringLiteral("file:///home/hamonikr/workspace/veyon-last/hamonize/server/resources/index.html")));
//    m_webview->load();
#endif
}

void DeskerWidget::noticeTest()
{
//    VeyonCore::platform().coreFunctions().restoreScreenSaverSettings();

//    VeyonCore::platform().inputDeviceFunctions().enableInputDevices();
//    VeyonCore::platform().coreFunctions().setSystemUiState( true );

//    QGuiApplication::restoreOverrideCursor();

//    delete m_lockWidget;
//    m_lockWidget = nullptr;
#ifndef WIN32
//    m_webview->setUrl(QUrl(QStringLiteral("http://192.168.0.2:8084/notice/notice")));
//    m_webview->load();
#endif

}


void DeskerWidget::loginTest()
{
#ifndef WIN32
//    m_webview->setUrl(QUrl(QStringLiteral("http://192.168.0.2:8084/")));
//    m_webview->load();
#endif
}

void DeskerWidget::lock( Mode mode, const QPixmap& background, QWidget* parent ) //:

{

    if( m_lockWidget == nullptr )
    {
        VeyonCore::platform().coreFunctions().disableScreenSaver();

        m_lockWidget = new LockWidget( LockWidget::BackgroundPixmap,
                                       QPixmap( QStringLiteral(":/screenlock/locked-screen-background.png" ) ) );
    }

//    VeyonCore::platform().coreFunctions().setSystemUiState( false );
//    VeyonCore::platform().inputDeviceFunctions().disableInputDevices();

//    if( mode == DesktopVisible )
//    {
//        m_background = QPixmap::grabWindow( qApp->desktop()->winId() );
//    }

//    setWindowTitle( QString() );
//    showFullScreen();
//    move( 0, 0 );
//    setFixedSize( qApp->desktop()->size() );
//    VeyonCore::platform().coreFunctions().raiseWindow( this );
//    setFocusPolicy( Qt::StrongFocus );
//    setFocus();
//    grabMouse();
//    grabKeyboard();
//    setCursor( Qt::BlankCursor );
//    QGuiApplication::setOverrideCursor( Qt::BlankCursor );

//    QCursor::setPos( mapToGlobal( QPoint( 0, 0 ) ) );

}



QStringList DeskerWidget::getGuestUserInfo()
{
    m_userLoginName = VeyonCore::platform().userFunctions().currentUser();
    QStringList guestUserInfo = {m_userFullName, QString()};

    emit newGuest(guestUserInfo);

    return guestUserInfo;
}



// SFR-004 39 PC의 H/W에 대한 정보는 부팅시 매번 최초 등록된 정보화 비교하여 변경이 일어난 경우
//            해당 PC는 사용불가 상태 처리하고 변경된 정보는 즉시 중앙관리시스템으로 전송되어야 함.

bool DeskerWidget::isHWChanged()
{
    if( m_hwinfo->isChanged() )
    {
        return true;
    }

    return false;

}
