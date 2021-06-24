package com.controller.curl;

import java.util.List; 

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.mapper.IGetAgentJobMapper;
import com.mapper.IGetAgentRecoveryMapper;
import com.model.GetAgentFirewallVo;
import com.model.GetAgentJobVo;
import com.model.GetAgentRecoveryVo;

@RestController
@RequestMapping("/getAgent")
public class CurlAgentRecoveryController {

	@Autowired
	private IGetAgentJobMapper agentJobMapper;

	@Autowired
	private IGetAgentRecoveryMapper getAgentRecoveryMapper;


	

	@RequestMapping("/recov")
	public String getAgentJob(@RequestParam(value = "name", required = false) String sgbUuid,
			@RequestParam(value = "wget", required = false) String sgbWget) throws Exception {

		String output = "";
		sgbUuid = sgbUuid.trim();

		int segSeq = sgbUUID(sgbUuid);
		if( segSeq == 0 ) {
			return  "nodata";
		}
		
		GetAgentRecoveryVo agentFirewallVo = new GetAgentRecoveryVo();
		agentFirewallVo.setOrg_seq(segSeq);
		agentFirewallVo.setPc_uuid(sgbUuid);

		int chkProgrmPolicy = getAgentRecoveryMapper.getAgentWorkYn(agentFirewallVo);
		int chkRecoveryLog = getAgentRecoveryMapper.getInitChk(agentFirewallVo);
		System.out.println("//===================================");
		System.out.println("//work yn === " + chkProgrmPolicy);
		System.out.println("//===================================");
		
		
		if ( chkProgrmPolicy == 0 ) {
			if( chkRecoveryLog != 0 ) {
				JSONObject jsonProgrmData = progrmPolicyData(agentFirewallVo);
				output = jsonProgrmData.toJSONString();	
			}else {
				output = "nodata";
			}
		} else {
			output = "nodata";
		}
		

		System.out.println("//===================================");
		System.out.println("//result data is : " + output);
		System.out.println("//===================================");
		
		return output;
	}

	
	
	public JSONObject progrmPolicyData(GetAgentRecoveryVo getProgrmVo) {

		JSONObject jsonObject = new JSONObject();

		
		int retInsertSelectVal = getAgentRecoveryMapper.setInsertSelect(getProgrmVo);
		
		System.out.println("//===============================");
		System.out.println("//====retInsertSelectVal is : "+ retInsertSelectVal);
		System.out.println("//===============================");

		List<GetAgentRecoveryVo> outputDatga = getAgentRecoveryMapper.getAgentWorkData(getProgrmVo);
		
		String arrAgentRecoveryData = "";
		for (GetAgentRecoveryVo set : outputDatga) {
//			System.out.println("----> " + set.getSeq());
//			System.out.println("----> " + set.getBr_backup_gubun());
//			System.out.println("----> " + set.getBr_backup_path());
//			System.out.println("----> " + set.getBr_backup_name());
//			System.out.println("----> " + set.getPc_uuid());

			jsonObject.put("PATH", set.getBr_backup_path());
			jsonObject.put("NAME", set.getBr_backup_name());
		}

		
		System.out.println("//===============================");
		System.out.println("//==jsonObject  data is : " + jsonObject);
		System.out.println("//===============================");
		 
		
		return jsonObject;
	}

	public int sgbUUID(String sgbUuid) {
		GetAgentJobVo agentVo = new GetAgentJobVo();
		agentVo.setPc_uuid(sgbUuid);
		agentVo = agentJobMapper.getAgentJobPcUUID(agentVo);
		
		int segSeq = 0;
		if(agentVo != null ) {
			segSeq = agentVo.getSeq();	
		}
		
		return segSeq;
	}

}
