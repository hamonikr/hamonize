/*
 * HCenterDirectory.cpp - class representing the HCenter directory and providing access to directory entries
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

#include <QHostAddress>
#include <QHostInfo>

#include "HCenterConfiguration.h"
#include "HCenterDirectory.h"


HCenterDirectory::HCenterDirectory( const HCenterConfiguration& configuration, QObject* parent ) :
	QObject( parent ),
	m_configuration( configuration ),
	m_client( configuration, QUrl(), this )
{
	m_usersDn = m_client.constructSubDn( m_configuration.userTree(), m_client.baseDn() );
	m_groupsDn = m_client.constructSubDn( m_configuration.groupTree(), m_client.baseDn() );
	m_computersDn = m_client.constructSubDn( m_configuration.computerTree(), m_client.baseDn() );

	if( m_configuration.computerGroupTree().isEmpty() == false )
	{
        m_computerGroupsDn = HCenterClient::constructSubDn( m_configuration.computerGroupTree(), m_client.baseDn() );
	}
	else
	{
		m_computerGroupsDn.clear();
	}

	if( m_configuration.recursiveSearchOperations() )
	{
        m_defaultSearchScope = HCenterClient::Scope::Sub;
	}
	else
	{
        m_defaultSearchScope = HCenterClient::Scope::One;
	}

	m_userLoginNameAttribute = m_configuration.userLoginNameAttribute();
	m_groupMemberAttribute = m_configuration.groupMemberAttribute();
	m_computerDisplayNameAttribute = m_configuration.computerDisplayNameAttribute();
	m_computerHostNameAttribute = m_configuration.computerHostNameAttribute();
	m_computerHostNameAsFQDN = m_configuration.computerHostNameAsFQDN();
	m_computerMacAddressAttribute = m_configuration.computerMacAddressAttribute();
	m_locationNameAttribute = m_configuration.locationNameAttribute();
	if( m_locationNameAttribute.isEmpty() )
	{
		m_locationNameAttribute = QStringLiteral("cn");
	}

	m_usersFilter = m_configuration.usersFilter();
	m_userGroupsFilter = m_configuration.userGroupsFilter();
	m_computersFilter = m_configuration.computersFilter();
	m_computerGroupsFilter = m_configuration.computerGroupsFilter();
	m_computerContainersFilter = m_configuration.computerContainersFilter();

	m_identifyGroupMembersByNameAttribute = m_configuration.identifyGroupMembersByNameAttribute();

	m_computerLocationsByContainer = m_configuration.computerLocationsByContainer();
	m_computerLocationsByAttribute = m_configuration.computerLocationsByAttribute();
	m_computerLocationAttribute = m_configuration.computerLocationAttribute();

}



const QString& HCenterDirectory::configInstanceId() const
{
	return m_configuration.instanceId();
}



/*!
 * \brief Disables any configured attributes which is required for some test scenarious
 */
void HCenterDirectory::disableAttributes()
{
	m_userLoginNameAttribute.clear();
	m_computerDisplayNameAttribute.clear();
	m_computerHostNameAttribute.clear();
	m_computerMacAddressAttribute.clear();
}



/*!
 * \brief Disables any configured filters which is required for some test scenarious
 */
void HCenterDirectory::disableFilters()
{
	m_usersFilter.clear();
	m_userGroupsFilter.clear();
	m_computersFilter.clear();
	m_computerGroupsFilter.clear();
	m_computerContainersFilter.clear();
}




QStringList HCenterDirectory::users( const QString& filterValue )
{
	return m_client.queryDistinguishedNames( m_usersDn,
                                             HCenterClient::constructQueryFilter( m_userLoginNameAttribute, filterValue, m_usersFilter ),
											 m_defaultSearchScope );
}



QStringList HCenterDirectory::groups( const QString& filterValue )
{
	return m_client.queryDistinguishedNames( m_groupsDn,
                                             HCenterClient::constructQueryFilter( QStringLiteral( "cn" ), filterValue ),
											 m_defaultSearchScope );
}



QStringList HCenterDirectory::userGroups( const QString& filterValue )
{
	return m_client.queryDistinguishedNames( m_groupsDn,
                                             HCenterClient::constructQueryFilter( QStringLiteral( "cn" ), filterValue, m_userGroupsFilter ),
											 m_defaultSearchScope );
}



QStringList HCenterDirectory::computersByDisplayName( const QString& filterValue )
{
	return m_client.queryDistinguishedNames( m_computersDn,
                                             HCenterClient::constructQueryFilter( m_computerDisplayNameAttribute, filterValue, m_computersFilter ),
											 computerSearchScope() );
}



