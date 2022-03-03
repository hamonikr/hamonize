package com.model;

import java.sql.Timestamp;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

import org.hibernate.annotations.Comment;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@Entity
@Table(name="tbl_act_firewall_log")
public class ActAgentLogFirewallVo {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Comment("시리얼넘버")
	private Long seq;

	@Comment("부서번호")
	@Column(nullable = false)
	private Long org_seq;
	
	@Size(max=100)
	private String datetime;
	
	@Size(max=100)
	@Comment("PC고유번호")
	@Column(nullable = false)
	private String pc_uuid;
	
	@Size(max=100)
	@Comment("PC호스트명")
	@Column(nullable = false)
	private String pc_hostname;
	
	@Size(max=10)
	@Comment("정책적용여부")
	private String kind;
	
	@Size(max=10)
	@Comment("정책적용성공여부")
	private String status;
	
	@Size(max=100)
	@Comment("port")
	@NotNull
	private String retport;

	@Comment("등록일")
	private Timestamp rgstr_date;
	
	@Comment("수정일")
	private Timestamp updt_date;

}