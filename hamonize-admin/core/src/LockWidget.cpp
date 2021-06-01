/*
 *  LockWidget.cpp - widget for locking a client
 *
 *  Copyright (c) 2006-2016 Tobias Junghans <tobydox@veyon.io>
 *
 *  This file is part of Veyon - https://veyon.io
 *
 *  This is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This software is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this software; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307,
 *  USA.
 */

#include "LockWidget.h"
#include "PlatformCoreFunctions.h"
#include "PlatformInputDeviceFunctions.h"

#include <QApplication>
#include <QDesktopWidget>
#include <QPainter>
#include <QLabel>
#include <QVBoxLayout>

LockWidget::LockWidget( Mode mode, const QPixmap& background, const QString& message, QWidget* parent ) :
	QWidget( parent, Qt::X11BypassWindowManagerHint ),
	m_background( background ),
    m_mode( mode )
{
	VeyonCore::platform().coreFunctions().setSystemUiState( false );
	VeyonCore::platform().inputDeviceFunctions().disableInputDevices();

	if( mode == DesktopVisible )
	{
        m_background = QPixmap::grabWindow( qApp->desktop()->winId() );
	}

	setWindowTitle( QString() );
	showFullScreen();
	move( 0, 0 );
	setFixedSize( qApp->desktop()->size() );
	VeyonCore::platform().coreFunctions().raiseWindow( this );
	setFocusPolicy( Qt::StrongFocus );
	setFocus();
	grabMouse();
	grabKeyboard();
	setCursor( Qt::BlankCursor );
	QGuiApplication::setOverrideCursor( Qt::BlankCursor );

	QCursor::setPos( mapToGlobal( QPoint( 0, 0 ) ) );

    QVBoxLayout *layout = new QVBoxLayout(this);

    QFont font = m_lblMessage.font();
    font.setPointSize(32);
    font.setBold(true);

    QPalette palette = m_lblMessage.palette();
//    palette.setColor(m_lblMessage.backgroundRole(), Qt::yellow);
    palette.setColor(m_lblMessage.foregroundRole(), Qt::red);

    m_lblMessage.setFont(font);
    m_lblMessage.setPalette(palette);
    m_lblMessage.setAlignment(Qt::AlignCenter);

    if( !message.isEmpty() )
    {
        m_lblMessage.setText(message);
    }
    else
    {
        m_lblMessage.setText(tr("Computer is not availabled,\nPlease contact your administrator."));
    }

    QLabel dummy;

    font = dummy.font();
    font.setPointSize(32);
    font.setBold(true);

    dummy.setFont(font);
    dummy.setText(tr("C"));


    layout->addWidget(&dummy);
    layout->addWidget(&m_lblMessage);

    setLayout(layout);

}



LockWidget::~LockWidget()
{
	VeyonCore::platform().inputDeviceFunctions().enableInputDevices();
	VeyonCore::platform().coreFunctions().setSystemUiState( true );

	QGuiApplication::restoreOverrideCursor();
}



void LockWidget::paintEvent( QPaintEvent* event )
{
	Q_UNUSED(event);

	QPainter p( this );
    switch( m_mode )
    {
	case DesktopVisible:
        p.drawPixmap( 0, 0, m_background );
		break;

	case BackgroundPixmap:

        p.fillRect( rect(), QColor( 64, 64, 64 ) );
        p.drawPixmap( ( width() - m_background.width() ) / 2,
                      ( height() - m_background.height() ) / 2,
                      m_background );
        break;

	default:
		break;
	}
}
