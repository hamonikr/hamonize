package com.model;

import java.sql.Timestamp;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.validation.constraints.Size;

import org.hibernate.annotations.Comment;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@Entity
@Table(name="tbl_act_progrm_log")
public class ActAgentLogProgrmVo {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Comment("시리얼넘버")
	private Long seq;

	@Comment("부서번호")
	private Long org_seq;
	
	@Size(max=100)
	private String datetime;
	
	@Size(max=100)
	@Comment("PC고유번호")
	private String pc_uuid;
	
	@Size(max=100)
	@Comment("PC호스트명")
	private String pc_hostname;
	
	@Size(max=10)
	@Comment("정책적용여부")
	private String kind;
	
	@Size(max=10)
	@Comment("정책적용성공여부")
	private String status;
	
	@Size(max=200)
	@Comment("프로그램명")
	private String progrmname;

	@Comment("등록일")
	private Timestamp rgstr_date;
	
	@Comment("수정일")
	private Timestamp updt_date;

}