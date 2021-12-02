package com.util;

import java.io.UnsupportedEncodingException;
import java.security.InvalidKeyException;
import java.security.KeyFactory;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.NoSuchAlgorithmException;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.SecureRandom;
import java.security.spec.RSAPublicKeySpec;
import java.util.HashMap;
import java.util.Map;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class RSAUtil { 

    protected final static Logger log = LoggerFactory.getLogger(RSAUtil.class);
    /* Attribute Name */ 
    public final static String PRIVATE_KEY = "privateKey" ;
    public final static String PUBLIC_KEY = "publicKey" ;
    public final static String PUBLIC_KEY_MODULUS = "publicKeyModulus" ;
    public final static String PUBLIC_KEY_EXPONENT = "publicKeyExponent" ;
    
    /** * 1024비트 RSA 키쌍을 생성합니다. */
    public static KeyPair genKey() throws NoSuchAlgorithmException { 
        SecureRandom secureRandom = new SecureRandom(); 
        KeyPairGenerator gen; gen = KeyPairGenerator.getInstance("RSA"); 
        gen.initialize(1024, secureRandom); 
        KeyPair keyPair = gen.genKeyPair(); 
        return keyPair; 
    }

    /** * Private Key로 RAS 복호화를 수행합니다. 
     * @param encrypted 암호화된 이진데이터를 base64 인코딩한 문자열 입니다. 
     * @param privateKey 복호화를 위한 개인키 입니다. 
     * @return * @throws Exception */
    public static String decryptRSA(String encrypted, PrivateKey privateKey) throws NoSuchPaddingException, NoSuchAlgorithmException, InvalidKeyException, BadPaddingException, IllegalBlockSizeException, UnsupportedEncodingException { 
        if (privateKey == null) { 
            log.error("====================암호화 비밀키 정보를 찾을 수 없습니다.\n encrypted="+encrypted); 
             //throw new Exception("잘못된 요청입니다."); 
            } 
            String decrypted = ""; 
            try { 
                Cipher cipher = Cipher.getInstance("RSA"); 
                byte[] encryptedBytes = hexToByteArray(encrypted); 
                cipher.init(Cipher.DECRYPT_MODE, privateKey); 
                byte[] decryptedBytes = cipher.doFinal(encryptedBytes); 
                decrypted = new String(decryptedBytes, "utf-8"); // 문자 인코딩 주의. 
            } catch (Exception ex) { log.error(ex.getMessage()); } 
            return decrypted; 
        } 
        
        /** * 16진 문자열을 byte 배열로 변환한다. */ 
        public static byte[] hexToByteArray(String hex) { 
            if (hex == null || hex.length() % 2 != 0) { return new byte[]{}; } 
            byte[] bytes = new byte[hex.length() / 2]; 
            for (int i = 0; i < hex.length(); i += 2) { 
                byte value = (byte)Integer.parseInt(hex.substring(i, i + 2), 16); 
                bytes[(int) Math.floor(i / 2)] = value; } return bytes; 
        } 

        public static Map<String, String> getKeySpec(PublicKey publicKey) { 
            Map<String, String> spec = new HashMap<String, String>(); 
            try { 
                KeyFactory keyFactory = KeyFactory.getInstance("RSA"); 
                RSAPublicKeySpec publicSpec = (RSAPublicKeySpec) 
                keyFactory.getKeySpec(publicKey, RSAPublicKeySpec.class); 
                spec.put(RSAUtil.PUBLIC_KEY_MODULUS, publicSpec.getModulus().toString(16)); 
                spec.put(RSAUtil.PUBLIC_KEY_EXPONENT, publicSpec.getPublicExponent().toString(16)); 
            } catch (Exception e) { log.error(e.getMessage()); } return spec; 
        } 
            
}

