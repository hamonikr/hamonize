/*
 * HCenterBrowseDialog.cpp - dialog for browsing HCenter directories
 *
 * Copyright (c) 2019 Tobias Junghans <tobydox@veyon.io>
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

#include "HCenterBrowseDialog.h"
#include "HCenterBrowseModel.h"
#include "HCenterConfiguration.h"

#include "ui_HCenterBrowseDialog.h"


HCenterBrowseDialog::HCenterBrowseDialog( const HCenterConfiguration& configuration, QWidget* parent ) :
	QDialog( parent ),
    ui( new Ui::HCenterBrowseDialog ),
	m_configuration( configuration )
{
	ui->setupUi( this );
}



HCenterBrowseDialog::~HCenterBrowseDialog()
{
	delete ui;
}



QString HCenterBrowseDialog::browseBaseDn( const QString& dn )
{
    HCenterBrowseModel model( HCenterBrowseModel::BrowseBaseDN, m_configuration, this );

	return browse( &model, dn, false );
}



QString HCenterBrowseDialog::browseDn( const QString& dn )
{
    HCenterBrowseModel model( HCenterBrowseModel::BrowseObjects, m_configuration, this );

	return browse( &model, dn, dn.toLower() == model.baseDn().toLower() );
}



QString HCenterBrowseDialog::browseAttribute( const QString& dn )
{
    HCenterBrowseModel model( HCenterBrowseModel::BrowseAttributes, m_configuration, this );

	return browse( &model, dn, true );
}



QString HCenterBrowseDialog::browse( HCenterBrowseModel* model, const QString& dn, bool expandSelected )
{
	ui->treeView->setModel( model );

	if( dn.isEmpty() == false )
	{
		const auto dnIndex = model->dnToIndex( dn );
		ui->treeView->selectionModel()->setCurrentIndex( dnIndex, QItemSelectionModel::SelectCurrent );
		if( expandSelected )
		{
			ui->treeView->expand( dnIndex );
		}
	}

	if( exec() == QDialog::Accepted )
	{
        return model->data( ui->treeView->selectionModel()->currentIndex(), HCenterBrowseModel::ItemNameRole ).toString();
	}

	return {};
}
