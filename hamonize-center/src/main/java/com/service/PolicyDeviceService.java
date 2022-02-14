package com.service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

	public int makePolicyPackage(Map<String, Object> params) throws ParseException{
		//Long segSeq = Long.parseLong(params.get("org_seq").toString());
		
		String[] listA = params.get("ppm_name").toString().split(",");
		String[] listB = params.get("former_ppm_name").toString().split(",");

		ArrayList<String> ppm_name = new ArrayList<String>(Arrays.asList(listA));
		ArrayList<String> former_ppm_name = new ArrayList<String>(Arrays.asList(listB));

		former_ppm_name.removeAll(ppm_name);

		String output = "{\\\"INS\\\":\\\""+String.join(",",ppm_name)+"\\\",\\\"DEL\\\":\\\""+String.join(",",former_ppm_name)+"\\\"}";
		// String output = "";
		// JSONObject updtPolicy = new JSONObject();
		// updtPolicy.put("INSERT", String.join(",",ppm_name));
		// if(!former_ppm_name.isEmpty())
		// {
		// 	updtPolicy.put("DEL", String.join(",",former_ppm_name));
		// }
		// output = updtPolicy.toJSONString();
		// output = output.replaceAll("\"", "\\\\\\\"");
		params.put("output", output);
		params.put("policyFilePath","/etc/hamonize/security/device.hm");

		int result = restApiService.makePolicy(params);
		System.out.println("resuklt======="+result);
	

		return result;

	}

}
