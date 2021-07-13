package com.controller.curl.agentjob;

import java.io.BufferedReader;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.mapper.IActAgentDeviceMapper;
import com.mapper.IActAgentFirewallMapper;
import com.mapper.IActAgentNxssMapper;
import com.mapper.IActAgentProgrmMapper;
import com.mapper.IGetAgentJobMapper;
import com.mapper.IGetAgentRecoveryMapper;
import com.model.ActAgentBackupRecoveryVo;
import com.model.ActAgentDeviceVo;
import com.model.ActAgentFirewallVo;
import com.model.ActAgentNxssVo;
import com.model.ActAgentProgrmVo;
import com.model.GetAgentJobVo;

@RestController
@RequestMapping("/act")
public class ActAgentFirewallController {

	@Autowired
	private IGetAgentJobMapper agentJobMapper;

	@Autowired
	private IActAgentFirewallMapper actAgentFirewallMapper ;

	@Autowired
	private IActAgentDeviceMapper actAgentDeviceMapper ;

	@Autowired
	private IActAgentProgrmMapper actAgentProgrmMapper;

	@Autowired
	private IActAgentNxssMapper actAgentNxssMapper;
	
	
	@Autowired
	private IGetAgentRecoveryMapper getAgentRecoveryMapper;
	
	
	@RequestMapping("/firewallAct")
	public String firewallAct(HttpServletRequest request ) throws Exception {
		System.out.println("firewallAct===============================[start]");
		// 출력 변수
		String output = "";

		StringBuffer json = new StringBuffer();
	    String line = null;
	 
	    try {
	        BufferedReader reader = request.getReader();
	        while((line = reader.readLine()) != null) {
	            json.append(line);
	        }
	 
	    }catch(Exception e) {
	        System.out.println("Error reading JSON string: " + e.toString());
	    }
	    
	    System.out.println("json===> "+ json);
	    
	    JSONParser jsonParser = new JSONParser();
        JSONObject jsonObj = (JSONObject) jsonParser.parse( json.toString());
        JSONArray hmdArray = (JSONArray) jsonObj.get("events");

        ActAgentFirewallVo inputVo = new ActAgentFirewallVo();
        for(int i=0 ; i<hmdArray.size() ; i++){
            JSONObject tempObj = (JSONObject) hmdArray.get(i);
        	
            inputVo.setDatetime(tempObj.get("datetime").toString());
            inputVo.setUuid(tempObj.get("uuid").toString().trim());
            inputVo.setHostname(tempObj.get("hostname").toString());
            inputVo.setStatus(tempObj.get("status").toString());
            inputVo.setStatus_yn(tempObj.get("status_yn").toString());
            inputVo.setRetport(tempObj.get("retport").toString());
            
        }
		
		System.out.println("\n에이전트에서 받은 값 inputVo : "+ inputVo.toString());

        int uuid = pcUUID(inputVo.getUuid());
        inputVo.setOrgseq(uuid);
        
        int retVal = actAgentFirewallMapper.insertActAgentFirewall(inputVo);
        System.out.println("retVal ==== "+ retVal);
        
		System.out.println("//===================================");
		System.out.println("//result data is : " + inputVo);
		System.out.println("firewallAct===============================[END]");
		System.out.println("//===================================");
		
		return output;
	}

	
	
