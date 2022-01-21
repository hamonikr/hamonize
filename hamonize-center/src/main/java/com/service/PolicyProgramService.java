package com.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mapper.IOrgMapper;
import com.mapper.IPolicyProgramMapper;
import com.model.PolicyProgrmVo;

@Service
public class PolicyProgramService {

	
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
	
}
