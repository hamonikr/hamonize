package com.controller;

import java.io.FileReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartRequest;

import com.google.gson.JsonArray;
import com.google.gson.JsonParser;
import com.mapper.IPcMangrMapper;
import com.model.FileVO;
import com.model.OrgVo;
import com.model.PcMangrVo;
import com.service.OrgService;
import com.service.ScreenManageService;
import com.util.FileUtil;

@Controller
@RequestMapping("/gplcs")
public class ScreenManageController {

	@Autowired
	private OrgService oService;

	@Autowired
	private ScreenManageService smService;
	
	@Autowired
	private FileUtil fileUtil;
	
	@Autowired
	private IPcMangrMapper pcmapper;

	@RequestMapping("/smanage")
	public String manage(HttpSession session, Model model) {

		JSONArray jsonArray = new JSONArray();

		try {
			OrgVo orgvo = new OrgVo();
			jsonArray = oService.orgList(orgvo);

		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("oList", jsonArray);

		return "/policy/screenManage";

	}
	
	@ResponseBody
	@RequestMapping("/sview")
	public JSONObject screenView(HttpSession session, Model model,OrgVo orgvo) {
		System.out.println("orgvo===="+orgvo.getSeq());
		FileVO fvo = new FileVO();
		fvo = smService.screenView(orgvo);
		JSONObject data = new JSONObject();
		System.out.println(orgvo.getSeq());
		System.out.println(fvo.getFilerealname());
		data.put("org_seq", orgvo.getSeq());
		data.put("filename", fvo.getFilerealname());
		
		return data;
			
	}
	
	@RequestMapping("/smanageSave")
	public String screenSave(@RequestParam Map<String, Object> params, ModelMap model, HttpServletRequest request) {
		params.put("org_seq", Integer.parseInt(params.get("org_seq").toString()));
		
		int result=0;
		//첨부파일
		List<MultipartFile> uploadFileList = new ArrayList<MultipartFile>();
		Map<String, List<MultipartFile>> uploadFile = new HashMap<String, List<MultipartFile>>();
		List<FileVO> fileList = null;

		try {
			MultipartRequest multipartReq = (MultipartRequest) request;
			Iterator<String> filenames = multipartReq.getFileNames();

			while (filenames.hasNext()) {
				String key = (String) filenames.next();
				uploadFile.put(key, multipartReq.getFiles(key));

				uploadFileList.addAll(multipartReq.getFiles(key));
			}

			if (uploadFileList != null && uploadFileList.size() > 0) {
				fileList = fileUtil.saveAllFiles(uploadFile);
				  if (fileList.isEmpty()) { 
					  model.addAttribute("message","첨부파일에 문제가 생겼습니다. 관리자에 문의하세요."); 
					  model.addAttribute("action", "close");
				  return "/gplcs/smanage.do"; }
				 
			}
		} catch (ClassCastException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
			// 2. 정보를 저장한다.
		result = smService.saveFile(params, fileList);
	
		if(result > 0)
		return "redirect:/gplcs/smanage.do";
		else
		return "";

	}
	
	@RequestMapping("/jsonInsertPc")
	public String winPc(HttpSession session, Model model,HttpServletRequest request) {
		model.addAttribute("message",request.getParameter("message")); 
		return "/pcMngr/pcUpload";

	}
	
	@ResponseBody
	@RequestMapping("/showJsonPc")
	public Map<String, Object> showjsonPc(ModelMap model, HttpServletRequest request) {
		String pattern = "^[hHwW]{1}[0-9]{5}\\=([0-9]{1,3})\\.([0-9]{1,3})\\.([0-9]{1,3})\\.([0-9]{1,3})\\=([0-9a-fA-F]{1,2})\\-([0-9a-fA-F]{1,2})\\-([0-9a-fA-F]{1,2})\\-([0-9a-fA-F]{1,2})\\-([0-9a-fA-F]{1,2})\\-([0-9a-fA-F]{1,2})*$";
		int result=0;
		//첨부파일
		List<MultipartFile> uploadFileList = new ArrayList<MultipartFile>();
		Map<String, List<MultipartFile>> uploadFile = new HashMap<String, List<MultipartFile>>();
		List<FileVO> fileList = null;
		JSONParser parser = new JSONParser();
		Map<String, Object> params = new HashMap<String, Object>();

		try {
			MultipartRequest multipartReq = (MultipartRequest) request;
			Iterator<String> filenames = multipartReq.getFileNames();
			while (filenames.hasNext()) {
				String key = (String) filenames.next();
				uploadFile.put(key, multipartReq.getFiles(key));
				uploadFileList.addAll(multipartReq.getFiles(key));
			}
			if (uploadFileList != null && uploadFileList.size() > 0) {
				fileList = fileUtil.saveAllFiles(uploadFile);
				Object obj = parser.parse(new FileReader(fileList.get(0).getFilepath()+"/"+fileList.get(0).getFilename()));
				JSONObject jsonObject = (JSONObject) obj;
				JSONArray json_coms = (JSONArray) jsonObject.get("computers");
				List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
				List<Map<String, Object>> chklist = new ArrayList<Map<String,Object>>();
				Map<String, Object> resultMap;
				Map<String, Object> chkMap;
				for(int i = 0; i< json_coms.size();i++) {
					resultMap = new HashMap<String, Object>();
					JSONObject data = new JSONObject();
					data = (JSONObject) json_coms.get(i);
					if(data.get("pass").equals("")) {
						chkMap = new HashMap<String, Object>();
						String date = data.get("name").toString();
						date = date.replaceAll("%23", "#").replaceAll("%20", " ").replaceAll("%2F", "/");
						String dateSplit[] = date.split(" ");
						String patternNum = "^[0-9]*$";
						chkMap.put("roomno",dateSplit[0].replaceAll("[^0-9]", ""));
						for(int k = 0;k<dateSplit.length;k++) {
							String dateChk = dateSplit[k];
							if(dateChk.matches(patternNum))
							chkMap.put("date",dateChk);
							
						}
						chklist.add(chkMap);
					}
					if(data.get("pass") != "" && !"".equals(data.get("pass"))) {
						String name = data.get("name").toString().trim();
						name = name.replaceAll("@", "").replaceAll(" ", "").replaceAll("\t", "").replaceAll("/OK-H","");
						boolean flag = name.matches(pattern);
						if(flag) {
							resultMap.put("flag","Y");	
						}else {
							resultMap.put("flag","N");	
						}
					
					resultMap.put("name",name);
					resultMap.put("deptname", data.get("tags").toString());
					resultMap.put("pc_ip", data.get("host").toString());
					
					for(int j=0;j<chklist.size();j++) {
						if(chklist.get(j).get("roomno").equals(data.get("tags").toString())) {
							resultMap.put("date", chklist.get(j).get("date"));
						}
					}
					list.add(resultMap);
					}
				}
				params.put("list", list);
			}
		} catch (ClassCastException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
			return params;
		}
		
		// 2. 정보를 저장한다.
		result = smService.saveFile(params, fileList);
	
		return params; 

	}
	
	@ResponseBody
	@RequestMapping("/saveJsonPc")
	public Map<String, Object> saveJsonPc(ModelMap model, HttpServletRequest request,@RequestParam Map<String, Object> param) {
		String pattern = "^[hHwW]{1}[0-9]{5}\\=([0-9]{1,3})\\.([0-9]{1,3})\\.([0-9]{1,3})\\.([0-9]{1,3})\\=([0-9a-fA-F]{1,2})\\-([0-9a-fA-F]{1,2})\\-([0-9a-fA-F]{1,2})\\-([0-9a-fA-F]{1,2})\\-([0-9a-fA-F]{1,2})\\-([0-9a-fA-F]{1,2})*$";
		int result=0;
		JSONParser parser = new JSONParser();
		Map<String, Object> params = new HashMap<String, Object>();
		Map<String, Object> dataMap = new HashMap<String, Object>();

		try {
				JSONArray json_coms = (JSONArray) parser.parse(param.get("data").toString());
				List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
				List<Map<String, Object>> winList = new ArrayList<Map<String,Object>>();
				Map<String, Object> resultMap;
				Map<String, Object> winResultMap;			
				int cntAll = 0;
				int cntWin = 0;
				for(int i = 0; i< json_coms.size();i++) {
					
					
					resultMap = new HashMap<String, Object>();
					winResultMap = new HashMap<String, Object>();
					JSONObject data = new JSONObject();
					data = (JSONObject) json_coms.get(i);
					String nameChk = data.get("name").toString();
					boolean flag = nameChk.matches(pattern);
					if(!flag) {
						dataMap.put("wrongNum", i);
						dataMap.put("result", "FAIL");
						return dataMap;
					}
					String name[] = data.get("name").toString().split("=");
					String deptname = data.get("deptname").toString().replaceAll("^0+", "");
					resultMap.put("deptname", deptname);
					resultMap.put("pc_ip", data.get("pc_ip").toString());
					resultMap.put("pc_hostname", name[0].substring(0,6));
					resultMap.put("pc_os", name[0].substring(0,1));
					resultMap.put("pc_macaddress", name[2]);
					resultMap.put("date",data.get("date").toString() );
					if("W".equals(name[0].substring(0,1))) {
						winResultMap.put("deptname", deptname);
						winResultMap.put("pc_ip", data.get("pc_ip").toString());
						winResultMap.put("pc_hostname", name[0].substring(0,6));
						winResultMap.put("pc_os", name[0].substring(0,1));
						winResultMap.put("pc_macaddress", name[2]);
						winResultMap.put("date", data.get("date").toString());
						winList.add(winResultMap);
						cntWin++;
					}
					list.add(resultMap);
					cntAll++;
				}
				params.put("data", list);
				params.put("dataWin", winList);
				params.put("last", cntAll);
				params.put("lastWin", cntWin);
				if((cntAll - cntWin) > 0)
				result = pcmapper.insertPcAmtJson(params);
				if(cntWin > 0)
				result = pcmapper.insertWindowPc(params);
				 
			
		} catch (ClassCastException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
			dataMap.put("result", "FAIL");
			return dataMap;
		}
			// 2. 정보를 저장한다.
		//result = smService.saveFile(params, fileList);
	
		if(result != -1) {
			dataMap.put("result", "SUCCESS");
			return dataMap; 
		}else {
			dataMap.put("result", "FAIL");
			return dataMap;
		}
	}

}
