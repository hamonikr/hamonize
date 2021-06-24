// package com.controller;

// import java.sql.SQLException;
// import java.util.ArrayList;
// import java.util.HashMap;
// import java.util.Iterator;
// import java.util.List;
// import java.util.Map;

// import javax.servlet.http.HttpServletRequest;
// import javax.servlet.http.HttpSession;

// import org.json.simple.JSONArray;
// import org.springframework.beans.factory.annotation.Autowired;
// import org.springframework.dao.DataIntegrityViolationException;
// import org.springframework.stereotype.Controller;
// import org.springframework.ui.Model;
// import org.springframework.web.bind.annotation.RequestMapping;
// import org.springframework.web.bind.annotation.RequestMethod;
// import org.springframework.web.bind.annotation.RequestParam;
// import org.springframework.web.bind.annotation.ResponseBody;
// import org.springframework.web.multipart.MultipartFile;
// import org.springframework.web.multipart.MultipartRequest;

// import com.mapper.IAttributeMapper;
// import com.mapper.INotiMapper;
// import com.mapper.IOrgMapper;
// import com.model.AttributeVo;
// import com.model.FileVO;
// import com.model.GroupVo;
// import com.model.NotiVo;
// import com.model.OrgVo;
// import com.paging.PagingUtil;
// import com.paging.PagingVo;
// import com.service.GroupService;
// import com.service.NotiService;
// import com.service.OrgService;
// import com.util.Constant;
// import com.util.FileUtil;


// @Controller
// @RequestMapping("/notice")
// public class NoticeController {

	
// 	@Autowired
// 	private INotiMapper notiMapper;
	
// 	@Autowired
// 	private IAttributeMapper attributeMapper;
	
// 	@Autowired
// 	private NotiService notiService;
	
// 	@Autowired
// 	private GroupService gService;
	
// 	@Autowired
// 	private OrgService oService;
	
// 	@Autowired
// 	private IOrgMapper oMapper;
	
// 	@Autowired
// 	private FileUtil fileUtil;

	
	
// 	/**
// 	 * 공지 목록]
// 	 * @param model
// 	 * @return
// 	 */
// 	@RequestMapping(value="/notice")
// 	public String noticePage(Model model) {
		
// 		AttributeVo attrVo = new AttributeVo();
// 		attrVo.setAttr_code("001");
// 		List<AttributeVo> retNoticeVo = attributeMapper.commcodeListInfo(attrVo);

// 		attrVo.setAttr_code("002");
// 		List<AttributeVo> retSoldierClassesVo = attributeMapper.commcodeListInfo(attrVo);

// 		JSONArray groupList = null;
// 		try {
// 			GroupVo gvo = new GroupVo();
// 			OrgVo orgvo = new OrgVo();
// 			groupList = oService.orgList(orgvo);
			
// 		} catch (Exception e) {
// 			e.printStackTrace();
// 		}
		
// 		model.addAttribute("oList", groupList);
// 		model.addAttribute("retNoticeVo", retNoticeVo);
// 		model.addAttribute("retSoldierClassesVo", retSoldierClassesVo);
		
// 		return "/notice/notice";
// 	}
	
// 	/**
// 	 * 공지 목록 proc]
// 	 * @param vo
// 	 * @param pagingVo
// 	 * @param session
// 	 * @param request
// 	 * @return
// 	 */
// 	@ResponseBody
// 	@RequestMapping("notice.proc")
// 	public Map<String, Object> listProc(NotiVo vo, PagingVo pagingVo, HttpSession session, HttpServletRequest request) {
// 		System.out.println("===========notice.pronotice.pronotice.pro===========================");
// 		Map<String, Object> jsonObject = new HashMap<String, Object>();

// 		// 페이징
// 		pagingVo.setCurrentPage(vo.getMngeListInfoCurrentPage());
// 		pagingVo = PagingUtil.setDefaultPaging(PagingUtil.DefaultPaging, pagingVo);

// 		int cnt = Integer.parseInt(notiMapper.countMngrListInfo(vo) + "");
		
// 		System.out.println("cnt======"+ cnt);
		
// 		pagingVo.setTotalRecordSize(cnt);
// 		pagingVo = PagingUtil.setPaging(pagingVo);

