package com.model;

import java.util.Date;

public class BackupVo {
	//공통
	private Integer bac_seq;
	private Integer org_seq;
	
	//백업주기 관리
	private String bac_cycle_option;
	private String bac_cycle_time;
	private String bac_gubun;
	
	//복구관리
	private Integer dept_seq;
	private String br_backup_path;
	private Date br_backup_iso_dt;
	private String br_backup_gubun;
	private String br_backup_name;
	
	public Integer getBac_seq() {
		return bac_seq;
	}
	public void setBac_seq(Integer bac_seq) {
		this.bac_seq = bac_seq;
	}
	public Integer getOrg_seq() {
		return org_seq;
	}
	public void setOrg_seq(Integer org_seq) {
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
	public Integer getDept_seq() {
		return dept_seq;
	}
	public void setDept_seq(Integer dept_seq) {
		this.dept_seq = dept_seq;
	}
	public String getBr_backup_path() {
		return br_backup_path;
	}
	public void setBr_backup_path(String br_backup_path) {
		this.br_backup_path = br_backup_path;
	}
	public Date getBr_backup_iso_dt() {
		return br_backup_iso_dt;
	}
	public void setBr_backup_iso_dt(Date br_backup_iso_dt) {
		this.br_backup_iso_dt = br_backup_iso_dt;
	}
	public String getBr_backup_gubun() {
		return br_backup_gubun;
	}
	public void setBr_backup_gubun(String br_backup_gubun) {
		this.br_backup_gubun = br_backup_gubun;
	}
	public String getBr_backup_name() {
		return br_backup_name;
	}
	public void setBr_backup_name(String br_backup_name) {
		this.br_backup_name = br_backup_name;
	}
	
	
	

}
