package com.mapper;

import java.util.List;
import java.util.Map;

import com.model.LogInOutVo;

public interface IPolicyCommonMapper {
	
	public int addAnsibleJobEventByHost(Map<String, Object> params);

	public int addAnsibleJobRelaunchEventByHost(Map<String, Object> params);

	public int aupdateAnsibleJobEventByHost(Map<String, Object> params);

	public int addAnsibleJobEventByGroup(Map<String, Object> params);

	public int deleteAnsibleJobEvent(Map<String, Object> params);
	
	public int checkCountAnsibleJobId(Map<String, Object> params);

	public List<Map<String, Object>> checkAnsibleJobFailOrNot(LogInOutVo inputVo);
	
	public List<Map<String, Object>> checkAnsibleJobFailOrNotList(LogInOutVo inputVo);

	public List<Map<String, Object>> checkAnsibleJobUpdtWhenOffPc(LogInOutVo inputVo);

	public List<Map<String, Object>> checkAnsibleJobProgrmWhenOffPc(LogInOutVo inputVo);

	public List<Map<String, Object>> checkAnsibleJobFrwlWhenOffPc(LogInOutVo inputVo);

	public List<Map<String, Object>> checkAnsibleJobDeviceWhenOffPc(LogInOutVo inputVo);

	public int deleteAnsibleJobRelaunchEvent(Map<String, Object> params);
	
	public int checkCountAnsibleJobRelaunchId(Map<String, Object> params);

	public Map<String, Object> getAnsibleJobEventByGroup(Map<String, Object> params);

	public int addAnsibleJobEventRelaunch(Map<String, Object> params);

}
