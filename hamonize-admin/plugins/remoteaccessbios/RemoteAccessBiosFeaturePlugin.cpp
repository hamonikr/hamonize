/*
 * RemoteAccessBiosFeaturePlugin.cpp - implementation of RemoteAccessBiosFeaturePlugin class
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

#include <QApplication>
#include <QInputDialog>
#include <QMessageBox>

#include "AuthenticationCredentials.h"
#include "RemoteAccessBiosFeaturePlugin.h"
#include "RemoteAccessWidget.h"
#include "VeyonMasterInterface.h"


RemoteAccessBiosFeaturePlugin::RemoteAccessBiosFeaturePlugin( QObject* parent ) :
	QObject( parent ),
	/* hihoon BIOSControl start */
	m_remoteControlBIOSFeature( QStringLiteral( "RemoteControlBIOS" ),
							Feature::Session | Feature::Master,
                            Feature::Uid( "9f473041-21f2-4629-88cd-3738f0269869" ),
							Feature::Uid(),
                            tr( "Remote control BIOS" ), QString(),
							tr( "Open a remote control window for a computer BIOS." ),
							QStringLiteral(":/remoteaccessbios/krdc.png") ),
	/* hihoon BIOSControl end */
	// hihoon m_features( { m_remoteViewFeature, m_remoteControlFeature } ),
    m_features( { m_remoteControlBIOSFeature } ),
	m_commands( {
{ QStringLiteral("bioscontrol"), m_remoteControlBIOSFeature.displayName() },
{ QStringLiteral("help"), tr( "Show help about command" ) },
				} )
{
}



const FeatureList &RemoteAccessBiosFeaturePlugin::featureList() const
{
	return m_features;
}



bool RemoteAccessBiosFeaturePlugin::startFeature( VeyonMasterInterface& master, const Feature& feature,
											  const ComputerControlInterfaceList& computerControlInterfaces )
{
	// determine which computer to access and ask if neccessary
	ComputerControlInterface::Pointer remoteAccessComputer;

    if( ( // feature.uid() == m_remoteViewFeature.uid() ||
          // feature.uid() == m_remoteControlFeature.uid() ||
          feature.uid() == m_remoteControlBIOSFeature.uid() ) &&
			computerControlInterfaces.count() != 1 )
	{
		QString hostName = QInputDialog::getText( master.mainWindow(),
												  tr( "Remote access" ),
												  tr( "Please enter the hostname or IP address of the computer to access:" ) );
		if( hostName.isEmpty() )
		{
			return false;
		}

		Computer customComputer;
		customComputer.setHostAddress( hostName );
		customComputer.setName( hostName );
		remoteAccessComputer = ComputerControlInterface::Pointer::create( customComputer );
	}
	else if( computerControlInterfaces.count() >= 1 )
	{
		remoteAccessComputer = computerControlInterfaces.first();
	}

	if( remoteAccessComputer.isNull() )
	{
		return false;
	}


//	if( feature.uid() == m_remoteViewFeature.uid() )
//	{
//		// 2019.05.10 hihoon RemoteBIOSControl mode 추가
//		// 2019.05.10 hihoon remark // new RemoteAccessWidget( remoteAccessComputer, true );

//		new RemoteAccessWidget( remoteAccessComputer, VncView::ViewOnlyMode );

//		return true;
//	}
//	else if( feature.uid() == m_remoteControlFeature.uid() )
//	{
//		/* UI가 없어 실행되지 않음
//		QMessageBox messageBox(QMessageBox::Information, tr( "Information" ),
//								tr( "Open a remote control window for a computer. Becouse this computer is not support remote BIOS control." ));
//		messageBox.show();
//		*/

//		// 2019.05.10 hihoon RemoteBIOSControl mode 추가
//		// 2019.05.10 hihoon remark // new RemoteAccessWidget( remoteAccessComputer, false );
//		new RemoteAccessWidget( remoteAccessComputer, VncView::RemoteControlMode );

//		return true;
//	}
//	/* 2019.05.08 hihoon start : 이함수의 로그는 VeyonAdmin.log 파일에 남는다. */
//	else

    if( feature.uid() == m_remoteControlBIOSFeature.uid() )
	{
		/* UI가 없어 실행되지 않음
		QMessageBox messageBox(QMessageBox::Information, tr( "Information" ),
								tr( "Open a remote control window for a computer. Becouse this computer is not support remote BIOS control." ));
		messageBox.show();
		*/

		vDebug() << "###### hihoon 4 ######## " << "feature.uid:" << feature.uid() 
                            << ", m_remoteBIOSControlFeature.uid:" << m_remoteControlBIOSFeature.uid();

        if (1) {

            // TODO : gtk-vnc 실행
            // linux : gvncviewer hostAddress
            // windows : ?


            bool _hasExtVNC = false;

            QStringList _argList;
            QString _extvncPath;

            QString _linux_ext_vncPath = QString::fromLatin1("/usr/bin/gvncviewer");
            QString _window_ext_vncPath = QString::fromLatin1("c:/Program Files/uvnc bvba/UltraVNC/vncviewer.exe");

            if(QFile::exists (_linux_ext_vncPath)) {

                _extvncPath = _linux_ext_vncPath;
                _hasExtVNC = true;

            }
            else if (QFile::exists (_window_ext_vncPath) ) {

                _extvncPath = _window_ext_vncPath;
                _hasExtVNC = true;

                _argList << QString::fromLatin1(("/nostatus"));

            }
            else {

                _hasExtVNC = false;

                QMessageBox::information( nullptr,
                        tr( "Execution impossible" ),
                        tr(	"No external VNC program were found. "
                            "Please VNC program install at proper location %1 " ).arg( _window_ext_vncPath ) );
            }

            if (_hasExtVNC) {

                QString _hostAddress = remoteAccessComputer->computer().hostAddress();
                _argList.append(_hostAddress );

                Process = new QProcess(this);
                Process->start(_extvncPath, _argList);

                return true;
            }
            else {

                return false;
            }

        }
        else {

            new RemoteAccessWidget( remoteAccessComputer, VncView::RemoteBIOSControlMode );
        }

		return true;
	}
	/* hihoon end */

	return false;
}



