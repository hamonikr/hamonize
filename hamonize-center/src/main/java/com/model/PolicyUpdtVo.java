package com.model;

public class PolicyUpdtVo {
	
	//정책확정Insert
	private Integer seq;
	private Integer org_seq;
	private String ppm_seq;
	
	//프로그램관리list
	private int pu_seq;
	private String pu_name;
	private String pu_status;
	private String pu_dc;
	private String deb_new_version;
	private String deb_now_version;
	
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
	public int getPu_seq() {
		return pu_seq;
	}
	public void setPu_seq(int pu_seq) {
		this.pu_seq = pu_seq;
	}
	public String getPu_name() {
		return pu_name;
	}
	public void setPu_name(String pu_name) {
		this.pu_name = pu_name;
	}
	public String getPu_status() {
		return pu_status;
	}
	public void setPu_status(String pu_status) {
		this.pu_status = pu_status;
	}
	public String getPu_dc() {
		return pu_dc;
	}
	public void setPu_dc(String pu_dc) {
		this.pu_dc = pu_dc;
	}
	public String getDeb_new_version() {
		return deb_new_version;
	}
	public void setDeb_new_version(String deb_new_version) {
		this.deb_new_version = deb_new_version;
	}
	public String getDeb_now_version() {
		return deb_now_version;
	}
	public void setDeb_now_version(String deb_now_version) {
		this.deb_now_version = deb_now_version;
	}
	
	
	
		
}
