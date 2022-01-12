package com.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.model.OrgVo;
import com.model.ResearchVo;
import com.paging.PagingVo;
import com.service.OrgService;
import com.service.ResearchService;
import org.json.simple.JSONArray;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;


@Controller
@RequestMapping("/research")
public class ResearchController {

	@Autowired
	private OrgService oService;

	@Autowired
	private ResearchService rSerivce;

	private Logger logger = LoggerFactory.getLogger(this.getClass());

	// @RequestMapping(value = "/excelList", method = RequestMethod.POST)
	// public CmmnExcelService excelList(ResearchVo vo, PagingVo pagingVo, HttpServletRequest request,
	// 		HttpServletResponse response, ModelMap model, @RequestParam Map<String, String> params)
	// 		throws Exception {

	// 	Map<String, Object> jsonObject = new HashMap<String, Object>();
	// 	vo.setDate_fr(vo.getDate_fr().replace("/", ""));
	// 	vo.setDate_to(vo.getDate_to().replace("/", ""));
	// 	if (vo.getOrg_seq() == null) {
	// 		vo.setOrg_seq(1);
	// 	}

	// 	List<Map<String, Object>> list = new ArrayList<>();

	// 	if ("1".equals(params.get("type"))) {
	// 		list = rSerivce.dayUsePc(vo);
	// 	} else if ("2".equals(params.get("type"))) {
	// 		list = rSerivce.loginList(vo);
	// 	} else if ("3".equals(params.get("type"))) {
	// 		list = rSerivce.dayUseUser(vo);
	// 	} else if ("4".equals(params.get("type"))) {
	// 		list = rSerivce.distionctDayUseUser(vo);
	// 	} else if ("5".equals(params.get("type"))) {
	// 		list = rSerivce.monthUsePc(vo);
	// 	} else if ("6".equals(params.get("type"))) {
	// 		list = rSerivce.pcCountUnit(vo);
	// 	} else if ("7".equals(params.get("type"))) {
	// 		list = rSerivce.dayTotalPc(vo);
	// 	} else if ("8".equals(params.get("type"))) {
	// 		list = rSerivce.dayTotalUser(vo);
	// 	}


	// 	String[] head = new String[list.get(0).size()];
	// 	String[] column = new String[list.get(0).size()];

	// 	for (int i = 0; i < head.length; i++) {
	// 		head[i] = list.get(0).keySet().toArray()[i].toString();
	// 		column[i] = list.get(0).keySet().toArray()[i].toString();
	// 	}

	// 	jsonObject.put("header", head); // Excel 상단
	// 	jsonObject.put("column", column); // Excel 상단
	// 	jsonObject.put("excelName", params.get("type")); // Excel 파일명
	// 	jsonObject.put("list", list); // Excel Data

	// 	model.addAttribute("data", jsonObject);
	// 	return new CmmnExcelService();
	// }

	/*
	 * 사용자관리 페이지
	 * 
	 * @return
	 * 
	 * @throws Exception
	 */
	@RequestMapping(value = "/research", method = RequestMethod.POST)
	public String userList(Model model, @RequestParam Map<String, Object> params) {
		JSONArray jsonArray = new JSONArray();
		try {
			OrgVo orgvo = new OrgVo();
			jsonArray = oService.orgList(orgvo);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		model.addAttribute("oList", jsonArray);

		return "/research/list";
	}

}
