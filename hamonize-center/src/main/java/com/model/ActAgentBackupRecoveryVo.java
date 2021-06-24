package com.model;

public class ActAgentBackupRecoveryVo {
	private Integer orgseq;
	private String datetime;
	private String uuid;
	private String hostname;
	private String action_status;
	private String result;

	

	@Override
	public String toString() {
		return "ActAgentBackupRecoveryVo [orgseq=" + orgseq + ", datetime=" + datetime + ", uuid=" + uuid
				+ ", hostname=" + hostname + ", action_status=" + action_status + ", result=" + result + "]";
	}
	public String getResult() {
		return result;
	}

	public void setResult(String result) {
		this.result = result;
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

	public String getAction_status() {
		return action_status;
	}

	public void setAction_status(String action_status) {
		this.action_status = action_status;
	}

}