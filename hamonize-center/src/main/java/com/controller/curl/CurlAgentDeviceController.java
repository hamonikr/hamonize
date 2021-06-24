package com.controller.curl;

import java.util.List;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.mapper.IGetAgentDeviceMapper;
import com.mapper.IGetAgentFirewallMapper;
import com.mapper.IGetAgentJobMapper;
import com.model.GetAgentDeviceVo;
import com.model.GetAgentFirewallVo;
import com.model.GetAgentJobVo;
import com.util.StringUtil;

@RestController
@RequestMapping("/getAgent")
public class CurlAgentDeviceController {

	@Autowired
	private IGetAgentJobMapper agentJobMapper;

	@Autowired
	private IGetAgentDeviceMapper getAgentDeviceMapper;

	

	@RequestMapping("/device")
	public String getAgentJob(@RequestParam(value = "name", required = false) String sgbUuid,
			@RequestParam(value = "wget", required = false) String sgbWget) throws Exception {

		// 출력 변수
		String output = "";
		System.out.println("===" + sgbUuid + "==" + sgbWget);
		sgbUuid = sgbUuid.trim();

		// uuid로 부문정보 가져오기
		int segSeq = sgbUUID(sgbUuid);
		if( segSeq == 0 ) {
			return  "nodata";
		}
		
		GetAgentDeviceVo agentFirewallVo = new GetAgentDeviceVo();
		agentFirewallVo.setOrg_seq(segSeq);
		agentFirewallVo.setPcm_uuid(sgbUuid);

		int chkProgrmPolicy = getAgentDeviceMapper.getAgentWorkYn(agentFirewallVo);
		System.out.println("//===================================");
		System.out.println("//device agent work yn === " + chkProgrmPolicy);
		System.out.println("//===================================");

		
		
		// chkProgrmPolicy는 정책에 변화가있는지 여부를 체크 agent가 일을 안했으면 0 변경된 정책에 의해 일을했으면 그 변경한 갯수가 출력 >>즉 0이면 새로운 정책을 내
		if ( chkProgrmPolicy == 0 ) {
			// 여기서 디비 데이터가져옴 progrmPolicyData()
			JSONObject jsonProgrmData = progrmPolicyData(agentFirewallVo);
			if( jsonProgrmData.size() == 0 ) {
				output = "nodata";
			}else {
				//output = jsonProgrmData.toJSONString();
				// 길이가 0이 아니지만 nodata 키가 value가 있다면 출력  
				System.out.println("jsonProgrmData.get(\"NODATA\")======"+ jsonProgrmData.get("nodata")+"\n");
				if( jsonProgrmData.get("nodata") != null ) {
					// 길이가 0이 아니지만 nodata 키가 value가 있다면 string 타입으로 바꿔서 output에 담
					System.out.println("aaaa");
					output =  jsonProgrmData.get("nodata").toString();	
				}else {
					// nodata가 아니라 실제 값이 있고 데이터를 가져오면 스트링으로 변환해서 output에 넣음
					System.out.println("bbbb");
					output = jsonProgrmData.toJSONString();
				}
			}
		} else {
			// 정책에 변화가 없다면 그냥 nodata 를 출력
			System.out.println("ddd");
			output = "nodata";
		}
		

		System.out.println("//===================================");
		System.out.println("// output result data is : " + output);
		System.out.println("//===================================");
		
		return output;
	}

	
	
	public JSONObject progrmPolicyData(GetAgentDeviceVo getProgrmVo) {

		JSONObject jsonObject = new JSONObject();

		GetAgentDeviceVo agentoldseqVo = getAgentDeviceMapper.getAgentOldSeq(getProgrmVo);
		if( agentoldseqVo != null ) {
			System.out.println("//====getAgentOldSeq is : "+ getProgrmVo.toString());
			getProgrmVo.setOrg_seq(agentoldseqVo.getOrg_seq());
			getProgrmVo.setPcm_uuid(agentoldseqVo.getPcm_uuid());
			getProgrmVo.setDvc_seq(agentoldseqVo.getDvc_seq());
			
		}else {
			System.out.println("getAgentOldSeq is no data");
			getProgrmVo.setOrg_seq(getProgrmVo.getOrg_seq());
			getProgrmVo.setPcm_uuid(getProgrmVo.getPcm_uuid());
		}
		
		
		int retInsertSelectVal = getAgentDeviceMapper.setInsertSelect(getProgrmVo);
		
		System.out.println("//===============================");
		System.out.println("//====retInsertSelectVal is : "+ retInsertSelectVal);
		System.out.println("//===============================");

		// 정책 가져오기 
		List<GetAgentDeviceVo> progrmPolicyData = getAgentDeviceMapper.getListDevicePolicy(getProgrmVo);
		
		System.out.println("//+progrmPolicyData.size() ==="+ progrmPolicyData.size() );
		// 디비에서 가져온 데이터가 없으면 nodata
		
		if( progrmPolicyData.size() == 0  ) {
			jsonObject.put("nodata", "nodata");
			return jsonObject;
		}
		

		getProgrmVo.setPpm_seq(progrmPolicyData.get(0).getPpm_seq());
		getProgrmVo.setNew_pa_seq(Integer.parseInt(progrmPolicyData.get(0).getPa_seq()));
		List<GetAgentDeviceVo> outputDatga = null;
		
		if( progrmPolicyData.size() == 1) {
			// 정책 결과가 한개만 있는 경우
			getProgrmVo.setOld_pa_seq(0);
			outputDatga = getAgentDeviceMapper.getAgentInitWorkData(getProgrmVo);
		}else {
			// 정책 결과가 한개이상인 경우
			getProgrmVo.setOld_pa_seq(Integer.parseInt(progrmPolicyData.get(1).getPa_seq()));
			outputDatga = getAgentDeviceMapper.getAgentWorkData(getProgrmVo);
		}


		String arrAgentProgrmY = "", arrAgentProgrmN = "";

		if (outputDatga.size() > 0) {
			for (int i = 0; i < outputDatga.size(); i++) {
				System.out.println("outputDatga.get(i).getGubun() >>> " + outputDatga.get(i).getGubun());
				if ("INS".contentEquals(outputDatga.get(i).getGubun())) {
					
					
					if (outputDatga.size() - 1 == i) {
						arrAgentProgrmY += outputDatga.get(i).getPcm_name() +"-"+StringUtil.nullConvert(outputDatga.get(i).getDevice_code());
					} else {
						arrAgentProgrmY += outputDatga.get(i).getPcm_name() +"-"+StringUtil.nullConvert(outputDatga.get(i).getDevice_code())+ ",";
					}
				}

				if ("DEL".contentEquals(outputDatga.get(i).getGubun())) {
					if (outputDatga.size() - 1 == i) {
						arrAgentProgrmN += outputDatga.get(i).getPcm_name()+"-"+StringUtil.nullConvert(outputDatga.get(i).getDevice_code());
					} else {
						arrAgentProgrmN += outputDatga.get(i).getPcm_name() +"-"+StringUtil.nullConvert(outputDatga.get(i).getDevice_code())+ ",";
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
		System.out.println("//==jsonObject  data is : " + jsonObject.size());
		System.out.println("//===============================");
		 
		return jsonObject;
	}


	/*
	 * 부서 UUID로 부문 seq 가져오기
	 * 
	 * @param sgbUuid
	 * @return 부문seq
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
