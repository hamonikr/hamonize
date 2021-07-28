package com.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.JsonArray;
import com.google.gson.JsonParser;
import com.mapper.IPolicyUpdtMapper;
import com.model.OrgVo;
import com.model.PolicyUpdtVo;
import com.service.AgentAptListService;
import com.service.OrgService;
import com.service.PolicyUpdtService;

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
	
	
	@RequestMapping("/umanage")
	public String manage(HttpSession session, Model model) throws Exception{
		System.out.println("\n /gplcs/umanage 실행===== \n");
		JSONArray jsonArray = new JSONArray();
		List<PolicyUpdtVo> pList = null;
		//APT저장소 목록
		List<Map<String, Object>> listMap= new ArrayList<Map<String, Object>>();
		//센터 업데이트 프로그램 목록
		List<Map<String, Object>> pSearchList = new ArrayList<Map<String, Object>>();
		//신규등록 프로그램 목록
		List<Map<String, Object>> newAdd = new ArrayList<Map<String, Object>>();
		//버전 업데이트 프로그램 목록
		List<Map<String, Object>> newUpdate = new ArrayList<Map<String, Object>>();
		Map<String, Object> params;

		try {
			System.out.println("===try===");
			OrgVo orgvo = new OrgVo();
			PolicyUpdtVo vo = new PolicyUpdtVo();
			jsonArray = oService.orgList(orgvo);
			
			// 디비에 설치된 패키지 정보
			pSearchList = uMapper.updtComapreList();
			for(int k=0;k<pSearchList.size();k++) {
				System.out.println("pSearchList" + pSearchList.get(k).toString());
			}
			// apt 저장소에 있는 버전 
			listMap = aService.getApt();
			
			for(int j=0;j<listMap.size();j++) {
				System.out.println("listMap" + listMap.get(j).toString());
			}
			
			System.out.println("comparing....\n");
			//APT저장소와 업데이트목록 비교후 등록 및 업데이트
			for (int i = 0; i < listMap.size(); i++) {
				boolean chk = false;
				for (int j = 0; j < pSearchList.size(); j++) {
					if (listMap.get(i).get("package").equals(pSearchList.get(j).get("pu_name"))) {
						chk = true;
						if (!listMap.get(i).get("version").equals(pSearchList.get(j).get("deb_new_version"))) {
							System.out.println("update");
							// newUpdate.add(listMap.get(i));
							int result = uService.updtCompareUpdate(listMap.get(i));
							break;
						} else {
							System.out.println("있음");
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
			//apt 저장소에 새로운 패키지 있을경우 추가  
			if(!newAdd.isEmpty()) {
			params = new HashMap<String, Object>();
			params.put("data", newAdd);
			
			// 다시 새로운 패키지 정보 비교해서 디비에 저장
			int result = uService.updtCompareSave(params);
			System.out.println("result===="+result);
			}
			pList = uService.updtList(vo);
		} catch (Exception e) {
			System.out.println("===error===");

			e.printStackTrace();
			// FAIL_GET_LIST
		}
		
		model.addAttribute("oList", jsonArray);
		model.addAttribute("pList",pList);
		
		return "/policy/updtManage";
		
	}
	@ResponseBody
	@RequestMapping("/usave")
	public String usave(HttpSession session, Model model,@RequestParam Map<String, Object> params ) {
		
		JsonParser jp = new JsonParser();
		String data = params.get("data").toString();
		JsonArray jsonArray = (JsonArray) jp.parse(data);
		List<Map<String, Object>> resultSet = new ArrayList<Map<String, Object>>();
		 Map<String, Object> resultMap;
		for(int i = 0; i < jsonArray.size(); i++) {
			resultMap = new HashMap<String, Object>();
			String ch = jsonArray.get(i).toString().replaceAll("[^0-9]", "");
			resultMap.put("org_seq", Integer.parseInt(ch));
			resultSet.add(resultMap);
		}
		params.put("data",resultSet);
		System.out.println("params..."+params);
		int result = 0;
		uService.updtDelete(params);
		result = uService.updtSave(params);
		/*
		 * try { OrgVo orgvo = new OrgVo(); vo = new PolicyProgramVo(); jsonArray =
		 * oService.orgList(orgvo); pList = pService.programList(vo);
		 * 
		 * } catch (Exception e) { e.printStackTrace(); // FAIL_GET_LIST }
		 */
		if(result >=1 )
			return "SUCCESS";
		else
			return"FAIL";
		
	}
	
	@ResponseBody
	@RequestMapping("ushow")
	public JSONObject ushow(HttpSession session, Model model,PolicyUpdtVo vo) {
		JSONObject data = new JSONObject();
		try {
			vo = uService.updtApplcView(vo);
			data.put("dataInfo", vo);
		}catch(Exception e) {
			
		}
		/*
		 * System.out.println("asd"+vo.getPu_seq()); vo = uService.updtApplcView(vo);
		 * System.out.println("orgvo===="+vo.getPpm_seq()); JSONObject data = new
		 * JSONObject(); data.put("dataInfo", vo);
		 * System.out.println("zzzzz"+data.get("ppm_seq"));
		 */

		
		return data;
			
	}
	
}
