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
@Table(name="tbl_device_applc_history")
public class ApplcDeviceHistory {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Comment("시리얼넘버")
	private Long seq;

	@Size(max=50)
	private String domain;

	private Long org_seq;
	
	@Size(max=150)
	private String ppm_seq;

	private Integer dvc_seq;

	private Timestamp rgstr_date;
	
	private Timestamp updt_date;

}
