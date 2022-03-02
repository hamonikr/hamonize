package com.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import com.model.BackupVo;
import com.model.OrgVo;
import com.service.BackupService;
import com.service.OrgService;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;


@Controller
@RequestMapping("/backupRestore")
public class PolicyBackupRestoreController {

	@Autowired
	private OrgService oService;

	@Autowired
	private BackupService bService;

	@Autowired
	MessageSource messageSource;

	private Logger logger = LoggerFactory.getLogger(this.getClass());

	@RequestMapping(value = "/backupC", method = RequestMethod.GET)
	public String manage(HttpSession session, Model model) {

		JSONArray jsonArray = new JSONArray();

		try {
			OrgVo orgvo = new OrgVo();
			jsonArray = oService.orgList(orgvo);

		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		model.addAttribute("oList", jsonArray);


		return "/backup/backupCycle";

	}


	@ResponseBody
	@RequestMapping(value = "backupSave", method = RequestMethod.POST)
	public String backupSave(HttpSession session, Model model, BackupVo vo,
			@RequestParam Map<String, Object> params) throws ParseException {
		JSONParser jp = new JSONParser();
		String data = params.get("data").toString();
		JSONArray jsonArray = (JSONArray) jp.parse(data);
		List<Map<String, Object>> resultSet = new ArrayList<Map<String, Object>>();
		Map<String, Object> resultMap;
		int result = 0;
		for (int i = 0; i < jsonArray.size(); i++) {
			resultMap = new HashMap<String, Object>();
			String ch = jsonArray.get(i).toString().replaceAll("[^0-9]", "");
			resultMap.put("org_seq", Integer.parseInt(ch));
			resultSet.add(resultMap);
			if (i == 5001) {
				params.put("data", resultSet);
				bService.backupDelete(params);
				result = bService.backupSave(params);
				params.remove("data");
				resultSet.clear();

			}
		}
		params.put("data", resultSet);
		System.out.println("params..." + params);
		bService.backupDelete(params);
		result = bService.backupSave(params);

		if (result >= 1)
			return "SUCCESS";
		else
			return "FAIL";
	}

	@ResponseBody
	@RequestMapping(value = "backupShow", method = RequestMethod.POST)
	public JSONObject pshow(HttpSession session, Model model, BackupVo vo) {
		vo = bService.backupApplcView(vo);
		JSONObject data = new JSONObject();
		data.put("dataInfo", vo);
		return data;

	}

	@RequestMapping(value = "/backupR", method = RequestMethod.GET)
	public String backupR(HttpSession session, Model model) {

		JSONArray jsonArray = new JSONArray();

		try {
			OrgVo orgvo = new OrgVo();
			jsonArray = oService.orgList(orgvo);

		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		model.addAttribute("oList", jsonArray);

		return "/backup/backupRestore";

	}

	@ResponseBody
	@RequestMapping(value = "backupRCShow", method = RequestMethod.POST)
	public JSONArray backupRCShow(HttpSession session, Model model,
			@RequestParam Map<String, Object> params) {
		JSONArray result = new JSONArray();
		List<Map<String, Object>> resultSet;

		System.out.println("backupRCShow org_seq > " + params.get("org_seq").toString());
		params.put("org_seq", Integer.parseInt(params.get("org_seq").toString()));
		params.put("domain", params.get("domain").toString());
		resultSet = bService.backupRCApplcView(params);

		if (!resultSet.isEmpty()) {
			for (int i = 0; i < resultSet.size(); i++) {
				JSONObject jo = new JSONObject();
				jo.put("seq", resultSet.get(i).get("seq").toString());
				jo.put("org_seq", resultSet.get(i).get("org_seq").toString());
				jo.put("pc_uuid", resultSet.get(i).get("pc_uuid").toString());
				jo.put("pc_hostname", resultSet.get(i).get("pc_hostname").toString());
				result.add(jo);
				System.out.println(resultSet.get(i));
			}
		}
		System.out.println(result);
		JSONObject data = new JSONObject();
		return result;

	}

	@ResponseBody
	@RequestMapping(value = "backupRCList", method = RequestMethod.POST)
	public JSONArray backupRCList(HttpSession session, Model model,
			@RequestParam Map<String, Object> params) {
		JSONArray result = new JSONArray();
		List<Map<String, Object>> resultSet;


		System.out.println("backupRCList seq : " + params.get("seq").toString());
		params.put("seq", Integer.parseInt(params.get("seq").toString()));

		resultSet = bService.backupRecoveryList(params);

		if (!resultSet.isEmpty()) {
			for (int i = 0; i < resultSet.size(); i++) {
				JSONObject jo = new JSONObject();
				jo.put("br_seq", resultSet.get(i).get("br_seq").toString());
				jo.put("br_org_seq", resultSet.get(i).get("br_org_seq").toString());
				jo.put("br_backup_iso_dt", resultSet.get(i).get("br_backup_iso_dt").toString());
				jo.put("br_backup_status", resultSet.get(i).get("br_backup_status").toString());
				jo.put("br_backup_name", resultSet.get(i).get("br_backup_name").toString());
				jo.put("br_backup_path", resultSet.get(i).get("br_backup_path").toString());
				jo.put("pc_seq", resultSet.get(i).get("pc_seq").toString());
				result.add(jo);
				System.out.println("backupRCList :  >>>> " + resultSet.get(i));
			}
		} else {
			System.out.println("backupRCList is empty..");
		}

		System.out.println(result);

		return result;

	}

	@ResponseBody
	@RequestMapping(value = "backupRCSave", method = RequestMethod.POST)
	public JSONObject backupRCSave(HttpSession session, Model model,
			@RequestParam Map<String, Object> params) throws ParseException, InterruptedException {
		params.put("pc_seq", Integer.parseInt(params.get("pc_seq").toString()));
		params.put("org_seq", Integer.parseInt(params.get("org_seq").toString()));
		params.put("br_seq", Integer.parseInt(params.get("br_seq").toString()));

		//ansible 정책전달
		JSONObject jobResult = bService.applyRestorePolicy(params);
		params.put("job_id", jobResult.get("id"));
		int result = 0;
		// 로그저장
		//bService.backupRecoveryLogSave(params);
		// 복구삭제
		bService.backupRecoveryDelete(params);
		// 복구등록
		result = bService.backupRecoverySave(params);
		JSONObject jsonObj = new JSONObject();
		if (result >= 1){
			jsonObj.put("STATUS", "SUCCESS");
			jsonObj.put("ID", jobResult.get("id"));
			jsonObj.put("JOBSTATUS", jobResult.get("status"));
		} else{
			jsonObj.put("STATUS", "FAIL");
		}
		return jsonObj;

	}


}
