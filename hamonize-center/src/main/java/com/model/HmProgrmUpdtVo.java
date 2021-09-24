package com.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class HmProgrmUpdtVo {
	private int pu_seq;
	private String pu_name;
	private String pu_status; 
	private String pu_dc; 
	private String deb_new_version; 
	private int polling_tm;
	
	// search ====
	private String txtSearch;
	private String selectOrgName;
	private String selectOrgUpperCode;
	private String keyWord;

	private int hmProgrmUpdtListInfoCurrentPage;
	
	
	
	// insert ====
	private int ppa_seq;
	private String ppa_org_seq;
	private String ppa_pcm_seq;
	
	private String[] orgNmCheckedList;
	private String progrmCheckedList;
	private String[] orgpcmseq;	
	private String pcm_name;

}
