package com.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class BlockingNxssInfoVo {
	// tbl_allow_ip_inof
	private int seq;
	private String domain;
	private String info;
	private String inst_dt;
	private String upd_dt;
	private String gubun;
	
	// search ====
	private String txtSearch;
	private String keyWord;

	private int mngeListInfoCurrentPage;
	
	// insert
	private String blockingAddress;
	private String infomation;
	
	// delete
	private String[] deleteAdressList;
	
	// forward domain
	private String forwardDomain;
	private String forwardNotice;

	
}
