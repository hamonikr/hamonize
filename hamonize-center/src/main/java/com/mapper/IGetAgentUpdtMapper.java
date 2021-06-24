package com.mapper;

import java.util.List;

import com.model.GetAgentUpdtVo;

public interface IGetAgentUpdtMapper {

	public int setInsertSelect(GetAgentUpdtVo vo);

	public int getAgentWorkYn(GetAgentUpdtVo vo);

	public GetAgentUpdtVo getAgentOldSeq(GetAgentUpdtVo vo);

	public List<GetAgentUpdtVo> getListUpdtsPolicy(GetAgentUpdtVo vo);

	public List<GetAgentUpdtVo> getAgentWorkData(GetAgentUpdtVo vo);

	public List<GetAgentUpdtVo> getAgentInitWorkData(GetAgentUpdtVo vo);

	public void updtStatus(GetAgentUpdtVo vo);

	public void setProgrmListFromUpdt(GetAgentUpdtVo vo);

	public void setProgrmListFromUpdtDelete(GetAgentUpdtVo vo);

	public void updtStatusDelete(GetAgentUpdtVo vo);

}
