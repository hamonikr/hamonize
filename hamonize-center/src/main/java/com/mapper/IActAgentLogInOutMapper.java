package com.mapper;

import com.model.LogInOutVo;

public interface IActAgentLogInOutMapper {


	public int insertLoginLog(LogInOutVo vo);
	public int updateLoginLog(LogInOutVo vo);
	
	public int selectLoginLogSeq(LogInOutVo vo);
}