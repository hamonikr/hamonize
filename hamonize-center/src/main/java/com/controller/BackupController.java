package com.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.JsonArray;
import com.google.gson.JsonParser;
import com.model.BackupVo;
import com.model.OrgVo;
import com.model.PolicyFireWallVo;
import com.service.BackupService;
import com.service.OrgService;

@Controller
@RequestMapping("/backupRecovery")
public class BackupController {

	@Autowired
	private OrgService oService;

	@Autowired
	private BackupService bService;
	
	@Autowired
	MessageSource messageSource;

	@RequestMapping("/backupC")
	public String manage(HttpSession session, Model model) {

		JSONArray jsonArray = new JSONArray();

		try {
			OrgVo orgvo = new OrgVo();
			jsonArray = oService.orgList(orgvo);

		} catch (Exception e) {
			e.printStackTrace();
			// FAIL_GET_LIST
		}

		model.addAttribute("oList", jsonArray);


		return "/backup/backupCycle";

	}

	
	  @ResponseBody
	  @RequestMapping("backupSave") 
	  public String backupSave(HttpSession session, Model model,BackupVo vo ,@RequestParam Map<String, Object> params ) {
		  JsonParser jp = new JsonParser();
			String data = params.get("data").toString();
			JsonArray jsonArray = (JsonArray) jp.parse(data);
			List<Map<String, Object>> resultSet = new ArrayList<Map<String, Object>>();
			 Map<String, Object> resultMap;
			 int result = 0;
			for(int i = 0; i < jsonArray.size(); i++) {
				resultMap = new HashMap<String, Object>();
				String ch = jsonArray.get(i).toString().replaceAll("[^0-9]", "");
				resultMap.put("org_seq", Integer.parseInt(ch));
				resultSet.add(resultMap);
				if(i == 5001) {
					params.put("data",resultSet);
					bService.backupDelete(params);
					result = bService.backupSave(params);
					params.remove("data");
					resultSet.clear();
					
				}
			}
			params.put("data",resultSet);
			System.out.println("params..."+params);
			bService.backupDelete(params);
			result = bService.backupSave(params);
			
			if(result >=1 )
				return "SUCCESS";
			else
				return"FAIL";  
	  }
	  
	  	@ResponseBody
		@RequestMapping("backupShow")
		public JSONObject pshow(HttpSession session, Model model,BackupVo vo) {
			vo = bService.backupApplcView(vo);
			JSONObject data = new JSONObject();
			data.put("dataInfo", vo);
			return data;
				
		}
	  
	  @RequestMapping("/backupR")
		public String backupR(HttpSession session, Model model) {

			JSONArray jsonArray = new JSONArray();

			try {
				OrgVo orgvo = new OrgVo();
				PolicyFireWallVo vo = new PolicyFireWallVo();
				jsonArray = oService.orgList(orgvo);

			} catch (Exception e) {
				e.printStackTrace();
				// FAIL_GET_LIST
			}
			model.addAttribute("oList", jsonArray);

			return "/backup/backupRecovery";

		}
	  
	  @ResponseBody
		@RequestMapping("backupRCShow")
		public JSONArray backupRCShow(HttpSession session, Model model,@RequestParam Map<String, Object> params) {
		  	JSONArray result = new JSONArray();
		  	List<Map<String, Object>> resultSet;
		  	params.put("org_seq", Integer.parseInt(params.get("org_seq").toString()));
		  	resultSet = bService.backupRCApplcView(params);
		  	if(!resultSet.isEmpty()) {
		  	for(int i = 0; i < resultSet.size();i++) {
		  		JSONObject jo = new JSONObject();
		  		jo.put("sgb_seq", resultSet.get(i).get("sgb_seq").toString());
		  		jo.put("org_seq", resultSet.get(i).get("org_seq").toString());
		  		jo.put("sgb_pc_uuid", resultSet.get(i).get("sgb_pc_uuid").toString());
		  		jo.put("sgb_pc_hostname", resultSet.get(i).get("sgb_pc_hostname").toString());
		  		result.add(jo);
		  		System.out.println(resultSet.get(i));
		  		}
		  	}
		  	System.out.println(result);
			JSONObject data = new JSONObject();
			return result;
				
		}
	  
	  @ResponseBody
		@RequestMapping("backupRCList")
		public JSONArray backupRCList(HttpSession session, Model model,@RequestParam Map<String, Object> params) {
		  	JSONArray result = new JSONArray();
		  	List<Map<String, Object>> resultSet;
		  	params.put("sgb_seq", Integer.parseInt(params.get("sgb_seq").toString()));
		  	resultSet = bService.backupRecoveryList(params);
		  	if(!resultSet.isEmpty()) {
		  	for(int i = 0; i < resultSet.size();i++) {
		  		JSONObject jo = new JSONObject();
		  		jo.put("sgb_seq", resultSet.get(i).get("sgb_seq").toString());
		  		jo.put("br_org_seq", resultSet.get(i).get("br_org_seq").toString());
		  		jo.put("br_backup_iso_dt", resultSet.get(i).get("br_backup_iso_dt").toString());
		  		jo.put("br_backup_gubun", resultSet.get(i).get("br_backup_gubun").toString());
		  		jo.put("br_backup_name", resultSet.get(i).get("br_backup_name").toString());
		  		jo.put("br_seq", resultSet.get(i).get("br_seq").toString());
		  		result.add(jo);
		  		System.out.println(resultSet.get(i));
		  		}
		  	}
		  	System.out.println(result);
			JSONObject data = new JSONObject();
			//data.put("dataInfo", result);
			return result;
				
		}
	  @ResponseBody
	  @RequestMapping("backupRCSave")
		public String backupRCSave(HttpSession session, Model model,@RequestParam Map<String, Object> params) {
		  params.put("sgb_seq", Integer.parseInt(params.get("sgb_seq").toString()));
		  params.put("org_seq", Integer.parseInt(params.get("org_seq").toString()));
		  params.put("br_seq", Integer.parseInt(params.get("br_seq").toString()));
		/*
		 * params.put("rl_org_seq", Integer.parseInt(params.get("org_seq").toString()));
		 * params.put("rl_br_seq", Integer.parseInt(params.get("br_seq").toString()));
		 */
		  int result=0;
		  //로그저장
		  bService.backupRecoveryLogSave(params);
		  //복구삭제
		  bService.backupRecoveryDelete(params);
		  //복구등록
		  result = bService.backupRecoverySave(params);
		  if(result > 0) {
			  model.addAttribute("messege","성공하였습니다..");
			return "SUCCESS";
		  }else {
			  model.addAttribute("messege","실패하였습니다.");
			return "FAIL";  
		  }
			
		}
	 

}
