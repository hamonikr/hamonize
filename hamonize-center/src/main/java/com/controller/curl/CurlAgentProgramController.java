package com.controller.curl;

import java.util.List;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.mapper.IGetAgentJobMapper;
import com.mapper.IGetAgentProgrmMapper;
import com.model.GetAgentJobVo;
import com.model.GetAgentProgrmVo;

@RestController
@RequestMapping("/getAgent")
public class CurlAgentProgramController {

	@Autowired
	private IGetAgentJobMapper agentJobMapper;

	@Autowired
	private IGetAgentProgrmMapper getAgentProgrmMapper;

	@RequestMapping("/progrm")
	public String getAgentJob(@RequestParam(value = "name", required = false) String sgbUuid,
			@RequestParam(value = "wget", required = false) String sgbWget) throws Exception {

		// 출력 변수
		String output = "";
		sgbUuid = sgbUuid.trim();

		// uuid로 부문정보 가져오기
		int segSeq = sgbUUID(sgbUuid);
		if( segSeq == 0 ) {
			return  "nodata";
		}
		
		GetAgentProgrmVo getProgrmVo = new GetAgentProgrmVo();
		getProgrmVo.setOrg_seq(segSeq);
		getProgrmVo.setPcm_uuid(sgbUuid);

		int chkProgrmPolicy = getAgentProgrmMapper.getAgentWorkYn(getProgrmVo);
		boolean isAgentProgrmAction = false;
		System.out.println("//===================================");
		System.out.println("//work yn === " + chkProgrmPolicy);
		System.out.println("//===================================");

		if ( chkProgrmPolicy == 0 ) {
			isAgentProgrmAction = true;
			JSONObject jsonProgrmData = progrmPolicyData(getProgrmVo);
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
		System.out.println("//CurlAgentProgramController result data is : " + output);
		System.out.println("//===================================");
		
		return output;
	}

	
	
	public JSONObject progrmPolicyData(GetAgentProgrmVo getProgrmVo) {
		GetAgentProgrmVo rDataVo = new GetAgentProgrmVo();
		JSONObject jsonObject = new JSONObject();

		GetAgentProgrmVo agentoldseqVo = getAgentProgrmMapper.getAgentOldSeq(getProgrmVo);
		
		if( agentoldseqVo != null ) {
			System.out.println("//====getAgentOldSeq is : "+ getProgrmVo.toString());
			getProgrmVo.setOrg_seq(agentoldseqVo.getOrg_seq());
			getProgrmVo.setPcm_uuid(agentoldseqVo.getPcm_uuid());
			getProgrmVo.setPa_seq(agentoldseqVo.getPa_seq());
			
		}else {
			System.out.println("getAgentOldSeq is no data");
			getProgrmVo.setOrg_seq(getProgrmVo.getOrg_seq());
			getProgrmVo.setPcm_uuid(getProgrmVo.getPcm_uuid());
		}		
		
		
		int retInsertSelectVal = getAgentProgrmMapper.setInsertSelect(getProgrmVo);
		
		

		// 프로그램 정책 가져오기
		List<GetAgentProgrmVo> progrmPolicyData = getAgentProgrmMapper.getListProgrmPolicy(getProgrmVo);
		System.out.println("//+progrmPolicyData.size() ==="+ progrmPolicyData.size() );
		if( progrmPolicyData.size() == 0  ) {
			jsonObject.put("nodata", "nodata");
			return jsonObject;
		}
		
		getProgrmVo.setPpm_seq(progrmPolicyData.get(0).getPpm_seq() );
		getProgrmVo.setNew_pa_seq(Integer.parseInt(progrmPolicyData.get(0).getPa_seq()));
		if( progrmPolicyData.size() == 1) {
			getProgrmVo.setOld_pa_seq(0);
		}else {
			getProgrmVo.setOld_pa_seq(Integer.parseInt(progrmPolicyData.get(1).getPa_seq()));
		}
		
		
		List<GetAgentProgrmVo> outputDatga =getAgentProgrmMapper.getAgentWorkData(getProgrmVo);
		
		
		/*
		 * for( GetAgentProgrmVo set : outputDatga ) { System.out.println("----> "+
		 * set.getGubun() +"=="+ set.getPcm_seq()+"=="+ set.getOrg_seq() +"=="+
		 * set.getPa_seq() +"=="+ set.getPcm_uuid() +"=="+ set.getPcm_name() +"=="+
		 * set.getInsert_dt() +"=="+ set.getOld_pa_seq() ); }
		 */
		
		String arrAgentProgrmY = "", arrAgentProgrmN = "";
		
		if (outputDatga.size() > 0) {
			for (int i = 0; i < outputDatga.size(); i++) {
				
				if( "INS".contentEquals(outputDatga.get(i).getGubun()) ) {
					if ( outputDatga.size() - 1 ==  i ) {
						arrAgentProgrmY += outputDatga.get(i).getPcm_name();
					}else {
						arrAgentProgrmY += outputDatga.get(i).getPcm_name() + ",";
					}	
				}

				if( "DEL".contentEquals(outputDatga.get(i).getGubun()) ) {
					if ( outputDatga.size() - 1 ==  i ) {
						arrAgentProgrmN += outputDatga.get(i).getPcm_name();
					}else {
						arrAgentProgrmN += outputDatga.get(i).getPcm_name() + ",";
					}	
				}
			}
			

			
			
			if( arrAgentProgrmY != "" ) {
				jsonObject.put("INS", arrAgentProgrmY);	
			}
			if( arrAgentProgrmN != "" ) {
				jsonObject.put("DEL", arrAgentProgrmN);	
			}
			
		}
		
		System.out.println("//===============================");
		System.out.println("//==INS output data is : "+ arrAgentProgrmY);
		System.out.println("//==DEL output data is : "+ arrAgentProgrmN);
		System.out.println("//==jsonObject  data is : "+ jsonObject);
		System.out.println("//===============================");
		
		return jsonObject;
	}


	/**
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
