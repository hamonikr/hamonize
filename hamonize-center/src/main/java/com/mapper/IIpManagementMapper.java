package com.mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.model.AllowIpInfoVo;

public interface IIpManagementMapper {
	public void insertIpInfo(AllowIpInfoVo vo);
	
	public void deleteIpInfo(AllowIpInfoVo vo);
	
	public int countMngrListInfo(AllowIpInfoVo vo);

	public List<AllowIpInfoVo> mngrListInfo(HashMap<String, Object> paramMap);
	
	public int ipCheck(Map<String, Object> params);
}
