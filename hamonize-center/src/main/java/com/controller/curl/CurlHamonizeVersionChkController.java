package com.controller.curl;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.mapper.IHamonizeVersionChkMapper;
import com.model.hamonizeVersionChkVo;

@RestController
@RequestMapping("/hmsvc")
public class CurlHamonizeVersionChkController {


	@Autowired
	IHamonizeVersionChkMapper hamonizeVersionChkMapper;
	

	@RequestMapping("/version")
	public void version(@RequestBody String valLoad ) throws Exception {
		System.out.println("---- CurlHamonizeVersionChkController ----");
	
		JSONParser jsonParser = new JSONParser();
       JSONObject jsonObj = (JSONObject) jsonParser.parse(valLoad);
       JSONArray hmdArray = (JSONArray) jsonObj.get("versionchk");
       hamonizeVersionChkVo  hamonizeVersionChkVo = new hamonizeVersionChkVo();
        
        
		for(int i=0 ; i<hmdArray.size() ; i++){
			JSONObject tempObj = (JSONObject) hmdArray.get(i);
			
			System.out.println("tempObj.get(\"state\").toString()===="+tempObj.get("state").toString());
			
			hamonizeVersionChkVo.setDebname(tempObj.get("debname").toString());
			hamonizeVersionChkVo.setDebversion(tempObj.get("debver").toString());
			hamonizeVersionChkVo.setDebstatus(tempObj.get("state").toString());
			hamonizeVersionChkVo.setPcuuid((tempObj.get("uuid").toString()));
		}
		
		hamonizeVersionChkVo  chkVo = new hamonizeVersionChkVo();
		
		// 이전 버전이랑 비교
		chkVo = hamonizeVersionChkMapper.getHamonizeAgentInfoOnPc(hamonizeVersionChkVo);
		
		if(chkVo == null ) {
			// 이전 버전이 없다면 insert 
			hamonizeVersionChkMapper.setHamonizeAgentIfnoOnPc(hamonizeVersionChkVo);
		}else {
			// update 
			System.out.println("---- update ----");
			//이전버전이랑 다르면 업데이트
			if( !hamonizeVersionChkVo.getDebversion().equals( chkVo.getDebversion() )  || 
					!hamonizeVersionChkVo.getDebstatus().contentEquals( chkVo.getDebstatus())	) {
				System.out.println("hamonizeVersionChkVo is not equals");
				hamonizeVersionChkMapper.updateHamonizeAgentIfnoOnPc(hamonizeVersionChkVo);
			}else {
				//이전버전이랑 같음
				System.out.println(" hamonizeVersionChkVo is quals");
			}
			
		}
		
	}

	

}