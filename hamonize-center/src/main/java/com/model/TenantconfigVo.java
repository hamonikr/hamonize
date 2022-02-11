package com.model;

import java.sql.Timestamp;

import javax.persistence.Id;
import javax.validation.constraints.Size;

import org.hibernate.annotations.Comment;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class TenantconfigVo {

	private Long seq;
	@Id
	@Size(max=50)
	@Comment("")
	private String domain;
	private Integer tenant_file_seq;
	private String tenant_hadmin_config;
	private Integer tenant_polling_time;
	private String tenant_authkey;	
	private Timestamp rgstr_date;
	private Timestamp updt_date;
	
}