package com.service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.GlobalPropertySource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class AgentAptListService {

	@Autowired
	GlobalPropertySource gs;

	private Logger logger = LoggerFactory.getLogger(this.getClass());

	public List<Map<String, Object>> getApt() throws MalformedURLException {
		String apiURL = "http://" + gs.getAptIp().trim() + "/dists/hamonize/main/binary-amd64/Packages";
		System.out.println("apt url : " + apiURL);

		List<String> list = new ArrayList<String>();
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();

		URL url = new URL(apiURL);
		String inputLine = "";

		try (BufferedReader bufferedReader =
				new BufferedReader(new InputStreamReader(url.openStream()))) {

			while ((inputLine = bufferedReader.readLine()) != null) {
				if (inputLine.indexOf("Package") == 0) {
					list.add(inputLine);

				} else if (inputLine.indexOf("Version") == 0) {
					list.add(inputLine);
				}
			}

			int co = 1;
			for (int i = 0; i < list.size(); i++) {
				if ((i % 2) != 0) {
					Map<String, Object> map = new HashMap<String, Object>();
					map.put("package", list.get((i - 1)).split(":")[1].trim());
					map.put("version", list.get(i).split(":")[1].trim());
					result.add((i - co), map);
					co++;
				}
			}


		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}


		return result;

	}

}

// apt저장소에서 description 까지 가져오는 소스
// @Service
// public class AgentAptListService {

// @Value("${apt.ip}")
// private String aptIp;


// public List<Map<String,Object>> getApt() {
// System.out.println("----------- getApt() 실행 -----------");
// String apiURL = "http://"+aptIp.trim()+"/dists/hamonize/main/binary-amd64/Packages";
// System.out.println("apiURL --> " +apiURL);

// List<String> list = new ArrayList<String>();
// List<Map<String,Object>> result = new ArrayList<Map<String,Object>>();

// System.out.println("get apt url : "+apiURL);

// try {

// URL url = new URL(apiURL);
// BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(url.openStream()));

// String inputLine;

// while ((inputLine = bufferedReader.readLine()) != null) {
// System.out.println("inputLine >>>> " + inputLine.toString());
// System.out.println("Package >>>> " + inputLine.indexOf("Package"));
// System.out.println("Description >>>> " + inputLine.indexOf("Description"));

// if (inputLine.indexOf("Package") == 0) {
// list.add(inputLine);
// } else if (inputLine.indexOf("Version") == 0) {
// list.add(inputLine);
// } else if (inputLine.indexOf("Description") == 0) {
// list.add(inputLine);
// }

// }
// int a =0;
// System.out.println("list.size() : "+list.size());
// for(int i = 1; i < list.size()+1;i++) {
// a = 3*i-2;

// if(a < list.size() ){

// System.out.println("aa==="+ a );
// System.out.println("i==="+ i );

// Map<String,Object> map = new HashMap<String,Object>();
// System.out.println("package: "+ list.get(a-1).split(":")[1].trim());
// map.put("package", list.get((a-1)).split(":")[1].trim());

// System.out.println("version: "+ list.get(a).split(":")[1].trim());
// map.put("version", list.get(a).split(":")[1].trim());

// System.out.println("description: "+ list.get(a+1).split(":")[1].trim());
// map.put("description", list.get(a+1).split(":")[1].trim());

// result.add(i-1,map);

// }
// }

// bufferedReader.close();

// } catch (MalformedURLException e) {
// e.printStackTrace();
// } catch (IOException e) {
// e.printStackTrace();
// }

// return result;

// }

// }
