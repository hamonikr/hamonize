package com.mapper;

import java.util.List;
import java.util.Map;

import com.model.BackupVo;

public interface IBackupMapper {
	
	public int backupSave(Map<String, Object> params);
	
	public int backupDelete(Map<String, Object> params);
	
	public BackupVo backupView(BackupVo vo);
	
	public BackupVo backupApplcView(BackupVo vo);
	
	public List<Map<String, Object>> backupRCApplcView(Map<String, Object> params);
	
	public List<Map<String, Object>> backupRecoveryList(Map<String, Object> params);
	
	public int backupRecoverySave(Map<String, Object> params);
	
	public int backupRecoveryLogSave(Map<String, Object> params);
	
	public int backupRecoveryDelete(Map<String, Object> params);

}
