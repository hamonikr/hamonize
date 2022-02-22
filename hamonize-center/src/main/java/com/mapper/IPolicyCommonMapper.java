package com.mapper;

import java.util.Map;

public interface IPolicyCommonMapper {
	
	public int addAnsibleJobEvent(Map<String, Object> params);
	
	public int checkCountAnsibleJobId(Map<String, Object> params);

}
