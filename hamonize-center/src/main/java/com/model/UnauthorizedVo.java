package com.model;

import java.sql.Timestamp;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class UnauthorizedVo{
	
	private Long seq;
	private Long org_seq;
	private String pc_uuid; 
	private String vendor;
	private String product; 
	private String info;
	private String pc_hostname;
	private String pc_user;
	private Timestamp rgstr_date;
	
	
}
