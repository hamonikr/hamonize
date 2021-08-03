package com.controller.curl;

import java.util.List;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.mapper.IGetAgentFirewallMapper;
import com.mapper.IGetAgentJobMapper;
import com.model.GetAgentFirewallVo;
import com.model.GetAgentJobVo;

@RestController
@RequestMapping("/getAgent")
public class CurlAgentFirewallController {

	@Autowired
	private IGetAgentJobMapper agentJobMapper;

	@Autowired
	private IGetAgentFirewallMapper getAgentFirewallMapper;

	/**
	 * 에이전트에 방화벽정책 보내는 부분
	 * @param uuid
	 * @param wget
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/firewall")
	public String getAgentJob(@RequestParam(value = "name", required = false) String uuid,
			@RequestParam(value = "wget", required = false) String wget) throws Exception {

		// 출력 변수
		String output = "";
		System.out.println("===" + uuid + "==" + wget);
		uuid = uuid.trim();

		// uuid로 부서정보 가져오기
		int segSeq = pcUUID(uuid);
		if( segSeq == 0 ) {
			return  "nodata";
		}
		
		GetAgentFirewallVo agentFirewallVo = new GetAgentFirewallVo();
		agentFirewallVo.setOrg_seq(segSeq);
		agentFirewallVo.setPcm_uuid(uuid);

		int chkProgrmPolicy = getAgentFirewallMapper.getAgentWorkYn(agentFirewallVo);
		System.out.println("//===================================");
		System.out.println("//work yn === " + chkProgrmPolicy);
		System.out.println("//===================================");

		if ( chkProgrmPolicy == 0 ) {
			JSONObject jsonProgrmData = progrmPolicyData(agentFirewallVo);
			if( jsonProgrmData.size() == 0 ) {
				output = "nodata";
			}else {
				System.out.println("jsonProgrmData.get(\"NODATA\")======"+ jsonProgrmData.get("nodata"));
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

	
	
	public JSONObject progrmPolicyData(GetAgentFirewallVo getProgrmVo) {

		JSONObject jsonObject = new JSONObject();
		
		GetAgentFirewallVo agentoldseqVo = getAgentFirewallMapper.getAgentOldSeq(getProgrmVo);
		if( agentoldseqVo != null ) {
			System.out.println("//====getAgentOldSeq is : "+ agentoldseqVo.toString());
			getProgrmVo.setOrg_seq(agentoldseqVo.getOrg_seq());
			getProgrmVo.setPcm_uuid(agentoldseqVo.getPcm_uuid());
			getProgrmVo.setFa_seq(agentoldseqVo.getFa_seq());
			
		}else {
			System.out.println("getAgentOldSeq is no data");
			getProgrmVo.setOrg_seq(getProgrmVo.getOrg_seq());
			getProgrmVo.setPcm_uuid(getProgrmVo.getPcm_uuid());
		}		
		
		int retInsertSelectVal = getAgentFirewallMapper.setInsertSelect(getProgrmVo);
		
		System.out.println("//===============================");
		System.out.println("//====retInsertSelectVal is : "+ retInsertSelectVal);
		System.out.println("//===============================");

		// 방화벽 정책 가져오기 
		List<GetAgentFirewallVo> progrmPolicyData = getAgentFirewallMapper.getListFirewallPolicy(getProgrmVo);
		System.out.println("//+progrmPolicyData.size() ==="+ progrmPolicyData.size() );
		if( progrmPolicyData.size() == 0  ) {
			jsonObject.put("nodata", "nodata");
			return jsonObject;
		}

		getProgrmVo.setPpm_seq(progrmPolicyData.get(0).getPpm_seq());
		getProgrmVo.setNew_pa_seq(Integer.parseInt(progrmPolicyData.get(0).getPa_seq()));
		List<GetAgentFirewallVo> outputDatga = null;
		
		if( progrmPolicyData.size() == 1) {
			getProgrmVo.setOld_pa_seq(0);
			
			outputDatga = getAgentFirewallMapper.getAgentInitWorkData(getProgrmVo);
			
		}else {
			getProgrmVo.setOld_pa_seq(Integer.parseInt(progrmPolicyData.get(1).getPa_seq()));
			outputDatga = getAgentFirewallMapper.getAgentWorkData(getProgrmVo);
		}

		String arrAgentProgrmY = "", arrAgentProgrmN = "";
  
		if (outputDatga.size() > 0) {
			for (int i = 0; i < outputDatga.size(); i++) {

				if ("INS".contentEquals(outputDatga.get(i).getGubun())) {
					if (outputDatga.size() - 1 == i) {
						arrAgentProgrmY += outputDatga.get(i).getSm_port();
					} else {
						arrAgentProgrmY += outputDatga.get(i).getSm_port() + ",";
					}
				}

				if ("DEL".contentEquals(outputDatga.get(i).getGubun())) {
					if (outputDatga.size() - 1 == i) {
						arrAgentProgrmN += outputDatga.get(i).getSm_port();
					} else {
						arrAgentProgrmN += outputDatga.get(i).getSm_port()+ ",";
					}
				}
			}

			if (arrAgentProgrmY != "") {
				jsonObject.put("INS", arrAgentProgrmY);
			}
			if (arrAgentProgrmN != "") {
				jsonObject.put("DEL", arrAgentProgrmN);
			}

		}

		System.out.println("//===============================");
		System.out.println("//==INS output data is : " + arrAgentProgrmY);
		System.out.println("//==DEL output data is : " + arrAgentProgrmN);
		System.out.println("//==jsonObject  data is : " + jsonObject);
		System.out.println("//===============================");
		 
		
		return jsonObject;
	}


	/*
	 * 부서 UUID로 부서 seq 가져오기
	 * 
	 * @param uuid
	 * @return 부서seq
	 */
	public int pcUUID(String uuid) {
		GetAgentJobVo agentVo = new GetAgentJobVo();
		agentVo.setPc_uuid(uuid);
		agentVo = agentJobMapper.getAgentJobPcUUID(agentVo);
		
		int segSeq = 0;
		
		if(agentVo != null ) {
			segSeq = agentVo.getSeq();	
			System.out.println("pcUUID > segSeq :"+segSeq);
		}
		return segSeq;
	}

}
