package com.controller;

import org.json.simple.JSONArray;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.model.GroupVo;
import com.service.GroupService;


@Controller
@RequestMapping("/statistics")
public class StatisticsController {

	@Autowired
	private GroupService gService;
	
	/**
	 * 통계 페이지
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/statistics")
	public String statisticsPage(Model model){
		JSONArray groupList = null;
		
		try {
			GroupVo gvo = new GroupVo();
			groupList = gService.groupList(gvo);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		model.addAttribute("gList", groupList);
		
		return "/statistics";
	}
}
