package com.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
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
	private String pcname;
	private Integer org_seq;
	private Integer move_org_seq;
	private Integer old_org_seq;
	private String org_nm;
	private String move_org_nm;
	private String[] updateBlockList;
	private String[] updateUnblockList;

	private String public_ip;

	
	// search ====
	private String txtSearch;
	private String keyWord;
	private Integer selectOrgSeq;
	private int pcListInfoCurrentPage;
	private String date_fr;
	private String date_to;

	// 사용자 정보
	private String sabun; // 사번
	private String username; // 사용자이름
	


}