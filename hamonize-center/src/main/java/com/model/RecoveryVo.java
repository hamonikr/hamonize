package com.model;




public class RecoveryVo {
	private int br_seq;
	private String br_org_seq;
	private String br_backup_path;
	private String br_backup_iso_dt;
	
	private String selectOrgName;
	private String selectOrgUpperCode;
	
	private String[] orgNmCheckedList;
	private String progrmCheckedList;
	
	// insert
	private String[] pcCheckedList;
	private String recoveryChecked;
	public int getBr_seq() {
		return br_seq;
	}
	public void setBr_seq(int br_seq) {
		this.br_seq = br_seq;
	}
	public String getBr_org_seq() {
		return br_org_seq;
	}
	public void setBr_org_seq(String br_org_seq) {
		this.br_org_seq = br_org_seq;
	}
	public String getBr_backup_path() {
		return br_backup_path;
	}
	public void setBr_backup_path(String br_backup_path) {
		this.br_backup_path = br_backup_path;
	}
	public String getBr_backup_iso_dt() {
		return br_backup_iso_dt;
	}
	public void setBr_backup_iso_dt(String br_backup_iso_dt) {
		this.br_backup_iso_dt = br_backup_iso_dt;
	}
	public String getSelectOrgName() {
		return selectOrgName;
	}
	public void setSelectOrgName(String selectOrgName) {
		this.selectOrgName = selectOrgName;
	}
	public String getSelectOrgUpperCode() {
		return selectOrgUpperCode;
	}
	public void setSelectOrgUpperCode(String selectOrgUpperCode) {
		this.selectOrgUpperCode = selectOrgUpperCode;
	}
	public String[] getOrgNmCheckedList() {
		return orgNmCheckedList;
	}
	public void setOrgNmCheckedList(String[] orgNmCheckedList) {
		this.orgNmCheckedList = orgNmCheckedList;
	}
	public String getProgrmCheckedList() {
		return progrmCheckedList;
	}
	public void setProgrmCheckedList(String progrmCheckedList) {
		this.progrmCheckedList = progrmCheckedList;
	}
	public String[] getPcCheckedList() {
		return pcCheckedList;
	}
	public void setPcCheckedList(String[] pcCheckedList) {
		this.pcCheckedList = pcCheckedList;
	}
	public String getRecoveryChecked() {
		return recoveryChecked;
	}
	public void setRecoveryChecked(String recoveryChecked) {
		this.recoveryChecked = recoveryChecked;
	}
}
