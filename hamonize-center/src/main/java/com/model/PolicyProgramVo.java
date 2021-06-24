package com.model;

public class PolicyProgramVo {
	
	//정책확정Insert
	private Integer seq;
	private Integer org_seq;
	private String ppm_seq;
	
	//프로그램관리list
	private int pcm_seq;
	private String pcm_name;
	private String pcm_status;
	private String pcm_dc;
	
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
	public int getPcm_seq() {
		return pcm_seq;
	}
	public void setPcm_seq(int pcm_seq) {
		this.pcm_seq = pcm_seq;
	}
	public String getPcm_name() {
		return pcm_name;
	}
	public void setPcm_name(String pcm_name) {
		this.pcm_name = pcm_name;
	}
	public String getPcm_status() {
		return pcm_status;
	}
	public void setPcm_status(String pcm_status) {
		this.pcm_status = pcm_status;
	}
	public String getPcm_dc() {
		return pcm_dc;
	}
	public void setPcm_dc(String pcm_dc) {
		this.pcm_dc = pcm_dc;
	}
	
	
}
