package com.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ActAgentFirewallVo {

	private String datetime;
	private String uuid;
	private String hostname;
	private String status;
	private String status_yn;
	private String retport;
	private Long orgseq;

}