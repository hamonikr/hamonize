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
	private int seq;

	//// json
	String datetime;
	String gubun;

}