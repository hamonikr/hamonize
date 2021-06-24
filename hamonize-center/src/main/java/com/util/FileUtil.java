package com.util;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import com.model.FileVO;

@Component
public class FileUtil {
	
	@Value("${attach.path}")
	private String filePath;
    /**
     * 파일 업로드.
     */
    public List<FileVO> saveAllFiles(Map<String,List<MultipartFile>> upfileMap) {
        List<FileVO> filelist = new ArrayList<FileVO>();
        
        Iterator<Entry<String, List<MultipartFile>>> itrt = upfileMap.entrySet().iterator();

        while(itrt.hasNext()) {
            Entry<String, List<MultipartFile>> entry = itrt.next();
            
            String key = entry.getKey();
            List<MultipartFile> upfiles = entry.getValue();
            
            for (MultipartFile uploadfile : upfiles ) {
                if (uploadfile.getSize() == 0) {
                    continue;
                }
                
                String newName = getNewName();
                String realName = key + "_" + newName;
                
                int index = uploadfile.getOriginalFilename().lastIndexOf(".");
                String fileExt = uploadfile.getOriginalFilename().substring(index+1).toLowerCase();
                realName += "."+fileExt;
                if(fileExt.equals("jpg")||fileExt.equals("png")||fileExt.equals("gif")||fileExt.equals("jpeg")||fileExt.equals("json")){
                	saveFile(uploadfile, filePath +"/" , realName,fileExt);
                	
                FileVO filedo = new FileVO();
                filedo.setFilename(realName);
                filedo.setRealname(uploadfile.getOriginalFilename());
                filedo.setFilesize(uploadfile.getSize());
                filedo.setFilepath(filePath);
                filelist.add(filedo);
                }else{
                	filelist = null;
                }
            }
        }
        
        
        return filelist;
    }    
    
    /**
     * 파일 저장 경로 생성.
     */
    public void makeBasePath(String path) {
        File dir = new File(path); 
        if (!dir.exists()) {
            dir.mkdirs();
        }
    }

    /**
     * 실제 파일 저장.
     */
    public String saveFile(MultipartFile file, String basePath, String fileName, String fileExt){
        if (file == null || file.getName().equals("") || file.getSize() < 1) {
            return null;
        }
     
        makeBasePath(basePath);
        String serverFullPath = basePath + fileName;
       
        int index = file.getOriginalFilename().lastIndexOf(".");
        String fileTmp = file.getOriginalFilename().substring(index+1);
        File file1 = new File(serverFullPath);
       
        try {
        	 if(fileTmp.equals(fileExt)){ 
        		 file.transferTo(file1);
        	 }else{
        		 file1.delete();
        		 serverFullPath = null;
        	 }
        } catch (IllegalStateException ex) {
            System.out.println("IllegalStateException: " + ex.toString());
        } catch (IOException ex) {
            System.out.println("IOException: " + ex.toString());
        }
        
        return serverFullPath;
    }
    
    /**
     * 날짜로 새로운 파일명 부여.
     */
    public String getNewName() {
        SimpleDateFormat ft = new SimpleDateFormat("yyyyMMddhhmmssSSS");
        return ft.format(new Date()) + (int) (Math.random() * 10);
    }
    
    public String getFileExtension(String filename) {
          Integer mid = filename.lastIndexOf(".");
          return filename.substring(mid, filename.length());
    }

    public String getRealPath(String path, String filename) {
        return path + filename.substring(0,4) + "/";
    }
}
