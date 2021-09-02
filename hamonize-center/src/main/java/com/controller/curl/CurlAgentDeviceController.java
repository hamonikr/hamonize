package com.controller.curl;

import java.util.List;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.mapper.IGetAgentDeviceMapper;
import com.mapper.IGetAgentJobMapper;
import com.model.GetAgentDeviceVo;
import com.model.GetAgentJobVo;
import com.util.StringUtil;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@RestController
@RequestMapping("/getAgent")
public class CurlAgentDeviceController {

	@Autowired
	private IGetAgentJobMapper agentJobMapper;

	@Autowired
	private IGetAgentDeviceMapper getAgentDeviceMapper;

	private Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 에이전트에 디바이스 정책 보내는 부분
	 * 
	 * @param pcUuid
	 * @param wget
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/device", method = RequestMethod.GET)
	public String getAgentJob(@RequestParam(value = "name", required = false) String pcUuid,
			@RequestParam(value = "wget", required = false) String wget) throws Exception {

		// 출력 변수
		String output = "";
		logger.debug("=== {}", pcUuid);
		logger.debug("=== {}", wget);

		pcUuid = pcUuid.trim();

		// uuid로 부서정보 가져오기
		int segSeq = pcUUID(pcUuid);
		if (segSeq == 0) {
			return "nodata";
		}

		GetAgentDeviceVo agentFirewallVo = new GetAgentDeviceVo();
		agentFirewallVo.setOrg_seq(segSeq);
		agentFirewallVo.setPcm_uuid(pcUuid);

		int chkProgrmPolicy = getAgentDeviceMapper.getAgentWorkYn(agentFirewallVo);

		logger.info("//---------------------------------------------");
		logger.debug("device agent work yn === {}", chkProgrmPolicy);
		logger.info("---------------------------------------------//");


		if (chkProgrmPolicy == 0) {
			JSONObject jsonProgrmData = progrmPolicyData(agentFirewallVo);
			if (jsonProgrmData.size() == 0) {
				output = "nodata";
			} else {
				logger.debug("jsonProgrmData.get(\"NODATA\")====== {}",
						jsonProgrmData.get("nodata"));

				if (jsonProgrmData.get("nodata") != null) {
					output = jsonProgrmData.get("nodata").toString();
				} else {
					output = jsonProgrmData.toJSONString();
				}
			}
		} else {
			output = "nodata";
		}

		logger.info("---------------------------------------------");
		logger.debug(" output result data is : {}", output);
		logger.info("---------------------------------------------");


		return output;
	}



	public JSONObject progrmPolicyData(GetAgentDeviceVo getProgrmVo) {

		JSONObject jsonObject = new JSONObject();

		GetAgentDeviceVo agentoldseqVo = getAgentDeviceMapper.getAgentOldSeq(getProgrmVo);
		if (agentoldseqVo != null) {
			logger.debug("//====getAgentOldSeq is : {}", getProgrmVo.toString());

			getProgrmVo.setOrg_seq(agentoldseqVo.getOrg_seq());
			getProgrmVo.setPcm_uuid(agentoldseqVo.getPcm_uuid());
			getProgrmVo.setDvc_seq(agentoldseqVo.getDvc_seq());

		} else {
			logger.debug("getAgentOldSeq is no data");
			getProgrmVo.setOrg_seq(getProgrmVo.getOrg_seq());
			getProgrmVo.setPcm_uuid(getProgrmVo.getPcm_uuid());
		}


		int retInsertSelectVal = getAgentDeviceMapper.setInsertSelect(getProgrmVo);

		logger.debug("//====retInsertSelectVal is : {}", retInsertSelectVal);

		// 정책 가져오기
		List<GetAgentDeviceVo> progrmPolicyData =
				getAgentDeviceMapper.getListDevicePolicy(getProgrmVo);

		logger.debug("//+progrmPolicyData.size() === {}", progrmPolicyData.size());

		// 디비에서 가져온 데이터가 없으면 nodata
		if (progrmPolicyData.size() == 0) {
			jsonObject.put("nodata", "nodata");
			return jsonObject;
		}


		getProgrmVo.setPpm_seq(progrmPolicyData.get(0).getPpm_seq());
		getProgrmVo.setNew_pa_seq(Integer.parseInt(progrmPolicyData.get(0).getPa_seq()));
		List<GetAgentDeviceVo> outputDatga = null;

		if (progrmPolicyData.size() == 1) {
			// 정책 결과가 한개만 있는 경우
			getProgrmVo.setOld_pa_seq(0);
			outputDatga = getAgentDeviceMapper.getAgentInitWorkData(getProgrmVo);
		} else {
			// 정책 결과가 한개이상인 경우
			getProgrmVo.setOld_pa_seq(Integer.parseInt(progrmPolicyData.get(1).getPa_seq()));
			outputDatga = getAgentDeviceMapper.getAgentWorkData(getProgrmVo);
		}


		String arrAgentProgrmY = "", arrAgentProgrmN = "";

		if (outputDatga.size() > 0) {
			for (int i = 0; i < outputDatga.size(); i++) {
				logger.debug("outputDatga.get(i).getGubun() >>> {}", outputDatga.get(i).getGubun());
				if ("INS".contentEquals(outputDatga.get(i).getGubun())) {


					if (outputDatga.size() - 1 == i) {
						arrAgentProgrmY += outputDatga.get(i).getPcm_name() + "-"
								+ StringUtil.nullConvert(outputDatga.get(i).getDevice_code());
					} else {
						arrAgentProgrmY += outputDatga.get(i).getPcm_name() + "-"
								+ StringUtil.nullConvert(outputDatga.get(i).getDevice_code()) + ",";
					}
				}

				if ("DEL".contentEquals(outputDatga.get(i).getGubun())) {
					if (outputDatga.size() - 1 == i) {
						arrAgentProgrmN += outputDatga.get(i).getPcm_name() + "-"
								+ StringUtil.nullConvert(outputDatga.get(i).getDevice_code());
					} else {
						arrAgentProgrmN += outputDatga.get(i).getPcm_name() + "-"
								+ StringUtil.nullConvert(outputDatga.get(i).getDevice_code()) + ",";
					}
				}
			}

			if (!arrAgentProgrmY.equals("")) {
				jsonObject.put("INS", arrAgentProgrmY);
			}
			if (!arrAgentProgrmN.equals("")) {
				jsonObject.put("DEL", arrAgentProgrmN);
			}

		}

		logger.info("//===============================");
		logger.debug("//==INS output data is : {}", arrAgentProgrmY);
		logger.debug("//==DEL output data is : {}", arrAgentProgrmN);
		logger.debug("//==jsonObject  data is : {}", jsonObject.size());
		logger.info("//===============================");

		return jsonObject;
	}


	/*
	 * 부서 UUID로 부서 seq 가져오기
	 * 
	 * @param sgbUuid
	 * 
	 * @return 부서seq
	 */
	public int pcUUID(String pcUuid) {
		GetAgentJobVo agentVo = new GetAgentJobVo();
		agentVo.setPc_uuid(pcUuid);
		agentVo = agentJobMapper.getAgentJobPcUUID(agentVo);
		int segSeq = 0;
		if (agentVo != null) {
			segSeq = agentVo.getSeq();
		}
		return segSeq;
	}

}
