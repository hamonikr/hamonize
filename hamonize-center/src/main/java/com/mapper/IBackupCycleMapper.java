package com.mapper;

import com.model.BackupCycleVo;

public interface IBackupCycleMapper {
	public BackupCycleVo backupCycleList(BackupCycleVo vo);

	public void deleteBackupCycle(BackupCycleVo vo);
	
	public void backupCycleInsert(BackupCycleVo vo);
}