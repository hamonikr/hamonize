package com.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mapper.IBackupMapper;
import com.model.BackupVo;

@Service
public class BackupService {
	
	@Autowired
	IBackupMapper bacmapper;
	
	
	public BackupVo backupView(BackupVo vo) {
		
		return bacmapper.backupView(vo);
		
	}
	
	public int backupSave(Map<String, Object> params) {
		return bacmapper.backupSave(params);
		
	}
	public int backupDelete(Map<String, Object> params) {
		return bacmapper.backupDelete(params);
		
	}
	
	public BackupVo backupApplcView(BackupVo vo){
		return bacmapper.backupApplcView(vo);
		
	}
	
	public List<Map<String, Object>> backupRCApplcView(Map<String, Object> params){
		return bacmapper.backupRCApplcView(params);
		
	}
	
	public List<Map<String, Object>> backupRecoveryList(Map<String, Object> params){
		return bacmapper.backupRecoveryList(params);
		
	}
	
	public int backupRecoverySave(Map<String, Object> params) {
		return bacmapper.backupRecoverySave(params);
	}
	
	public int backupRecoveryLogSave(Map<String, Object> params) {
		return bacmapper.backupRecoveryLogSave(params);
	}
	
	public int backupRecoveryDelete(Map<String, Object> params) {
		return bacmapper.backupRecoveryDelete(params);
	}
	
	

}
