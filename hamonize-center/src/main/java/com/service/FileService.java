package com.service;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import com.mapper.IFileMapper;
import com.model.FileVo;

import org.apache.commons.io.FilenameUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service
public class FileService {

    @Value("${attach.path}")
    private String path;

    @Autowired
    private IFileMapper fileMapper;

  public Map uploadFile(MultipartFile mFile,FileVo vo) throws IOException {
    String result = "";
    Path uploadDir = Paths.get(path);
    if(!Files.isDirectory(uploadDir)) {
        Files.createDirectories(uploadDir);
    }
    Map map = new HashMap<>();
    UUID tmpFileName = UUID.randomUUID(); 
    String originalFileName = mFile.getOriginalFilename();        
    String fileExt = FilenameUtils.getExtension(originalFileName);
    String logicalFileName = tmpFileName.toString()+ "." + fileExt;
    byte[] fileBytes = mFile.getBytes();
    Path filePath = uploadDir.resolve(logicalFileName);
        
    vo.setFilename(logicalFileName);
    vo.setFilerealname(originalFileName);
    vo.setFilesize(mFile.getSize());
    vo.setFilepath(filePath.toString());

    if(Files.write(filePath, fileBytes) != null){
        fileMapper.saveFile(vo);
        result ="S";
        map.put("filename",logicalFileName);
        map.put("filepath",filePath.toString());
    }else{
        result ="F";
    }
    map.put("result",result);
    return map;
  }

  public List<FileVo> getFile(String type){
    return fileMapper.getFiles();
  }

  public String deleteFile(FileVo vo) throws IOException {
    //vo = fileMapper.getFileSeq(vo.getSeq());
    String result ="";
    File file = new File(vo.getFilepath());

    if(file.exists()){ 
        if(file.delete()){
            //fileMapper.deleteFile(vo);
            result ="S";

        }else{
            // logger.info("파일 삭제 실패");
            result ="F";
        }
    }else{ 
        // logger.info("파일 없음");
        result ="F";
    }

    return result;
        
}
  
}
