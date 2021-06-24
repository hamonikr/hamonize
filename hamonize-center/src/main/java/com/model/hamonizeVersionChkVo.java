package com.model;

public class hamonizeVersionChkVo{
	
	private Integer debseq;
	private String debname;
	private String debversion;
	private String debstatus;
	private String pcuuid;
	private String insert_dt;
	
	
	
	@Override
	public String toString() {
		return "UpdtPolicyVo [debseq=" + debseq + ", debname=" + debname + ", debversion=" + debversion + ", debstatus="
				+ debstatus + ", pcuuid=" + pcuuid + ", insert_dt=" + insert_dt + "]";
	}
	
	
	public Integer getDebseq() {
		return debseq;
	}
	public void setDebseq(Integer debseq) {
		this.debseq = debseq;
	}
	public String getDebname() {
		return debname;
	}
	public void setDebname(String debname) {
		this.debname = debname;
	}
	public String getDebversion() {
		return debversion;
	}
	public void setDebversion(String debversion) {
		this.debversion = debversion;
	}
	public String getDebstatus() {
		return debstatus;
	}
	public void setDebstatus(String debstatus) {
		this.debstatus = debstatus;
	}
	public String getPcuuid() {
		return pcuuid;
	}
	public void setPcuuid(String pcuuid) {
		this.pcuuid = pcuuid;
	}
	public String getInsert_dt() {
		return insert_dt;
	}
	public void setInsert_dt(String insert_dt) {
		this.insert_dt = insert_dt;
	}
	
	
}
