package com.service;

import java.util.HashMap; 
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mapper.ITchnlgyMapper;
import com.model.AnswerVo;
import com.model.TchnlgyVo;
import com.paging.PagingVo;

@Service
public class TchnlgyService {
	
	@Autowired
	private ITchnlgyMapper tchnlgyMapper;
	
	
	public void tchnlgyInsert(TchnlgyVo vo) throws Exception {
		tchnlgyMapper.tchnlgyInsert(vo);
	}
	
	
	public List<TchnlgyVo> tchnlgyList(TchnlgyVo vo, PagingVo pagingVo) {
		
		HashMap<String, Object> paramMap = new HashMap<String, Object>();

		paramMap.put("mngeVo", vo);
		paramMap.put("pagingVo", pagingVo);

		List<TchnlgyVo> list = tchnlgyMapper.tchnlgyListInfo(paramMap);

		return list;
		
		
	}


	
}
