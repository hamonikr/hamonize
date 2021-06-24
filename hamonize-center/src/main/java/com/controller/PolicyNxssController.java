package com.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.model.HmprogramVo;
import com.model.OrgVo;
import com.model.PolicyProgramVo;
import com.service.HmprogramService;
import com.service.OrgService;
import com.service.PolicyProgramService;

@Controller
@RequestMapping("/gplcs")
public class PolicyNxssController {
	
	@Autowired
	private OrgService oService;
	
	@Autowired
	private PolicyProgramService pService;
	
	@Autowired
	private HmprogramService hmprogramService;
	
	@RequestMapping("/nmanage")
	public String manage(HttpSession session, Model model) {
		
		JSONArray jsonArray = new JSONArray();
		List<PolicyProgramVo> pList = null;

		try {
			OrgVo orgvo = new OrgVo();
			PolicyProgramVo vo = new PolicyProgramVo();
			jsonArray = oService.orgList(orgvo);
			pList = pService.programList(vo);
		
		} catch (Exception e) {
			e.printStackTrace();
			// FAIL_GET_LIST
		}
		System.out.println("pList=="+pList);
		model.addAttribute("oList", jsonArray);
		model.addAttribute("pList",pList);
		
		return "/policy/programManage";
		
	}
	
}
