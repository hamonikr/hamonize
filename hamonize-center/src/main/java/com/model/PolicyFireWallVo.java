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
@Table(name="tbl_policy_firewall_list")
public class PolicyFireWallVo {

	//정책확정Insert
	@Transient
	private Integer seq;
	@Transient
	private Integer org_seq;
	@Transient
	private String ppm_seq;
	
	//프로그램관리list
	@Size(max=50)
	@Comment("테넌트")
	private String domain;
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Comment("시리얼 번호")
	private Long sm_seq;
	
	@Size(max=300)
	@Comment("방화벽병")
	private String sm_name;
	
	@Size(max=10)
	@Comment("방화벽 상태")
	private String sm_status;
	
	@Size(max=500)
	@Comment("방화벽 설명")
	private String sm_dc;
	
	@Size(max=20)
	@Comment("포트")
	private String sm_port;
	
	@Transient
	private int mngeListInfoCurrentPage;
	@Transient
	private String[] deleteList;

	@Comment("등록일")
	private Timestamp rgstr_date;
	@Comment("수정일")
	private Timestamp updt_date;
	
}
