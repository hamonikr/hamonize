package com.service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONObject;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mapper.IOrgMapper;
import com.mapper.IPolicyProgramMapper;
import com.model.PolicyProgrmVo;

@Service
public class PolicyProgramService {

	@Autowired
	RestApiService restApiService;

	@Autowired
	IPolicyProgramMapper iProgramMapper;
	
	@Autowired
	IOrgMapper orgmapper;
	
	public List<PolicyProgrmVo> programList(PolicyProgrmVo vo) {
		
		List<PolicyProgrmVo> list = iProgramMapper.programList(vo);
		
		return list;
		
	}
	
	public int programSave(Map<String, Object> params) {
		return iProgramMapper.programSave(params);
		
	}
	public int programDelete(Map<String, Object> params) {
		return iProgramMapper.programDelete(params);
		
	}
	
	public PolicyProgrmVo programApplcView(PolicyProgrmVo vo){
		return iProgramMapper.programApplcView(vo);
		
	}

	public int applyProgramPolicy(Map<String, Object> params) throws ParseException{
		//Long segSeq = Long.parseLong(params.get("org_seq").toString());
		
		String[] listA = params.get("ppm_name").toString().split(",");
		String[] listB = params.get("former_ppm_name").toString().split(",");

		ArrayList<String> ppm_name = new ArrayList<String>(Arrays.asList(listA));
		ArrayList<String> former_ppm_name = new ArrayList<String>(Arrays.asList(listB));

		former_ppm_name.removeAll(ppm_name);

		// String output = "{\\\"INS\\\":\\\""+String.join(",",ppm_name)+"\\\",\\\"DEL\\\":\\\""+String.join(",",former_ppm_name)+"\\\"}";
		String output = "";
		JSONObject updtPolicy = new JSONObject();
		updtPolicy.put("INS", String.join(",",ppm_name));
		if(!former_ppm_name.isEmpty())
		{
			updtPolicy.put("DEL", String.join(",",former_ppm_name));
		}
		output = updtPolicy.toJSONString();
		output = output.replaceAll("\"", "\\\\\\\"");
		params.put("output", output);
		params.put("policyFilePath","/etc/hamonize/progrm/progrm.hm");

		int result = restApiService.makePolicy(params);
		System.out.println("resuklt======="+result);
	

		return result;

	}
	
}
