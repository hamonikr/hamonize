package com.service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
public class AgentAptListService {

	@Value("${apt.ip}")
	private String aptIp;

	private Logger logger = LoggerFactory.getLogger(this.getClass());

	public List<Map<String, Object>> getApt() throws MalformedURLException {
		String apiURL = "http://" + aptIp.trim() + "/dists/hamonize/main/binary-amd64/Packages";

		List<String> list = new ArrayList<String>();
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();

		URL url = new URL(apiURL);

		try (

			BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(url.openStream()))) {
			String inputLine = "";

			
			while ( !(inputLine = bufferedReader.readLine()).isEmpty() ) {
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
			bufferedReader.close();

		} catch (Exception e) {
			logger.error(e.getMessage(), e);

		}

		return result;
 
	}

}
