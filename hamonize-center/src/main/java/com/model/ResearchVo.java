package com.model;

import com.paging.PagingVo;

public class ResearchVo extends PagingVo{

	private Integer idx;
	private String user_gunbun;
	private String user_id;
	private String pass_wd;
	private String user_name;
	private String insert_dt;
	private String update_dt;
	private String kind;
	private String rank;
	private String discharge_dt;
	private Integer org_seq; 
	private String narasarang_no; 
	private String org_nm; 
	private String P_org_nm; 

	// search ====
	private String txtSearch;
	private String selectOrgName;
	private String keyWord;
	private String date_fr;
	private String date_to;
	
	//사지방 관리자
	private String manager_yn;
	private String position;
	
	//pc정보
	private int sgb_seq;
	private String sgb_pc_status;
	private String sgb_pc_cpu;
	private String sgb_pc_cpu_id;
	private String sgb_pc_memory;
	private String sgb_pc_disk;
	private String sgb_pc_disk_id;
	private String sgb_pc_macaddress;
	private String sgb_pc_ip;
	private String sgb_pc_vpnip;
	private String sgb_pc_hostname;
	private String sgb_pc_guid;
	private String sgb_pc_uuid;
	private String sgb_pc_os;
	private String pc_change;
	private String cpu_info;
	private String ram_info;
	private String hdd_info;
	private String mboard_info;
	private String etc_info;
	private String status;
	private String maxSgbPcCntByorgSeq;

	private String old_pc_ip;
	private String old_pc_vpnip;
	private String old_pc_macaddr;
	
	private int seq;
	private String sttus;

	private int ListInfoCurrentPage;
	
	
	private int pc_count;
	
	

	
	public int getPc_count() {
		return pc_count;
	
	}

	
	public void setPc_count(int pc_count) {
		this.pc_count = pc_count;
	
	}

	public Integer getIdx() {
		return idx;
	}

	public void setIdx(Integer idx) {
		this.idx = idx;
	}

	

	public String getOrg_nm() {
		return org_nm;
	}

	public void setOrg_nm(String org_nm) {
		this.org_nm = org_nm;
	}

	public String getUser_gunbun() {
		return user_gunbun;
	}

	public void setUser_gunbun(String user_gunbun) {
		this.user_gunbun = user_gunbun;
	}

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

	public String getKind() {
		return kind;
	}

	public void setKind(String kind) {
		this.kind = kind;
	}

	public String getRank() {
		return rank;
	}

	public void setRank(String rank) {
		this.rank = rank;
	}

	public String getDischarge_dt() {
		return discharge_dt;
	}

	public void setDischarge_dt(String discharge_dt) {
		this.discharge_dt = discharge_dt;
	}

	public Integer getOrg_seq() {
		return org_seq;
	}

	public void setOrg_seq(Integer org_seq) {
		this.org_seq = org_seq;
	}

	public String getNarasarang_no() {
		return narasarang_no;
	}

