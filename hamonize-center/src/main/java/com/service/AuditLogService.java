package com.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.text.ParseException;

import com.hamonize.portal.user.SecurityUser;
// import com.hamonize.portal.user.SecurityUser;
import com.mapper.IAuditLogMapper;
import com.mapper.IGetAgentJobMapper;
import com.model.AuditLogVo;
import com.model.GetAgentJobVo;
import com.model.LoginVO;
import com.paging.PagingVo;


@Service
public class AuditLogService {

	@Autowired
	private IGetAgentJobMapper agentJobMapper;
	
	@Autowired
	private IAuditLogMapper auditLogMapper;
	private Logger logger = LoggerFactory.getLogger(this.getClass());

	public List<AuditLogVo> userLogList(AuditLogVo vo, PagingVo pagingVo) throws ParseException {

		HashMap<String, Object> paramMap = new HashMap<String, Object>();
		
		paramMap.put("auditLogVo", vo);
		paramMap.put("pagingVo", pagingVo);
		List<AuditLogVo> list = auditLogMapper.userLogListInfo(paramMap);
		
		for (AuditLogVo el : list) {
			logger.info("spent time  --> {}", el.getSpent_time());
			if(el.getSpent_time() != null){
				String[] harray = el.getSpent_time().split("\\:");	
				int hours = Integer.valueOf(harray[0]);
		
				if(hours > 24){
					int days = hours/24;
					Double d_hours =((hours/24.0) - days)*24; 
					int n_hours =(int) Math.round(d_hours);

					logger.info("{}일 {}:{}:{}", days,n_hours ,harray[1],harray[2]);
					String convert_string = days+"일 "+n_hours+":"+harray[1]+":"+harray[2] ;
					el.setSpent_time(convert_string);
					
				}
					
			}
			
		}

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
	 * 업데이트 정책 적용 결과
	 */
	public List<Map<String, Object>> udptList(HashMap<String, Object> params, SecurityUser lvo ) {

		HashMap<String, Object> jsonObject = new HashMap<String, Object>();
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();

		try {

			List<String> list = auditLogMapper.udptPackageList();

			jsonObject.put("debList", list);
			jsonObject.put("debListCnt", list.size());
			jsonObject.put("uuid", params.get("pc_uuid"));
			jsonObject.put("org_seq", params.get("org_seq"));
			jsonObject.put("domain", lvo.getDomain());
			
			result = auditLogMapper.updtList(jsonObject);


		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		return result;

	}

	/**
	 * 프로그램 정책 적용 결과
	 */
	public List<Map<String, Object>> programList(HashMap<String, Object> params, SecurityUser lvo ) {

		HashMap<String, Object> jsonObject = new HashMap<String, Object>();
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();

		try {
			List<String> list = auditLogMapper.programPackageList(params);

			jsonObject.put("debList", list);
			jsonObject.put("debListCnt", list.size());
			jsonObject.put("uuid", params.get("pc_uuid"));
			jsonObject.put("org_seq", pcUUID_Domain( params.get("pc_uuid").toString(), lvo.getDomain() ));
			jsonObject.put("domain", lvo.getDomain());
			result = auditLogMapper.programList(jsonObject);


		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		return result;

	}

	/**
	 * 방화벽 정책 적용 결과
	 */
	public List<Map<String, Object>> firewallList(HashMap<String, Object> params, SecurityUser lvo ) {
	// public List<Map<String, Object>> firewallList(HashMap<String, Object> params, SecurityUser lvo ) {

		HashMap<String, Object> jsonObject = new HashMap<String, Object>();
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();

		try {

			List<String> list = auditLogMapper.firewallPackageList(lvo.getDomain());

			
			jsonObject.put("debList", list);
			jsonObject.put("debListCnt", list.size());
			jsonObject.put("uuid", params.get("pc_uuid"));
			jsonObject.put("domain", lvo.getDomain());
			jsonObject.put("org_seq", pcUUID_Domain( params.get("pc_uuid").toString(), lvo.getDomain() ));

			result = auditLogMapper.firewallList(jsonObject);


		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		return result;

	}

	/**
	 * 디바이스 정책 적용 결과
	 */
	public List<Map<String, Object>> deviceList(HashMap<String, Object> params, SecurityUser lvo) {

		HashMap<String, Object> jsonObject = new HashMap<String, Object>();
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();

		try {

			jsonObject.put("uuid", params.get("pc_uuid"));

			List<String> list = auditLogMapper.devicePackageList(jsonObject);

			jsonObject.put("debList", list);
			jsonObject.put("debListCnt", list.size());
			jsonObject.put("uuid", params.get("pc_uuid"));
			jsonObject.put("domain", lvo.getDomain());
			jsonObject.put("org_seq", pcUUID_Domain( params.get("pc_uuid").toString(), lvo.getDomain() ));


			result = auditLogMapper.deviceList(jsonObject);


		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		return result;

	}

	/**
	 * 유해사이트 정책 적용 결과
	 */
	public List<Map<String, Object>> nxssList(HashMap<String, Object> params) {

		HashMap<String, Object> jsonObject = new HashMap<String, Object>();
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();

		try {

			jsonObject.put("uuid", params.get("pc_uuid"));
			System.out.println("deviceparams...." + params);
			System.out.println("deviceuuid=======" + params.get("pc_uuid"));
			result = auditLogMapper.nxssList(jsonObject);

		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		return result;

	}

	public Long pcUUID_Domain(String uuid, String domain) {
		GetAgentJobVo agentVo = new GetAgentJobVo();
		agentVo.setPc_uuid(uuid);
		agentVo.setDomain(domain);
		agentVo = agentJobMapper.getAgentJobPcUUID(agentVo);
		Long segSeq = agentVo.getSeq();
		return segSeq;
	}
}
