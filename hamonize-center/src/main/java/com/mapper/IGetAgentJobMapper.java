package com.mapper;

import java.util.List;

import com.model.BlockingNxssInfoVo;
import com.model.CurlPcBackupVo;
import com.model.GetAgentJobVo;
import com.model.HmSecurityVo;
import com.model.HmprogramVo;

public interface IGetAgentJobMapper {

	
	public GetAgentJobVo getAgentJobPcUUID(  GetAgentJobVo vo );

	public GetAgentJobVo getAgentJobPcUUIDInBACKUP(  GetAgentJobVo vo );
	
	public List<GetAgentJobVo> getAgentJobList( );

	public int getAgentJobDelete();
	
	

	public List<GetAgentJobVo> getAgentJobPcPolocy(  GetAgentJobVo vo );

	public List<GetAgentJobVo> 	getAgentJobPcBackup(  GetAgentJobVo vo );
	


	public int setAgentJobPcPolocy( GetAgentJobVo vo );

	public int setAgentJobPcBackup( GetAgentJobVo vo );
	
	// ad 백업본 저장
	public int insertBackupInfo(CurlPcBackupVo cpbVo);
	
	// public List<BlockingNxssInfoVo> nxssListInfo();
	
	
//================================
	public int selectInsertProgrmInAgentJob(HmprogramVo vo);
	public List<HmprogramVo> selectProgrmInAgentJob(HmprogramVo vo);
	public List<HmprogramVo> programAgentY(HmprogramVo vo);
	public List<HmprogramVo> programAgentN(HmprogramVo vo);
	public int programAgentDel(HmprogramVo vo);
	public int programAgentInsert(HmprogramVo vo);
	
	
	
	public List<HmSecurityVo> selectSecurityInAgentJob(HmSecurityVo vo);
	public int selectInsertSecurityInAgentJob(HmSecurityVo vo);
	public List<HmSecurityVo> securityAgentY(HmSecurityVo vo);
	public List<HmSecurityVo> securityAgentN(HmSecurityVo vo);
	public int securityAgentInsert(HmSecurityVo vo);
	public int securityAgentDel(HmSecurityVo vo);
}
