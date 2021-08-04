package com.controller;

import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mapper.ISvrlstMapper;
import com.model.AdminVo;
import com.model.OrgVo;
import com.model.SvrlstVo;
import com.paging.PagingUtil;
import com.paging.PagingVo;
import com.service.AdminService;
import com.service.OrgService;
import com.service.SvrlstService;
import com.util.Constant;
import com.util.SHA256Util;
import com.util.StringUtil;

@Controller
@RequestMapping("/admin")
public class AdminController {
	
	@Autowired
	private AdminService adminservice;
	
	@Autowired
	private OrgService oService;

	@Autowired
	private SvrlstService svrlstService;
	
	@Autowired
	private ISvrlstMapper svrlstMapper;
	
	//서버 관리자
	@RequestMapping("/serverlist")
	public String serverlist(HttpSession session, Model model,AdminVo vo) throws Exception{
		return "/svrlst/list";
	}
	
	@ResponseBody
	@RequestMapping("serverlist.proc")
	public Map<String, Object> serverlistProc(SvrlstVo vo, PagingVo pagingVo, HttpSession session, HttpServletRequest request) {
		Map<String, Object> jsonObject = new HashMap<String, Object>();

		// 페이징
		pagingVo.setCurrentPage(vo.getSvrlstInfoCurrentPage());
		pagingVo = PagingUtil.setDefaultPaging(PagingUtil.CustomerPaging, pagingVo);

		int cnt = Integer.parseInt(svrlstMapper.countSvrlstListInfo(vo) + "");
		
		
		pagingVo.setTotalRecordSize(cnt);
		pagingVo = PagingUtil.setPaging(pagingVo);

		try {
			List<SvrlstVo> gbList = svrlstService.getSvrlstList(vo, pagingVo);
			jsonObject.put("list", gbList);
			jsonObject.put("pagingVo", pagingVo);

			jsonObject.put("success", true);
		} catch (Exception e) {
			jsonObject.put("success", false);
			e.printStackTrace();
		}

		return jsonObject;
	}
	
	
	@RequestMapping("serverlistDelete.proc")
	public String serverlistDelete(SvrlstVo vo, PagingVo pagingVo, HttpSession session, HttpServletRequest request) {
		Map<String, Object> jsonObject = new HashMap<String, Object>();
		
		svrlstMapper.svrlstDelete(vo);
		
		return "/svrlst/list";
	}
	
	
	
	@ResponseBody
	@RequestMapping(value="serverlistInsert.proc")
	public Map<String, Object> serverlistInsert(HttpSession session, SvrlstVo nVo) throws Exception {
		
		Map<String, Object> jsonObject = new HashMap<String, Object>();
		
		try {
			svrlstService.svrlstInsert(nVo);
			
			jsonObject.put("msg", Constant.Board.SUCCESS_GROUP_BOARD);
			jsonObject.put("success", true);
			
		} catch (SQLException sqle) {
			sqle.printStackTrace();
			jsonObject.put("msg", Constant.Board.SUCCESS_FAIL);
			jsonObject.put("success", false);
		} catch (DataIntegrityViolationException dive ){
			dive.printStackTrace();
			jsonObject.put("msg", Constant.Board.SUCCESS_FAIL);
			jsonObject.put("success", false);
		} catch (Exception e) {
			e.printStackTrace();
			jsonObject.put("msg", Constant.Board.SUCCESS_FAIL);
			jsonObject.put("success", false);
		}
		
		
		return jsonObject;
	}
	
	
	//센터 관리자
	@RequestMapping("/list")
	public String list(HttpSession session, Model model,AdminVo vo) throws Exception{
		List<AdminVo> list = new ArrayList<AdminVo>();

			// 페이징
			vo.setCurrentPage(vo.getAdminListInfoCurrentPage());
			vo = (AdminVo) PagingUtil.setDefaultPaging(PagingUtil.DefaultPaging, vo);
			int cnt = Integer.parseInt(adminservice.countListInfo(vo) + "");
			vo.setTotalRecordSize(cnt);
			vo = (AdminVo) PagingUtil.setPaging(vo);
			list = adminservice.adminList(vo);
			
		model.addAttribute("keyWord",vo.getKeyWord());
		model.addAttribute("txtSearch",vo.getTxtSearch());
		model.addAttribute("aList", list);
		model.addAttribute("paging", vo);
		
		return "/admin/list";
	}
	@RequestMapping("/view")
	public String view(Model model,AdminVo vo) throws Exception{
		
		if(vo.getUser_id() != null) {
			AdminVo avo = adminservice.adminView(vo);
			model.addAttribute("result",avo);
		}
		
		return "/admin/view";
		
	}
	
