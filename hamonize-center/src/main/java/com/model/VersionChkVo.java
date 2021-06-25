package com.model;

public class VersionChkVo {

	private String datetime;
	private String uuid;
	private String hostname;
	private String pcmngr;
	private String agent;
	private String browser;
	
	
	
	
	@Override
	public String toString() {
		return "VersionChkVo [datetime=" + datetime + ", uuid=" + uuid + ", hostname=" + hostname + ", pcmngr=" + pcmngr
				+ ", agent=" + agent + ", browser=" + browser + "]";
	}
	public String getDatetime() {
		return datetime;
	}
	public void setDatetime(String datetime) {
		this.datetime = datetime;
	}
	public String getUuid() {
		return uuid;
	}
	public void setUuid(String uuid) {
		this.uuid = uuid;
	}
	public String getHostname() {
		return hostname;
	}
	public void setHostname(String hostname) {
		this.hostname = hostname;
	}
	public String getPcmngr() {
		return pcmngr;
	}
	public void setPcmngr(String pcmngr) {
		this.pcmngr = pcmngr;
	}
	public String getAgent() {
		return agent;
	}
	public void setAgent(String agent) {
		this.agent = agent;
	}
	public String getBrowser() {
		return browser;
	}
	public void setBrowser(String browser) {
		this.browser = browser;
	}
	
	


}