package com.model;




public class HmprogramVo {
	private int pcm_seq;
	private String pcm_name;
	private String pcm_status;
	private String pcm_dc;
	
	// search ====
	private String txtSearch;
	private String selectOrgName;
	private String selectOrgUpperCode;
	private String keyWord;

	private int hmProgramListInfoCurrentPage;
	
	
	
	// insert ====
	private int ppa_seq;
	private String ppa_org_seq;
	private String ppa_pcm_seq;
	
	private String[] orgNmCheckedList;
	private String[] orgpcmseq;
	private String progrmCheckedList;

	// ===== 
	private String pcm_seq_str;
	private String org_seq;
	public int getPcm_seq() {
		return pcm_seq;
	}
	public void setPcm_seq(int pcm_seq) {
		this.pcm_seq = pcm_seq;
	}
	public String getPcm_name() {
		return pcm_name;
	}
	public void setPcm_name(String pcm_name) {
		this.pcm_name = pcm_name;
	}
	public String getPcm_status() {
		return pcm_status;
	}
	public void setPcm_status(String pcm_status) {
		this.pcm_status = pcm_status;
	}
	public String getPcm_dc() {
		return pcm_dc;
	}
	public void setPcm_dc(String pcm_dc) {
		this.pcm_dc = pcm_dc;
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
	public int getHmProgramListInfoCurrentPage() {
		return hmProgramListInfoCurrentPage;
	}
	public void setHmProgramListInfoCurrentPage(int hmProgramListInfoCurrentPage) {
		this.hmProgramListInfoCurrentPage = hmProgramListInfoCurrentPage;
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
	public String[] getOrgpcmseq() {
		return orgpcmseq;
	}
	public void setOrgpcmseq(String[] orgpcmseq) {
		this.orgpcmseq = orgpcmseq;
	}
	public String getProgrmCheckedList() {
		return progrmCheckedList;
	}
	public void setProgrmCheckedList(String progrmCheckedList) {
		this.progrmCheckedList = progrmCheckedList;
	}
	public String getPcm_seq_str() {
		return pcm_seq_str;
	}
	public void setPcm_seq_str(String pcm_seq_str) {
		this.pcm_seq_str = pcm_seq_str;
	}
	public String getOrg_seq() {
		return org_seq;
	}
	public void setOrg_seq(String org_seq) {
		this.org_seq = org_seq;
	}
	
	
	
}
