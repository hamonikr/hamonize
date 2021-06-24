package com.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.mapper.IUserMapper;
import com.model.OrgVo;
import com.model.ResearchVo;
import com.paging.PagingVo;
import com.service.OrgService;
import com.service.ResearchService;
import com.service.UserService;
import com.util.CmmnExcelService;

@Controller
@RequestMapping("/research")
public class ResearchController {

	@Autowired
	private IUserMapper userMapper;

	@Autowired
	private OrgService oService;

	@Autowired
	private UserService userSerivce;
	
	@Autowired
	private ResearchService rSerivce;
	
	
	@RequestMapping("/excelList")
	public CmmnExcelService excelList(ResearchVo vo, PagingVo pagingVo,HttpServletRequest request, HttpServletResponse response, ModelMap model,
    		@RequestParam Map<String, String> params) throws Exception {
		Map<String, Object> jsonObject = new HashMap<String, Object>();
		vo.setDate_fr(vo.getDate_fr().replace("/", ""));
		vo.setDate_to(vo.getDate_to().replace("/", ""));
		if(vo.getOrg_seq() == null) {
			vo.setOrg_seq(1);
		}
		List<Map<String, Object>> list = null;
		if("1".equals(params.get("type"))) {
			list = rSerivce.dayUsePc(vo);
		}else if("2".equals(params.get("type"))) {
			list = rSerivce.loginList(vo);
		}else if("3".equals(params.get("type"))) {
			list = rSerivce.dayUseUser(vo);
		}else if("4".equals(params.get("type"))) {
			list = rSerivce.distionctDayUseUser(vo);
		}else if("5".equals(params.get("type"))) {
			list = rSerivce.monthUsePc(vo);
		}else if("6".equals(params.get("type"))) {
			list = rSerivce.pcCountUnit(vo);
		}else if("7".equals(params.get("type"))) {
			list = rSerivce.dayTotalPc(vo);
		}else if("8".equals(params.get("type"))) {
			list = rSerivce.dayTotalUser(vo);
		}
		
		
		String[] head = new String[list.get(0).size()];
		String[] column = new String[list.get(0).size()];
		for(int i = 0;i < head.length;i++) {
			head[i] = list.get(0).keySet().toArray()[i].toString();
			column[i] = list.get(0).keySet().toArray()[i].toString();
		}
		//String[] column ={"rownum","p_org_nm","org_nm","user_id","rank","user_name","narasarang_no","user_gunbun","enlistment_dt","discharge_dt"};
		jsonObject.put("header", head);		  // Excel 상단
		jsonObject.put("column", column);		  // Excel 상단
		jsonObject.put("excelName",params.get("type"));    // Excel 파일명
		jsonObject.put("list", list);          // Excel Data
		
		//model.addAttribute("header", head);
		//model.addAttribute("list", list);
		model.addAttribute("data", jsonObject);
		return new CmmnExcelService();
    }

	/**
	 * 사용자관리 페이지
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/research")
	public String userList(Model model, @RequestParam Map<String, Object> params) {
		JSONArray jsonArray = new JSONArray();
		try {
			OrgVo orgvo = new OrgVo();
			jsonArray = oService.orgList(orgvo);
		} catch (Exception e) {
			e.printStackTrace();
			// FAIL_GET_LIST
		}
		// System.out.println(jsonArray.toString().replaceAll("\"", ""));
		model.addAttribute("oList", jsonArray);

		return "/research/list";
	}

//	@ResponseBody
//	@RequestMapping(value = "/eachList")
//	public Map<String,Object> eachList(Model model, UserVo vo, @RequestParam Map<String, Object> params) throws Exception {
//		Map<String,Object> dataMap = new HashMap<String, Object>();
//		List<UserVo> list = new ArrayList<UserVo>();
//		vo.setOrg_seq(Integer.parseInt(params.get("org_seq").toString()));
//		// 페이징
//		vo.setCurrentPage(vo.getListInfoCurrentPage());
//		vo = (UserVo) PagingUtil.setDefaultPaging(PagingUtil.DefaultPaging, vo);
//		int cnt = Integer.parseInt(userMapper.countListInfo(vo) + "");
//		vo.setTotalRecordSize(cnt);
//		vo = (UserVo) PagingUtil.setPaging(vo);
//
//		list = userSerivce.userList(vo);
//		/*
//		 * int count = 0; for(UserVo uvo : list) { //String nara =
//		 * AES256Util.decryptAES256(uvo.getNarasarang_no(), AES256Util.createKey());
//		 * list.get(count).setNarasarang_no(AES256Util.decryptAES256(uvo.
//		 * getNarasarang_no(), AES256Util.createKey())); count++; }
//		 */
//		dataMap.put("data", list);
//		dataMap.put("paging", vo);
//
//		// model.addAttribute("userList",list);
//		return dataMap;
//	}
//	
//	@RequestMapping("/excel")
//	public CmmnExcelService userListExcel(UserVo vo, PagingVo pagingVo,HttpServletRequest request, HttpServletResponse response, ModelMap model,
//    		@RequestParam Map<String, String> params) throws Exception {
//		Map<String, Object> jsonObject = new HashMap<String, Object>();
//
//		List<Map<String, Object>> list = userMapper.userListExcel(vo);
//		String[] head = new String[list.get(0).size()];
//		String[] column = new String[list.get(0).size()];
//		for(int i = 0;i < head.length;i++) {
//			head[i] = list.get(0).keySet().toArray()[i].toString();
//			column[i] = list.get(0).keySet().toArray()[i].toString();
//		}
//		//String[] column ={"rownum","p_org_nm","org_nm","user_id","rank","user_name","narasarang_no","user_gunbun","enlistment_dt","discharge_dt"};
//		jsonObject.put("header", head);		  // Excel 상단
//		jsonObject.put("column", column);		  // Excel 상단
//		jsonObject.put("excelName","사용자정보리스트");    // Excel 파일명
//		jsonObject.put("list", list);          // Excel Data
//		
//		//model.addAttribute("header", head);
//		//model.addAttribute("list", list);
//		model.addAttribute("data", jsonObject);
//		return new CmmnExcelService();
//    }
//
//	@ResponseBody
//	@RequestMapping(value = "/userView")
//	public UserVo userView(UserVo vo, Model model) throws Exception {
//
//		UserVo uvo = userSerivce.userView(vo);
//		model.addAttribute("result", uvo);
//
//		return uvo;
//
//	}

