package com.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mapper.IPcMangrMapper;
import com.model.OrgVo;
import com.model.PcDataVo;
import com.model.PcMangrVo;
import com.model.PcMemoryDataVo;
import com.service.MonitoringService;
import com.service.OrgService;

@Controller
@RequestMapping("/mntrng")
public class MonitoringController {
	
	@Autowired
	private OrgService oService;
	
	@Autowired
	private MonitoringService mService;
	
	@Autowired
	private IPcMangrMapper pcmp;
	
	@RequestMapping(value = "/pcControlList")
	public String pcControlPage(Model model ,@RequestParam Map<String, Object> params ) {
				JSONArray jsonArray = new JSONArray();
				try {
					OrgVo orgvo = new OrgVo();
					jsonArray = oService.orgList(orgvo);
				} catch (Exception e) {
					e.printStackTrace();
					// FAIL_GET_LIST
				}
				//System.out.println(jsonArray.toString().replaceAll("\"", ""));
				model.addAttribute("oList", jsonArray);

				return "/mntrng/mntrngList";
	}

	@ResponseBody
	@RequestMapping(value = "/pcList")
	public Map<String, Object> pcList(Model model,@RequestParam Map<String, Object> params) {
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		Map<String,Object> result = new HashMap<String,Object>();
		params.put("org_seq", Integer.parseInt(params.get("org_seq").toString()));
		int on = 0;
		int off = 0;
		try {
			list =  mService.pcListInfo(params);
			for(int i = 0; i < list.size();i++) {
				//if(list.get(i).get("sgb_pc_status") != null)
				if(list.get(i).get("pc_status") != null)
					on++;
				else
					off++;	
			}
			System.out.println("on===="+on);
			System.out.println("off===="+off);
			//influxListData = mntrgService.influxInfo();
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		result.put("pcList", list);
		result.put("on", on);
		result.put("off", off);
		
		model.addAttribute("pcList",list);
		model.addAttribute("on",on);
		model.addAttribute("off",off);
		return result;
	}
	
	//로그감사 > 정책배포결과
	@ResponseBody
	@RequestMapping(value = "/pcPolicyList")
	public HashMap<String, Object> pcPolicyList(Model model,@RequestParam Map<String, Object> params) {
		HashMap<String, Object> jsonObject = new HashMap<String, Object>();
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
		
		params.put("org_seq", Integer.parseInt(params.get("org_seq").toString()));
		params.put("type",params.get("type").toString());

		System.out.println("type========"+params.get("type").toString());
		
		int on = 0;
		int off = 0;
		
		try {
			list =  mService.pcListInfo(params);
			for(int i = 0; i < list.size();i++) {
				if(list.get(i).get("pc_status") != null)
					on++;
				else
					off++;	
			}
		
			System.out.println("on===="+on);
			System.out.println("off===="+off);
			//influxListData = mntrgService.influxInfo();
			result = pcmp.pcPolicyUpdtList(params);
			jsonObject.put("pcList", list);
			jsonObject.put("policyUpdtResult", result);
			jsonObject.put("policyProgrmResult", pcmp.pcPolicyProgrmList(params));
			jsonObject.put("policyFirewallResult", pcmp.pcPolicyFirewallList(params));
			jsonObject.put("policyDeviceResult", pcmp.pcPolicyDeviceList(params));
			
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		//model.addAttribute("pcList",list);
		model.addAttribute("on",on);
		model.addAttribute("off",off);
		return jsonObject;
	}
	
	// 상세 로깅정보 출력 화면
	@RequestMapping(value = "/pcView")
	public String pcInfo(Model model,@RequestParam Map<String, Object> params ) {
		String uuid="";
		PcMangrVo vo = new PcMangrVo();
		if(!params.isEmpty()) {
		 uuid = params.get("uuid").toString();
		 vo.setPc_uuid(uuid);
		 vo = pcmp.pcDetailInfo(vo);
		 System.out.println("vo===="+vo.toString());

		}
	
		model.addAttribute("uuid",uuid);
		model.addAttribute("pcvo",vo);
		
		return "/mntrng/mntmgView";
	}

	@ResponseBody
	@RequestMapping(value = "/memoryUsage")
	public JSONArray memoryUsage(Model model,@RequestParam Map<String, Object> params ) {
		List<PcMemoryDataVo> list = mService.getMemory(params.get("uuid").toString());
		JSONObject mem;
		JSONArray ja = new JSONArray();
		for(int i=0;i<list.size();i++) {
			 mem = new JSONObject();
			 mem.put("memory", list.get(i).getValue());
			 ja.add(mem);
		}
		return ja;
	}
	
	@ResponseBody
	@RequestMapping(value = "/cpuUsage")
	public JSONArray cpuUsage(Model model,@RequestParam Map<String, Object> params ) {
		List<PcDataVo> list = mService.getCpu(params.get("uuid").toString());
		JSONObject cpu;
		JSONArray ja = new JSONArray();
		for(int i=0;i<list.size();i++) {
			cpu = new JSONObject();
			System.out.println("cpu===="+list.get(i).getValue());
			cpu.put("cpu", list.get(i).getValue());
			 ja.add(cpu);
		}
		return ja;
	}
	
	
	

}
