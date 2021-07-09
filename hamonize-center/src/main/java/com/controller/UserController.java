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
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mapper.IUserMapper;
import com.model.OrgVo;
import com.model.UserVo;
import com.paging.PagingUtil;
import com.paging.PagingVo;
import com.service.OrgService;
import com.service.UserService;
import com.util.StringUtil;

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
	
	@RequestMapping(value = "/view/{seq}")
	public String userView(@PathVariable("seq") int seq, UserVo vo, Model model) throws Exception {
		System.out.println("user seq : "+ seq);
		OrgVo ovo = new OrgVo();

		UserVo uvo = userSerivce.userView(vo);

		System.out.println("org name : "+uvo.getOrg_nm());
		System.out.println("org seq : "+uvo.getOrg_seq());

		List<OrgVo> list = userSerivce.getOrgList(ovo);

		model.addAttribute("result", uvo);
		model.addAttribute("olist", list);

		return "/user/userAdd";

	}

	@RequestMapping("/userAdd")
	public String userAddView(Model model, OrgVo vo) {		
		List<OrgVo> list = userSerivce.getOrgList(vo);
		model.addAttribute("olist", list);

		return "/user/userAdd";
	}

	@RequestMapping("/idDuplCheck")
	@ResponseBody
	public int idDuplCheck(Model model,UserVo vo) throws Exception{
		int result = 0;
		System.out.println("user id check-- > "+ vo.getUser_id());
		
		result = userSerivce.userIdCheck(vo);
		return result;
		
	}

	@RequestMapping("/userSave")
	public String save(Model model, UserVo vo) {
		int result = userSerivce.userSave(vo);

		if(result>=1){
			System.out.println("user 저장 성공 >> "+ result);
		}else{
			System.out.println("user 저장 실패 >> "+ result);
		}

		return "redirect:/user/userList";
	}


	@RequestMapping("/modify")
	@ResponseBody
	public int modify(Model model, UserVo vo) throws Exception {
		int result=0;
		System.out.println("vo : " +vo.toString());
		result = userSerivce.userModify(vo);
		return result;
		
	}
	
	@RequestMapping(value = "/delete", method = RequestMethod.POST)
	@ResponseBody
	public int delete(Model model, @RequestParam(value = "seqs[]") List<Integer> list ) throws Exception{
		int result =0;
		List<UserVo> voList = new ArrayList<> ();
	
		for(int i=0;i<list.size();i++){
			UserVo tmp = new UserVo();
			tmp.setSeq(list.get(i));
			voList.add(tmp);
		}
		System.out.println("user 수정---");
		result = userSerivce.userDelete(voList);
	
		return result;
		
	}
	
}
