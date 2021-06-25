package com.model;




public class CurlPcBackupVo {
	
	
	// db table====
	private int br_seq;
	private int br_org_seq;
	private String br_backup_path;	// 백업 이미지 경로 및 iso 파일 이름
	private String br_backup_iso_dt;	// 백업실행일시
	private String br_backup_gubun; 	// 백업구분 A:초기백업본
	
	// pc get json ====
	private String bk_datetime;
	private String bk_uuid;
	private String bk_name;
	private String bk_dir; 
	private String bk_hostname;
	private int sgb_seq;
	
	public int getBr_seq() {
		return br_seq;
	}
	public void setBr_seq(int br_seq) {
		this.br_seq = br_seq;
	}
	public int getBr_org_seq() {
		return br_org_seq;
	}
	public void setBr_org_seq(int br_org_seq) {
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
	public String getBr_backup_gubun() {
		return br_backup_gubun;
	}
	public void setBr_backup_gubun(String br_backup_gubun) {
		this.br_backup_gubun = br_backup_gubun;
	}
	public String getBk_datetime() {
		return bk_datetime;
	}
	public void setBk_datetime(String bk_datetime) {
		this.bk_datetime = bk_datetime;
	}
	public String getBk_uuid() {
		return bk_uuid;
	}
	public void setBk_uuid(String bk_uuid) {
		this.bk_uuid = bk_uuid;
	}
	public String getBk_name() {
		return bk_name;
	}
	public void setBk_name(String bk_name) {
		this.bk_name = bk_name;
	}
	public String getBk_dir() {
		return bk_dir;
	}
	public void setBk_dir(String bk_dir) {
		this.bk_dir = bk_dir;
	}
	public String getBk_hostname() {
		return bk_hostname;
	}
	public void setBk_hostname(String bk_hostname) {
		this.bk_hostname = bk_hostname;
	}
	public int getSgb_seq() {
		return sgb_seq;
	}
	public void setSgb_seq(int sgb_seq) {
		this.sgb_seq = sgb_seq;
	} 
	

}