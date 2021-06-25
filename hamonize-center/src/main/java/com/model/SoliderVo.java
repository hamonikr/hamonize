package com.model;




public class SoliderVo {

	private int idx;
	private String number;
	private String id;
	private String pw;
	private String name;
	private String insert_dt;
	private String update_dt;
	private String kind;
	private String rank;
	private String discharge_dt;
	private String group_orgcode; 
	private String orgname; 
	

	// search ====
	private String txtSearch;
	private String selectOrgName;
	private String keyWord;

	private int soliderListInfoCurrentPage;

	public int getIdx() {
		return idx;
	}

	public void setIdx(int idx) {
		this.idx = idx;
	}

	public String getNumber() {
		return number;
	}

	public void setNumber(String number) {
		this.number = number;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getPw() {
		return pw;
	}

	public void setPw(String pw) {
		this.pw = pw;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
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

	public String getGroup_orgcode() {
		return group_orgcode;
	}

	public void setGroup_orgcode(String group_orgcode) {
		this.group_orgcode = group_orgcode;
	}

	public String getOrgname() {
		return orgname;
	}

	public void setOrgname(String orgname) {
		this.orgname = orgname;
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

	public int getSoliderListInfoCurrentPage() {
		return soliderListInfoCurrentPage;
	}

	public void setSoliderListInfoCurrentPage(int soliderListInfoCurrentPage) {
		this.soliderListInfoCurrentPage = soliderListInfoCurrentPage;
	}

}