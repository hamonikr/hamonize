package com.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class RecoveryVo {
	private int br_seq;
	private Long br_org_seq;
	private Long dept_seq; // pc seq num

	private String br_backup_path;
	private String br_backup_iso_dt;
	
	private String selectOrgName;
	private String selectOrgUpperCode;
	
	private String[] orgNmCheckedList;
	private String progrmCheckedList;
	
	// insert
	private String[] pcCheckedList;
	private String recoveryChecked;
}
