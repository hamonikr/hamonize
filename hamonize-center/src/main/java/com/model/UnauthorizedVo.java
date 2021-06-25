package com.model;

public class UnauthorizedVo{
	
	private  int seq;
	private  int org_seq;
	private String pc_uuid; 
	private String vendor;
	private String product; 
	private String info;
	private String pc_user;
	private String insert_dt;
	
	
	@Override
	public String toString() {
		return "UnauthorizedVo [seq=" + seq + ", pc_uuid=" + pc_uuid + ", vendor=" + vendor + ", product=" + product
				+ ", info=" + info + ", pc_user=" + pc_user + ", insert_dt=" + insert_dt +", org_seq=" + org_seq + "]";
	}
	public int getSeq() {
		return seq;
	}
	public void setSeq(int seq) {
		this.seq = seq;
	}
	public String getPc_uuid() {
		return pc_uuid;
	}
	public void setPc_uuid(String pc_uuid) {
		this.pc_uuid = pc_uuid;
	}
	public String getVendor() {
		return vendor;
	}
	public void setVendor(String vendor) {
		this.vendor = vendor;
	}
	public String getProduct() {
		return product;
	}
	public void setProduct(String product) {
		this.product = product;
	}
	public String getInfo() {
		return info;
	}
	public void setInfo(String info) {
		this.info = info;
	}
	public String getPc_user() {
		return pc_user;
	}
	public void setPc_user(String pc_user) {
		this.pc_user = pc_user;
	}
	public String getInsert_dt() {
		return insert_dt;
	}
	public void setInsert_dt(String insert_dt) {
		this.insert_dt = insert_dt;
	}
	public int getOrg_seq() {
		return org_seq;
	}
	public void setOrg_seq(int org_seq) {
		this.org_seq = org_seq;
	}
	
	
	
	
	
}
