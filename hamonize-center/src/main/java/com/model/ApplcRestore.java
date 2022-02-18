package com.model;

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
@Table(name="tbl_restore_applc")
public class ApplcRestore {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Comment("시리얼넘버")
	private Long seq;

	@Size(max=50)
	private String domain;

	@Comment("pc번호")
	private Long pc_seq;
	
	@Comment("조직번호")
	private Long org_seq;
	
	@Comment("Ansible JobId")
	private Long job_id;
	
	@Comment("백업이미지번호")
	private Long br_seq;

}
