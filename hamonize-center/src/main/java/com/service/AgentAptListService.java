package com.service;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
public class AgentAptListService {
	
	  @Value("${apt.ip}") 
	  private String aptIp;
	 
	  
	public List<Map<String,Object>> getApt() {
		System.out.println("----------- getApt() 실행 -----------");
		String apiURL = "http://"+aptIp.trim()+"/dists/hamonize/main/binary-amd64/Packages";
		System.out.println("apiURL --> " +apiURL);

		List<String> list = new ArrayList<String>();
		List<Map<String,Object>> result = new ArrayList<Map<String,Object>>();
		
		System.out.println("get apt url : "+apiURL);
		
		try {

			URL url = new URL(apiURL);
			BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(url.openStream()));

			String inputLine;

			while ((inputLine = bufferedReader.readLine()) != null) {
				System.out.println("inputLine : " + inputLine.toString());
				System.out.println("Package : " + inputLine.indexOf("Package"));
				if (inputLine.indexOf("Package") == 0) {
					list.add(inputLine);

				} else if (inputLine.indexOf("Version") == 0) {
					list.add(inputLine);
				}

			}
			int co = 1;
			for(int i = 0; i < list.size();i++) {
				if((i % 2) != 0) {
					Map<String,Object> map = new HashMap<String,Object>();
					System.out.println("package: "+ list.get((i-1)).split(":")[1].trim());
					map.put("package", list.get((i-1)).split(":")[1].trim());
					
					System.out.println("package: "+ list.get(i).split(":")[1].trim());
					map.put("version", list.get(i).split(":")[1].trim());
					System.out.println("list >> "+list.get(i));
					result.add((i-co),map);
					co++;
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

		return result;

	}

}
