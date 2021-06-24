package com.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mapper.IOrgMapper;
import com.mapper.IPolicyFireWallMapper;
import com.model.PolicyFireWallVo;
import com.paging.PagingVo;

@Service
public class PolicyFireWallService {
	
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

}
