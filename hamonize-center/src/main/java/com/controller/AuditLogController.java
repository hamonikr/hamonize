package com.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mapper.IAuditLogMapper;
import com.model.AuditLogVo;
import com.model.OrgVo;
import com.model.PcMangrVo;
import com.model.PcDataVo;
import com.paging.PagingUtil;
import com.paging.PagingVo;
import com.service.AuditLogService;
import com.service.OrgService;
import com.service.MonitoringService;

@Controller
@RequestMapping("/auditLog")
public class AuditLogController {

	@Autowired
	private OrgService oService;

	@Autowired
	private AuditLogService logService;

	@Autowired
	private MonitoringService miService;

	@Autowired
	private IAuditLogMapper logMapper;

	private Logger logger = LoggerFactory.getLogger(this.getClass());


	/*
	 * PC 사용 로그
	 * 
	 * @param model
	 * 
	 * @return
	 */
	@RequestMapping(value = "/pcUserLog", method = RequestMethod.GET)
	public String pcUserLog(Model model, @RequestParam Map<String, Object> params) {
		JSONArray jsonArray = new JSONArray();
		try {
			OrgVo orgvo = new OrgVo();
			jsonArray = oService.orgList(orgvo);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		model.addAttribute("oList", jsonArray);

		return "/auditLog/pcUserLog";
	}

	@ResponseBody
	@RequestMapping(value = "userLogList.proc", method = RequestMethod.POST)
	public Map<String, Object> listProc(AuditLogVo vo, PagingVo pagingVo, HttpSession session,
			HttpServletRequest request) {

		Map<String, Object> jsonObject = new HashMap<String, Object>();

		if (!"".equals(vo.getDate_fr()))
			vo.setDate_fr(vo.getDate_fr().replaceAll("/", "") + " 00:00:00");
		if (!"".equals(vo.getDate_to()))
			vo.setDate_to(vo.getDate_to().replaceAll("/", "") + " 23:59:59");

		// 페이징
		pagingVo.setCurrentPage(vo.getCurrentPage());
		pagingVo = PagingUtil.setDefaultPaging(PagingUtil.DefaultPaging, pagingVo);

		int cnt = Integer.parseInt(logMapper.countUserLogListInfo(vo) + "");
		pagingVo.setTotalRecordSize(cnt);
		pagingVo = PagingUtil.setPaging(pagingVo);

		try {
			int index = 0;
			List<AuditLogVo> list = logService.userLogList(vo, pagingVo);
			List<PcDataVo> influxList = miService.influxInfo();
			for (AuditLogVo el : list) {
				for (PcDataVo pd : influxList) {
					if (el.getPc_uuid().equals(pd.getHost())) {
						list.get(index).setState("Y");
					}
				}
				index++;
			}

			jsonObject.put("list", list);
			jsonObject.put("auditLogVo", vo);
			jsonObject.put("pagingVo", pagingVo);

			jsonObject.put("success", true);
		} catch (Exception e) {
			jsonObject.put("success", false);
			logger.error(e.getMessage(), e);
		}

		return jsonObject;
	}



	/**
	 * PC 하드웨어 변경
	 * 
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/pcChangeLog", method = RequestMethod.GET)
	public String pcChangeLog(Model model, @RequestParam Map<String, Object> params) {
		JSONArray jsonArray = new JSONArray();
		try {
			OrgVo orgvo = new OrgVo();
			jsonArray = oService.orgList(orgvo);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		model.addAttribute("oList", jsonArray);

		return "/auditLog/pcChangeLog";
	}

	@ResponseBody
	@RequestMapping(value = "pcChangeLogList.proc", method = RequestMethod.POST)
	public Map<String, Object> pcChangeLogList(AuditLogVo vo, PagingVo pagingVo,
			HttpSession session, HttpServletRequest request) {

		Map<String, Object> jsonObject = new HashMap<String, Object>();

		if (!"".equals(vo.getDate_fr()))
			vo.setDate_fr(vo.getDate_fr().replaceAll("/", "") + " 00:00:00");
		if (!"".equals(vo.getDate_to()))
			vo.setDate_to(vo.getDate_to().replaceAll("/", "") + " 23:59:59");

		// 페이징
		pagingVo.setCurrentPage(vo.getCurrentPage());
		pagingVo = PagingUtil.setDefaultPaging(PagingUtil.DefaultPaging, pagingVo);

		int cnt = Integer.parseInt(logMapper.countPcChangeLogListInfo(vo) + "");
		pagingVo.setTotalRecordSize(cnt);
		pagingVo = PagingUtil.setPaging(pagingVo);

		try {
			List<AuditLogVo> list = logService.pcChangeLogList(vo, pagingVo);
			jsonObject.put("list", list);
			jsonObject.put("auditLogVo", vo);
			jsonObject.put("pagingVo", pagingVo);

			jsonObject.put("success", true);
		} catch (Exception e) {
			jsonObject.put("success", false);
			logger.error(e.getMessage(), e);
		}

		return jsonObject;
	}


	/**
	 * PC 사용 로그
	 * 
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/unAuthLog", method = RequestMethod.GET)
	public String unAuthLog(Model model, @RequestParam Map<String, Object> params) {
		JSONArray jsonArray = new JSONArray();
		try {
			OrgVo orgvo = new OrgVo();
			jsonArray = oService.orgList(orgvo);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		model.addAttribute("oList", jsonArray);

		return "/auditLog/pcUnAuthLog";
	}

	@ResponseBody
	@RequestMapping(value = "unAuthLogList.proc", method = RequestMethod.POST)
	public Map<String, Object> unAuthLogListproc(AuditLogVo vo, PagingVo pagingVo,
			HttpSession session, HttpServletRequest request) {


		Map<String, Object> jsonObject = new HashMap<String, Object>();

		if (!"".equals(vo.getDate_fr()))
			vo.setDate_fr(vo.getDate_fr().replaceAll("/", "") + " 00:00:00");
		if (!"".equals(vo.getDate_to()))
			vo.setDate_to(vo.getDate_to().replaceAll("/", "") + " 23:59:59");

		// 페이징
		pagingVo.setCurrentPage(vo.getCurrentPage());
		pagingVo = PagingUtil.setDefaultPaging(PagingUtil.DefaultPaging, pagingVo);

		int cnt = Integer.parseInt(logMapper.countUnAuthLogListInfo(vo) + "");
		pagingVo.setTotalRecordSize(cnt);
		pagingVo = PagingUtil.setPaging(pagingVo);

		try {
			List<AuditLogVo> list = logService.unAuthLogList(vo, pagingVo);
			jsonObject.put("list", list);
			jsonObject.put("auditLogVo", vo);
			jsonObject.put("pagingVo", pagingVo);

			jsonObject.put("success", true);
		} catch (Exception e) {
			jsonObject.put("success", false);
			logger.error(e.getMessage(), e);
		}

		return jsonObject;
	}



	/**
	 * 프로세스 차단 로그
	 * 
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/prcssBlockLog", method = RequestMethod.GET)
	public String prcssBlockLog(Model model, @RequestParam Map<String, Object> params) {
		JSONArray jsonArray = new JSONArray();
		try {
			OrgVo orgvo = new OrgVo();
			jsonArray = oService.orgList(orgvo);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		model.addAttribute("oList", jsonArray);

		return "/auditLog/prcssBlockLog";
	}

	@ResponseBody
	@RequestMapping(value = "prcssBlockLogList.proc", method = RequestMethod.POST)
	public Map<String, Object> prcssBlockLogList(AuditLogVo vo, PagingVo pagingVo,
			HttpSession session, HttpServletRequest request) {

		Map<String, Object> jsonObject = new HashMap<String, Object>();

		if (!"".equals(vo.getDate_fr()))
			vo.setDate_fr(vo.getDate_fr().replaceAll("/", "") + " 00:00:00");
		if (!"".equals(vo.getDate_to()))
			vo.setDate_to(vo.getDate_to().replaceAll("/", "") + " 23:59:59");

		// 페이징
		pagingVo.setCurrentPage(vo.getCurrentPage());
		pagingVo = PagingUtil.setDefaultPaging(PagingUtil.DefaultPaging, pagingVo);

		int cnt = Integer.parseInt(logMapper.countPrcssBlockLogListInfo(vo) + "");
		pagingVo.setTotalRecordSize(cnt);
		pagingVo = PagingUtil.setPaging(pagingVo);

		try {
			List<AuditLogVo> list = logService.prcssBlockLogList(vo, pagingVo);
			jsonObject.put("list", list);
			jsonObject.put("auditLogVo", vo);
			jsonObject.put("pagingVo", pagingVo);

			jsonObject.put("success", true);
		} catch (Exception e) {
			jsonObject.put("success", false);
			logger.error(e.getMessage(), e);
		}

		return jsonObject;
	}

	/*
	 * 프로세스 차단 로그
	 * 
	 * @param model
	 * 
	 * @return
	 */
	@RequestMapping(value = "/updateCheckLog", method = RequestMethod.GET)
	public String updateCheckLog(Model model, @RequestParam Map<String, Object> params) {
		JSONArray jsonArray = new JSONArray();
		try {
			OrgVo orgvo = new OrgVo();
			jsonArray = oService.orgList(orgvo);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		model.addAttribute("oList", jsonArray);

		return "/auditLog/updateCheckLog";
	}




	@ResponseBody
	@RequestMapping(value = "pcMngrList.proc", method = RequestMethod.POST)
	public Map<String, Object> listProc(PcMangrVo vo, PagingVo pagingVo, HttpSession session,
			HttpServletRequest request) {
		Map<String, Object> jsonObject = new HashMap<String, Object>();

		// 페이징
		pagingVo.setCurrentPage(vo.getPcListInfoCurrentPage());
		pagingVo = PagingUtil.setDefaultPaging(PagingUtil.DefaultPaging, pagingVo);
		pagingVo = PagingUtil.setPaging(pagingVo);

		try {
			jsonObject.put("pcVo", vo);
			jsonObject.put("pagingVo", pagingVo);

			jsonObject.put("success", true);
		} catch (Exception e) {
			jsonObject.put("success", false);
			logger.error(e.getMessage(), e);
		}

		return jsonObject;
	}

	@ResponseBody
	@RequestMapping(value = "detailPolicy.proc", method = RequestMethod.POST)
	public HashMap<String, Object> detailPolicy(@RequestParam HashMap<String, Object> params,
			HttpSession session) {

		HashMap<String, Object> jsonObject = new HashMap<String, Object>();

		try {
			jsonObject.put("udpt", logService.udptList(params));
			jsonObject.put("program", logService.programList(params));
			jsonObject.put("device", logService.deviceList(params));
			jsonObject.put("firewall", logService.firewallList(params));
		} catch (Exception e) {
			jsonObject.put("success", false);
			logger.error(e.getMessage(), e);
		}

		return jsonObject;
	}


}
