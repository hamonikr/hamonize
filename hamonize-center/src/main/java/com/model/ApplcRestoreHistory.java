package com.model;

import java.sql.Timestamp;

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
@Table(name="tbl_restore_applc_history")
public class ApplcRestoreHistory {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Comment("시리얼넘버")
	private Long seq;

	@Size(max=50)
	private String domain;

	@Comment("조직번호")
	private Long org_seq;

	@Comment("복원번호")
	private Long recv_applc_seq;

	@Comment("pc번호")
	private Long pc_seq;

	@Comment("백업이미지번호")
	private Long br_seq;

	@Comment("복원일")
	private Timestamp rgstr_date;
	
	@Comment("수정일")
	private Timestamp updt_date;
	
	@Comment("Ansible JobId")
	private Long job_id;

}
