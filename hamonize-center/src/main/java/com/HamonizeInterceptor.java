package com;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.service.IpManagementService;

@Component
public class HamonizeInterceptor extends HandlerInterceptorAdapter {
	
	@Autowired
	private IpManagementService iService;

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
	
		//ip체크
		Map<String, Object> param = new HashMap<String, Object>();
		try {
			 HttpSession session = request.getSession();
			 if(session.getAttribute("userSession") == null) {
				 response.sendRedirect("/login/login");
				 return false;
			 }
	
		// 	 String clientIp = null;
		// 	 clientIp = request.getHeader("X-Forwarded-For");
		//         if (clientIp == null || clientIp.length() == 0 || "unknown".equalsIgnoreCase(clientIp)) { 
		//         	clientIp = request.getHeader("Proxy-Client-IP"); 
		//         	System.out.println("clientIp111==="+clientIp);
		//         } 
		//         if (clientIp == null || clientIp.length() == 0 || "unknown".equalsIgnoreCase(clientIp)) { 
		//         	clientIp = request.getHeader("WL-Proxy-Client-IP"); 
		//         	System.out.println("clientIp222==="+clientIp);
		//         } 
		//         if (clientIp == null || clientIp.length() == 0 || "unknown".equalsIgnoreCase(clientIp)) { 
		//         	clientIp = request.getHeader("HTTP_CLIENT_IP"); 
		//         	System.out.println("clientIp333==="+clientIp);
		//         } 
		//         if (clientIp == null || clientIp.length() == 0 || "unknown".equalsIgnoreCase(clientIp)) { 
		//             clientIp = request.getHeader("HTTP_X_FORWARDED_FOR"); 
		//             System.out.println("clientIp444==="+clientIp);
		//         }
		//         if (clientIp == null || clientIp.length() == 0 || "unknown".equalsIgnoreCase(clientIp)) { 
		//             clientIp = request.getHeader("X-Real-clientIp"); 
		//             System.out.println("clientIp555==="+clientIp);
		//         }
		//         if (clientIp == null || clientIp.length() == 0 || "unknown".equalsIgnoreCase(clientIp)) { 
		//             clientIp = request.getHeader("X-RealclientIp"); 
		//             System.out.println("clientIp666==="+clientIp);
		//         }
		//         if (clientIp == null || clientIp.length() == 0 || "unknown".equalsIgnoreCase(clientIp)) { 
		//             clientIp = request.getHeader("REMOTE_ADDR");
		//             System.out.println("clientIp777==="+clientIp);
		//         }
		//         if (clientIp == null || clientIp.length() == 0 || "unknown".equalsIgnoreCase(clientIp)) { 
		//             clientIp = request.getRemoteAddr(); 
		//             System.out.println("clientIp888==="+clientIp);
		//         }
		        
		// if(clientIp != null || "".equals(clientIp)){
		// 	System.out.println("===========================================");
		// 	System.out.println("들어오는 아이피 ===="+clientIp);
		// 	System.out.println("===========================================");
		// 	String[] dotIPs = clientIp.split("\\.");
		// 	String[] ips = new String[15];
		// 	ips[0] = dotIPs[0] + "." + dotIPs[1] + "."  + dotIPs[2] + "." + dotIPs[3];
		// 	ips[1] = "*." + dotIPs[1] + "."  + dotIPs[2] + "." + dotIPs[3];
	    // 	ips[2] = dotIPs[0] + ".*."  + dotIPs[2] + "." + dotIPs[3];
	    // 	ips[3] = dotIPs[0] + "." + dotIPs[1] + ".*." + dotIPs[3];
	    // 	ips[4] = dotIPs[0] + "." + dotIPs[1] + "."  + dotIPs[2] + ".*";
	    // 	ips[5] = "*.*."  + dotIPs[2] + "." + dotIPs[3];
	    // 	ips[6] = "*." + dotIPs[1] + ".*." + dotIPs[3];
	    // 	ips[7] = "*." + dotIPs[1] + "."  + dotIPs[2] + ".*";
	    // 	ips[8] = dotIPs[0] + ".*.*." + dotIPs[3];
	    // 	ips[9] = dotIPs[0] + ".*." + dotIPs[2] + ".*";
	    // 	ips[10] = dotIPs[0] +"."+ dotIPs[1]+"." + "*.*";
	    // 	ips[11] = "*.*.*." + dotIPs[3];
	    // 	ips[12] = "*.*." + dotIPs[2] + ".*";
	    // 	ips[13] = "*." + dotIPs[1] + ".*.*";
	    // 	ips[14] = dotIPs[0] + ".*.*.*";
	    // 	for(int i = 0; i<ips.length;i++){
	    // 		param.put("usr_ip"+i,ips[i]);
	    // 	}
		// }else{
    	// 	return false;
		// }
		// int cnt = iService.ipCheck(param);
	
		}catch(NullPointerException e) {
			e.printStackTrace();
			System.out.println(e);
		}
		
		return super.preHandle(request, response, handler);
	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
		super.postHandle(request, response, handler, modelAndView);
	}

	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex)
			throws Exception {
		super.afterCompletion(request, response, handler, ex);
	}
	
}
