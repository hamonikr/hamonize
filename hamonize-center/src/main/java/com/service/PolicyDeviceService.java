package com.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mapper.IOrgMapper;
import com.mapper.IPolicyDeviceMapper;
import com.model.AllowIpInfoVo;
import com.model.PolicyDeviceVo;
import com.paging.PagingVo;

@Service
public class PolicyDeviceService {
	
	
	
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
