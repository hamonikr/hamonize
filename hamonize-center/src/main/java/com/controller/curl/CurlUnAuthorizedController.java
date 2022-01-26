package com.controller.curl;

import java.io.BufferedReader;
import java.util.ArrayList;
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

import com.mapper.IUnauthorizedMapper;
import com.model.UnauthorizedVo;

@RestController
@RequestMapping("/hmsvc")
public class CurlUnAuthorizedController {


	@Autowired
	IUnauthorizedMapper iUnauthorizedMapper;

	
	private Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 비인가 디바이스의 접속 로그 에이전트에서 비인가디바이스 접속 로그 전송
	 * 
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/unauth", method = RequestMethod.POST)
	public String getAgentJob(HttpServletRequest request) throws Exception {

		StringBuffer json = new StringBuffer();
		String line = null;

		try {
			BufferedReader reader = request.getReader();
			while ( !Objects.isNull(line = reader.readLine()) ) {
//			while (!(line = reader.readLine()).isEmpty()) {
				json.append(line);
			}
			reader.close();
		} catch (Exception e) {
			logger.info("Error reading JSON string: " + e.toString());
		}


		JSONParser jsonParser = new JSONParser();
		JSONObject jsonObj = (JSONObject) jsonParser.parse(json.toString());

		JSONArray inetvalArray = (JSONArray) jsonObj.get("events");
		System.out.println("====> " + jsonObj.get("events"));

		List<UnauthorizedVo> list = new ArrayList<UnauthorizedVo>();
		System.out.println("inetvalArray size : " + inetvalArray.size());

		for (int i = 0; i < inetvalArray.size(); i++) {
			JSONObject tempObj = (JSONObject) inetvalArray.get(i);
			UnauthorizedVo tmpVo = new UnauthorizedVo();
			System.out.println("tempObj : " + tempObj);
			tmpVo.setPc_uuid(tempObj.get("uuid").toString());
			tmpVo.setVendor(tempObj.get("vendor").toString());
			tmpVo.setProduct(tempObj.get("product").toString());
			tmpVo.setInfo(tempObj.get("usbinfo").toString());
			tmpVo.setPc_user(tempObj.get("user").toString());
			tmpVo.setInsert_dt(tempObj.get("datetime").toString());

			list.add(tmpVo);
			System.out.println("setInetLogVo===" + list.get(i).toString());

		}


		int retVal = iUnauthorizedMapper.unAuthorizedInsert(list);
		System.out.println("=========retVal is ==" + retVal);

		if (retVal == 1) {
			return "Y";
		} else {
			return "N";
		}

	}


}
