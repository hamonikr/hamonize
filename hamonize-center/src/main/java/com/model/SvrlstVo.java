package com.model;

public class SvrlstVo {

	private int seq;
	private String svr_nm;
	private String svr_domain;
	private String svr_ip;
	private String svr_port;
	private String svr_dc;
	private String insert_dt;

	// search ====
	private String txtSearch;
	private String keyWord;
	private String chkdel;
	
	

	private int svrlstInfoCurrentPage;

	public int getSeq() {
		return seq;
	}

	public void setSeq(int seq) {
		this.seq = seq;
	}

	public String getSvr_nm() {
		return svr_nm;
	}

	public void setSvr_nm(String svr_nm) {
		this.svr_nm = svr_nm;
	}

	public String getSvr_domain() {
		return svr_domain;
	}

	public void setSvr_domain(String svr_domain) {
		this.svr_domain = svr_domain;
	}

	public String getSvr_ip() {
		return svr_ip;
	}

	public void setSvr_ip(String svr_ip) {
		this.svr_ip = svr_ip;
	}

	public String getSvr_dc() {
		return svr_dc;
	}

	public void setSvr_dc(String svr_dc) {
		this.svr_dc = svr_dc;
	}

	public String getInsert_dt() {
		return insert_dt;
	}

	public void setInsert_dt(String insert_dt) {
		this.insert_dt = insert_dt;
	}

	public String getTxtSearch() {
		return txtSearch;
	}

	public void setTxtSearch(String txtSearch) {
		this.txtSearch = txtSearch;
	}

	public String getKeyWord() {
		return keyWord;
	}

	public void setKeyWord(String keyWord) {
		this.keyWord = keyWord;
	}

	public int getSvrlstInfoCurrentPage() {
		return svrlstInfoCurrentPage;
	}

	public void setSvrlstInfoCurrentPage(int svrlstInfoCurrentPage) {
		this.svrlstInfoCurrentPage = svrlstInfoCurrentPage;
	}

	public String getChkdel() {
		return chkdel;
	}

	public void setChkdel(String chkdel) {
		this.chkdel = chkdel;
	}

	public String getSvr_port() {
		return svr_port;
	}

	public void setSvr_port(String svr_port) {
		this.svr_port = svr_port;
	}


	
	
}
