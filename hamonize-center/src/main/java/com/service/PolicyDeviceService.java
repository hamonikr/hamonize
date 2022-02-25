package com.service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONObject;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mapper.IOrgMapper;
import com.mapper.IPolicyDeviceMapper;
import com.model.PolicyDeviceVo;
import com.paging.PagingVo;

@Service
public class PolicyDeviceService {
	
	@Autowired
	RestApiService restApiService;
	
	@Autowired
	IPolicyDeviceMapper iDeviceMapper;
	
	@Autowired
	IOrgMapper orgmapper;
	
	public List<PolicyDeviceVo> deviceList(PolicyDeviceVo vo) {
		
		List<PolicyDeviceVo> list = iDeviceMapper.deviceList(vo);
		
		return list;
		
	}
	
	public int deviceSave(Map<String, Object> params) {
		return iDeviceMapper.deviceSave(params);
		
	}
	public int deviceDelete(Map<String, Object> params) {
		return iDeviceMapper.deviceDelete(params);
		
	}
	
	public PolicyDeviceVo deviceApplcView(PolicyDeviceVo vo){
		return iDeviceMapper.deviceApplcView(vo);
		
	}
	
	public List<PolicyDeviceVo> dManagePopList(PolicyDeviceVo vo, PagingVo pagingVo) {

		Map<String, Object> paramMap = new HashMap<String, Object>();

		paramMap.put("mngeVo", vo);
		paramMap.put("pagingVo", pagingVo);

		List<PolicyDeviceVo> list = iDeviceMapper.dManagePopList(paramMap);

		return list;
	}
	
	public int devicePolicyCount(PolicyDeviceVo vo) {
		return iDeviceMapper.devicePolicyCount(vo);
	}
	
	public int devicePopSave(PolicyDeviceVo vo) throws Exception{
		return iDeviceMapper.devicePopSave(vo);
		
	}
	
	public void devicePopDelete(PolicyDeviceVo vo) throws Exception{
		iDeviceMapper.devicePopDelete(vo);
	}

	public JSONObject applyDevicePolicy(Map<String, Object> params) throws ParseException{
		
		ArrayList<String> list_ppmnm = new ArrayList<String>();
		ArrayList<String> list_former_ppmnm = new ArrayList<String>();

		for (String el : params.get("ppm_name").toString().split(",")) {
			list_ppmnm.add(el);
		}
		
		for (String el : params.get("former_ppm_name").toString().split(",")) {
			list_former_ppmnm.add(el);
		}
		
		list_former_ppmnm.removeAll(list_ppmnm);
		
		String output = "";
		JSONObject updtPolicy = new JSONObject();
		System.out.println("#############ppm_name##########" + list_ppmnm);
		System.out.println("#############former_ppm_name##########" + list_former_ppmnm);
		System.out.println("@@@@@@@@@@@@@@@ list_ppmnm === "+ list_ppmnm.get(0) +", --- " + list_ppmnm.get(0).length());
		System.out.println("@@@@@@@@@@@@@@@ list_former_ppmnm === "+ list_former_ppmnm.get(0) +", --- " + list_former_ppmnm.get(0).length());
		
		System.out.println("@@@@@@@@@@@@@@@ list_ppmnm === "+ list_ppmnm.isEmpty() +",---length " + list_ppmnm.size());
		System.out.println("@@@@@@@@@@@@@@@ list_former_ppmnm === "+ list_former_ppmnm.isEmpty() +", length---" +list_former_ppmnm.size());
		
		if( list_ppmnm.get(0).length() != 0 ) {
			updtPolicy.put("INS", String.join(",",list_ppmnm));
		}
		if( list_former_ppmnm.get(0).length() != 0) {
			updtPolicy.put("DEL", String.join(",",list_former_ppmnm));
		}
				
		
		output = updtPolicy.toJSONString();
		output = output.replaceAll("\"", "\\\\\\\"");
		System.out.println("####### output================="+output);
		params.put("output", output);
		params.put("policyFilePath","/etc/hamonize/security/device.hm");
		params.put("policyRunFilePath","/etc/hamonize/rundevicepolicy");

		JSONObject result = restApiService.makePolicyToGroup(params);
		return result;
//		return null;

	}

	public int getDeviceHistoryLastJob(PolicyDeviceVo vo) {
		return iDeviceMapper.getDeviceHistoryLastJob(vo);
	}

}
