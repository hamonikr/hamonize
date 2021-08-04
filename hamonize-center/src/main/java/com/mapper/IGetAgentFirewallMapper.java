package com.mapper;

import java.util.List;

import com.model.GetAgentFirewallVo;

public interface IGetAgentFirewallMapper {

	public int setInsertSelect(GetAgentFirewallVo vo);

	public int getAgentWorkYn(GetAgentFirewallVo vo);

	public GetAgentFirewallVo getAgentOldSeq(GetAgentFirewallVo vo);

	public List<GetAgentFirewallVo> getListFirewallPolicy(GetAgentFirewallVo vo);

	public List<GetAgentFirewallVo> getAgentWorkData(GetAgentFirewallVo vo);

	public List<GetAgentFirewallVo> getAgentInitWorkData(GetAgentFirewallVo vo);

}
