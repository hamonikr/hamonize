package com.controller;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mapper.IHmprogramMapper;
import com.model.GroupVo;
import com.model.HmprogramVo;
import com.model.NotiVo;
import com.model.SoliderVo;
import com.paging.PagingUtil;
import com.paging.PagingVo;
import com.service.GroupService;
import com.service.HmprogramService;
import com.util.Constant;


@Controller
@RequestMapping("/securityTmp")
public class SecurityControllerTMP_X {

	@Autowired
	private GroupService gService;
	
	@Autowired
	private HmprogramService hmprogramService;

	@Autowired
	private IHmprogramMapper hmprogramMapper;

	
	
	
	
	/**
	 * 업데이트 관리 페이지
	 * 
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/updateManagement")
	public String updateManagementPage(Model model) {
		//log.info(" -- ctr:updateManagementPage");
		JSONArray groupList = null;

		try {
			GroupVo gvo = new GroupVo();
			groupList = gService.groupList(gvo);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		model.addAttribute("gList", groupList);

		return "/secrty/updateManagement";
	}

	/**
	 * 프로그램 관리 페이지
	 * 
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/programManagement")
	public String programManagementPage(Model model) {
		//log.info(" -- ctr:programManagementPage");
		JSONArray groupList = null;

		try {
			GroupVo gvo = new GroupVo();
//			gvo.setGroup_gubun("group");
			groupList = gService.groupList(gvo);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		model.addAttribute("gList", groupList);

		return "/secrty/programManagement";
	}
	
	
	@ResponseBody
	@RequestMapping("programManagement.proc")
	public Map<String, Object> programManagementProc(HmprogramVo vo, PagingVo pagingVo, HttpSession session,
			HttpServletRequest request) {

		Map<String, Object> jsonObject = new HashMap<String, Object>();

		// 페이징
		pagingVo.setCurrentPage(vo.getHmProgramListInfoCurrentPage());
		pagingVo = PagingUtil.setDefaultPaging(PagingUtil.DefaultPaging, pagingVo);

		int cnt = Integer.parseInt(hmprogramMapper.countHmPcProgramListInfo(vo) + "");
		pagingVo.setTotalRecordSize(cnt);
		pagingVo = PagingUtil.setPaging(pagingVo);

		try {
			List<HmprogramVo> gbList = hmprogramService.soliderList(vo, pagingVo);
			jsonObject.put("list", gbList);
			jsonObject.put("pagingVo", pagingVo);

			jsonObject.put("success", true);
		} catch (Exception e) {
			jsonObject.put("success", false);
			e.printStackTrace();
		}

		return jsonObject;
	}

	
	@ResponseBody
	@RequestMapping(value="programManagementInsert.proc", method=RequestMethod.POST)
	public Map<String, Object> programManagementInsertProc(HttpSession session, HmprogramVo hVo) throws Exception {
		
		System.out.println("hVo==="+ hVo);
		System.out.println("hVo==="+ hVo.getOrgNmCheckedList()[0]);
		System.out.println("hVo==="+ hVo.getProgrmCheckedList());
		
		Map<String, Object> jsonObject = new HashMap<String, Object>();
		
		
		try {
			hmprogramService.programManagementInsert(hVo);
			
			jsonObject.put("msg", Constant.Board.SUCCESS_GROUP_BOARD);
			jsonObject.put("success", true);
			
		} catch (SQLException sqle) {
			sqle.printStackTrace();
			jsonObject.put("msg", Constant.Board.SUCCESS_FAIL);
			jsonObject.put("success", false);
		} catch (DataIntegrityViolationException dive ){
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

	
	
	/**
	 * 보안관리 페이지
	 * 
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/securityManagement")
	public String securityManagementPage(Model model) {
		//log.info(" -- ctr:securityManagementPage");
		JSONArray groupList = null;

		try {
			GroupVo gvo = new GroupVo();
			groupList = gService.groupList(gvo);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		model.addAttribute("gList", groupList);

		return "/secrty/securityManagement";
	}
}