QStringList RemoteAccessBiosFeaturePlugin::commands() const
{
	return m_commands.keys();
}



QString RemoteAccessBiosFeaturePlugin::commandHelp( const QString& command ) const
{
	return m_commands.value( command );
}



CommandLinePluginInterface::RunResult RemoteAccessBiosFeaturePlugin::handle_view( const QStringList& arguments )
{
	if( arguments.count() < 1 )
	{
		return NotEnoughArguments;
	}

    return remoteAccessBios( arguments.first(), VncView::ViewOnlyMode ) ? Successful : Failed;
}



CommandLinePluginInterface::RunResult RemoteAccessBiosFeaturePlugin::handle_control( const QStringList& arguments )
{
	if( arguments.count() < 1 )
	{
		return NotEnoughArguments;
	}

    return remoteAccessBios( arguments.first(), VncView::RemoteControlMode ) ? Successful : Failed;
}



CommandLinePluginInterface::RunResult RemoteAccessBiosFeaturePlugin::handle_bioscontrol( const QStringList& arguments )
{
	if( arguments.count() < 1 )
	{
		return NotEnoughArguments;
	}

    return remoteAccessBios( arguments.first(), VncView::RemoteBIOSControlMode ) ? Successful : Failed;
}


CommandLinePluginInterface::RunResult RemoteAccessBiosFeaturePlugin::handle_help( const QStringList& arguments )
{
	if( arguments.value( 0 ) == QStringLiteral("view") )
	{
		printf( "\nremoteaccess view <host>\n\n" );
		return NoResult;
	}
	else if( arguments.value( 0 ) == QStringLiteral("control") )
	{
		printf( "\nremoteaccess control <host>\n}n" );
		return NoResult;
	}

	return InvalidCommand;
}



bool RemoteAccessBiosFeaturePlugin::initAuthentication()
{
	if( VeyonCore::instance()->initAuthentication() == false )
	{
		vWarning() << "Could not initialize authentication";
		return false;
	}

	return true;
}



// 2019.05.10 hihoon RemoteBIOSControl mode 추가 
// 2019 05.10 hihoon remark // bool RemoteAccessBiosFeaturePlugin::remoteAccess( const QString& hostAddress, bool viewOnly )
bool RemoteAccessBiosFeaturePlugin::remoteAccessBios( const QString& hostAddress, VncView::Mode remoteMode )
{
	if( initAuthentication() == false )
	{
		return false;
	}

	Computer remoteComputer;
	remoteComputer.setName( hostAddress );
	remoteComputer.setHostAddress( hostAddress );

	// 2019.05.10 hihoon RemoteBIOSControl mode 추가 
	// 2019 05.10 hihoon remark // new RemoteAccessWidget( ComputerControlInterface::Pointer::create( remoteComputer ), viewOnly );

    	//new RemoteAccessWidget( ComputerControlInterface::Pointer::create( remoteComputer ), remoteMode );


	qApp->exec();

	return true;
}
