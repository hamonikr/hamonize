package com.mapper;

import com.model.GetAgentPollingVo;
import com.model.HmProgrmUpdtVo;
import com.model.TenantconfigVo;

public interface IGetAgentPollingMapper {


	public TenantconfigVo getPollingTime(TenantconfigVo vo);

	public int insertPollingData(HmProgrmUpdtVo vo);
}
