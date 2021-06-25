package com.model;

public class ActAgentProgrmVo {

	private Integer orgseq;
	private String datetime;
	private String uuid;
	private String hostname;
	private String status_yn;
	private String status;
	private String progrmname;
	
	
	@Override
	public String toString() {
		return "ActAgentProgrmVo [orgseq=" + orgseq + ", datetime=" + datetime + ", uuid=" + uuid + ", hostname="
				+ hostname + ", status_yn=" + status_yn + ", status=" + status + ", progrmname=" + progrmname + "]";
	}
	
	
	public Integer getOrgseq() {
		return orgseq;
	}
	public void setOrgseq(Integer orgseq) {
		this.orgseq = orgseq;
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
	public String getStatus_yn() {
		return status_yn;
	}
	public void setStatus_yn(String status_yn) {
		this.status_yn = status_yn;
	}
	public String getProgrmname() {
		return progrmname;
	}
	public void setProgrmname(String progrmname) {
		this.progrmname = progrmname;
	}

	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	
	


}