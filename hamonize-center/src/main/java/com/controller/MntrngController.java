package com.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONArray;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.model.GroupVo;
import com.model.PcMangrVo;
import com.service.GroupService;
import com.service.MntrgService;


@Controller
@RequestMapping("/mntrng")
public class MntrngController {

	@Autowired
	private MntrgService mntrgService;

	@Autowired
	private GroupService groupService;

	/*
	 * 모니터링 페이지
	 * 
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/pcControl")
	public String pcControlPage(Model model) {
		JSONArray groupList = null;

		try {
			GroupVo gvo = new GroupVo();
			groupList = groupService.groupList(gvo);
			
			System.out.println("groupList========"+ groupList);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		model.addAttribute("gList", groupList);
		

		return "/mntrng/mntrngControl";
	}

	@ResponseBody
	@RequestMapping("pcControl.proc")
	public Map<String, Object> pcControlProc( PcMangrVo pvo ) {
		Map<String, Object> jsonObject = new HashMap<String, Object>();

		try {
			System.out.println("pvo==+"+ pvo);
			
			List<PcMangrVo> retData = mntrgService.pcMntrgList(pvo);
			System.out.println("retData========"+ retData.size());
			jsonObject.put("influxData", retData);
		} catch (Exception e) {
			jsonObject.put("influxData", "ssssssss");
			e.printStackTrace();
		}

		return jsonObject;
	}
	
	/*
	 * PC 정보 페이지
	 * 
	 * @param code
	 * @return
	 */
	@RequestMapping(value = "/pcinfo", method = RequestMethod.POST)
	public String pcinfoPostPage(Model model, String code) {
		JSONArray groupList = null;

		try {
			GroupVo gvo = new GroupVo();
			groupList = groupService.groupList(gvo);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		model.addAttribute("gList", groupList);

		return "/mntrng/mntrnggInfo";
	}

}