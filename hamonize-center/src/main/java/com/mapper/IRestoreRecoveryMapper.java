package com.mapper;

import com.model.PcMangrVo;
import com.model.RecoveryVo;

public interface IRestoreRecoveryMapper {
	public RecoveryVo[] recoveryList(RecoveryVo vo);
	public PcMangrVo[] pcList(RecoveryVo vo);
	public void recoveryInfoInsert(RecoveryVo vo);
}