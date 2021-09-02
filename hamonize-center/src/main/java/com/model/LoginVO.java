package com.model;

import java.io.Serializable;
import java.io.UnsupportedEncodingException;
import java.util.Map;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class LoginVO implements Serializable {

	private static final long serialVersionUID = -6614488379179856787L;

	/** cookie info */
	private Map<String, String> sso_user;

	/** 아이디 */
	private String user_id;
	private String user_name;
	private String pass_wd;
	private String dept_name;
	private String gubun;

	private String salt;



	/** 이름 */
	private String user_nm;
	/** 회원사코드 */
	private String company_cd;
	/** 회원사코드 */
	private String korean_nm;
	/* ? */
	private String member_gb;
	/**/
	private String old_comcd;

	private String role_ids;
	/** 파일컨트롤 아이디 */
	private String file_ctrl_id;
	/** 조회수 관련 아이디 */
	private String brd_hit_id;
	/** 회원레벨명 */
	private String grad_nm;
	/** 접속자 ip */
	private String user_ip;
	/** 실명인증 CI */
	private String ci;
	private String grade;
	private String login_date;
	private String conn_gubun;
	private int loginKey;
	private String curr_date;

	/** 이메일 */
	private String user_email;
	/** 전화번호 */
	private String user_tel;
	/** 부서명 */
	private String user_dept_nm;
	/** 부서코드 */
	private String abroad_code;


	public void setSso_user(LoginVO uservo) throws UnsupportedEncodingException {

		user_id = uservo.getUser_id();
		user_nm = uservo.getUser_nm();
		member_gb = uservo.getGrade();
		grad_nm = uservo.getGrad_nm();
		role_ids = uservo.getGrade();

	}

}
