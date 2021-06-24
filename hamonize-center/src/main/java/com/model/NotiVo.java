package com.model;




public class NotiVo {

	private int noti_seq;
	private String noti_title;
	private String noti_contents;
	private String noti_writer_id;
	private String noti_group;
	private String noti_rank;
	private Integer noti_orgcode;
	private Integer noti_orguppercode;
	private String first_date;
	private String last_date;
	private int hit;
	
	
	public int getNoti_seq() {
		return noti_seq;
	}
	public void setNoti_seq(int noti_seq) {
		this.noti_seq = noti_seq;
	}
	public String getNoti_title() {
		return noti_title;
	}
	public void setNoti_title(String noti_title) {
		this.noti_title = noti_title;
	}
	public String getNoti_contents() {
		return noti_contents;
	}
	public void setNoti_contents(String noti_contents) {
		this.noti_contents = noti_contents;
	}
	public String getNoti_writer_id() {
		return noti_writer_id;
	}
	public void setNoti_writer_id(String noti_writer_id) {
		this.noti_writer_id = noti_writer_id;
	}
	public String getNoti_group() {
		return noti_group;
	}
	public void setNoti_group(String noti_group) {
		this.noti_group = noti_group;
	}
	public String getNoti_rank() {
		return noti_rank;
	}
	public void setNoti_rank(String noti_rank) {
		this.noti_rank = noti_rank;
	}
	public Integer getNoti_orgcode() {
		return noti_orgcode;
	}
	public void setNoti_orgcode(Integer noti_orgcode) {
		this.noti_orgcode = noti_orgcode;
	}
	public Integer getNoti_orguppercode() {
		return noti_orguppercode;
	}
	public void setNoti_orguppercode(Integer noti_orguppercode) {
		this.noti_orguppercode = noti_orguppercode;
	}
	public String getFirst_date() {
		return first_date;
	}
	public void setFirst_date(String first_date) {
		this.first_date = first_date;
	}
	public String getLast_date() {
		return last_date;
	}
	public void setLast_date(String last_date) {
		this.last_date = last_date;
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
	public String getOrgname() {
		return orgname;
	}
	public void setOrgname(String orgname) {
		this.orgname = orgname;
	}
	public String getOrguppername() {
		return orguppername;
	}
	public void setOrguppername(String orguppername) {
		this.orguppername = orguppername;
	}
	public String getOrgname_upcode() {
		return orgname_upcode;
	}
	public void setOrgname_upcode(String orgname_upcode) {
		this.orgname_upcode = orgname_upcode;
	}
	
	
	public String getRankSelect() {
		return rankSelect;
	}
	public void setRankSelect(String rankSelect) {
		this.rankSelect = rankSelect;
	}
	public String getNotiSelect() {
		return notiSelect;
	}
	public void setNotiSelect(String notiSelect) {
		this.notiSelect = notiSelect;
	}
	public String getGroupSelect() {
		return groupSelect;
	}
	public void setGroupSelect(String groupSelect) {
		this.groupSelect = groupSelect;
	}
	


	public int getHit() {
		return hit;
	}
	public void setHit(int hit) {
		this.hit = hit;
	}



	// search ====
	private String txtSearch;
	private String keyWord;

	private int mngeListInfoCurrentPage;
	
	//	writer] orgname, orgname_value
	private String orgname;
	private String orguppername;
	private String orgname_upcode;
	
	private String rankSelect;
	private String notiSelect;
	private String groupSelect;

}