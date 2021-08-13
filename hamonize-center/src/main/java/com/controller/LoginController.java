package com.controller;

import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.model.LoginVO;
import com.service.LoginService;
import com.util.StringUtil;

@Controller
@RequestMapping("/login")
public class LoginController implements Serializable {

	private static final long serialVersionUID = -2588429989351863115L;
	@Autowired
	private LoginService loginService;

	@RequestMapping("/login")
	public String login(HttpSession session, Model model) {
		return "/login/login";
	}

	@RequestMapping(value = "/insession.do")
	@ResponseBody
	public String insession(HttpServletRequest request, HttpServletResponse response,
			@RequestParam Map<String, Object> params, ModelMap model) throws Exception {
		String clientIp = params.get("user_ip").toString();
		Map<String, Object> param = new HashMap<String, Object>();

		String pass_wd = request.getParameter("pass_wd");
		params.put("pass_wd", StringUtil.EncodingSHA256(pass_wd));
		System.out.println("id===" + params.get("user_id"));
		System.out.println("passwd===" + params.get("pass_wd"));

		LoginVO lvo = loginService.getLoginInfo(params);
		String result = "0";

		System.out.println("lvo all : " + lvo.toString());
		System.out.println("lvo : " + lvo.getUser_id());

		if (lvo == null || lvo.getUser_id() == null) {
			System.out.println("aaa result > " + result);
			return result;
		} else {
			System.out.println("login");
			request.getSession().setAttribute("userSession", lvo);
			lvo.setUser_ip(request.getRemoteAddr());
			lvo.setLoginKey(loginService.getSeqMax());
			loginService.insertLoginInfo(lvo);

			result = "1";
			System.out.println("bbb result > " + result);

			return result;

		}

	}

	@RequestMapping("/logout.do")
	public String logout(HttpServletRequest request, ModelMap model) throws Exception {
		SimpleDateFormat format1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date time = new Date();
		String time1 = format1.format(time);
		System.out.println(time1 + "로그아웃");
		LoginVO lvo = (LoginVO) request.getSession().getAttribute("userSession");
		String rtnUrl = "/login/login.do";

		if (lvo != null) {
			loginService.updateLoginInfo(lvo);



		}


		request.getSession().invalidate();
		model.clear();

		return "redirect:" + rtnUrl;

	}

}
