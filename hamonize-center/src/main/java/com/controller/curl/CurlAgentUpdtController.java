package com.controller.curl;

import java.util.List;

import com.mapper.IGetAgentJobMapper;
import com.mapper.IGetAgentUpdtMapper;
import com.model.GetAgentJobVo;
import com.model.GetAgentUpdtVo;

import org.json.simple.JSONObject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/getAgent")
public class CurlAgentUpdtController {

	@Autowired
	private IGetAgentJobMapper agentJobMapper;

	@Autowired
	private IGetAgentUpdtMapper getAgentUpdtMapper;

	private Logger logger = LoggerFactory.getLogger(this.getClass());


	/**
	 * 에이전트에 업데이트 정책 보내는 부분
	 * 
	 * @param uuid
	 * @param wget
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updt", method = RequestMethod.GET)
	public String getAgentJob(@RequestParam(value = "name", required = false) String uuid,
			@RequestParam(value = "wget", required = false) String wget) throws Exception {
		String output = "";
		uuid = uuid.trim();

		// uuid로 부서정보 가져오기
		Long segSeq = pcUUID(uuid);
		if (segSeq == 0) {
			return "nodata";
		}

		GetAgentUpdtVo agentFirewallVo = new GetAgentUpdtVo();
		agentFirewallVo.setOrg_seq(segSeq);
		agentFirewallVo.setPcm_uuid(uuid);

		int chkProgrmPolicy = getAgentUpdtMapper.getAgentWorkYn(agentFirewallVo);
		logger.info("//===================================");
		logger.debug("//getAgent work yn === {}", chkProgrmPolicy);
		logger.info("//===================================");


		if (chkProgrmPolicy == 0) {
			JSONObject jsonProgrmData = progrmPolicyData(agentFirewallVo);
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


		logger.info("//===================================");
		logger.debug("//getAgent result data is : {}", output);
		logger.info("//===================================");

		return output;
	}



	public JSONObject progrmPolicyData(GetAgentUpdtVo getProgrmVo) {

		GetAgentUpdtVo rDataVo = new GetAgentUpdtVo();
		logger.debug("//====get Vo param is : {}", getProgrmVo.toString());

		JSONObject jsonObject = new JSONObject();

		GetAgentUpdtVo agentoldseqVo = getAgentUpdtMapper.getAgentOldSeq(getProgrmVo);

		if (agentoldseqVo != null) {
			logger.debug("//====getAgentOldSeq is : {}", getProgrmVo.toString());
			rDataVo.setOrg_seq(agentoldseqVo.getOrg_seq());
			rDataVo.setPcm_uuid(agentoldseqVo.getPcm_uuid());
			rDataVo.setUpdt_ap_seq(agentoldseqVo.getUpdt_ap_seq());

		} else {
			logger.info("getAgentOldSeq is no data");
			rDataVo.setOrg_seq(getProgrmVo.getOrg_seq());
			rDataVo.setPcm_uuid(getProgrmVo.getPcm_uuid());
		}

		logger.debug("//====rDataVorDataVorDataVoget Vo param is : {}", rDataVo.toString());

		// 에이전트가 작업 수행결과를 업데이트 하는 일 > rDataVo
		int retInsertSelectVal = getAgentUpdtMapper.setInsertSelect(rDataVo);

		logger.info("//===============================");
		logger.debug("//====retInsertSelectVal is : {}", retInsertSelectVal);
		logger.info("//===============================");

		// 디비에서 정책 가져오기 - 업그레이드시에 버전 정보를 가져오기
		List<GetAgentUpdtVo> progrmPolicyData = getAgentUpdtMapper.getListUpdtsPolicy(rDataVo);
		logger.debug("//+progrmPolicyData.size() ==={}", progrmPolicyData.size());
		if (progrmPolicyData.size() == 0) {
			jsonObject.put("nodata", "nodata");
			return jsonObject;
		}

		rDataVo.setPpm_seq(progrmPolicyData.get(0).getPpm_seq());
		rDataVo.setNew_pa_seq(Integer.parseInt(progrmPolicyData.get(0).getPa_seq()));

		List<GetAgentUpdtVo> outputDatga = null;

		if (progrmPolicyData.size() == 1) {
			rDataVo.setOld_pa_seq(0);
			// 최초 실행시
			outputDatga = getAgentUpdtMapper.getAgentInitWorkData(rDataVo);

		} else {
			rDataVo.setOld_pa_seq(Integer.parseInt(progrmPolicyData.get(1).getPa_seq()));
			outputDatga = getAgentUpdtMapper.getAgentWorkData(rDataVo);
		}

		String arrAgentProgrmY = "", arrAgentProgrmN = "", arrUpdtStatusUpdate = "";
		String arrUpdtUpgrade = "", arrUpdtInsert = "", arrUpdtUpgrade_ver = "";

		if (outputDatga.size() > 0) {

			int arrUpdtInsertCnt = 0;
			int arrUpdtUpgradeCnt = 0;
			for (int i = 0; i < outputDatga.size(); i++) {
				logger.debug("1========={}", outputDatga.get(i).getGubun());

				if ("INSERT".contentEquals(outputDatga.get(i).getGubun())) {
					arrUpdtInsert += outputDatga.get(i).getPcm_name() + ",";
					arrUpdtInsertCnt++;
				}

				if ("UPGRADE".contentEquals(outputDatga.get(i).getGubun())) {
					arrUpdtUpgrade += outputDatga.get(i).getPcm_name() + "_"
							+ outputDatga.get(i).getDeb_new_version() + ",";
					arrUpdtUpgradeCnt++;
				}

				if ("INS".contentEquals(outputDatga.get(i).getGubun())) {
					arrAgentProgrmY += outputDatga.get(i).getPcm_name() + ",";

				}

				if ("DEL".contentEquals(outputDatga.get(i).getGubun())) {
					logger.debug("outputDatga >> {}", outputDatga.get(i).toString());

					arrAgentProgrmN += outputDatga.get(i).getPcm_name() + ",";
				}

				if (i == outputDatga.size() - 1) {
					arrUpdtStatusUpdate += outputDatga.get(i).getPcm_seq();
				} else {
					arrUpdtStatusUpdate += outputDatga.get(i).getPcm_seq() + ",";
				}

			}

			if (!arrUpdtInsert.equals("")) {
				jsonObject.put("INSERT", arrUpdtInsert);
			}
			if (!arrUpdtUpgrade.equals("")) {
				jsonObject.put("UPGRADE", arrUpdtUpgrade);
			}
			if (!arrAgentProgrmY.equals("")) {
				jsonObject.put("INS", arrAgentProgrmY);
			}
			if (!arrAgentProgrmN.equals("")) {
				jsonObject.put("DEL", arrAgentProgrmN);

			}

		}


		logger.info("//===============================");
		logger.debug("//==INSERT output data is : {}", arrUpdtInsert);
		logger.debug("//==UPGRADE output data is : {}", arrUpdtUpgrade);
		logger.debug("//==INS output data is : {}", arrAgentProgrmY);
		logger.debug("//==DEL output data is : {}", arrAgentProgrmN);
		logger.debug("//==jsonObject  data is : {}", jsonObject);
		logger.info("//===============================");


		return jsonObject;
	}


	/*
	 * 부서 UUID로 부서 seq 가져오기
	 * 
	 * @param uuid
	 * 
	 * @return 부서seq
	 */
	public Long pcUUID(String uuid) {
		GetAgentJobVo agentVo = new GetAgentJobVo();
		agentVo.setPc_uuid(uuid);
		agentVo = agentJobMapper.getAgentJobPcUUID(agentVo);

		Long segSeq = 0L;
		if (agentVo != null) {
			segSeq = agentVo.getSeq();
		}
		return segSeq;
	}

}