/*!
 * \brief Returns list of computer object names matching the given hostname filter
 * \param filterValue A filter value which is used to query the hostname attribute
 * \return List of DNs of all matching computer objects
 */
QStringList HCenterDirectory::computersByHostName( const QString& filterValue )
{
	return m_client.queryDistinguishedNames( m_computersDn,
                                             HCenterClient::constructQueryFilter( m_computerHostNameAttribute, filterValue, m_computersFilter ),
											 computerSearchScope() );
}



QStringList HCenterDirectory::computerGroups( const QString& filterValue )
{
    return m_client.queryDistinguishedNames( m_computerGroupsDn.isEmpty() ? m_computersDn : m_computerGroupsDn,
//                                             HCenterClient::constructQueryFilter( QStringLiteral( "cn" ), filterValue, m_computerGroupsFilter ) ,
                                             HCenterClient::constructQueryFilter( QStringLiteral( "" ), filterValue, m_computerGroupsFilter ) ,
                                             m_defaultSearchScope );
}



QStringList HCenterDirectory::computerLocations( const QString& filterValue )
{
	QStringList locations;

	if( m_computerLocationsByAttribute )
	{
		locations = m_client.queryAttributeValues( m_computersDn,
												   m_computerLocationAttribute,
                                                   HCenterClient::constructQueryFilter( m_computerLocationAttribute, filterValue, m_computersFilter ),
												   m_defaultSearchScope );
	}
	else if( m_computerLocationsByContainer )
	{
		locations = m_client.queryAttributeValues( m_computersDn,
												   m_locationNameAttribute,
                                                   HCenterClient::constructQueryFilter( m_locationNameAttribute, filterValue, m_computerContainersFilter ) ,
												   m_defaultSearchScope );
	}
	else
	{
        locations = m_client.queryAttributeValues( m_computerGroupsDn.isEmpty() ? m_computersDn : m_computerGroupsDn,
												   m_locationNameAttribute,
                                                   HCenterClient::constructQueryFilter( m_locationNameAttribute, filterValue, m_computerGroupsFilter ) ,
												   m_defaultSearchScope );
	}

	locations.removeDuplicates();

	std::sort( locations.begin(), locations.end() );

	return locations;
}



QStringList HCenterDirectory::groupMembers( const QString& groupDn )
{
	return m_client.queryAttributeValues( groupDn, m_groupMemberAttribute );
}



QStringList HCenterDirectory::groupsOfUser( const QString& userDn )
{
	const auto userId = groupMemberUserIdentification( userDn );
	if( m_groupMemberAttribute.isEmpty() || userId.isEmpty() )
	{
		return {};
	}

	return m_client.queryDistinguishedNames( m_groupsDn,
                                             HCenterClient::constructQueryFilter( m_groupMemberAttribute, userId, m_userGroupsFilter ),
											 m_defaultSearchScope );
}



QStringList HCenterDirectory::groupsOfComputer( const QString& computerDn )
{
	const auto computerId = groupMemberComputerIdentification( computerDn );
	if( m_groupMemberAttribute.isEmpty() || computerId.isEmpty() )
	{
		return {};
	}

	return m_client.queryDistinguishedNames( m_computerGroupsDn.isEmpty() ? m_groupsDn : m_computerGroupsDn,
                                             HCenterClient::constructQueryFilter( m_groupMemberAttribute, computerId, m_computerGroupsFilter ),
											 m_defaultSearchScope );
}



QStringList HCenterDirectory::locationsOfComputer( const QString& computerDn )
{
	if( m_computerLocationsByAttribute )
	{
		return m_client.queryAttributeValues( computerDn, m_computerLocationAttribute );
	}
	else if( m_computerLocationsByContainer )
	{
        return m_client.queryAttributeValues( HCenterClient::parentDn( computerDn ), m_locationNameAttribute );
	}

	const auto computerId = groupMemberComputerIdentification( computerDn );
	if( m_groupMemberAttribute.isEmpty() || computerId.isEmpty() )
	{
		return {};
	}

	return m_client.queryAttributeValues( m_computerGroupsDn.isEmpty() ? m_groupsDn : m_computerGroupsDn,
										  m_locationNameAttribute,
                                          HCenterClient::constructQueryFilter( m_groupMemberAttribute, computerId, m_computerGroupsFilter ),
										  m_defaultSearchScope );
}



QString HCenterDirectory::userLoginName( const QString& userDn )
{
	return m_client.queryAttributeValues( userDn, m_userLoginNameAttribute ).value( 0 );
}



QString HCenterDirectory::computerDisplayName( const QString& computerDn )
{
	return m_client.queryAttributeValues( computerDn, m_computerDisplayNameAttribute ).value( 0 );

}