	/*
	 * @RequestMapping("/management") public String managementPage(Model model)
	 * throws Exception {
	 * 
	 * JSONArray groupList = null;
	 * 
	 * try { GroupVo gvo = new GroupVo(); gvo.setGroup_gubun("group"); groupList =
	 * gService.groupList(gvo); } catch (ParseException e) { e.printStackTrace(); }
	 * model.addAttribute("gList", groupList);
	 * 
	 * return "/user/userList"; }
	 */

	/*
	 * @ResponseBody
	 * 
	 * @RequestMapping("listProc") public Map<String, Object> listProc(SoliderVo vo,
	 * PagingVo pagingVo, HttpSession session, HttpServletRequest request) {
	 * 
	 * Map<String, Object> jsonObject = new HashMap<String, Object>();
	 * 
	 * // 페이징 pagingVo.setCurrentPage(vo.getSoliderListInfoCurrentPage()); pagingVo
	 * = PagingUtil.setDefaultPaging(PagingUtil.DefaultPaging, pagingVo);
	 * 
	 * int cnt = Integer.parseInt(soliderMapper.countSoliderListInfo(vo) + "");
	 * pagingVo.setTotalRecordSize(cnt); pagingVo = PagingUtil.setPaging(pagingVo);
	 * 
	 * try { List<SoliderVo> gbList = userSerivce.soliderList(vo, pagingVo);
	 * jsonObject.put("list", gbList); jsonObject.put("pagingVo", pagingVo);
	 * 
	 * jsonObject.put("success", true); } catch (Exception e) {
	 * jsonObject.put("success", false); e.printStackTrace(); }
	 * 
	 * return jsonObject; }
	 * 
	 * 
	 * @ResponseBody
	 * 
	 * @RequestMapping("/userView.proc") public Map<String, Object> test(SoliderVo
	 * vo, PagingVo pagingVo, HttpSession session, HttpServletRequest request) {
	 * 
	 * Map<String, Object> jsonObject = new HashMap<String, Object>();
	 * 
	 * 
	 * try {
	 * 
	 * 
	 * // common val AttributeVo attrVo = new AttributeVo();
	 * attrVo.setAttr_code("001"); List<AttributeVo> retAttributeVo =
	 * attributeMapper.commcodeListInfo(attrVo);
	 * 
	 * // user info SoliderVo userInfo = soliderMapper.selectUsreInfo(vo);
	 * 
	 * 
	 * jsonObject.put("retAttributeVo", retAttributeVo); jsonObject.put("userInfo",
	 * userInfo);
	 * 
	 * jsonObject.put("success", true); } catch (Exception e) {
	 * jsonObject.put("success", false); e.printStackTrace(); }
	 * 
	 * return jsonObject; }
	 * 
	 * 
	 * 
	 * 
	 * @RequestMapping("/userAdd.acnt") public String userAdd(Model model, SoliderVo
	 * vo, HttpServletRequest request) {
	 * 
	 * // 값검증 if(vo == null || vo.getMem_seq() == null || vo.getMem_seq().length()
	 * <= 0) { return "/manager/mento/mentoList"; }
	 * 
	 * // common val AttributeVo attrVo = new AttributeVo();
	 * attrVo.setAttr_code("002"); List<AttributeVo> retAttributeRankVo =
	 * attributeMapper.commcodeListInfo(attrVo);
	 * 
	 * JSONArray groupList = null; try { GroupVo gvo = new GroupVo(); groupList =
	 * gService.groupList(gvo); } catch (ParseException e) { e.printStackTrace(); }
	 * 
	 * model.addAttribute("gList", groupList);
	 * model.addAttribute("retAttributeRankVo", retAttributeRankVo);
	 * 
	 * 
	 * return "/user/userAdd"; }
	 */

}
