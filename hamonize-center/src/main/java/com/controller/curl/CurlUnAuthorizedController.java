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

import com.mapper.IGetAgentBackupMapper;
import com.mapper.IGetAgentJobMapper;
import com.mapper.IInetLogMapper;
import com.mapper.IUnauthorizedMapper;
import com.model.GetAgentBackupVo;
import com.model.GetAgentJobVo;
import com.model.InetLogVo;
import com.model.UnauthorizedVo;

@RestController
@RequestMapping("/hmsvc")
public class CurlUnAuthorizedController {


	@Autowired
	IUnauthorizedMapper iUnauthorizedMapper;
	

	@RequestMapping("/unauth")
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

		UnauthorizedVo setInetLogVo = new UnauthorizedVo();
        for(int i=0 ; i<inetvalArray.size() ; i++){
            JSONObject tempObj = (JSONObject) inetvalArray.get(i);
    		
            setInetLogVo.setPc_uuid(tempObj.get("uuid").toString());
    		setInetLogVo.setVendor(tempObj.get("vendor").toString());
    		setInetLogVo.setProduct(tempObj.get("product").toString());
    		setInetLogVo.setInfo(tempObj.get("usbinfo").toString());
    		setInetLogVo.setPc_user(tempObj.get("user").toString());
    		setInetLogVo.setInsert_dt(tempObj.get("datetime").toString());
            
        }
        
        System.out.println("setInetLogVo==="+ setInetLogVo.toString());
        
		int retVal = iUnauthorizedMapper.unAuthorizedInsert(setInetLogVo);
		System.out.println("=========retVal is =="+ retVal);
		
		if( retVal == 1) {
			return "Y";
		}else {
			return "N";
		}
        
	}


}
