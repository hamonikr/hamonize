package com.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class PolicyUpdtVo {
	
	//정책확정Insert
	private Integer seq;
	private Integer org_seq;
	private String ppm_seq;
	
	//프로그램관리list
	private int pu_seq;
	private String pu_name;
	private String pu_status;
	private String pu_dc;
	private String deb_new_version;
	private String deb_now_version;
		
}
