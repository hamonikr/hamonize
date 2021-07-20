package com.controller;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.json.simple.JSONArray;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.model.GroupVo;
import com.service.GroupService;




@Controller
@RequestMapping("/group")
public class GroupController {

	@Autowired
	private GroupService gService;

	/*
	 * 부서관리 페이지
	 * 
	 * @model gList : jsonGroupList
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/groupManagement")
	public String groupManagementPage(HttpSession session, Model model) {
		
		JSONArray groupList = null;

		try {
			GroupVo gvo = new GroupVo();
			gvo.setGroup_gubun("group");
			groupList = gService.groupList(gvo);
		} catch (ParseException e) {
			e.printStackTrace();
			// FAIL_GET_LIST
		}
		model.addAttribute("gList", groupList);

		return "/group/groupManagement";
	}
	
	
	

	/*
	 * 조직등록
	 * 
	 * @param groupVo.name
	 * @param groupVo.step
	 * @param groupVo.orguppercode
	 * @param groupVo.orgcode
	 * @return msg
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value = "/insert", method = RequestMethod.POST, produces = "application/text; charset=utf8")
	public Object groupInsert(@Valid GroupVo groupVo) {
		String msg = "";

		try {
			msg = gService.groupInsert(groupVo);
		} catch (Exception e) {
			// 에러가 구체적으로 나뉠 경우 개별로 나누어 처리
			e.printStackTrace();
		}
		return new ResponseEntity<String>(msg, HttpStatus.OK);
	}

	/*
	 * 조직삭제
	 * 
	 * @param groupVo.orguppercode
	 * @param groupVo.orgcode
	 * @return msg
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value = "/delete", method = RequestMethod.POST, produces = "application/text; charset=utf8")
	public Object groupDelete(GroupVo groupVo) {
		
		System.out.println("=groupVo==="+ groupVo);
		
		String msg = "";

		 msg = gService.groupDelete(groupVo);
		 System.out.println("con=="+ msg);
		return new ResponseEntity<String>(msg, HttpStatus.OK);
	}
	
	
	/*
	 * 부서관리
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping("/sgbManagement")
	public String sgbManagementPage(HttpSession session, Model model) {
		
		JSONArray groupList = null;

		try {
			GroupVo gvo = new GroupVo();
			gvo.setGroup_gubun("sgb");
			groupList = gService.groupList(gvo);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		model.addAttribute("gList", groupList);

		return "/group/sgbManagement";
	}
	
	@ResponseBody
	@RequestMapping(value = "/sgbInsert", method = RequestMethod.POST, produces = "application/text; charset=utf8")
	public Object sgbInsert(@Valid GroupVo groupVo) {
		String msg = "";

		try {
			groupVo.setGroup_gubun("sgb");
			msg = gService.groupInsert(groupVo);
		} catch (Exception e) {
			// 에러가 구체적으로 나뉠 경우 개별로 나누어 처리
			e.printStackTrace();
		}
		return new ResponseEntity<String>(msg, HttpStatus.OK);
	}
	
	
}
