package com.service;

import java.util.HashMap;
import java.util.List;

import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mapper.IBlockingNxssMngrMapper;
import com.model.BlockingNxssInfoVo;
import com.paging.PagingVo;




@Service
public class BlockingNxssMngrService {
	
	@Autowired
	private IBlockingNxssMngrMapper blockingNxssMngrMapper;

	
	public List<BlockingNxssInfoVo> blockingList(BlockingNxssInfoVo vo, PagingVo pagingVo) {

		HashMap<String, Object> paramMap = new HashMap<String, Object>();

		paramMap.put("mngeVo", vo);
		paramMap.put("pagingVo", pagingVo);

		List<BlockingNxssInfoVo> tt = blockingNxssMngrMapper.mngrListInfo(paramMap);

		return tt;
	}
	
	
	@Transactional
	public void updateForwardDomainInfo(BlockingNxssInfoVo vo) throws Exception{
		blockingNxssMngrMapper.deleteForwardDomainInfo(vo);
		blockingNxssMngrMapper.insertForwardDomainInfo(vo);
	}
	
	
	@Transactional
	public void insertDomainInfo(BlockingNxssInfoVo vo) throws Exception{
		blockingNxssMngrMapper.insertDomainInfo(vo);
	}

	
	@Transactional
	public void deleteDomainInfo(BlockingNxssInfoVo vo) throws Exception{
		blockingNxssMngrMapper.deleteDomainInfo(vo);
	}
}
