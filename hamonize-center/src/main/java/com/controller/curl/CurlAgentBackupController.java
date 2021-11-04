package com.controller.curl;

import java.util.List;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
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

	private Logger logger = LoggerFactory.getLogger(this.getClass());


	/**
	 * 에이전트에 백업 정책 보내는 매서드
	 * 
	 * @param pcUuid
	 * @param wget
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/backup", method = RequestMethod.GET)
	public String getAgentJob(@RequestParam(value = "name", required = false) String pcUuid,
			@RequestParam(value = "wget", required = false) String wget) throws Exception {

		// 출력 변수
		String output = "";
		pcUuid = pcUuid.trim();

		// uuid로 부서정보 가져오기
		int segSeq = pcUUID(pcUuid);
		if (segSeq == 0) {
			return "nodata";
		}

		GetAgentBackupVo agentBackupVo = new GetAgentBackupVo();
		agentBackupVo.setOrg_seq(segSeq);
		agentBackupVo.setPcm_uuid(pcUuid);

		int chkProgrmPolicy = getAgentBackupMapper.getAgentWorkYn(agentBackupVo);

		if (chkProgrmPolicy == 0) {
			JSONObject jsonProgrmData = progrmPolicyData(agentBackupVo);

			if (jsonProgrmData.size() == 0) {
				output = "nodata";
			} else {
				if (jsonProgrmData.get("nodata") != null) {
					output = jsonProgrmData.get("nodata").toString();
				} else {
					output = jsonProgrmData.toJSONString();
				}

			}

		} else {
			output = "nodata";
		}



		return output;
	}



	public JSONObject progrmPolicyData(GetAgentBackupVo agentBackupVo) {

		JSONObject jsonObject = new JSONObject();


		int retInsertSelectVal = getAgentBackupMapper.setInsertSelect(agentBackupVo);


		// 정책 가져오기
		List<GetAgentBackupVo> progrmBackupData =
				getAgentBackupMapper.getListBackupPolicy(agentBackupVo);
		if (progrmBackupData.size() == 0) {
			jsonObject.put("nodata", "nodata");
			return jsonObject;
		}


		JSONObject backupInfo = new JSONObject();
		String arrAgentProgrmY = "", arrAgentProgrmN = "";
		for (GetAgentBackupVo set : progrmBackupData) {

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
	 * @param pcUuid
	 * 
	 * @return 부서seq
	 */
	public int pcUUID(String pcUUID) {
		GetAgentJobVo agentVo = new GetAgentJobVo();
		agentVo.setPc_uuid(pcUUID);
		agentVo = agentJobMapper.getAgentJobPcUUID(agentVo);
		int segSeq = 0;
		if (agentVo != null) {
			segSeq = agentVo.getSeq();
		}
		return segSeq;
	}

}
