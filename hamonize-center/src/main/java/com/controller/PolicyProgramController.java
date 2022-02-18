package com.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.ParseException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.JsonArray;
import com.google.gson.JsonParser;
import com.model.OrgVo;
import com.model.PolicyProgrmVo;
import com.service.OrgService;
import com.service.PolicyProgramService;

@Controller
@RequestMapping("/gplcs")
public class PolicyProgramController {

	@Autowired
	private OrgService oService;

	@Autowired
	private PolicyProgramService pService;

	private Logger logger = LoggerFactory.getLogger(this.getClass());


	@RequestMapping(value = "/pmanage", method = RequestMethod.GET)
	public String manage(HttpSession session, Model model) {

		JSONArray jsonArray = new JSONArray();
		List<PolicyProgrmVo> pList = null;

		try {
			OrgVo orgvo = new OrgVo();
			PolicyProgrmVo vo = new PolicyProgrmVo();
			jsonArray = oService.orgList(orgvo);
			pList = pService.programList(vo);

		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		model.addAttribute("oList", jsonArray);
		model.addAttribute("pList", pList);

		return "/policy/programManage";

	}

	@ResponseBody
	@RequestMapping(value = "/psave", method = RequestMethod.POST)
	public JSONObject pinsert(HttpSession session, Model model,
			@RequestParam Map<String, Object> params) throws ParseException {

		JsonParser jp = new JsonParser();
		String data = params.get("data").toString();
		JsonArray jsonArray = (JsonArray) jp.parse(data);
		List<Map<String, Object>> resultSet = new ArrayList<Map<String, Object>>();
		Map<String, Object> resultMap;
		for (int i = 0; i < jsonArray.size(); i++) {
			resultMap = new HashMap<String, Object>();
			String ch = jsonArray.get(i).toString().replaceAll("[^0-9]", "");
			resultMap.put("org_seq", Integer.parseInt(ch));
			resultSet.add(resultMap);
		}

		params.put("data", resultSet);
		//ansible 정책전달
		JSONObject jobResult = pService.applyProgramPolicy(params);
		params.put("job_id", jobResult.get("id"));
		int result = 0;
		pService.programDelete(params);
		result = pService.programSave(params);
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

	@ResponseBody
	@RequestMapping(value = "pshow", method = RequestMethod.POST)
	public JSONObject pshow(HttpSession session, Model model, PolicyProgrmVo vo) {
		JSONObject data = new JSONObject();
		List<PolicyProgrmVo> pList = null;
		try {
			data.put("job_id", pService.getProgrmHistoryLastJob(vo));
			pList = pService.programList(vo);
			vo = pService.programApplcView(vo);
			data.put("dataInfo", vo);
			data.put("pList", pList);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		return data;

	}

}
