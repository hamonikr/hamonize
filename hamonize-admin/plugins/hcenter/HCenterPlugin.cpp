/*
 * HCenterPlugin.cpp - implementation of HCenterPlugin class
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

#include "CommandLineIO.h"
#include "ConfigurationManager.h"
#include "HCenterNetworkObjectDirectory.h"
#include "HCenterPlugin.h"
#include "HCenterConfigurationPage.h"
#include "HCenterDirectory.h"
#include "VeyonConfiguration.h"


HCenterPlugin::HCenterPlugin( QObject* parent ) :
	QObject( parent ),
	m_configuration( &VeyonCore::config() ),
	m_ldapClient( nullptr ),
	m_ldapDirectory( nullptr ),
	m_commands( {
{ QStringLiteral("autoconfigurebasedn"), tr( "Auto-configure the base DN via naming context" ) },
{ QStringLiteral("query"), tr( "Query objects from LDAP directory" ) },
{ QStringLiteral("help"), tr( "Show help about command" ) },
				} )
{
}



HCenterPlugin::~HCenterPlugin()
{
	delete m_ldapDirectory;
	m_ldapDirectory = nullptr;

	delete m_ldapClient;
	m_ldapClient = nullptr;
}



void HCenterPlugin::upgrade( const QVersionNumber& oldVersion )
{
	if( oldVersion < QVersionNumber( 1, 1 ) )
	{
		const auto upgradeFilter = []( const QString& filter ) {
			if( filter.isEmpty() == false &&
					filter.startsWith( QLatin1Char('(') ) == false )
			{
				return QStringLiteral("(%1)").arg( filter );
			}
			// already upgraded or special filter so don't touch
			return filter;
		};

		m_configuration.setComputerContainersFilter( upgradeFilter( m_configuration.computerContainersFilter() ) );
		m_configuration.setComputerGroupsFilter( upgradeFilter( m_configuration.computerGroupsFilter() ) );
		m_configuration.setComputersFilter( upgradeFilter( m_configuration.computersFilter() ) );
		m_configuration.setUserGroupsFilter( upgradeFilter( m_configuration.userGroupsFilter() ) );
		m_configuration.setUsersFilter( upgradeFilter( m_configuration.usersFilter() ) );

		// bind password not encrypted yet?
		const auto rawBindPassword = m_configuration.bindPasswordProperty().variantValue().toString();
		if( rawBindPassword.size() < MaximumPlaintextPasswordLength )
		{
			// setting it again will encrypt it
			m_configuration.setBindPassword( Configuration::Password::fromPlainText( rawBindPassword ) );
		}
	}
	else if( oldVersion < QVersionNumber( 1, 2 ) )
	{
		m_configuration.setUserLoginNameAttribute( m_configuration.legacyUserLoginAttribute() );
		m_configuration.setComputerLocationsByAttribute( m_configuration.legacyComputerRoomMembersByAttribute() );
		m_configuration.setComputerLocationsByContainer( m_configuration.legacyComputerRoomMembersByContainer() );
		m_configuration.setComputerLocationAttribute( m_configuration.legacyComputerRoomAttribute() );
		m_configuration.setLocationNameAttribute( m_configuration.legacyComputerRoomNameAttribute() );
	}
}



QStringList HCenterPlugin::commands() const
{
	return m_commands.keys();
}



QString HCenterPlugin::commandHelp( const QString& command ) const
{
	return m_commands.value( command );
}



NetworkObjectDirectory *HCenterPlugin::createNetworkObjectDirectory( QObject* parent )
{
	return new HCenterNetworkObjectDirectory( m_configuration, parent );
}



void HCenterPlugin::reloadConfiguration()
{
	delete m_ldapDirectory;
	m_ldapDirectory = new HCenterDirectory( m_configuration );
}



QStringList HCenterPlugin::userGroups( bool queryDomainGroups )
{
	Q_UNUSED(queryDomainGroups);

	return HCenterClient::stripBaseDn( ldapDirectory().userGroups(), ldapClient().baseDn() );
}



QStringList HCenterPlugin::groupsOfUser( const QString& username, bool queryDomainGroups )
{
	Q_UNUSED(queryDomainGroups);

	const auto strippedUsername = VeyonCore::stripDomain( username );

	const QString userDn = ldapDirectory().users( strippedUsername ).value( 0 );

	if( userDn.isEmpty() )
	{
		vWarning() << "empty user DN for user" << strippedUsername;
		return QStringList();
	}

	return HCenterClient::stripBaseDn( ldapDirectory().groupsOfUser( userDn ), ldapClient().baseDn() );
}



ConfigurationPage *HCenterPlugin::createConfigurationPage()
{
	return new HCenterConfigurationPage( m_configuration );
}



CommandLinePluginInterface::RunResult HCenterPlugin::handle_autoconfigurebasedn( const QStringList& arguments )
{
	QUrl ldapUrl;
	ldapUrl.setUrl( arguments.value( 0 ), QUrl::StrictMode );

	if( ldapUrl.isValid() == false || ldapUrl.host().isEmpty() )
	{
		CommandLineIO::error( tr("Please specify a valid LDAP url following the schema "
								 "\"ldap[s]://[user[:password]@]hostname[:port]\"") );
		return InvalidArguments;
	}

	QString namingContextAttribute = arguments.value( 1 );

	if( namingContextAttribute.isEmpty() )
	{
		CommandLineIO::warning( tr("No naming context attribute name given - falling back to configured value." ) );
	}
	else
	{
		m_configuration.setNamingContextAttribute( namingContextAttribute );
	}

	HCenterClient ldapClient( m_configuration, ldapUrl );
	QString baseDn = ldapClient.queryNamingContexts().value( 0 );

	if( baseDn.isEmpty() )
	{
		CommandLineIO::error( tr("Could not query base DN. Please check your LDAP configuration." ) );
		return Failed;
	}

	CommandLineIO::info( tr( "Configuring %1 as base DN and disabling naming context queries." ).arg( baseDn ) );

	m_configuration.setBaseDn( baseDn );
	m_configuration.setQueryNamingContext( false );

	// write configuration
	ConfigurationManager configurationManager;
	if( configurationManager.saveConfiguration() == false )
	{
		CommandLineIO::error( configurationManager.errorString() );
		return Failed;
	}

	return Successful;
}



CommandLinePluginInterface::RunResult HCenterPlugin::handle_query( const QStringList& arguments )
{
	QString objectType = arguments.value( 0 );
	QString filter = arguments.value( 1 );
	QStringList results;

	if( objectType == QStringLiteral("locations") )
	{
		results = ldapDirectory().computerLocations( filter );
	}
	else if( objectType == QStringLiteral("computers") )
	{
		results = ldapDirectory().computersByHostName( filter );
	}
	else if( objectType == QStringLiteral("groups") )
	{
		results = ldapDirectory().groups( filter );
	}
	else if( objectType == QStringLiteral("users") )
	{
		results = ldapDirectory().users( filter );
	}
	else
	{
		return InvalidArguments;
	}

	for( const auto& result : qAsConst( results ) )
	{
		printf( "%s\n", qUtf8Printable( result ) );
	}

	return Successful;
}




CommandLinePluginInterface::RunResult HCenterPlugin::handle_help( const QStringList& arguments )
{
	QString command = arguments.value( 0 );

	if( command == QStringLiteral("autoconfigurebasedn") )
	{
		printf( "\n"
				"ldap autoconfigurebasedn <LDAP URL> [<naming context attribute name>]\n"
				"\n"
				"Automatically configures the LDAP base DN configuration setting by querying\n"
				"the naming context attribute from given LDAP server. The LDAP url parameter\n"
				"needs to follow the schema:\n"
				"\n"
				"  ldap[s]://[user[:password]@]hostname[:port]\n\n" );
		return NoResult;
	}
	else if( command == QStringLiteral("query") )
	{
		printf( "\n"
				"ldap query <object type> [filter]\n"
				"\n"
				"Query objects from configured LDAP directory where <object type> may be one\n"
				"of \"locations\", \"computers\", \"groups\" or \"users\". You can optionally\n"
				"specify a filter such as \"foo*\".\n"
				"\n" );
		return NoResult;
	}

	return InvalidCommand;
}



HCenterClient& HCenterPlugin::ldapClient()
{
	if( m_ldapClient == nullptr )
	{
		m_ldapClient = new HCenterClient( m_configuration );
	}

	// TODO: check whether still connected and reconnect if neccessary

	return *m_ldapClient;
}



HCenterDirectory& HCenterPlugin::ldapDirectory()
{
	if( m_ldapDirectory == nullptr )
	{
		m_ldapDirectory = new HCenterDirectory( m_configuration );
	}

	// TODO: check whether still connected and reconnect if neccessary

	return *m_ldapDirectory;
}
