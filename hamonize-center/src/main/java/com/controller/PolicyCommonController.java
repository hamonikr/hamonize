package com.controller;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import com.mapper.IPolicyCommonMapper;
import com.service.RestApiService;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.ParseException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/gplcs")
public class PolicyCommonController {

	@Autowired
	RestApiService restApiService;

	@Autowired
	IPolicyCommonMapper commonMapper;

	private Logger logger = LoggerFactory.getLogger(this.getClass());

	@ResponseBody
	@RequestMapping(value = "checkAnsibleJobStatus", method = RequestMethod.POST)
	public JSONObject checkAnsibleJobStatus(HttpSession session,@RequestParam Map<String, Object> params) throws ParseException {
		JSONObject data = new JSONObject();
		data = restApiService.checkPolicyJobResult(Integer.parseInt(params.get("job_id").toString()));
		return data;

	}

	@ResponseBody
	@RequestMapping(value = "addAnsibleJobEvent", method = RequestMethod.POST)
	public int addAnsibleJobEvent(HttpSession session,@RequestParam Map<String, Object> params) throws ParseException, SQLException {
		JSONArray dataArr = new JSONArray();
		List<Map<String,Object>> resultSet = new ArrayList<Map<String,Object>>();
		Map<String, Object> resultMap;
		dataArr = restApiService.addAnsibleJobEvent(Integer.parseInt(params.get("job_id").toString()));
		for (int i = 0; i < dataArr.size(); i++) {
			resultMap = new HashMap<String, Object>();
			String json = dataArr.get(i).toString();
			resultMap.put("result", json);
			resultSet.add(resultMap);
		}
		params.put("data", resultSet);
		int result = commonMapper.checkCountAnsibleJobId(params);
		if(result == 0)
		result = commonMapper.addAnsibleJobEvent(params);
		return result;

	}

}
