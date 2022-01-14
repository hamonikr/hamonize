package com.model;

import java.io.Serializable;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class LoginVO implements Serializable {

	private static final long serialVersionUID = -6614488379179856787L;

	private String domain;

	/** 아이디 */
	private String user_id;
	private String user_name;
	private String pass_wd;
	private String dept_name;
	private String status;

	private String salt;
	private String user_ip;
	private int loginKey;

}