	public void setNarasarang_no(String narasarang_no) {
		this.narasarang_no = narasarang_no;
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

	public String getPosition() {
		return position;
	}

	public void setPosition(String position) {
		this.position = position;
	}

	public String getP_org_nm() {
		return P_org_nm;
	}

	public void setP_org_nm(String p_org_nm) {
		P_org_nm = p_org_nm;
	}

	
	public int getSgb_seq() {
		return sgb_seq;
	
	}

	
	public void setSgb_seq(int sgb_seq) {
		this.sgb_seq = sgb_seq;
	
	}

	
	public String getSgb_pc_status() {
		return sgb_pc_status;
	
	}

	
	public void setSgb_pc_status(String sgb_pc_status) {
		this.sgb_pc_status = sgb_pc_status;
	
	}

	
	public String getSgb_pc_cpu() {
		return sgb_pc_cpu;
	
	}

	
	public void setSgb_pc_cpu(String sgb_pc_cpu) {
		this.sgb_pc_cpu = sgb_pc_cpu;
	
	}

	
	public String getSgb_pc_cpu_id() {
		return sgb_pc_cpu_id;
	
	}

	
	public void setSgb_pc_cpu_id(String sgb_pc_cpu_id) {
		this.sgb_pc_cpu_id = sgb_pc_cpu_id;
	
	}

	
	public String getSgb_pc_memory() {
		return sgb_pc_memory;
	
	}

	
	public void setSgb_pc_memory(String sgb_pc_memory) {
		this.sgb_pc_memory = sgb_pc_memory;
	
	}

	
	public String getSgb_pc_disk() {
		return sgb_pc_disk;
	
	}

	
	public void setSgb_pc_disk(String sgb_pc_disk) {
		this.sgb_pc_disk = sgb_pc_disk;
	
	}

	
	public String getSgb_pc_disk_id() {
		return sgb_pc_disk_id;
	
	}

	
	public void setSgb_pc_disk_id(String sgb_pc_disk_id) {
		this.sgb_pc_disk_id = sgb_pc_disk_id;
	
	}

	
	public String getSgb_pc_macaddress() {
		return sgb_pc_macaddress;
	
	}

	
	public void setSgb_pc_macaddress(String sgb_pc_macaddress) {
		this.sgb_pc_macaddress = sgb_pc_macaddress;
	
	}

	
	public String getSgb_pc_ip() {
		return sgb_pc_ip;
	
	}

	
	public void setSgb_pc_ip(String sgb_pc_ip) {
		this.sgb_pc_ip = sgb_pc_ip;
	
	}

	
	public String getSgb_pc_vpnip() {
		return sgb_pc_vpnip;
	
	}

	
	public void setSgb_pc_vpnip(String sgb_pc_vpnip) {
		this.sgb_pc_vpnip = sgb_pc_vpnip;
	
	}

	
	public String getSgb_pc_hostname() {
		return sgb_pc_hostname;
	
	}

	
	public void setSgb_pc_hostname(String sgb_pc_hostname) {
		this.sgb_pc_hostname = sgb_pc_hostname;
	
	}

	
	public String getSgb_pc_guid() {
		return sgb_pc_guid;
	
	}

	
	public void setSgb_pc_guid(String sgb_pc_guid) {
		this.sgb_pc_guid = sgb_pc_guid;
	
	}

	
	public String getSgb_pc_uuid() {
		return sgb_pc_uuid;
	
	}

	
	public void setSgb_pc_uuid(String sgb_pc_uuid) {
		this.sgb_pc_uuid = sgb_pc_uuid;
	
	}

	
	public String getSgb_pc_os() {
		return sgb_pc_os;
	
	}

	
	public void setSgb_pc_os(String sgb_pc_os) {
		this.sgb_pc_os = sgb_pc_os;
	
	}

	
	public String getPc_change() {
		return pc_change;
	
	}

	
	public void setPc_change(String pc_change) {
		this.pc_change = pc_change;
	
	}

	
	public String getCpu_info() {
		return cpu_info;
	
	}

	
	public void setCpu_info(String cpu_info) {
		this.cpu_info = cpu_info;
	
	}

	
	public String getRam_info() {
		return ram_info;
	
	}

	
	public void setRam_info(String ram_info) {
		this.ram_info = ram_info;
	
	}

	
	public String getHdd_info() {
		return hdd_info;
	
	}

	
	public void setHdd_info(String hdd_info) {
		this.hdd_info = hdd_info;
	
	}

	
	public String getMboard_info() {
		return mboard_info;
	
	}

	
	public void setMboard_info(String mboard_info) {
		this.mboard_info = mboard_info;
	
	}

	
	public String getEtc_info() {
		return etc_info;
	
	}

	
	public void setEtc_info(String etc_info) {
		this.etc_info = etc_info;
	
	}

	
	public String getStatus() {
		return status;
	
	}

	
	public void setStatus(String status) {
		this.status = status;
	
	}

	
	public String getMaxSgbPcCntByorgSeq() {
		return maxSgbPcCntByorgSeq;
	
	}

	
	public void setMaxSgbPcCntByorgSeq(String maxSgbPcCntByorgSeq) {
		this.maxSgbPcCntByorgSeq = maxSgbPcCntByorgSeq;
	
	}

	
	public String getOld_pc_ip() {
		return old_pc_ip;
	
	}

	
	public void setOld_pc_ip(String old_pc_ip) {
		this.old_pc_ip = old_pc_ip;
	
	}

	
	public String getOld_pc_vpnip() {
		return old_pc_vpnip;
	
	}

	
	public void setOld_pc_vpnip(String old_pc_vpnip) {
		this.old_pc_vpnip = old_pc_vpnip;
	
	}

	
	public String getOld_pc_macaddr() {
		return old_pc_macaddr;
	
	}

	
	public void setOld_pc_macaddr(String old_pc_macaddr) {
		this.old_pc_macaddr = old_pc_macaddr;
	
	}

	
	public int getSeq() {
		return seq;
	
	}

	
	public void setSeq(int seq) {
		this.seq = seq;
	
	}

	
	public String getSttus() {
		return sttus;
	
	}

	
	public void setSttus(String sttus) {
		this.sttus = sttus;
	
	}
	
	

	

}