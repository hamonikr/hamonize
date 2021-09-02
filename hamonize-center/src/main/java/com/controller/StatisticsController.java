package com.controller;

import org.json.simple.JSONArray;
import org.json.simple.parser.ParseException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import com.model.GroupVo;
import com.service.GroupService;


@Controller
@RequestMapping("/statistics")
public class StatisticsController {

	@Autowired
	private GroupService gService;

	private Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 통계 페이지
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/statistics", method = RequestMethod.POST)
	public String statisticsPage(Model model) {
		JSONArray groupList = null;

		try {
			GroupVo gvo = new GroupVo();
			groupList = gService.groupList(gvo);
		} catch (ParseException e) {
			logger.error(e.getMessage(), e);
		}
		model.addAttribute("gList", groupList);

		return "/statistics";
	}
}
