package com.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class VersionChkVo {

	private String datetime;
	private String uuid;
	private String hostname;
	private String pcmngr;
	private String agent;
	private String browser;
	
}