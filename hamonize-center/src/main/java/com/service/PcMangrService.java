package com.service;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mapper.IPcMangrMapper;
import com.model.PcMangrVo;
import com.paging.PagingVo;

@Service
public class PcMangrService {

	@Autowired
	private IPcMangrMapper pcMangrMapper;

	public List<PcMangrVo> pcMangrList(PcMangrVo vo, PagingVo pagingVo) {

		HashMap<String, Object> paramMap = new HashMap<String, Object>();

		paramMap.put("pcMangrVo", vo);
		paramMap.put("pagingVo", pagingVo);
		List<PcMangrVo> tt = pcMangrMapper.pcListInfo(paramMap);

		return tt;
	}
	
	public List<PcMangrVo> pcBlockList(PcMangrVo vo, PagingVo pagingVo) {

		HashMap<String, Object> paramMap = new HashMap<String, Object>();

		paramMap.put("pcMangrVo", vo);
		paramMap.put("pagingVo", pagingVo);
		List<PcMangrVo> tt = pcMangrMapper.pcBlockListInfo(paramMap);

		return tt;
	}
	
	public int updateBlock(PcMangrVo vo) {
		return pcMangrMapper.updateBlock(vo);
	}
	
	public int updateUnBlock(PcMangrVo vo) {
		return pcMangrMapper.updateUnblock(vo);
	}
	

}