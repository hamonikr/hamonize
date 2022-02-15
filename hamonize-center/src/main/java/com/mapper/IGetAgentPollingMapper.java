package com.mapper;

import com.model.GetAgentPollingVo;
import com.model.HmProgrmUpdtVo;

public interface IGetAgentPollingMapper {


	public GetAgentPollingVo getPollingTime(GetAgentPollingVo vo);

	public int insertPollingData(HmProgrmUpdtVo vo);
}
