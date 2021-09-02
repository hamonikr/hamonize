package com.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONArray;
import org.json.simple.parser.ParseException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mapper.IAttributeMapper;
import com.model.AttributeVo;
import com.model.GroupVo;
import com.service.AttributeManagementService;
import com.service.GroupService;

@Controller
@RequestMapping("/test")
public class TestController {

	@Autowired
	private GroupService gService;

	@Autowired
	private AttributeManagementService attributeService;

	@Autowired
	private IAttributeMapper attributeMapper;

	private Logger logger = LoggerFactory.getLogger(this.getClass());

	@RequestMapping(value = "/home", method = RequestMethod.POST)
	public String home(Model model) {

		return "/home";
	}

	@RequestMapping(value = "/tree", method = RequestMethod.POST)
	public String tree(Model model) {

		return "/test/test";
	}

	@RequestMapping(value = "/treefrom", method = RequestMethod.POST)
	public String treefrom(Model model) {

		JSONArray groupList = null;

		try {
			GroupVo gvo = new GroupVo();
			gvo.setGroup_gubun("group");
			groupList = gService.groupList(gvo);
		} catch (ParseException e) {
			logger.error(e.getMessage(), e);
		}
		model.addAttribute("gList", groupList);

		return "/test/treefrom";
	}

	@RequestMapping(value = "/treeMenu", method = RequestMethod.POST)
	public String treeMenu(Model model) {

		return "/test/treeMenu";
	}



	@RequestMapping(value = "/info", method = RequestMethod.POST)
	public String addAttribute(Model model) {

		AttributeVo attrVo = new AttributeVo();
		attrVo.setAttr_code("001");
		List<AttributeVo> retAttributeVo = attributeMapper.commcodeListInfo(attrVo);

		model.addAttribute("retAttributeVo", retAttributeVo);

		return "/test/test";
	}



	@ResponseBody
	@RequestMapping(value = "test.proc", method = RequestMethod.POST)
	public Map<String, Object> listProc(AttributeVo aVo) {
		Map<String, Object> jsonObject = new HashMap<String, Object>();

		System.out.println("get aVo === " + aVo);

		try {
			attributeService.addAttribute(aVo);
			jsonObject.put("success", true);
		} catch (Exception e) {
			jsonObject.put("success", false);
			logger.error(e.getMessage(), e);
		}

		return jsonObject;
	}

}
