package com.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mapper.IHmprogramMapper;
import com.mapper.IOrgMapper;
import com.mapper.IPolicyProgramMapper;
import com.model.PolicyProgramVo;

@Service
public class PolicyNxssService {
	
	@Autowired
	IHmprogramMapper iHmprogramMapper;
	
	@Autowired
	IPolicyProgramMapper iProgramMapper;
	
	@Autowired
	IOrgMapper orgmapper;
	
	public List<PolicyProgramVo> programList(PolicyProgramVo vo) {
		
		List<PolicyProgramVo> list = iProgramMapper.programList(vo);
		
		return list;
		
	}


}
