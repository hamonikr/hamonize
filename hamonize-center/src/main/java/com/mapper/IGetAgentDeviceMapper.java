package com.mapper;

import java.util.List;

import com.model.GetAgentDeviceVo;

public interface IGetAgentDeviceMapper {

	public int setInsertSelect(GetAgentDeviceVo vo);

	public int getAgentWorkYn(GetAgentDeviceVo vo);

	public GetAgentDeviceVo getAgentOldSeq(GetAgentDeviceVo vo);

	public List<GetAgentDeviceVo> getListDevicePolicy(GetAgentDeviceVo vo);

	public List<GetAgentDeviceVo> getAgentWorkData(GetAgentDeviceVo vo);

	public List<GetAgentDeviceVo> getAgentInitWorkData(GetAgentDeviceVo vo);

}
