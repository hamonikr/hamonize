/*
 * main.cpp - startup routine for Veyon Master Application
 *
 * Copyright (c) 2004-2019 Tobias Junghans <tobydox@veyon.io>
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
#include <QSplashScreen>
#include <QDebug>

#include "DeskerWidget.h"
#include "DeskerSessionControl.h"
#include "VeyonConfiguration.h"
#include "PlatformUserFunctions.h"

int main( int argc, char** argv )
{
	VeyonCore::setupApplicationParameters();

	QApplication app( argc, argv );
	app.connect( &app, &QApplication::lastWindowClosed, &QApplication::quit );


    VeyonCore core( &app, QStringLiteral("Desker") );

    qDebug() << "Start: Desker";

//    m_lockWidget = new DeskerWidget( LockWidget::BackgroundPixmap,
//                                   QPixmap( QStringLiteral(":/screenlock/locked-screen-background.png" ) ) );

    DeskerWidget deskerCore( &app );
//    Calc c(&app);
    // hide splash-screen as soon as main-window is shown
    //splashScreen.finish( masterCore.mainWindow() );

    HWInfo hwinfo;
    if ( hwinfo.isChanged() )
    {
        deskerCore.show();
        vDebug() << "### CRITICAL : Hardware is changed. So lock computer! ###";
//        deskerCore.lock();
    }

    QString currentUser = VeyonCore::platform().userFunctions().currentUser();
    vInfo() << "currentUser:" << currentUser;
//    QString currentUser = VeyonCore::platform().userFunctions().currentUser();

    if ( !currentUser.contains( QStringLiteral("lightdm"), Qt::CaseSensitive) )
    {
        deskerCore.show();
    }
//    qDebug() << "UserInfo: " << c.userinfo(1.0);
	return core.exec();
}
