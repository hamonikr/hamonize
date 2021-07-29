package com.controller.aptrepository;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Scanner;
import java.util.Set;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;

@RestController
@RequestMapping("/getApt")
public class AgentAptListController {
	
	
	@Value("${apt.ip}") 
	private static String aptIp;
	 

// 	public static void main(String[] args) {
// //		test1();

// 		String apiURL = "https://"+aptIp+"/dists/sgb/main/binary-amd64/Packages";
// 		System.out.println("apt url aaa : "+apiURL);
		
// 		try {
// 			System.out.println(9%2);

// 			URL url = new URL(apiURL);
// 			BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(url.openStream()));

// 			StringBuilder stringBuilder = new StringBuilder();

// 			String inputLine;
// 			while ((inputLine = bufferedReader.readLine()) != null) {
// //				stringBuilder.append(inputLine);
// //				stringBuilder.append(System.lineSeparator());
				
// //				System.out.println(inputLine.indexOf("Package"));
				
// 				if( inputLine.indexOf("Package") == 0) {
// 					System.out.println("Package : "+inputLine);
// 					stringBuilder.append(inputLine);
// 					stringBuilder.append(System.lineSeparator());
// 				}
// 				if( inputLine.indexOf("Version") == 0) {
// 					System.out.println("Version : "+inputLine);
// 					stringBuilder.append(inputLine);
// 					stringBuilder.append(System.lineSeparator());
// 				}
// 				if( inputLine.indexOf("Section") == 0) {
// 					stringBuilder.append(inputLine);
// 					stringBuilder.append(System.lineSeparator());
// 				}
// 				if( inputLine.indexOf("Filename") == 0) {
// 					stringBuilder.append(inputLine);
// 					stringBuilder.append(System.lineSeparator());
// 				}
				
// 			}

// 			bufferedReader.close();
// 			System.out.println(stringBuilder.toString().trim());

// 		} catch (MalformedURLException e) {
// 			// TODO Auto-generated catch block
// 			e.printStackTrace();
// 		} catch (IOException e) {
// 			// TODO Auto-generated catch block
// 			e.printStackTrace();
// 		}

// 	}

	public List<String> getApt() {
		
		String apiURL = "http://"+aptIp+"/dists/sgb/main/binary-amd64/Packages";
		List<String> list = new ArrayList<String>();
		try {

			URL url = new URL(apiURL);
			BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(url.openStream()));
			
			

			String inputLine;
			while ((inputLine = bufferedReader.readLine()) != null) {
//				stringBuilder.append(inputLine);
//				stringBuilder.append(System.lineSeparator());
				
//				System.out.println(inputLine.indexOf("Package"));
				
				if( inputLine.indexOf("Package") == 0) {
					list.add(inputLine);
				}else if( inputLine.indexOf("Version") == 0) {
					list.add(inputLine);
				}else if( inputLine.indexOf("Section") == 0) {
					list.add(inputLine);
				}else if( inputLine.indexOf("Filename") == 0) {
					list.add(inputLine);
				}
				
			}

			bufferedReader.close();			

		} catch (MalformedURLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
		return list;
		
	}

	public void test1() {
		String apiURL = "http://"+aptIp+"/dists/sgb/main/binary-amd64/Packages";
		try {
			URL aURL = new URL(apiURL);
			BufferedReader in = new BufferedReader(new InputStreamReader(aURL.openStream()));

			String inputLine;
			while ((inputLine = in.readLine()) != null)
				System.out.println(inputLine);
			in.close();
		} catch (MalformedURLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
