package com.controller.curl.agentjob;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class HashTest {
// 	public static void main(String[] args) {
// 		// TODO Auto-generated method stub
// 		String str = "http://sex.com:80";
// //		String str = "http://hotsexytsxx.livesexet.com:80";
// 		String hashStr = createHash(str);
// 		System.out.println("str : " + str + ", hashStr : " + hashStr);
		
		
// 	}

	public static String createHash(String str) {
		String hashString = "";
	
		try {
            MessageDigest md = MessageDigest.getInstance("MD5"); // SHA-256, MD5
            md.update(str.getBytes());
//            md.update("http://xvideo.com:80".getBytes());
//            md.update("http://hotsexytsxx.livesexet.com:80".getBytes());
            
            byte byteData[] = md.digest();
 
            StringBuffer sb = new StringBuffer(); 
            for(int i=0; i<byteData.length; i++) {
                sb.append(Integer.toString((byteData[i]&0xff) + 0x100, 16).substring(1));
            }
 
            String retVal = sb.toString();
//            System.out.println(retVal); 
            hashString = retVal;
        } catch(NoSuchAlgorithmException e){
            e.printStackTrace(); 
        }
		
		return hashString;
	}
}
