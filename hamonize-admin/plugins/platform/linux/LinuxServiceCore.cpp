/*
 * LinuxServiceFunctions.cpp - implementation of LinuxServiceFunctions class
 *
 * Copyright (c) 2017-2019 Tobias Junghans <tobydox@veyon.io>
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

#include <QDateTime>
#include <QDBusReply>
#include <QElapsedTimer>
#include <QEventLoop>
#include <QProcess>
#include <QThread>
#include <QTimer>

#include <proc/readproc.h>

#include "BuiltinFeatures.h"
#include "UserSessionControl.h"
#include "PluginManager.h"
#include "PlatformUserFunctions.h"
#include "Filesystem.h"
#include "LinuxCoreFunctions.h"
#include "LinuxServiceCore.h"
#include "VeyonConfiguration.h"


LinuxServiceCore::LinuxServiceCore( QObject* parent ) :
	QObject( parent ),
	m_loginManager( LinuxCoreFunctions::systemdLoginManager() ),
    m_guestLoginManager( LinuxCoreFunctions::guestLoginManager() ),
    m_multiSession( VeyonCore::config().isMultiSessionServiceEnabled() )
{

	connectToLoginManager();
//    connectToGuestLoginManager();
}



LinuxServiceCore::~LinuxServiceCore()
{
	stopAllServers();
}



void LinuxServiceCore::run()
{
	const auto sessions = listSessions();

	for( const auto& s : sessions )
	{
		startServer( s, QDBusObjectPath( s ) );
	}

	QEventLoop eventLoop;
	eventLoop.exec();
}



void LinuxServiceCore::startServer( const QString& login1SessionId, const QDBusObjectPath& sessionObjectPath )
{
    const auto sessionPath = sessionObjectPath.path();

	const auto sessionType = getSessionType( sessionPath );

	if( sessionType == QStringLiteral("wayland") )
	{
		vCritical() << "Can't start Veyon Server in Wayland sessions as this is not yet supported. Please switch to X11-based sessions!";
		return;
	}

	// do not start server for non-graphical sessions
	if( sessionType != QStringLiteral("x11") )
	{
		return;
	}

	const auto sessionLeader = getSessionLeaderPid( sessionPath );
	if( sessionLeader < 0 )
	{
		vCritical() << "No leader available for session" << sessionPath;
		return;
	}

	auto sessionEnvironment = getSessionEnvironment( sessionLeader );

	if( sessionEnvironment.isEmpty() )
	{
        vWarning() << "Environment for session" << sessionPath << "not yet available - retrying in"
				   << SessionEnvironmentProbingInterval << "msecs";
		QTimer::singleShot( SessionEnvironmentProbingInterval, this,
							[=]() { startServer( login1SessionId, sessionObjectPath ); } );
		return;
	}

	if( m_multiSession == false && m_serverProcesses.isEmpty() == false )
	{
		// make sure no other server is still running
		stopAllServers();
	}

	const auto sessionUptime = getSessionUptimeSeconds( sessionPath );

	if( sessionUptime >= 0 && sessionUptime < SessionUptimeSecondsMinimum )
	{
		vDebug() << "Session" << sessionPath << "too young - retrying in" << SessionUptimeProbingInterval << "msecs";
        QTimer::singleShot( SessionUptimeProbingInterval, this, [=]() { startServer( login1SessionId, sessionObjectPath ); } );
		return;
	}

	const auto seat = getSessionSeat( sessionPath );
	const auto display = getSessionDisplay( sessionPath );

    vInfo() << "Starting server for new session" << login1SessionId << "(" << sessionPath << ")"
			<< "with display" << display
			<< "at seat" << seat.path;

	if( m_multiSession )
	{
		const auto sessionId = openSession( QStringList( { sessionPath, display, seat.path } ) );
		sessionEnvironment.insert( VeyonCore::sessionIdEnvironmentVariable(), QString::number( sessionId ) );
	}

    //    vInfo() << "currentUser:" << currentUser;

//    auto processDesker = new QProcess( this );
//    processDesker->setProcessEnvironment( sessionEnvironment );
//    processDesker->start( VeyonCore::filesystem().deskerFilePath() );
//    m_deskerProcesses[sessionPath] = processDesker;

    auto process = new QProcess( this );
	process->setProcessEnvironment( sessionEnvironment );
	process->start( VeyonCore::filesystem().serverFilePath() );
	m_serverProcesses[sessionPath] = process;

}



void LinuxServiceCore::stopServer( const QString& login1SessionId, const QDBusObjectPath& sessionObjectPath )
{
	Q_UNUSED( login1SessionId );

	const auto sessionPath = sessionObjectPath.path();

	if( m_serverProcesses.contains( sessionPath ) )
	{
		stopServer( sessionPath );
	}

//    if( m_deskerProcesses.contains( sessionPath ) )
//    {
//        stopDesker ( sessionPath );
//    }
}


void LinuxServiceCore::connectToLoginManager()
{
	bool success = true;

	const auto service = m_loginManager->service();
	const auto path = m_loginManager->path();
	const auto interface = m_loginManager->interface();


    success &= QDBusConnection::systemBus().connect( service, path, interface, QStringLiteral("SessionNew"),
													 this, SLOT(startServer(QString,QDBusObjectPath)) );

	success &= QDBusConnection::systemBus().connect( service, path, interface, QStringLiteral("SessionRemoved"),
                                                     this, SLOT(stopServer(QString,QDBusObjectPath)) );

	if( success == false )
	{
		vWarning() << "could not connect to login manager! retrying in" << LoginManagerReconnectInterval << "msecs";
		QTimer::singleShot( LoginManagerReconnectInterval, this, &LinuxServiceCore::connectToLoginManager );
	}
	else
	{
		vDebug() << "connected to login manager";
	}

}



void LinuxServiceCore::stopServer( const QString& sessionPath )
{
	if( m_serverProcesses.contains( sessionPath ) == false )
	{
		return;
	}

	vInfo() << "stopping server for removed session" << sessionPath;

	auto process = qAsConst(m_serverProcesses)[sessionPath];

	process->terminate();

	QElapsedTimer serverStopTimer;
	serverStopTimer.start();

	while( process->state() != QProcess::NotRunning )
	{
		if( serverStopTimer.elapsed() >= ServerTerminateTimeout )
		{
			vWarning() << "server for session" << sessionPath << "still running - killing now";
			process->kill();
			QThread::msleep( ServerKillDelayTime );
			break;
		}

		QThread::msleep( ServerStopSleepInterval );
	}

	if( m_multiSession )
	{
		closeSession( process->processEnvironment().value( VeyonCore::sessionIdEnvironmentVariable() ).toInt() );
	}

	delete process;
	m_serverProcesses.remove( sessionPath );
}

void LinuxServiceCore::stopDesker( const QString& sessionPath )
{
    if( m_deskerProcesses.contains( sessionPath ) == false )
    {
        return;
    }

    vInfo() << "stopping desker for removed session" << sessionPath;

    auto processDesker = qAsConst(m_deskerProcesses)[sessionPath];

    processDesker->terminate();

    QElapsedTimer deskerStopTimer;
    deskerStopTimer.start();

    while( processDesker->state() != QProcess::NotRunning )
    {
        if( deskerStopTimer.elapsed() >= ServerTerminateTimeout )
        {
            vWarning() << "server for session" << sessionPath << "still running - killing now";
            processDesker->kill();
            QThread::msleep( ServerKillDelayTime );
            break;
        }

        QThread::msleep( ServerStopSleepInterval );
    }

    if( m_multiSession )
    {
        closeSession( processDesker->processEnvironment().value( VeyonCore::sessionIdEnvironmentVariable() ).toInt() );
    }

    delete processDesker;
    m_deskerProcesses.remove( sessionPath );
}



void LinuxServiceCore::stopAllServers()
{
	while( m_serverProcesses.isEmpty() == false )
	{
		stopServer( m_serverProcesses.firstKey() );
	}

//    while( m_deskerProcesses.isEmpty() == false )
//    {
//        stopDesker( m_deskerProcesses.firstKey() );
//    }
}



QStringList LinuxServiceCore::listSessions()
{
	QStringList sessions;

	const QDBusReply<QDBusArgument> reply = m_loginManager->call( QStringLiteral("ListSessions") );

	if( reply.isValid() )
	{
		const auto data = reply.value();

		data.beginArray();
		while( data.atEnd() == false )
		{
			LoginDBusSession session;

			data.beginStructure();
			data >> session.id >> session.uid >> session.name >> session.seatId >> session.path;
			data.endStructure();

			sessions.append( session.path.path() );
		}
		return sessions;
	}
	else
	{
		vCritical() << "Could not query sessions:" << reply.error().message();
	}

	return sessions;
}



void LinuxServiceCore::logonDesker( const QString& guestId, const QString& guestName )
{

    vDebug() << __PRETTY_FUNCTION__ << "### hihoon ### guestId, guestName" << guestId << guestName;

    VeyonCore::platform().userFunctions().changeDeskerLoginInfo(guestId, guestName);

//    VeyonCore::builtinFeatures().userSessionControl().getUserSessionInfo( { weakPointer() } );
//    UserSessionControl* userSessionCtl = VeyonCore::builtinFeatures().userSessionControl().getUserSessionInfo( { weakPointer() } );
    VeyonCore::builtinFeatures().userSessionControl().setGuestUserInfo(guestId, guestName);

}



void LinuxServiceCore::connectToGuestLoginManager()
{
    bool success = true;

    const auto service = m_guestLoginManager->service();
    const auto path = m_guestLoginManager->path();
    const auto interface = m_guestLoginManager->interface();


    success &= QDBusConnection::sessionBus().connect( service, path, interface, QStringLiteral("GuestSessionNew"),
                                                     this, SLOT(guestLogin(QString,QDBusObjectPath)) );

    success &= QDBusConnection::sessionBus().connect( service, path, interface, QStringLiteral("GuestSessionRemoved"),
                                                     this, SLOT(guestLogout(QString,QDBusObjectPath)) );

    if( success == false )
    {
        vWarning() << "could not connect to guest login manager! retrying in" << LoginManagerReconnectInterval << "msecs";
        QTimer::singleShot( LoginManagerReconnectInterval, this, &LinuxServiceCore::connectToGuestLoginManager );
    }
    else
    {
        vDebug() << "connected to guest login manager";
    }
}



QVariant LinuxServiceCore::getSessionProperty( const QString& session, const QString& property )
{
	QDBusInterface loginManager( QStringLiteral("org.freedesktop.login1"),
								 session,
								 QStringLiteral("org.freedesktop.DBus.Properties"),
								 QDBusConnection::systemBus() );

	const QDBusReply<QDBusVariant> reply = loginManager.call( QStringLiteral("Get"),
															  QStringLiteral("org.freedesktop.login1.Session"),
															  property );

	if( reply.isValid() == false )
	{
		vCritical() << "Could not query session property" << property << reply.error().message();
		return QVariant();
	}

	return reply.value().variant();
}



int LinuxServiceCore::getSessionLeaderPid( const QString& session )
{
	const auto leader = getSessionProperty( session, QStringLiteral("Leader") );

	if( leader.isNull() )
	{
		return -1;
	}

	return leader.toInt();
}



qint64 LinuxServiceCore::getSessionUptimeSeconds( const QString& session )
{
	const auto timestamp = getSessionProperty( session, QStringLiteral("Timestamp") );

	if( timestamp.isNull() )
	{
		return -1;
	}

	return QDateTime::currentMSecsSinceEpoch() / 1000 - static_cast<qint64>( timestamp.toLongLong() / ( 1000 * 1000 ) );
}



QString LinuxServiceCore::getSessionType( const QString& session )
{
	return getSessionProperty( session, QStringLiteral("Type") ).toString();
}



QString LinuxServiceCore::getSessionDisplay( const QString& session )
{
	return getSessionProperty( session, QStringLiteral("Display") ).toString();
}



QString LinuxServiceCore::getSessionId( const QString& session )
{
	return getSessionProperty( session, QStringLiteral("Id") ).toString();
}



LinuxServiceCore::LoginDBusSessionSeat LinuxServiceCore::getSessionSeat( const QString& session )
{
	const auto seatArgument = getSessionProperty( session, QStringLiteral("Seat") ).value<QDBusArgument>();

	LoginDBusSessionSeat seat;
	seatArgument.beginStructure();
	seatArgument >> seat.id;
	seatArgument >> seat.path;
	seatArgument.endStructure();

	return seat;
}



QProcessEnvironment LinuxServiceCore::getSessionEnvironment( int sessionLeaderPid )
{
	QProcessEnvironment sessionEnv;

	PROCTAB* proc = openproc( PROC_FILLSTATUS | PROC_FILLENV );
	proc_t* procInfo = nullptr;

	QList<int> ppids;

    int proc_cnt = 0;
	while( ( procInfo = readproc( proc, nullptr ) ) )
	{
		if( ( procInfo->ppid == sessionLeaderPid || ppids.contains( procInfo->ppid ) ) &&
				procInfo->environ != nullptr )
		{
			for( int i = 0; procInfo->environ[i]; ++i )
			{
				const auto env = QString::fromUtf8( procInfo->environ[i] ).split( QLatin1Char('=') );
                const auto first = env.first();
                const auto mid = env.mid(1);
                sessionEnv.insert( first, mid.join( QLatin1Char('=') ) );
                //sessionEnv.insert( env.first(), env.mid( 1 ).join( QLatin1Char('=') ) );
			}

			ppids.append( procInfo->tid );
		}
        proc_cnt++;
		freeproc( procInfo );
	}

	closeproc( proc );

	return sessionEnv;
}
