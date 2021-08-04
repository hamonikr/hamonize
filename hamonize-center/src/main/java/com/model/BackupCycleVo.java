package com.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class BackupCycleVo {
	private int bac_seq;
	private String bac_org_seq;
	private String bac_cycle_option;
	private String bac_cycle_time;
	private String bac_gubun;
	
	private String selectOrgName;
	private String selectOrgUpperCode;
	
	private String[] orgNmCheckedList;
	private String progrmCheckedList;
	
	// insert
	private String backupGubun;
	private String backupOption;
	private String backupTime;
	
}
