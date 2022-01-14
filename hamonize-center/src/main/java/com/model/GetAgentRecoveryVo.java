package com.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class GetAgentRecoveryVo {

	private int seq;
	private Long org_seq;
	private int pc_seq;
	private int br_seq;
	private int recv_applc_seq;
	private String br_backup_gubun;
	private String br_backup_name;
	private String br_backup_path;
	private String insert_dt;
	private String pc_uuid;
	private String status;
	
	
	
}
