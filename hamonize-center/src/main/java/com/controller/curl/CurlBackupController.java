package com.controller.curl;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.mapper.IGetAgentJobMapper;
import com.model.CurlPcBackupVo;
import com.model.GetAgentJobVo;

@RestController
@RequestMapping("/backup")
public class CurlBackupController {


	@Autowired
	private IGetAgentJobMapper agentJobMapper;


	@RequestMapping(value = "/setBackupJob", method = RequestMethod.POST)
	public String setBackupJob(@RequestBody String valLoad) throws Exception {

		String output = "";

		CurlPcBackupVo cbVo = new CurlPcBackupVo();


		JSONParser jsonParser = new JSONParser();
		JSONObject jsonObj = (JSONObject) jsonParser.parse(valLoad);
		JSONArray hmdArray = (JSONArray) jsonObj.get("events");

		for (int i = 0; i < hmdArray.size(); i++) {
			JSONObject tempObj = (JSONObject) hmdArray.get(i);
			cbVo.setBr_backup_path(tempObj.get("dir").toString());
			cbVo.setBk_name(tempObj.get("name").toString());
			cbVo.setBk_uuid(tempObj.get("uuid").toString());
			cbVo.setBr_backup_iso_dt(tempObj.get("datetime").toString());
			cbVo.setBk_hostname(tempObj.get("hostname").toString());
			cbVo.setBr_backup_gubun(tempObj.get("gubun").toString());
		}


		GetAgentJobVo agentVo = new GetAgentJobVo();
		agentVo.setPc_uuid(cbVo.getBk_uuid());
		agentVo.setSeq(cbVo.getBr_org_seq());
		agentVo = agentJobMapper.getAgentJobPcUUIDInBACKUP(agentVo);

		System.out.println("agentVo org_seq >>> " + agentVo.getOrg_seq());
		System.out.println("agentVo pc_seq >>> " + agentVo.getSeq());

		cbVo.setBr_org_seq(agentVo.getOrg_seq());
		cbVo.setDept_seq(agentVo.getSeq());
		agentJobMapper.insertBackupInfo(cbVo);


		return output;
	}


}


