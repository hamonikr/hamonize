package com.model;




public class AllowIpInfoVo {
	// tbl_allow_ip_inof
	private int sma_seq;
	private String sma_ipaddress;
	private String sma_macaddress;
	private String sma_info;
	private String sma_insert_dt;
	private String sma_update_dt;
	private String sma_gubun;
	
	// search ====
	private String txtSearch;
	private String keyWord;

	private int mngeListInfoCurrentPage;
	
	// insert
	private String ipaddress;
	private String macaddress;
	private String infomation;
	
	// delete
	private String[] deleteAdressList;

	public int getSma_seq() {
		return sma_seq;
	}

	public void setSma_seq(int sma_seq) {
		this.sma_seq = sma_seq;
	}

	public String getSma_ipaddress() {
		return sma_ipaddress;
	}

	public void setSma_ipaddress(String sma_ipaddress) {
		this.sma_ipaddress = sma_ipaddress;
	}

	public String getSma_macaddress() {
		return sma_macaddress;
	}

	public void setSma_macaddress(String sma_macaddress) {
		this.sma_macaddress = sma_macaddress;
	}

	public String getSma_info() {
		return sma_info;
	}

	public void setSma_info(String sma_info) {
		this.sma_info = sma_info;
	}

	public String getSma_insert_dt() {
		return sma_insert_dt;
	}

	public void setSma_insert_dt(String sma_insert_dt) {
		this.sma_insert_dt = sma_insert_dt;
	}

	public String getSma_update_dt() {
		return sma_update_dt;
	}

	public void setSma_update_dt(String sma_update_dt) {
		this.sma_update_dt = sma_update_dt;
	}

	public String getSma_gubun() {
		return sma_gubun;
	}

	public void setSma_gubun(String sma_gubun) {
		this.sma_gubun = sma_gubun;
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

	public int getMngeListInfoCurrentPage() {
		return mngeListInfoCurrentPage;
	}

	public void setMngeListInfoCurrentPage(int mngeListInfoCurrentPage) {
		this.mngeListInfoCurrentPage = mngeListInfoCurrentPage;
	}

	public String getIpaddress() {
		return ipaddress;
	}

	public void setIpaddress(String ipaddress) {
		this.ipaddress = ipaddress;
	}

	public String getMacaddress() {
		return macaddress;
	}

	public void setMacaddress(String macaddress) {
		this.macaddress = macaddress;
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
	
	
}
