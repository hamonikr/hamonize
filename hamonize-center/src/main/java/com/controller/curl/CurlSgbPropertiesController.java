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
import com.mapper.IGetAgentRecoveryMapper;
import com.mapper.ISvrlstMapper;
import com.model.BlockingNxssInfoVo;
import com.model.GetAgentFirewallVo;
import com.model.GetAgentJobVo;
import com.model.GetAgentRecoveryVo;
import com.model.SvrlstVo;
import com.model.UnauthorizedVo;

@RestController
@RequestMapping("/getAgent")
public class CurlSgbPropertiesController {

	@Autowired
	private IGetAgentJobMapper agentJobMapper;

	@Autowired
	private ISvrlstMapper svrlstMapper;

	

	@RequestMapping("/sgbprt")
	public String getAgentJob(HttpServletRequest request) throws Exception {

		String output = "";
		
		JSONObject jsonObject = new JSONObject();
		JSONObject jsonList = new JSONObject();
		JSONArray itemList = new JSONArray();

		
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
		JSONObject object = (JSONObject) inetvalArray.get(0);
    	
		System.out.println("====> "+ object.get("uuid").toString());
		
		//int segSeq = sgbUUID(object.get("uuid").toString());

		List<SvrlstVo> svrlstVo = svrlstMapper.getSvrlstDataList();
		

		for( SvrlstVo svrlstData : svrlstVo ){
			System.out.println("svrlstData===>=="+ svrlstData.getSvr_port()+"=="+ svrlstData.getSvr_domain() +"=="+ svrlstData.getSvr_ip());
			
			JSONObject tmpObject = new JSONObject();
			
			tmpObject.put("sgbname", svrlstData.getSvr_nm());
			tmpObject.put("sgbdomain", svrlstData.getSvr_domain());
			
			if( "N".equals(svrlstData.getSvr_port()) ) {
				tmpObject.put("sgbip", svrlstData.getSvr_ip());	
			}else {
				tmpObject.put("sgbip", svrlstData.getSvr_ip() +":"+ svrlstData.getSvr_port());
			}
			
			
			itemList.add(tmpObject);
		}
		jsonObject.put("sgbdata", itemList);

		output = jsonObject.toJSONString();
		
		System.out.println("//===================================");
		System.out.println("//result data is : " + output);
		System.out.println("//===================================");
		
		return output;
	}

	
	

	public int sgbUUID(String sgbUuid) {
		GetAgentJobVo agentVo = new GetAgentJobVo();
		agentVo.setPc_uuid(sgbUuid);
		agentVo = agentJobMapper.getAgentJobPcUUID(agentVo);
		int segSeq = agentVo.getSeq();
		return segSeq;
	}

}
