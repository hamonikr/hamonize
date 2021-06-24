package com.model;

import java.util.Arrays;

public class UpdtPolicyVo{
	
	private String debname;
	private String debver;
	private String[] arrDebname;
	private String state;
	private String path;
	private String gubun;
	private String org_seq;
	private String pc_uuid;
	
	
	
	
	
	
	@Override
	public String toString() {
		return "UpdtPolicyVo [debname=" + debname + ", arrDebname=" + Arrays.toString(arrDebname) + ", state=" + state
				+ ", path=" + path + ", gubun=" + gubun + ", org_seq=" + org_seq + ", pc_uuid=" + pc_uuid + "]";
	}
	public String[] getArrDebname() {
		return arrDebname;
	}
	public void setArrDebname(String[] arrDebname) {
		this.arrDebname = arrDebname;
	}
	public String getOrg_seq() {
		return org_seq;
	}
	public void setOrg_seq(String org_seq) {
		this.org_seq = org_seq;
	}
	public String getDebname() {
		return debname;
	}
	public void setDebname(String debname) {
		this.debname = debname;
	}
	public String getState() {
		return state;
	}
	public void setState(String state) {
		this.state = state;
	}
	public String getPath() {
		return path;
	}
	public void setPath(String path) {
		this.path = path;
	}
	public String getGubun() {
		return gubun;
	}
	public void setGubun(String gubun) {
		this.gubun = gubun;
	}
	public String getPc_uuid() {
		return pc_uuid;
	}
	public void setPc_uuid(String pc_uuid) {
		this.pc_uuid = pc_uuid;
	}
	public String getDebver() {
		return debver;
	}
	public void setDebver(String debver) {
		this.debver = debver;
	}
	

	
}
