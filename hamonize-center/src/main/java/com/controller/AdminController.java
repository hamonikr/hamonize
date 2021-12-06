package com.controller;

import java.security.KeyPair;
import java.security.NoSuchAlgorithmException;
import java.security.PrivateKey;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import com.mapper.ISvrlstMapper;
import com.mapper.IFileMapper;
import com.mapper.IGetAgentPollingMapper;

import com.model.AdminVo;
import com.model.FileVo;
import com.model.HmProgrmUpdtVo;
import com.model.LoginVO;
import com.model.OrgVo;
import com.model.SvrlstVo;
import com.paging.PagingUtil;
import com.paging.PagingVo;
import com.service.AdminService;
import com.service.LoginService;
import com.service.OrgService;
import com.service.SvrlstService;
import com.util.Constant;
import com.util.RSAUtil;
import com.util.SHA256Util;

import org.json.simple.JSONArray;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/admin")
public class AdminController { 

	@Autowired
	private AdminService adminservice;

	@Autowired
	private LoginService loginService;

	@Autowired
	private OrgService oService;

	@Autowired
	private SvrlstService svrlstService;

	@Autowired
	private ISvrlstMapper svrlstMapper;

	@Autowired
	private IFileMapper fileMapper;
	
	@Autowired
	private IGetAgentPollingMapper getAgentPollingMapper;

	private Logger logger = LoggerFactory.getLogger(this.getClass());
	private static final String SUCCESS = "success";


	// 서버 관리자
	@GetMapping("/serverlist")
	public String serverlist(HttpSession session, Model model) {
		List<HmProgrmUpdtVo> progrmlist = svrlstMapper.getProgrmList();
		List<SvrlstVo> serverlist = svrlstMapper.getVpnSvrlstList();
		FileVo publickey = fileMapper.getFile("public");
		FileVo privatekey = fileMapper.getFile("private");
		FileVo adminconfig = fileMapper.getFile("adminconfig");

		model.addAttribute("plist", progrmlist);
		model.addAttribute("slist", serverlist);
		model.addAttribute("publickey", publickey);
		model.addAttribute("privatekey", privatekey);
		model.addAttribute("config", adminconfig);


		return "/svrlst/list";
	}

	@ResponseBody
	@PostMapping("/serverlist.proc")
	public Map<String, Object> serverlistProc(SvrlstVo vo, PagingVo pagingVo, HttpSession session,
			HttpServletRequest request) {
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
			jsonObject.put(SUCCESS, true);
		} catch (Exception e) {
			jsonObject.put(SUCCESS, false);
			logger.error(e.getMessage(), e);
		}

