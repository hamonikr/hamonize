package com.mapper;

import java.util.HashMap;
import java.util.List;

import com.model.BlockingNxssInfoVo;

public interface IBlockingNxssMngrMapper {
	public BlockingNxssInfoVo getForwardDomain();
	
	public void insertDomainInfo(BlockingNxssInfoVo vo);
	
	public void deleteDomainInfo(BlockingNxssInfoVo vo);
	
	public int countMngrListInfo(BlockingNxssInfoVo vo);

	public List<BlockingNxssInfoVo> mngrListInfo(HashMap<String, Object> paramMap);

	public void deleteForwardDomainInfo(BlockingNxssInfoVo vo);

	public void insertForwardDomainInfo(BlockingNxssInfoVo vo);
}
