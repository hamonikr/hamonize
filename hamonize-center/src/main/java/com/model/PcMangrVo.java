package com.model;


import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.IdClass;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.validation.constraints.Size;

import com.id.PcMangrId;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@Entity
@IdClass(PcMangrId.class)
@Table(name="tbl_pc_mangr")
public class PcMangrVo {
	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	private Long seq;
	@Id
	private String domain;
	@Transient
	private int dept_seq;
	@Size(max=100)
	private String pc_status;
	@Size(max=100)
	private String pc_cpu;
	@Size(max=100)
	private String pc_cpu_id;
	@Size(max=100)
	private String pc_memory;
	@Size(max=100)
	private String pc_disk;
	@Size(max=100)
	private String pc_disk_id;
	@Size(max=100)
	private String pc_macaddress;
	@Size(max=100)
	private String pc_ip;
	@Size(max=100)
	private String pc_vpnip;
	@Size(max=300)
	private String pc_hostname;
	@Size(max=100)
	private String pc_guid;
	@Size(max=100)
	private String pc_uuid;
	@Size(max=50)
	private String pc_os;
	@Size(max=10)
	private String pc_change;
	@Transient
	private String cpu_info;
	@Transient
	private String ram_info;
	@Transient
	private String hdd_info;
	@Transient
	private String mboard_info;
	@Transient
	private String etc_info;
	@Transient
	private String status;
	@Transient
	private String maxPcCntByorgSeq;
	@Transient
	private String old_pc_ip;
	@Transient
	private String old_pc_vpnip;
	@Transient
	private String old_pc_macaddr;
	@Transient
	private String sttus;
	@Transient
	private String org_dept_room_name;
	
	private String rgstr_date;
	private String updt_date;
	@Transient
	private String deptname;
	@Transient
	private String alldeptname;
	@Transient
	private String deptsido;
	@Transient
	private String pcname;
	private Long org_seq;
	@Transient
	private Long move_org_seq;
	@Transient
	private Long old_org_seq;
	@Transient
	private String org_nm;
	@Transient
	private String move_org_nm;
	@Transient
	private String[] updateBlockList;
	@Transient
	private String[] updateUnblockList;
	@Transient
	private String public_ip;

	
	// search ====
	@Transient
	private String txtSearch;
	@Transient
	private String keyWord;
	@Transient
	private Integer selectOrgSeq;
	@Transient
	private int pcListInfoCurrentPage;
	@Transient
	private String date_fr;
	@Transient
	private String date_to;

	// 사용자 정보
	@Transient
	private String sabun; // 사번
	@Transient
	private String username; // 사용자이름
	


}