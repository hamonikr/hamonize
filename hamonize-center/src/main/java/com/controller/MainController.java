package com.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.mapper.IMainMapper;
import com.mapper.ITchnlgyMapper;
import com.service.MainService;
import com.service.MonitoringService;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
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

	@ResponseBody
	@RequestMapping(value = "/sidoCount")
	public Map<String, Object> sidoCount(Model model,@RequestParam Map<String, Object> params ) {
		//개방상용 구분
		int wCount = mMapper.wCount();
		int hCount = mMapper.hCount();
		
		Map<String, Object> dataMap = new HashMap<String, Object>();
		List<Map<String,Object>> sList = mMapper.sidoCount();
		List<Map<String,Object>> tList = mMapper.pcTotalSidoCount();
		
		//사용중인pc시도별
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();
		
		int on = 0;
		int off = 0;
		try {
			list = mMapper.pcUseSidoCount();
			for(int i = 0; i < list.size();i++) {
				resultList.add((Map<String, Object>) list.get(i));
				if(list.get(i).get("pc_status")=="true")
					on++;
				else
					off++;		
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}

		dataMap.put("sidoCount", sList);
		dataMap.put("pcOn", on);
		dataMap.put("pcOff", off);
		dataMap.put("useList", list);
		dataMap.put("totalList", tList);
	
		//개방상용 구분
		dataMap.put("wCount", wCount);
		dataMap.put("hCount", hCount);
		return dataMap;
	}

	// @ResponseBody
	// @RequestMapping(value = "/serversidoCount")
	// public Map<String, Object> serversidoCount(Model model,@RequestParam Map<String, Object> params ) {
	// 	//개방상용 구분
	// 	int wCount = mMapper.wCount();
	// 	int hCount = mMapper.hCount();
		
	// 	Map<String, Object> dataMap = new HashMap<String, Object>();
	// 	List<Map<String,Object>> sList = mMapper.serversidoCount();
	// 	List<Map<String,Object>> tList = mMapper.serverTotalSidoCount();
	// 	TchnlgyVo vo  = new TchnlgyVo();
	// 	vo = tchnlgyMapper.countMngrListInfo(vo);
	// 	System.out.println("vo ====="+vo.getTbl_cnt());

	// 	//사용중인pc시도별
	// 	List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
	// 	List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();

	// 	int on = 0;
	// 	int off = 0;

	// 	try {
	// 		list = mMapper.serverUseSidoCount();
	// 		for(int i = 0; i < list.size();i++) {
	// 			resultList.add((Map<String, Object>) list.get(i));
	// 			if(list.get(i).get("pc_status")=="true")
	// 				on++;
	// 			else
	// 				off++;		
	// 		}
			
	// 	} catch (Exception e) {
	// 		e.printStackTrace();
	// 	}

	// 	dataMap.put("sidoCount", sList);
	// 	dataMap.put("pcOn", on);
	// 	dataMap.put("pcOff", off);
	// 	dataMap.put("useList", list);
	// 	dataMap.put("totalList", tList);
	// 	dataMap.put("tchnlgyCount", vo);

	// 	//개방상용 구분
	// 	dataMap.put("wCount", wCount);
	// 	dataMap.put("hCount", hCount);
	// 	return dataMap;
	// }
	
	@ResponseBody
	@RequestMapping(value = "/gugunCount")
	public JSONArray gugunCount(Model model,@RequestParam Map<String, Object> params ) {
		List<Map<String,Object>> sList = mMapper.gugunCount(params);
		JSONArray ja = new JSONArray();
		
		for(int i=0;i<sList.size();i++) {
			JSONObject data = new JSONObject();
			data.put("gugun", sList.get(i).get("gugun"));
			data.put("pc_cnt", sList.get(i).get("pc_cnt"));
			data.put("t_sum", sList.get(i).get("t_sum"));
 			ja.add(data);
		}
		return ja;
	}
	

	// @ResponseBody
	// @RequestMapping(value = "/serverList")
	// public Map<String,Object> serverList(Model model,@RequestParam Map<String, Object> params) {
	// 	List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
	// 	List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();
	// 	Map<String, Object> dataParams = new HashMap<String, Object>();
	
	// 	int on = 0;
	// 	int off = 0;
	// 	try {
	// 		list =  mService.serverListInfo(params);
	// 		for(int i = 0; i < list.size();i++) {
	// 			resultList.add((Map<String, Object>) list.get(i));
				
	// 			if(list.get(i).get("pc_status")=="true")
	// 				on++;
	// 			else
	// 				off++;		
	// 		}
			
	// 	} catch (Exception e) {
	
	// 		e.printStackTrace();
	// 	}
	// 	dataParams.put("sido", resultList);
	// 	dataParams.put("pcOn", on);
	// 	dataParams.put("pcOff", off);
		
	// 	return dataParams;
	// }
	
	@ResponseBody
	@RequestMapping(value = "/inetLogCount")
	public Map<String, Object> inetLogCount(Model model,@RequestParam Map<String, Object> params ) {
		System.out.println("offset===="+params.get("offset"));
		params.put("offset", Integer.parseInt(params.get("offset").toString()));
		Map<String, Object> dataMap = new HashMap<String, Object>();
		List<Map<String,Object>> cList = mMapper.inetLogConnect(params);
		List<Map<String,Object>> iList = mMapper.inetLogIlligal(params);
		
		dataMap.put("conList", cList);
		dataMap.put("illList", iList);
		return dataMap;
	}


}
