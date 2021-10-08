package com.controller.curl;

import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.mapper.IFileMapper;
import com.model.FileVo;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;


@RestController
@RequestMapping("/getAgent")
public class CurlAgentAdminkeyController {

	@Autowired
	private IFileMapper fileMapper;
	
	private Logger logger = LoggerFactory.getLogger(this.getClass());
	
	
	@RequestMapping("/getpublickey")
    public String getpublickey( FileVo vo, HttpServletRequest request,HttpServletResponse response) throws UnsupportedEncodingException {
        vo = fileMapper.getFilePublic();
        File file = new File(vo.getFilepath());
		String ret ="";
       
        if (file.exists() && file.isFile()) {
			response.setContentType("application/octet-stream; charset=utf-8");
			response.setContentLength((int) file.length());
         
            response.setHeader("Content-Disposition", "attachment;filename="+URLEncoder.encode(vo.getFilerealname(), "UTF-8").replaceAll(
				"\\+", "%20"));
			response.setHeader("Content-Transfer-Encoding", "binary");
		
            try {
                
                OutputStream out = response.getOutputStream();
                FileInputStream fis = null;
            
                fis = new FileInputStream(file);
            
                FileCopyUtils.copy(fis, out);
         
                if (fis != null){
                    fis.close();
                }
                
                out.flush();
                out.close();
             
                ret="S";
            } catch (Exception e) {
                logger.error(e.getMessage());
            }
        }else{
            logger.info("파일이 아님");
            ret="F";
        }
        
        return ret;
    }

	@RequestMapping("/getconfigfile")
    public String getconfigfile( FileVo vo, HttpServletRequest request,HttpServletResponse response) throws UnsupportedEncodingException {
        vo = fileMapper.getFileConfig();
        File file = new File(vo.getFilepath());
		String ret ="";
       
        if (file.exists() && file.isFile()) {
			response.setContentType("application/octet-stream; charset=utf-8");
			response.setContentLength((int) file.length());
         
            response.setHeader("Content-Disposition", "attachment;filename="+URLEncoder.encode(vo.getFilerealname(), "UTF-8").replaceAll(
				"\\+", "%20"));
			response.setHeader("Content-Transfer-Encoding", "binary");
		
            try {
                
                OutputStream out = response.getOutputStream();
                FileInputStream fis = null;
            
                fis = new FileInputStream(file);
            
                FileCopyUtils.copy(fis, out);
         
                if (fis != null){
                    fis.close();
                }
                
                out.flush();
                out.close();
             
                ret="S";
            } catch (Exception e) {
                logger.error(e.getMessage());
            }
        }else{
            logger.info("파일이 아님");
            ret="F";
        }
        
        return ret;
    }

}
