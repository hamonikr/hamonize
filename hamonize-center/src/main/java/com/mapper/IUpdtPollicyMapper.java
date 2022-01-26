package com.mapper;

import java.util.Map;

import com.model.UpdtPolicyVo;

public interface IUpdtPollicyMapper {

	public int updtPolicyActionResultInsert(Map<String, Object> map);

	public int updtInsertProgrm(UpdtPolicyVo vo);

	public int updtDeleteProgrm(Map<String, Object> map);

	public int deleteProccessBlockProgrm(Map<String, Object> map);

}
