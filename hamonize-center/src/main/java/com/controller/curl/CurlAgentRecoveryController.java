package com.controller.curl;

import java.util.List;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.mapper.IGetAgentJobMapper;
import com.mapper.IGetAgentRecoveryMapper;
import com.model.GetAgentJobVo;
import com.model.GetAgentRecoveryVo;

@RestController
@RequestMapping("/getAgent")
public class CurlAgentRecoveryController {

	@Autowired
	private IGetAgentJobMapper agentJobMapper;

	@Autowired
	private IGetAgentRecoveryMapper getAgentRecoveryMapper;

	/**
	 * 에이전트에 복구 정책 보내는 부분
	 * 
	 * @param uuid
	 * @param wget
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/recov", method = RequestMethod.GET)
	public String getRecovAgentJob(@RequestParam(value = "name", required = false) String uuid,
			@RequestParam(value = "wget", required = false) String wget) throws Exception {

		String output = "";
		uuid = uuid.trim();

		int segSeq = pcUUID(uuid);
		if (segSeq == 0) {
			return "nodata";
		}

		GetAgentRecoveryVo agentFirewallVo = new GetAgentRecoveryVo();
		agentFirewallVo.setOrg_seq(segSeq);
		agentFirewallVo.setPc_uuid(uuid);

		int chkProgrmPolicy = getAgentRecoveryMapper.getAgentWorkYn(agentFirewallVo);
		int chkRecoveryLog = getAgentRecoveryMapper.getInitChk(agentFirewallVo);

		if (chkProgrmPolicy == 0) {
			if (chkRecoveryLog == 0) {
				JSONObject jsonProgrmData = recoveryPolicyData(agentFirewallVo);
				output = jsonProgrmData.toString();
			} else {
				output = "nodata";
			}
		} else {
			output = "nodata";
		}

		return output;
	}

	public JSONObject recoveryPolicyData(GetAgentRecoveryVo getProgrmVo) {

		JSONObject jsonObject = new JSONObject();

		int retInsertSelectVal = getAgentRecoveryMapper.setInsertSelect(getProgrmVo);

		List<GetAgentRecoveryVo> outputDatga = getAgentRecoveryMapper.getAgentWorkData(getProgrmVo);

		for (GetAgentRecoveryVo set : outputDatga) {
			jsonObject.put("PATH", set.getBr_backup_path());
			jsonObject.put("NAME", set.getBr_backup_name());
		}

		return jsonObject;
	}

	public int pcUUID(String uuid) {
		GetAgentJobVo agentVo = new GetAgentJobVo();
		agentVo.setPc_uuid(uuid);
		agentVo = agentJobMapper.getAgentJobPcUUID(agentVo);

		int segSeq = 0;
		if (agentVo != null) {
			segSeq = agentVo.getSeq();
		}

		return segSeq;
	}

}
