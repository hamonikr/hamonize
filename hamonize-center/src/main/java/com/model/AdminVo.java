package com.model;

import java.sql.Timestamp;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.validation.constraints.Size;

import com.paging.PagingVo;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@Entity
@Table(name="tbl_admin_user")
public class AdminVo extends PagingVo {
	// 센터 관리자
	@Size(max=50)
	private String domain;
	@Id
	@Size(max=50)
	private String user_id;
	@Size(max=300)
	private String pass_wd;
	@Transient
	private String current_pass_wd;
	@Size(max=50)
	private String user_name;
	@Size(max=50)
	private String dept_name;
	private String status;
	private Timestamp rgstr_date;
	private Timestamp updt_date;
	private String salt;
	@Column(columnDefinition = "integer default 0")
	private int login_check;

	@Transient
	private int adminListInfoCurrentPage;

	// 검색
	@Transient
	private String keyWord;
	@Transient
	private String txtSearch;


}
