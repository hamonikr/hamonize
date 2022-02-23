package com.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@ToString
@Getter
@Setter
public class ActAgentBackupRecoveryVo {
	
	
	private String domain;
	
	private Long org_seq;
	private String datetime;
	private String uuid;
	private String hostname;
	private String action_status;
	private String result;

}