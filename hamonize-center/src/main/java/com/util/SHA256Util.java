package com.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Random;

public class SHA256Util {
	
	public static String getEncrypt(String source, String salt) {
        return getEncrypt(source, salt.getBytes());
    }
    
    public static String getEncrypt(String source, byte[] salt) {
        
        String result = "";
        
        byte[] a = source.getBytes();
        byte[] bytes = new byte[a.length + salt.length];
        
        System.arraycopy(a, 0, bytes, 0, a.length);
        System.arraycopy(salt, 0, bytes, a.length, salt.length);
        
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            md.update(bytes);
            
            byte[] byteData = md.digest();
            
            StringBuffer sb = new StringBuffer();
            for (int i = 0; i < byteData.length; i++) {
                sb.append(Integer.toString((byteData[i] & 0xFF) + 256, 16).substring(1));
            }
            
            result = sb.toString();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        
        return result;
    }
    
    public static String generateSalt() {
//        Random random = new Random();
//        
//        byte[] salt = new byte[8];
//        random.nextBytes(salt);
//        
//        StringBuffer sb = new StringBuffer();
//        for (int i = 0; i < salt.length; i++) {
//            // byte 값을 Hex 값으로 바꾸기.
//            sb.append(String.format("%02x",salt[i]));
//        }
//        
//        return sb.toString();
        return "hamoneyes";
    }
}
