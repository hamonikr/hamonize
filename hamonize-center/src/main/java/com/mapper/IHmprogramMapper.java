package com.mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.model.HmprogramVo;

public interface IHmprogramMapper {

	public List<HmprogramVo> hmPcProgramListInfo(HashMap<String, Object> map);

	public HmprogramVo selectHmProgrm(HmprogramVo vo);
	
	public int countHmPcProgramListInfo(HmprogramVo vo);

	public void deleteHmProgrm(HmprogramVo vo);
	
	public void save(HmprogramVo vo);
	
	public HmprogramVo selectHmProgrmAgentJob( HmprogramVo hvo ) ;
	
	public int prcssKillLog(Map<String, Object> map);
	

}