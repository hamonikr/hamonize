package com.model;

public class AnswerVo {
	private int as_seq;
	private String as_tcng_seq;
	private String as_content;
	private String as_insert_dt;
	private String as_update_dt;
	
	
	// insert
	private int tcngSeq;
	private String sportStatus;
	private String sportType_detail;
	private String answerContent;
	private String admin_id;
	private String admin_name;
	public int getAs_seq() {
		return as_seq;
	}
	public void setAs_seq(int as_seq) {
		this.as_seq = as_seq;
	}
	public String getAs_tcng_seq() {
		return as_tcng_seq;
	}
	public void setAs_tcng_seq(String as_tcng_seq) {
		this.as_tcng_seq = as_tcng_seq;
	}
	public String getAs_content() {
		return as_content;
	}
	public void setAs_content(String as_content) {
		this.as_content = as_content;
	}
	public String getAs_insert_dt() {
		return as_insert_dt;
	}
	public void setAs_insert_dt(String as_insert_dt) {
		this.as_insert_dt = as_insert_dt;
	}
	public String getAs_update_dt() {
		return as_update_dt;
	}
	public void setAs_update_dt(String as_update_dt) {
		this.as_update_dt = as_update_dt;
	}
	public int getTcngSeq() {
		return tcngSeq;
	}
	public void setTcngSeq(int tcngSeq) {
		this.tcngSeq = tcngSeq;
	}
	public String getSportStatus() {
		return sportStatus;
	}
	public void setSportStatus(String sportStatus) {
		this.sportStatus = sportStatus;
	}
	public String getAnswerContent() {
		return answerContent;
	}
	public void setAnswerContent(String answerContent) {
		this.answerContent = answerContent;
	}
	public String getSportType_detail() {
		return sportType_detail;
	}
	public void setSportType_detail(String sportType_detail) {
		this.sportType_detail = sportType_detail;
	}
	public String getAdmin_id() {
		return admin_id;
	}
	public void setAdmin_id(String admin_id) {
		this.admin_id = admin_id;
	}
	public String getAdmin_name() {
		return admin_name;
	}
	public void setAdmin_name(String admin_name) {
		this.admin_name = admin_name;
	}
	
	
	
}
