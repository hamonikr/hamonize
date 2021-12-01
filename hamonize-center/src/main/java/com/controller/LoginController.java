package com.controller;

import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.model.LoginVO;
import com.service.LoginService;
import com.util.SHA256Util;
import com.util.StringUtil;


@Controller
@RequestMapping("/login")
public class LoginController implements Serializable {

	private static final long serialVersionUID = -2588429989351863115L;

	private Logger logger = LoggerFactory.getLogger(this.getClass());

	@Autowired
	private LoginService loginService;


	@RequestMapping(value = "/login", method = RequestMethod.GET)
	public String login(HttpSession session, Model model) {

		return "/login/login";
	}

	@RequestMapping(value = "/insession.do", method = RequestMethod.POST)
	@ResponseBody
	public String insession(HttpServletRequest request, HttpServletResponse response,
			@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

		String pass_wd = request.getParameter("pass_wd");
		LoginVO salt_vo = loginService.getSalt(params);

		params.put("pass_wd", SHA256Util.getEncrypt(pass_wd, salt_vo.getSalt()));

		LoginVO lvo = loginService.getLoginInfo(params);
		String result = "0";

		if (lvo == null || lvo.getUser_id() == null) {
			loginService.updateLoginFailCount(params);
			return result;
		} else if(loginService.getLoginFailCount(params) > 4){
			result = "5";
			return result;
		} else if("D".equals(lvo.getGubun())){
			result = "3";
			return result;
		}else {

			request.getSession().setAttribute("userSession", lvo);
			lvo.setUser_ip(request.getRemoteAddr());
			lvo.setLoginKey(loginService.getSeqMax());
			loginService.insertLoginInfo(lvo);

			result = "1";

			return result;

		}

	}

	@RequestMapping(value = "/logout.do", method = RequestMethod.GET)
	public String logout(HttpServletRequest request, ModelMap model) throws Exception {
		SimpleDateFormat format1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date time = new Date();
		String time1 = format1.format(time);
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
