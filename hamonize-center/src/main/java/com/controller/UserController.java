package com.controller;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.google.gson.Gson;
import com.mapper.IUserMapper;
import com.model.OrgVo;
import com.model.UserVo;
import com.paging.PagingUtil;
import com.service.OrgService;
import com.service.UserService;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;


@Controller
@RequestMapping("/user")
public class UserController {

	@Autowired
	private IUserMapper userMapper;

	@Autowired
	private OrgService oService;

	@Autowired
	private UserService userSerivce;

	private Logger logger = LoggerFactory.getLogger(this.getClass());


	/*
	 * 사용자관리 페이지
	 * 
	 * @return
	 * 
	 * @throws Exception
	 */
	
	@GetMapping("/userList")
	public String userList(Model model, @RequestParam Map<String, Object> params) {
		JSONArray jsonArray = new JSONArray();
		try {
			OrgVo orgvo = new OrgVo();
			jsonArray = oService.orgList(orgvo);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		model.addAttribute("oList", jsonArray);

		return "/user/userList";
	}

	@ResponseBody
	@PostMapping("/userList.proc")
	public Map<String, Object> userListProc(Model model, UserVo vo,
			@RequestParam Map<String, Object> params) throws Exception {
		Map<String, Object> dataMap = new HashMap<String, Object>();
		List<UserVo> list = new ArrayList<UserVo>();
		vo.setOrg_seq(Long.valueOf(Integer.parseInt(params.get("org_seq").toString())));

		System.out.println("선택된 org_seq : " + vo.getOrg_seq());

		// 페이징
		vo.setCurrentPage(vo.getListInfoCurrentPage());
		vo = (UserVo) PagingUtil.setDefaultPaging(PagingUtil.DefaultPaging, vo);
		int cnt = Integer.parseInt(userMapper.countListInfo(vo) + "");
		vo.setTotalRecordSize(cnt);
		vo = (UserVo) PagingUtil.setPaging(vo);

		list = userSerivce.userList(vo);
		dataMap.put("list", list);
		dataMap.put("paging", vo);

		return dataMap;
	}

	@PostMapping("/view/{seq}")
	public String userView(@PathVariable("seq") int seq, UserVo vo, Model model) throws Exception {
		OrgVo ovo = new OrgVo();

		UserVo uvo = userSerivce.userView(vo);
		List<OrgVo> list = userSerivce.getOrgList(ovo);

		model.addAttribute("result", uvo);
		model.addAttribute("olist", list);

		return "/user/userAdd";

	}

	@PostMapping("/userAdd")
	public String userAddView(Model model, OrgVo vo) {
		List<OrgVo> list = userSerivce.getOrgList(vo);
		model.addAttribute("olist", list);

		return "/user/userAdd";
	}

	@PostMapping("/idDuplCheck")
	@ResponseBody
	public int idDuplCheck(Model model, UserVo vo) throws Exception {
		int result = 0;
		result = userSerivce.userIdCheck(vo);
		return result;

	}

	@PostMapping("/userSave")
	public String save(Model model, UserVo vo) throws Exception {
		System.out.println("userVo====="+vo);
		int result = 0;
		if(vo.getSeq() == null){
			result = userSerivce.userSave(vo);
		}else{
			result = userSerivce.userModify(vo);
		}
		return "redirect:/user/userList";
	}


	@PostMapping("/modify")
	@ResponseBody
	public int modify(Model model, UserVo vo) throws Exception {
		Timestamp timestamp = new Timestamp(System.currentTimeMillis());
		SimpleDateFormat timefomat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");

		int result = 0;

		result = userSerivce.userModify(vo);
		return result;

	}

	@PostMapping("/userDelete")
	@ResponseBody
	public int delete(Model model,  @RequestParam Map<String, Object> params)
			throws Exception {
		int result = 0;
		JSONParser jsonPr = new JSONParser();
		JSONArray jsonArray = (JSONArray) jsonPr.parse(params.get("userArr").toString());
		List<UserVo> voList = new ArrayList<>();

		for (int i = 0; i < jsonArray.size(); i++) {
			JSONObject jo = new JSONObject();
			jo = (JSONObject) jsonArray.get(i);
			UserVo tmp = new UserVo();
			tmp.setSeq(Long.parseLong(jo.get("seq").toString()));
			tmp.setUser_id(jo.get("user_id").toString());
			voList.add(tmp);
		}

		result = userSerivce.userDelete(voList);

		return result;

	}

}
