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

import com.mapper.IEqualsHwMapper;
import com.mapper.IGetAgentBackupMapper;
import com.mapper.IGetAgentJobMapper;
import com.mapper.IInetLogMapper;
import com.model.EqualsHwVo;
import com.model.GetAgentBackupVo;
import com.model.GetAgentJobVo;
import com.model.InetLogVo;

@RestController
@RequestMapping("/hmsvc")
public class CurlEqualsHwController {


	@Autowired
	private IGetAgentJobMapper agentJobMapper;
	
	@Autowired
	IEqualsHwMapper equalsHwMapper;
	

	@RequestMapping("/eqhw")
	public String getAgentJob(HttpServletRequest request) throws Exception {
		
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
	    
	    
		JSONParser jsonParser = new JSONParser();
		JSONObject jsonObj = (JSONObject) jsonParser.parse( json.toString());
		JSONArray inetvalArray = (JSONArray) jsonObj.get("events");
		System.out.println("====> "+ jsonObj.get("events"));

		EqualsHwVo setEqualsHwVo = new EqualsHwVo();
        for(int i=0 ; i<inetvalArray.size() ; i++){
            JSONObject tempObj = (JSONObject) inetvalArray.get(i);
    		
            setEqualsHwVo.setInsert_dt(tempObj.get("datetime").toString());
            setEqualsHwVo.setPc_hostname(tempObj.get("hostname").toString());
            setEqualsHwVo.setPc_memory(tempObj.get("memory").toString());
            setEqualsHwVo.setPc_cpu_id(tempObj.get("cpuid").toString());
            setEqualsHwVo.setPc_disk(tempObj.get("hddinfo").toString());
            setEqualsHwVo.setPc_disk_id(tempObj.get("hddid").toString());
            setEqualsHwVo.setPc_ip(tempObj.get("ipaddr").toString());
            setEqualsHwVo.setPc_uuid(tempObj.get("uuid").toString());
            setEqualsHwVo.setPc_user(tempObj.get("user").toString());
            setEqualsHwVo.setPc_macaddress(tempObj.get("macaddr").toString());
            setEqualsHwVo.setPc_cpu(tempObj.get("cpuinfo").toString());
            
        }
        
        setEqualsHwVo.setOrg_seq(sgbUUID(setEqualsHwVo.getPc_uuid()));
        
        
		int retVal = equalsHwMapper.sgbPcHWInfoInsert(setEqualsHwVo);
		System.out.println("=========retVal is =="+ retVal);
		
		if( retVal == 1) {
			equalsHwMapper.sgbPcMngrModify(setEqualsHwVo);
			return "Y";
		}else {
			return "N";
		}
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
		int segSeq = agentVo.getSeq();
		return segSeq;
	}

}
