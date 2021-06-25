package com.mapper;

import java.util.List;

import com.model.GetAgentNxssVo;

public interface IGetAgentNxssMapper {

	public int  setInsertSelect( GetAgentNxssVo vo );
	
	public GetAgentNxssVo getAgentWorkYn (GetAgentNxssVo vo );
	
	public List<GetAgentNxssVo> getListNxssPolicy( GetAgentNxssVo vo );

	
	
	
	
	
	
	
	
	
	
	
	
}
