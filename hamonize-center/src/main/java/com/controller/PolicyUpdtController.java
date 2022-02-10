package com.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import com.google.gson.JsonArray;
import com.google.gson.JsonParser;
import com.mapper.IPolicyUpdtMapper;
import com.model.OrgVo;
import com.model.PolicyUpdtVo;
import com.service.AgentAptListService;
import com.service.OrgService;
import com.service.PolicyUpdtService;

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

@Controller
@RequestMapping("/gplcs")
public class PolicyUpdtController {

	@Autowired
	private OrgService oService;

	@Autowired
	private PolicyUpdtService uService;

	@Autowired
	private IPolicyUpdtMapper uMapper;

	@Autowired
	private AgentAptListService aService;

	private Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 업데이트 관리 페이지 apt 에서 패키지 리스트 가져와 db에 저장 후 출력
	 * 
	 * @param session
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/umanage", method = RequestMethod.GET)
	public String manage(HttpSession session, Model model) throws Exception {
		JSONArray jsonArray = new JSONArray();
		List<PolicyUpdtVo> pList = null;
		// APT저장소 목록
		List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
		// 센터 업데이트 프로그램 목록
		List<Map<String, Object>> pSearchList = new ArrayList<Map<String, Object>>();
		// 신규등록 프로그램 목록
		List<Map<String, Object>> newAdd = new ArrayList<Map<String, Object>>();
		// 버전 업데이트 프로그램 목록
		List<Map<String, Object>> newUpdate = new ArrayList<Map<String, Object>>();
		Map<String, Object> params;

		try {
			OrgVo orgvo = new OrgVo();
			PolicyUpdtVo vo = new PolicyUpdtVo();
			jsonArray = oService.orgList(orgvo);

			// 디비에 설치된 패키지 정보
			pSearchList = uMapper.updtComapreList();
			// apt 저장소에 있는 버전
			listMap = aService.getApt();


			System.out.println("comparing....\n");
			// APT저장소와 업데이트목록 비교후 등록 및 업데이트
			for (int i = 0; i < listMap.size(); i++) {
				boolean chk = false;
				for (int j = 0; j < pSearchList.size(); j++) {
					if (listMap.get(i).get("package").equals(pSearchList.get(j).get("pu_name"))) {
						chk = true;
						if (!listMap.get(i).get("version")
								.equals(pSearchList.get(j).get("deb_new_version"))) {
							int result = uService.updtCompareUpdate(listMap.get(i));
							break;
						} else {
							break;
						}
					} else {
						chk = false;
					}
				}
				if (!chk) {
					newAdd.add(listMap.get(i));
				}
			}
			// apt 저장소에 새로운 패키지 있을경우 추가
			if (!newAdd.isEmpty()) {
				params = new HashMap<String, Object>();
				params.put("data", newAdd);

				// 다시 새로운 패키지 정보 비교해서 디비에 저장
				int result = uService.updtCompareSave(params);
				System.out.println("result====" + result);
			}
			pList = uService.updtList(vo);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		model.addAttribute("oList", jsonArray);
		model.addAttribute("pList", pList);

		return "/policy/updtManage";

	}

	@ResponseBody
	@RequestMapping(value = "/usave", method = RequestMethod.POST)
	public String usave(HttpSession session, Model model,
			@RequestParam Map<String, Object> params) throws ParseException {
logger.info("1111======"+params.get("inventory_id").toString());
logger.info("1111======"+(String) params.get("group_id"));
logger.info("1111======"+(String) params.get("org_seq"));
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
		System.out.println("params..." + params);
		int result = 0;
		uService.updtDelete(params);
		result = uService.updtSave(params);
		
		//차단정책 초기화
		uService.updatePolicyProgrm(params);
		//ansible 정책전달
		uService.makePolicyPackage(params);
		if (result >= 1)
			return "SUCCESS";
		else
			return "FAIL";

	}

	@ResponseBody
	@RequestMapping(value = "ushow", method = RequestMethod.POST)
	public JSONObject ushow(HttpSession session, Model model, PolicyUpdtVo vo) {
		JSONObject data = new JSONObject();
		try {
			vo = uService.updtApplcView(vo);
			data.put("dataInfo", vo);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		return data;

	}

}
