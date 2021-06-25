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
import com.model.GetAgentBackupVo;
import com.model.GetAgentJobVo;
import com.model.InetLogVo;

@RestController
@RequestMapping("/hmsvc")
public class CurlInetLogController {


	@Autowired
	IInetLogMapper inetLogMapper;
	

	@RequestMapping("/inetLog")
	public String getAgentJob(HttpServletRequest request) throws Exception {
		System.out.println("============inetlog start============");
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
	    
	    
		JSONParser jsonParser = new JSONParser();
		JSONObject jsonObj = (JSONObject) jsonParser.parse( json.toString() );
		JSONArray inetvalArray = (JSONArray) jsonObj.get("inetval");
		System.out.println("====> "+ jsonObj.get("inetval"));
		System.out.println("inetvalArray.size()======"+ inetvalArray.size());
		System.out.println("inetvalArray.size()======"+ inetvalArray.get(0));
		
		
		
		InetLogVo setInetLogVo = new InetLogVo();
        for(int i=0 ; i<inetvalArray.size() ; i++){
            JSONObject tempObj = (JSONObject) inetvalArray.get(i);
            System.out.println(tempObj);
           setInetLogVo.setUser_id(tempObj.get("userid").toString());
    		setInetLogVo.setPc_ip(tempObj.get("pcip").toString());
    		setInetLogVo.setCnnc_url(tempObj.get("url").toString());
    		if(tempObj.get("url").toString().contains("google")) {
    			setInetLogVo.setState("connect");
    		}else if(tempObj.get("url").toString().contains("naver")){
    			setInetLogVo.setState("connect");
    		}else if(tempObj.get("url").toString().contains("daum")){
    			setInetLogVo.setState("connect");
    		}else if(tempObj.get("url").toString().contains("youtube")){
    			setInetLogVo.setState("connect");
    		}else if(tempObj.get("url").toString().contains("facebook")){
    			setInetLogVo.setState("connect");
    		}else if(tempObj.get("url").toString().contains("fb")){
    			setInetLogVo.setState("connect");
    		}else if(tempObj.get("url").toString().contains("instagram")){
    			setInetLogVo.setState("connect");
    		}else {
    			setInetLogVo.setState(tempObj.get("state").toString());
    		}
    		setInetLogVo.setHostname(tempObj.get("hostname").toString());
    		setInetLogVo.setPc_uuid(tempObj.get("pcuuid").toString());
    		setInetLogVo.setReg_dt(tempObj.get("regdt").toString());
            
        }
        int retVal = 0;
        System.out.println("===>"+ setInetLogVo.toString());
        System.out.println("cnnc==="+setInetLogVo.getCnnc_url());
       if(!"-c".equals(setInetLogVo.getCnnc_url())) {
		retVal = inetLogMapper.inetLogInsert(setInetLogVo);
		System.out.println("=========retVal is =="+ retVal);
        }else {
        	System.out.println("error");
        }
		
		if( retVal == 1) {
			return "Y";
		}else {
			return "N";
		}
	}

	
}
