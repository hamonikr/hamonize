package com.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class SvrlstVo {

	private int seq;
	private String svr_nm;
	private String svr_domain;
	private String svr_ip;
	private String svr_port;
	private String svr_dc;
	private String insert_dt;

	// search ====
	private String txtSearch;
	private String keyWord;
	private String chkdel;
	
	private int svrlstInfoCurrentPage;

}