// 		try {
// 			List<NotiVo> gbList = notiService.notiList(vo, pagingVo);
// 			jsonObject.put("list", gbList);
// 			jsonObject.put("hotelRoomVo", vo);
// 			jsonObject.put("mngeVo", vo);
// 			jsonObject.put("pagingVo", pagingVo);

// 			jsonObject.put("success", true);
// 		} catch (Exception e) {
// 			jsonObject.put("success", false);
// 			e.printStackTrace();
// 		}

// 		return jsonObject;
// 	}
	
	
	
// 	/**
// 	 * 공지 등록 화면]
// 	 * @param model
// 	 * @return
// 	 */
// 	@RequestMapping(value="/noticeInsert")
// 	public String noticeInsertPage( Model model, NotiVo nVo ) {
// 		//log.info(" -- ctr:noticeInsertPage");
		
		
// 		AttributeVo attrVo = new AttributeVo();
// 		attrVo.setAttr_code("001");
// 		List<AttributeVo> retAttributeVo = attributeMapper.commcodeListInfo(attrVo);

// 		attrVo.setAttr_code("002");
// 		List<AttributeVo> retSoldierClassesVo = attributeMapper.commcodeListInfo(attrVo);
		
		
// 		List<OrgVo> oList = null;
// 		try {
// 			 oList = oMapper.orgChoose();

// 		} catch (Exception e) {
// 			e.printStackTrace();
// 		}
		
// 		model.addAttribute("oList", oList);
// 		model.addAttribute("retAttributeVo", retAttributeVo);
// 		model.addAttribute("retSoldierClassesVo", retSoldierClassesVo);
		
// 		return "/notice/noticeInsert";
// 	}
	
	
// 	/**
// 	 * 공지등록 proc]
// 	 * @param session
// 	 * @param nVo
// 	 * @return
// 	 * @throws Exception
// 	 */
// 	@ResponseBody
// 	@RequestMapping(value="noticeInsert.proc", method=RequestMethod.POST)
// 	public Map<String, Object> notiWrite(@RequestParam Map<String, Object> params,HttpSession session, NotiVo nVo,Model model,HttpServletRequest request) throws Exception {
// 		System.out.println("nVo==="+ nVo);
		
// 		Map<String, Object> jsonObject = new HashMap<String, Object>();
// 		int result=0;
// 		//첨부파일
// 		List<MultipartFile> uploadFileList = new ArrayList<MultipartFile>();
// 		Map<String, List<MultipartFile>> uploadFile = new HashMap<String, List<MultipartFile>>();
// 		List<FileVO> fileList = null;
	
// 		try {
// 			MultipartRequest multipartReq = (MultipartRequest) request;
// 			Iterator<String> filenames = multipartReq.getFileNames();
// 			while (filenames.hasNext()) {
// 				String key = (String) filenames.next();
// 				uploadFile.put(key, multipartReq.getFiles(key));
// 				uploadFileList.addAll(multipartReq.getFiles(key));
// 			}
// 			if (uploadFileList != null && uploadFileList.size() > 0) {
// 				fileList = fileUtil.saveAllFiles(uploadFile);
// 				  if (fileList.isEmpty()) { 
// 					  model.addAttribute("message","첨부파일에 문제가 생겼습니다. 관리자에 문의하세요."); 
// 					  model.addAttribute("action", "close");
// 					  //jsonObject.put("msg", Constant.Board.SUCCESS_FAIL);
// 					  jsonObject.put("success", false);
// 				  }
				 
// 			}
// 			notiService.notiInsert(nVo);
// 			//result = notiService.saveFile(params, fileList);
// 			jsonObject.put("msg", Constant.Board.SUCCESS_GROUP_BOARD);
// 			jsonObject.put("success", true);
			
// 		} catch (SQLException sqle) {
// 			sqle.printStackTrace();
// 			jsonObject.put("msg", Constant.Board.SUCCESS_FAIL);
// 			jsonObject.put("success", false);
// 		} catch (DataIntegrityViolationException dive ){
// 			dive.printStackTrace();
// 			jsonObject.put("msg", Constant.Board.SUCCESS_FAIL);
// 			jsonObject.put("success", false);
// 		} catch (Exception e) {
// 			e.printStackTrace();
// 			jsonObject.put("msg", Constant.Board.SUCCESS_FAIL);
// 			jsonObject.put("success", false);
// 		}
		
		
// 		return jsonObject;
// 	}
	
	
// 	/**
// 	 * 공지 상세 화면]
// 	 * @param model
// 	 * @return
// 	 */
// 	@RequestMapping(value="/noticeDetail.acnt")
// 	public String noticeDetailPage(Model model, NotiVo nVo) {
		
