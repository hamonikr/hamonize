package com.util;

import java.util.regex.Pattern;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public class EgovWebUtil {
	
	public static String cookieRead( HttpServletRequest request, String chk){
		// 쿠키값 가져오기
		Cookie[] cookies = request.getCookies();
		String cValue = "";
		if (cookies != null) {
			for (int i = 0; i < cookies.length; i++) {
				Cookie c = cookies[i];
				// 저장된 쿠키 이름을 가져온다
				String cName = c.getName();
				// 쿠키값을 가져온다

				if( cName.equals(chk)){
					cValue = c.getValue();	
				}
			}
		}
		return cValue;
	}
	
	public static void cookieMake(HttpServletRequest request, HttpServletResponse response, String hn){
		
		Cookie cookie = new Cookie("HTGno", hn);
	    cookie.setMaxAge(60*60*24*365);            // 쿠키 유지 기간 - 1년
	    cookie.setPath("/");                               // 모든 경로에서 접근 가능하도록 
	    response.addCookie(cookie);                // 쿠키저장
	    
	}
	public static String clearXSSMinimum(String value) {
		if (value == null || value.trim().equals("")) {
			return "";
		}
		
		String returnValue = value;

		returnValue = returnValue.replaceAll("&", "&amp;");
		returnValue = returnValue.replaceAll("<", "&lt;");
		returnValue = returnValue.replaceAll(">", "&gt;");
		returnValue = returnValue.replaceAll("\"", "&#34;");
		returnValue = returnValue.replaceAll("\'", "&#39;");
		return returnValue;
	}

	public static String clearXSSMaximum(String value) {
		String returnValue = value;
		returnValue = clearXSSMinimum(returnValue);

		returnValue = returnValue.replaceAll("%00", null);

		returnValue = returnValue.replaceAll("%", "&#37;");

		// \\. => .

		returnValue = returnValue.replaceAll("\\.\\./", ""); // ../
		returnValue = returnValue.replaceAll("\\.\\.\\\\", ""); // ..\
		returnValue = returnValue.replaceAll("\\./", ""); // ./
		returnValue = returnValue.replaceAll("%2F", "");

		return returnValue;
	}

	public static String filePathBlackList(String value) {
		String returnValue = value;
		if (returnValue == null || returnValue.trim().equals("")) {
			return "";
		}

		returnValue = returnValue.replaceAll("\\.\\./", ""); // ../
		returnValue = returnValue.replaceAll("\\.\\.\\\\", ""); // ..\

		return returnValue;
	}

	/**
	 * 행안부 보안취약점 점검 조치 방안.
	 *
	 * @param value
	 * @return
	 */
	public static String filePathReplaceAll(String value) {
		String returnValue = value;
		if (returnValue == null || returnValue.trim().equals("")) {
			return "";
		}

		returnValue = returnValue.replaceAll("/", "");
		returnValue = returnValue.replaceAll("\\", "");
		returnValue = returnValue.replaceAll("\\.\\.", ""); // ..
		returnValue = returnValue.replaceAll("&", "");

		return returnValue;
	}

	public static String filePathWhiteList(String value) {
		return value; // TODO
	}
	
	 public static boolean isIPAddress(String str) {
		Pattern ipPattern = Pattern.compile("\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}");
		
		return ipPattern.matcher(str).matches();
    }
	 
	 public static String removeCRLF(String parameter) {
		 return parameter.replaceAll("\r", "").replaceAll("\n", "");
	 }
	 
	 public static String removeSQLInjectionRisk(String parameter) {
		 return parameter.replaceAll("\\p{Space}", "").replaceAll("\\*", "").replaceAll("%", "").replaceAll(";", "").replaceAll("-", "").replaceAll("\\+", "").replaceAll(",", "");
	 }
	 
	 public static String removeOSCmdRisk(String parameter) {
		 return parameter.replaceAll("\\p{Space}", "").replaceAll("\\*", "").replaceAll("|", "").replaceAll(";", "");
	 }
	 
	 
    /*
    public static void main(String[] args) {
	String test = null;
	
	test = "<script language='javascript' encoding=\"utf-8\">q&a</script>";
	System.out.println("clearXSSMinimum() Test");
	System.out.println(test);
	System.out.println("=>");
	System.out.println(clearXSSMinimum(test));
	System.out.println();
	
	test = "/a/b/c../..\\";
	System.out.println("clearXSSMaximum() Test");
	System.out.println(test);
	System.out.println(" =>");
	System.out.println(clearXSSMaximum(test));
	System.out.println();
	
	test = "/a/b/c/../../../..\\..\\";
	System.out.println("filePathBlackList() Test");
	System.out.println(test);
	System.out.println("=>");
	System.out.println(filePathBlackList(test));
	System.out.println();
	
	test = "192.168.0.1";
	System.out.println("isIPAddress() test");
	System.out.println("IP : " + test + " => " + isIPAddress(test));
	
	test = "abc def*%;-+,ghi";
	System.out.println("removeSQLInjectionRisk() test");
	System.out.println(test + " => " + removeSQLInjectionRisk(test));
    }
    //*/

}