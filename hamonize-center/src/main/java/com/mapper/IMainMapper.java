package com.mapper;

import java.util.List;
import java.util.Map;

public interface IMainMapper {
	
	public List<Map<String,Object>> sidoCount();
	
	public List<Map<String,Object>> gugunCount(Map<String, Object> params);
	
	public List<Map<String,Object>> tcngSidoCount();
	
	public List<Map<String,Object>> tcngGugunCount(Map<String, Object> params);
	
	public List<Map<String,Object>> pcUseSidoCount();

    public List<Map<String,Object>> pcTotalSidoCount();
	
	public int hCount();
	
	public List<Map<String,Object>> inetLogConnect(Map<String, Object> params);
	
	public List<Map<String,Object>> inetLogIlligal(Map<String, Object> params);
		


}
