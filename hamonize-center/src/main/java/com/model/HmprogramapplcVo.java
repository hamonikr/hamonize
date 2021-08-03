package com.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class HmprogramapplcVo {

	private int ppa_seq;
	private String ppa_org_seq;
	private String ppa_pcm_seq;

	// search ====
	private String txtSearch;
	private String selectOrgName;
	private String keyWord;
	
}
