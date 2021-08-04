package com.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class hamonizeVersionChkVo{
	
	private Integer debseq;
	private String debname;
	private String debversion;
	private String debstatus;
	private String pcuuid;
	private String insert_dt;
}
