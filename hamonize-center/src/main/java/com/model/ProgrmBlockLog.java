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
@Table(name="tbl_progrm_block_log")
public class ProgrmBlockLog {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Comment("시리얼넘버")
	private Long seq;

	@Comment("부서번호")
	private Long org_seq;
	
	@Size(max=100)
	@Comment("프로그램명")
	private String progrm_name;

	@Size(max=30)
	@Comment("PC아이피")
	private String pc_ip;
	
	@Size(max=100)
	@Comment("PC고유번호")
	private String pc_uuid;
	
	@Size(max=100)
	@Comment("PC호스트명")
	private String pc_hostname;

	@Comment("등록일")
	private Timestamp rgstr_date;
	
	@Comment("수정일")
	private Timestamp updt_date;

}