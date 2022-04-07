package com.controller;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.hamonize.portal.user.SecurityUser;
import com.mapper.IPolicyUpdtMapper;
import com.model.FileVo;
import com.model.LoginVO;
import com.model.OrgVo;
import com.model.PolicyUpdtVo;
import com.paging.PagingUtil;
import com.paging.PagingVo;
import com.service.AgentAptListService;
import com.service.FileService;
import com.service.OrgService;
import com.service.PolicyUpdtService;
import com.service.RestApiService;
import com.util.AuthUtil;
import com.util.Constant;
import com.util.ShellRunner;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

@Controller
@RequestMapping("/gplcs")
public class PolicyUpdtController {

	@Autowired
	private OrgService oService;

	@Autowired
	private PolicyUpdtService uService;

	@Autowired
	private IPolicyUpdtMapper uMapper;

	@Autowired
	private AgentAptListService aService;

	@Autowired
	RestApiService restApiService;

	@Autowired
	FileService fileService;

	private Logger logger = LoggerFactory.getLogger(this.getClass());

	/**
	 * 업데이트 관리 페이지 apt 에서 패키지 리스트 가져와 db에 저장 후 출력
	 * 
	 * @param session
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/umanage", method = RequestMethod.GET)
	public String manage(HttpSession session, Model model) throws Exception {
		JSONArray jsonArray = new JSONArray();
		List<PolicyUpdtVo> pList = null;
		// APT저장소 목록
		List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
		// 센터 업데이트 프로그램 목록
		List<Map<String, Object>> pSearchList = new ArrayList<Map<String, Object>>();
		// 신규등록 프로그램 목록
		List<Map<String, Object>> newAdd = new ArrayList<Map<String, Object>>();
		// 버전 업데이트 프로그램 목록
		List<Map<String, Object>> newUpdate = new ArrayList<Map<String, Object>>();
		Map<String, Object> params;

		try {
			OrgVo orgvo = new OrgVo();
			PolicyUpdtVo vo = new PolicyUpdtVo();
			jsonArray = oService.orgList(orgvo);

			// 디비에 설치된 패키지 정보
			pSearchList = uMapper.updtComapreList();
			// apt 저장소에 있는 버전
			listMap = aService.getApt();


			System.out.println("comparing....\n");
			// APT저장소와 업데이트목록 비교후 등록 및 업데이트
			for (int i = 0; i < listMap.size(); i++) {
				boolean chk = false;
				for (int j = 0; j < pSearchList.size(); j++) {
					if (listMap.get(i).get("package").equals(pSearchList.get(j).get("pu_name"))) {
						chk = true;
						if (!listMap.get(i).get("version")
								.equals(pSearchList.get(j).get("deb_new_version"))) {
							int result = uService.updtCompareUpdate(listMap.get(i));
							break;
						} else {
							break;
						}
					} else {
						chk = false;
					}
				}
				if (!chk) {
					newAdd.add(listMap.get(i));
				}
			}
			// apt 저장소에 새로운 패키지 있을경우 추가
			if (!newAdd.isEmpty()) {
				params = new HashMap<String, Object>();
				params.put("data", newAdd);

				// 다시 새로운 패키지 정보 비교해서 디비에 저장
				int result = uService.updtCompareSave(params);
				System.out.println("result====" + result);
			}
			SecurityUser lvo = AuthUtil.getLoginSessionInfo();
			// LoginVO lvo = AuthUtil.getLoginSessionInfo();
		
			vo.setDomain(lvo.getDomain());
			pList = uService.updtList(vo);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		model.addAttribute("oList", jsonArray);
		model.addAttribute("pList", pList);

		return "/policy/updtManage";

	}

	@ResponseBody
	@RequestMapping(value = "/usave", method = RequestMethod.POST)
	public JSONObject usave(HttpSession session, Model model,
			@RequestParam Map<String, Object> params) throws ParseException, InterruptedException {
		JSONParser jp = new JSONParser();
		String data = params.get("data").toString();
		JSONArray jsonArray = (JSONArray) jp.parse(data);
		List<Map<String, Object>> resultSet = new ArrayList<Map<String, Object>>();
		Map<String, Object> resultMap;
		for (int i = 0; i < jsonArray.size(); i++) {
			resultMap = new HashMap<String, Object>();
			String ch = jsonArray.get(i).toString().replaceAll("[^0-9]", "");
			resultMap.put("org_seq", Integer.parseInt(ch));
			resultSet.add(resultMap);
		}
		params.put("data", resultSet);
		System.out.println("params..." + params);
		int result = 0;
		//ansible 정책전달
		JSONObject jobResult = uService.applyPackagePolicy(params);
		
		params.put("job_id", jobResult.get("id"));
		uService.updtDelete(params);
		result = uService.updtSave(params);
		
		//차단정책 초기화
		uService.updatePolicyProgrm(params);
		JSONObject jsonObj = new JSONObject();
		
		if (result >= 1){
			jsonObj.put("STATUS", "SUCCESS");
			jsonObj.put("ID", jobResult.get("id"));
			jsonObj.put("JOBSTATUS", jobResult.get("status"));
		} else{
			jsonObj.put("STATUS", "FAIL");
		}
		return jsonObj;
	}

	@ResponseBody
	@RequestMapping(value = "ushow", method = RequestMethod.POST)
	public JSONObject ushow(HttpSession session, Model model, PolicyUpdtVo vo) {
		JSONObject data = new JSONObject();
		System.out.println("vo====="+vo.toString());
		try {
			data.put("job_id", uService.getUpdtHistoryLastJob(vo));
			vo = uService.updtApplcView(vo);
			data.put("dataInfo", vo);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		return data;

	}

	@ResponseBody
	@RequestMapping(value = "uManagePopList", method = RequestMethod.POST)
	public Map<String, Object> uManagePopList(PolicyUpdtVo vo, PagingVo pagingVo,
			HttpSession session, HttpServletRequest request) {
		Map<String, Object> jsonObject = new HashMap<String, Object>();
		JSONArray ja = new JSONArray();
		SecurityUser lvo = AuthUtil.getLoginSessionInfo();
		// LoginVO lvo = AuthUtil.getLoginSessionInfo();
		
		vo.setDomain(lvo.getDomain());
		// 페이징
		pagingVo.setCurrentPage(vo.getMngeListInfoCurrentPage());
		pagingVo = PagingUtil.setDefaultPaging(PagingUtil.LayerPopupPaging, pagingVo);

		int cnt = uMapper.updtPopCount(vo);
		pagingVo.setTotalRecordSize(cnt);
		pagingVo = PagingUtil.setPaging(pagingVo);

		try {
			List<PolicyUpdtVo> gbList = uService.uManagePopList(vo, pagingVo);
			List<FileVo> files = fileService.getFile("updt");
			jsonObject.put("list", gbList);
			jsonObject.put("filelist", files);
			jsonObject.put("mngeVo", vo);
			jsonObject.put("pagingVo", pagingVo);
			jsonObject.put("success", true);
		} catch (Exception e) {
			jsonObject.put("success", false);
			logger.error(e.getMessage(), e);
		}

		return jsonObject;
	}

	@ResponseBody
	@RequestMapping(value = "/uManagePopSave", method = RequestMethod.POST)
	public Map<String, Object> uManagePopSave(HttpSession session, PolicyUpdtVo vo,@RequestParam("keyfile") MultipartFile mFile,@RequestParam Map<String,Object> params)
			throws Exception {
		Map<String, Object> jsonObject = new HashMap<String, Object>();
		SecurityUser lvo = AuthUtil.getLoginSessionInfo();
		// LoginVO lvo = AuthUtil.getLoginSessionInfo();
		vo.setDomain(lvo.getDomain());
		try {
			FileVo fvo = new FileVo();
			fvo.setP_seq(vo.getPu_seq());
			fvo.setKind(params.get("kind").toString());
			fvo.setDomain(lvo.getDomain());
			Map sf = fileService.uploadFile(mFile,fvo);
			fvo.setFilepath(sf.get("filepath").toString());
			ShellRunner sr = new ShellRunner();
			String cmd = "dpkg --info "+sf.get("filepath")+" | grep Package: \n"
			+"dpkg --info "+sf.get("filepath")+" | grep Version:";
			String[] callCmd = {"/bin/bash", "-c", cmd};
			sf = sr.execCommand(callCmd);
			String [] restunrs = sf.get(1).toString().split("\n");
			vo.setDeb_apply_name(restunrs[0].split(":")[1]);
			vo.setDeb_new_version(restunrs[1].split(":")[1]);
			uService.updtPopSave(vo);
			OrgVo orgvo = new OrgVo();
			orgvo.setDomain(lvo.getDomain());
			restApiService.addAptRepoPackage(orgvo,mFile);
			fileService.deleteFile(fvo);
			jsonObject.put("msg", Constant.Board.SUCCESS_GROUP_BOARD);
			jsonObject.put("success", true);

		} catch (SQLException sqle) {
			logger.error(sqle.getMessage(), sqle);
			jsonObject.put("msg", Constant.Board.SUCCESS_FAIL);
			jsonObject.put("success", false);
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

	@ResponseBody
	@RequestMapping(value = "/uManagePopDelete", method = RequestMethod.POST)
	public Map<String, Object> uManagePopDelete(HttpSession session, PolicyUpdtVo vo)
			throws Exception {
		Map<String, Object> jsonObject = new HashMap<String, Object>();
		
		SecurityUser lvo = AuthUtil.getLoginSessionInfo();
		// LoginVO lvo = AuthUtil.getLoginSessionInfo();
		
		vo.setDomain(lvo.getDomain());
		
		try {
			uService.updtPopDelete(vo);

			jsonObject.put("msg", Constant.Board.SUCCESS_GROUP_BOARD);
			jsonObject.put("success", true);

		} catch (SQLException sqle) {
			logger.error(sqle.getMessage(), sqle);
			jsonObject.put("msg", Constant.Board.SUCCESS_FAIL);
			jsonObject.put("success", false);
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

}
