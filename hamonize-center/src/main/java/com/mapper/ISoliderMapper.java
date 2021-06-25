package com.mapper;

import java.util.HashMap;
import java.util.List;

import com.model.SoliderVo;

public interface ISoliderMapper {

	public List<SoliderVo> soliderListInfo(HashMap<String, Object> map);

	public int countSoliderListInfo(SoliderVo vo);

	public SoliderVo selectUsreInfo(SoliderVo vo);

}