package com.model;

import com.paging.PagingVo;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
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
	
	//부서 관리자
	private String manager_yn;
	private String position;
	
	//pc정보
	//private int sgb _seq;  // 미사용
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
	private String maxSgbPcCntByorgSeq;

	private String old_pc_ip;
	private String old_pc_vpnip;
	private String old_pc_macaddr;
	
	private int seq;
	private String sttus;

	private int ListInfoCurrentPage;
	private int pc_count;
	

}