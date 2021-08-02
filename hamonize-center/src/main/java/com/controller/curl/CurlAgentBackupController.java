package com.controller.curl;

import java.util.List;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.mapper.IGetAgentBackupMapper;
import com.mapper.IGetAgentJobMapper;
import com.model.GetAgentBackupVo;
import com.model.GetAgentJobVo;

@RestController
@RequestMapping("/getAgent")
public class CurlAgentBackupController {

	@Autowired
	private IGetAgentJobMapper agentJobMapper;

	@Autowired
	private IGetAgentBackupMapper getAgentBackupMapper;

	

	@RequestMapping("/backup")
	public String getAgentJob(@RequestParam(value = "name", required = false) String sgbUuid,
			@RequestParam(value = "wget", required = false) String sgbWget) throws Exception {

		// 출력 변수
		String output = "";
		System.out.println("===" + sgbUuid + "==" + sgbWget);
		sgbUuid = sgbUuid.trim();

		// uuid로 부서정보 가져오기
		int segSeq = sgbUUID(sgbUuid);
		if( segSeq == 0 ) {
			return  "nodata";
		}

		GetAgentBackupVo agentBackupVo = new GetAgentBackupVo();
		agentBackupVo.setOrg_seq(segSeq);
		agentBackupVo.setPcm_uuid(sgbUuid);

		int chkProgrmPolicy = getAgentBackupMapper.getAgentWorkYn(agentBackupVo);
		
		if ( chkProgrmPolicy == 0 ) {
			JSONObject jsonProgrmData = progrmPolicyData(agentBackupVo);
			
			if( jsonProgrmData.size() == 0 ) {
				output = "nodata";
			}else {
				if( jsonProgrmData.get("nodata") != null ) {
					output =  jsonProgrmData.get("nodata").toString();	
				}else {
					output = jsonProgrmData.toJSONString();
				}
				
			}
			
		} else {
			output = "nodata";
		}
		

		System.out.println("//===================================");
		System.out.println("//result data is : " + output);
		System.out.println("//===================================");
		
		return output;
	}

	
	
	public JSONObject progrmPolicyData(GetAgentBackupVo agentBackupVo) {

		JSONObject jsonObject = new JSONObject();

		
		int retInsertSelectVal = getAgentBackupMapper.setInsertSelect(agentBackupVo);
		
		System.out.println("//===============================");
		System.out.println("//====retInsertSelectVal is : "+ retInsertSelectVal);
		System.out.println("//===============================");

		// 정책 가져오기 
		List<GetAgentBackupVo> progrmBackupData = getAgentBackupMapper.getListBackupPolicy(agentBackupVo);
		System.out.println("//+progrmPolicyData.size() ==="+ progrmBackupData.size() );
		if( progrmBackupData.size() == 0  ) {
			jsonObject.put("nodata", "nodata");
			return jsonObject;
		}
		
		
		JSONObject backupInfo = new JSONObject();
		String arrAgentProgrmY = "", arrAgentProgrmN = "";
		for (GetAgentBackupVo set : progrmBackupData) {
			System.out.println("----> " + set.getBac_seq() + "==" + set.getOrg_seq() + "==" + set.getBac_cycle_option() + "=="
					+ set.getBac_cycle_time() + "==" + set.getBac_gubun());
			
			backupInfo = new JSONObject();
			backupInfo.put("cycle_option", set.getBac_cycle_option());
			backupInfo.put("cycle_time", set.getBac_cycle_time());
			backupInfo.put("Bac_gubun", set.getBac_gubun());
		}
		

		JSONArray backupArray = new JSONArray();
		backupArray.add(backupInfo);
		
        jsonObject.put("backup", backupArray);
		return jsonObject;
	}


	/*
	 * 부서 UUID로 부서 seq 가져오기
	 * 
	 * @param sgbUuid
	 * @return 부서seq
	 */
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