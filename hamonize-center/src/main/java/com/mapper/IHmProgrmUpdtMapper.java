package com.mapper;

import java.util.HashMap;
import java.util.List;

import com.model.HmProgrmUpdtVo;

public interface IHmProgrmUpdtMapper {

	public List<HmProgrmUpdtVo> ListHmProgrmUpdt(HashMap<String, Object> map);

	public HmProgrmUpdtVo selectHmProgrmUpdt(HmProgrmUpdtVo vo);
	
	public int countHmProgrmUpdt(HmProgrmUpdtVo vo);

	public void InsertHmProgrmUpdt(HmProgrmUpdtVo vo);
	
	public void deleteHmProgrmUpdt(HmProgrmUpdtVo vo);
	
	
	public HmProgrmUpdtVo selectHmUpdateAgentJob( HmProgrmUpdtVo hvo ) ;
}