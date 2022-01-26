package com.controller.curl;

import java.io.BufferedReader;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.mapper.IUpdtPollicyMapper;
import com.model.UpdtPolicyVo;

@RestController
@RequestMapping("/hmsvc")
public class CurlUpdtPolicyController {


	@Autowired
	IUpdtPollicyMapper updtPollicyMapper;

	/**
	 * agent에서 프로그램 업데이트한 수행결과 값을 받아오는 부분 리턴 구분값 > 프로그램 설치 : insresert, 업데이트 : updtresert, 삭제 :
	 * delresert
	 * 
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updtpolicy", method = RequestMethod.POST)
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

		JSONParser Parser = new JSONParser(); // 여기서 에러
		JSONObject jsonObj = (JSONObject) Parser.parse(json.toString());


		/**
		 * ====================================== deb insert =======================================
		 */
		JSONArray insArray = (JSONArray) jsonObj.get("insresert");
		UpdtPolicyVo[] updtVo = new UpdtPolicyVo[insArray.size()];
		if (insArray.size() != 0) {
			System.out.println("agent에서 보낸 결과 updtpolicy > insresert");
			for (int i = 0; i < insArray.size(); i++) {
				JSONObject object = (JSONObject) insArray.get(i);
				updtVo[i] = new UpdtPolicyVo();
				updtVo[i].setDebname(object.getOrDefault("debname", "").toString());
				updtVo[i].setDebver(object.getOrDefault("debver", "").toString());
				updtVo[i].setState(object.getOrDefault("state", "").toString());
				updtVo[i].setPath(object.getOrDefault("path", "").toString());
				updtVo[i].setGubun("INSTALL");
				updtVo[i].setPc_uuid(jsonObj.getOrDefault("uuid", "").toString());


				UpdtPolicyVo insDataVo = new UpdtPolicyVo();
				insDataVo.setDebname(object.getOrDefault("debname", "").toString());
				insDataVo.setPc_uuid(jsonObj.getOrDefault("uuid", "").toString());
				updtPollicyMapper.updtInsertProgrm(insDataVo);

			}


		}


		/**
		 * ====================================== deb update =======================================
		 */
		JSONArray updtArray = (JSONArray) jsonObj.get("updtresert");
		UpdtPolicyVo[] updtVo2 = new UpdtPolicyVo[updtArray.size()];

		if (updtArray.size() != 0) {
			for (int i = 0; i < updtArray.size(); i++) {
				JSONObject object = (JSONObject) updtArray.get(i);
				updtVo2[i] = new UpdtPolicyVo();
				updtVo2[i].setDebname(object.getOrDefault("debname", "").toString());
				updtVo2[i].setDebver(object.getOrDefault("debver", "").toString());
				updtVo2[i].setState(object.getOrDefault("state", "").toString());
				updtVo2[i].setPath(object.getOrDefault("path", "").toString());
				updtVo2[i].setGubun("UPGRADE");
				updtVo2[i].setPc_uuid(jsonObj.getOrDefault("uuid", "").toString());

				UpdtPolicyVo insDataVo = new UpdtPolicyVo();
				insDataVo.setDebname(object.getOrDefault("debname", "").toString());
				updtPollicyMapper.updtInsertProgrm(insDataVo);

			}
		}


		/**
		 * ====================================== deb delete =======================================
		 */
		JSONArray delArray = (JSONArray) jsonObj.get("delresert");
		UpdtPolicyVo[] updtVo3 = new UpdtPolicyVo[delArray.size()];

		if (delArray.size() != 0) {

			for (int i = 0; i < delArray.size(); i++) {
				JSONObject object = (JSONObject) delArray.get(i);

				updtVo3[i] = new UpdtPolicyVo();
				updtVo3[i].setDebname(object.getOrDefault("debname", "").toString());
				updtVo3[i].setDebver(object.getOrDefault("debver", "").toString());
				updtVo3[i].setState(object.getOrDefault("state", "").toString());
				updtVo3[i].setPath(object.getOrDefault("path", "").toString());
				updtVo3[i].setGubun("DELETE");
				updtVo3[i].setPc_uuid(jsonObj.getOrDefault("uuid", "").toString());

			}
			// deb insert & program del
			Map<String, Object> mapDelete = new HashMap<String, Object>();
			mapDelete.put("list", updtVo3);
			updtPollicyMapper.updtDeleteProgrm(mapDelete);

			// delete act_progrm_log
			for(int j=0;j<mapDelete.size();j++){
				logger.info( "aaaa :  {}", mapDelete.get("list"));
			}
			updtPollicyMapper.deleteProccessBlockProgrm(mapDelete);
			
		}



		UpdtPolicyVo[] updtVoSum =
				new UpdtPolicyVo[updtArray.size() + insArray.size() + delArray.size()];
		System.out.println("updtVoSum======" + updtVoSum.length);
		System.out.println(
				"=====>" + updtArray.size() + "==" + insArray.size() + "==" + delArray.size());
		System.arraycopy(updtVo, 0, updtVoSum, 0, updtVo.length);
		System.arraycopy(updtVo2, 0, updtVoSum, updtVo.length, updtVo2.length);
		System.arraycopy(updtVo3, 0, updtVoSum, updtVo2.length, updtVo3.length);



		Map<String, Object> map = new HashMap<String, Object>();
		map.put("list", updtVoSum);

		if (updtVoSum.length != 0) {
			updtPollicyMapper.updtPolicyActionResultInsert(map);
		}


		return null;
	}



}
