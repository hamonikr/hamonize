package com.model;




public class HmProgrmUpdtVo {
	private int pu_seq;
	private String pu_name;
	private String pu_status; 
	private String pu_dc; 
	
	// search ====
	private String txtSearch;
	private String selectOrgName;
	private String selectOrgUpperCode;
	private String keyWord;

	private int hmProgrmUpdtListInfoCurrentPage;
	
	
	
	// insert ====
	private int ppa_seq;
	private String ppa_org_seq;
	private String ppa_pcm_seq;
	
	private String[] orgNmCheckedList;
	private String progrmCheckedList;
	private String[] orgpcmseq;	
	private String pcm_name;
	public int getPu_seq() {
		return pu_seq;
	}
	public void setPu_seq(int pu_seq) {
		this.pu_seq = pu_seq;
	}
	public String getPu_name() {
		return pu_name;
	}
	public void setPu_name(String pu_name) {
		this.pu_name = pu_name;
	}
	public String getPu_status() {
		return pu_status;
	}
	public void setPu_status(String pu_status) {
		this.pu_status = pu_status;
	}
	public String getPu_dc() {
		return pu_dc;
	}
	public void setPu_dc(String pu_dc) {
		this.pu_dc = pu_dc;
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
	public String getSelectOrgUpperCode() {
		return selectOrgUpperCode;
	}
	public void setSelectOrgUpperCode(String selectOrgUpperCode) {
		this.selectOrgUpperCode = selectOrgUpperCode;
	}
	public String getKeyWord() {
		return keyWord;
	}
	public void setKeyWord(String keyWord) {
		this.keyWord = keyWord;
	}
	public int getHmProgrmUpdtListInfoCurrentPage() {
		return hmProgrmUpdtListInfoCurrentPage;
	}
	public void setHmProgrmUpdtListInfoCurrentPage(int hmProgrmUpdtListInfoCurrentPage) {
		this.hmProgrmUpdtListInfoCurrentPage = hmProgrmUpdtListInfoCurrentPage;
	}
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
	public String[] getOrgNmCheckedList() {
		return orgNmCheckedList;
	}
	public void setOrgNmCheckedList(String[] orgNmCheckedList) {
		this.orgNmCheckedList = orgNmCheckedList;
	}
	public String getProgrmCheckedList() {
		return progrmCheckedList;
	}
	public void setProgrmCheckedList(String progrmCheckedList) {
		this.progrmCheckedList = progrmCheckedList;
	}
	public String[] getOrgpcmseq() {
		return orgpcmseq;
	}
	public void setOrgpcmseq(String[] orgpcmseq) {
		this.orgpcmseq = orgpcmseq;
	}
	public String getPcm_name() {
		return pcm_name;
	}
	public void setPcm_name(String pcm_name) {
		this.pcm_name = pcm_name;
	}	
}
