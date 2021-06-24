package com.model;

import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.influxdb.annotation.Column;
import org.influxdb.annotation.Measurement;




@Measurement(name = "CpuDataVo")
public class CpuDataVo {
	@Column(name = "time")
	private Instant time;

	@Column(name = "host")
	private String host;

	@Column(name = "instance")
	private String instance;

	@Column(name = "type")
	private String type;

	@Column(name = "type_instance")
	private String type_instance;

	@Column(name = "value")
	private String value;

	
	private List<String> optionNameVal;
	private List<Map<Integer, String>> nameVal;
	private List<Map<Integer, String>> noVal;
	private List<Map<Integer, Integer>> isDefaultOptionGoodsVal;


	public CpuDataVo() {
		nameVal = new ArrayList<Map<Integer, String>>();
		noVal = new ArrayList<Map<Integer, String>>();
		isDefaultOptionGoodsVal = new ArrayList<Map<Integer, Integer>>();
	}


	public Instant getTime() {
		return time;
	}


	public void setTime(Instant time) {
		this.time = time;
	}


	public String getHost() {
		return host;
	}


	public void setHost(String host) {
		this.host = host;
	}


	public String getInstance() {
		return instance;
	}


	public void setInstance(String instance) {
		this.instance = instance;
	}


	public String getType() {
		return type;
	}


	public void setType(String type) {
		this.type = type;
	}


	public String getType_instance() {
		return type_instance;
	}


	public void setType_instance(String type_instance) {
		this.type_instance = type_instance;
	}


	public String getValue() {
		return value;
	}


	public void setValue(String value) {
		this.value = value;
	}


	public List<String> getOptionNameVal() {
		return optionNameVal;
	}


	public void setOptionNameVal(List<String> optionNameVal) {
		this.optionNameVal = optionNameVal;
	}


	public List<Map<Integer, String>> getNameVal() {
		return nameVal;
	}


	public void setNameVal(List<Map<Integer, String>> nameVal) {
		this.nameVal = nameVal;
	}


	public List<Map<Integer, String>> getNoVal() {
		return noVal;
	}


	public void setNoVal(List<Map<Integer, String>> noVal) {
		this.noVal = noVal;
	}


	public List<Map<Integer, Integer>> getIsDefaultOptionGoodsVal() {
		return isDefaultOptionGoodsVal;
	}


	public void setIsDefaultOptionGoodsVal(List<Map<Integer, Integer>> isDefaultOptionGoodsVal) {
		this.isDefaultOptionGoodsVal = isDefaultOptionGoodsVal;
	}
	
}