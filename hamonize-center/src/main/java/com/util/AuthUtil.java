package com.util;

import javax.servlet.http.HttpSession;

import com.model.LoginVO;

import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

public class AuthUtil {

  public static LoginVO getLoginSessionInfo(){
    ServletRequestAttributes servletRequestAttribute = (ServletRequestAttributes) RequestContextHolder.currentRequestAttributes();
    HttpSession httpSession = servletRequestAttribute.getRequest().getSession(true);
    LoginVO lvo = (LoginVO)httpSession.getAttribute("userSession");
    return lvo;
    
  }
  
}
