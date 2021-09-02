package com.controller;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.parser.ParseException;
import org.slf4j.LoggerFactory;
import org.slf4j.Logger;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mapper.IGroupMapper;
import com.model.BackupCycleVo;
import com.model.GroupVo;
import com.model.RecoveryVo;
import com.service.BackupCycleService;
import com.service.BackupRecoveryService;
import com.service.GroupService;
import com.util.Constant;
import com.util.EgovWebUtil;



@Controller
@RequestMapping("/backupRecovery")
public class BackupRecoveryContoller extends EgovWebUtil {

	@Autowired
	private GroupService gService;

	@Autowired
	private IGroupMapper groupMapper;


	@Autowired
	private BackupCycleService backupCycleService;


	@Autowired
	private BackupRecoveryService restoreRecoveryService;

	private Logger logger = LoggerFactory.getLogger(this.getClass());


	/**
	 * 백업 주기 설정 페이지
	 * 
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/backupCycle", method = RequestMethod.POST)
	public String backupCyclePage(Model model) {
		JSONArray groupList = null;

		try {
			GroupVo gvo = new GroupVo();
			gvo.setGroup_gubun("group");
			groupList = gService.groupList(gvo);
		} catch (ParseException e) {
			logger.error(e.getMessage(), e);;
		}
		model.addAttribute("gList", groupList);

		return "/backupRecovery/backupCycle";
	}


	/**
	 * 백업주기 리스트 프로시
	 * 
	 * @param vo
	 * @param session
	 * @param request
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "backupCycle.proc", method = RequestMethod.POST)
	public Map<String, Object> backupCycleProc(BackupCycleVo vo, HttpSession session,
			HttpServletRequest request) {

		Map<String, Object> jsonObject = new HashMap<String, Object>();

		try {
			BackupCycleVo backupCycleList = backupCycleService.backupCycleList(vo);

			GroupVo gvo = new GroupVo();
			System.out.println("vo.getSelectOrgUpperCode()===" + vo.getSelectOrgUpperCode());
			gvo.setOrgupcodename(vo.getSelectOrgUpperCode());
			System.out.println("gvo=== " + gvo);

			List<GroupVo> sgbGroup = groupMapper.groupSgbList(gvo);

			jsonObject.put("backupCycleData", backupCycleList);
			jsonObject.put("sgblist", sgbGroup);

			jsonObject.put("success", true);
		} catch (Exception e) {
			jsonObject.put("success", false);
			logger.error(e.getMessage(), e);;
		}

		return jsonObject;
	}



	/**
	 * 백업주기 등록
	 * 
	 * @param session
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value = "backupCycleInsert.proc", method = RequestMethod.POST)
	public Map<String, Object> backupCycleInsertProc(HttpSession session, BackupCycleVo vo)
			throws Exception {

		Map<String, Object> jsonObject = new HashMap<String, Object>();

		try {
			backupCycleService.backupCycleInsert(vo);

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


	// =========================================================


	/**
	 * 복구 페이지
	 * 
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/restoreRecovery", method = RequestMethod.POST)
	public String restoreRecoveryPage(Model model) {
		JSONArray groupList = null;

		try {
			GroupVo gvo = new GroupVo();
			groupList = gService.groupList(gvo);
		} catch (ParseException e) {
			logger.error(e.getMessage(), e);;
		}
		model.addAttribute("gList", groupList);

		return "/backupRecovery/restoreRecovery";
	}


	/**
	 * 복구 리스트 프로시
	 * 
	 * @param vo
	 * @param session
	 * @param request
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "restoreRecovery.proc", method = RequestMethod.POST)
	public Map<String, Object> restoreRecoveryProc(RecoveryVo vo, HttpSession session,
			HttpServletRequest request) {

		Map<String, Object> jsonObject = new HashMap<String, Object>();

		try {
			HashMap<String, Object> recoveryList = restoreRecoveryService.restoreRecoveryList(vo);

			GroupVo gvo = new GroupVo();
			System.out.println("vo.getSelectOrgUpperCode()===" + vo.getSelectOrgUpperCode());
			gvo.setOrgupcodename(vo.getSelectOrgUpperCode());
			System.out.println("gvo=== " + gvo);

			List<GroupVo> sgbGroup = groupMapper.groupSgbList(gvo);

			jsonObject.put("recoveryList", recoveryList);
			jsonObject.put("sgblist", sgbGroup);

			jsonObject.put("success", true);
		} catch (Exception e) {
			jsonObject.put("success", false);
			logger.error(e.getMessage(), e);;
		}

		return jsonObject;
	}


	/**
	 * 복구 시작 프로시 - 복구로그저장
	 * 
	 * @param vo
	 * @param session
	 * @param request
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "startRecovery.proc", method = RequestMethod.POST)
	public Map<String, Object> startRecoveryProc(RecoveryVo vo, HttpSession session,
			HttpServletRequest request) {
		Map<String, Object> jsonObject = new HashMap<String, Object>();

		try {
			restoreRecoveryService.recoveryInfoInsert(vo);

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
