package com;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.slf4j.LoggerFactory;
import org.slf4j.Logger;

import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

public class HamonizeInterceptor implements HandlerInterceptor {

	private Logger logger = LoggerFactory.getLogger(this.getClass());

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response,
			Object handler) throws Exception {

		try {
			HttpSession session = request.getSession();
			if (session.getAttribute("userSession") == null) {
				response.sendRedirect("/login/login");
				return false;
			}

		} catch (NullPointerException e) {
			logger.error("NullPointerException : {}", e.getMessage(), e);
		}

		//return super.preHandle(request, response, handler);
		return true;
	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
		//super.postHandle(request, response, handler, modelAndView);
	}


}
