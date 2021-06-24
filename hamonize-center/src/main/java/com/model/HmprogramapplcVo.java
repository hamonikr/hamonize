package com.model;





public class HmprogramapplcVo {

	private int ppa_seq;
	private String ppa_org_seq;
	private String ppa_pcm_seq;

	// search ====
	private String txtSearch;
	private String selectOrgName;
	private String keyWord;
	public int getPpa_seq() {
		return ppa_seq;
	}
	public void setPpa_seq(int ppa_seq) {
		this.ppa_seq = ppa_seq;
	}
	public String getPpa_org_seq() {
		return ppa_org_seq;
	}
	public void setPpa_org_seq(String ppa_org_seq) {
		this.ppa_org_seq = ppa_org_seq;
	}
	public String getPpa_pcm_seq() {
		return ppa_pcm_seq;
	}
	public void setPpa_pcm_seq(String ppa_pcm_seq) {
		this.ppa_pcm_seq = ppa_pcm_seq;
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

}
