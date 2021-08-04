package com.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class AllowIpInfoVo {
	// tbl_allow_ip_inof
	private int sma_seq;
	private String sma_ipaddress;
	private String sma_macaddress;
	private String sma_info;
	private String sma_insert_dt;
	private String sma_update_dt;
	private String sma_gubun;
	
	// search ====
	private String txtSearch;
	private String keyWord;

	private int mngeListInfoCurrentPage;
	
	// insert
	private String ipaddress;
	private String macaddress;
	private String infomation;
	
	// delete
	private String[] deleteAdressList;

	
}
