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
import com.mapper.IPolicyDeviceMapper;
import com.model.LoginVO;
import com.model.OrgVo;
import com.model.PolicyDeviceVo;
import com.paging.PagingUtil;
import com.paging.PagingVo;
import com.service.OrgService;
import com.service.PolicyDeviceService;
import com.util.AuthUtil;
import com.util.Constant;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Controller
@RequestMapping("/gplcs")
public class PolicyDeviceController {

	@Autowired
	private OrgService oService;

	@Autowired
	private PolicyDeviceService dService;

	@Autowired
	private IPolicyDeviceMapper policyDeviceMapper;

	private Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * deviceList 출력
	 * 
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/dmanage", method = RequestMethod.GET)
	public String manage(HttpSession session, Model model) {

		JSONArray jsonArray = new JSONArray();
		List<PolicyDeviceVo> pList = null;
		LoginVO lvo = AuthUtil.getLoginSessionInfo();
		try {
			OrgVo orgvo = new OrgVo();
			PolicyDeviceVo vo = new PolicyDeviceVo();
			vo.setDomain(lvo.getDomain());
			jsonArray = oService.orgList(orgvo);
			pList = dService.deviceList(vo);

		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		model.addAttribute("oList", jsonArray);
		model.addAttribute("pList", pList);

		return "/policy/deviceManage";

	}

	@ResponseBody
	@RequestMapping(value = "/dsave", method = RequestMethod.POST)
	public String dinsert(HttpSession session, Model model,
			@RequestParam Map<String, Object> params) {

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

		dService.deviceDelete(params);
		result = dService.deviceSave(params);

		if (result >= 1)
			return "SUCCESS";
		else
			return "FAIL";

	}

	@ResponseBody
	@RequestMapping(value = "dshow", method = RequestMethod.POST)
	public JSONObject dshow(HttpSession session, Model model, PolicyDeviceVo vo) {
		System.out.println("asd" + vo.getSm_seq());
		JSONObject data = new JSONObject();
		try {
			vo = dService.deviceApplcView(vo);
			data.put("dataInfo", vo);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		return data;

	}

	@RequestMapping(value = "dManagePop", method = RequestMethod.POST)
	public String dManagePop() {
		return "/policy/deviceManagePop";
	}

	@ResponseBody
	@RequestMapping(value = "dManagePopList", method = RequestMethod.POST)
	public Map<String, Object> dManagePopList(PolicyDeviceVo vo, PagingVo pagingVo,
			HttpSession session, HttpServletRequest request) {
		Map<String, Object> jsonObject = new HashMap<String, Object>();
		JSONArray ja = new JSONArray();
		LoginVO lvo = AuthUtil.getLoginSessionInfo();
		vo.setDomain(lvo.getDomain());
		// 페이징
		pagingVo.setCurrentPage(vo.getMngeListInfoCurrentPage());
		pagingVo = PagingUtil.setDefaultPaging(PagingUtil.LayerPopupPaging, pagingVo); // recordSize,
																						// currentPage,
																						// blockSize
		int cnt = policyDeviceMapper.devicePopCount(vo);
		pagingVo.setTotalRecordSize(cnt);
		pagingVo = PagingUtil.setPaging(pagingVo);


		try {
			List<PolicyDeviceVo> gbList = dService.dManagePopList(vo, pagingVo);

			jsonObject.put("list", gbList);
			jsonObject.put("mngeVo", vo);
			jsonObject.put("pagingVo", pagingVo);
			jsonObject.put("success", true);
		} catch (Exception e) {
			jsonObject.put("success", false);
			logger.error(e.getMessage(), e);
		}

		return jsonObject;
	}


	@ResponseBody
	@RequestMapping(value = "/dManagePopSave", method = RequestMethod.POST)
	public Map<String, Object> dManagePopSave(HttpSession session, PolicyDeviceVo vo)
			throws Exception {
		Map<String, Object> jsonObject = new HashMap<String, Object>();
		LoginVO lvo = AuthUtil.getLoginSessionInfo();
		vo.setDomain(lvo.getDomain());
		try {
			dService.devicePopSave(vo);

			jsonObject.put("msg", Constant.Board.SUCCESS_GROUP_BOARD);
			jsonObject.put("success", true);

		} catch (SQLException sqle) {
			logger.error(sqle.getMessage(), sqle);
			jsonObject.put("msg", Constant.Board.SUCCESS_FAIL);
			jsonObject.put("success", false);
		} catch (DataIntegrityViolationException dive) {
			logger.error(dive.getMessage(), dive);
			jsonObject.put("msg", Constant.Board.SUCCESS_FAIL);
			jsonObject.put("success", false);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			jsonObject.put("msg", Constant.Board.SUCCESS_FAIL);
			jsonObject.put("success", false);
		}
		return jsonObject;
	}

	@ResponseBody
	@RequestMapping(value = "/dManagePopDelete", method = RequestMethod.POST)
	public Map<String, Object> dManagePopDelete(HttpSession session, PolicyDeviceVo vo)
			throws Exception {
		Map<String, Object> jsonObject = new HashMap<String, Object>();

		try {
			dService.devicePopDelete(vo);

			jsonObject.put("msg", Constant.Board.SUCCESS_GROUP_BOARD);
			jsonObject.put("success", true);

		} catch (SQLException sqle) {
			logger.error(sqle.getMessage(), sqle);
			jsonObject.put("msg", Constant.Board.SUCCESS_FAIL);
			jsonObject.put("success", false);
		} catch (DataIntegrityViolationException dive) {
			logger.error(dive.getMessage(), dive);
			jsonObject.put("msg", Constant.Board.SUCCESS_FAIL);
			jsonObject.put("success", false);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			jsonObject.put("msg", Constant.Board.SUCCESS_FAIL);
			jsonObject.put("success", false);
		}
		return jsonObject;
	}


}
