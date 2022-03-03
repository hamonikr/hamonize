package com.mapper;

import java.util.List;

import com.model.ActAgentLogBackupRestoreVo;
import com.model.GetAgentRecoveryVo;

public interface IGetAgentRecoveryMapper {

	public int  setInsertSelect( GetAgentRecoveryVo vo );
	
	public int getAgentWorkYn (GetAgentRecoveryVo vo );

	public int getInitChk (GetAgentRecoveryVo vo );
	
	public List<GetAgentRecoveryVo> getAgentWorkData( GetAgentRecoveryVo vo );
	
	
	
	/** 복구 체크 */
	public int insertActAgentBackupRecovery(ActAgentLogBackupRestoreVo vo);
	public ActAgentLogBackupRestoreVo getDataActAgentBackupRecovery(ActAgentLogBackupRestoreVo vo);

	/** 정책 삭제 후 복구 여부 처리 */
	public int updateDataActAgentBackupRecovery(ActAgentLogBackupRestoreVo vo);
	
	/** 정책 삭제 */
	public int deleteActPolicy(ActAgentLogBackupRestoreVo vo);
	
	
	
}