	@RequestMapping("/deviceAct")
	public String deviceAct(HttpServletRequest request ) throws Exception {
		System.out.println("deviceAct===============================[start]");
		// 출력 변수
		String output = "";

		StringBuffer json = new StringBuffer();
	    String line = null;
	 
	    try {
	        BufferedReader reader = request.getReader();
	        while((line = reader.readLine()) != null) {
	            json.append(line);
	        }
	 
	    }catch(Exception e) {
	        System.out.println("Error reading JSON string: " + e.toString());
	    }
	    
	    System.out.println("json===> "+ json);
	    
	    JSONParser jsonParser = new JSONParser();
        JSONObject jsonObj = (JSONObject) jsonParser.parse( json.toString());
        JSONArray hmdArray = (JSONArray) jsonObj.get("events");

        ActAgentDeviceVo inputVo = new ActAgentDeviceVo();
        for(int i=0 ; i<hmdArray.size() ; i++){
            JSONObject tempObj = (JSONObject) hmdArray.get(i);
        	
            inputVo.setUuid(tempObj.get("uuid").toString().trim());
            inputVo.setHostname(tempObj.get("hostname").toString());
            inputVo.setStatus_yn(tempObj.get("statusyn").toString());
            inputVo.setProduct(tempObj.get("procut").toString());
            inputVo.setVendorCode(tempObj.get("vendorCode").toString());
            inputVo.setProductCode(tempObj.get("productCode").toString());
            
        }
        
        int uuid = pcUUID(inputVo.getUuid());
        inputVo.setOrgseq(uuid);
        
        int retVal = actAgentDeviceMapper.insertActAgentDevice(inputVo);
        System.out.println("retVal ==== "+ retVal);
        
		System.out.println("//===================================");
		System.out.println("//result data is : " + inputVo);
		System.out.println("deviceAct===============================[END]");
		System.out.println("//===================================");
		
		return output;
	}
	

	
	@RequestMapping("/progrmAct")
	public String progrmAct(HttpServletRequest request ) throws Exception {
		System.out.println("progrmAct===============================[start]");
		// 출력 변수
		String output = "";
		int uuid = 0;
		
		StringBuffer json = new StringBuffer();
	    String line = null;
	 
	    try {
			System.out.println("\naaaaa\n");
	        BufferedReader reader = request.getReader();
	        while((line = reader.readLine()) != null) {
	            json.append(line);
				System.out.println("\nbbbbb\n");

	        }
	 
	    }catch(Exception e) {
			System.out.println("\ncccc\n");

	        System.out.println("Error reading JSON string: " + e.toString());
	    }
	    
	    
	    JSONParser Parser = new JSONParser();
	    JSONObject jsonObj = (JSONObject) Parser.parse(json.toString());
	    
	    
	    /** ======================================
	     * insresert : 프로그램 정책 적용 (ins:적용, del:해제)
	     *=======================================*/
	    
	    JSONArray insArray = (JSONArray) jsonObj.get("insresert");
	    ActAgentProgrmVo[] inputVo = new ActAgentProgrmVo[insArray.size()];
		System.out.println("\ndddd\n");

		if( insArray.size() != 0 ) {
		    for (int i = 0; i < insArray.size(); i++) {          
		    	JSONObject tempObj = (JSONObject) insArray.get(i);
		    	inputVo[i] = new ActAgentProgrmVo();
				inputVo[i].setUuid(tempObj.get("uuid").toString().trim());
				inputVo[i].setHostname(tempObj.get("hostname").toString());
				inputVo[i].setStatus(tempObj.get("status").toString());
				inputVo[i].setStatus_yn(tempObj.get("status_yn").toString());
				inputVo[i].setProgrmname(tempObj.get("progrmname").toString());
				inputVo[i].setDatetime(tempObj.get("datetime").toString());
				inputVo[i].setOrgseq(pcUUID(tempObj.get("uuid").toString().trim()));
		    }  
	    }
	    
	    System.out.println("에이전트 프로그램 정책 결과 : inputVo ======================================");
		for (int i = 0; i < inputVo.length; i++) {
			System.out.println("updtVo[i]=======" + inputVo[i].toString());
		}
	    
		Map<String, Object> insertDataMap = new HashMap<String, Object>();
		insertDataMap.put("list", inputVo);
		
		if (inputVo.length != 0) {
			actAgentProgrmMapper.insertActAgentProgrm(insertDataMap);
		}

		System.out.println("progrmAct===============================[END]");
		
		return output;
	}
	
	

	@RequestMapping("/nxssAct")
	public String nxssAct(HttpServletRequest request ) throws Exception {
		System.out.println("nxssAct===============================[start]");
		// 출력 변수
		String output = "";

		StringBuffer json = new StringBuffer();
	    String line = null;
	 
	    try {
	        BufferedReader reader = request.getReader();
	        while((line = reader.readLine()) != null) {
	            json.append(line);
	        }
	 
	    }catch(Exception e) {
	        System.out.println("Error reading JSON string: " + e.toString());
	    }
	    
	    System.out.println("json===> "+ json);
	    
	    JSONParser jsonParser = new JSONParser();
        JSONObject jsonObj = (JSONObject) jsonParser.parse( json.toString());
        JSONArray hmdArray = (JSONArray) jsonObj.get("events");

        ActAgentNxssVo inputVo = new ActAgentNxssVo();
        for(int i=0 ; i<hmdArray.size() ; i++){
            JSONObject tempObj = (JSONObject) hmdArray.get(i);
        	
            inputVo.setUuid(tempObj.get("uuid").toString().trim());
            inputVo.setHostname(tempObj.get("hostname").toString());
            inputVo.setFile_gubun(tempObj.get("file_gubun").toString());
            inputVo.setFileDate(tempObj.get("fileDate").toString());
            
        }
        
        int uuid = pcUUID(inputVo.getUuid());
        inputVo.setOrgseq(uuid);
        
        int retVal = actAgentNxssMapper.insertActAgentNxss(inputVo);
        System.out.println("retVal ==== "+ retVal);
        
		System.out.println("//===================================");
		System.out.println("//result data is : " + inputVo);
		System.out.println("nxssAct===============================[END]");
		System.out.println("//===================================");
		
		return output;
	}
	
	
	
