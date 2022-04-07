package com.controller.aptrepository;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

import com.GlobalPropertySource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/getApt")
public class AgentAptListController {


	@Autowired
	GlobalPropertySource gs;

	private Logger logger = LoggerFactory.getLogger(this.getClass());

	public List<String> getApt() throws IOException {

		logger.info("gs.getAptIp()  : {}",gs.getAptIp() );

		String apiURL = "http://" + gs.getAptIp() + "/dists/public/main/binary-amd64/Packages";
		List<String> list = new ArrayList<String>();
		URL url = new URL(apiURL);

		try (BufferedReader bufferedReader =
				new BufferedReader(new InputStreamReader(url.openStream()))) {

			String inputLine = "";

			while ((inputLine = bufferedReader.readLine()) != null) {

				if (inputLine.indexOf("Package") == 0) {
					list.add(inputLine);
				} else if (inputLine.indexOf("Version") == 0) {
					list.add(inputLine);
				} else if (inputLine.indexOf("Section") == 0) {
					list.add(inputLine);
				} else if (inputLine.indexOf("Filename") == 0) {
					list.add(inputLine);
				}
			}
			return list;
		}


	}

}
