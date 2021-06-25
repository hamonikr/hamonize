package com.model;






public class AttributeVo {

	private String attr_code;
	private String attr_name;
	private String attr_value_code;
	private String attr_value_name;
	
	// 분류 선택 
	private String optradio;

	public String getAttr_code() {
		return attr_code;
	}

	public void setAttr_code(String attr_code) {
		this.attr_code = attr_code;
	}

	public String getAttr_name() {
		return attr_name;
	}

	public void setAttr_name(String attr_name) {
		this.attr_name = attr_name;
	}

	public String getAttr_value_code() {
		return attr_value_code;
	}

	public void setAttr_value_code(String attr_value_code) {
		this.attr_value_code = attr_value_code;
	}

	public String getAttr_value_name() {
		return attr_value_name;
	}

	public void setAttr_value_name(String attr_value_name) {
		this.attr_value_name = attr_value_name;
	}

	public String getOptradio() {
		return optradio;
	}

	public void setOptradio(String optradio) {
		this.optradio = optradio;
	}
	
}
