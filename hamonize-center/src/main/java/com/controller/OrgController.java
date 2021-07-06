package com.controller;

import java.util.ArrayList;
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
import com.mapper.IOrgMapper;
import com.model.OrgVo;
import com.service.IpManagementService;
import com.service.OrgService;
import com.util.LDAPConnection;


@Controller
@RequestMapping("/org/orgManage")
public class OrgController {
	@Autowired
	GlobalPropertySource gs;

	@Autowired
	private OrgService oService;
	
	@Autowired
	private IOrgMapper oMapper;
	
	/*
	 * 부서관리 페이지
	 * 
	 * @model gList : jsonGroupList
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(params="!type")
	public String orgList(HttpSession session, Model model,HttpServletRequest request) {
		JSONArray jsonArray = new JSONArray();

		try {
			// 저장된 조직 정보 출력 
			OrgVo orgvo = new OrgVo();
			jsonArray = oService.orgList(orgvo);
			for(int i=0;i<jsonArray.size();i++ ){
				System.out.println("org list --> "+ jsonArray.get(i).toString());
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		LDAPConnection con = new LDAPConnection();
		System.out.println("LDAPConnection ----> start....");
		
		try {
			con.main(gs.getLdapUrl(), gs.getLdapPassword());
		} catch (NamingException e1) {
			e1.printStackTrace();
		}

		model.addAttribute("oList", jsonArray);

		return "/org/orgList";
	}
	
	@ResponseBody
	@RequestMapping(params="type=show",method=RequestMethod.POST)
	public JSONObject orgView(HttpSession session, Model model,OrgVo orgvo) {
		// 선택한 조직 정보 출력
		orgvo = oService.orgView(orgvo);
		
		JSONObject data = new JSONObject();
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
		
		return data;
			
	}
	
	@ResponseBody
	@RequestMapping(params="type=save",method=RequestMethod.POST)
	public int orgSave(HttpSession session, Model model,OrgVo vo) throws Exception{
		// 조직 추가
		System.out.println("조직 추가 org >> "+ vo.toString());
		System.out.println("상위 부서 이름 >> "+ vo.getAll_org_nm());
		
		int result = oService.orgSave(vo);
		return result;
		
	}
	
	@ResponseBody
	@RequestMapping(params="type=delt",method=RequestMethod.POST)
	public int orgDelete(HttpSession session, Model model,OrgVo vo) throws Exception {
		System.out.println("조직 추가 org >> "+ vo.toString());
		System.out.println("상위 부문 이름 >>> "+ vo.getP_org_nm());
		int result = oService.orgDelete(vo);
		return result;
		
	}
	
	@RequestMapping("addAdServer")
	public void addAdServer() throws Exception{
		 List<OrgVo> oList = new ArrayList<OrgVo>();
		  oList = oMapper.orgList();
		  for(int i = 0; i < oList.size();i++) {
			//  AdLdapUtils adUtils = new AdLdapUtils();
			  OrgVo upGroupInfo = oMapper.groupUpperCode(oList.get(i));
				System.out.println(i+"-----------NEWupGroupInfo=================="+upGroupInfo.getOrg_nm());
				System.out.println("section====="+oList.get(i).getSection());
				System.out.println("부문이다!!!");
				
				//adUtils.adOuCreate(upGroupInfo.getOrg_nm());
				
				if("S".equals(oList.get(i).getSection()) ){
				// adUtils.sgbOuModify(upGroupInfo.getOrg_nm());
					System.out.println("부서다!!!!!!!!!!!!!!!");
				System.out.println("upGroupInfo.getOrgname()====="+ upGroupInfo.getOrg_nm().replaceAll("/","\\/"));
				}
			  System.out.println(oList.get(i).getOrg_nm());
		  }
	}

}
