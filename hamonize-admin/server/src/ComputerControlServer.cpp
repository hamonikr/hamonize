/*
 * ComputerControlServer.cpp - implementation of ComputerControlServer
 *
 * Copyright (c) 2006-2019 Tobias Junghans <tobydox@veyon.io>
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

#include <QCoreApplication>
#include <QHostInfo>
#include <QtConcurrent>

#include "VncProxyConnection.h"
#include "UserSessionControl.h"
#include "PlatformCoreFunctions.h"
#include "AccessControlProvider.h"
#include "BuiltinFeatures.h"
#include "ComputerControlClient.h"
#include "ComputerControlServer.h"
#include "FeatureMessage.h"
#include "VeyonConfiguration.h"
#include "SystemTrayIcon.h"
#include "DeskerWidget.h"

#include "HWInfo.h"

#include "PlatformUserFunctions.h"


ComputerControlServer::ComputerControlServer( QObject* parent ) :
	QObject( parent ),
	m_allowedIPs(),
	m_failedAuthHosts(),
	m_featureManager(),
	m_featureWorkerManager( *this, m_featureManager ),
	m_serverAuthenticationManager( this ),
	m_serverAccessControlManager( m_featureWorkerManager, VeyonCore::builtinFeatures().desktopAccessDialog(), this ),
//    m_guestLoginManager( ComputerControlServer::guestLoginManager() ),
    m_hwInfo( new HWInfo() ),
    m_vncServer(),
	m_vncProxyServer( VeyonCore::config().localConnectOnly() || AccessControlProvider().isAccessToLocalComputerDenied() ?
						  QHostAddress::LocalHost : QHostAddress::Any,
					  VeyonCore::config().primaryServicePort() + VeyonCore::sessionId(),
					  this,
                      this ),
    m_screenLockFeature( QStringLiteral( "ScreenLock" ),
                         Feature::Mode | Feature::AllComponents,
                         Feature::Uid( "ccb535a2-1d24-4cc1-a709-8b47d2b2ac79" ),
                         Feature::Uid(),
                         tr( "Lock" ), tr( "Unlock" ),
                         tr( "To reclaim all user's full attention you can lock "
                             "their computers using this button. "
                             "In this mode all input devices are locked and "
                             "the screens are blacked." ),
                         QStringLiteral(":/screenlock/system-lock-screen.png") ),
    m_watcher( new QFileSystemWatcher()),
    m_deskerCore( new DeskerWidget( parent ))
{
    vDebug() << "Constructor Start!";

	VeyonCore::builtinFeatures().systemTrayIcon().setToolTip(
				tr( "%1 Service %2 at %3:%4" ).arg( VeyonCore::applicationName(), VeyonCore::version(),
													QHostInfo::localHostName(),
													QString::number( VeyonCore::config().primaryServicePort() + VeyonCore::sessionId() ) ),
				m_featureWorkerManager );

	// make app terminate once the VNC server thread has finished
	connect( &m_vncServer, &VncServer::finished, QCoreApplication::instance(), &QCoreApplication::quit );

	connect( &m_serverAuthenticationManager, &ServerAuthenticationManager::authenticationDone,
			 this, &ComputerControlServer::showAuthenticationMessage );

//    connectToGuestLoginManager();

    vDebug() << "Constructor Finish!";
}



ComputerControlServer::~ComputerControlServer()
{
	vDebug();

    delete m_hwInfo;
	m_vncProxyServer.stop();
}


// TODO hihoon : hamonize-configuration에서 Desker Login Manager 환경 설정 필요 (모든계정에서 사용할 지, Guest게정에서만 사용할지 설정)
//void ComputerControlServer::connectToGuestLoginManager()
//{
//    bool success = true;

//    const auto service = m_guestLoginManager->service();
//    const auto path = m_guestLoginManager->path();
//    const auto interface = m_guestLoginManager->interface();


//    success &= QDBusConnection::systemBus().connect( service, path, interface, QStringLiteral("deskerSessionLogon"),
//                                                     this, SLOT(guestLogin(QString,QString)) );

//    success &= QDBusConnection::systemBus().connect( service, path, interface, QStringLiteral("deskerSessionLogoout"),
//                                                     this, SLOT(guestLogout()) );

//    if( success == false )
//    {
//        vWarning() << "could not connect to guest login manager! retrying in" << LoginManagerReconnectInterval << "msecs";
//        QTimer::singleShot( LoginManagerReconnectInterval, this, &ComputerControlServer::connectToGuestLoginManager );
//    }
//    else
//    {
//        vDebug() << "connected to guest login manager";
//    }
//}

bool ComputerControlServer::start()
{
    vDebug() << "Start!";

	if( m_vncProxyServer.start( m_vncServer.serverPort(), m_vncServer.password() ) == false )
	{
		return false;
	}

	m_vncServer.prepare();
	m_vncServer.start();


//    m_deskerCore->show();

    vDebug() << "HardwareChangeCheck:" << VeyonCore::config().isHardwareChangeCheck();

    if( VeyonCore::config().isHardwareChangeCheck() )  {

        vDebug() << "HardwareChangeCheck: loop";

        if( m_hwInfo->isChanged() )
        {
            vDebug() << "local Lock Screen!";
            localLock();
            //        sendToCenterLog(CenterAPI::LockComputer);
        }

    }
    vDebug() << "Finish!";
	return true;
}



VncProxyConnection* ComputerControlServer::createVncProxyConnection( QTcpSocket* clientSocket,
																	 int vncServerPort,
																	 const QString& vncServerPassword,
																	 QObject* parent )
{
//    vDebug() << "vncServerPort, vncServerPassword:" << vncServerPort << vncServerPassword;
	return new ComputerControlClient( this, clientSocket, vncServerPort, vncServerPassword, parent );
}



bool ComputerControlServer::handleFeatureMessage( QTcpSocket* socket )
{
	char messageType;
	if( socket->getChar( &messageType ) == false )
	{
		vWarning() << "could not read feature message!";
		return false;
	}

	// receive message
	FeatureMessage featureMessage;
	if( featureMessage.isReadyForReceive( socket ) == false )
	{
		socket->ungetChar( messageType );
		return false;
	}

	featureMessage.receive( socket );

	return m_featureManager.handleFeatureMessage( *this, MessageContext( socket ), featureMessage );
}



bool ComputerControlServer::sendFeatureMessageReply( const MessageContext& context, const FeatureMessage& reply )
{
    vDebug() << reply.featureUid() << reply.command() << reply.arguments();

	char rfbMessageType = FeatureMessage::RfbMessageType;
	context.ioDevice()->write( &rfbMessageType, sizeof(rfbMessageType) );

	return reply.send( context.ioDevice() );
}

/*
 * hihoon 임시 코딩 함 : guest login id/name을 일렉트론 버전을 사용할때 /tmp/guest.../huserinfo 파일로 전달받기 위함
 */
