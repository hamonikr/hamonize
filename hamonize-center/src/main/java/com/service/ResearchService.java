package com.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mapper.IResearchMapper;
import com.model.ResearchVo;

@Service
public class ResearchService {
	
	@Autowired
	private IResearchMapper rm;
	
	public List<Map<String, Object>> dayUsePc(ResearchVo vo) {
		return rm.dayUsePc(vo);
	}
	
	public List<Map<String, Object>> loginList(ResearchVo vo) {
		return rm.loginList(vo);
	}
	
	public List<Map<String, Object>> dayUseUser(ResearchVo vo) {
		return rm.dayUseUser(vo);
	}
	
	public List<Map<String, Object>> distionctDayUseUser(ResearchVo vo){
		return rm.distionctDayUseUser(vo);
	}
	
	public List<Map<String, Object>> monthUsePc(ResearchVo vo){
		return rm.monthUsePc(vo);
	}
	
	public List<Map<String, Object>> pcCountUnit(ResearchVo vo){
		return rm.pcCountUnit(vo);
	}
	
	public List<Map<String, Object>> dayTotalPc(ResearchVo vo){
		return rm.dayTotalPc(vo);
	}
	
	public List<Map<String, Object>> dayTotalUser(ResearchVo vo){
		return rm.dayTotalUser(vo);
	}
}
