package com.model;

import java.sql.Timestamp;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.persistence.UniqueConstraint;
import javax.validation.constraints.Size;

import org.hibernate.annotations.Comment;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@Entity
@Table(name="tbl_tenant_config",uniqueConstraints={
	@UniqueConstraint( columnNames={"domain"})
	})
public class TenantconfigVo {
	

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Comment("시리얼번호")
	private Long seq;

	@Size(max=50)
	@Comment("테넌트")
	@Column(nullable = false)
	private String domain;

	@Comment("")
	private Long tenant_file_seq;

	@Column(columnDefinition="TEXT")
	@Comment("")
	private String tenant_hadmin_config;

	@Column(columnDefinition="TEXT")
	@Comment("")
	private String tenant_hadmin_public_key;

	@Column(columnDefinition="TEXT")
	@Comment("")
	private String tenant_hadmin_private_key;

	private Integer tenant_polling_time;

	private String tenant_authkey;
	
	@Size(max=4)
	private String tenant_vpn_used;

	private Timestamp rgstr_date;
	private Timestamp updt_date;
	
	@Transient
	private String uuid;
	
}