package com.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ActAgentProgrmVo {

	private int orgseq;
	private String datetime;
	private String uuid;
	private String hostname;
	private String status_yn;
	private String status;
	private String progrmname;

}