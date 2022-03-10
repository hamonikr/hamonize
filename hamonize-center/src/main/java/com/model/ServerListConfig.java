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
@Table(name="tbl_svrlst")
public class ServerListConfig {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Comment("시리얼넘버")
	private Long seq;

	@Size(max=50)
	private String svr_domain;
	
	@Size(max=200)
	private String svr_nm;

	@Size(max=30)
	private String svr_ip;

	@Size(max=300)
	private String svr_dc;

	@Size(max=20)
	private String svr_port;

	@Size(max=30)
	private String svr_vip;

	private Timestamp rgstr_date;
}
