package com.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mapper.IIpManagementMapper;
import com.model.AllowIpInfoVo;
import com.paging.PagingVo;




@Service
public class IpManagementService {
	
	@Autowired
	private IIpManagementMapper ipManagementMapper;

	
	public List<AllowIpInfoVo> ipManagementList(AllowIpInfoVo vo, PagingVo pagingVo) {

		HashMap<String, Object> paramMap = new HashMap<String, Object>();

		paramMap.put("mngeVo", vo);
		paramMap.put("pagingVo", pagingVo);

		List<AllowIpInfoVo> tt = ipManagementMapper.mngrListInfo(paramMap);

		return tt;
	}
	
	
	@Transactional
	public void insertIpInfo(AllowIpInfoVo vo) throws Exception{
		ipManagementMapper.insertIpInfo(vo);
	}

	
	@Transactional
	public void deleteIpInfo(AllowIpInfoVo vo) throws Exception{
		ipManagementMapper.deleteIpInfo(vo);
	}
	@Transactional
	public int ipCheck(Map<String, Object> params) {
		return ipManagementMapper.ipCheck(params);
	}
}
