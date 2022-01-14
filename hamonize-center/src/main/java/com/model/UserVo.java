package com.model;

import com.paging.PagingVo;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class UserVo extends PagingVo{

	private Integer seq;
	private String user_sabun;
	private String user_id;
	private String pass_wd;
	private String user_name;
	private String ins_date;
	private String upd_date;
	private String rank;
	private String gubun;
	private String email;
	private String tel;

	private String discharge_dt;
	private Long org_seq; 
	private String org_nm; 
	private String P_org_nm; 

	// search ====
	private String txtSearch;
	private String selectOrgName;
	private String keyWord;
	private String date_fr;
	private String date_to;
	
	//사지방 관리자
	private String manager_yn;
	private String position;

	private int ListInfoCurrentPage;


}