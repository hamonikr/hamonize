package com.controller.curl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.mapper.IFileMapper;
import com.model.FileVo;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;


@RestController
@RequestMapping("/getAgent")
public class CurlAgentAdminkeyController {

	@Autowired
    private IFileMapper fileMapper;

	private Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@GetMapping("/getAdminKey")
	public  List<Map<String, Object>> getAgentJob(FileVo vo) throws Exception {
		
		List<Map<String, Object>> jsonObjectList = new ArrayList <Map<String, Object>>();

		List <FileVo> output = fileMapper.getFiles();	
		
		int cnt=0;
			if( output.size() == 0 ){
				Map<String, Object> jsonObject = new HashMap <String, Object>();

				jsonObject.put("data", "nodata");
				jsonObjectList.add(jsonObject);
					
			}else{
				for(FileVo el : output){
					Map<String, Object> jsonObject = new HashMap <String, Object>();

					logger.info("admin data : {}\n",el);
					
					jsonObject.put(el.getKeytype(), el.getFilepath());
					jsonObject.put("filename", el.getFilerealname());
					
					jsonObjectList.add(jsonObject);
					
					logger.info("seq : {}",el.getSeq());
					logger.info("cnt : {}",cnt);
					logger.info("jsonObjectList : {}",jsonObjectList.get(cnt));
					logger.info("-------------\n");
					cnt+=1;
				
				
				}
	
			}
		

		return jsonObjectList;
	}

}
