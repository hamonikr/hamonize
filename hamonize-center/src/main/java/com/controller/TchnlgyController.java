package com.controller;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mapper.ITchnlgyMapper;
import com.model.AnswerVo;
import com.model.OrgVo;
import com.model.TchnlgyVo;
import com.paging.PagingUtil;
import com.paging.PagingVo;
import com.service.OrgService;
import com.service.TchnlgyService;
import com.util.CmmnExcelService;
import com.util.Constant;

@Controller
@RequestMapping("/tchnlgy")
public class TchnlgyController {

	@Autowired
	private TchnlgyService tchnlgyService;
	
	@Autowired
	private ITchnlgyMapper tchnlgyMapper;
	
	@Autowired
	private OrgService oService;

	
	/**
	 * 기술지원 목록 페이지
	 * @return
	 */
	@RequestMapping(value="/tchnlgyList")
	public String tchnlgyListPage(ModelMap model,HttpServletRequest request) {
		return "/tchnlgy/tchnlgyList";
	}
	
	
	
	/**
	 * 기술지원 목록 proc]
	 * @param vo
	 * @param pagingVo
	 * @param session
	 * @param request
	 * @return
	 */
	@ResponseBody
	@RequestMapping("tchnlgyList.proc")
	public Map<String, Object> listProc(ModelMap model,TchnlgyVo vo, PagingVo pagingVo, HttpSession session, HttpServletRequest request) {

		Map<String, Object> jsonObject = new HashMap<String, Object>();
		vo.setMngeListInfoCurrentPage(Integer.parseInt(request.getParameter("mngeListInfoCurrentPage")));
		// 페이징
		pagingVo = PagingUtil.setDefaultPaging(PagingUtil.DefaultPaging, pagingVo);
		pagingVo.setCurrentPage(vo.getMngeListInfoCurrentPage());
		TchnlgyVo cvo = tchnlgyMapper.countMngrListInfo(vo);
		int cnt = Integer.parseInt(cvo.getTbl_cnt());
		pagingVo.setTotalRecordSize(cnt);
		pagingVo = PagingUtil.setPaging(pagingVo);
		System.out.println("pagingVo==="+pagingVo.getCurrentPage());
		try {
			List<TchnlgyVo> gbList = tchnlgyService.tchnlgyList(vo, pagingVo);
			jsonObject.put("list", gbList);
			jsonObject.put("mngeVo", vo);
			jsonObject.put("cVo", cvo);
			jsonObject.put("pagingVo", pagingVo);
			jsonObject.put("success", true);
			model.addAttribute("list",gbList);
		} catch (Exception e) {
			jsonObject.put("success", false);
			e.printStackTrace();
		}

		return jsonObject;
	}
	
	
	@RequestMapping(value="/tchnlgyInsert")
	public String tchnlgyInsertPage(HttpSession session,ModelMap model) throws Exception {
		
		JSONArray orgList = null;
		OrgVo orgvo = new OrgVo();
		orgList = oService.orgList(orgvo);
		model.addAttribute("oList", orgList);
				
		return "/tchnlgy/tchnlgyInsert";
	}
	/**
	 * 기술지원 등록
	 * @param session
	 * @param vo
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="/tchnlgyInsert.proc", method=RequestMethod.POST)
	public Map<String, Object> tchnlgyAddProc(HttpSession session, TchnlgyVo vo) {
		Map<String, Object> jsonObject = new HashMap<String, Object>();

		try {
			tchnlgyService.tchnlgyInsert(vo);
			
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
	
	
	
	/**
	 * 기술지원 상세 페이지
	 * @param model
	 * @param vo
	 * @return
	 */
	@RequestMapping(value="/tchnlgyDetail.acnt")
	public String tchnlgyDetailAcnt(Model model, TchnlgyVo vo) {
		System.out.println("TchnlgyVo==="+ vo);
		
		TchnlgyVo viewVo = tchnlgyMapper.tchnlgyViewInfo(vo);
		
		List<AnswerVo> answerList = tchnlgyMapper.tchnlgyAnswerList(vo);
		
		model.addAttribute("answerList", answerList);
		model.addAttribute("viewVo", viewVo);
		model.addAttribute("mngeListInfoCurrentPage", vo.getMngeListInfoCurrentPage());
		
		return "/tchnlgy/tchnlgyDetail";
	}
	
	

	/**
	 * 기술지원 댓글 목록 proc]
	 * @param vo
	 * @param pagingVo
	 * @param session
	 * @param request
	 * @return
	 */
	@ResponseBody
	@RequestMapping("tchnlgyAnswerList.proc")
	public Map<String, Object> tchnlgyAnswerList(TchnlgyVo vo, PagingVo pagingVo, HttpSession session, HttpServletRequest request) {

		Map<String, Object> jsonObject = new HashMap<String, Object>();

		try {
			List<AnswerVo> answerList = tchnlgyMapper.tchnlgyAnswerList(vo);
			
			jsonObject.put("answerList", answerList);

			jsonObject.put("success", true);
		} catch (Exception e) {
			jsonObject.put("success", false);
			e.printStackTrace();
		}

		return jsonObject;
	}
	
	
	
