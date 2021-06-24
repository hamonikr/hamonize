package com.model;

import java.util.Arrays;

public class PcMangrVo {

	private int dept_seq;
	private String pc_status;
	private String pc_cpu;
	private String pc_cpu_id;
	private String pc_memory;
	private String pc_disk;
	private String pc_disk_id;
	private String pc_macaddress;
	private String pc_ip;
	private String pc_vpnip;
	private String pc_hostname;
	private String pc_guid;
	private String pc_uuid;
	private String pc_os;
	private String pc_change;
	private String cpu_info;
	private String ram_info;
	private String hdd_info;
	private String mboard_info;
	private String etc_info;
	private String status;
	private String maxPcCntByorgSeq;

	private String old_pc_ip;
	private String old_pc_vpnip;
	private String old_pc_macaddr;
	
	private int seq;
	private String sttus;
	private String org_dept_room_name;
	
	private String first_date;
	private String last_date;
	private String deptname;
	private String alldeptname;
	private String deptsido;
	private String deptpcname;
	private Integer org_seq;
	private Integer move_org_seq;
	private String org_nm;
	private String move_org_nm;
	private String[] updateBlockList;
	private String[] updateUnblockList;

	
	// search ====
	private String txtSearch;
	private String keyWord;
	private Integer selectOrgSeq;
	private int pcListInfoCurrentPage;
	private String date_fr;
	private String date_to;

	@Override
	public String toString() {
		return "PcMangrVo [dept_seq=" + dept_seq + ", pc_status=" + pc_status + ", pc_cpu=" + pc_cpu
				+ ", pc_cpu_id=" + pc_cpu_id + ", pc_memory=" + pc_memory + ", pc_disk="
				+ pc_disk + ", pc_disk_id=" + pc_disk_id + ", pc_macaddress=" + pc_macaddress
				+ ", pc_ip=" + pc_ip + ", pc_vpnip=" + pc_vpnip + ", pc_hostname=" + pc_hostname
				+ ", pc_guid=" + pc_guid + ", pc_uuid=" + pc_uuid + ", pc_os=" + pc_os
				+ ", pc_change=" + pc_change + ", cpu_info=" + cpu_info + ", ram_info=" + ram_info + ", hdd_info="
				+ hdd_info + ", mboard_info=" + mboard_info + ", etc_info=" + etc_info + ", status=" + status
				+ ", maxPcCntByorgSeq=" + maxPcCntByorgSeq + ", old_pc_ip=" + old_pc_ip + ", old_pc_vpnip="
				+ old_pc_vpnip + ", old_pc_macaddr=" + old_pc_macaddr + ", seq=" + seq + ", sttus=" + sttus
				+ ", org_dept_room_name=" + org_dept_room_name + ", first_date="
				+ first_date + ", last_date=" + last_date + ", deptname=" + deptname + ", alldeptname=" + alldeptname
				+ ", deptsido=" + deptsido + ", deptpcname=" + deptpcname + ", org_seq=" + org_seq + ", move_org_seq="
				+ move_org_seq + ", org_nm=" + org_nm + ", move_org_nm=" + move_org_nm + ", updateBlockList="
				+ Arrays.toString(updateBlockList) + ", updateUnblockList=" + Arrays.toString(updateUnblockList)
				+ ", txtSearch=" + txtSearch + ", keyWord=" + keyWord + ", selectOrgSeq=" + selectOrgSeq
				+ ", pcListInfoCurrentPage=" + pcListInfoCurrentPage + ", date_fr=" + date_fr + ", date_to=" + date_to
				+ "]";
	}
	public int getDept_seq() {
		return dept_seq;
	}
	public String getDate_to() {
		return date_to;
	}
	public void setDate_to(String date_to) {
		this.date_to = date_to;
	}
	public String getDate_fr() {
		return date_fr;
	}
	public void setDate_fr(String date_fr) {
		this.date_fr = date_fr;
	}
	public int getPcListInfoCurrentPage() {
		return pcListInfoCurrentPage;
	}
	public void setPcListInfoCurrentPage(int pcListInfoCurrentPage) {
		this.pcListInfoCurrentPage = pcListInfoCurrentPage;
	}
	public Integer getSelectOrgSeq() {
		return selectOrgSeq;
	}
	public void setSelectOrgSeq(Integer selectOrgSeq) {
		this.selectOrgSeq = selectOrgSeq;
	}
	public String getKeyWord() {
		return keyWord;
	}
	public void setKeyWord(String keyWord) {
		this.keyWord = keyWord;
	}
	public String getTxtSearch() {
		return txtSearch;
	}
	public void setTxtSearch(String txtSearch) {
		this.txtSearch = txtSearch;
	}
	public String getDeptpcname() {
		return deptpcname;
	}
	public void setDeptpcname(String deptpcname) {
		this.deptpcname = deptpcname;
	}
	public String getDeptsido() {
		return deptsido;
	}
	public void setDeptsido(String deptsido) {
		this.deptsido = deptsido;
	}
	public String getDeptname() {
		return deptname;
	}
	public void setDeptname(String deptname) {
		this.deptname = deptname;
	}
	public String[] getUpdateUnblockList() {
		return updateUnblockList;
	}
	public void setUpdateUnblockList(String[] updateUnblockList) {
		this.updateUnblockList = updateUnblockList;
	}
	public String[] getUpdateBlockList() {
		return updateBlockList;
	}
	public void setUpdateBlockList(String[] updateBlockList) {
		this.updateBlockList = updateBlockList;
	}
	public String getMove_org_nm() {
		return move_org_nm;
	}
	public void setMove_org_nm(String move_org_nm) {
		this.move_org_nm = move_org_nm;
	}
	public String getOrg_nm() {
		return org_nm;
	}
	public void setOrg_nm(String org_nm) {
		this.org_nm = org_nm;
	}
	public Integer getMove_org_seq() {
		return move_org_seq;
	}
	public void setMove_org_seq(Integer move_org_seq) {
		this.move_org_seq = move_org_seq;
	}
	public Integer getOrg_seq() {
		return org_seq;
	}
	public void setOrg_seq(Integer org_seq) {
		this.org_seq = org_seq;
	}
	
