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

	@RequestMapping("/home")
	public String home( Model model ) {
		
		return "/home";
	}
	
	@RequestMapping("/tree")
	public String tree( Model model ) {
		
		return "/test/test";
	}
	
	@RequestMapping("/treefrom")
	public String treefrom( Model model ) {
		
		JSONArray groupList = null;

		try {
			GroupVo gvo = new GroupVo();
			gvo.setGroup_gubun("group");
			groupList = gService.groupList(gvo);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		model.addAttribute("gList", groupList);
		
		return "/test/treefrom";
	}
	
	@RequestMapping("/treeMenu")
	public String treeMenu( Model model ) {
		
		return "/test/treeMenu";
	}
	
	
	
	@RequestMapping("/info")
	public String addAttribute( Model model ) {
		
		AttributeVo attrVo = new AttributeVo();
		attrVo.setAttr_code("001");
		List<AttributeVo> retAttributeVo = attributeMapper.commcodeListInfo(attrVo);
		
		System.out.println("retAttributeVo==="+ retAttributeVo);
		
		model.addAttribute("retAttributeVo", retAttributeVo);
		
		
		return "/test/test";
	}
	
	

	@ResponseBody
	@RequestMapping("test.proc")
	public Map<String, Object> listProc( AttributeVo aVo) {
/*		public Map<String, Object> listProc(@RequestParam(value = "attrValueName") List<String> attrValueNames,
				@RequestParam(value = "attrName") String nameValue) {
*/
		Map<String, Object> jsonObject = new HashMap<String, Object>();

		System.out.println("get aVo === " + aVo);
		
		try {
			
//			attributeService.addAttribute(nameValue, attrValueNames);
			attributeService.addAttribute(aVo);
			
			jsonObject.put("success", true);
		} catch (Exception e) {
			jsonObject.put("success", false);
			e.printStackTrace();
		}

		return jsonObject;
	}
	
	
	
/*	
	@RequestMapping(value = "/test.proc", method = RequestMethod.POST)
	public String updateAttribute(@RequestParam(value = "attrValueName") List<String> attrValueNames,
			@RequestParam(value = "attrName") String nameValue) {

		attributeService.addAttribute(nameValue, attrValueNames);

		return "redirect:/goods/attributeManagement/attributeManagement.html";
	}
	*/
}
