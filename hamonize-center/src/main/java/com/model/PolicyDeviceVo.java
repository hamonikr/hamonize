package com.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class PolicyDeviceVo {
	
	//정책확정Insert
	private Integer seq;
	private Integer org_seq;
	private String ppm_seq;
	
	//프로그램관리list
	private int sm_seq;
	private String sm_name;
	private String sm_status;
	private String sm_dc;
	private String sm_port;
	private String sm_gubun;
	private String sm_device_code;
	
	private int mngeListInfoCurrentPage;
	private String[] deleteList;
	
	
}