	public String getAlldeptname() {
		return alldeptname;
	}
	public void setAlldeptname(String alldeptname) {
		this.alldeptname = alldeptname;
	}
	public String getLast_date() {
		return last_date;
	}
	public void setLast_date(String last_date) {
		this.last_date = last_date;
	}
	public String getFirst_date() {
		return first_date;
	}
	public void setFirst_date(String first_date) {
		this.first_date = first_date;
	}
	public String getOrg_dept_room_name() {
		return org_dept_room_name;
	}
	public void setOrg_dept_room_name(String org_dept_room_name) {
		this.org_dept_room_name = org_dept_room_name;
	}
	public String getSttus() {
		return sttus;
	}
	public void setSttus(String sttus) {
		this.sttus = sttus;
	}
	public String getMaxPcCntByorgSeq() {
		return maxPcCntByorgSeq;
	}
	public void setMaxPcCntByorgSeq(String maxPcCntByorgSeq) {
		this.maxPcCntByorgSeq = maxPcCntByorgSeq;
	}
	public int getSeq() {
		return seq;
	}
	public void setSeq(int seq) {
		this.seq = seq;
	}
	public String getOld_pc_macaddr() {
		return old_pc_macaddr;
	}
	public void setOld_pc_macaddr(String old_pc_macaddr) {
		this.old_pc_macaddr = old_pc_macaddr;
	}
	public String getOld_pc_vpnip() {
		return old_pc_vpnip;
	}
	public void setOld_pc_vpnip(String old_pc_vpnip) {
		this.old_pc_vpnip = old_pc_vpnip;
	}
	public String getOld_pc_ip() {
		return old_pc_ip;
	}
	public void setOld_pc_ip(String old_pc_ip) {
		this.old_pc_ip = old_pc_ip;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getEtc_info() {
		return etc_info;
	}
	public void setEtc_info(String etc_info) {
		this.etc_info = etc_info;
	}
	public String getMboard_info() {
		return mboard_info;
	}
	public void setMboard_info(String mboard_info) {
		this.mboard_info = mboard_info;
	}
	public String getCpu_info() {
		return cpu_info;
	}
	public void setCpu_info(String cpu_info) {
		this.cpu_info = cpu_info;
	}
	public String getHdd_info() {
		return hdd_info;
	}
	public void setHdd_info(String hdd_info) {
		this.hdd_info = hdd_info;
	}
	public String getRam_info() {
		return ram_info;
	}
	public void setRam_info(String ram_info) {
		this.ram_info = ram_info;
	}
	public String getPc_change() {
		return pc_change;
	}
	public void setPc_change(String pc_change) {
		this.pc_change = pc_change;
	}
	public String getPc_os() {
		return pc_os;
	}
	public void setPc_os(String pc_os) {
		this.pc_os = pc_os;
	}
	public String getPc_uuid() {
		return pc_uuid;
	}
	public void setPc_uuid(String pc_uuid) {
		this.pc_uuid = pc_uuid;
	}
	public String getPc_guid() {
		return pc_guid;
	}
	public void setPc_guid(String pc_guid) {
		this.pc_guid = pc_guid;
	}
	public String getPc_hostname() {
		return pc_hostname;
	}
	public void setPc_hostname(String pc_hostname) {
		this.pc_hostname = pc_hostname;
	}
	public String getPc_vpnip() {
		return pc_vpnip;
	}
	public void setPc_vpnip(String pc_vpnip) {
		this.pc_vpnip = pc_vpnip;
	}
	public String getPc_ip() {
		return pc_ip;
	}
	public void setPc_ip(String pc_ip) {
		this.pc_ip = pc_ip;
	}
	public String getPc_macaddress() {
		return pc_macaddress;
	}
	public void setPc_macaddress(String pc_macaddress) {
		this.pc_macaddress = pc_macaddress;
	}
	public String getPc_disk_id() {
		return pc_disk_id;
	}
	public void setPc_disk_id(String pc_disk_id) {
		this.pc_disk_id = pc_disk_id;
	}
	public String getPc_disk() {
		return pc_disk;
	}
	public void setPc_disk(String pc_disk) {
		this.pc_disk = pc_disk;
	}
	public String getPc_memory() {
		return pc_memory;
	}
	public void setPc_memory(String pc_memory) {
		this.pc_memory = pc_memory;
	}
	public String getPc_cpu_id() {
		return pc_cpu_id;
	}
	public void setPc_cpu_id(String pc_cpu_id) {
		this.pc_cpu_id = pc_cpu_id;
	}
	public String getPc_cpu() {
		return pc_cpu;
	}
	public void setPc_cpu(String pc_cpu) {
		this.pc_cpu = pc_cpu;
	}
	public String getPc_status() {
		return pc_status;
	}
	public void setPc_status(String pc_status) {
		this.pc_status = pc_status;
	}
	public void setDept_seq(int dept_seq) {
		this.dept_seq = dept_seq;
	}




}