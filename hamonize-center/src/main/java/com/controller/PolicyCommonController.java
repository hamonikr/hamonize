package com.controller;

import java.util.Map;

import javax.servlet.http.HttpSession;

import com.service.RestApiService;

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

	private Logger logger = LoggerFactory.getLogger(this.getClass());

	@ResponseBody
	@RequestMapping(value = "checkAnsibleJobStatus", method = RequestMethod.POST)
	public JSONObject checkAnsibleJobStatus(HttpSession session,@RequestParam Map<String, Object> params) throws ParseException {
		JSONObject data = new JSONObject();
		data = restApiService.checkPolicyJobResult(Integer.parseInt(params.get("job_id").toString()));
		return data;

	}

}
