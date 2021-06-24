package com.mapper;

import java.util.HashMap;
import java.util.List;

import com.model.HmProgrmUpdtVo;
import com.model.HmSecurityVo;

public interface IHmSecurityMapper {

	public List<HmSecurityVo> ListHmSecurity(HashMap<String, Object> map);

	public HmSecurityVo selectHmSecurity(HmSecurityVo vo);
	
	public int countHmSecurity(HmSecurityVo vo);

	public int InsertHmSecurity(HmSecurityVo vo);
	
	public void deleteHmSecurity(HmSecurityVo vo);
	

	public HmSecurityVo selectHmSecurityAgentJob( HmSecurityVo hvo ) ;
}