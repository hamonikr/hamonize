package com.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class UnauthorizedVo{
	
	private  int seq;
	private  int org_seq;
	private String pc_uuid; 
	private String vendor;
	private String product; 
	private String info;
	private String pc_user;
	private String insert_dt;
	
	
}
