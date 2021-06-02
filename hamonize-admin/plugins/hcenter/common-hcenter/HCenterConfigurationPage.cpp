/*
 * HCenterConfigurationPage.cpp - implementation of the HCenterConfigurationPage class
 *
 * Copyright (c) 2016-2019 Tobias Junghans <tobydox@veyon.io>
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

#include <QFileDialog>
#include <QInputDialog>
#include <QMessageBox>

#include "HCenterConfiguration.h"
#include "HCenterConfigurationPage.h"
#include "Configuration/UiMapping.h"
#include "HCenterDirectory.h"
#include "HCenterBrowseDialog.h"

#include "ui_HCenterConfigurationPage.h"

HCenterConfigurationPage::HCenterConfigurationPage( HCenterConfiguration& configuration, QWidget* parent ) :
	ConfigurationPage( parent ),
    ui(new Ui::HCenterConfigurationPage),
	m_configuration( configuration )
{
	ui->setupUi(this);

#define CONNECT_BUTTON_SLOT(name)	connect( ui->name, &QPushButton::clicked, this, &HCenterConfigurationPage::name );

    connect( ui->browseBaseDn, &QPushButton::clicked, this, &HCenterConfigurationPage::browseBaseDn );
	connect( ui->browseUserTree, &QPushButton::clicked, this, [this]() { browseObjectTree( ui->userTree ); } );
	connect( ui->browseGroupTree, &QPushButton::clicked, this, [this]() { browseObjectTree( ui->groupTree ); } );
	connect( ui->browseComputerTree, &QPushButton::clicked, this, [this]() { browseObjectTree( ui->computerTree ); } );
	connect( ui->browseComputerGroupTree, &QPushButton::clicked, this, [this]() { browseObjectTree( ui->computerGroupTree ); } );

	connect( ui->browseUserLoginNameAttribute, &QPushButton::clicked, this, [this]() { browseAttribute( ui->userLoginNameAttribute, m_configuration.userTree() ); } );
	connect( ui->browseGroupMemberAttribute, &QPushButton::clicked, this, [this]() { browseAttribute( ui->groupMemberAttribute, m_configuration.groupTree() ); } );
	connect( ui->browseComputerDisplayNameAttribute, &QPushButton::clicked, this, [this]() { browseAttribute( ui->computerDisplayNameAttribute, m_configuration.computerTree() ); } );
	connect( ui->browseComputerHostNameAttribute, &QPushButton::clicked, this, [this]() { browseAttribute( ui->computerHostNameAttribute, m_configuration.computerTree() ); } );
	connect( ui->browseComputerMacAddressAttribute, &QPushButton::clicked, this, [this]() { browseAttribute( ui->computerMacAddressAttribute, m_configuration.computerTree() ); } );
	connect( ui->browseComputerLocationAttribute, &QPushButton::clicked, this, [this]() { browseAttribute( ui->computerLocationAttribute, m_configuration.computerTree() ); } );
	connect( ui->browseLocationNameAttribute, &QPushButton::clicked, this, [this]() { browseAttribute( ui->locationNameAttribute, m_configuration.computerTree() ); } );

	CONNECT_BUTTON_SLOT( testBindInteractively );
	CONNECT_BUTTON_SLOT( testBaseDn );
	CONNECT_BUTTON_SLOT( testNamingContext );
	CONNECT_BUTTON_SLOT( testUserTree );
	CONNECT_BUTTON_SLOT( testGroupTree );
	CONNECT_BUTTON_SLOT( testComputerTree );
	CONNECT_BUTTON_SLOT( testComputerGroupTree );

	CONNECT_BUTTON_SLOT( testUserLoginNameAttribute );
	CONNECT_BUTTON_SLOT( testGroupMemberAttribute );
	CONNECT_BUTTON_SLOT( testComputerDisplayNameAttribute );
	CONNECT_BUTTON_SLOT( testComputerHostNameAttribute );
	CONNECT_BUTTON_SLOT( testComputerMacAddressAttribute );
	CONNECT_BUTTON_SLOT( testComputerLocationAttribute );
	CONNECT_BUTTON_SLOT( testLocationNameAttribute );

	CONNECT_BUTTON_SLOT( testUsersFilter );
	CONNECT_BUTTON_SLOT( testUserGroupsFilter );
	CONNECT_BUTTON_SLOT( testComputersFilter );
	CONNECT_BUTTON_SLOT( testComputerGroupsFilter );
	CONNECT_BUTTON_SLOT( testComputerContainersFilter );

	CONNECT_BUTTON_SLOT( testGroupsOfUser );
	CONNECT_BUTTON_SLOT( testGroupsOfComputer );
	CONNECT_BUTTON_SLOT( testComputerObjectByIpAddress );
	CONNECT_BUTTON_SLOT( testLocationEntries );
	CONNECT_BUTTON_SLOT( testLocations );

	CONNECT_BUTTON_SLOT( browseCACertificateFile );

	connect( ui->tlsVerifyMode, QOverload<int>::of( &QComboBox::currentIndexChanged ), ui->tlsCACertificateFile, [=]() {
        ui->tlsCACertificateFile->setEnabled( ui->tlsVerifyMode->currentIndex() == HCenterClient::TLSVerifyCustomCert );
	} );

	const auto browseButtons = findChildren<QPushButton *>( QRegularExpression( QStringLiteral("browse.*") ) );
	for( auto button : browseButtons )
	{
		button->setToolTip( tr( "Browse" ) );
	}

	const auto testButtons = findChildren<QPushButton *>( QRegularExpression( QStringLiteral("test.*") ) );
	for( auto button : testButtons )
	{
		button->setToolTip( tr( "Test" ) );
	}
}



HCenterConfigurationPage::~HCenterConfigurationPage()
{
	delete ui;
}



void HCenterConfigurationPage::resetWidgets()
{
    FOREACH_HCenter_CONFIG_PROPERTY(INIT_WIDGET_FROM_PROPERTY);
}



void HCenterConfigurationPage::connectWidgetsToProperties()
{
    FOREACH_HCenter_CONFIG_PROPERTY(CONNECT_WIDGET_TO_PROPERTY)
}



void HCenterConfigurationPage::applyConfiguration()
{
}



void HCenterConfigurationPage::browseBaseDn()
{
    const auto baseDn = HCenterBrowseDialog( m_configuration, this ).browseBaseDn( m_configuration.baseDn() );

	if( baseDn.isEmpty() == false )
	{
		ui->baseDn->setText( baseDn );
	}
}



void HCenterConfigurationPage::browseObjectTree( QLineEdit* lineEdit )
{
    auto dn = HCenterClient::addBaseDn( lineEdit->text(), m_configuration.baseDn() );

    dn = HCenterBrowseDialog( m_configuration, this ).browseDn( dn );

	if( dn.isEmpty() == false )
	{
        dn = HCenterClient::stripBaseDn( dn, m_configuration.baseDn() );

		lineEdit->setText( dn );
	}
}



void HCenterConfigurationPage::browseAttribute( QLineEdit* lineEdit, const QString& tree )
{
    const auto treeDn = HCenterClient::addBaseDn( tree, m_configuration.baseDn() );

    const auto attribute = HCenterBrowseDialog( m_configuration, this ).browseAttribute( treeDn );

	if( attribute.isEmpty() == false )
	{
		lineEdit->setText( attribute );
	}
}



void HCenterConfigurationPage::testBindInteractively()
{
	testBind( false );
}



void HCenterConfigurationPage::testBaseDn()
{
	if( testBindQuietly() )
	{
        vDebug() << "[TEST][HCenter] Testing base DN";

        HCenterClient HCenterClient( m_configuration );
        QStringList entries = HCenterClient.queryBaseDn();

		if( entries.isEmpty() )
		{
            QMessageBox::critical( this, tr( "HCenter base DN test failed"),
								   tr( "Could not query the configured base DN. "
									   "Please check the base DN parameter.\n\n"
                                       "%1" ).arg( HCenterClient.errorDescription() ) );
		}
		else
		{
            QMessageBox::information( this, tr( "HCenter base DN test successful" ),
                                      tr( "The HCenter base DN has been queried successfully. "
										  "The following entries were found:\n\n%1" ).
									  arg( entries.join(QLatin1Char('\n')) ) );
		}
	}
}



void HCenterConfigurationPage::testNamingContext()
{
	if( testBindQuietly() )
	{
        vDebug() << "[TEST][HCenter] Testing naming context";

        HCenterClient HCenterClient( m_configuration );
        const auto baseDn = HCenterClient.queryNamingContexts().value( 0 );

		if( baseDn.isEmpty() )
		{
            QMessageBox::critical( this, tr( "HCenter naming context test failed"),
								   tr( "Could not query the base DN via naming contexts. "
									   "Please check the naming context attribute parameter.\n\n"
                                       "%1" ).arg( HCenterClient.errorDescription() ) );
		}
		else
		{
            QMessageBox::information( this, tr( "HCenter naming context test successful" ),
                                      tr( "The HCenter naming context has been queried successfully. "
										  "The following base DN was found:\n%1" ).
									  arg( baseDn ) );
		}
	}
}



void HCenterConfigurationPage::testUserTree()
{
	if( testBindQuietly() )
	{
        vDebug() << "[TEST][HCenter] Testing user tree";

        HCenterDirectory HCenterDirectory( m_configuration );
        HCenterDirectory.disableAttributes();
        HCenterDirectory.disableFilters();
        int count = HCenterDirectory.users().count();

        reportHCenterTreeQueryResult( tr( "user tree" ), count, ui->userTreeLabel->text(),
                                   HCenterDirectory.client().errorDescription() );
	}
}



void HCenterConfigurationPage::testGroupTree()
{
	if( testBindQuietly() )
	{
        vDebug() << "[TEST][HCenter] Testing group tree";

        HCenterDirectory HCenterDirectory( m_configuration );
        HCenterDirectory.disableAttributes();
        HCenterDirectory.disableFilters();
        int count = HCenterDirectory.groups().count();

        reportHCenterTreeQueryResult( tr( "group tree" ), count, ui->groupTreeLabel->text(),
                                   HCenterDirectory.client().errorDescription() );
	}
}



void HCenterConfigurationPage::testComputerTree()
{
	if( testBindQuietly() )
	{
        vDebug() << "[TEST][HCenter] Testing computer tree";

        HCenterDirectory HCenterDirectory( m_configuration );
        HCenterDirectory.disableAttributes();
        HCenterDirectory.disableFilters();
        int count = HCenterDirectory.computersByHostName().count();

        reportHCenterTreeQueryResult( tr( "computer tree" ), count, ui->computerTreeLabel->text(),
                                   HCenterDirectory.client().errorDescription() );
	}
}



void HCenterConfigurationPage::testComputerGroupTree()
{
	if( testBindQuietly() )
	{
        vDebug() << "[TEST][HCenter] Testing computer group tree";

        HCenterDirectory HCenterDirectory( m_configuration );
        HCenterDirectory.disableAttributes();
        HCenterDirectory.disableFilters();
        int count = HCenterDirectory.computerGroups().count();

        reportHCenterTreeQueryResult( tr( "computer group tree" ), count, ui->computerGroupTreeLabel->text(),
                                   HCenterDirectory.client().errorDescription() );
	}
}



void HCenterConfigurationPage::testUserLoginNameAttribute()
{
	QString userFilter = QInputDialog::getText( this, tr( "Enter username" ),
												tr( "Please enter a user login name (wildcards allowed) which to query:") );
	if( userFilter.isEmpty() == false )
	{
        vDebug() << "[TEST][HCenter] Testing user login attribute for" << userFilter;

        HCenterDirectory HCenterDirectory( m_configuration );
        HCenterDirectory.disableFilters();

        reportHCenterObjectQueryResults( tr( "user objects" ), { ui->userLoginNameAttributeLabel->text() },
                                      HCenterDirectory.users( userFilter ), HCenterDirectory );
	}
}



void HCenterConfigurationPage::testGroupMemberAttribute()
{
	QString groupFilter = QInputDialog::getText( this, tr( "Enter group name" ),
												 tr( "Please enter a group name whose members to query:") );
	if( groupFilter.isEmpty() == false )
	{
        vDebug() << "[TEST][HCenter] Testing group member attribute for" << groupFilter;

        HCenterDirectory HCenterDirectory( m_configuration );
        HCenterDirectory.disableFilters();

        QStringList groups = HCenterDirectory.groups( groupFilter );

		if( groups.isEmpty() == false )
		{
            reportHCenterObjectQueryResults( tr( "group members" ), { ui->groupMemberAttributeLabel->text() },
                                          HCenterDirectory.groupMembers( groups.first() ), HCenterDirectory );
		}
		else
		{
			QMessageBox::warning( this, tr( "Group not found"),
								  tr( "Could not find a group with the name \"%1\". "
									  "Please check the group name or the group "
									  "tree parameter.").arg( groupFilter ) );
		}
	}
}



void HCenterConfigurationPage::testComputerDisplayNameAttribute()
{
	auto computerName = QInputDialog::getText( this, tr( "Enter computer display name" ),
											   tr( "Please enter a computer display name to query:") );
	if( computerName.isEmpty() == false )
	{
        vDebug() << "[TEST][HCenter] Testing computer display name attribute";

        HCenterDirectory HCenterDirectory( m_configuration );
        HCenterDirectory.disableFilters();

        reportHCenterObjectQueryResults( tr( "computer objects" ), { ui->computerDisplayNameAttributeLabel->text() },
                                      HCenterDirectory.computersByDisplayName( computerName ), HCenterDirectory );
	}

}



void HCenterConfigurationPage::testComputerHostNameAttribute()
{
	QString computerName = QInputDialog::getText( this, tr( "Enter computer name" ),
												  tr( "Please enter a computer hostname to query:") );
	if( computerName.isEmpty() == false )
	{
		if( m_configuration.computerHostNameAsFQDN() &&
			computerName.contains( QLatin1Char('.') ) == false )
		{
			QMessageBox::critical( this, tr( "Invalid hostname" ),
								   tr( "You configured computer hostnames to be stored "
									   "as fully qualified domain names (FQDN) but entered "
									   "a hostname without domain." ) );
			return;
		}
		else if( m_configuration.computerHostNameAsFQDN() == false &&
				 computerName.contains( QLatin1Char('.') ) )
		{
			QMessageBox::critical( this, tr( "Invalid hostname" ),
								   tr( "You configured computer hostnames to be stored "
									   "as simple hostnames without a domain name but "
									   "entered a hostname with a domain name part." ) );
			return;
		}

        vDebug() << "[TEST][HCenter] Testing computer hostname attribute";

        HCenterDirectory HCenterDirectory( m_configuration );
        HCenterDirectory.disableFilters();

        reportHCenterObjectQueryResults( tr( "computer objects" ), { ui->computerHostNameAttributeLabel->text() },
                                      HCenterDirectory.computersByHostName( computerName ), HCenterDirectory );
	}
}



void HCenterConfigurationPage::testComputerMacAddressAttribute()
{
	QString computerDn = QInputDialog::getText( this, tr( "Enter computer DN" ),
												tr( "Please enter the DN of a computer whose MAC address to query:") );
	if( computerDn.isEmpty() == false )
	{
        vDebug() << "[TEST][HCenter] Testing computer MAC address attribute";

        HCenterDirectory HCenterDirectory( m_configuration );
        HCenterDirectory.disableFilters();

        QString macAddress = HCenterDirectory.computerMacAddress( computerDn );

        reportHCenterObjectQueryResults( tr( "computer MAC addresses" ), { ui->computerMacAddressAttributeLabel->text() },
									  macAddress.isEmpty() ? QStringList() : QStringList( macAddress ),
                                      HCenterDirectory );
	}
}



void HCenterConfigurationPage::testComputerLocationAttribute()
{
	const auto locationName = QInputDialog::getText( this, tr( "Enter computer location name" ),
													 tr( "Please enter the name of a computer location (wildcards allowed):") );
	if( locationName.isEmpty() == false )
	{
        vDebug() << "[TEST][HCenter] Testing computer location attribute for" << locationName;

        HCenterDirectory HCenterDirectory( m_configuration );

        reportHCenterObjectQueryResults( tr( "computer locations" ), { ui->computerLocationAttributeLabel->text() },
                                      HCenterDirectory.computerLocations( locationName ), HCenterDirectory );
	}
}



void HCenterConfigurationPage::testLocationNameAttribute()
{
	const auto locationName = QInputDialog::getText( this, tr( "Enter location name" ),
													 tr( "Please enter the name of a computer location (wildcards allowed):") );
	if( locationName.isEmpty() == false )
	{
        vDebug() << "[TEST][HCenter] Testing location name attribute for" << locationName;

        HCenterDirectory HCenterDirectory( m_configuration );

        reportHCenterObjectQueryResults( tr( "computer locations" ), { ui->locationNameAttributeLabel->text() },
                                      HCenterDirectory.computerLocations( locationName ), HCenterDirectory );
	}
}



void HCenterConfigurationPage::testUsersFilter()
{
    vDebug() << "[TEST][HCenter] Testing users filter";

    HCenterDirectory HCenterDirectory( m_configuration );
    int count = HCenterDirectory.users().count();

    reportHCenterFilterTestResult( tr( "users" ), count, HCenterDirectory.client().errorDescription() );
}



void HCenterConfigurationPage::testUserGroupsFilter()
{
    vDebug() << "[TEST][HCenter] Testing user groups filter";

    HCenterDirectory HCenterDirectory( m_configuration );
    int count = HCenterDirectory.userGroups().count();

    reportHCenterFilterTestResult( tr( "user groups" ), count, HCenterDirectory.client().errorDescription() );
}



void HCenterConfigurationPage::testComputersFilter()
{
    vDebug() << "[TEST][HCenter] Testing computers filter";

    HCenterDirectory HCenterDirectory( m_configuration );
    const auto count = HCenterDirectory.computersByHostName().count();

    reportHCenterFilterTestResult( tr( "computers" ), count, HCenterDirectory.client().errorDescription() );
}



void HCenterConfigurationPage::testComputerGroupsFilter()
{
    vDebug() << "[TEST][HCenter] Testing computer groups filter";

    HCenterDirectory HCenterDirectory( m_configuration );
    int count = HCenterDirectory.computerGroups().count();

    reportHCenterFilterTestResult( tr( "computer groups" ), count, HCenterDirectory.client().errorDescription() );
}



void HCenterConfigurationPage::testComputerContainersFilter()
{
    vDebug() << "[TEST][HCenter] Testing computer containers filter";

    HCenterDirectory HCenterDirectory( m_configuration );
    const auto count = HCenterDirectory.computerLocations().count();

    reportHCenterFilterTestResult( tr( "computer containers" ), count, HCenterDirectory.client().errorDescription() );
}



void HCenterConfigurationPage::testGroupsOfUser()
{
	QString username = QInputDialog::getText( this, tr( "Enter username" ),
											  tr( "Please enter a user login name whose group memberships to query:") );
	if( username.isEmpty() == false )
	{
        vDebug() << "[TEST][HCenter] Testing groups of user" << username;

        HCenterDirectory HCenterDirectory( m_configuration );

        QStringList userObjects = HCenterDirectory.users(username);

		if( userObjects.isEmpty() == false )
		{
            reportHCenterObjectQueryResults( tr( "groups of user" ), { ui->userLoginNameAttributeLabel->text(),
																	ui->groupMemberAttributeLabel->text() },
                                          HCenterDirectory.groupsOfUser( userObjects.first() ), HCenterDirectory );
		}
		else
		{
			QMessageBox::warning( this, tr( "User not found" ),
								  tr( "Could not find a user with the name \"%1\". Please check the username "
									  "or the user tree parameter.").arg( username ) );
		}
	}
}



void HCenterConfigurationPage::testGroupsOfComputer()
{
	QString computerHostName = QInputDialog::getText( this, tr( "Enter hostname" ),
													  tr( "Please enter a computer hostname whose group memberships to query:") );
	if( computerHostName.isEmpty() == false )
	{
        vDebug() << "[TEST][HCenter] Testing groups of computer for" << computerHostName;

        HCenterDirectory HCenterDirectory( m_configuration );

        QStringList computerObjects = HCenterDirectory.computersByHostName(computerHostName);

		if( computerObjects.isEmpty() == false )
		{
            reportHCenterObjectQueryResults( tr( "groups of computer" ), { ui->computerHostNameAttributeLabel->text(),
																		ui->groupMemberAttributeLabel->text() },
                                          HCenterDirectory.groupsOfComputer( computerObjects.first() ), HCenterDirectory );
		}
		else
		{
			QMessageBox::warning( this, tr( "Computer not found" ),
								  tr( "Could not find a computer with the hostname \"%1\". "
									  "Please check the hostname or the computer tree "
									  "parameter.").arg( computerHostName ) );
		}
	}
}



void HCenterConfigurationPage::testComputerObjectByIpAddress()
{
	QString computerIpAddress = QInputDialog::getText( this, tr( "Enter computer IP address" ),
													   tr( "Please enter a computer IP address which to resolve to an computer object:") );
	if( computerIpAddress.isEmpty() == false )
	{
        vDebug() << "[TEST][HCenter] Testing computer object resolve by IP address" << computerIpAddress;

        HCenterDirectory HCenterDirectory( m_configuration );

        QString computerName = HCenterDirectory.hostToHCenterFormat( computerIpAddress );

        vDebug() << "[TEST][HCenter] Resolved IP address to computer name" << computerName;

		if( computerName.isEmpty() )
		{
			QMessageBox::critical( this, tr( "Hostname lookup failed" ),
								   tr( "Could not lookup hostname for IP address %1. "
									   "Please check your DNS server settings." ).arg( computerIpAddress ) );
		}
		else
		{
            reportHCenterObjectQueryResults( tr( "computers" ), { ui->computerHostNameAttributeLabel->text() },
                                          HCenterDirectory.computersByHostName( computerName ), HCenterDirectory );
		}

	}
}



void HCenterConfigurationPage::testLocationEntries()
{
	const auto locationName = QInputDialog::getText( this, tr( "Enter location name" ),
													 tr( "Please enter the name of a location whose entries to query:") );
	if( locationName.isEmpty() == false )
	{
        vDebug() << "[TEST][HCenter] Testing location entries for" << locationName;

        HCenterDirectory HCenterDirectory( m_configuration );
        reportHCenterObjectQueryResults( tr( "location entries" ), { ui->computerGroupsFilterLabel->text(),
																  ui->computerLocationsIdentifications->title() },
                                      HCenterDirectory.computerLocationEntries( locationName ), HCenterDirectory );
	}
}



void HCenterConfigurationPage::testLocations()
{
    vDebug() << "[TEST][HCenter] Querying all locations";

    HCenterDirectory HCenterDirectory( m_configuration );
    reportHCenterObjectQueryResults( tr( "location entries" ), { ui->computerGroupsFilterLabel->text(),
															  ui->computerLocationsIdentifications->title() },
                                  HCenterDirectory.computerLocations(), HCenterDirectory );
}



void HCenterConfigurationPage::browseCACertificateFile()
{
	auto caCertFile = QFileDialog::getOpenFileName( this, tr( "Custom CA certificate file" ), QString(),
													tr( "Certificate files (*.pem)" ) );
	if( caCertFile.isEmpty() == false )
	{
		ui->tlsCACertificateFile->setText( caCertFile );
	}
}



bool HCenterConfigurationPage::testBind( bool quiet )
{
    vDebug() << "[TEST][HCenter] Testing bind";

    HCenterClient HCenterClient( m_configuration );

    if( HCenterClient.isConnected() == false )
	{
        QMessageBox::critical( this, tr( "HCenter connection failed"),
                               tr( "Could not connect to the HCenter server. "
								   "Please check the server parameters.\n\n"
                                   "%1" ).arg( HCenterClient.errorDescription() ) );
	}
    else if( HCenterClient.isBound() == false )
	{
        QMessageBox::critical( this, tr( "HCenter bind failed"),
                               tr( "Could not bind to the HCenter server. "
								   "Please check the server parameters "
								   "and bind credentials.\n\n"
                                   "%1" ).arg( HCenterClient.errorDescription() ) );
	}
	else if( quiet == false )
	{
        QMessageBox::information( this, tr( "HCenter bind successful"),
                                  tr( "Successfully connected to the HCenter "
                                      "server and performed an HCenter bind. "
                                      "The basic HCenter settings are "
									  "configured correctly." ) );
	}

    return HCenterClient.isConnected() && HCenterClient.isBound();
}




void HCenterConfigurationPage::reportHCenterTreeQueryResult( const QString& name, int count,
													   const QString& parameter, const QString& errorDescription )
{
	if( count <= 0 )
	{
        QMessageBox::critical( this, tr( "HCenter %1 test failed").arg( name ),
							   tr( "Could not query any entries in configured %1. "
								   "Please check the parameter \"%2\".\n\n"
								   "%3" ).arg( name, parameter, errorDescription ) );
	}
	else
	{
        QMessageBox::information( this, tr( "HCenter %1 test successful" ).arg( name ),
								  tr( "The %1 has been queried successfully and "
									  "%2 entries were found." ).arg( name ).arg( count ) );
	}
}





void HCenterConfigurationPage::reportHCenterObjectQueryResults( const QString &objectsName, const QStringList& parameterNames,
                                                          const QStringList& results, const HCenterDirectory &directory )
{
	if( results.isEmpty() )
	{
		QStringList parameters;
		parameters.reserve( parameterNames.count() );

		for( const auto& parameterName : parameterNames )
		{
			parameters += QStringLiteral("\"%1\"").arg( parameterName );
		}

        QMessageBox::critical( this, tr( "HCenter test failed"),
							   tr( "Could not query any %1. "
								   "Please check the parameter(s) %2 and enter the name of an existing object.\n\n"
								   "%3" ).arg( objectsName, parameters.join( QStringLiteral(" %1 ").arg( tr("and") ) ),
											   directory.client().errorDescription() ) );
	}
	else
	{
        QMessageBox::information( this, tr( "HCenter test successful" ),
								  tr( "%1 %2 have been queried successfully:\n\n%3" ).
								  arg( results.count() ).
								  arg( objectsName, formatResultsString( results ) ) );
	}
}





void HCenterConfigurationPage::reportHCenterFilterTestResult( const QString &filterObjects, int count, const QString &errorDescription )
{
	if( count <= 0 )
	{
        QMessageBox::critical( this, tr( "HCenter filter test failed"),
							   tr( "Could not query any %1 using the configured filter. "
                                   "Please check the HCenter filter for %1.\n\n"
								   "%2" ).arg( filterObjects, errorDescription ) );
	}
	else
	{
        QMessageBox::information( this, tr( "HCenter filter test successful" ),
								  tr( "%1 %2 have been queried successfully using the configured filter." ).
								  arg( count ).arg( filterObjects ) );
	}
}



QString HCenterConfigurationPage::formatResultsString( const QStringList &results )
{
	static constexpr auto FirstResult = 0;
	static constexpr auto MaxResults = 3;

	if( results.count() <= MaxResults )
	{
		return results.join(QLatin1Char('\n'));
	}

	return QStringLiteral( "%1\n[...]" ).arg( results.mid( FirstResult, MaxResults ).join( QLatin1Char('\n') ) );
}
