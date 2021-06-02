/*
 * MainWindow.h - main window of Veyon Master Application
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

#pragma once

#include <QObject>
#include <QWidget>
#include <QPixmap>

#include "VeyonCore.h"
#include "Calc.h"

class VEYON_CORE_EXPORT DeskerWidget : public QWidget
{
	Q_OBJECT
//    Q_CLASSINFO("D-Bus Interface", "org.hamonize.IDesker");

public:
    typedef enum Modes
    {
        DesktopVisible,
        BackgroundPixmap,
        NoBackground
    } Mode;

    DeskerWidget( QObject* parent = nullptr );
    ~DeskerWidget() override;

    void lock( Mode mode, const QPixmap& background = QPixmap(), QWidget* parent = nullptr );

public slots:
    QStringList getGuestUserInfo();

signals:
    void newGuest(QStringList guestUserInfo);

private:

    void paintEvent( QPaintEvent * ) override;

    QPixmap m_background;
    Mode m_mode;

    QString m_userLoginName;
    QString m_userFullName;
    QString m_guestLoginName;  // 2019.06.10 hihoon PC방 Guest 로그인 시 사용자 로그인 App용 사용자 ID/NAME 세션관리 클래스 내부 변수 추가
    QString m_guestFullName;   // 2019.06.10 hihoon PC방 Guest 로그인 시 사용자 로그인 App용 사용자 ID/NAME 세션관리 클래스 내부 변수 추가

} ;
