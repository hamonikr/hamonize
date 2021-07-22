package com.model;

import java.util.Date;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class BackupVo {
	//공통
	private Integer bac_seq;
	private Integer org_seq;
	
	//백업주기 관리
	private String bac_cycle_option;
	private String bac_cycle_time;
	private String bac_gubun;
	
	//복구관리
	private Integer dept_seq;
	private String br_backup_path;
	private Date br_backup_iso_dt;
	private String br_backup_gubun;
	private String br_backup_name;
	

}
