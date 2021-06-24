package com.controller;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.JsonArray;
import com.google.gson.JsonParser;
import com.mapper.IPolicyFireWallMapper;
import com.model.OrgVo;
import com.model.PolicyDeviceVo;
import com.model.PolicyFireWallVo;
import com.paging.PagingUtil;
import com.paging.PagingVo;
import com.service.OrgService;
import com.service.PolicyFireWallService;
import com.util.Constant;

@Controller
@RequestMapping("/gplcs")
public class PolicyFireWallController {

	@Autowired
	private OrgService oService;

	@Autowired
	private PolicyFireWallService fService;
	
	@Autowired
	private IPolicyFireWallMapper policyFireWallMapper;
	

	@RequestMapping("/fmanage")
	public String manage(HttpSession session, Model model) {

		JSONArray jsonArray = new JSONArray();
		List<PolicyFireWallVo> pList = null;

		try {
			OrgVo orgvo = new OrgVo();
			PolicyFireWallVo vo = new PolicyFireWallVo();
			jsonArray = oService.orgList(orgvo);
			pList = fService.firewallList(vo);

		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("oList", jsonArray);
		model.addAttribute("pList", pList);

		return "/policy/fireWallManage";

	}

	@ResponseBody
	@RequestMapping("/fsave")
	public String finsert(HttpSession session, Model model, @RequestParam Map<String, Object> params) {

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
	
		fService.fireWallDelete(params);
		result = fService.fireWallSave(params);
		
		/*
		 * try { OrgVo orgvo = new OrgVo(); vo = new PolicyProgramVo(); jsonArray =
		 * oService.orgList(orgvo); pList = pService.programList(vo);
		 * 
		 * } catch (Exception e) { e.printStackTrace(); // FAIL_GET_LIST }
		 */
		if (result >= 1)
			return "SUCCESS";
		else
			return "FAIL";

	}

	@ResponseBody
	@RequestMapping("/fshow")
	public JSONObject fshow(HttpSession session, Model model, PolicyFireWallVo vo) {
		JSONObject data = new JSONObject();
		try {
			vo = fService.fireWallApplcView(vo);
			data.put("dataInfo", vo);
		} catch (Exception e) {
			e.printStackTrace();
		}
		/*
		 * vo = fService.fireWallApplcView(vo);
		 * System.out.println("orgvo===="+vo.getSm_seq()); JSONObject data = new
		 * JSONObject(); data.put("dataInfo", vo);
		 * System.out.println("zzzzz"+data.get("sm_seq"));
		 */

		return data;

	}

	@RequestMapping("fManagePop")
	public String dManagePop() {
		return "/policy/fireWallManagePop";
	}

	@ResponseBody
	@RequestMapping("fManagePopList")
	public Map<String, Object> dManagePopList(PolicyFireWallVo vo, PagingVo pagingVo, HttpSession session,
			HttpServletRequest request) {
		Map<String, Object> jsonObject = new HashMap<String, Object>();
		JSONArray ja = new JSONArray();

		// 페이징
		pagingVo.setCurrentPage(vo.getMngeListInfoCurrentPage());
		pagingVo = PagingUtil.setDefaultPaging(PagingUtil.LayerPopupPaging, pagingVo);
		
		int cnt = policyFireWallMapper.fireWallPopCount(vo);
		pagingVo.setTotalRecordSize(cnt);
		pagingVo = PagingUtil.setPaging(pagingVo);
		  
		try {
			List<PolicyFireWallVo> gbList = fService.fManagePopList(vo, pagingVo);
			
			jsonObject.put("list", gbList);
			jsonObject.put("mngeVo", vo);
			jsonObject.put("pagingVo", pagingVo);
			jsonObject.put("success", true);
		} catch (Exception e) {
			jsonObject.put("success", false);
			e.printStackTrace();
		}

		return jsonObject;
	}

	@ResponseBody
	@RequestMapping(value = "/fManagePopSave", method = RequestMethod.POST)
	public Map<String, Object> dManagePopSave(HttpSession session, PolicyFireWallVo vo) throws Exception {
		Map<String, Object> jsonObject = new HashMap<String, Object>();

		try {
			fService.fireWallPopSave(vo);

			jsonObject.put("msg", Constant.Board.SUCCESS_GROUP_BOARD);
			jsonObject.put("success", true);

		} catch (SQLException sqle) {
			sqle.printStackTrace();
			jsonObject.put("msg", Constant.Board.SUCCESS_FAIL);
			jsonObject.put("success", false);
		} catch (DataIntegrityViolationException dive) {
			dive.printStackTrace();
			jsonObject.put("msg", Constant.Board.SUCCESS_FAIL);
			jsonObject.put("success", false);
		} catch (Exception e) {
			e.printStackTrace();
			jsonObject.put("msg", Constant.Board.SUCCESS_FAIL);
			jsonObject.put("success", false);
		}
		return jsonObject;
	}

	@ResponseBody
	@RequestMapping(value = "/fManagePopDelete", method = RequestMethod.POST)
	public Map<String, Object> dManagePopDelete(HttpSession session, PolicyFireWallVo vo) throws Exception {
		// log.info(" -- ctr:deleteIpManagementProc - vo : " + vo);

		Map<String, Object> jsonObject = new HashMap<String, Object>();

		try {
			fService.fireWallPopDelete(vo);

			jsonObject.put("msg", Constant.Board.SUCCESS_GROUP_BOARD);
			jsonObject.put("success", true);

		} catch (SQLException sqle) {
			sqle.printStackTrace();
			jsonObject.put("msg", Constant.Board.SUCCESS_FAIL);
			jsonObject.put("success", false);
		} catch (DataIntegrityViolationException dive) {
			dive.printStackTrace();
			jsonObject.put("msg", Constant.Board.SUCCESS_FAIL);
			jsonObject.put("success", false);
		} catch (Exception e) {
			e.printStackTrace();
			jsonObject.put("msg", Constant.Board.SUCCESS_FAIL);
			jsonObject.put("success", false);
		}
		return jsonObject;
	}

}
