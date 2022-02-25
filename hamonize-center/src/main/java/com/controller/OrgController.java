package com.controller;

import java.util.List;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.GlobalPropertySource;
import com.hamonize.portal.user.SecurityUser;
import com.model.LoginVO;
import com.model.OrgVo;
import com.service.OrgService;
import com.util.AuthUtil;
import com.util.LDAPConnection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Controller
@RequestMapping(value = "/org/orgManage", method = RequestMethod.GET)
public class OrgController {
	@Autowired
	GlobalPropertySource gs;

	@Autowired
	private OrgService oService;

	private Logger logger = LoggerFactory.getLogger(this.getClass());

	/*
	 * 부서관리 페이지
	 * 
	 * @model gList : jsonGroupList
	 * 
	 * @return
	 * 
	 * @throws Exception
	 */
	@RequestMapping(params = "!type", method = RequestMethod.POST)
	public String orgList(HttpSession session, Model model, HttpServletRequest request) {
		JSONArray jsonArray = new JSONArray();
		try {
			// 저장된 조직 정보 출력
			OrgVo orgvo = new OrgVo();
			jsonArray = oService.orgList(orgvo);

		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		LDAPConnection con = new LDAPConnection();

		try {
			con.connection(gs.getLdapUrl(), gs.getLdapPassword());
		} catch (NamingException e1) {
			logger.error(e1.getMessage(), e1);
		}

		model.addAttribute("oList", jsonArray);
		model.addAttribute("domain", AuthUtil.getLoginSessionInfo().getDomain());
		return "/org/orgList";
	}

	/*
	 * 선택한 조직 정보 출력
	 * 
	 * @return data
	 * 
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(params = "type=show", method = RequestMethod.POST)
	public JSONObject orgView(HttpSession session, Model model, OrgVo orgvo) {

		orgvo = oService.orgView(orgvo);

		JSONObject data = new JSONObject();
		data.put("domain", orgvo.getDomain());
		data.put("seq", orgvo.getSeq());
		data.put("p_seq", orgvo.getP_seq());
		data.put("org_nm", orgvo.getOrg_nm());
		data.put("p_org_nm", orgvo.getP_org_nm());
		data.put("all_org_nm", orgvo.getAll_org_nm());
		data.put("sido", orgvo.getSido());
		data.put("gugun", orgvo.getGugun());
		data.put("section", orgvo.getSection());
		data.put("org_num", orgvo.getOrg_num());
		data.put("org_ordr", orgvo.getOrg_ordr());
		data.put("inventory_id", orgvo.getInventory_id());
		data.put("group_id", orgvo.getGroup_id());

		return data;

	}


	/*
	 * 조직 추가
	 * 
	 */
	@ResponseBody
	@RequestMapping(params = "type=save", method = RequestMethod.POST)
	public int orgSave(HttpSession session, Model model, OrgVo vo) throws Exception {
		SecurityUser lvo = (SecurityUser)session.getAttribute("userSession");
		vo.setDomain(lvo.getDomain());
		int result = oService.orgSave(vo);
		return result;

	}

	/*
	 * 조직 삭제
	 * 
	 */
	@ResponseBody
	@RequestMapping(params = "type=delt", method = RequestMethod.POST)
	public int orgDelete(HttpSession session, Model model, OrgVo vo) throws Exception {
		int result = 0;
		result = oService.orgDelete(vo);
		return result;

	}

	/*
	 * 하위 조직 불러오기
	 * 
	 */
	@ResponseBody
	@RequestMapping(params = "type=searchChildDept", method = RequestMethod.POST)
	public List<OrgVo> searchChildDept(HttpSession session, Model model, OrgVo vo) throws Exception {
		SecurityUser lvo = AuthUtil.getLoginSessionInfo();
		vo.setDomain(lvo.getDomain());
		List<OrgVo> list = oService.searchChildDept(vo);
		return list;

	}
}
