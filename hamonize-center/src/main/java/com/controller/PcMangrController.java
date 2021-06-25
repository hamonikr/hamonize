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

import com.mapper.IPcMangrMapper;
import com.model.AllowIpInfoVo;
import com.model.AuditLogVo;
import com.model.OrgVo;
import com.model.PcMangrVo;
import com.paging.PagingUtil;
import com.paging.PagingVo;
import com.service.OrgService;
import com.service.PcMangrService;
import com.util.CmmnExcelService;
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

	/*
	 * PC관리 페이지
	 * 
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/pcMngrList")
	public String pcMngrList(Model model ,@RequestParam Map<String, Object> params ) {
		JSONArray jsonArray = new JSONArray();
		try {
			OrgVo orgvo = new OrgVo();
			jsonArray = oService.orgList(orgvo);
		} catch (Exception e) {
			e.printStackTrace();
		}
	
		model.addAttribute("oList", jsonArray);
		model.addAttribute("pc_change", (String)params.get("pc_change"));
		if("R".equals(params.get("pc_change")) && params.get("pc_change") != "" )
			return "/pcMngr/pcListMove";
		else
		return "/pcMngr/pcList";
	}

	@ResponseBody
	@RequestMapping("pcMngrList.proc")
	public Map<String, Object> listProc(PcMangrVo vo, PagingVo pagingVo, HttpSession session, HttpServletRequest request) {

		System.out.println("1===========" + vo.getOrg_seq());
		System.out.println("2===========" + vo.getPc_change());
		System.out.println("3===========" + vo.getTxtSearch());
		System.out.println("4===========" + vo.getKeyWord());
		
		Map<String, Object> jsonObject = new HashMap<String, Object>();

		// 페이징
		pagingVo.setCurrentPage(vo.getPcListInfoCurrentPage());
		pagingVo = PagingUtil.setDefaultPaging(PagingUtil.DefaultPaging, pagingVo);

		int cnt = Integer.parseInt(pcmapper.countPcListInfo(vo) + "");
		pagingVo.setTotalRecordSize(cnt);
		pagingVo = PagingUtil.setPaging(pagingVo);

		try {
			List<PcMangrVo> gbList = pcService.pcMangrList(vo, pagingVo);
			for (int i=0;i<gbList.size();i++){
				System.out.println("gbList >>> "+ gbList.get(i).toString());
			}

			jsonObject.put("list", gbList);
			jsonObject.put("pcVo", vo);
			jsonObject.put("pagingVo", pagingVo);
			jsonObject.put("success", true);
		} catch (Exception e) {
			jsonObject.put("success", false);
			e.printStackTrace();
		}

		return jsonObject;
	}
	
	@RequestMapping("/pcMngrListExcel")
	public CmmnExcelService pcMngrListExcel(PcMangrVo vo, PagingVo pagingVo,HttpServletRequest request, HttpServletResponse response, ModelMap model,
    		@RequestParam Map<String, String> params) throws Exception {
		Map<String, Object> jsonObject = new HashMap<String, Object>();

		// 페이징
		pagingVo.setCurrentPage(vo.getPcListInfoCurrentPage());
		pagingVo = PagingUtil.setDefaultPaging(PagingUtil.DefaultPaging, pagingVo);

		int cnt = Integer.parseInt(pcmapper.countPcListInfo(vo) + "");
		pagingVo.setTotalRecordSize(cnt);
		pagingVo = PagingUtil.setPaging(pagingVo);
		
		vo.setDate_fr(vo.getDate_fr().toString().replaceAll("/", "-"));
		vo.setDate_to(vo.getDate_to().toString().replaceAll("/", "-"));

		List<Map<String, Object>> list = pcmapper.pcMngrListExcel(vo);
		
		String[] head ={"번호","지역","부서이름","OS","CPU","MEMORY","DISK","MACADDRESS","IP","설치날짜","HOSTNAME"};
		String[] column ={"rownum","sido","deptname","pc_os","pc_cpu","pc_memory","pc_disk","pc_macaddress","pc_ip","first_date","pc_hostname"};
		jsonObject.put("header", head);		  // Excel 상단
		jsonObject.put("column", column);		  // Excel 상단
		jsonObject.put("excelName","PC정보리스트");    // Excel 파일명
		jsonObject.put("list", list);          // Excel Data
		
		model.addAttribute("data", jsonObject);
		return new CmmnExcelService();
    }
	
	@ResponseBody
	@RequestMapping("changeStts")
	public Object changeStts(PcMangrVo vo) {
		int result = pcmapper.changeStts(vo);
		
		if(result > 0) {
			int re = pcmapper.changeInsertHistory(vo);
			pcmapper.updateHistory(vo);
			if("P".equals(vo.getPc_change())){
				pcmapper.insertMoveInfo(vo);
			}
			if("F".equals(vo.getSttus())) {
				pcmapper.deleteMoveInfo(vo);
			}
			return "SUCCESS";
		}else
			return "FAIL";
		
	}
	
	
	@ResponseBody
	@RequestMapping("requestCount")
	public int requestCount() {
		int result = pcmapper.requestCount();
		//System.out.println("result1========"+result);
		return result;
		
	}

	
	@ResponseBody
	@RequestMapping(value = "/getMovePcInfo")
	public Map<String, Object> getMovePcInfo(PcMangrVo vo,Model model ,@RequestParam Map<String, Object> params ) {
		Map<String, Object> jsonObject = new HashMap<String, Object>();
		
		jsonObject.put("result", pcmapper.pcMoveInfo(vo));
		
		return jsonObject;
	}
	
	
	/*
	 * PC 차단 관리 페이지
	 * 
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/pcBlockList")
	public String pcBlockList(Model model ,@RequestParam Map<String, Object> params ) {
		JSONArray jsonArray = new JSONArray();
	
		try {
			OrgVo orgvo = new OrgVo();
			jsonArray = oService.orgList(orgvo);
		} catch (Exception e) {
			e.printStackTrace();
	
		}
	
		model.addAttribute("oList", jsonArray);
		model.addAttribute("pc_change", (String)params.get("pc_change"));
		if("R".equals(params.get("pc_change")) && params.get("pc_change") != "" )
			return "/pcMngr/pcListMove";
		else
		return "/pcMngr/pcBlockList";
	}

	@ResponseBody
	@RequestMapping("pcBlockList.proc")
	public Map<String, Object> blockListProc(PcMangrVo vo, PagingVo pagingVo, HttpSession session, HttpServletRequest request) {

		System.out.println("1===========" + vo.getOrg_seq());
		System.out.println("2===========" + vo.getPc_change());
		System.out.println("3===========" + vo.getTxtSearch());
		System.out.println("4===========" + vo.getKeyWord());
		
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
			e.printStackTrace();
		}

		return jsonObject;
	}
	
	/*
	 * 사이트 IP 삭제 프로시
	 * 
	 * @param model
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/updateBlock.proc", method=RequestMethod.POST)
	public Map<String, Object> updateBlockproc(HttpSession session, PcMangrVo vo) throws Exception {
		Map<String, Object> jsonObject = new HashMap<String, Object>();
		System.out.println("getUpdateBlockList========"+vo.getUpdateBlockList());
		
		try {
	
			if(vo.getUpdateBlockList().length > 0){
				pcService.updateBlock(vo);
			}
			if(vo.getUpdateUnblockList().length > 0){
				pcService.updateUnBlock(vo);
			}
			
			jsonObject.put("msg", Constant.Board.SUCCESS_GROUP_BOARD);
			jsonObject.put("success", true);
			
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
	
	
}