package com.model;

import java.util.List;




public class MntrgVo {
	
	private String pcName;
	
	private String pcOrgName;
	
	private List<PcDataVo> influxPcDataVo;
	
	private List<String> strPcName;

	public String getPcName() {
		return pcName;
	}

	public void setPcName(String pcName) {
		this.pcName = pcName;
	}

	public String getPcOrgName() {
		return pcOrgName;
	}

	public void setPcOrgName(String pcOrgName) {
		this.pcOrgName = pcOrgName;
	}

	public List<PcDataVo> getInfluxPcDataVo() {
		return influxPcDataVo;
	}

	public void setInfluxPcDataVo(List<PcDataVo> influxPcDataVo) {
		this.influxPcDataVo = influxPcDataVo;
	}

	public List<String> getStrPcName() {
		return strPcName;
	}

	public void setStrPcName(List<String> strPcName) {
		this.strPcName = strPcName;
	}

}