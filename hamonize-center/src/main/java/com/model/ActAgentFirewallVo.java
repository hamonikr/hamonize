package com.model;

public class ActAgentFirewallVo {

	private String datetime;
	private String uuid;
	private String hostname;
	private String status;
	private String status_yn;
	private String retport;
	private Integer orgseq;
	
	
	@Override
	public String toString() {
		return "ActAgentFirewallVo [datetime=" + datetime + ", uuid=" + uuid + ", hostname=" + hostname + ", status="
				+ status + ", status_yn=" + status_yn + ", retport=" + retport + "]";
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
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getRetport() {
		return retport;
	}
	public void setRetport(String retport) {
		this.retport = retport;
	}

	public String getStatus_yn() {
		return status_yn;
	}

	public void setStatus_yn(String status_yn) {
		this.status_yn = status_yn;
	}

	public Integer getOrgseq() {
		return orgseq;
	}

	public void setOrgseq(Integer orgseq) {
		this.orgseq = orgseq;
	}
	
	
	
	
	
	
	


}