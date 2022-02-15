package com.controller.curl;

import java.util.HashMap;
import java.util.Map;

import com.mapper.IGetAgentPollingMapper;
import com.model.GetAgentPollingVo;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/getAgent")
public class CurlAgentPollingController {

	@Autowired
	private IGetAgentPollingMapper getAgentPollingMapper;
	
	private Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 에이전트에 방화벽정책 보내는 부분
	 * 
	 * @param uuid
	 * @param wget
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/setPollTime", method = RequestMethod.GET)
	public  Map<String, Object> getAgentJob(@RequestParam(value = "uuid", required = false) String uuid,@RequestParam(value = "name", required = false) String name) throws Exception {

		// 출력 변수
		logger.info("uuid === {}", uuid);
		
		uuid = uuid.trim();

		GetAgentPollingVo vo = new GetAgentPollingVo();
		vo.setUuid(uuid);
		vo.setPu_name(name);
		

		GetAgentPollingVo output = getAgentPollingMapper.getPollingTime(vo);
		Map<String, Object> jsonObject = new HashMap<String, Object>();
		
		System.out.println("==="+ output);
		if( output != null ) {
			jsonObject.put("data", output.getPolling_tm());
		}else {
			jsonObject.put("data", "3600");
		}

		logger.info("//===================================");
		logger.info("/result data is : {}", jsonObject);
		logger.info("//===================================// ");

		return jsonObject;
	}

}
