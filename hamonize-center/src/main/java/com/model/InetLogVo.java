package com.model;

public class InetLogVo{
	
	private  int inet_seq;
	private String user_id;
	private String pc_ip;
	private String cnnc_url;
	private String pc_uuid;
	private String hostname;
	private String state;
	private String reg_dt;
	
	
	@Override
	public String toString() {
		return "InetLogVo [inet_seq=" + inet_seq + ", user_id=" + user_id + ", pc_ip=" + pc_ip + ", cnnc_url="
				+ cnnc_url + ", pc_uuid=" + pc_uuid + ", hostname=" + hostname + ", state=" + state + ", reg_dt="
				+ reg_dt + "]";
	}
	public int getInet_seq() {
		return inet_seq;
	}
	public void setInet_seq(int inet_seq) {
		this.inet_seq = inet_seq;
	}
	public String getUser_id() {
		return user_id;
	}
	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}
	public String getPc_ip() {
		return pc_ip;
	}
	public void setPc_ip(String pc_ip) {
		this.pc_ip = pc_ip;
	}
	public String getCnnc_url() {
		return cnnc_url;
	}
	public void setCnnc_url(String cnnc_url) {
		this.cnnc_url = cnnc_url;
	}
	public String getPc_uuid() {
		return pc_uuid;
	}
	public void setPc_uuid(String pc_uuid) {
		this.pc_uuid = pc_uuid;
	}
	public String getHostname() {
		return hostname;
	}
	public void setHostname(String hostname) {
		this.hostname = hostname;
	}
	public String getState() {
		return state;
	}
	public void setState(String state) {
		this.state = state;
	}
	public String getReg_dt() {
		return reg_dt;
	}
	public void setReg_dt(String reg_dt) {
		this.reg_dt = reg_dt;
	}
	
	
	
}
