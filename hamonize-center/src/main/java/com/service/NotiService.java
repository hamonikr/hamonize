package com.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mapper.INotiMapper;
import com.model.FileVO;
import com.model.NotiVo;
import com.paging.PagingVo;

@Service
public class NotiService {

	@Autowired
	private INotiMapper notiMapper;

	public List<NotiVo> notiList(NotiVo vo, PagingVo pagingVo) {

		HashMap<String, Object> paramMap = new HashMap<String, Object>();

		paramMap.put("mngeVo", vo);
		paramMap.put("pagingVo", pagingVo);

		List<NotiVo> tt = notiMapper.notiListInfo(paramMap);

		return tt;
	}
	
	
	@Transactional
	public void notiInsert(NotiVo nVo) throws Exception {
		notiMapper.notiInsert(nVo);
	}
	
	@Transactional
	public int saveFile(Map<String, Object> dataMap,List<FileVO> fileList) {
		int result = 0;
		System.out.println("noti_seq===="+dataMap.get("noti_seq"));
		// 2. 파일 정보 저장
				if(fileList !=  null && fileList.size() == 1) {
					for (FileVO fileVO : fileList) {
						dataMap.put("filemakename", fileVO.getFilename());
						dataMap.put("filerealname", fileVO.getRealname());
						dataMap.put("filesize", fileVO.getFilesize());
						dataMap.put("filepath", fileVO.getFilepath());
						System.out.println("f1=="+dataMap.get("filemakename"));
						System.out.println("f2=="+dataMap.get("filerealname"));
						System.out.println("f3=="+dataMap.get("filesize"));
						System.out.println("f4=="+dataMap.get("org_seq"));
						System.out.println("f5=="+dataMap.get("filepath"));
					
					}
					// 1. 게시글 정보 저장
				}
				//smMapper.saveFile(dataMap);
				notiMapper.saveFile(dataMap);
				//partcptMapper.rqfrmModifyFile(dataMap);
				result = 1;
		return result;
		
	}
	

}