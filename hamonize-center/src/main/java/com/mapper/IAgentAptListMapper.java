package com.mapper;

import java.util.List;

import com.model.AdminVo;

public interface IAgentAptListMapper {
	
	public List<AdminVo> adminList(AdminVo vo);
	
	public int saveApt(List<String> list);

}
