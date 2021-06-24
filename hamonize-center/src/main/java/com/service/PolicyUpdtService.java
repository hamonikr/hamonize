package com.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mapper.IOrgMapper;
import com.mapper.IPolicyProgramMapper;
import com.mapper.IPolicyUpdtMapper;
import com.model.PolicyProgramVo;
import com.model.PolicyUpdtVo;

@Service
public class PolicyUpdtService {

	
	@Autowired
	IPolicyUpdtMapper iUpdtMapper;
	
	@Autowired
	IOrgMapper orgmapper;
	
	public List<PolicyUpdtVo> updtList(PolicyUpdtVo vo) {
		
		List<PolicyUpdtVo> list = iUpdtMapper.updtList(vo);
		
		return list;
		
	}
	
	public int updtSave(Map<String, Object> params) {
		return iUpdtMapper.updtSave(params);
		
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
	/*
	 * public List<HmprogramVo> soliderList(HmprogramVo vo, PagingVo pagingVo) {
	 * 
	 * HashMap<String, Object> paramMap = new HashMap<String, Object>();
	 * 
	 * paramMap.put("hmprogramVo", vo); //paramMap.put("pagingVo", pagingVo);
	 * 
	 * List<HmprogramVo> listVal = hmprogramMapper.hmPcProgramListInfo(paramMap);
	 * 
	 * return listVal; }
	 */

}
