package com.controller.aptrepository;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/getApt")
public class AgentAptListController {

	@Value("${apt.ip}")
	private static String aptIp;

	public List<String> getApt() throws IOException {

		String apiURL = "http://" + aptIp + "/dists/sgb/main/binary-amd64/Packages";
		List<String> list = new ArrayList<String>();
		URL url = new URL(apiURL);

		try (BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(url.openStream()))) {

			String inputLine = "";

			while (!(inputLine = bufferedReader.readLine()).isEmpty()) {

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
			bufferedReader.close();
			return list;
		}

	}

}
