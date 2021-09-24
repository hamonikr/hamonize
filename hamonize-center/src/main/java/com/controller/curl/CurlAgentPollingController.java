package com.controller.curl;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

import com.mapper.IGetAgentJobMapper;
import com.mapper.IGetAgentPollingMapper;
import com.model.GetAgentPollingVo;
import com.model.GetAgentJobVo;

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
		logger.info("name === {}", name);
		
		uuid = uuid.trim();
		name = name.trim();

		GetAgentPollingVo vo = new GetAgentPollingVo();
		vo.setUuid(uuid);
		vo.setPu_name(name);
		
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

	// /*
	//  * 부서 UUID로 부서 seq 가져오기
	//  * 
	//  * @param uuid
	//  * 
	//  * @return 부서seq
	//  */
	// public int pcUUID(String uuid) {
	// 	GetAgentJobVo agentVo = new GetAgentJobVo();
	// 	agentVo.setPc_uuid(uuid);
	// 	agentVo = agentJobMapper.getAgentJobPcUUID(agentVo);

	// 	int segSeq = 0;

	// 	if (agentVo != null) {
	// 		segSeq = agentVo.getSeq();
	// 	}
	// 	return segSeq;
	// }

}
