package com.util;

import java.security.SecureRandom;
import java.util.Base64;
import java.util.Base64.Encoder;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class SHA256Util {
    private static Logger logger = LoggerFactory.getLogger(SHA256Util.class);
    private static final String ALGORITHM = "HmacSHA256";

    public static String generateSalt() {
        SecureRandom random = new SecureRandom();
        byte[] salt = new byte[8];
        random.nextBytes(salt);

        StringBuffer sb = new StringBuffer();

        for (int i = 0; i < salt.length; i++) {
            sb.append(String.format("%02x", salt[i]));
        }

        return sb.toString();
    }


    public static String getEncrypt(String message, String salt) {

        String result = "";

        try {
            Mac sha256_HMAC = Mac.getInstance(ALGORITHM);
            SecretKeySpec secret_key = new SecretKeySpec(salt.getBytes(), ALGORITHM);

            sha256_HMAC.init(secret_key);

            byte[] bt = sha256_HMAC.doFinal(message.getBytes());

            Encoder encoder = Base64.getEncoder();

            String hash = encoder.encodeToString(bt);
            result = hash;

        } catch (Exception e) {
            logger.error(e.getMessage(), e);
        }

        return result;
    }

}

