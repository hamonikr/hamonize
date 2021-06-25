package com.mapper;

import java.util.List;

import com.model.GetAgentBackupVo;

public interface IGetAgentBackupMapper {

	public int  setInsertSelect( GetAgentBackupVo vo );
	
	public int getAgentWorkYn (GetAgentBackupVo vo );
	
	public List<GetAgentBackupVo> getListBackupPolicy( GetAgentBackupVo vo );

	public List<GetAgentBackupVo> getAgentWorkData( GetAgentBackupVo vo );
	
	
	
	
}
