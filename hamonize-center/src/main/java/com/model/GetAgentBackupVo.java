package com.model;

public class GetAgentBackupVo {

	private int bac_seq;
	private int org_seq;
	private String bac_cycle_option; 
	private String bac_cycle_time; 
	private String bac_gubun;
	private String pcm_uuid;
	
	
	public int getBac_seq() {
		return bac_seq;
	}
	public void setBac_seq(int bac_seq) {
		this.bac_seq = bac_seq;
	}
	public int getOrg_seq() {
		return org_seq;
	}
	public void setOrg_seq(int org_seq) {
		this.org_seq = org_seq;
	}
	public String getBac_cycle_option() {
		return bac_cycle_option;
	}
	public void setBac_cycle_option(String bac_cycle_option) {
		this.bac_cycle_option = bac_cycle_option;
	}
	public String getBac_cycle_time() {
		return bac_cycle_time;
	}
	public void setBac_cycle_time(String bac_cycle_time) {
		this.bac_cycle_time = bac_cycle_time;
	}
	public String getBac_gubun() {
		return bac_gubun;
	}
	public void setBac_gubun(String bac_gubun) {
		this.bac_gubun = bac_gubun;
	}
	public String getPcm_uuid() {
		return pcm_uuid;
	}
	public void setPcm_uuid(String pcm_uuid) {
		this.pcm_uuid = pcm_uuid;
	} 

	
	
	
	
}
