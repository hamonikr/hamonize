package com.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.json.simple.JSONArray;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mapper.IPcMangrMapper;
import com.mapper.ISvrlstMapper;
import com.model.LoginVO;
import com.model.OrgVo;
import com.model.PcMangrVo;
import com.model.SvrlstVo;
import com.paging.PagingUtil;
import com.paging.PagingVo;
import com.service.OrgService;
import com.service.PcMangrService;
import com.util.AuthUtil;
import com.util.Constant;

@Controller
@RequestMapping("/pcMngr")
public class PcMangrController {

	@Autowired
	private PcMangrService pcService;

	@Autowired
	private IPcMangrMapper pcmapper;

	@Autowired
	private OrgService oService;

	@Autowired
	private ISvrlstMapper svrlstMapper;

	private Logger logger = LoggerFactory.getLogger(this.getClass());

	/*
	 * PC관리 페이지
	 * 
	 * @param model
	 * 
	 * @return
	 */
	@RequestMapping(value = "/pcMngrList", method = RequestMethod.GET)
	public String pcMngrList(Model model, @RequestParam Map<String, Object> params) {
		JSONArray jsonArray = new JSONArray();
		try {
			OrgVo orgvo = new OrgVo();
			jsonArray = oService.orgList(orgvo);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		model.addAttribute("oList", jsonArray);
		model.addAttribute("pc_change", (String) params.get("pc_change"));
		if ("R".equals(params.get("pc_change")) && params.get("pc_change") != "")
			return "/pcMngr/pcListMove";
		else
			return "/pcMngr/pcList";
	}

	/**
	 * PC 목록 불러오기
	 * 
	 * @param vo
	 * @param pagingVo
	 * @param session
	 * @param request
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "pcMngrList.proc", method = RequestMethod.POST)
	public Map<String, Object> listProc(PcMangrVo vo, PagingVo pagingVo, HttpSession session,
			HttpServletRequest request) {

		Map<String, Object> jsonObject = new HashMap<String, Object>();
		LoginVO lvo = AuthUtil.getLoginSessionInfo();
		vo.setDomain(lvo.getDomain());
		// 페이징
		pagingVo.setCurrentPage(vo.getPcListInfoCurrentPage());
		pagingVo = PagingUtil.setDefaultPaging(PagingUtil.DefaultPaging, pagingVo);

		int cnt = Integer.parseInt(pcmapper.countPcListInfo(vo) + "");
		pagingVo.setTotalRecordSize(cnt);
		pagingVo = PagingUtil.setPaging(pagingVo);

		SvrlstVo svrnm = new SvrlstVo();
		svrnm.setSvr_nm("VPNIP");
		
		SvrlstVo svo = svrlstMapper.getVpnSvrUsed(svrnm);

		try {
			List<PcMangrVo> gbList = pcService.pcMangrList(vo, pagingVo);

			jsonObject.put("list", gbList);
			jsonObject.put("pcVo", vo);
			jsonObject.put("svo", svo);		
			jsonObject.put("pagingVo", pagingVo);
			jsonObject.put("success", true);
		} catch (Exception e) {
			jsonObject.put("success", false);
			logger.error(e.getMessage(), e);
		}

		return jsonObject;
	}

	@ResponseBody
	@RequestMapping(value = "teamList", method = RequestMethod.POST)
	public List<OrgVo> teamList() {
		List<OrgVo> teamList = pcmapper.teamList();
		// if (result > 0) {
		// 	int re = pcmapper.changeInsertHistory(vo);
		// 	pcmapper.updateHistory(vo);
		// 	if ("P".equals(vo.getPc_change())) {
		// 		pcmapper.insertMoveInfo(vo);
		// 	}
		// 	if ("F".equals(vo.getSttus())) {
		// 		pcmapper.deleteMoveInfo(vo);
		// 	}
		// 	return "SUCCESS";
		// } else
		// 	return "FAIL";
		return teamList;

	}

	@ResponseBody
	@RequestMapping(value = "moveTeam", method = RequestMethod.POST)
	public int moveTeam(HttpSession session, Model model, PcMangrVo vo) throws NamingException {
		int result = 0;
		LoginVO lvo = AuthUtil.getLoginSessionInfo();
		vo.setDomain(lvo.getDomain());
		result = oService.pcMove(vo);
		return result;

	}

	@ResponseBody
	@RequestMapping(value = "deletePc", method = RequestMethod.POST)
	public int deletePc(HttpSession session, Model model, PcMangrVo vo) throws NamingException, ParseException {
		int result = 0;
		//LoginVO lvo = AuthUtil.getLoginSessionInfo();
		//vo.setDomain(lvo.getDomain());
//		result = oService.pcMove(vo);
		result = oService.deletePc(vo);
		System.out.println("delete pc result ================"+ result );
		return result;

	}


	@ResponseBody
	@RequestMapping(value = "changeStts", method = RequestMethod.POST)
	public Object changeStts(PcMangrVo vo) {
		int result = pcmapper.changeStts(vo);

		if (result > 0) {
			int re = pcmapper.changeInsertHistory(vo);
			pcmapper.updateHistory(vo);
			if ("P".equals(vo.getPc_change())) {
				pcmapper.insertMoveInfo(vo);
			}
			if ("F".equals(vo.getSttus())) {
				pcmapper.deleteMoveInfo(vo);
			}
			return "SUCCESS";
		} else
			return "FAIL";

	}


	@ResponseBody
	@RequestMapping(value = "requestCount", method = RequestMethod.POST)
	public int requestCount() {
		int result = pcmapper.requestCount();
		return result;

	}


	@ResponseBody
	@RequestMapping(value = "/getMovePcInfo", method = RequestMethod.POST)
	public Map<String, Object> getMovePcInfo(PcMangrVo vo, Model model,
			@RequestParam Map<String, Object> params) {
		Map<String, Object> jsonObject = new HashMap<String, Object>();

		jsonObject.put("result", pcmapper.pcMoveInfo(vo));

		return jsonObject;
	}


	/*
	 * PC 차단 관리 페이지
	 * 
	 * @param model
	 * 
	 * @return
	 */
	@RequestMapping(value = "/pcBlockList", method = RequestMethod.POST)
	public String pcBlockList(Model model, @RequestParam Map<String, Object> params) {
		JSONArray jsonArray = new JSONArray();

		try {
			OrgVo orgvo = new OrgVo();
			jsonArray = oService.orgList(orgvo);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);

		}

		model.addAttribute("oList", jsonArray);
		model.addAttribute("pc_change", (String) params.get("pc_change"));
		if ("R".equals(params.get("pc_change")) && params.get("pc_change") != "")
			return "/pcMngr/pcListMove";
		else
			return "/pcMngr/pcBlockList";
	}

