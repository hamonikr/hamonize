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
import com.mapper.IPolicyFireWallMapper;
import com.model.PolicyFireWallVo;
import com.paging.PagingVo;

@Service
public class PolicyFireWallService {
	
	@Autowired
	RestApiService restApiService;

	@Autowired
	IPolicyFireWallMapper ifireWallMapper;
	
	@Autowired
	IOrgMapper orgmapper;
	
	public List<PolicyFireWallVo> firewallList(PolicyFireWallVo vo) {
		
		List<PolicyFireWallVo> list = ifireWallMapper.fireWallList(vo);
		
		return list;
		
	}
	
	public int fireWallSave(Map<String, Object> params) {
		return ifireWallMapper.fireWallSave(params);
		
	}
	public int fireWallDelete(Map<String, Object> params) {
		return ifireWallMapper.fireWallDelete(params);
		
	}
	
	public PolicyFireWallVo fireWallApplcView(PolicyFireWallVo vo){
		return ifireWallMapper.fireWallApplcView(vo);
		
	}
	
	public List<PolicyFireWallVo> fManagePopList(PolicyFireWallVo vo, PagingVo pagingVo) {

		Map<String, Object> paramMap = new HashMap<String, Object>();

		paramMap.put("mngeVo", vo);
		paramMap.put("pagingVo", pagingVo);

		List<PolicyFireWallVo> list = ifireWallMapper.fManagePopList(paramMap);

		return list;
	}
	
	public int fireWallPolicyCount(PolicyFireWallVo vo) {
		return ifireWallMapper.fireWallPolicyCount(vo);
	}
	
	public int fireWallPopSave(PolicyFireWallVo vo) throws Exception{
		return ifireWallMapper.fireWallPopSave(vo);
		
	}
	
	public void fireWallPopDelete(PolicyFireWallVo vo) throws Exception{
		ifireWallMapper.fireWallPopDelete(vo);
	}

	public JSONObject applyFirewallPolicy(Map<String, Object> params) throws ParseException{

		String[] listA = {};
		String[] listB = {};
		if(params.get("ppm_name").toString() != "")
		listA = params.get("ppm_name").toString().split(",");
		if(params.get("former_ppm_name").toString() != "")
		listB = params.get("former_ppm_name").toString().split(",");

		ArrayList<String> ppm_name = new ArrayList<String>(Arrays.asList(listA));
		ArrayList<String> former_ppm_name = new ArrayList<String>(Arrays.asList(listB));

		former_ppm_name.removeAll(ppm_name);

		//String output = "{\\\"INS\\\":\\\""+String.join(",",ppm_name)+"\\\",\\\"DEL\\\":\\\""+String.join(",",former_ppm_name)+"\\\"}";
		String output = "";
		JSONObject updtPolicy = new JSONObject();
		if(!ppm_name.isEmpty())
		{
			updtPolicy.put("INS", String.join(",",ppm_name));
		}
		if(!former_ppm_name.isEmpty())
		{
			updtPolicy.put("DEL", String.join(",",former_ppm_name));
		}
		output = updtPolicy.toJSONString();
		output = output.replaceAll("\"", "\\\\\\\"");
		params.put("output", output);
		params.put("policyFilePath","/etc/hamonize/firewall/firewallInfo.hm");
		params.put("policyRunFilePath","/etc/hamonize/runufw");

		JSONObject result = restApiService.makePolicyToGroup(params);
		System.out.println("resuklt======="+result);
	

		return result;
		
//		ArrayList<String> list_ppm_name = new ArrayList<String>();
//		ArrayList<String> list_former_ppm_name = new ArrayList<String>();
//		
//		
//		for (String el : params.get("ppm_name").toString().split(",")) {
//			list_ppm_name.add(el);
//		}
//		
//		for (String el : params.get("former_ppm_name").toString().split(",")) {
//			list_former_ppm_name.add(el);
//		}
//		
//		
//		System.out.println("@@@@@@@@@@@@@@@ ppm_name === "+ list_ppm_name.isEmpty()+":::" + list_ppm_name.get(0) +", --- " + list_ppm_name.get(0).length());
//		System.out.println("@@@@@@@@@@@@@@@ former_ppm_name === "+ list_former_ppm_name.isEmpty()+":::" +  list_former_ppm_name.get(0) +", --- " + list_former_ppm_name.get(0).length());
//		
//		
//		System.out.println("@@@@@@@@@@@@@@@ ppm_name === "+ list_ppm_name.isEmpty() +",---length " + list_ppm_name.size());
//		System.out.println("@@@@@@@@@@@@@@@ former_ppm_name === "+ list_former_ppm_name.isEmpty() +", length---" +list_former_ppm_name.size());
//
//		
//		
//		String output = "";
//		JSONObject updtPolicy = new JSONObject();
//		if( list_ppm_name.get(0).length() != 0 ) {
//			updtPolicy.put("INS", String.join(",",list_ppm_name));
//		}
//		System.out.println("############## output ==1111111111111============+"+ output );
//		if( list_former_ppm_name.get(0).length() != 0 ) {
//			System.out.println("=============+"+ list_former_ppm_name);
//			updtPolicy.put("DEL", String.join(",",list_former_ppm_name));
//		}
//		System.out.println("############## output ========222222222======+"+ output );
//		output = updtPolicy.toJSONString();
//		System.out.println("############## output ==============+"+ output );
//		output = output.replaceAll("\"", "\\\\\\\"");
//		params.put("output", output);
//		params.put("policyFilePath","/etc/hamonize/firewall/firewallInfo.hm");
//		params.put("policyRunFilePath","/etc/hamonize/runufw");
//
//		JSONObject result = restApiService.makePolicyToGroup(params);
//		System.out.println("resuklt======="+result);
//	
//
//		return result;
	}

	public int getFrwlHistoryLastJob(PolicyFireWallVo vo) {
		return ifireWallMapper.getFrwlHistoryLastJob(vo);
	}

}
