package com.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
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
	private String vendorcode;
	private String productcode;

	private String product;
	private String info;
	private String pc_user;
	private String org_nm;
	private String ins_date;
	private String status_yn;
	
	//프로세스차단 기록
	private String prcssname;
	private String ipaddress;

	
	

}
