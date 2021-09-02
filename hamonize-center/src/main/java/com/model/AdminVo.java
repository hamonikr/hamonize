package com.model;

import com.paging.PagingVo;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class AdminVo extends PagingVo {
	// 센터 관리자
	private String user_id;
	private String pass_wd;
	private String user_name;
	private String dept_name;
	private String gubun;
	private String insert_dt;
	private String update_dt;
	private String salt;

	private int adminListInfoCurrentPage;



	// 사지방 관리자
	private String arr_org_seq;
	private String rank;
	private String tel_num;
	private String phone_num;
	private String manager_yn;
	private int ListInfoCurrentPage;
	private int[] org_seq;
	private String org_nm;

	// 검색
	private String keyWord;
	private String txtSearch;


}
