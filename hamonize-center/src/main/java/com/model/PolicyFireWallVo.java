package com.model;

public class PolicyFireWallVo {
	
	//정책확정Insert
	private Integer seq;
	private Integer org_seq;
	private String ppm_seq;
	
	//프로그램관리list
	private int sm_seq;
	private String sm_name;
	private String sm_status;
	private String sm_dc;
	private String sm_port;
	private String sm_gubun;
	
	private int mngeListInfoCurrentPage;
	private String[] deleteList;
	
	public Integer getSeq() {
		return seq;
	}
	public void setSeq(Integer seq) {
		this.seq = seq;
	}
	public Integer getOrg_seq() {
		return org_seq;
	}
	public void setOrg_seq(Integer org_seq) {
		this.org_seq = org_seq;
	}
	public String getPpm_seq() {
		return ppm_seq;
	}
	public void setPpm_seq(String ppm_seq) {
		this.ppm_seq = ppm_seq;
	}
	public int getSm_seq() {
		return sm_seq;
	}
	public void setSm_seq(int sm_seq) {
		this.sm_seq = sm_seq;
	}
	public String getSm_name() {
		return sm_name;
	}
	public void setSm_name(String sm_name) {
		this.sm_name = sm_name;
	}
	public String getSm_status() {
		return sm_status;
	}
	public void setSm_status(String sm_status) {
		this.sm_status = sm_status;
	}
	public String getSm_dc() {
		return sm_dc;
	}
	public void setSm_dc(String sm_dc) {
		this.sm_dc = sm_dc;
	}
	public String getSm_port() {
		return sm_port;
	}
	public void setSm_port(String sm_port) {
		this.sm_port = sm_port;
	}
	public String getSm_gubun() {
		return sm_gubun;
	}
	public void setSm_gubun(String sm_gubun) {
		this.sm_gubun = sm_gubun;
	}
	public int getMngeListInfoCurrentPage() {
		return mngeListInfoCurrentPage;
	}
	public void setMngeListInfoCurrentPage(int mngeListInfoCurrentPage) {
		this.mngeListInfoCurrentPage = mngeListInfoCurrentPage;
	}
	public String[] getDeleteList() {
		return deleteList;
	}
	public void setDeleteList(String[] deleteList) {
		this.deleteList = deleteList;
	}
	
	
	
	
}
