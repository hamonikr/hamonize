package com.mapper;

import java.util.List;
import java.util.Map;

import com.model.PolicyProgrmVo;

public interface IPolicyProgramMapper {
	
	public List<PolicyProgrmVo> programList(PolicyProgrmVo vo);
	
	public int programSave(Map<String, Object> params);
	
	public int programDelete(Map<String, Object> params);
	
	public PolicyProgrmVo programApplcView(PolicyProgrmVo vo);

	public int getProgrmHistoryLastJob(PolicyProgrmVo vo);

}
