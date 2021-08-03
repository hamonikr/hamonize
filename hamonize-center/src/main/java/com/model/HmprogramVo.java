package com.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class HmprogramVo {
	private int pcm_seq;
	private String pcm_name;
	private String pcm_status;
	private String pcm_dc;
	
	// search ====
	private String txtSearch;
	private String selectOrgName;
	private String selectOrgUpperCode;
	private String keyWord;

	private int hmProgramListInfoCurrentPage;
	
	
	
	// insert ====
	private int ppa_seq;
	private String ppa_org_seq;
	private String ppa_pcm_seq;
	
	private String[] orgNmCheckedList;
	private String[] orgpcmseq;
	private String progrmCheckedList;

	// ===== 
	private String pcm_seq_str;
	private String org_seq;

	
}
