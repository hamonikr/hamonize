package com.model;

public class ActAgentNxssVo {

	private Integer orgseq;
	private String uuid;
	private String hostname;
	private String file_gubun;
	private String fileDate;
	private String ins_date;

	@Override
	public String toString() {
		return "ActAgentNxssVo [orgseq=" + orgseq + ", uuid=" + uuid + ", hostname=" + hostname + ", file_gubun=" + file_gubun
				+ ", fileDate=" + fileDate + ", ins_date=" + ins_date + "]";
	}

	public Integer getOrgseq() {
		return orgseq;
	}

	public void setOrgseq(Integer orgseq) {
		this.orgseq = orgseq;
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

	public String getFile_gubun() {
		return file_gubun;
	}

	public void setFile_gubun(String file_gubun) {
		this.file_gubun = file_gubun;
	}

	public String getFileDate() {
		return fileDate;
	}

	public void setFileDate(String fileDate) {
		this.fileDate = fileDate;
	}

	public String getIns_date() {
		return ins_date;
	}

	public void setIns_date(String ins_date) {
		this.ins_date = ins_date;
	}

}