// 		System.out.println("nVo==="+ nVo);
		
// 		NotiVo retNvo = notiMapper.notiViewInfo(nVo);
// 		notiMapper.increaseHit(retNvo.getNoti_seq());
		
// 		AttributeVo attrVo = new AttributeVo();
// 		attrVo.setAttr_code("001");
// 		List<AttributeVo> retAttributeVo = attributeMapper.commcodeListInfo(attrVo);

// 		attrVo.setAttr_code("002");
// 		List<AttributeVo> retSoldierClassesVo = attributeMapper.commcodeListInfo(attrVo);

// 		model.addAttribute("retAttributeVo", retAttributeVo);
// 		model.addAttribute("retSoldierClassesVo", retSoldierClassesVo);
// 		model.addAttribute("retNvo", retNvo);
		
// 		return "/notice/noticeDetail";
// 	}
	
// 	/**
// 	 * 공지 등록 화면]
// 	 * @param model
// 	 * @return
// 	 */
// 	@RequestMapping(value="/noticeUpdate")
// 	public String noticeUpdatePage( Model model, NotiVo nVo ) {
// 		//log.info(" -- ctr:noticeInsertPage");
// 		NotiVo retNvo = notiMapper.notiViewInfo(nVo);
		
// 		AttributeVo attrVo = new AttributeVo();
// 		attrVo.setAttr_code("001");
// 		List<AttributeVo> retAttributeVo = attributeMapper.commcodeListInfo(attrVo);

// 		attrVo.setAttr_code("002");
// 		List<AttributeVo> retSoldierClassesVo = attributeMapper.commcodeListInfo(attrVo);
		
		
// 		List<OrgVo> oList = null;
// 		try {
// 			 oList = oMapper.orgChoose();

// 		} catch (Exception e) {
// 			e.printStackTrace();
// 		}
		
// 		model.addAttribute("oList", oList);
// 		model.addAttribute("retAttributeVo", retAttributeVo);
// 		model.addAttribute("retSoldierClassesVo", retSoldierClassesVo);
// 		model.addAttribute("retNvo", retNvo);
		
// 		return "/notice/noticeInsert";
// 	}
	

// 	@ResponseBody
// 	@RequestMapping(value="noticeUpdate.proc", method=RequestMethod.POST)
// 	public Map<String, Object> noticeUpdate(HttpSession session, NotiVo nVo)  {
// 		System.out.println("nVo==="+ nVo);
		
// 		Map<String, Object> jsonObject = new HashMap<String, Object>();
		
		
		
// 		try {
// 			int tmp = notiMapper.notiUpdateProc(nVo);
// 			System.out.println("tmp======"+ tmp);
			
// 			jsonObject.put("msg", Constant.Board.SUCCESS_GROUP_BOARD);
// 			jsonObject.put("success", true);
			
// 		} catch (SQLException sqle) {
// 			sqle.printStackTrace();
// 			jsonObject.put("msg", Constant.Board.SUCCESS_FAIL);
// 			jsonObject.put("success", false);
// 		} catch (DataIntegrityViolationException dive ){
// 			dive.printStackTrace();
// 			jsonObject.put("msg", Constant.Board.SUCCESS_FAIL);
// 			jsonObject.put("success", false);
// 		} catch (Exception e) {
// 			e.printStackTrace();
// 			jsonObject.put("msg", Constant.Board.SUCCESS_FAIL);
// 			jsonObject.put("success", false);
// 		}
		
			

// //		Constant.Group.SUCCESS_CREATE
		
// 		return jsonObject;
// 	}
	
// 	/**
// 	 * 공지 삭제
// 	 * @param seq
// 	 * @return
// 	 */
// 	@RequestMapping(value="noticeDelete")
// 	public String noticeDelete(NotiVo vo) {
// 		int seq = vo.getNoti_seq();
		
// 			try {
// 				notiMapper.notiDelete(seq);
// 			} catch (SQLException e) {
// 				// TODO Auto-generated catch block
// 				e.printStackTrace();
// 			}
		
// 		return "redirect:notice";
// 	}
	
	
// }
