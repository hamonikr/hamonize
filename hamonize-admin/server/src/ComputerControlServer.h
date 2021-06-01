/*
 * ComputerControlServer.h - header file for ComputerControlServer
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

#pragma once

#include <QtCore/QMutex>
#include <QtCore/QStringList>
#include <QApplication>

#include <QFileSystemWatcher>

//#include <QtDBus/QDBusInterface>
//#include <QtDBus/QDBusConnection>

//#include <QDBusInterface>
//#include <QDBusConnection>

#include "VeyonCore.h"
#include "FeatureProviderInterface.h"
#include "FeatureManager.h"
#include "FeatureWorkerManager.h"
#include "RfbVeyonAuth.h"
#include "ServerAuthenticationManager.h"
#include "ServerAccessControlManager.h"
#include "VeyonServerInterface.h"
#include "VncProxyServer.h"
#include "VncProxyConnectionFactory.h"
#include "VncServer.h"
#include "HWInfo.h"
#include "CenterAPI.h"
#include "DeskerWidget.h"

class ComputerControlServer : public QObject, VncProxyConnectionFactory, VeyonServerInterface
{
	Q_OBJECT
public:
	ComputerControlServer( QObject* parent = nullptr );
	~ComputerControlServer() override;

	bool start();

	VncProxyConnection* createVncProxyConnection( QTcpSocket* clientSocket,
												  int vncServerPort,
												  const QString& vncServerPassword,
												  QObject* parent ) override;

	ServerAuthenticationManager& authenticationManager()
	{
		return m_serverAuthenticationManager;
	}

	ServerAccessControlManager& accessControlManager()
	{
		return m_serverAccessControlManager;
	}

	bool handleFeatureMessage( QTcpSocket* socket );

	bool sendFeatureMessageReply( const MessageContext& context, const FeatureMessage& reply ) override;

	void setAllowedIPs( const QStringList &allowedIPs );

	FeatureWorkerManager& featureWorkerManager() override
	{
		return m_featureWorkerManager;
	}

//    typedef QSharedPointer<QDBusInterface> DBusInterfacePointer;

//    static DBusInterfacePointer guestLoginManager();

    void localLock();

private slots:
    void guestLogin( const QString& guestId, const QString& guestName );
    void guestLogout();
    void watchingGuestUser();

private:
    enum Arguments
    {
        UserLoginName,
        UserFullName,
        GuestLoginName, // 2019.06.10 hihoon PC방 Guest 로그인 시 사용자 로그인 App용 사용자 ID/NAME 전달 변수 추가
        GuestFullName,  // 2019.06.10 hihoon PC방 Guest 로그인 시 사용자 로그인 App용 사용자 ID/NAME 전달 변수 추가
    };

    enum {
        LoginManagerReconnectInterval = 3000,
        ServerTerminateTimeout = 3000,
        ServerStopSleepInterval = 100,
        ServerKillDelayTime = 1000,
        SessionEnvironmentProbingInterval = 1000,
        SessionUptimeSecondsMinimum = 3,
        SessionUptimeProbingInterval = 1000,
    };

    enum Commands
    {
        StartLockCommand,
        StopLockCommand,
        CommandCount
    };

	void showAuthenticationMessage( ServerAuthenticationManager::AuthResult result, const QString& host, const QString& user );

    void connectToGuestLoginManager();

	QMutex m_dataMutex;
	QStringList m_allowedIPs;

	QStringList m_failedAuthHosts;

	FeatureManager m_featureManager;
	FeatureWorkerManager m_featureWorkerManager;

	ServerAuthenticationManager m_serverAuthenticationManager;
	ServerAccessControlManager m_serverAccessControlManager;

//    ComputerControlServer::DBusInterfacePointer m_guestLoginManager;

    HWInfo *m_hwInfo;

	VncServer m_vncServer;
	VncProxyServer m_vncProxyServer;


    const Feature m_screenLockFeature;

    QFileSystemWatcher *m_watcher;

    DeskerWidget *m_deskerCore;

    QApplication *m_app;
} ;