		return jsonObject;
	}


	@PostMapping("serverlistDelete.proc")
	public String serverlistDelete(SvrlstVo vo, PagingVo pagingVo, HttpSession session,
			HttpServletRequest request) {
		svrlstMapper.svrlstDelete(vo);

		return "/svrlst/list";
	}



	@ResponseBody
	@PostMapping("serverlistInsert.proc")
	public Map<String, Object> serverlistInsert(HttpSession session, SvrlstVo nVo) {

		Map<String, Object> jsonObject = new HashMap<String, Object>();

		try {
			svrlstService.svrlstInsert(nVo);

			jsonObject.put("msg", Constant.Board.SUCCESS_GROUP_BOARD);
			jsonObject.put(SUCCESS, true);

		} catch (SQLException sqle) {
			logger.error(sqle.getMessage(), sqle);
			jsonObject.put("msg", Constant.Board.SUCCESS_FAIL);
			jsonObject.put(SUCCESS, false);
		} catch (DataIntegrityViolationException dive) {
			logger.error(dive.getMessage(), dive);
			jsonObject.put("msg", Constant.Board.SUCCESS_FAIL);
			jsonObject.put(SUCCESS, false);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			jsonObject.put("msg", Constant.Board.SUCCESS_FAIL);
			jsonObject.put(SUCCESS, false);
		}


		return jsonObject;
	}

	//vpn server 사용여부
	@PostMapping("/vpnUsed")
	@ResponseBody
	public int vpnUsed(SvrlstVo vo) {
		int result = 0;
		result = svrlstMapper.vpnUsedUpdate(vo);
		return result;
	}
	


	// 센터 관리자
	@GetMapping("/list")
	public String list(HttpSession session, Model model, AdminVo vo) {
		List<AdminVo> list = new ArrayList<>();

		// 페이징
		vo.setCurrentPage(vo.getAdminListInfoCurrentPage());
		vo = (AdminVo) PagingUtil.setDefaultPaging(PagingUtil.DefaultPaging, vo);
		int cnt = Integer.parseInt(adminservice.countListInfo(vo) + "");
		vo.setTotalRecordSize(cnt);
		vo = (AdminVo) PagingUtil.setPaging(vo);
		list = adminservice.adminList(vo);

		model.addAttribute("keyWord", vo.getKeyWord());
		model.addAttribute("txtSearch", vo.getTxtSearch());
		model.addAttribute("aList", list);
		model.addAttribute("paging", vo);

		return "/admin/list";
	}

	@PostMapping("/view")
	public String view(Model model, AdminVo vo, HttpServletRequest request) throws NoSuchAlgorithmException {

		if (vo.getUser_id() != null) {

			// 세션에 남아있을지도 몰라서 생성 전에 제거
			request.getSession().removeAttribute(RSAUtil.PRIVATE_KEY);
			KeyPair keys = RSAUtil.genKey();
			// Key 생성
			// 개인키는 세션에 저장
			request.getSession().setAttribute(RSAUtil.PRIVATE_KEY, keys.getPrivate());
			// 클라이언트 공개키 생성을 위한 파라미터
			Map<String, String> spec = RSAUtil.getKeySpec(keys.getPublic());
			request.setAttribute(RSAUtil.PUBLIC_KEY_MODULUS, spec.get(RSAUtil.PUBLIC_KEY_MODULUS));
			request.setAttribute(RSAUtil.PUBLIC_KEY_EXPONENT, spec.get(RSAUtil.PUBLIC_KEY_EXPONENT));
			request.setAttribute(RSAUtil.PUBLIC_KEY, keys.getPublic()); // 사용X
			
			AdminVo avo = adminservice.adminView(vo);
			model.addAttribute("result", avo);
		}

		return "/admin/view";

	}

	@PostMapping("/save")
	@ResponseBody
	public int save(Model model, AdminVo vo) {
		int result = 0;
		String salt = SHA256Util.generateSalt();
		vo.setPass_wd(SHA256Util.getEncrypt(vo.getPass_wd(), salt));
		vo.setSalt(salt);

		result = adminservice.adminSave(vo);
		return result;

	}

	@PostMapping("/modify")
	@ResponseBody
	public int modify(Model model, AdminVo vo, @RequestParam Map<String, Object> params, HttpServletRequest request) throws Exception {
		int result = 0;
		LoginVO salt_vo = loginService.getSalt(params);

		PrivateKey pk = (PrivateKey)request.getSession().getAttribute(RSAUtil.PRIVATE_KEY);
		
		// 생성한 개인키가 없으면 잘못된 요청으로 처리
		if(pk == null) { 
			logger.error("=======================Private Key is Null"); 
			throw new Exception(); 
		}
		vo.setCurrent_pass_wd(RSAUtil.decryptRSA(vo.getCurrent_pass_wd(), pk));
		
		vo.setCurrent_pass_wd(SHA256Util.getEncrypt(vo.getCurrent_pass_wd(), salt_vo.getSalt()));
		result = adminservice.adminPasswordCheck(vo);
		
		if(result == 1){
			if (vo.getPass_wd() != null || !vo.getPass_wd().trim().isEmpty()) {
				vo.setPass_wd(RSAUtil.decryptRSA(vo.getPass_wd(), pk));
				String salt = SHA256Util.generateSalt();
				vo.setPass_wd(SHA256Util.getEncrypt(vo.getPass_wd(), salt));
				vo.setSalt(salt);
			}
			result = adminservice.adminModify(vo);
		}else{
			result = 0;
		}
		request.getSession().removeAttribute(RSAUtil.PRIVATE_KEY);
		return result;

	}

	@PostMapping("/delete")
	@ResponseBody
	public int delete(Model model, AdminVo vo) {
		int result = 0;
		result = adminservice.adminDelete(vo);
		return result;

	}

	@PostMapping("/idDuplCheck")
	@ResponseBody
	public int idDuplCheck(Model model, AdminVo vo) {
		int result = 0;
		result = adminservice.adminIdCheck(vo);
		return result;

	}


	// 부서 관리자
	@PostMapping("/managerlist")
	public String managerlist(HttpSession session, Model model, AdminVo vo) {
		List<AdminVo> list = new ArrayList<>();

		// 페이징
		vo.setCurrentPage(vo.getCurrentPage());
		vo = (AdminVo) PagingUtil.setDefaultPaging(PagingUtil.DefaultPaging, vo);
		int cnt = Integer.parseInt(adminservice.sgbManagercountListInfo(vo) + "");
		vo.setTotalRecordSize(cnt);
		vo = (AdminVo) PagingUtil.setPaging(vo);
		list = adminservice.sgbManagerList(vo);

		model.addAttribute("keyWord", vo.getKeyWord());
		model.addAttribute("txtSearch", vo.getTxtSearch());
		model.addAttribute("aList", list);
		model.addAttribute("paging", vo);

		return "/sgbManager/list";
	}

	@PostMapping("/managerview")
	public String managerview(Model model, AdminVo vo) {


		if (vo.getUser_id() != null) {
			AdminVo avo = adminservice.sgbManagerView(vo);
			model.addAttribute("result", avo);
		}
		JSONArray orgList = null;
		OrgVo orgvo = new OrgVo();
		try {
			orgList = oService.orgList(orgvo);
		} catch (NamingException e) {
			logger.error(e.getMessage(), e);
		}
		model.addAttribute("oList", orgList);
		return "/sgbManager/view";

	}

	@PostMapping("/managersave")
	@ResponseBody
	public int managersave(Model model, AdminVo vo) {
		int result = 0;
		result = adminservice.sgbManagerIdCheck(vo);
		if (result == 0) {
			String salt = SHA256Util.generateSalt();
			vo.setPass_wd(SHA256Util.getEncrypt(vo.getPass_wd(), salt));
			vo.setSalt(salt);

			result = adminservice.sgbManagerSave(vo);
		} else {
			result += 10;
		}
		return result;

	}

	@PostMapping("/managermodify")
	@ResponseBody
	public int managermodify(Model model, AdminVo vo) {
		int result = 0;
		if (vo.getPass_wd() != null || !vo.getPass_wd().trim().isEmpty()) {
			String salt = SHA256Util.generateSalt();
			vo.setPass_wd(SHA256Util.getEncrypt(vo.getPass_wd(), salt));
			vo.setSalt(salt);

		}
		result = adminservice.sgbManagerModify(vo);
		return result;

	}

	@PostMapping("/managerdelete")
	@ResponseBody
	public int managerdelete(Model model, AdminVo vo) {
		int result = 0;
		result = adminservice.sgbManagerDelete(vo);
		return result;

	}

	@PostMapping("/manageridDuplCheck")
	@ResponseBody
	public int manageridDuplCheck(Model model, AdminVo vo) {
		int result = 0;
		result = adminservice.sgbManagerIdCheck(vo);
		return result;

	}


	@ResponseBody
	@PostMapping("/setPollTime")
	public String setPollTime (HmProgrmUpdtVo vo) {
		String retval="";
		logger.info("pu name : {}",vo.getPu_name());
		logger.info("setPollTime : {}",vo.getPolling_tm());
		if(svrlstMapper.updatePollingTime(vo)==1 && getAgentPollingMapper.insertPollingData(vo)==1){
			retval="SUCCESS"; 
		}else{
			retval="FAIL"; 
		}

		return retval;
	}


	@ResponseBody
	@PostMapping("/setEnv")
	public String setEnv (SvrlstVo vo) {
		String retval="";
		if(svrlstMapper.envInsert(vo) ==1){
			retval="SUCCESS"; 
		}else{
			retval="FAIL"; 
		}

		return retval;
	}


}
