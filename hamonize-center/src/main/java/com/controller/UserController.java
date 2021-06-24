package com.controller;

import java.util.ArrayList;
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
import org.springframework.web.bind.annotation.ResponseBody;

import com.mapper.IUserMapper;
import com.model.OrgVo;
import com.model.UserVo;
import com.paging.PagingUtil;
import com.paging.PagingVo;
import com.service.OrgService;
import com.service.UserService;
import com.util.CmmnExcelService;

@Controller
@RequestMapping("/user")
public class UserController {

	@Autowired
	private IUserMapper userMapper;

	@Autowired
	private OrgService oService;

	@Autowired
	private UserService userSerivce;

	/*
	 * 사용자관리 페이지
	 * 
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/userList")
	public String userList(Model model, @RequestParam Map<String, Object> params) {
		JSONArray jsonArray = new JSONArray();
		try {
			OrgVo orgvo = new OrgVo();
			jsonArray = oService.orgList(orgvo);
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("oList", jsonArray);

		return "/user/userList";
	}

	@ResponseBody
	@RequestMapping(value = "/eachList")
	public Map<String,Object> eachList(Model model, UserVo vo, @RequestParam Map<String, Object> params) throws Exception {
		Map<String,Object> dataMap = new HashMap<String, Object>();
		List<UserVo> list = new ArrayList<UserVo>();
		vo.setOrg_seq(Integer.parseInt(params.get("org_seq").toString()));
	
		// 페이징
		vo.setCurrentPage(vo.getListInfoCurrentPage());
		vo = (UserVo) PagingUtil.setDefaultPaging(PagingUtil.DefaultPaging, vo);
		int cnt = Integer.parseInt(userMapper.countListInfo(vo) + "");
		vo.setTotalRecordSize(cnt);
		vo = (UserVo) PagingUtil.setPaging(vo);

		list = userSerivce.userList(vo);
		dataMap.put("data", list);
		dataMap.put("paging", vo);

		return dataMap;
	}
	
	@RequestMapping("/userListExcel")
	public CmmnExcelService userListExcel(UserVo vo, PagingVo pagingVo,HttpServletRequest request, HttpServletResponse response, ModelMap model,
    	@RequestParam Map<String, String> params) throws Exception {
		
		Map<String, Object> jsonObject = new HashMap<String, Object>();

		// 페이징
		pagingVo.setCurrentPage(vo.getListInfoCurrentPage());
		pagingVo = PagingUtil.setDefaultPaging(PagingUtil.DefaultPaging, pagingVo);

		int cnt = Integer.parseInt(userMapper.countListInfo(vo) + "");
		pagingVo.setTotalRecordSize(cnt);
		pagingVo = PagingUtil.setPaging(pagingVo);
		
		vo.setDate_fr(vo.getDate_fr().toString().replaceAll("/", "-"));
		vo.setDate_to(vo.getDate_to().toString().replaceAll("/", "-"));

		List<Map<String, Object>> list = userMapper.userListExcel(vo);
		
		String[] head ={"번호","소속부문","부서번호","ID","직급","성명","사번","입사일","퇴사일"};
		String[] column ={"rownum","p_org_nm","org_nm","user_id","rank","user_name","user_gunbun","enlistment_dt","discharge_dt"};
		jsonObject.put("header", head);		  // Excel 상단
		jsonObject.put("column", column);		  // Excel 상단
		jsonObject.put("excelName","사용자정보리스트");    // Excel 파일명
		jsonObject.put("list", list);          // Excel Data
		
		model.addAttribute("data", jsonObject);
		return new CmmnExcelService();
    }

	@ResponseBody
	@RequestMapping(value = "/userView")
	public UserVo userView(UserVo vo, Model model) throws Exception {

		UserVo uvo = userSerivce.userView(vo);
		model.addAttribute("result", uvo);

		return uvo;

	}

}
