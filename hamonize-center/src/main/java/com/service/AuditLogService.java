package com.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mapper.IAuditLogMapper;
import com.model.AuditLogVo;
import com.paging.PagingVo;

@Service
public class AuditLogService {
	
	@Autowired
	private IAuditLogMapper auditLogMapper;

	public List<AuditLogVo> userLogList(AuditLogVo vo, PagingVo pagingVo) {

		HashMap<String, Object> paramMap = new HashMap<String, Object>();

		paramMap.put("auditLogVo", vo);
		paramMap.put("pagingVo", pagingVo);
		List<AuditLogVo> list = auditLogMapper.userLogListInfo(paramMap);

		return list;
	}
	
	public List<AuditLogVo> iNetLogList(AuditLogVo vo, PagingVo pagingVo) {

		HashMap<String, Object> paramMap = new HashMap<String, Object>();

		paramMap.put("auditLogVo", vo);
		paramMap.put("pagingVo", pagingVo);
		List<AuditLogVo> list = auditLogMapper.iNetLogListInfo(paramMap);

		return list;
	}
	
	public List<AuditLogVo> pcChangeLogList(AuditLogVo vo, PagingVo pagingVo) {

		HashMap<String, Object> paramMap = new HashMap<String, Object>();

		paramMap.put("auditLogVo", vo);
		paramMap.put("pagingVo", pagingVo);
		List<AuditLogVo> list = auditLogMapper.pcChangeLogListInfo(paramMap);

		return list;
	}
	
	public List<AuditLogVo> unAuthLogList(AuditLogVo vo, PagingVo pagingVo) {

		HashMap<String, Object> paramMap = new HashMap<String, Object>();

		paramMap.put("auditLogVo", vo);
		paramMap.put("pagingVo", pagingVo);
		List<AuditLogVo> list = auditLogMapper.unAuthLogListInfo(paramMap);

		return list;
	}
	
	public List<AuditLogVo> prcssBlockLogList(AuditLogVo vo, PagingVo pagingVo) {

		HashMap<String, Object> paramMap = new HashMap<String, Object>();

		paramMap.put("auditLogVo", vo);
		paramMap.put("pagingVo", pagingVo);
		List<AuditLogVo> list = auditLogMapper.prcssBlockLogListInfo(paramMap);

		return list;
	}
	
	/**
	 업데이트 정책 적용 결과
	 */
	public List<Map<String,Object>> udptList(HashMap<String, Object> params) {
		
		HashMap<String, Object> jsonObject = new HashMap<String, Object>();
		List<Map<String,Object>> result = new ArrayList<Map<String,Object>>();
		
		try {
			
			List<String> list = auditLogMapper.udptPackageList();
			
			jsonObject.put("debList", list);
			jsonObject.put("debListCnt", list.size());
			jsonObject.put("uuid", params.get("pc_uuid"));
			result = auditLogMapper.updtList(jsonObject);
			
			
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return result;
		
	}
	
	/**
	 프로그램 정책 적용 결과
	 */
	public List<Map<String,Object>> programList(HashMap<String, Object> params) {
		
		HashMap<String, Object> jsonObject = new HashMap<String, Object>();
		List<Map<String,Object>> result = new ArrayList<Map<String,Object>>();
		
		try {
			
			List<String> list = auditLogMapper.programPackageList();

			for(int i=0;i< list.size() ;i++){
				System.out.println("list : "+list.get(i).toString());
		
			}
			
			jsonObject.put("debList", list);
			jsonObject.put("debListCnt", list.size());
			jsonObject.put("uuid", params.get("pc_uuid"));
			
			result = auditLogMapper.programList(jsonObject);
			
			
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return result;
		
	}
	
	/**
	 방화벽 정책 적용 결과
	 */
	public List<Map<String,Object>> firewallList(HashMap<String, Object> params) {
		
		HashMap<String, Object> jsonObject = new HashMap<String, Object>();
		List<Map<String,Object>> result = new ArrayList<Map<String,Object>>();
		
		try {
			
			List<String> list = auditLogMapper.firewallPackageList();
			
			jsonObject.put("debList", list);
			jsonObject.put("debListCnt", list.size());
			jsonObject.put("uuid", params.get("pc_uuid"));
			
			result = auditLogMapper.firewallList(jsonObject);
			
			
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return result;
		
	}
	
	/**
	 디바이스 정책 적용 결과
	 */
	public List<Map<String,Object>> deviceList(HashMap<String, Object> params) {
		
		HashMap<String, Object> jsonObject = new HashMap<String, Object>();
		List<Map<String,Object>> result = new ArrayList<Map<String,Object>>();
		
		try {
			
			List<String> list = auditLogMapper.devicePackageList();
			
			jsonObject.put("debList", list);
			jsonObject.put("debListCnt", list.size());
			jsonObject.put("uuid", params.get("pc_uuid"));

			result = auditLogMapper.deviceList(jsonObject);
			
			
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return result;
		
	}
	
	/**
	 유해사이트 정책 적용 결과
	 */
	public List<Map<String,Object>> nxssList(HashMap<String, Object> params) {
		
		HashMap<String, Object> jsonObject = new HashMap<String, Object>();
		List<Map<String,Object>> result = new ArrayList<Map<String,Object>>();
		
		try {

			jsonObject.put("uuid", params.get("pc_uuid"));
			System.out.println("deviceparams...."+params);
			System.out.println("deviceuuid======="+params.get("pc_uuid"));
			result = auditLogMapper.nxssList(jsonObject);
			
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return result;
		
	}

}
