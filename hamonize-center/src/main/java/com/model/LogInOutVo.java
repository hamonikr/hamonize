package com.model;

import java.sql.Timestamp;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.validation.constraints.Size;

import org.hibernate.annotations.Comment;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@Entity
@Table(name="tbl_loginout")
public class LogInOutVo {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Comment("조직 시리얼넘버")
	private Long seq;

	@Size(max=50)
	@Comment("")
	private String domain;
	
	@Size(max=100)
	@Comment("")
	private String pc_uuid;

	private Timestamp login_dt;
	private Timestamp logout_dt;

	@Transient
	private String kind;
	@Transient
	private Long org_seq;
	@Transient
	private Long job_id;

	//// json
	@Transient
	String datetime;
	@Transient
	String gubun;

}