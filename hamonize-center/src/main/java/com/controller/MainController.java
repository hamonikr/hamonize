package com.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.model.SvrlstVo;
import com.mapper.ISvrlstMapper;

import com.service.MonitoringService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.ObjectUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.slf4j.LoggerFactory;
import org.slf4j.Logger;

@Controller
public class MainController {

	@Autowired
	private MonitoringService miService;

	@Autowired
	private ISvrlstMapper svrlstMapper;

	private Logger logger = LoggerFactory.getLogger(this.getClass());

	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String mainPage() throws Exception {
		return "redirect:/login/login";
	}

	// @RequestMapping(value = "/home", method = RequestMethod.GET)

	// public String homePage() throws Exception {
	// 	return "/mntrng/pcControl";

	// }

	@RequestMapping(value = "/main", method = RequestMethod.GET)
	public String mainMap(Model model) throws Exception {
		
		SvrlstVo center = new SvrlstVo();
		center.setSvr_nm("GRAFANA_URL");
		SvrlstVo svo = svrlstMapper.getVpnSvrUsed(center);
		logger.info("svo ;; {}",svo.getSvr_ip());
		logger.info("port : {}", svo.getSvr_port());
		
		model.addAttribute("svo", svo);
		return "/main/mainMap";

	}


	@ResponseBody
	@RequestMapping(value = "/pcList", method = RequestMethod.POST)
	public Map<String, Object> pcList(Model model, @RequestParam Map<String, Object> params) {
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		Map<String, Object> result = new HashMap<String, Object>();
		params.put("org_seq", 1);
		int on = 0;
		int off = 0;
		try {
			list = miService.pcListInfo(params);
			for (int i = 0; i < list.size(); i++) {
				if ("true".equals(list.get(i).get("pc_status"))) {
					on++;
				} else {
					off++;
				}
			}

		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		result.put("pcList", list);
		result.put("on", on);
		result.put("off", off);

		return result;
	}



}
