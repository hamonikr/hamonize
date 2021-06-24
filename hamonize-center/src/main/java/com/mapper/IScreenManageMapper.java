package com.mapper;

import java.util.Map;

import com.model.FileVO;
import com.model.OrgVo;

public interface IScreenManageMapper {
	
	public Map<String, Object> getImageFile(Map<String, Object> params);
	
	public int saveFile(Map<String, Object> params);
	
	public FileVO screenView(OrgVo vo);
	
	

}
