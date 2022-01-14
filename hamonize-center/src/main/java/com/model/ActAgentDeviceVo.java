package com.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ActAgentDeviceVo {

	private Long org_seq;
	private String datetime;
	private String uuid;
	private String hostname;
	private String status_yn;
	private String product;
	private String vendorCode;
	private String productCode;

}