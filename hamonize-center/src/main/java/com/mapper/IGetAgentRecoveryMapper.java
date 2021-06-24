package com.mapper;

import java.util.List;

import com.model.ActAgentBackupRecoveryVo;
import com.model.GetAgentRecoveryVo;

public interface IGetAgentRecoveryMapper {

	public int  setInsertSelect( GetAgentRecoveryVo vo );
	
	public int getAgentWorkYn (GetAgentRecoveryVo vo );

	public int getInitChk (GetAgentRecoveryVo vo );
	
	public List<GetAgentRecoveryVo> getAgentWorkData( GetAgentRecoveryVo vo );
	
	
	
	/** 복구 체크 */
	public int insertActAgentBackupRecovery(ActAgentBackupRecoveryVo vo);
	public ActAgentBackupRecoveryVo getDataActAgentBackupRecovery(ActAgentBackupRecoveryVo vo);

	/** 정책 삭제 후 복구 여부 처리 */
	public int updateDataActAgentBackupRecovery(ActAgentBackupRecoveryVo vo);
	
	/** 정책 삭제 */
	public int deleteSgbPolicy(ActAgentBackupRecoveryVo vo);
	
	
	
}
