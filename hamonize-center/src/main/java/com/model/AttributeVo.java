package com.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class AttributeVo {

	private String attr_code;
	private String attr_name;
	private String attr_value_code;
	private String attr_value_name;
	
	// 분류 선택 
	private String optradio;

}