QString HCenterDirectory::computerHostName( const QString& computerDn )
{
	if( computerDn.isEmpty() )
	{
		return QString();
	}

	return m_client.queryAttributeValues( computerDn, m_computerHostNameAttribute ).value( 0 );
}



QString HCenterDirectory::computerMacAddress( const QString& computerDn )
{
	if( computerDn.isEmpty() )
	{
		return QString();
	}

	return m_client.queryAttributeValues( computerDn, m_computerMacAddressAttribute ).value( 0 );
}



QString HCenterDirectory::groupMemberUserIdentification( const QString& userDn )
{
	if( m_identifyGroupMembersByNameAttribute )
	{
		return userLoginName( userDn );
	}

	return userDn;
}



QString HCenterDirectory::groupMemberComputerIdentification( const QString& computerDn )
{
	if( m_identifyGroupMembersByNameAttribute )
	{
		return computerHostName( computerDn );
	}

	return computerDn;
}



QStringList HCenterDirectory::computerLocationEntries( const QString& locationName )
{
	if( m_computerLocationsByAttribute )
	{
		return m_client.queryDistinguishedNames( m_computersDn,
                                                 HCenterClient::constructQueryFilter( m_computerLocationAttribute, locationName, m_computersFilter ),
												 m_defaultSearchScope );
	}
	else if( m_computerLocationsByContainer )
	{
        const auto locationDnFilter = HCenterClient::constructQueryFilter( m_locationNameAttribute, locationName, m_computerContainersFilter );
		const auto locationDns = m_client.queryDistinguishedNames( m_computersDn, locationDnFilter, m_defaultSearchScope );

		return m_client.queryDistinguishedNames( locationDns.value( 0 ),
                                                 HCenterClient::constructQueryFilter( QString(), QString(), m_computersFilter ),
												 m_defaultSearchScope );
	}

	auto memberComputers = groupMembers( computerGroups( locationName ).value( 0 ) );

	// computer filter configured?
	if( m_computersFilter.isEmpty() == false )
	{
		auto memberComputersSet = memberComputers.toSet();

		// then return intersection of filtered computer list and group members
		return memberComputersSet.intersect( computersByHostName().toSet() ).toList();
	}

	return memberComputers;
}



QString HCenterDirectory::hostToHCenterFormat( const QString& host )
{
	QHostAddress hostAddress( host );

	// no valid IP address given?
	if( hostAddress.protocol() == QAbstractSocket::UnknownNetworkLayerProtocol )
	{
		// then try to resolve ist first
		QHostInfo hostInfo = QHostInfo::fromName( host );
		if( hostInfo.error() != QHostInfo::NoError || hostInfo.addresses().isEmpty() )
		{
			vWarning() << "could not lookup IP address of host"
					   << host << "error:" << hostInfo.errorString();
			return QString();
		}

#if QT_VERSION < 0x050600
		hostAddress = hostInfo.addresses().value( 0 );
#else
		hostAddress = hostInfo.addresses().constFirst();
#endif
		vDebug() << "no valid IP address given, resolved IP address of host" << host << "to" << hostAddress.toString();
	}

	// now do a name lookup to get the full hostname information
	QHostInfo hostInfo = QHostInfo::fromName( hostAddress.toString() );
	if( hostInfo.error() != QHostInfo::NoError )
	{
		vWarning() << "could not lookup hostname for IP" << hostAddress.toString() << "error:" << hostInfo.errorString();
		return {};
	}

	// are we working with fully qualified domain name?
	if( m_computerHostNameAsFQDN )
	{
		vDebug() << "resolved FQDN" << hostInfo.hostName();
		return hostInfo.hostName();
	}

	// return first part of hostname which should be the actual machine name
	const QString hostName = hostInfo.hostName().split( QLatin1Char('.') ).value( 0 );

	vDebug() << "resolved hostname" << hostName;
	return hostName;
}



QString HCenterDirectory::computerObjectFromHost( const QString& host )
{
    QString hostName = hostToHCenterFormat( host );
	if( hostName.isEmpty() )
	{
		vWarning() << "could not resolve hostname, returning empty computer object";
		return {};
	}

	QStringList computerObjects = computersByHostName( hostName );
	if( computerObjects.count() == 1 )
	{
		return computerObjects.first();
	}

	// return empty result if not exactly one object was found
	vWarning() << "more than one computer object found, returning empty computer object!";
	return {};
}



HCenterClient::Scope HCenterDirectory::computerSearchScope() const
{
	// when using containers/OUs as locations computer objects are not located directly below the configured computer DN
	if( m_computerLocationsByContainer )
	{
        return HCenterClient::Scope::Sub;
	}

	return m_defaultSearchScope;
}
