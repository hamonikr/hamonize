package com.mapper;

import java.util.List;
import java.util.Map;

import com.model.PolicyDeviceVo;

public interface IPolicyDeviceMapper {
	
	public List<PolicyDeviceVo> deviceList(PolicyDeviceVo vo);
	
	public int deviceSave(Map<String, Object> params);
	
	public int deviceDelete(Map<String, Object> params);
	
	public PolicyDeviceVo deviceApplcView(PolicyDeviceVo vo);
	
	public List<PolicyDeviceVo> dManagePopList(Map<String, Object> params);
	
	public int devicePolicyCount(PolicyDeviceVo vo);
	
	public int devicePopSave(PolicyDeviceVo vo);
	
	public void devicePopDelete(PolicyDeviceVo vo);
	
	public int devicePopCount(PolicyDeviceVo vo);


}
