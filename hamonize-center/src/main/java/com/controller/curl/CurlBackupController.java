package com.controller.curl;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.mapper.IGetAgentJobMapper;
import com.model.CurlPcBackupVo;
import com.model.GetAgentJobVo;

@RestController
@RequestMapping("/backup")
public class CurlBackupController {


	@Autowired
	private IGetAgentJobMapper agentJobMapper;

	
	@RequestMapping("/setBackupJob")
	public String  setBackupJob(@RequestBody String valLoad ) throws Exception {

		String output = "";
		System.out.println("valLoad==="+ valLoad);
		
		
		CurlPcBackupVo cbVo = new CurlPcBackupVo();

        
		JSONParser jsonParser = new JSONParser();
        JSONObject jsonObj = (JSONObject) jsonParser.parse(valLoad);
        JSONArray hmdArray = (JSONArray) jsonObj.get("events");
		
		for(int i=0 ; i<hmdArray.size() ; i++){
            JSONObject tempObj = (JSONObject) hmdArray.get(i);
            cbVo.setBr_backup_path(tempObj.get("dir").toString());
            cbVo.setBk_name(tempObj.get("name").toString());
            cbVo.setBk_uuid(tempObj.get("uuid").toString());
            cbVo.setBr_backup_iso_dt(tempObj.get("datetime").toString());
            cbVo.setBk_hostname(tempObj.get("hostname").toString());
            cbVo.setBr_backup_gubun(tempObj.get("gubun").toString());
		}
		
		System.out.println("===> "+ cbVo);

//		valLoad==={       
//			"events" : [ {       "datetime":"2019-06-27 23:09:16",       
//			"uuid":"HamoniKR-5DDAC624-3298-46AC-80A6-38EF370EDDB2",      
//			"name": "",       
//			"hostname": "t05-vb",       
//			"dir": "/timeshift/snapshots"      
//			"gubun": "B"       } ]}
		
		
		GetAgentJobVo agentVo = new GetAgentJobVo(); 
		agentVo.setPc_uuid(cbVo.getBk_uuid());
		agentVo.setSeq(cbVo.getBr_org_seq());
		agentVo = agentJobMapper.getAgentJobPcUUIDInBACKUP(agentVo);
		
		//System.out.println("agentVo ==="+ agentVo.getOrg_seq() );
		
		
		cbVo.setBr_org_seq( agentVo.getOrg_seq());
		cbVo.setSgb_seq(agentVo.getSgb_seq());
//		cbVo.setBr_backup_gubun("A");
		agentJobMapper.insertBackupInfo( cbVo );
		
		
		return output;
	}
	

	
}


