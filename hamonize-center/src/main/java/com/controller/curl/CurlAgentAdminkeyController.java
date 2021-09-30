package com.controller.curl;

import java.util.HashMap;
import java.util.Map;

import com.mapper.IGetAgentPollingMapper;
import com.model.GetAgentPollingVo;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/getAgent")
public class CurlAgentAdminkeyController {

	@Autowired
	private IGetAgentPollingMapper getAgentPollingMapper;
	
	private Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@GetMapping("/getAdminKey")
	public  Map<String, Object> getAgentJob(@RequestParam(value = "uuid", required = false) String uuid) throws Exception {

		logger.info("uuid === {}", uuid);
		
		uuid = uuid.trim();
	
		GetAgentPollingVo vo = new GetAgentPollingVo();
		vo.setUuid(uuid);
		
		int chkProgrmPolicy = getAgentPollingMapper.getAgentWorkYn(vo);
		GetAgentPollingVo output = getAgentPollingMapper.getPollingTime(vo);
		Map<String, Object> jsonObject = new HashMap<String, Object>();

		logger.info("//===================================");
		logger.info("//work yn === {}", chkProgrmPolicy);
		logger.info("//===================================// ");

		if (chkProgrmPolicy == 0) {
			if( output.getPolling_tm() == 0 ){
				jsonObject.put("data", "nodata");
			}else{
				logger.info("getPolling_tm : {}",output.getPolling_tm());
				if( output.getPolling_tm().SIZE !=0){
					jsonObject.put("data", output.getPolling_tm());

				}else{
					jsonObject.put("data", "nodata");
				}
			}
			
		}else{
			jsonObject.put("data", "nodata");

		}


		logger.info("//===================================");
		logger.info("/result data is : {}", jsonObject);
		logger.info("//===================================// ");

		return jsonObject;
	}

}
