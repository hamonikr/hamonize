package com.controller;

import java.util.ArrayList;
import java.util.List;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.GlobalPropertySource;
import com.mapper.IOrgMapper;
import com.model.OrgVo;
import com.service.OrgService;
import com.util.LDAPConnection;


@Controller
@RequestMapping("/org/orgManage")
public class OrgController {
	@Autowired
	GlobalPropertySource gs;

	@Autowired
	private OrgService oService;
	
	@Autowired
	private IOrgMapper oMapper;
	
	/*
	 * 부서관리 페이지
	 * 
	 * @model gList : jsonGroupList
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="!type")
	public String orgList(HttpSession session, Model model,HttpServletRequest request) {
		JSONArray jsonArray = new JSONArray();

		try {
			// 저장된 조직 정보 출력 
			OrgVo orgvo = new OrgVo();
			jsonArray = oService.orgList(orgvo);
			for(int i=0;i<jsonArray.size();i++ ){
				System.out.println("org list --> "+ jsonArray.get(i).toString());
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		LDAPConnection con = new LDAPConnection();
		System.out.println("LDAPConnection ----> start....");
		
		try {
			con.connection(gs.getLdapUrl(), gs.getLdapPassword());
		} catch (NamingException e1) {
			e1.printStackTrace();
		}

		model.addAttribute("oList", jsonArray);

		return "/org/orgList";
	}
	
	@ResponseBody
	@RequestMapping(params="type=show",method=RequestMethod.POST)
	public JSONObject orgView(HttpSession session, Model model,OrgVo orgvo) {
		// 선택한 조직 정보 출력
		orgvo = oService.orgView(orgvo);
		
		JSONObject data = new JSONObject();
		data.put("seq", orgvo.getSeq());
        data.put("p_seq", orgvo.getP_seq());
        data.put("org_nm", orgvo.getOrg_nm());
        data.put("p_org_nm", orgvo.getP_org_nm());
        data.put("all_org_nm", orgvo.getAll_org_nm());
        data.put("sido", orgvo.getSido());
        data.put("gugun", orgvo.getGugun());
        data.put("section", orgvo.getSection());
        data.put("org_num", orgvo.getOrg_num());
        data.put("org_ordr", orgvo.getOrg_ordr());
		
		return data;
			
	}
	
	@ResponseBody
	@RequestMapping(params="type=save",method=RequestMethod.POST)
	public int orgSave(HttpSession session, Model model,OrgVo vo) throws Exception{
		// 조직 추가
		int result = oService.orgSave(vo);
		return result;
		
	}
	
	@ResponseBody
	@RequestMapping(params="type=delt",method=RequestMethod.POST)
	public int orgDelete(HttpSession session, Model model,OrgVo vo) throws Exception {
		int result=0;
		result = oService.orgDelete(vo);
		return result;
		
	}
}
