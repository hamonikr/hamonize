/*
 * UserSessionControl.h - declaration of UserSessionControl class
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

#include <QReadWriteLock>

#include "SimpleFeatureProvider.h"

class QThread;
class QTimer;

class VEYON_CORE_EXPORT UserSessionControl : public QObject, public SimpleFeatureProvider, public PluginInterface
{
	Q_OBJECT
	Q_INTERFACES(FeatureProviderInterface PluginInterface)
public:
	UserSessionControl( QObject* parent = nullptr );
	~UserSessionControl() override;

	bool getUserSessionInfo( const ComputerControlInterfaceList& computerControlInterfaces );

    void setGuestUserInfo(const QString& guestId, const QString& guestName);

	Plugin::Uid uid() const override
	{
		return QStringLiteral("80580500-2e59-4297-9e35-e53959b028cd");
	}

	QVersionNumber version() const override
	{
		return QVersionNumber( 1, 1 );
	}

	QString name() const override
	{
		return QStringLiteral( "UserSessionControl" );
	}

	QString description() const override
	{
		return tr( "User session control" );
	}

	QString vendor() const override
	{
		return QStringLiteral( "Veyon Community" );
	}

	QString copyright() const override
	{
		return QStringLiteral( "Tobias Junghans" );
	}

	const FeatureList& featureList() const override
	{
		return m_features;
	}

	bool startFeature( VeyonMasterInterface& master, const Feature& feature,
					   const ComputerControlInterfaceList& computerControlInterfaces ) override;

	bool handleFeatureMessage( VeyonMasterInterface& master, const FeatureMessage& message,
							   ComputerControlInterface::Pointer computerControlInterface ) override;

    bool handleFeatureMessage( VeyonServerInterface& server, const MessageContext& messageContext,
							   const FeatureMessage& message ) override;

private:
	enum Commands
	{
		GetInfo,
		LogonUser,
		LogoffUser
	};

	enum Arguments
	{
		UserLoginName,
		UserFullName,
        GuestLoginName, // 2019.06.10 hihoon PC방 Guest 로그인 시 사용자 로그인 App용 사용자 ID/NAME 전달 변수 추가
        GuestFullName,  // 2019.06.10 hihoon PC방 Guest 로그인 시 사용자 로그인 App용 사용자 ID/NAME 전달 변수 추가
	};

	void queryUserInformation();
    void queryGuestUserInformation();
	bool confirmFeatureExecution( const Feature& feature, QWidget* parent );

	const Feature m_userSessionInfoFeature;
	const Feature m_userLogoffFeature;
	const FeatureList m_features;

	QReadWriteLock m_userDataLock;
	QString m_userLoginName;
	QString m_userFullName;
    QString m_guestLoginName;  // 2019.06.10 hihoon PC방 Guest 로그인 시 사용자 로그인 App용 사용자 ID/NAME 세션관리 클래스 내부 변수 추가
    QString m_guestFullName;   // 2019.06.10 hihoon PC방 Guest 로그인 시 사용자 로그인 App용 사용자 ID/NAME 세션관리 클래스 내부 변수 추가
};
