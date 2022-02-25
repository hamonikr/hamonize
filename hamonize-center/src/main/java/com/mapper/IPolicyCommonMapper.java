package com.mapper;

import java.util.Map;

public interface IPolicyCommonMapper {
	
	public int addAnsibleJobEventByHost(Map<String, Object> params);

	public int addAnsibleJobRelaunchEventByHost(Map<String, Object> params);

	public int aupdateAnsibleJobEventByHost(Map<String, Object> params);

	public int addAnsibleJobEventByGroup(Map<String, Object> params);

	public int deleteAnsibleJobEvent(Map<String, Object> params);
	
	public int checkCountAnsibleJobId(Map<String, Object> params);

	public int deleteAnsibleJobRelaunchEvent(Map<String, Object> params);
	
	public int checkCountAnsibleJobRelaunchId(Map<String, Object> params);

	public Map<String, Object> getAnsibleJobEventByGroup(Map<String, Object> params);

	public int addAnsibleJobEventRelaunch(Map<String, Object> params);

}
