package com.util;

import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.springframework.web.servlet.view.document.AbstractExcelView;






public class CmmnExcelService extends AbstractExcelView{

	@SuppressWarnings("unchecked")
	protected void buildExcelDocument(Map<String, Object> model,
			org.apache.poi.hssf.usermodel.HSSFWorkbook workbook, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		Map<String, Object> data =  (Map<String, Object>) model.get("data");
		
		String userAgent = request.getHeader("User-Agent");
		String fileName = new StringBuilder(data.get("excelName")+"_").append(DateUtil.getToday("yyyyMMddHHmmss")).append(".xlsx").toString();

		if (userAgent.indexOf("MSIE") > -1 || userAgent.contains("Trident")) {
			fileName = URLEncoder.encode(fileName, "utf-8");
		} else {
			fileName = new String(fileName.getBytes("utf-8"), "iso-8859-1");
		}
		response.setHeader("Content-Disposition", "attachment; filename=\""	+ fileName + "\";");
		response.setHeader("Content-Transfer-Encoding", "binary");

		//create a new workbook
		SXSSFWorkbook wb = new SXSSFWorkbook(100);		
		//create a new Excel sheet
		Sheet sheet = wb.createSheet(data.get("excelName")+" 내역");

		Row header = sheet.createRow(0);
        String[] headerName=(String[])data.get("header");
        String[] columnName=(String[])data.get("column");
        for(int i=0,max=headerName.length;i<max;i++){
        	header.createCell(i).setCellValue(headerName[i]);
        }
        // create data rows
        int rowCount = 1;
        List<Map<String, Object>> list = (List<Map<String, Object>>)data.get("list");
        
		int maxColumnWidth = 255*256; // The maximum column width 
		
        for(int i=0,max=list.size();i<max;i++){
        	Row aRow = sheet.createRow(rowCount++);
        	
        	for(int ii=0,max2=headerName.length;ii<max2;ii++){
        		try {
        		aRow.createCell(ii).setCellValue(list.get(i).get(columnName[ii]).toString());
        	
        		int width = (sheet.getColumnWidth(ii));
        		if (width > maxColumnWidth) { 
        			width = maxColumnWidth;  
				}
        		}catch (Exception e) {
					// TODO: handle exception
				}
        	}
        }

        
    		OutputStream fileOut2 = response.getOutputStream(); 
    		wb.write(fileOut2);
    	 	fileOut2.close();


	}
	
}
