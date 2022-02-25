package com.controller;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.mapper.IPolicyFireWallMapper;
import com.model.LoginVO;
// import com.hamonize.portal.user.SecurityUser;
import com.model.OrgVo;
import com.model.PolicyFireWallVo;
import com.paging.PagingUtil;
import com.paging.PagingVo;
import com.service.OrgService;
import com.service.PolicyFireWallService;
import com.util.AuthUtil;
import com.util.Constant;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/gplcs")
public class PolicyFireWallController {

	@Autowired
	private OrgService oService;

	@Autowired
	private PolicyFireWallService fService;

	@Autowired
	private IPolicyFireWallMapper policyFireWallMapper;

	private Logger logger = LoggerFactory.getLogger(this.getClass());

	@RequestMapping(value = "/fmanage", method = RequestMethod.GET)
	public String manage(HttpSession session, Model model) {

		JSONArray jsonArray = new JSONArray();
		List<PolicyFireWallVo> pList = null;
		// SecurityUser lvo = AuthUtil.getLoginSessionInfo();
		LoginVO lvo = AuthUtil.getLoginSessionInfo();
		
		try {
			OrgVo orgvo = new OrgVo();
			PolicyFireWallVo vo = new PolicyFireWallVo();
			vo.setDomain(lvo.getDomain());
			jsonArray = oService.orgList(orgvo);
			pList = fService.firewallList(vo);

		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		model.addAttribute("oList", jsonArray);
		model.addAttribute("pList", pList);

		return "/policy/fireWallManage";

	}

	@ResponseBody
	@RequestMapping(value = "/fsave", method = RequestMethod.POST)
	public JSONObject finsert(HttpSession session, Model model,
			@RequestParam Map<String, Object> params) throws ParseException {

		JSONParser jp = new JSONParser();
		String data = params.get("data").toString();
		JSONArray jsonArray = (JSONArray) jp.parse(data);
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

		//ansible 정책전달
		JSONObject jobResult = fService.applyFirewallPolicy(params);
		params.put("job_id", jobResult.get("id"));
		fService.fireWallDelete(params);
		result = fService.fireWallSave(params);
		
		JSONObject jsonObj = new JSONObject();
		if (result >= 1){
			jsonObj.put("STATUS", "SUCCESS");
			jsonObj.put("ID", jobResult.get("id"));
			jsonObj.put("JOBSTATUS", jobResult.get("status"));
		} else{
			jsonObj.put("STATUS", "FAIL");
		}
		return jsonObj;

	}

	@ResponseBody
	@RequestMapping(value = "/fshow", method = RequestMethod.POST)
	public JSONObject fshow(HttpSession session, Model model, PolicyFireWallVo vo) {
		JSONObject data = new JSONObject();
		try {
			data.put("job_id", fService.getFrwlHistoryLastJob(vo));
			vo = fService.fireWallApplcView(vo);
			data.put("dataInfo", vo);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		return data;

	}

	@RequestMapping(value = "fManagePop", method = RequestMethod.POST)
	public String dManagePop() {
		return "/policy/fireWallManagePop";
	}

	@ResponseBody
	@RequestMapping(value = "fManagePopList", method = RequestMethod.POST)
	public Map<String, Object> dManagePopList(PolicyFireWallVo vo, PagingVo pagingVo,
			HttpSession session, HttpServletRequest request) {
		Map<String, Object> jsonObject = new HashMap<String, Object>();
		JSONArray ja = new JSONArray();
		// SecurityUser lvo = AuthUtil.getLoginSessionInfo();
		LoginVO lvo = AuthUtil.getLoginSessionInfo();
		
		vo.setDomain(lvo.getDomain());
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
			logger.error(e.getMessage(), e);
		}

		return jsonObject;
	}

	@ResponseBody
	@RequestMapping(value = "/fManagePopSave", method = RequestMethod.POST)
	public Map<String, Object> dManagePopSave(HttpSession session, PolicyFireWallVo vo)
			throws Exception {
		Map<String, Object> jsonObject = new HashMap<String, Object>();
		// SecurityUser lvo = AuthUtil.getLoginSessionInfo();
		LoginVO lvo = AuthUtil.getLoginSessionInfo();
		vo.setDomain(lvo.getDomain());
		try {
			fService.fireWallPopSave(vo);

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
	@RequestMapping(value = "/fManagePopDelete", method = RequestMethod.POST)
	public Map<String, Object> dManagePopDelete(HttpSession session, PolicyFireWallVo vo)
			throws Exception {
		Map<String, Object> jsonObject = new HashMap<String, Object>();
		
		// SecurityUser lvo = AuthUtil.getLoginSessionInfo();
		LoginVO lvo = AuthUtil.getLoginSessionInfo();
		
		vo.setDomain(lvo.getDomain());
		
		try {
			fService.fireWallPopDelete(vo);

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
