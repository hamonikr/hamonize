package com.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class LogInOutVo {

	private String domain;
	private String uuid;
	private String login_dt;
	private String logout_dt;
	private String kind;
	private int seq;
	private Long org_seq;
	private Long job_id;

	//// json
	String datetime;
	String gubun;

}