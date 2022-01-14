package com.controller;

import java.io.Serializable;
import java.security.KeyPair;
import java.security.NoSuchAlgorithmException;
import java.security.PrivateKey;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.model.LoginVO;
import com.service.LoginService;
import com.util.RSAUtil;
import com.util.SHA256Util;

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


@Controller
@RequestMapping("/login")
public class LoginController implements Serializable {

	private static final long serialVersionUID = -2588429989351863115L;

	private Logger logger = LoggerFactory.getLogger(this.getClass());

	@Autowired
	private LoginService loginService;


	@RequestMapping(value = "/login", method = RequestMethod.GET)
	public String login(HttpSession session, HttpServletRequest request,Model model) throws NoSuchAlgorithmException {

		// 세션에 남아있을지도 몰라서 생성 전에 제거
		request.getSession().removeAttribute(RSAUtil.PRIVATE_KEY);
		KeyPair keys = RSAUtil.genKey();
		// Key 생성
		// 개인키는 세션에 저장
		request.getSession().setAttribute(RSAUtil.PRIVATE_KEY, keys.getPrivate());
		request.getSession().setMaxInactiveInterval(-1);
		// 클라이언트 공개키 생성을 위한 파라미터
		Map<String, String> spec = RSAUtil.getKeySpec(keys.getPublic());
		request.setAttribute(RSAUtil.PUBLIC_KEY_MODULUS, spec.get(RSAUtil.PUBLIC_KEY_MODULUS));
		request.setAttribute(RSAUtil.PUBLIC_KEY_EXPONENT, spec.get(RSAUtil.PUBLIC_KEY_EXPONENT));
		request.setAttribute(RSAUtil.PUBLIC_KEY, keys.getPublic()); // 사용X

		return "/login/login";
	}

	@RequestMapping(value = "/insession", method = RequestMethod.POST)
	@ResponseBody
	public String insession(HttpServletRequest request, HttpServletResponse response,
			@RequestParam Map<String, Object> params, ModelMap model) throws Exception {

		String pass_wd = request.getParameter("pass_wd");
		LoginVO salt_vo = loginService.getSalt(params);

		PrivateKey pk = (PrivateKey)request.getSession().getAttribute(RSAUtil.PRIVATE_KEY);
		
		// 생성한 개인키가 없으면 잘못된 요청으로 처리
		if(pk == null) { 
			logger.error("=======================Private Key is Null"); 
			throw new Exception(); 
		}
		pass_wd = RSAUtil.decryptRSA(pass_wd, pk);
		logger.info("pk >>>> {}",pk);
		logger.info("pass_wd >>>> {}",pass_wd);
		
		params.put("pass_wd", SHA256Util.getEncrypt(pass_wd, salt_vo.getSalt()));

		LoginVO lvo = loginService.getLoginInfo(params);
		System.out.println("lvo======"+lvo);
		String result = "0";

		if(loginService.getLoginFailCount(params) >= 5){
			result = "5";
			return result;
		} else if (lvo == null || lvo.getUser_id() == null) {
			loginService.updateLoginFailCount(params);
			if(loginService.getLoginFailCount(params) >= 5){
				loginService.updateLoginStatus(params);
			}
			return result;
		} else if("D".equals(lvo.getStatus())){
			result = "3";
		}else {

			request.getSession().setAttribute("userSession", lvo);
			lvo.setUser_ip(request.getRemoteAddr());
			lvo.setLoginKey(loginService.getSeqMax());
			loginService.insertLoginInfo(lvo);
			loginService.updateLoginFailCountInit(params);
			result = "1";

		}
		request.getSession().removeAttribute(RSAUtil.PRIVATE_KEY);
		return result;
	}

	@RequestMapping(value = "/logout", method = RequestMethod.GET)
	public String logout(HttpServletRequest request, ModelMap model) throws Exception {
		SimpleDateFormat format1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date time = new Date();
		String time1 = format1.format(time);
		LoginVO lvo = (LoginVO) request.getSession().getAttribute("userSession");
		
//		logger.info("logout----------->{}", lvo.getUser_id(),">>> ");
		
		String rtnUrl = "/login/login";

		if (lvo != null) {
			loginService.updateLoginInfo(lvo);
		}

		request.getSession().invalidate();
		model.clear();

		return "redirect:" + rtnUrl;

	}

}
