/*
 * RemoteAccessFeaturePlugin.h - declaration of RemoteAccessFeaturePlugin class
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

#include <QProcess>

#include "Computer.h"
#include "SimpleFeatureProvider.h"
#include "CommandLinePluginInterface.h"
#include "VncView.h"

class RemoteAccessBiosFeaturePlugin : public QObject, CommandLinePluginInterface, SimpleFeatureProvider, PluginInterface
{
	Q_OBJECT
	Q_PLUGIN_METADATA(IID "io.veyon.Veyon.Plugins.RemoteAccessBios")
	Q_INTERFACES(PluginInterface FeatureProviderInterface CommandLinePluginInterface)
public:
	RemoteAccessBiosFeaturePlugin( QObject* parent = nullptr );
	~RemoteAccessBiosFeaturePlugin() override = default;

	Plugin::Uid uid() const override
	{
		return QStringLiteral("4248ea24-f04a-4445-950d-b0133846ec90");
	}

	QVersionNumber version() const override
	{
		return QVersionNumber( 1, 1 );
	}

	QString name() const override
	{
		return QStringLiteral("RemoteAccessBios");
	}

	QString description() const override
	{
		return tr( "Remote control BIOS of a computer" );
	}

	QString vendor() const override
	{
		return QStringLiteral("Invesume Inc.");
	}

	QString copyright() const override
	{
		return QStringLiteral("Hihoon");
	}

	const FeatureList& featureList() const override;

	bool startFeature( VeyonMasterInterface& master, const Feature& feature,
					   const ComputerControlInterfaceList& computerControlInterfaces ) override;

	QString commandLineModuleName() const override
	{
		return QStringLiteral( "remoteaccessbios" );
	}

	QString commandLineModuleHelp() const override
	{
		return description();
	}

	QStringList commands() const override;

	QString commandHelp( const QString& command ) const override;

private slots:
	CommandLinePluginInterface::RunResult handle_view( const QStringList& arguments );
	CommandLinePluginInterface::RunResult handle_control( const QStringList& arguments );
	CommandLinePluginInterface::RunResult handle_bioscontrol( const QStringList& arguments );
	CommandLinePluginInterface::RunResult handle_help( const QStringList& arguments );

private:
	bool initAuthentication();
	// 2019.05.10 hihoon RemoteBIOSControl mode 추가 
	// 2019.05.10 hihoon remark // bool remoteAccess( const QString& hostAddress, bool viewOnly );
	bool remoteAccessBios( const QString& hostAddress, VncView::Mode remoteMode );

	//const Feature m_remoteViewFeature;
	//const Feature m_remoteControlFeature;
    const Feature m_remoteControlBIOSFeature;
	const FeatureList m_features;

	QMap<QString, QString> m_commands;

    QProcess *Process;
};
