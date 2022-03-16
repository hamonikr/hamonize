package com.model;

import java.sql.Timestamp;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.IdClass;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.persistence.UniqueConstraint;
import javax.validation.constraints.Size;

import com.id.UserId;
import com.paging.PagingVo;

import org.hibernate.annotations.Comment;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@Entity
@IdClass(UserId.class)
@Table(name="tbl_user",uniqueConstraints={
	@UniqueConstraint( columnNames={"user_id"})
			})
public class UserVo extends PagingVo{

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	@Comment("USER시리얼넘버")
	private Long seq;

	@Id
	@Size(max=50)
	@Comment("")
	private String domain;

	@Size(max=100)
	@Column(nullable = false)
	@Comment("아이디")
	private String user_id;

	@Size(max=300)
	@Comment("비밀번호")
	private String pass_wd;

	@Size(max=100)
	@Comment("이름")
	private String user_name;

	@Comment("등록일")
	private Timestamp rgstr_date;
	
	@Comment("수정일")
	private Timestamp updt_date;

	private Long org_seq;

	@Transient
	private String org_nm;
	@Transient
	private String P_org_nm; 

	// search ====
	@Transient
	private String txtSearch;
	@Transient
	private String selectOrgName;
	@Transient
	private String keyWord;
	@Transient
	private String date_fr;
	@Transient
	private String date_to;
	
	@Transient
	private int ListInfoCurrentPage;


}