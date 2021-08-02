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
	 
	public List<String> getApt() {
		
		String apiURL = "http://"+aptIp+"/dists/sgb/main/binary-amd64/Packages";
		List<String> list = new ArrayList<String>();
		try {

			URL url = new URL(apiURL);
			BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(url.openStream()));
			
			

			String inputLine;
			while ((inputLine = bufferedReader.readLine()) != null) {
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
			e.printStackTrace();
		} catch (IOException e) {
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
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

}
