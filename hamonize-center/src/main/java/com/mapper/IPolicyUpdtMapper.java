package com.mapper;

import java.util.List;
import java.util.Map;

import com.model.PolicyUpdtVo;

public interface IPolicyUpdtMapper {
	
	public List<PolicyUpdtVo> updtList(PolicyUpdtVo vo);
	
	public int updtSave(Map<String, Object> params);
	
	public int updtDelete(Map<String, Object> params);
	
	public PolicyUpdtVo updtApplcView(PolicyUpdtVo vo);
	
	public int getUpdtHistoryLastJob(PolicyUpdtVo vo);
	
	public List<Map<String, Object>> updtComapreList();
	
	public List<Map<String, Object>> updtResult(Map<String, Object> params);
	
	public int updtCompareSave(Map<String, Object> params);
	
	public int updtCompareUpdate(Map<String, Object> params);

	public int updatePolicyProgrm(Map<String, Object> params);

}
