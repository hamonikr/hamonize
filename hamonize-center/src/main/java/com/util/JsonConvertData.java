package com.util;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


/**
 * <pre>
 * com.skt.tvalley.web.common.JsonConvert.java
 * DESC: 클래스설명.
 * </pre>
 * 
 * @author kbchoi
 * @since 2015. 9. 11.
 * @version 1.0
 *
 */
public class JsonConvertData {
	private static Logger logger = LoggerFactory.getLogger(JsonConvertData.class);

	/**
	 * <pre>
	 * DESC: DataMap 형식으로 들어온 데이터를 json으로 컨버팅해준다.
	 * </pre>
	 *
	 * @return String.
	 */
	public static String JsonConvert(DataMap paramDataMap) {
		String result = "";
		ObjectMapper objectMapper = new ObjectMapper();

		try {
			result = objectMapper.writeValueAsString(paramDataMap);
		} catch (JsonProcessingException e) {
			logger.error(e.getMessage(), e);
		}

		return result;
	}
}
