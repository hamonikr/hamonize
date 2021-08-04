package com.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class InetLogVo{
	
	private  int inet_seq;
	private String user_id;
	private String pc_ip;
	private String cnnc_url;
	private String pc_uuid;
	private String hostname;
	private String state;
	private String reg_dt;

	
}
