package com.controller.curl;

import java.util.HashMap;
import java.util.Map;

import com.mapper.IGetAgentPollingMapper;
import com.model.GetAgentPollingVo;
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
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.util.FileCopyUtils;


@RestController
@RequestMapping("/getAgent")
public class CurlAgentAdminkeyController {

	@Autowired
	private IGetAgentPollingMapper getAgentPollingMapper;

	@Autowired
	private IFileMapper fileMapper;
	
	private Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@GetMapping("/getAdminKey")
	public  Map<String, Object> getAgentJob(@RequestParam(value = "uuid", required = false) String uuid) throws Exception {

		logger.info("uuid === {}", uuid);
		
		uuid = uuid.trim();
	
		GetAgentPollingVo vo = new GetAgentPollingVo();
		vo.setUuid(uuid);
		
		int chkProgrmPolicy = getAgentPollingMapper.getAgentWorkYn(vo);
		GetAgentPollingVo output = getAgentPollingMapper.getPollingTime(vo);
		Map<String, Object> jsonObject = new HashMap<String, Object>();

		logger.info("//===================================");
		logger.info("//work yn === {}", chkProgrmPolicy);
		logger.info("//===================================// ");

		if (chkProgrmPolicy == 0) {
			if( output.getPolling_tm() == 0 ){
				jsonObject.put("data", "nodata");
			}else{
				logger.info("getPolling_tm : {}",output.getPolling_tm());
				if( output.getPolling_tm().SIZE !=0){
					jsonObject.put("data", output.getPolling_tm());

				}else{
					jsonObject.put("data", "nodata");
				}
			}
			
		}else{
			jsonObject.put("data", "nodata");

		}


		logger.info("//===================================");
		logger.info("/result data is : {}", jsonObject);
		logger.info("//===================================// ");

		return jsonObject;
	}


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

}