void ComputerControlServer::watchingGuestUser()
{

//#ifdef WIN32

//#else


    QtConcurrent::run( [=]() {

        const auto guestUserInfo = VeyonCore::platform().userFunctions().guestUserInfo();
        const auto guestLoginName = guestUserInfo.first();
    } );


//#endif
}

///*! Returns DBus interface for session manager of Guest login manager */
///*! 윈도우에서는 D-Bus를 사용할 수 없으므로 해당 InterfacePointer는 plugins/platfom/linux,window가 다르게 구현해야한다 */
//ComputerControlServer::DBusInterfacePointer ComputerControlServer::guestLoginManager()
//{
//    auto res = DBusInterfacePointer::create( QStringLiteral("org.hamonikr.SDesker"),
//                                         QStringLiteral("/org/hamonikr/ODesker"),
//                                         QStringLiteral("org.hamonikr.IDesker"),
//                                         QDBusConnection::systemBus() );
//    vDebug() << __PRETTY_FUNCTION__ << "### hihoon ### res :" << res;
//    return res;

//}

/* Server 스스로 screenlock feature message를 생성하여 PC를 Lock 할 수 있는 함수 */
void ComputerControlServer::localLock()
{

    vDebug() << __PRETTY_FUNCTION__ << "Lock system";

    // ScreenLock feature 생성
    FeatureMessage message( Feature::Uid( "ccb535a2-1d24-4cc1-a709-8b47d2b2ac79" ), StartLockCommand );
//    Feature screenLockFeature( QStringLiteral( "ScreenLock" ),
//                     Feature::Mode | Feature::AllComponents,
//                     Feature::Uid( "ccb535a2-1d24-4cc1-a709-8b47d2b2ac79" ),
//                     Feature::Uid(),
//                     tr( "Lock" ), tr( "Unlock" ),
//                     tr( "To reclaim all user's full attention you can lock "
//                         "their computers using this button. "
//                         "In this mode all input devices are locked and "
//                         "the screens are blacked." ),
//                      QStringLiteral(":/screenlock/system-lock-screen.png") );

    if( m_featureWorkerManager.isWorkerRunning( m_screenLockFeature ) == false &&
            message.command() != StopLockCommand )
    {
        m_featureWorkerManager.startWorker( m_screenLockFeature, FeatureWorkerManager::ManagedSystemProcess );
//        m_featureWorkerManager.startWorker( screenLockFeature, FeatureWorkerManager::UnmanagedSessionProcess );
    }
    m_featureWorkerManager.sendMessage( message );

    vDebug() << "### Finish";
}


