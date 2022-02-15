package com.service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.TreeSet;
import java.util.stream.Collectors;


import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;

import com.mapper.IGetAgentJobMapper;
import com.mapper.IGetAgentUpdtMapper;
import com.mapper.IOrgMapper;
import com.mapper.IPolicyUpdtMapper;
import com.model.GetAgentUpdtVo;
import com.model.PolicyUpdtVo;

@Service
public class PolicyUpdtService {

	@Autowired
	RestApiService restApiService;

	@Autowired
	IPolicyUpdtMapper iUpdtMapper;
	
	@Autowired
	IOrgMapper orgmapper;

	private Logger logger = LoggerFactory.getLogger(this.getClass());
	
	public List<PolicyUpdtVo> updtList(PolicyUpdtVo vo) {
		
		List<PolicyUpdtVo> list = iUpdtMapper.updtList(vo);
		
		return list;
		
	}
	
	public int updtSave(Map<String, Object> params) {
		return iUpdtMapper.updtSave(params);
		
	}
	public int updatePolicyProgrm(Map<String, Object> params) {
		return iUpdtMapper.updatePolicyProgrm(params);
		
	}
	public int updtDelete(Map<String, Object> params) {
		return iUpdtMapper.updtDelete(params);
		
	}
	
	public PolicyUpdtVo updtApplcView(PolicyUpdtVo vo){
		return iUpdtMapper.updtApplcView(vo);
		
	}
	public int updtCompareSave(Map<String, Object> params) {
		return iUpdtMapper.updtCompareSave(params);
	}
	public int updtCompareUpdate(Map<String, Object> params) {
		return iUpdtMapper.updtCompareUpdate(params);
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
		params.put("policyFilePath","/etc/hamonize/updt/updtInfo.hm");

		int result = restApiService.makePolicy(params);
		System.out.println("resuklt======="+result);
	

		return result;

	}

}
