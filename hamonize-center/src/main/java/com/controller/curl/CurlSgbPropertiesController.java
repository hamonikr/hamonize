package com.controller.curl;

import java.io.BufferedReader;
import java.util.List;
import java.util.Objects;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.mapper.IGetAgentJobMapper;
import com.mapper.ISvrlstMapper;
import com.model.GetAgentJobVo;
import com.model.SvrlstVo;

@RestController
@RequestMapping("/getAgent")
public class CurlSgbPropertiesController {

	@Autowired
	private IGetAgentJobMapper agentJobMapper;

	@Autowired
	private ISvrlstMapper svrlstMapper;

	private Logger logger = LoggerFactory.getLogger(this.getClass());


	@RequestMapping(value = "/sgbprt", method = RequestMethod.POST)
	public String getAgentJob(HttpServletRequest request) throws Exception {

		String output = "";

		JSONObject jsonObject = new JSONObject();
		JSONObject jsonList = new JSONObject();
		JSONArray itemList = new JSONArray();


		StringBuffer json = new StringBuffer();
		String line = null;

		try {
			BufferedReader reader = request.getReader();
			while ( !Objects.isNull(line = reader.readLine()) ) {
				json.append(line);
			}
			reader.close();
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}


		JSONParser jsonParser = new JSONParser();
		JSONObject jsonObj = (JSONObject) jsonParser.parse(json.toString());
		JSONArray inetvalArray = (JSONArray) jsonObj.get("events");
		JSONObject object = (JSONObject) inetvalArray.get(0);

		logger.debug("====> {}", object.get("uuid").toString());


		List<SvrlstVo> svrlstVo = svrlstMapper.getSvrlstDataList();


		for (SvrlstVo svrlstData : svrlstVo) {
			System.out.println("svrlstData===>==" + svrlstData.getSvr_port() + "=="
					+ svrlstData.getSvr_domain() + "==" + svrlstData.getSvr_ip());

			JSONObject tmpObject = new JSONObject();

			tmpObject.put("sgbname", svrlstData.getSvr_nm());
			tmpObject.put("sgbdomain", svrlstData.getSvr_domain());

			if ("N".equals(svrlstData.getSvr_port())) {
				tmpObject.put("sgbip", svrlstData.getSvr_ip());
			} else {
				tmpObject.put("sgbip", svrlstData.getSvr_ip() + ":" + svrlstData.getSvr_port());
			}


			itemList.add(tmpObject);
		}
		jsonObject.put("sgbdata", itemList);

		output = jsonObject.toJSONString();

		System.out.println("//===================================");
		System.out.println("//result data is : " + output);
		System.out.println("//===================================");

		return output;
	}



	public Long deptUUID(String uuid) {
		GetAgentJobVo agentVo = new GetAgentJobVo();
		agentVo.setPc_uuid(uuid);
		agentVo = agentJobMapper.getAgentJobPcUUID(agentVo);
		Long segSeq = agentVo.getSeq();
		return segSeq;
	}

}
