package com.model;




public class HmSecurityVo {
	private int sm_seq;
	private String sm_name;
	private String sm_status; 
	private String sm_dc; 
	private String sm_port; 
	private String sm_gubun; 
	
	// search ====
	private String txtSearch;
	public int getSm_seq() {
		return sm_seq;
	}
	public void setSm_seq(int sm_seq) {
		this.sm_seq = sm_seq;
	}
	public String getSm_name() {
		return sm_name;
	}
	public void setSm_name(String sm_name) {
		this.sm_name = sm_name;
	}
	public String getSm_status() {
		return sm_status;
	}
	public void setSm_status(String sm_status) {
		this.sm_status = sm_status;
	}
	public String getSm_dc() {
		return sm_dc;
	}
	public void setSm_dc(String sm_dc) {
		this.sm_dc = sm_dc;
	}
	public String getSm_port() {
		return sm_port;
	}
	public void setSm_port(String sm_port) {
		this.sm_port = sm_port;
	}
	public String getSm_gubun() {
		return sm_gubun;
	}
	public void setSm_gubun(String sm_gubun) {
		this.sm_gubun = sm_gubun;
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
	public int getHmSecurityCurrentPage() {
		return hmSecurityCurrentPage;
	}
	public void setHmSecurityCurrentPage(int hmSecurityCurrentPage) {
		this.hmSecurityCurrentPage = hmSecurityCurrentPage;
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
	public int getPcm_seq() {
		return pcm_seq;
	}
	public void setPcm_seq(int pcm_seq) {
		this.pcm_seq = pcm_seq;
	}
	public String getPcm_status() {
		return pcm_status;
	}
	public void setPcm_status(String pcm_status) {
		this.pcm_status = pcm_status;
	}
	public String getOrg_seq() {
		return org_seq;
	}
	public void setOrg_seq(String org_seq) {
		this.org_seq = org_seq;
	}
	public int getSyseq() {
		return syseq;
	}
	public void setSyseq(int syseq) {
		this.syseq = syseq;
	}
	public String getSyname() {
		return syname;
	}
	public void setSyname(String syname) {
		this.syname = syname;
	}
	public String getSystatus() {
		return systatus;
	}
	public void setSystatus(String systatus) {
		this.systatus = systatus;
	}
	private String selectOrgName;
	private String selectOrgUpperCode;
	private String keyWord;

	private int hmSecurityCurrentPage;
	
	
	
	// insert ====
	private int ppa_seq;
	private String ppa_org_seq;
	private String ppa_pcm_seq;
	
	private String[] orgNmCheckedList;
	private String progrmCheckedList;
	private String[] orgpcmseq;
	
	private String pcm_name;
	private int pcm_seq;
	private String pcm_status;
	private String org_seq;

	// =====
	private int syseq;
	private String syname;
	private String systatus;

	
	
	
}
