package com.model;

import org.influxdb.annotation.Column;
import org.influxdb.annotation.Measurement;




@Measurement(name = "cpu_value")
public class PcDataVo {
	@Column(name = "time")
	private String time;

	@Column(name = "host")
	private String host;

	@Column(name = "instance")
	private Long instance;

	@Column(name = "type")
	private String type;

	public String getTime() {
		return time;
	}


	public void setTime(String time) {
		this.time = time;
	}


	public String getHost() {
		return host;
	}


	public void setHost(String host) {
		this.host = host;
	}


	public Long getInstance() {
		return instance;
	}


	public void setInstance(Long instance) {
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


	public Long getValue() {
		return value;
	}


	public void setValue(Long value) {
		this.value = value;
	}


	public Boolean getStatus() {
		return status;
	}


	public void setStatus(Boolean status) {
		this.status = status;
	}


	public String getPcHostName() {
		return pcHostName;
	}


	public void setPcHostName(String pcHostName) {
		this.pcHostName = pcHostName;
	}


	@Column(name = "type_instance")
	private String type_instance;

	@Column(name = "value")
	private Long value;

	@Column(name = "status")
	private Boolean status;

	
	private String pcHostName;
}