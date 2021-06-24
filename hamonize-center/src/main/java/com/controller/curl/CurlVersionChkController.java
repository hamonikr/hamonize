package com.controller.curl;

import java.io.BufferedReader;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.mapper.IGetAgentJobMapper;
import com.mapper.IGetAgentNxssMapper;
import com.mapper.IVersionChkMapper;
import com.model.GetAgentJobVo;
import com.model.GetAgentNxssVo;
import com.model.PcMangrVo;
import com.model.VersionChkVo;
import com.paging.PagingVo;
import com.service.VersionChkService;

@RestController
@RequestMapping("/getAgent")
public class CurlVersionChkController {

	@Autowired
	private IGetAgentJobMapper agentJobMapper;

	@Autowired
	private IVersionChkMapper versionChkMapper ;
	
	@Autowired
	private VersionChkService vcService;

	@RequestMapping("/versionchk")
	public String getAgentJob(HttpServletRequest request, VersionChkVo vo, PagingVo pagingVo ) throws Exception {

		// 출력 변수
		String output = "";

		StringBuffer json = new StringBuffer();
	    String line = null;
	 
	    try {
	        BufferedReader reader = request.getReader();
	        while((line = reader.readLine()) != null) {
	        	System.out.println("line===> "+ line);
	            json.append(line);
	        }
	 
	    }catch(Exception e) {
	        System.out.println("Error reading JSON string: " + e.toString());
	    }
	    
	    System.out.println("json===> "+ json);
	    
	    JSONParser jsonParser = new JSONParser();
        JSONObject jsonObj = (JSONObject) jsonParser.parse( json.toString());
        JSONArray hmdArray = (JSONArray) jsonObj.get("events");

        VersionChkVo inputVo = new VersionChkVo();
        for(int i=0 ; i<hmdArray.size() ; i++){
            JSONObject tempObj = (JSONObject) hmdArray.get(i);
        	
            inputVo.setDatetime(tempObj.get("datetime").toString());
            inputVo.setUuid(tempObj.get("uuid").toString());
            inputVo.setHostname(tempObj.get("hostname").toString());
            inputVo.setPcmngr(tempObj.get("pcmngr").toString());
            inputVo.setAgent(tempObj.get("agent").toString());
            inputVo.setBrowser(tempObj.get("browser").toString());
            
        }
        
        List<VersionChkVo> esVo = vcService.chkVersionInfo(inputVo, pagingVo);
        System.out.println("===============================");
        for(VersionChkVo tempValue : esVo){
        	System.out.println("============> "+ tempValue);
        	System.out.println("============> "+ tempValue.getUuid());
        	System.out.println("============> "+ tempValue.getDatetime());
        	System.out.println("============> "+ tempValue.getHostname());
        	System.out.println("============> "+ tempValue.getPcmngr());
        	System.out.println("============> "+ tempValue.getAgent());
        } 
        
        

		System.out.println("//===================================");
		System.out.println("//result data is : " + inputVo);
		System.out.println("//===================================");
		
		return output;
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
