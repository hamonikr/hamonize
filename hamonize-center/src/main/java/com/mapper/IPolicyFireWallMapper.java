package com.mapper;//		String apiURL = "http://"+aptIp+"/dists/sgb-server/main/binary-amd64/Packages";


import java.util.List;
import java.util.Map;

import com.model.PolicyFireWallVo;

public interface IPolicyFireWallMapper {
	
	public List<PolicyFireWallVo> fireWallList(PolicyFireWallVo vo);
	
	public int fireWallSave(Map<String, Object> params);
	
	public int fireWallDelete(Map<String, Object> params);
	
	public PolicyFireWallVo fireWallApplcView(PolicyFireWallVo vo);
	
	public List<PolicyFireWallVo> fManagePopList(Map<String, Object> params);
	
	public int fireWallPolicyCount(PolicyFireWallVo vo);
	
	public int fireWallPopSave(PolicyFireWallVo vo);
	
	public void fireWallPopDelete(PolicyFireWallVo vo);
	
	public int fireWallPopCount(PolicyFireWallVo vo);

}
