package com.model;

import com.paging.PagingVo;

public class UserVo extends PagingVo{

	private Integer idx;
	private String user_gunbun;
	private String user_id;
	private String pass_wd;
	private String user_name;
	private String insert_dt;
	private String update_dt;
	private String kind;
	private String rank;
	private String discharge_dt;
	private Integer org_seq; 
	private String narasarang_no; 
	private String org_nm; 
	private String P_org_nm; 

	// search ====
	private String txtSearch;
	private String selectOrgName;
	private String keyWord;
	private String date_fr;
	private String date_to;
	
	//사지방 관리자
	private String manager_yn;
	private String position;

	private int ListInfoCurrentPage;

	public Integer getIdx() {
		return idx;
	}

	public void setIdx(Integer idx) {
		this.idx = idx;
	}

	

	public String getOrg_nm() {
		return org_nm;
	}

	public void setOrg_nm(String org_nm) {
		this.org_nm = org_nm;
	}

	public String getUser_gunbun() {
		return user_gunbun;
	}

	public void setUser_gunbun(String user_gunbun) {
		this.user_gunbun = user_gunbun;
	}

	public String getUser_id() {
		return user_id;
	}

	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}

	public String getPass_wd() {
		return pass_wd;
	}

	public void setPass_wd(String pass_wd) {
		this.pass_wd = pass_wd;
	}

	public String getUser_name() {
		return user_name;
	}

	public void setUser_name(String user_name) {
		this.user_name = user_name;
	}

	public String getInsert_dt() {
		return insert_dt;
	}

	public void setInsert_dt(String insert_dt) {
		this.insert_dt = insert_dt;
	}

	public String getUpdate_dt() {
		return update_dt;
	}

	public void setUpdate_dt(String update_dt) {
		this.update_dt = update_dt;
	}

	public String getKind() {
		return kind;
	}

	public void setKind(String kind) {
		this.kind = kind;
	}

	public String getRank() {
		return rank;
	}

	public void setRank(String rank) {
		this.rank = rank;
	}

	public String getDischarge_dt() {
		return discharge_dt;
	}

	public void setDischarge_dt(String discharge_dt) {
		this.discharge_dt = discharge_dt;
	}

	public Integer getOrg_seq() {
		return org_seq;
	}

	public void setOrg_seq(Integer org_seq) {
		this.org_seq = org_seq;
	}

	public String getNarasarang_no() {
		return narasarang_no;
	}

	public void setNarasarang_no(String narasarang_no) {
		this.narasarang_no = narasarang_no;
	}

	public String getTxtSearch() {
		return txtSearch;
	}

	public void setTxtSearch(String txtSearch) {
		this.txtSearch = txtSearch;
	}

	public String getSelectOrgName() {
		return selectOrgName;
	}

	public void setSelectOrgName(String selectOrgName) {
		this.selectOrgName = selectOrgName;
	}

	public String getKeyWord() {
		return keyWord;
	}

	public void setKeyWord(String keyWord) {
		this.keyWord = keyWord;
	}

	public String getDate_fr() {
		return date_fr;
	}

	public void setDate_fr(String date_fr) {
		this.date_fr = date_fr;
	}

	public String getDate_to() {
		return date_to;
	}

	public void setDate_to(String date_to) {
		this.date_to = date_to;
	}

	public int getListInfoCurrentPage() {
		return ListInfoCurrentPage;
	}

	public void setListInfoCurrentPage(int listInfoCurrentPage) {
		ListInfoCurrentPage = listInfoCurrentPage;
	}

	public String getManager_yn() {
		return manager_yn;
	}

	public void setManager_yn(String manager_yn) {
		this.manager_yn = manager_yn;
	}

	public String getPosition() {
		return position;
	}

	public void setPosition(String position) {
		this.position = position;
	}

	public String getP_org_nm() {
		return P_org_nm;
	}

	public void setP_org_nm(String p_org_nm) {
		P_org_nm = p_org_nm;
	}
	
	

	

}