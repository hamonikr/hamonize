package com.service;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mapper.IVersionChkMapper;
import com.model.VersionChkVo;
import com.paging.PagingVo;

@Service
public class VersionChkService {

	@Autowired
	private IVersionChkMapper versionChkMapper;

	public List<VersionChkVo> chkVersionInfo(VersionChkVo vo, PagingVo pagingVo) {

		HashMap<String, Object> paramMap = new HashMap<String, Object>();

		paramMap.put("versionChkVo", vo);
		paramMap.put("pagingVo", pagingVo);
		List<VersionChkVo> tt = versionChkMapper.chkVersionInfo(paramMap);

		return tt;
	}

}