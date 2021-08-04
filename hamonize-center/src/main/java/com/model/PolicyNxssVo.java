package com.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class PolicyNxssVo {
	
	//정책확정Insert
	private Integer seq;
	private Integer org_seq;
	private String ppm_seq;
	
	//프로그램관리list
	private int pcm_seq;
	private String pcm_name;
	private String pcm_status;
	private String pcm_dc;

	
}
