package com.model;

import java.io.Serializable;
import java.io.UnsupportedEncodingException;
import java.util.Map;


public class LoginVO implements Serializable{

	private static final long serialVersionUID = -6614488379179856787L;

	/** cookie info*/
	private Map<String, String> sso_user;
	
	/** 아이디 */
	private String user_id;
	private String user_name;
	private String pass_wd;
	private String dept_name;
	private String gubun;
	
	

	public String getUser_name() {
		return user_name;
	}
	public void setUser_name(String user_name) {
		this.user_name = user_name;
	}
	public String getPass_wd() {
		return pass_wd;
	}
	public void setPass_wd(String pass_wd) {
		this.pass_wd = pass_wd;
	}
	public String getDept_name() {
		return dept_name;
	}
	public void setDept_name(String dept_name) {
		this.dept_name = dept_name;
	}
	public String getGubun() {
		return gubun;
	}
	public void setGubun(String gubun) {
		this.gubun = gubun;
	}
	/** 이름 */
	private String user_nm;
	/** 회원사코드*/
	private String company_cd;
	/** 회원사코드*/
	private String korean_nm;
	/*?*/
	private String member_gb;
	/**/
	private String old_comcd;
	/** 사용자 권한 목록(사용자 권한이 "|"으로 구분된 String제공 예: G200010|I200030|I200070|I300014|I340000|I350010|I360060|....|) */
	private String role_ids;
	/** 파일컨트롤 아이디*/
	private String file_ctrl_id;
	/** 조회수 관련 아이디*/
	private String brd_hit_id;
	/** 회원레벨명*/
	private String grad_nm;
	/** 접속자 ip*/
	private String user_ip;
	/** 실명인증 CI*/
	private String ci;
	private String grade;
	private String login_date;
	private String conn_gubun;
	private int loginKey;
	private String curr_date;
	
	/** 이메일*/
	private String user_email;
	/** 전화번호*/
	private String user_tel;
	/** 부서명*/
	private String user_dept_nm;
	/**부서코드*/
	private String abroad_code;
	
	public String getUser_id() {
		return user_id;
	}
	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}
	public String getUser_nm() {
		return user_nm;
	}
	public void setUser_nm(String user_nm) {
		this.user_nm = user_nm;
	}
	public String getCompany_cd() {
		return company_cd;
	}
	public void setCompany_cd(String company_cd) {
		this.company_cd = company_cd;
	}
	public String getKorean_nm() {
		return korean_nm;
	}
	public void setKorean_nm(String korean_nm) {
		this.korean_nm = korean_nm;
	}
	public String getMember_gb() {
		return member_gb;
	}
	public void setMember_gb(String member_gb) {
		this.member_gb = member_gb;
	}
	public String getOld_comcd() {
		return old_comcd;
	}
	public void setOld_comcd(String old_comcd) {
		this.old_comcd = old_comcd;
	}

	/*
	 * public String getRole_ids() { return (role_ids==null ||
	 * role_ids.equals(""))?Globals.EVERYONE:role_ids; }
	 */
	public void setRole_ids(String role_ids) {
		this.role_ids = role_ids;
	}
	public String getFile_ctrl_id() {
		return file_ctrl_id;
	}
	public void setFile_ctrl_id(String file_ctrl_id) {
		this.file_ctrl_id = file_ctrl_id;
	}
	public String getBrd_hit_id() {
		return brd_hit_id;
	}
	public void setBrd_hit_id(String brd_hit_id) {
		this.brd_hit_id = brd_hit_id;
	}
	public String getGrad_nm() {
		return grad_nm;
	}
	public void setGrad_nm(String grad_nm) {
		this.grad_nm = grad_nm;
	}

	public void setSso_user(LoginVO uservo) throws UnsupportedEncodingException{

		user_id = uservo.getUser_id();
		user_nm = uservo.getUser_nm();
		member_gb = uservo.getGrade();
		grad_nm = uservo.getGrad_nm();
		role_ids = uservo.getGrade();
				
	}
	public String getUser_ip() {
		return user_ip;
	}
	public void setUser_ip(String user_ip) {
		this.user_ip = user_ip;
	}
	public String getCi() {
		return ci;
	}
	public void setCi(String ci) {
		this.ci = ci;
	}
	public String getGrade() {
		return grade;
	}
	public void setGrade(String grade) {
		this.grade = grade;
	}
	public String getLogin_date() {
		return login_date;
	}
	public void setLogin_date(String login_date) {
		this.login_date = login_date;
	}
	public String getConn_gubun() {
		return conn_gubun;
	}
	public void setConn_gubun(String conn_gubun) {
		this.conn_gubun = conn_gubun;
	}
	public int getLoginKey() {
		return loginKey;
	}
	public void setLoginKey(int loginKey) {
		this.loginKey = loginKey;
	}
	public String getCurr_date() {
		return curr_date;
	}
	public void setCurr_date(String curr_date) {
		this.curr_date = curr_date;
	}
	public String getUser_email() {
		return user_email;
	}
	public void setUser_email(String user_email) {
		this.user_email = user_email;
	}
	public String getUser_tel() {
		return user_tel;
	}
	public void setUser_tel(String user_tel) {
		this.user_tel = user_tel;
	}
	public String getUser_dept_nm() {
		return user_dept_nm;
	}
	public void setUser_dept_nm(String user_dept_nm) {
		this.user_dept_nm = user_dept_nm;
	}
	public String getAbroad_code() {
		return abroad_code;
	}
	public void setAbroad_code(String abroad_code) {
		this.abroad_code = abroad_code;
	}

}
