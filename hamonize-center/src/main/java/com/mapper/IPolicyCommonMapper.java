package com.mapper;

import java.util.Map;

public interface IPolicyCommonMapper {
	
	public int addAnsibleJobEventByHost(Map<String, Object> params);

	public int addAnsibleJobEventByGroup(Map<String, Object> params);

	public int deleteAnsibleJobEvent(Map<String, Object> params);
	
	public int checkCountAnsibleJobId(Map<String, Object> params);

	public Map<String, Object> getAnsibleJobEventByGroup(Map<String, Object> params);

	public int addAnsibleJobEventRelaunch(Map<String, Object> params);

}
