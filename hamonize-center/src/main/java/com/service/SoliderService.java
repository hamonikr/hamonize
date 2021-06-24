package com.service;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mapper.ISoliderMapper;
import com.model.SoliderVo;
import com.paging.PagingVo;

@Service
public class SoliderService {

	@Autowired
	private ISoliderMapper soliderMapper;

	public List<SoliderVo> soliderList(SoliderVo vo, PagingVo pagingVo) {

		HashMap<String, Object> paramMap = new HashMap<String, Object>();

		paramMap.put("soliderVo", vo);
		paramMap.put("pagingVo", pagingVo);

		List<SoliderVo> listVal = soliderMapper.soliderListInfo(paramMap);

		return listVal;
	}

}