void ComputerControlServer::guestLogin( const QString& guestId, const QString& guestName )
{

    vDebug() << __PRETTY_FUNCTION__ << "### hihoon ### guestId, guestName" << guestId << guestName;

    VeyonCore::builtinFeatures().userSessionControl().setGuestUserInfo(guestId, guestName);

    VncProxyServer::VncProxyConnectionList connClients = m_vncProxyServer.clients();

    // UserSessionControl feature 생성
    FeatureMessage reply( Feature::Uid( "79a5e74d-50bd-4aab-8012-0e70dc08cc72" ), FeatureMessage::DefaultCommand );

    for ( auto connClient : qAsConst( connClients) ) {

        auto socket = connClient->proxyClientSocket();
        const MessageContext messageContext( socket );

        reply.addArgument( GuestLoginName, guestId );
        reply.addArgument( GuestFullName, guestName );

        sendFeatureMessageReply( messageContext, reply );
    }

    vDebug() << "### connections.length() :" << connClients.length();
}


void ComputerControlServer::guestLogout()
{

    vDebug() << __PRETTY_FUNCTION__ ;

    VeyonCore::builtinFeatures().userSessionControl().setGuestUserInfo( QStringLiteral(""), QStringLiteral(""));

    VncProxyServer::VncProxyConnectionList connClients = m_vncProxyServer.clients();

    FeatureMessage reply( Feature::Uid( "79a5e74d-50bd-4aab-8012-0e70dc08cc72" ), FeatureMessage::DefaultCommand );

    for ( auto connClient : qAsConst( connClients) ) {

        auto socket = connClient->proxyClientSocket();
        const MessageContext messageContext( socket );

        reply.addArgument( GuestLoginName, QStringLiteral("") );
        reply.addArgument( GuestFullName, QStringLiteral("") );

        sendFeatureMessageReply( messageContext, reply );
    }

}

void ComputerControlServer::showAuthenticationMessage( ServerAuthenticationManager::AuthResult result, const QString& host, const QString& user )
{
	if( result == ServerAuthenticationManager::AuthResultSuccessful )
	{
		vInfo() << "successfully authenticated" << user << "at host" << host;

		if( VeyonCore::config().remoteConnectionNotificationsEnabled() )
		{
			VeyonCore::builtinFeatures().systemTrayIcon().showMessage(
						tr( "Remote access" ),
						tr( "User \"%1\" at host \"%2\" is now accessing this computer." ).arg( user, host ),
						m_featureWorkerManager );
		}
	}
	else if( result == ServerAuthenticationManager::AuthResultFailed )
	{
		vWarning() << "failed authenticating client" << host << user;

		if( VeyonCore::config().failedAuthenticationNotificationsEnabled() )
		{
			QMutexLocker l( &m_dataMutex );

			if( m_failedAuthHosts.contains( host ) == false )
			{
				m_failedAuthHosts += host;
				VeyonCore::builtinFeatures().systemTrayIcon().showMessage(
							tr( "Authentication error" ),
							tr( "User \"%1\" at host \"%2\" attempted to access this computer "
								"but could not authenticate successfully!" ).arg( user, host ),
							m_featureWorkerManager );
			}
		}
	}
	else
	{
		vCritical() << "Invalid auth result" << result;
	}
}
