package com.mapper;

import java.util.List;
import java.util.Map;

import com.model.ResearchVo;
import com.model.UserVo;

public interface IResearchMapper {

	public List<Map<String, Object>> first(UserVo vo);
	
	public List<Map<String, Object>> dayUsePc(ResearchVo vo);
	
	public List<Map<String, Object>> loginList(ResearchVo vo);
	
	public List<Map<String, Object>> dayUseUser(ResearchVo vo);
	
	public List<Map<String, Object>> distionctDayUseUser(ResearchVo vo);
	
	public List<Map<String, Object>> monthUsePc(ResearchVo vo);
	
	public List<Map<String, Object>> pcCountUnit(ResearchVo vo);
	
	public List<Map<String, Object>> dayTotalPc(ResearchVo vo);
	
	public List<Map<String, Object>> dayTotalUser(ResearchVo vo);
	
}
