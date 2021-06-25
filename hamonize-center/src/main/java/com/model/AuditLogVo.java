package com.model;

public class AuditLogVo {
	
	private Integer org_seq;

	// search ====
	private String txtSearch;	
	private String keyWord;
	private Integer selectOrgSeq;
	private int currentPage;
	private String date_fr;
	private String date_to;
	
	//사용자로그
	private Integer idx;
	private Integer sidx;
	private String user_gunbun;
	private String user_id;
	private String user_name;
	private String login_dt;
	private String logout_dt;
	private String spent_time;
	private String rank;
	private String sgb_pc_hostname;
	private String join_org_nm;
	
	//인터넷 사용기록
	private String pc_ip;
	private String cnnc_url;
	private String pc_uuid;
	private String hostname;
	private String state;
	private String reg_dt;
	private String txtSearch0;
	private String txtSearch1;
	private String txtSearch2;
	private String txtSearch3;
	private String txtSearch4;
	private String txtSearch5;
	
	//pc 하드웨어변경정보
	private String pc_cpu;
	private String pc_memory;
	private String pc_disk;
	private String pc_macaddress;
	private String pc_hostname;
	private String pc_disk_id;
	private String pc_cpu_id;
	private String insert_dt;
	
	//비인가 디바이스 접속 기록
	private String vendor;
	private String product;
	private String info;
	private String pc_user;
	private String org_nm;
	
	//프로세스차단 기록
	private String prcssname;
	private String ipaddr;

	
	
	
	public String getDate_fr() {
		return date_fr;
	}
	public void setDate_fr(String date_fr) {
		this.date_fr = date_fr;
	}
	public String getDate_to() {
		return date_to;
	}
	public void setDate_to(String date_to) {
		this.date_to = date_to;
	}
	public Integer getOrg_seq() {
		return org_seq;
	}
	public void setOrg_seq(Integer org_seq) {
		this.org_seq = org_seq;
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
	public Integer getSelectOrgSeq() {
		return selectOrgSeq;
	}
	public void setSelectOrgSeq(Integer selectOrgSeq) {
		this.selectOrgSeq = selectOrgSeq;
	}
	public int getCurrentPage() {
		return currentPage;
	}
	public void setCurrentPage(int currentPage) {
		this.currentPage = currentPage;
	}
	public Integer getIdx() {
		return idx;
	}
	public void setIdx(Integer idx) {
		this.idx = idx;
	}
	public Integer getSidx() {
		return sidx;
	}
	public void setSidx(Integer sidx) {
		this.sidx = sidx;
	}
	public String getUser_gunbun() {
		return user_gunbun;
	}
	public void setUser_gubun(String user_gunbun) {
		this.user_gunbun = user_gunbun;
	}
	public String getUser_id() {
		return user_id;
	}
	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}
	public String getUser_name() {
		return user_name;
	}
	public void setUser_name(String user_name) {
		this.user_name = user_name;
	}
	public String getLogin_dt() {
		return login_dt;
	}
	public void setLogin_dt(String login_dt) {
		this.login_dt = login_dt;
	}
	public String getLogout_dt() {
		return logout_dt;
	}
	public void setLogput_dt(String logout_dt) {
		this.logout_dt = logout_dt;
	}
	public String getSpent_time() {
		return spent_time;
	}
	public void setSpent_time(String spent_time) {
		this.spent_time = spent_time;
	}
	public String getRank() {
		return rank;
	}
	public void setRank(String rank) {
		this.rank = rank;
	}
	public String getSgb_pc_hostname() {
		return sgb_pc_hostname;
	}
	public void setSgb_pc_hostname(String sgb_pc_hostname) {
		this.sgb_pc_hostname = sgb_pc_hostname;
	}
	
	
	
	
	public String getPc_ip() {
		return pc_ip;
	}
	public void setPc_ip(String pc_ip) {
		this.pc_ip = pc_ip;
	}
	public String getCnnc_url() {
		return cnnc_url;
	}
	public void setCnnc_url(String cnnc_url) {
		this.cnnc_url = cnnc_url;
	}
	public String getPc_uuid() {
		return pc_uuid;
	}
	public void setPc_uuid(String pc_uuid) {
		this.pc_uuid = pc_uuid;
	}
	public String getHostname() {
		return hostname;
	}
	public void setHostname(String hostname) {
		this.hostname = hostname;
	}
	public String getState() {
		return state;
	}
	public void setState(String state) {
		this.state = state;
	}
	public String getReg_dt() {
		return reg_dt;
	}
	public void setReg_dt(String reg_dt) {
		this.reg_dt = reg_dt;
	}
	public void setUser_gunbun(String user_gunbun) {
		this.user_gunbun = user_gunbun;
	}
	public void setLogout_dt(String logout_dt) {
		this.logout_dt = logout_dt;
	}
	
	
	
