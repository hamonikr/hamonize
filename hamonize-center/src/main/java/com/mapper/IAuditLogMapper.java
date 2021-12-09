package com.mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.model.AuditLogVo;

public interface IAuditLogMapper {

	public List<AuditLogVo> userLogListInfo(HashMap<String, Object> map);
	
	public int countUserLogListInfo(AuditLogVo vo);
	
	public List<AuditLogVo> iNetLogListInfo(HashMap<String, Object> map);
	
	public int countInetLogListInfo(AuditLogVo vo);
	
	public List<AuditLogVo> pcChangeLogListInfo(HashMap<String, Object> map);
	
	public int countPcChangeLogListInfo(AuditLogVo vo);
	
	public List<AuditLogVo> unAuthLogListInfo(HashMap<String, Object> map);
	
	public int countUnAuthLogListInfo(AuditLogVo vo);
	
	public List<AuditLogVo> prcssBlockLogListInfo(HashMap<String, Object> map);
	
	public int countPrcssBlockLogListInfo(AuditLogVo vo);
	
	public List<Map<String, Object>> userLogListExcel(AuditLogVo vo);
	
	public List<Map<String, Object>> iNetLogListExcel(AuditLogVo vo);
	
	public List<Map<String, Object>> unAuthLogListExcel(AuditLogVo vo);
	
	public List<Map<String, Object>> prcssBlockLogListExcel(AuditLogVo vo);
	
	public List<String> udptPackageList();
	
	public List<Map<String, Object>> updtList(HashMap<String, Object> map);
	
	public List<String> programPackageList(HashMap<String, Object> params);
	
	public List<Map<String, Object>> programList(HashMap<String, Object> map);
	
	public List<String> firewallPackageList();
	
	public List<Map<String, Object>> firewallList(HashMap<String, Object> map);
	
	public List<String> devicePackageList(HashMap<String, Object> map);
	
	public List<Map<String, Object>> deviceList(HashMap<String, Object> map);
	
	public List<Map<String, Object>> nxssList(HashMap<String, Object> map);
	
	

}
