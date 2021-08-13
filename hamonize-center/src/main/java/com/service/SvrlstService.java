package com.service;

import java.util.HashMap;
import java.util.List;

import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mapper.ISvrlstMapper;
import com.model.SvrlstVo;
import com.paging.PagingVo;

@Service
public class SvrlstService {

	@Autowired
	private ISvrlstMapper svrlstMapper;

	public List<SvrlstVo> getSvrlstList(SvrlstVo vo, PagingVo pagingVo) {

		HashMap<String, Object> paramMap = new HashMap<String, Object>();

		paramMap.put("mngeVo", vo);
		paramMap.put("pagingVo", pagingVo);

		List<SvrlstVo> retData = svrlstMapper.getSvrlstList(paramMap);

		return retData;
	}



	@Transactional
	public void svrlstInsert(SvrlstVo nVo) throws Exception {
		svrlstMapper.svrlstInsert(nVo);
	}


}
