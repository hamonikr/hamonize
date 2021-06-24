package com.model;

public class OrgVo {
	
	private Integer seq;
	private Integer p_seq;
	private Integer org_ordr;
	private String org_nm;
	private String p_org_nm;
	private String all_org_nm;
	private String sido;
	private String gugun;
	private String org_num;
	private String writer_id;
	private String writer_ip;
	private String update_writer_id;
	private String update_writer_ip;
	private String section;
	private String orgname;
	private String pc_uuid;
	private String level;
	

	public Integer getSeq() {
		return seq;
	}
	public String getWriter_id() {
		return writer_id;
	}
	public void setWriter_id(String writer_id) {
		this.writer_id = writer_id;
	}
	public String getUpdate_writer_ip() {
		return update_writer_ip;
	}
	public void setUpdate_writer_ip(String update_writer_ip) {
		this.update_writer_ip = update_writer_ip;
	}
	public String getUpdate_writer_id() {
		return update_writer_id;
	}
	public void setUpdate_writer_id(String update_writer_id) {
		this.update_writer_id = update_writer_id;
	}
	public String getWriter_ip() {
		return writer_ip;
	}
	public void setWriter_ip(String writer_ip) {
		this.writer_ip = writer_ip;
	}
	
	public void setSeq(Integer seq) {
		this.seq = seq;
	}
	public Integer getP_seq() {
		return p_seq;
	}
	public void setP_seq(Integer p_seq) {
		this.p_seq = p_seq;
	}
	public Integer getOrg_ordr() {
		return org_ordr;
	}
	public void setOrg_ordr(Integer org_ordr) {
		this.org_ordr = org_ordr;
	}
	public String getOrg_nm() {
		return org_nm;
	}
	public void setOrg_nm(String org_nm) {
		this.org_nm = org_nm;
	}

	
	
	public String getSection() {
		return section;
	}
	public void setSection(String section) {
		this.section = section;
	}
	public String getOrgname() {
		return orgname;
	}
	public void setOrgname(String orgname) {
		this.orgname = orgname;
	}
	public String getPc_uuid() {
		return pc_uuid;
	}
	public void setPc_uuid(String pc_uuid) {
		this.pc_uuid = pc_uuid;
	}
	public String getP_org_nm() {
		return p_org_nm;
	}
	public void setP_org_nm(String p_org_nm) {
		this.p_org_nm = p_org_nm;
	}
	public String getAll_org_nm() {
		return all_org_nm;
	}
	public void setAll_org_nm(String all_org_nm) {
		this.all_org_nm = all_org_nm;
	}
	public String getSido() {
		return sido;
	}
	public void setSido(String sido) {
		this.sido = sido;
	}
	public String getGugun() {
		return gugun;
	}
	public void setGugun(String gugun) {
		this.gugun = gugun;
	}
	public String getOrg_num() {
		return org_num;
	}
	public void setOrg_num(String org_num) {
		this.org_num = org_num;
	}
	public String getLevel() {
		return level;
	}
	public void setLevel(String level) {
		this.level = level;
	}
	
	

}
