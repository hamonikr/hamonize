/*
 * HCenterNetworkObjectDirectory.cpp - provides a NetworkObjectDirectory for HCenter
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

#include "HCenterConfiguration.h"
#include "HCenterDirectory.h"
#include "HCenterNetworkObjectDirectory.h"


HCenterNetworkObjectDirectory::HCenterNetworkObjectDirectory( const HCenterConfiguration& HCenterConfiguration,
														QObject* parent ) :
	NetworkObjectDirectory( parent ),
    m_HCenterDirectory( HCenterConfiguration )
{
}



NetworkObjectList HCenterNetworkObjectDirectory::queryObjects( NetworkObject::Type type, const QString& name )
{
	switch( type )
	{
	case NetworkObject::Location: return queryLocations( name );
	case NetworkObject::Host: return queryHosts( name );
	default: break;
	}

	return {};
}



NetworkObjectList HCenterNetworkObjectDirectory::queryParents( const NetworkObject& object )
{
	switch( object.type() )
	{
	case NetworkObject::Host:
		return { NetworkObject( NetworkObject::Location,
                                m_HCenterDirectory.locationsOfComputer( object.directoryAddress() ).value( 0 ) ) };
	case NetworkObject::Location:
		return { NetworkObject::Root };
	default:
		break;
	}

	return { NetworkObject::None };
}



void HCenterNetworkObjectDirectory::update()
{
    const auto locations = m_HCenterDirectory.computerLocations();
	const NetworkObject rootObject( NetworkObject::Root );

	for( const auto& location : qAsConst( locations ) )
	{
		const NetworkObject locationObject( NetworkObject::Location, location );

		addOrUpdateObject( locationObject, rootObject );

		updateLocation( locationObject );
	}

	removeObjects( NetworkObject::Root, [locations]( const NetworkObject& object ) {
		return object.type() == NetworkObject::Location && locations.contains( object.name() ) == false; } );
}



void HCenterNetworkObjectDirectory::updateLocation( const NetworkObject& locationObject )
{
    const auto computers = m_HCenterDirectory.computerLocationEntries( locationObject.name() );

	for( const auto& computer : qAsConst( computers ) )
	{
        const auto hostObject = computerToObject( &m_HCenterDirectory, computer );
		if( hostObject.type() == NetworkObject::Host )
		{
			addOrUpdateObject( hostObject, locationObject );
		}
	}

	removeObjects( locationObject, [computers]( const NetworkObject& object ) {
		return object.type() == NetworkObject::Host && computers.contains( object.directoryAddress() ) == false; } );
}



NetworkObjectList HCenterNetworkObjectDirectory::queryLocations( const QString& name )
{
    const auto locations = m_HCenterDirectory.computerLocations( name );

	NetworkObjectList locationObjects;
	locationObjects.reserve( locations.size() );

	for( const auto& location : locations )
	{
		locationObjects.append( NetworkObject( NetworkObject::Location, location ) );
	}

	return locationObjects;
}



NetworkObjectList HCenterNetworkObjectDirectory::queryHosts( const QString& name )
{
    const auto computers = m_HCenterDirectory.computersByHostName( name );

	NetworkObjectList hostObjects;
	hostObjects.reserve( computers.size() );

	for( const auto& computer : computers )
	{
        hostObjects.append( computerToObject( &m_HCenterDirectory, computer ) );
	}

	return hostObjects;
}



NetworkObject HCenterNetworkObjectDirectory::computerToObject( HCenterDirectory* directory, const QString& computerDn )
{
	auto displayNameAttribute = directory->computerDisplayNameAttribute();
	if( displayNameAttribute.isEmpty() )
	{
		displayNameAttribute = QStringLiteral("cn");
	}

	auto hostNameAttribute = directory->computerHostNameAttribute();
	if( hostNameAttribute.isEmpty() )
	{
		hostNameAttribute = QStringLiteral("cn");
	}

	QStringList computerAttributes{ displayNameAttribute, hostNameAttribute };

	auto macAddressAttribute = directory->computerMacAddressAttribute();
	if( macAddressAttribute.isEmpty() == false )
	{
		computerAttributes.append( macAddressAttribute );
	}

	computerAttributes.removeDuplicates();

	const auto computers = directory->client().queryObjects( computerDn, computerAttributes,
                                                             directory->computersFilter(), HCenterClient::Scope::Base );
	if( computers.isEmpty() == false )
	{
		const auto& computerDn = computers.firstKey();
		const auto& computer = computers.first();
		const auto displayName = computer[displayNameAttribute].value( 0 );
		const auto hostName = computer[hostNameAttribute].value( 0 );
		const auto macAddress = ( macAddressAttribute.isEmpty() == false ) ? computer[macAddressAttribute].value( 0 ) : QString();

		return NetworkObject( NetworkObject::Host, displayName, hostName, macAddress, computerDn );
	}

	return NetworkObject::None;
}
