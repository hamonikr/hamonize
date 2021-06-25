package com.mapper;

import java.util.HashMap;
import java.util.List;

import com.model.VersionChkVo;

public interface IVersionChkMapper {

	public int inserVersionChk(VersionChkVo vo);

	public List<VersionChkVo> chkVersionInfo(HashMap<String, Object> map);
	
}