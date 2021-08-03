package com.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class HmSecurityVo {
	private int sm_seq;
	private String sm_name;
	private String sm_status; 
	private String sm_dc; 
	private String sm_port; 
	private String sm_gubun; 
	
	// search ====
	private String txtSearch;

	private String selectOrgName;
	private String selectOrgUpperCode;
	private String keyWord;

	private int hmSecurityCurrentPage;


	// insert ====
	private int ppa_seq;
	private String ppa_org_seq;
	private String ppa_pcm_seq;
	
	private String[] orgNmCheckedList;
	private String progrmCheckedList;
	private String[] orgpcmseq;
	
	private String pcm_name;
	private int pcm_seq;
	private String pcm_status;
	private String org_seq;

	// =====
	private int syseq;
	private String syname;
	private String systatus;

	
	
	
}
