package com.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class GetAgentJobVo {
	 
	
	private String domain;
	// == new vo val
	private String pc_uuid;
	private Long seq;
	private int p_seq;
	private String org_nm;
	private int dept_seq;
	
	
	
	// == agentjob
	private int aj_seq;
	private String aj_table_seq;
	private String insert_dt;
	private String aj_return_val;
	private String aj_table_gubun;
	

	// == tbl progrm policy applc
	private String ppa_pcm_seq;
	private String pcm_name;
	
	// == pc uuid 
	private Long org_seq;
	private String orgcode;
	private String upper_org_code;
	private String upper_org_name;
	private String uuid_orgname;
	private String upper_org_seq;
	private String uuid;
	
	// == t_backup recovery mngr 
	private String br_org_seq;
	private String br_backup_path; 
	private String br_backup_iso_dt; 
	private String br_backup_gubun;
	


}
