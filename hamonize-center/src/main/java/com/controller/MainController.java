package com.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.mapper.IMainMapper;
import com.mapper.ITchnlgyMapper;
import com.service.MainService;
import com.service.MonitoringService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class MainController {
	@Autowired
	private IMainMapper mMapper;
	
	@Autowired
	private MainService mService;

	@Autowired
	private MonitoringService miService;
	
	@Autowired
	private ITchnlgyMapper tchnlgyMapper;

	@RequestMapping("/")
	public String mainPage() throws Exception {
		return "redirect:/login/login";
	}
	
	@RequestMapping("/home")
	public String homePage() throws Exception {
		return "/mntrng/pcControl";

	}
	
	@RequestMapping("/main")
	public String mainMap() throws Exception {
		return "/main/mainMap";

	}

	@ResponseBody
	@RequestMapping(value = "/pcList")
	public Map<String, Object> pcList(Model model,@RequestParam Map<String, Object> params) {
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		Map<String,Object> result = new HashMap<String,Object>();
		params.put("org_seq", 1);
		int on = 0;
		int off = 0;
		try {
			list =  miService.pcListInfo(params);
			for(int i = 0; i < list.size();i++) {
				if(list.get(i).get("pc_status") != null)
					on++;
				else
					off++;	
			}
			System.out.println("on===="+on);
			System.out.println("off===="+off);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		result.put("pcList", list);
		result.put("on", on);
		result.put("off", off);

		return result;
	}

	

}
