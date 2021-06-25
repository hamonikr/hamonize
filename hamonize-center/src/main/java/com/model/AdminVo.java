package com.model;

import com.paging.PagingVo;

public class AdminVo extends PagingVo{
	//센터 관리자
	private String user_id;
	private String pass_wd;
	private String user_name;
	private String dept_name;
	private String gubun;
	private String insert_dt;
	private String update_dt;
	private int adminListInfoCurrentPage;
	
	
	
	//사지방 관리자
	private String arr_org_seq;
	private String rank;
	private String tel_num;
	private String phone_num;
	private String manager_yn;
	private int ListInfoCurrentPage;
	private int[] org_seq;
	private String org_nm;
	
	//검색
	private String keyWord;
	private String txtSearch;
	
	
	
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
	public String getDept_name() {
		return dept_name;
	}
	public void setDept_name(String dept_name) {
		this.dept_name = dept_name;
	}
	public String getGubun() {
		return gubun;
	}
	public void setGubun(String gubun) {
		this.gubun = gubun;
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
	public int getAdminListInfoCurrentPage() {
		return adminListInfoCurrentPage;
	}
	public void setAdminListInfoCurrentPage(int adminListInfoCurrentPage) {
		this.adminListInfoCurrentPage = adminListInfoCurrentPage;
	}
	
	
	
	
	
	
	public String getArr_org_seq() {
		return arr_org_seq;
	}
	public void setArr_org_seq(String arr_org_seq) {
		this.arr_org_seq = arr_org_seq;
	}
	public String getRank() {
		return rank;
	}
	public void setRank(String rank) {
		this.rank = rank;
	}
	public String getTel_num() {
		return tel_num;
	}
	public void setTel_num(String tel_num) {
		this.tel_num = tel_num;
	}
	public String getPhone_num() {
		return phone_num;
	}
	public void setPhone_num(String phone_num) {
		this.phone_num = phone_num;
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
	public int[] getOrg_seq() {
		return org_seq;
	}
	public void setOrg_seq(int[] org_seq) {
		this.org_seq = org_seq;
	}
	public String getOrg_nm() {
		return org_nm;
	}
	public void setOrg_nm(String org_nm) {
		this.org_nm = org_nm;
	}
	
	public String getKeyWord() {
		return keyWord;
	
	}
	
	public void setKeyWord(String keyWord) {
		this.keyWord = keyWord;
	
	}
	
	public String getTxtSearch() {
		return txtSearch;
	
	}
	
	public void setTxtSearch(String txtSearch) {
		this.txtSearch = txtSearch;
	
	}
	
	
	
	
	
	

}
