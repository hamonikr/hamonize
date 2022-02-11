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
@Table(name="tbl_device_applc")
public class ApplcDevice {

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	@Comment("시리얼넘버")
	private Long seq;

	@Size(max=50)
	private String domain;

	private Integer org_seq;
	@Size(max=500)
	private String ppm_seq;

}
