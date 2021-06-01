/*
 * LinuxCoreFunctions.h - declaration of LinuxCoreFunctions class
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

#pragma once

#include <QDBusInterface>

#include "PlatformCoreFunctions.h"

// clazy:excludeall=copyable-polymorphic


class LinuxCoreFunctions : public PlatformCoreFunctions
{
public:
	LinuxCoreFunctions();

	bool applyConfiguration() override;

	void initNativeLoggingSystem( const QString& appName ) override;
	void writeToNativeLoggingSystem( const QString& message, Logger::LogLevel loglevel ) override;

	void reboot() override;
	void powerDown( bool installUpdates ) override;

	void raiseWindow( QWidget* widget ) override;

	void disableScreenSaver() override;
	void restoreScreenSaverSettings() override;

	void setSystemUiState( bool enabled ) override;

	QString activeDesktopName() override;

	bool isRunningAsAdmin() const override;
	bool runProgramAsAdmin( const QString& program, const QStringList& parameters ) override;

	bool runProgramAsUser( const QString& program, const QStringList& parameters,
						   const QString& username,
						   const QString& desktop = QString() ) override;

	QString genericUrlHandler() const override;

    // SFR-004 39 PC의 H/W에 대한 정보는 부팅시 매번 최초 등록된 정보화 비교하여 변경이 일어난 경우
    //            해당 PC는 사용불가 상태 처리하고 변경된 정보는 즉시 중앙관리시스템으로 전송되어야 함.
    bool isHWChanged();

	typedef QSharedPointer<QDBusInterface> DBusInterfacePointer;

	static DBusInterfacePointer kdeSessionManager();
	static DBusInterfacePointer gnomeSessionManager();
	static DBusInterfacePointer mateSessionManager();
	static DBusInterfacePointer xfcePowerManager();
	static DBusInterfacePointer systemdLoginManager();
	static DBusInterfacePointer consoleKitManager();

    static DBusInterfacePointer guestLoginManager();


private:
	int m_screenSaverTimeout;
	int m_screenSaverPreferBlanking;
	bool m_dpmsEnabled;
	unsigned short m_dpmsStandbyTimeout;
	unsigned short m_dpmsSuspendTimeout;
	unsigned short m_dpmsOffTimeout;

};
