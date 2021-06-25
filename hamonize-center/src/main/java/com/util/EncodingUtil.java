/*
 * package com.util;
 * 
 * import org.jasypt.encryption.pbe.StandardPBEStringEncryptor;
 * 
 * public class EncodingUtil {
 * 
 * private StandardPBEStringEncryptor pbeEnc = new StandardPBEStringEncryptor();
 * 
 * public EncodingUtil() { pbeEnc.setAlgorithm("PBEWithMD5AndDES");
 * pbeEnc.setPassword("SAMPLE"); }
 * 
 * public String encrypt(String data) { return pbeEnc.encrypt(data); }
 * 
 * public String decrypt(String data) { return pbeEnc.decrypt(data); }
 * 
 * public static void main(String[] args) throws Exception { EncodingUtil eu =
 * new EncodingUtil();
 * 
 * String api_key = "NCS55AC394A0094C"; String api_key2 = "admin"; String
 * api_secret = "4i2bg9MIAMmnUXXQbArBcA=="; String api_secret2 =
 * "1blW/mUv3/3+gXW7NaeAfg=="; System.out.println("api_key:" +
 * eu.encrypt(api_key)); System.out.println("api_secret:" +
 * eu.decrypt(api_secret));
 * 
 * System.out.println("api_key:" + eu.encrypt(api_key2));
 * System.out.println("api_secret:" + eu.decrypt(api_secret2)); } }
 */