package com.model;

public class GetAgentRecoveryVo {

	private int seq;
	private int org_seq;
	private int pc_seq;
	private int br_seq;
	private int recv_applc_seq;
	private String br_backup_gubun;
	private String br_backup_name;
	private String br_backup_path;
	private String insert_dt;
	private String pc_uuid;
	private String status;
	
	
	public int getSeq() {
		return seq;
	}
	public int getPc_seq() {
		return pc_seq;
	}
	public void setPc_seq(int pc_seq) {
		this.pc_seq = pc_seq;
	}
	public void setSeq(int seq) {
		this.seq = seq;
	}
	public int getOrg_seq() {
		return org_seq;
	}
	public void setOrg_seq(int org_seq) {
		this.org_seq = org_seq;
	}
	
	public int getBr_seq() {
		return br_seq;
	}
	public void setBr_seq(int br_seq) {
		this.br_seq = br_seq;
	}
	public int getRecv_applc_seq() {
		return recv_applc_seq;
	}
	public void setRecv_applc_seq(int recv_applc_seq) {
		this.recv_applc_seq = recv_applc_seq;
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
	public String getBr_backup_path() {
		return br_backup_path;
	}
	public void setBr_backup_path(String br_backup_path) {
		this.br_backup_path = br_backup_path;
	}
	public String getInsert_dt() {
		return insert_dt;
	}
	public void setInsert_dt(String insert_dt) {
		this.insert_dt = insert_dt;
	}
	public String getPc_uuid() {
		return pc_uuid;
	}
	public void setPc_uuid(String pc_uuid) {
		this.pc_uuid = pc_uuid;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	
	
	
}
