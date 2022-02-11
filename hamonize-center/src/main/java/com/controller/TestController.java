package com.controller;


import java.util.Random;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.GlobalPropertySource;
import com.model.OrgVo;
import com.service.OrgService;
import com.util.LDAPConnection;


@Controller
@RequestMapping("/test")
public class TestController {
	@Autowired
	private OrgService oService;
	@Autowired
	GlobalPropertySource gs;


	private Logger logger = LoggerFactory.getLogger(this.getClass());

	@RequestMapping("/layout")
	public String test(HttpSession session, Model model, HttpServletRequest request) {

		JSONArray jsonArray = new JSONArray();

		try {
			// 저장된 조직 정보 출력
			OrgVo orgvo = new OrgVo();
			jsonArray = oService.orgList(orgvo);

		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		LDAPConnection con = new LDAPConnection();

		try {
			con.connection(gs.getLdapUrl(), gs.getLdapPassword());
		} catch (NamingException e1) {
			logger.error(e1.getMessage(), e1);
		}

		model.addAttribute("oList", jsonArray);
		
		return "/test2";
//		return "/test";

	}

	@RequestMapping("/layout2")
	public String test2(HttpSession session, Model model, HttpServletRequest request) {

		JSONArray jsonArray = new JSONArray();

		try {
			// 저장된 조직 정보 출력
			OrgVo orgvo = new OrgVo();
			jsonArray = oService.orgList(orgvo);

		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		LDAPConnection con = new LDAPConnection();

		try {
			con.connection(gs.getLdapUrl(), gs.getLdapPassword());
		} catch (NamingException e1) {
			logger.error(e1.getMessage(), e1);
		}

		model.addAttribute("oList", jsonArray);
		
		return "/test";

	}
	
//	public static void main(String[] args)  {
//		java.util.Random generator = new java.util.Random();
//        generator.setSeed(System.currentTimeMillis());
//        System.out.println(generator.nextInt(1000000) % 1000000);
//    }
}
