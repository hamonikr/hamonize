package com.model;

import java.sql.Time;
import java.sql.Timestamp;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@Entity
@Table(name="tbl_admin_login_history")
public class AdminHistoryVo {
	// 센터 관리자
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long seq;
	@Size(max=50)
	@Column(nullable = false)
	private String domain;
	@Size(max=50)
	@NotNull
	private String user_id;
	@Size(max=50)
	private String user_ip;
	private Timestamp login_date;
	private Timestamp logout_date;
	private Time time_spent;

}
