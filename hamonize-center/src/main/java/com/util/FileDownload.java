
// package com.util;

// import java.io.File;
// import java.io.FileInputStream;
// import java.io.FileNotFoundException;
// import java.io.IOException;
// import java.io.OutputStream;
// import java.io.UnsupportedEncodingException;
// import java.net.URLEncoder;
// import java.util.Map;

// import javax.servlet.http.HttpServletRequest;
// import javax.servlet.http.HttpServletResponse;
// import org.slf4j.LoggerFactory;
// import org.slf4j.Logger;

// import org.springframework.beans.factory.annotation.Autowired;
// import org.springframework.beans.factory.annotation.Value;
// import org.springframework.stereotype.Controller;
// import org.springframework.web.bind.annotation.RequestMapping;
// import org.springframework.web.bind.annotation.RequestMethod;
// import org.springframework.web.bind.annotation.RequestParam;

// @Controller
// public class FileDownload {

//     @Autowired
//     private ScreenManageService smService;

//     @Value("${attach.path}")
//     private String path;

//     private Logger logger = LoggerFactory.getLogger(this.getClass());


//     /**
//      * 파일(첨부파일, 이미지등) 다운로드.
//      */
//     @RequestMapping(value = "fileDown.do", method = RequestMethod.POST)
//     public void fileDownload(@RequestParam Map<String, Object> params, HttpServletRequest request,
//             HttpServletResponse response) {

//         String realPath = "";
//         String tmpPath = path;

//         Map<String, Object> boardFile = smService.getImageFile(params);

//         String filename = (String) boardFile.get("FILE_NAME");
//         String downname = (String) boardFile.get("REAL_NAME");
//         String filepath = (String) boardFile.get("FILE_PATH");

//         if (filepath == null || "".equals(filepath))
//             filepath = tmpPath;
//         if (filename == null || "".equals(filename))
//             filename = downname;

//         try {
//             filename = URLEncoder.encode(filename, "UTF-8");
//         } catch (UnsupportedEncodingException ex) {
//             logger.error("UnsupportedEncodingException : {}", ex.getMessage(), ex);
//         }

//         String folder = "";
//         if (downname.indexOf("_") > -1) {
//             String temp[] = downname.split("_");
//             folder = temp[1].substring(0, 4);
//         }

//         realPath = filepath + folder + "/" + downname;

//         File file1 = new File(realPath);
//         if (!file1.exists()) {
//             return;
//         }

//         // 파일명 지정
//         response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");

//         try (FileInputStream fis = new FileInputStream(realPath)) {
//             OutputStream os = response.getOutputStream();

//             int ncount = 0;
//             byte[] bytes = new byte[512];

//             while ((ncount = fis.read(bytes)) != -1) {
//                 os.write(bytes, 0, ncount);
//             }

//             os.close();
//         } catch (FileNotFoundException fe) {
//             logger.error("FileNotFoundException : {}", fe.getMessage(), fe);
//         } catch (IOException ie) {
//             logger.error("IOException : {}", ie.getMessage(), ie);
//         }

//     }



//     /**
//      * 이미지파일 다운로드.
//      */
//     @RequestMapping(value = {"imgfile.do", "download.do"}, method = RequestMethod.POST)
//     public void fileDownload(HttpServletRequest request, HttpServletResponse response) {
//         String filename = request.getParameter("fn");
//         String downname = request.getParameter("dn");
//         String realPath = "";

//         if (filename == null || "".equals(filename)) {
//             filename = downname;
//         }

//         String folder = "";
//         if (downname.indexOf("_") > -1) {
//             String temp[] = downname.split("_");
//             folder = temp[1].substring(0, 4);
//         }

//         try {
//             filename = URLEncoder.encode(filename, "UTF-8");
//         } catch (UnsupportedEncodingException ex) {
//             logger.error("UnsupportedEncodingException : {}", ex.getMessage(), ex);
//         }

//         realPath = path + folder + "/" + downname;

//         File file1 = new File(realPath);
//         if (!file1.exists()) {
//             return;
//         }

//         // 파일명 지정
//         response.setHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");

//         try (FileInputStream fis = new FileInputStream(realPath)) {
//             OutputStream os = response.getOutputStream();

//             int ncount = 0;
//             byte[] bytes = new byte[512];

//             while ((ncount = fis.read(bytes)) != -1) {
//                 os.write(bytes, 0, ncount);
//             }

//             os.close();

//         } catch (FileNotFoundException fe) {
//             logger.error("FileNotFoundException : {}", fe.getMessage(), fe);
//         } catch (IOException ie) {
//             logger.error("IOException : {}", ie.getMessage(), ie);
//         }
//     }

// }
