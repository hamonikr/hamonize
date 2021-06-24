package com.mapper;

import java.util.List;

import com.model.GetAgentProgrmVo;

public interface IGetAgentProgrmMapper {

	public List<GetAgentProgrmVo> getListProgrmPolicy( GetAgentProgrmVo vo );

	
	public List<GetAgentProgrmVo> getListProgrm( GetAgentProgrmVo vo );
	
	
	public int getAgentWorkYn (GetAgentProgrmVo vo );

	public GetAgentProgrmVo getAgentOldSeq (GetAgentProgrmVo vo );
	
	
	public int  setInsertSelect( GetAgentProgrmVo vo );
	
	
	public List<GetAgentProgrmVo> getAgentWorkData( GetAgentProgrmVo vo );
	
}
