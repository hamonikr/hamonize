package com.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class GetAgentBackupVo {

	private int bac_seq;
	private int org_seq;
	private String bac_cycle_option; 
	private String bac_cycle_time; 
	private String bac_gubun;
	private String pcm_uuid;
	

	
}