	@RequestMapping("/stBackupRecoveryAct")
	public String stBackupRecoveryAct(HttpServletRequest request ) throws Exception {
		System.out.println("stBackupRecoveryAct===============================[start]");
		// 출력 변수
		String output = "";

		StringBuffer json = new StringBuffer();
	    String line = null;
	 
	    try {
	        BufferedReader reader = request.getReader();
	        while((line = reader.readLine()) != null) {
	            json.append(line);
	        }
	 
	    }catch(Exception e) {
	        System.out.println("Error reading JSON string: " + e.toString());
	    }
	    
	    System.out.println("json===> "+ json);
	    
	    JSONParser jsonParser = new JSONParser();
        JSONObject jsonObj = (JSONObject) jsonParser.parse( json.toString());
        JSONArray hmdArray = (JSONArray) jsonObj.get("events");

        ActAgentBackupRecoveryVo inputVo = new ActAgentBackupRecoveryVo();
        for(int i=0 ; i<hmdArray.size() ; i++){
            JSONObject tempObj = (JSONObject) hmdArray.get(i);
        	
            inputVo.setDatetime(tempObj.get("datetime").toString());
            inputVo.setUuid(tempObj.get("uuid").toString().trim());
            inputVo.setHostname(tempObj.get("hostname").toString());
            inputVo.setAction_status(tempObj.get("action_status").toString());
            inputVo.setResult(tempObj.get("result").toString());
            
        }
        
        int uuid = pcUUID(inputVo.getUuid());
        inputVo.setOrgseq(uuid);
        
        int retVal = getAgentRecoveryMapper.insertActAgentBackupRecovery(inputVo);
        System.out.println("retVal ==== "+ retVal);
        
		System.out.println("//===================================");
		System.out.println("//result data is : " + inputVo);
		System.out.println("stBackupRecoveryAct===============================[END]");
		System.out.println("//===================================");
		
		return output;
	}
	
	
	@RequestMapping("/checkRecovery")
	public String chkeckRecovery(@RequestParam(value = "name", required = false) String uuid,
			@RequestParam(value = "wget", required = false) String sgbWget) throws Exception {
		
		String output = "";
		ActAgentBackupRecoveryVo inputVo = new ActAgentBackupRecoveryVo();
		int segSeq = pcUUID(uuid.trim());
		
		inputVo.setUuid(uuid.trim());
		inputVo.setOrgseq(segSeq);
		System.out.println("segSeq=========>"+ segSeq);
		if( segSeq == 0 ) {
			return  output;
		}else {
			/**
			 * 복구 실행 후 기존 작업 내역 삭제 
			 */
			ActAgentBackupRecoveryVo retVo = getAgentRecoveryMapper.getDataActAgentBackupRecovery(inputVo);
			System.out.println("retVo========"+ retVo);
			System.out.println("retVo==result======"+ retVo.getResult());
//			output = retVo.getResult();
			
			if( "N".equals(retVo.getResult()) ) {
//				1. 업데이트 정책 삭제 tbl_updt_agent_job ::: org_seq, pcm_uuid 
//				2. 프로그램 정책 삭제 tbl_progrm_agent_job ::: org_seq, pcm_uuid
//				3. 방화벽 포트 정책 삭제 tbl_frwl_agent_job ::: org_seq, pcm_uuid
//				4. 디바이시 정책 삭제 tbl_device_agent_job ::: org_seq, pcm_uuid
//				5. 유해사이트 tbl_site_agent_job ::: pc_uuid
				try {
					int delPolicyVal = getAgentRecoveryMapper.deleteSgbPolicy(inputVo);
					System.out.println("delPolicyVal======> "+ delPolicyVal);
					getAgentRecoveryMapper.updateDataActAgentBackupRecovery(inputVo);
				} catch (Exception e) {
					// TODO: handle exception
					System.out.println("e==============="+e.getMessage());
					return "error";
				}
				
			}

			
			
			
			
		}
		
		return "aa";
	}
	
	
	/*
	 * 부서 UUID로 부문 seq 가져오기
	 * 
	 * @param pcuuid
	 * @return 부문seq
	 */
	public int pcUUID(String pcuuid) {
		GetAgentJobVo agentVo = new GetAgentJobVo();
		agentVo.setPc_uuid(pcuuid);
		agentVo = agentJobMapper.getAgentJobPcUUID(agentVo);
		int segSeq = 0;
		if(agentVo != null ) {
			segSeq = agentVo.getSeq();	
		}
		return segSeq;
	}

}





