package com.controller;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
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
	public int addAnsibleJobEvent(@RequestParam Map<String, Object> params,HttpServletRequest request) throws ParseException, SQLException {
		System.out.println("url===="+request.getHeader("referer"));
		String[] before_url = request.getHeader("referer").split("/");
		params.put("before_url", before_url[before_url.length -1]);
		JSONArray dataArr = new JSONArray();
		List<Map<String,Object>> resultSet = new ArrayList<Map<String,Object>>();
		Map<String, Object> resultMap;
		dataArr = restApiService.addAnsibleJobEvent(Integer.parseInt(params.get("job_id").toString()));
		System.out.println("dataArr.size()============"+dataArr.size());
		//String processedLength = "";
		for (int i = 0; i < dataArr.size(); i++) {
			resultMap = new HashMap<String, Object>();
			if(i > 0)
			{
				String json = dataArr.get(i).toString();
				resultMap.put("result", json);
				resultSet.add(resultMap);
			}
			// else
			// {
			// 	processedLength = dataArr.get(i).toString();
			// 	params.put("processedLength", processedLength);
			// }
		}
		params.put("data", resultSet);
		int result = commonMapper.checkCountAnsibleJobId(params);
		System.out.println("result===="+result);
		// if((dataArr.size() -1) > result)
		// {
		// 	if(processedLength.split(",").length > (dataArr.size() -1))
		// 	{
		// 		commonMapper.deleteAnsibleJobEvent(params);
		// 		addAnsibleJobEvent(params,request);
		// 	}
		// }
		// result = commonMapper.addAnsibleJobEvent(params);
		if((dataArr.size() -1) > result)
		{
			if(result > 0)
			{
				commonMapper.deleteAnsibleJobEvent(params);
			}
			result = commonMapper.addAnsibleJobEvent(params);
		}
		return result;

	}

}
