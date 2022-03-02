package com.service;

import java.util.List;
import java.util.Map;

import com.mapper.IBackupMapper;
import com.model.BackupVo;

import org.json.simple.JSONObject;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class BackupService {
	
	@Autowired
	IBackupMapper bacmapper;

	@Autowired
	RestApiService restApiService;
	
	
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

	public JSONObject applyRestorePolicy(Map<String, Object> params) throws ParseException, InterruptedException{
		//Long segSeq = Long.parseLong(params.get("org_seq").toString());
		System.out.println("br_backup_name-======"+params.get("br_backup_name"));
		System.out.println("br_backup_path-======"+params.get("br_backup_path"));;
		
		String output = "{\\\"PATH\\\":\\\""+params.get("br_backup_path").toString()+
		"\\\",\\\"NAME\\\":\\\""+params.get("br_backup_name").toString()+"\\\"}";
		//output = output.replaceAll("\"", "\\\\\\\"");
		System.out.println("output======"+output);
		params.put("output", output);
		params.put("policyFilePath","/etc/hamonize/recovery/recoveryInfo.hm");
		params.put("policyRunFilePath","/etc/hamonize/runrecovery");

		JSONObject result = restApiService.makePolicyToGroup(params);
		System.out.println("ResultID====="+result);
		// updtPolicy.clear();
		// updtPolicy.put("INS", String.join(",",ppm_name));
		// updtPolicy.put("DEL", String.join(",",former_ppm_name));
		// output = updtPolicy.toJSONString();
		// params.put("packageList", output);
		// updtResult(params);
		//System.out.println(updtResult(params));

		return result;

	}

	
	

}