	@RequestMapping("/save")
	@ResponseBody
	public int save(Model model,AdminVo vo) throws NoSuchAlgorithmException {
		int result=0;
		vo.setPass_wd(StringUtil.EncodingSHA256(vo.getPass_wd()));
		result = adminservice.adminSave(vo);
		return result;
		
	}
	
	@RequestMapping("/modify")
	@ResponseBody
	public int modify(Model model,AdminVo vo) throws Exception {
		int result=0;
		if(vo.getPass_wd() != null || vo.getPass_wd() != "") {
		vo.setPass_wd(StringUtil.EncodingSHA256(vo.getPass_wd()));
		}
		
		result = adminservice.adminModify(vo);
		return result;
		
	}
	
	@RequestMapping("/delete")
	@ResponseBody
	public int delete(Model model,AdminVo vo) throws Exception{
		int result=0;
		result = adminservice.adminDelete(vo);
		return result;
		
	}
	
	@RequestMapping("/idDuplCheck")
	@ResponseBody
	public int idDuplCheck(Model model,AdminVo vo) throws Exception{
		int result = 0;
		result = adminservice.adminIdCheck(vo);
		return result;
		
	}
	
	
	//부서 관리자
	@RequestMapping("/managerlist")
	public String managerlist(HttpSession session, Model model,AdminVo vo) throws Exception{
			List<AdminVo> list = new ArrayList<AdminVo>();
		
			// 페이징
			vo.setCurrentPage(vo.getCurrentPage());
			vo = (AdminVo) PagingUtil.setDefaultPaging(PagingUtil.DefaultPaging, vo);
			int cnt = Integer.parseInt(adminservice.sgbManagercountListInfo(vo) + "");
			vo.setTotalRecordSize(cnt);
			vo = (AdminVo) PagingUtil.setPaging(vo);
			list = adminservice.sgbManagerList(vo);
			
			model.addAttribute("keyWord",vo.getKeyWord());
			model.addAttribute("txtSearch",vo.getTxtSearch());
			model.addAttribute("aList", list);
			model.addAttribute("paging", vo);
		
		return "/sgbManager/list";
	}
	@RequestMapping("/managerview")
	public String managerview(Model model,AdminVo vo) throws Exception{
		
		
		if(vo.getUser_id() != null) {
			System.out.println("vo==="+vo.toString());
			AdminVo avo = adminservice.sgbManagerView(vo);
			model.addAttribute("result",avo);			
		}
		JSONArray orgList = null;
		OrgVo orgvo = new OrgVo();
		orgList = oService.orgList(orgvo);
		model.addAttribute("oList", orgList);
		return "/sgbManager/view";
		
	}
	
	@RequestMapping("/managersave")
	@ResponseBody
	public int managersave(Model model,AdminVo vo) throws NoSuchAlgorithmException {
		int result=0;
		result = adminservice.sgbManagerIdCheck(vo);
		if(result == 0) {
			vo.setPass_wd(SHA256Util.getEncrypt(vo.getPass_wd(), SHA256Util.generateSalt()));
			result = adminservice.sgbManagerSave(vo);
		}else{
			result += 10;
		}
		return result;
		
	}
	
	@RequestMapping("/managermodify")
	@ResponseBody
	public int managermodify(Model model,AdminVo vo) throws Exception {
		int result=0;
		if(vo.getPass_wd() != null || vo.getPass_wd() != "") {
		vo.setPass_wd(SHA256Util.getEncrypt(vo.getPass_wd(), SHA256Util.generateSalt()));
		}
		result = adminservice.sgbManagerModify(vo);
		return result;
		
	}
	
	@RequestMapping("/managerdelete")
	@ResponseBody
	public int managerdelete(Model model,AdminVo vo) throws Exception{
		int result=0;
		result = adminservice.sgbManagerDelete(vo);
		return result;
		
	}
	
	@RequestMapping("/manageridDuplCheck")
	@ResponseBody
	public int manageridDuplCheck(Model model,AdminVo vo) throws Exception{
		int result = 0;
		result = adminservice.sgbManagerIdCheck(vo);
		return result;
		
	}

}
