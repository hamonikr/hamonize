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

import org.slf4j.LoggerFactory;
import org.slf4j.Logger;

@Controller
@RequestMapping("/mntrng")
public class MntrngController {

	@Autowired
	private MntrgService mntrgService;

	@Autowired
	private GroupService groupService;

	private Logger logger = LoggerFactory.getLogger(this.getClass());

	/*
	 * 모니터링 페이지
	 * 
	 * @param model
	 * 
	 * @return
	 */
	@RequestMapping(value = "/pcControl", method = RequestMethod.POST)
	public String pcControlPage(Model model) {
		JSONArray groupList = null;

		try {
			GroupVo gvo = new GroupVo();
			groupList = groupService.groupList(gvo);

		} catch (ParseException e) {
			logger.error(e.getMessage(), e);
		}
		model.addAttribute("gList", groupList);


		return "/mntrng/mntrngControl";
	}

	@ResponseBody
	@RequestMapping(value = "/pcControl.proc", method = RequestMethod.POST)
	public Map<String, Object> pcControlProc(PcMangrVo pvo) {
		Map<String, Object> jsonObject = new HashMap<String, Object>();

		try {
			List<PcMangrVo> retData = mntrgService.pcMntrgList(pvo);
			jsonObject.put("influxData", retData);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		return jsonObject;
	}

	/*
	 * PC 정보 페이지
	 * 
	 * @param code
	 * 
	 * @return
	 */
	@RequestMapping(value = "/pcinfo", method = RequestMethod.POST)
	public String pcinfoPostPage(Model model, String code) {
		JSONArray groupList = null;

		try {
			GroupVo gvo = new GroupVo();
			groupList = groupService.groupList(gvo);
		} catch (ParseException e) {
			logger.error(e.getMessage(), e);
		}
		model.addAttribute("gList", groupList);

		return "/mntrng/mntrnggInfo";
	}

}