	public String getPc_cpu() {
		return pc_cpu;
	}
	public void setPc_cpu(String pc_cpu) {
		this.pc_cpu = pc_cpu;
	}
	public String getPc_memory() {
		return pc_memory;
	}
	public void setPc_memory(String pc_memory) {
		this.pc_memory = pc_memory;
	}
	public String getPc_disk() {
		return pc_disk;
	}
	public void setPc_disk(String pc_disk) {
		this.pc_disk = pc_disk;
	}
	public String getPc_macaddress() {
		return pc_macaddress;
	}
	public void setPc_macaddress(String pc_macaddress) {
		this.pc_macaddress = pc_macaddress;
	}
	public String getPc_hostname() {
		return pc_hostname;
	}
	public void setPc_hostname(String pc_hostname) {
		this.pc_hostname = pc_hostname;
	}
	public String getPc_disk_id() {
		return pc_disk_id;
	}
	public void setPc_disk_id(String pc_disk_id) {
		this.pc_disk_id = pc_disk_id;
	}
	public String getPc_cpu_id() {
		return pc_cpu_id;
	}
	public void setPc_cpu_id(String pc_cpu_id) {
		this.pc_cpu_id = pc_cpu_id;
	}
	public String getInsert_dt() {
		return insert_dt;
	}
	public void setInsert_dt(String insert_dt) {
		this.insert_dt = insert_dt;
	}
	
	
	
	public String getVendor() {
		return vendor;
	}
	public void setVendor(String vendor) {
		this.vendor = vendor;
	}
	public String getProduct() {
		return product;
	}
	public void setProduct(String product) {
		this.product = product;
	}
	public String getInfo() {
		return info;
	}
	public void setInfo(String info) {
		this.info = info;
	}
	public String getPc_user() {
		return pc_user;
	}
	public void setPc_user(String pc_user) {
		this.pc_user = pc_user;
	}
	public String getOrg_nm() {
		return org_nm;
	}
	public void setOrg_nm(String org_nm) {
		this.org_nm = org_nm;
	}
	public String getJoin_org_nm() {
		return join_org_nm;
	}
	public void setJoin_org_nm(String join_org_nm) {
		this.join_org_nm = join_org_nm;
	}
	public String getPrcssname() {
		return prcssname;
	}
	public void setPrcssname(String prcssname) {
		this.prcssname = prcssname;
	}
	public String getIpaddr() {
		return ipaddr;
	}
	public void setIpaddr(String ipaddr) {
		this.ipaddr = ipaddr;
	}
	public String getTxtSearch0() {
		return txtSearch0;
	}
	public void setTxtSearch0(String txtSearch0) {
		this.txtSearch0 = txtSearch0;
	}
	public String getTxtSearch1() {
		return txtSearch1;
	}
	public void setTxtSearch1(String txtSearch1) {
		this.txtSearch1 = txtSearch1;
	}
	public String getTxtSearch2() {
		return txtSearch2;
	}
	public void setTxtSearch2(String txtSearch2) {
		this.txtSearch2 = txtSearch2;
	}
	public String getTxtSearch3() {
		return txtSearch3;
	}
	public void setTxtSearch3(String txtSearch3) {
		this.txtSearch3 = txtSearch3;
	}
	public String getTxtSearch4() {
		return txtSearch4;
	}
	public void setTxtSearch4(String txtSearch4) {
		this.txtSearch4 = txtSearch4;
	}
	public String getTxtSearch5() {
		return txtSearch5;
	}
	public void setTxtSearch5(String txtSearch5) {
		this.txtSearch5 = txtSearch5;
	}
	
	
	
	
	
	
	
	
	
	

}