	@ResponseBody
	@RequestMapping(value = "pcBlockList.proc", method = RequestMethod.POST)
	public Map<String, Object> blockListProc(PcMangrVo vo, PagingVo pagingVo, HttpSession session,
			HttpServletRequest request) {
		Map<String, Object> jsonObject = new HashMap<String, Object>();

		// 페이징
		pagingVo.setCurrentPage(vo.getPcListInfoCurrentPage());
		pagingVo = PagingUtil.setDefaultPaging(PagingUtil.DefaultPaging, pagingVo);

		int cnt = Integer.parseInt(pcmapper.countPcListInfo(vo) + "");
		pagingVo.setTotalRecordSize(cnt);
		pagingVo = PagingUtil.setPaging(pagingVo);

		try {
			List<PcMangrVo> gbList = pcService.pcBlockList(vo, pagingVo);
			jsonObject.put("list", gbList);
			jsonObject.put("pcVo", vo);
			jsonObject.put("pagingVo", pagingVo);

			jsonObject.put("success", true);
		} catch (Exception e) {
			jsonObject.put("success", false);
			logger.error(e.getMessage(), e);
		}

		return jsonObject;
	}

	/*
	 * 사이트 IP 삭제 프로시
	 * 
	 * @param model
	 * 
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/updateBlock.proc", method = RequestMethod.POST)
	public Map<String, Object> updateBlockproc(HttpSession session, PcMangrVo vo) throws Exception {
		Map<String, Object> jsonObject = new HashMap<String, Object>();

		try {

			if (vo.getUpdateBlockList().length > 0) {
				pcService.updateBlock(vo);
			}
			if (vo.getUpdateUnblockList().length > 0) {
				pcService.updateUnBlock(vo);
			}

			jsonObject.put("msg", Constant.Board.SUCCESS_GROUP_BOARD);
			jsonObject.put("success", true);

		} catch (DataIntegrityViolationException dive) {
			logger.error(dive.getMessage(), dive);
			jsonObject.put("msg", Constant.Board.SUCCESS_FAIL);
			jsonObject.put("success", false);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			jsonObject.put("msg", Constant.Board.SUCCESS_FAIL);
			jsonObject.put("success", false);
		}
		return jsonObject;
	}


	// pc excel 다운로드

	// @RequestMapping("/pcMngrListExcel")
	// public CmmnExcelService pcMngrListExcel(PcMangrVo vo, PagingVo pagingVo,HttpServletRequest
	// request, HttpServletResponse response, ModelMap model,
	// @RequestParam Map<String, String> params) throws Exception {
	// Map<String, Object> jsonObject = new HashMap<String, Object>();

	// // 페이징
	// pagingVo.setCurrentPage(vo.getPcListInfoCurrentPage());
	// pagingVo = PagingUtil.setDefaultPaging(PagingUtil.DefaultPaging, pagingVo);

	// int cnt = Integer.parseInt(pcmapper.countPcListInfo(vo) + "");
	// pagingVo.setTotalRecordSize(cnt);
	// pagingVo = PagingUtil.setPaging(pagingVo);

	// vo.setDate_fr(vo.getDate_fr().toString().replaceAll("/", "-"));
	// vo.setDate_to(vo.getDate_to().toString().replaceAll("/", "-"));

	// List<Map<String, Object>> list = pcmapper.pcMngrListExcel(vo);

	// String[] head
	// ={"번호","지역","부서이름","OS","CPU","MEMORY","DISK","MACADDRESS","IP","설치날짜","HOSTNAME"};
	// String[] column
	// ={"rownum","sido","deptname","pc_os","pc_cpu","pc_memory","pc_disk","pc_macaddress","pc_ip","first_date","pc_hostname"};
	// jsonObject.put("header", head); // Excel 상단
	// jsonObject.put("column", column); // Excel 상단
	// jsonObject.put("excelName","PC정보리스트"); // Excel 파일명
	// jsonObject.put("list", list); // Excel Data

	// model.addAttribute("data", jsonObject);
	// return new CmmnExcelService();
	// }

}
