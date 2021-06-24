package com.model;



public class BackupCycleVo {
	private int bac_seq;
	private String bac_org_seq;
	private String bac_cycle_option;
	private String bac_cycle_time;
	private String bac_gubun;
	
	private String selectOrgName;
	private String selectOrgUpperCode;
	
	private String[] orgNmCheckedList;
	private String progrmCheckedList;
	
	// insert
	private String backupGubun;
	private String backupOption;
	private String backupTime;
	public int getBac_seq() {
		return bac_seq;
	}
	public void setBac_seq(int bac_seq) {
		this.bac_seq = bac_seq;
	}
	public String getBac_org_seq() {
		return bac_org_seq;
	}
	public void setBac_org_seq(String bac_org_seq) {
		this.bac_org_seq = bac_org_seq;
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
	public String getBackupGubun() {
		return backupGubun;
	}
	public void setBackupGubun(String backupGubun) {
		this.backupGubun = backupGubun;
	}
	public String getBackupOption() {
		return backupOption;
	}
	public void setBackupOption(String backupOption) {
		this.backupOption = backupOption;
	}
	public String getBackupTime() {
		return backupTime;
	}
	public void setBackupTime(String backupTime) {
		this.backupTime = backupTime;
	}
	
}
