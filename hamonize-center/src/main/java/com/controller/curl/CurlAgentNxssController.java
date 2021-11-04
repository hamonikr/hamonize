package com.controller.curl;

import java.util.List;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.mapper.IGetAgentJobMapper;
import com.mapper.IGetAgentNxssMapper;
import com.model.GetAgentJobVo;
import com.model.GetAgentNxssVo;

@RestController
@RequestMapping("/getAgent")
public class CurlAgentNxssController {

	@Autowired
	private IGetAgentJobMapper agentJobMapper;

	@Autowired
	private IGetAgentNxssMapper getAgentNxssMapper;

	@RequestMapping(value = "/nxss", method = RequestMethod.GET)
	public String getAgentJob(@RequestParam(value = "name", required = false) String sgbUuid,
			@RequestParam(value = "wget", required = false) String sgbWget) throws Exception {

		// 출력 변수
		String output = "";
		sgbUuid = sgbUuid.trim();

		// uuid로 부서정보 가져오기
		int segSeq = sgbUUID(sgbUuid);
		if (segSeq == 0) {
			return "nodata";
		}

		GetAgentNxssVo agentNxssVo = new GetAgentNxssVo();
		agentNxssVo.setPcm_uuid(sgbUuid);

		GetAgentNxssVo chkProgrmPolicy = getAgentNxssMapper.getAgentWorkYn(agentNxssVo);

		if (chkProgrmPolicy == null) {
			int retInsertSelectVal = getAgentNxssMapper.setInsertSelect(agentNxssVo);
			JSONObject jsonNxssData = progrmPolicyData(agentNxssVo);
			output = jsonNxssData.toJSONString();
		} else {
			if (chkProgrmPolicy.getHist_seq() != 0
					&& (chkProgrmPolicy.getSma_history_seq() != chkProgrmPolicy.getHist_seq())) {
				int retInsertSelectVal = getAgentNxssMapper.setInsertSelect(agentNxssVo);
				JSONObject jsonNxssData = progrmPolicyData(agentNxssVo);
				output = jsonNxssData.toJSONString();
			} else {
				output = "nodata";
			}

		}

		return output;
	}

	public JSONObject progrmPolicyData(GetAgentNxssVo agentNxssVo) {

		JSONObject jsonObject = new JSONObject();

		String nxssList = "", fording = "", message = "";
		;
		int nxssListCnt = 0;
		List<GetAgentNxssVo> nxssData = getAgentNxssMapper.getListNxssPolicy(agentNxssVo);

		for (GetAgentNxssVo bnif : nxssData) {
			if ("B".equals(bnif.getSma_gubun())) {
				nxssList += bnif.getSma_domain() + "\n";
				nxssListCnt++;
			} else if ("F".equals(bnif.getSma_gubun())) {
				fording += bnif.getSma_domain() + "\n";
				message += bnif.getSma_info() + "\n";
			}
		}
		jsonObject.put("nxssList", nxssList);
		jsonObject.put("nxssListCnt", nxssListCnt);
		jsonObject.put("fording", fording);
		jsonObject.put("message", message);

		return jsonObject;
	}

	/**
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
		if (agentVo != null) {
			segSeq = agentVo.getSeq();
		}
		return segSeq;
	}

}
