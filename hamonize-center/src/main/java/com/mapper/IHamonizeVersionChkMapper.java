package com.mapper;

import com.model.hamonizeVersionChkVo;

public interface IHamonizeVersionChkMapper {

	
	public hamonizeVersionChkVo getHamonizeAgentInfoOnPc(hamonizeVersionChkVo vo);
	
	public int setHamonizeAgentIfnoOnPc(hamonizeVersionChkVo vo);

	public int updateHamonizeAgentIfnoOnPc(hamonizeVersionChkVo vo);
	
}
