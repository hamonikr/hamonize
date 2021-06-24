package com.model;




public class GetAgentJobVo {
	 
	// == new vo val
	private String pc_uuid;
	private int seq;
	private int p_seq;
	private String org_nm;
	private int sgb_seq;
	
	
	
	// == agentjob
	private int aj_seq;
	private String aj_table_seq;
	private String insert_dt;
	private String aj_return_val;
	private String aj_table_gubun;
	

	// == tbl progrm policy applc
	private String ppa_pcm_seq;
	private String pcm_name;
	
	// == pc uuid 
	private int org_seq;
	private String orgcode;
	private String upper_org_code;
	private String upper_org_name;
	private String uuid_orgname;
	private String upper_org_seq;
	private String uuid;
	
	// == t_backup recovery mngr 
	private String br_org_seq;
	private String br_backup_path; 
	private String br_backup_iso_dt; 
	private String br_backup_gubun;
	
	
	public int getAj_seq() {
		return aj_seq;
	}
	public void setAj_seq(int aj_seq) {
		this.aj_seq = aj_seq;
	}
	public String getAj_table_seq() {
		return aj_table_seq;
	}
	public void setAj_table_seq(String aj_table_seq) {
		this.aj_table_seq = aj_table_seq;
	}
	public String getInsert_dt() {
		return insert_dt;
	}
	public void setInsert_dt(String insert_dt) {
		this.insert_dt = insert_dt;
	}
	public String getAj_return_val() {
		return aj_return_val;
	}
	public void setAj_return_val(String aj_return_val) {
		this.aj_return_val = aj_return_val;
	}
	public String getAj_table_gubun() {
		return aj_table_gubun;
	}
	public void setAj_table_gubun(String aj_table_gubun) {
		this.aj_table_gubun = aj_table_gubun;
	}
	public String getPpa_pcm_seq() {
		return ppa_pcm_seq;
	}
	public void setPpa_pcm_seq(String ppa_pcm_seq) {
		this.ppa_pcm_seq = ppa_pcm_seq;
	}
	public String getPcm_name() {
		return pcm_name;
	}
	public void setPcm_name(String pcm_name) {
		this.pcm_name = pcm_name;
	}
	public int getOrg_seq() {
		return org_seq;
	}
	public void setOrg_seq(int org_seq) {
		this.org_seq = org_seq;
	}
	public String getOrgcode() {
		return orgcode;
	}
	public void setOrgcode(String orgcode) {
		this.orgcode = orgcode;
	}
	public String getUpper_org_code() {
		return upper_org_code;
	}
	public void setUpper_org_code(String upper_org_code) {
		this.upper_org_code = upper_org_code;
	}
	public String getUpper_org_name() {
		return upper_org_name;
	}
	public void setUpper_org_name(String upper_org_name) {
		this.upper_org_name = upper_org_name;
	}
	public String getUuid_orgname() {
		return uuid_orgname;
	}
	public void setUuid_orgname(String uuid_orgname) {
		this.uuid_orgname = uuid_orgname;
	}
	public String getUpper_org_seq() {
		return upper_org_seq;
	}
	public void setUpper_org_seq(String upper_org_seq) {
		this.upper_org_seq = upper_org_seq;
	}
	public String getUuid() {
		return uuid;
	}
	public void setUuid(String uuid) {
		this.uuid = uuid;
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
	public String getBr_backup_gubun() {
		return br_backup_gubun;
	}
	public void setBr_backup_gubun(String br_backup_gubun) {
		this.br_backup_gubun = br_backup_gubun;
	}
	public String getPc_uuid() {
		return pc_uuid;
	}
	public void setPc_uuid(String pc_uuid) {
		this.pc_uuid = pc_uuid;
	}
	public int getSeq() {
		return seq;
	}
	public void setSeq(int seq) {
		this.seq = seq;
	}
	public int getP_seq() {
		return p_seq;
	}
	public void setP_seq(int p_seq) {
		this.p_seq = p_seq;
	}
	public String getOrg_nm() {
		return org_nm;
	}
	public void setOrg_nm(String org_nm) {
		this.org_nm = org_nm;
	}
	public int getSgb_seq() {
		return sgb_seq;
	}
	public void setSgb_seq(int sgb_seq) {
		this.sgb_seq = sgb_seq;
	}
	@Override
	public String toString() {
		return "GetAgentJobVo [pc_uuid=" + pc_uuid + ", seq=" + seq + ", p_seq=" + p_seq + ", org_nm=" + org_nm
				+ ", sgb_seq=" + sgb_seq + ", aj_seq=" + aj_seq + ", aj_table_seq=" + aj_table_seq + ", insert_dt="
				+ insert_dt + ", aj_return_val=" + aj_return_val + ", aj_table_gubun=" + aj_table_gubun
				+ ", ppa_pcm_seq=" + ppa_pcm_seq + ", pcm_name=" + pcm_name + ", org_seq=" + org_seq + ", orgcode="
				+ orgcode + ", upper_org_code=" + upper_org_code + ", upper_org_name=" + upper_org_name
				+ ", uuid_orgname=" + uuid_orgname + ", upper_org_seq=" + upper_org_seq + ", uuid=" + uuid
				+ ", br_org_seq=" + br_org_seq + ", br_backup_path=" + br_backup_path + ", br_backup_iso_dt="
				+ br_backup_iso_dt + ", br_backup_gubun=" + br_backup_gubun + ", getAj_seq()=" + getAj_seq()
				+ ", getAj_table_seq()=" + getAj_table_seq() + ", getInsert_dt()=" + getInsert_dt()
				+ ", getAj_return_val()=" + getAj_return_val() + ", getAj_table_gubun()=" + getAj_table_gubun()
				+ ", getPpa_pcm_seq()=" + getPpa_pcm_seq() + ", getPcm_name()=" + getPcm_name() + ", getOrg_seq()="
				+ getOrg_seq() + ", getOrgcode()=" + getOrgcode() + ", getUpper_org_code()=" + getUpper_org_code()
				+ ", getUpper_org_name()=" + getUpper_org_name() + ", getUuid_orgname()=" + getUuid_orgname()
				+ ", getUpper_org_seq()=" + getUpper_org_seq() + ", getSgb_uuid()=" + getUuid()
				+ ", getBr_org_seq()=" + getBr_org_seq() + ", getBr_backup_path()=" + getBr_backup_path()
				+ ", getBr_backup_iso_dt()=" + getBr_backup_iso_dt() + ", getBr_backup_gubun()=" + getBr_backup_gubun()
				+ ", getPc_uuid()=" + getPc_uuid() + ", getSeq()=" + getSeq() + ", getP_seq()=" + getP_seq()
				+ ", getOrg_nm()=" + getOrg_nm() + ", getSgb_seq()=" + getSgb_seq() + ", getClass()=" + getClass()
				+ ", hashCode()=" + hashCode() + ", toString()=" + super.toString() + "]";
	}
	
	
	
	
    

}
