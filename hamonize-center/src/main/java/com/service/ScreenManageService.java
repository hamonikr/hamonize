package com.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.mapper.IScreenManageMapper;
import com.model.FileVO;
import com.model.OrgVo;

@Service
public class ScreenManageService {
	
	@Autowired
	IScreenManageMapper smMapper;
	
	
	public Map<String, Object> getImageFile(Map<String, Object> params) {
		Map<String, Object> imageFile = smMapper.getImageFile(params);
		return imageFile;
	}
	@Transactional(readOnly=false)
	public int saveFile(Map<String, Object> dataMap,List<FileVO> fileList) {
		int result = 0;
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
				smMapper.saveFile(dataMap);
				//partcptMapper.rqfrmModifyFile(dataMap);
				result = 1;
		return result;
		
	}
	
	public FileVO screenView(OrgVo vo) {	
		return smMapper.screenView(vo);
		
	}
	
	
}
