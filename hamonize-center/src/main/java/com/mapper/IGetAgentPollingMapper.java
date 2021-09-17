package com.mapper;

import com.model.GetAgentPollingVo;
import com.model.HmProgrmUpdtVo;

public interface IGetAgentPollingMapper {

	public int getAgentWorkYn(GetAgentPollingVo vo);

	public GetAgentPollingVo getPollingTime(GetAgentPollingVo vo);

	public int insertPollingData(HmProgrmUpdtVo vo);
}