	/**
	 * 기술지원 수정
	 * @param session
	 * @param vo
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="tchnlgyUpdate.proc", method=RequestMethod.POST)
	public Map<String, Object> tchnlgyUpdate(HttpSession session, TchnlgyVo vo) {
		System.out.println("nVo==="+ vo);
		
		Map<String, Object> jsonObject = new HashMap<String, Object>();
		
		try {
			int tmp = tchnlgyMapper.tchnlgyUpdateProc(vo);
			System.out.println("tmp======"+ tmp);
			
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
	
	
	
	/**
	 * 기술지원 삭제
	 * @param model
	 * @param vo
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="/tchnlgyDelete.proc", method=RequestMethod.POST)
	public Map<String, Object> tchnlgyDeleteProc(Model model, TchnlgyVo vo) {
		
		Map<String, Object> jsonObject = new HashMap<String, Object>();
		
		try {
			int tmp = tchnlgyMapper.tchnlgyDeleteProc(vo);
			System.out.println("tmp======"+ tmp);
			
			jsonObject.put("msg", Constant.Board.SUCCESS_DELETE);
			jsonObject.put("success", true);
			
		} catch (SQLException sqle) {
			sqle.printStackTrace();
			jsonObject.put("msg", Constant.Board.SUCCESS_DELETE_FAIL);
			jsonObject.put("success", false);
		} catch (DataIntegrityViolationException dive ){
			dive.printStackTrace();
			jsonObject.put("msg", Constant.Board.SUCCESS_DELETE_FAIL);
			jsonObject.put("success", false);
		} catch (Exception e) {
			e.printStackTrace();
			jsonObject.put("msg", Constant.Board.SUCCESS_DELETE_FAIL);
			jsonObject.put("success", false);
		}
		
		return jsonObject;
	}
	
	
	
	/*
	 * 기술지원 댓글 등록
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="/tchnlgyAnswerInsert.proc", method=RequestMethod.POST)
	public Map<String, Object> tchnlgyAnswerInsertProc(Model model, AnswerVo vo) {
		
		Map<String, Object> jsonObject = new HashMap<String, Object>();
		
		try {
			TchnlgyVo tVo = new TchnlgyVo();
			tVo.setSeq(vo.getTcngSeq());
			tVo.setSportStatus(vo.getSportStatus());
			tVo.setSportType_detail(vo.getSportType_detail());
			
			int tmp = tchnlgyMapper.tchnlgyAnswerInsertProc(vo);
			tchnlgyMapper.tchnlgyUpdateProc(tVo);
			
			System.out.println("tmp======"+ tmp);
			
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
	
	/*
	 * 기술지원 댓글 삭제
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="/tchnlgyAnswerDelete.proc", method=RequestMethod.POST)
	public Map<String, Object> tchnlgyAnswerDeleteProc(Model model, AnswerVo vo) {
		
		Map<String, Object> jsonObject = new HashMap<String, Object>();
		
		try {
			int tmp = tchnlgyMapper.tchnlgyAnswerDeleteProc(vo);
			System.out.println("tmp======"+ tmp);
			
			jsonObject.put("msg", Constant.Board.SUCCESS_DELETE);
			jsonObject.put("success", true);
			
		} catch (SQLException sqle) {
			sqle.printStackTrace();
			jsonObject.put("msg", Constant.Board.SUCCESS_DELETE_FAIL);
			jsonObject.put("success", false);
		} catch (DataIntegrityViolationException dive ){
			dive.printStackTrace();
			jsonObject.put("msg", Constant.Board.SUCCESS_DELETE_FAIL);
			jsonObject.put("success", false);
		} catch (Exception e) {
			e.printStackTrace();
			jsonObject.put("msg", Constant.Board.SUCCESS_DELETE_FAIL);
			jsonObject.put("success", false);
		}
		
		return jsonObject;
	}
	
	@RequestMapping("/tchnlgyExcel")
	public CmmnExcelService pcUserLogExcel(TchnlgyVo vo, PagingVo pagingVo,HttpServletRequest request, HttpServletResponse response, ModelMap model,
    		@RequestParam Map<String, String> params) throws Exception {
		System.out.println("params"+params.toString());
		Map<String, Object> jsonObject = new HashMap<String, Object>();
		
		vo.setDate_fr(vo.getDate_fr().replaceAll("/",""));
		vo.setDate_to(vo.getDate_to().replaceAll("/",""));

		// 페이징
		pagingVo.setCurrentPage(vo.getMngeListInfoCurrentPage());
		pagingVo = PagingUtil.setDefaultPaging(PagingUtil.DefaultPaging, pagingVo);
		pagingVo = PagingUtil.setPaging(pagingVo);

		List<Map<String, Object>> list = tchnlgyMapper.mngrListExcel(vo);
		
		String[] head ={"번호","이슈번호","접수구분","사지방번호","아이디","이름","제목","내용","전화번호","관리자정보","댓글","요청구분","진행상황","접수일","답변일"};
		String[] column ={"rownum","seq","state","org_nm","user_id","user_name","title","content","tel_num","admin_info","as_content","type","status","insert_dt","as_insert_dt"};
		jsonObject.put("header", head);		  // Excel 상단
		jsonObject.put("column", column);		  // Excel 상단
		jsonObject.put("excelName","장애신고접수내역");    // Excel 파일명
		jsonObject.put("list", list);          // Excel Data
		
		model.addAttribute("data", jsonObject);
		return new CmmnExcelService();
    }
	
}
