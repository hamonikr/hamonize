package com.model;




public class BlockingNxssInfoVo {
	// tbl_allow_ip_inof
	private int seq;
	private String domain;
	private String info;
	private String inst_dt;
	private String upd_dt;
	private String gubun;
	
	// search ====
	private String txtSearch;
	private String keyWord;

	private int mngeListInfoCurrentPage;
	
	// insert
	private String blockingAddress;
	private String infomation;
	
	// delete
	private String[] deleteAdressList;
	
	// forward domain
	private String forwardDomain;
	private String forwardNotice;

	

	public String getTxtSearch() {
		return txtSearch;
	}

	public String getGubun() {
		return gubun;
	}

	public void setGubun(String gubun) {
		this.gubun = gubun;
	}

	public String getUpd_dt() {
		return upd_dt;
	}

	public void setUpd_dt(String upd_dt) {
		this.upd_dt = upd_dt;
	}

	public String getInst_dt() {
		return inst_dt;
	}

	public void setInst_dt(String inst_dt) {
		this.inst_dt = inst_dt;
	}

	public String getInfo() {
		return info;
	}

	public void setInfo(String info) {
		this.info = info;
	}

	public String getDomain() {
		return domain;
	}

	public void setDomain(String domain) {
		this.domain = domain;
	}

	public int getSeq() {
		return seq;
	}

	public void setSeq(int seq) {
		this.seq = seq;
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

	public int getMngeListInfoCurrentPage() {
		return mngeListInfoCurrentPage;
	}

	public void setMngeListInfoCurrentPage(int mngeListInfoCurrentPage) {
		this.mngeListInfoCurrentPage = mngeListInfoCurrentPage;
	}

	public String getBlockingAddress() {
		return blockingAddress;
	}

	public void setBlockingAddress(String blockingAddress) {
		this.blockingAddress = blockingAddress;
	}

	public String getInfomation() {
		return infomation;
	}

	public void setInfomation(String infomation) {
		this.infomation = infomation;
	}

	public String[] getDeleteAdressList() {
		return deleteAdressList;
	}

	public void setDeleteAdressList(String[] deleteAdressList) {
		this.deleteAdressList = deleteAdressList;
	}

	public String getForwardDomain() {
		return forwardDomain;
	}

	public void setForwardDomain(String forwardDomain) {
		this.forwardDomain = forwardDomain;
	}

	public String getForwardNotice() {
		return forwardNotice;
	}

	public void setForwardNotice(String forwardNotice) {
		this.forwardNotice = forwardNotice;
	}
	
	
}
